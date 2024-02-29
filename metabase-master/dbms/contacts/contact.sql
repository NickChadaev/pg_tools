CREATE OR REPLACE FUNCTION contacts.contact (
  p_dt_start timestamp,
  p_dt_end timestamp
)
RETURNS void AS
$body$
BEGIN
   
insert into contacts.cm_contact (id_contact, dt_beg, dt_end, id_contact_method, kd_tp_contact,
                                 id_usr_create, id_reg, kd_system, id_entity, id_jur_contact,
                                 kd_entity, "data", kd_status)
SELECT * 
  FROM dblink ('ccrm',
               format($$select id_contact,
                               dt_beg,
                               dt_end,
                               id_contact_method,
                               kd_tp_contact,
                               id_usr_create,
                               id_reg,
                               kd_system,
                               id_entity,
                               id_jur_contact,
                               kd_entity,
                               "data",
                               kd_status
                          from contacts.cm_contact
                        where (dt_change >= %1L
                          and  dt_change < %2L)
                           or (dt_beg >= %3L
                          and  dt_beg < %4L)$$, p_dt_start, p_dt_end, p_dt_start, p_dt_end)) 
  AS cm_contact (id_contact bigint,
                 dt_beg timestamp,
                 dt_end timestamp,
                 id_contact_method int4,
                 kd_tp_contact int4,
                 id_usr_create bigint,
                 id_reg int8,
                 kd_system int4,
                 id_entity bigint,
                 id_jur_contact bigint,
                 kd_entity int8,
                 "data" jsonb,
                 kd_status int4)
where id_usr_create not in (select unnest(vl_param) id_user from dict.dct_spec_params where kd_param = 2)
  and case
        when id_entity is not null
          then id_entity not in (select unnest(vl_param) id_client from dict.dct_spec_params where kd_param = 1)
        else true
      end        
on conflict (id_contact) do
update set data = excluded.data
where cm_contact.dt_end is distinct from excluded.dt_end
   or cm_contact.id_entity is distinct from excluded.id_entity
   or cm_contact.id_jur_contact is distinct from excluded.id_jur_contact
   or cm_contact.kd_entity is distinct from excluded.kd_entity
   or cm_contact.data is distinct from excluded.data
   or cm_contact.kd_status <> excluded.kd_status
   or cm_contact.id_reg is distinct from excluded.id_reg;

--Отдельно добавляем атрибуты сообщений ЛК, чтобы загрзука отрабатывала быстрее
with upd_attr_lk
  as (SELECT id_contact,
             coalesce(jsonb_build_object('KD_SOFTWARE',
                                         case
                                           when nm_device like 'mozilla/5.0%%' then 1 --Браузер
                                           when nm_device is null then 3 --Не найдено
                                           else 2 --В остальных случаях это приложение
                                         end,
                                         'KD_DEVICE',
                                         case
                                           when nm_device like '%windows nt%' or nm_device like '%macintosh%' then 2 --ПК
                                           when nm_device like '%android%'
                                             or nm_device like '%iphone%'
                                             or nm_device like '%ipad%'
                                             or (nm_device is not null and nm_device not like 'mozilla/5.0%%' )then 1 --Телефон
                                           else 3 --Не найдено
                                         end), '{}'::jsonb) vl_data
        FROM dblink ('ccrm',
                     format($$select cc.id_contact,
                                     split_part(substring(cm.nm_message from 'Приложение:</b> (.*)'), '<br', 1) nm_app,
                                     lower(split_part(substring(cm.nm_message from 'Устройство:</b> (.*)'), '<br', 1)) nm_device,
                                     split_part(substring(cm.nm_message from 'Версия ОС:</b> (.*)'), '<br', 1) nm_ver_os
                                from contacts.cm_contact cc
                              join contacts.cm_contact_service ccs --Берем только первое обращение процесса
                                on cc.id_contact = ccs.id_contact
                              join contacts.cm_message_service cms --Берем только первое сообщение по обращению
                                on ccs.id_service = cms.id_service
                               and cms.id_message = (select min(id_message)
                                                       from contacts.cm_message_service
                                                     where id_service = cms.id_service)
                              join contacts.cm_message cm
                                on cms.id_message = cm.id_message
                               and cm.kd_tp_contact = 1
                              where cc.kd_system = 104
                                and cc.id_contact_method = 3
                                and cm.dt_message >= %1L
                                and cm.dt_message < %2L$$, p_dt_start, p_dt_end)) 
        AS cm_contact (id_contact bigint,
                       nm_app text,
                       nm_device text,
                       nm_ver_os text))
update contacts.cm_contact cc
   set data = coalesce(data, '{}'::jsonb) || ual.vl_data
from upd_attr_lk ual
where cc.id_contact = ual.id_contact;
   
insert into contacts.cm_contact_status_hist (id_contact, dt_change, kd_status, id_usr)
SELECT * 
  FROM dblink ('ccrm',
               format($$select sh.id_sys_entity id_contact, 
                               sh.dt_change, 
       					       sh.kd_status, 
       					       sh.id_usr 
  				          from contacts.cm_status_hist sh
				        where sh.kd_sys_entity = 5
  				          and sh.dt_change >= %1L
                          and sh.dt_change < %2L$$, p_dt_start, p_dt_end)) 
  AS cm_contact_status_hist (id_contact bigint, 
                             dt_change timestamp, 
       					     kd_status int4, 
       					     id_usr integer)
where exists (select from contacts.cm_contact
              where id_contact = cm_contact_status_hist.id_contact)                 
on conflict (id_contact, dt_change) do nothing;
  
END;
$body$
LANGUAGE 'plpgsql'
VOLATILE
CALLED ON NULL INPUT
SECURITY INVOKER
PARALLEL UNSAFE
COST 100;