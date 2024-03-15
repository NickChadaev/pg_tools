
   
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
