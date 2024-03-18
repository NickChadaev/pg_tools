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
