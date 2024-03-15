
insert into contacts.cm_task_status_hist (id_task, dt_change, kd_status, id_usr)
SELECT * 
  FROM dblink ('ccrm',
               format($$select sh.id_sys_entity id_task, 
                               sh.dt_change, 
       					       sh.kd_status, 
       					       sh.id_usr 
  				          from contacts.cm_status_hist sh
				        where sh.kd_sys_entity = 6
  				          and sh.dt_change >= %1L
                          and sh.dt_change < %2L$$, p_dt_start, p_dt_end)) 
  AS cm_task_status_hist (id_task bigint, 
                          dt_change timestamp, 
       					  kd_status int4, 
       					  id_usr integer)
where exists (select from contacts.cm_task
              where id_task = cm_task_status_hist.id_task)              
on conflict (id_task, dt_change) do nothing;
  
END;
$body$
LANGUAGE 'plpgsql'
VOLATILE
CALLED ON NULL INPUT
SECURITY INVOKER
PARALLEL UNSAFE
COST 100;
