insert into clientdb.cdb_ls (id_ls, id_dict_facility, id_client, dt_en, nm_ls, 
                                 id_ls_role, dt_create)
SELECT * 
  FROM dblink ('ccrm',
               format($$select id_ls,
                               id_dict_facility,
                               id_client,
                               dt_en,
                               nm_ls,
                               id_ls_role,
                               dt_create 
                          from clientdb.cdb_ls
                        where (dt_change >= %1L
                          and  dt_change < %2L)
                           or (dt_create >= %3L
                          and  dt_create < %4L)$$, p_dt_start, p_dt_end, p_dt_start, p_dt_end)) 
  AS cdb_ls (id_ls bigint,
                 id_dict_facility int4,
                 id_client bigint,
                 dt_en timestamp,
                 nm_ls text,
                 id_ls_role int4,
                 dt_create timestamp)
where id_client not in (select unnest(vl_param) id_client from dict.dct_spec_params where kd_param = 1)                     
on conflict (id_ls) do
update set dt_en = excluded.dt_en,
           id_ls_role = excluded.id_ls_role
where cdb_ls.dt_en <> excluded.dt_en
   or cdb_ls.dt_en is distinct from excluded.dt_en
   or cdb_ls.id_ls_role <> excluded.id_ls_role
   or cdb_ls.id_ls_role is distinct from excluded.id_ls_role;
