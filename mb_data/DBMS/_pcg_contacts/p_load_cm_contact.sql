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
