DROP PROCEDURE IF EXISTS pcg_clientdb.cdb_ls (timestamp, timestamp, bigint);
CREATE OR REPLACE PROCEDURE pcg_clientdb.cdb_ls (
        p_dt_start    timestamp
       ,p_dt_end      timestamp
       ,p_id_facility bigint    
)

  LANGUAGE plpgsql
  SECURITY INVOKER
AS  
$$
  -- ======================================================================= --
  --    2024-03-22  Вариант №1  селекция по датам и (p_id_facility bigint)   --
  -- ======================================================================= --
  DECLARE
  
    _exec  text = format ($_$ SELECT  id_ls 
                                   ,id_dict_facility 
                                   ,id_client 
                                   ,dt_en 
                                   ,nm_ls 
                                   ,id_ls_role 
                                   ,dt_create 
                              FROM clientdb.cdb_ls
                              
                            WHERE ((dt_change >= %1$L AND dt_change < %2$L)
                                     OR 
                                   (dt_create >= %1$L AND dt_create < %2$L)
                                  )
                                     AND
                                  (id_dict_facility =  %3$L)  
                         $_$, p_dt_start, p_dt_end, p_id_facility);
  
  
  BEGIN
    INSERT INTO clientdb.cdb_ls (id_ls
                               , id_dict_facility
                               , id_client
                               , dt_en
                               , nm_ls
                               , id_ls_role
                               , dt_create
    )
    SELECT cdb_ls.* FROM dblink ('ccrm', _exec) 
      AS cdb_ls (     id_ls            bigint 
                    , id_dict_facility int4 
                    , id_client        bigint 
                    , dt_en            timestamp 
                    , nm_ls            text 
                    , id_ls_role       int4 
                    , dt_create        timestamp
                )
    --Костыль   
     INNER JOIN clientdb.cdb_client cc ON (cc.id_client = cdb_ls.id_client)
                
    WHERE cdb_ls.id_client NOT IN (
                       SELECT unnest(vl_param) id_client FROM dict.dct_spec_params WHERE kd_param = 1
    )                     
    ON conflict (id_ls) DO
    UPDATE SET dt_en      = excluded.dt_en,
               id_ls_role = excluded.id_ls_role
               
    WHERE cdb_ls.dt_en      <> excluded.dt_en
       OR cdb_ls.dt_en      IS DISTINCT FROM excluded.dt_en
       OR cdb_ls.id_ls_role <> excluded.id_ls_role
       OR cdb_ls.id_ls_role IS DISTINCT FROM excluded.id_ls_role;
 END;
$$;

COMMENT ON PROCEDURE pcg_clientdb.cdb_ls (timestamp, timestamp, bigint) IS
'Загрузка данных по подключённым лицевым счетам';

-- USE CASE 
--            CALL pcg_clientdb.cdb_ls ('2023-01-14', '2024-03-14', 22);
--            SELECT * FROM clientdb.cdb_ls;
--            SELECT count(1) FROM clientdb.cdb_ls;   -- 33
--            DELETE FROM clientdb.cdb_ls;  --   

   
