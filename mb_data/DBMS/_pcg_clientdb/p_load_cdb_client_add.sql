DROP PROCEDURE IF EXISTS pcg_clientdb.cdb_add (timestamp, timestamp, bigint);
CREATE OR REPLACE PROCEDURE pcg_clientdb.cdb_add (
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

  
  BEGIN
    INSERT INTO clientdb.cdb_client_additional (
                 id_client_additional
               , id_client
               , kd_entity
               , data
               , id_ls
    )
    SELECT cdb_client_additional.* 
      FROM dblink ('ccrm',
                   format ($_$ SELECT  id_client_additional
                                     ,id_client 
                                     ,kd_entity 
                                     ,data 
                                     ,id_ls
                                     
                               FROM clientdb.cdb_client_additional
                               WHERE (dt_change >= %1L AND dt_change < %2L)
                               $_$, p_dt_start, p_dt_end 
                    ) 
            )
      AS cdb_client_additional ( id_client_additional bigint 
                                ,id_client            bigint 
                                ,kd_entity            int4 
                                ,data                 jsonb 
                                ,id_ls                bigint
                               )
    --Костыль   
    INNER JOIN clientdb.cdb_client cc ON (cc.id_client = cdb_client_additional.id_client) 
    
    WHERE cdb_client_additional.id_client NOT IN (SELECT unnest(vl_param) id_client 
                                   FROM dict.dct_spec_params WHERE kd_param = 1
                           )                     
    
    ON conflict (id_client_additional) DO
        UPDATE SET DATA = excluded.data WHERE cdb_client_additional.data <> excluded.data;
    
 END;
$$;

COMMENT ON PROCEDURE pcg_clientdb.cdb_add (timestamp, timestamp, bigint) IS
'Загрузка адресов клиентов. Соответсвует метамодельной сущности 2100 "Дополнительная сущность клиента"';

-- USE CASE 
--            CALL pcg_clientdb.cdb_add ('2000-01-14', '2025-03-14', 22);
--            SELECT * FROM clientdb.cdb_client_additional;
--            SELECT count(1) FROM clientdb.cdb_client_additional;   -- 33
--            DELETE FROM clientdb.cdb_client_additional;  --   

   
