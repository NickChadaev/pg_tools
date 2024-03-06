    insert into dict.dct_status (kd_status, nm_status, nm_description,
                                      kd_sys_entity, dt_change)
    SELECT * 
      FROM dblink ('ccrm',
                   $$select kd_status, 
                            nm_status, 
                            nm_description,
                            kd_sys_entity, 
                            dt_change
                       from dict.d_status$$) 
      AS dct_status (kd_status int4, 
                     nm_status text, 
                     nm_description text,
                     kd_sys_entity int4, 
                     dt_change timestamp)                      
    on conflict (kd_status) do
    update set nm_status = excluded.nm_status,
               nm_description = excluded.nm_description,
               dt_change = excluded.dt_change
    where dct_status.nm_status <> excluded.nm_status
       or dct_status.nm_description is distinct from excluded.nm_description
       or dct_status.dt_change <> excluded.dt_change;
