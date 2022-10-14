DROP FUNCTION IF EXISTS gar_tmp_pcg_trans.f_adr_house_unload_data (text, bigint, text);
CREATE OR REPLACE FUNCTION gar_tmp_pcg_trans.f_adr_house_unload_data (
              p_schema_name   text       -- схема на отдалённом сервере
             ,p_id_region     bigint     -- Номер региона.
             ,p_conn          text       -- connection dblink
)

        RETURNS TABLE  (
                          id_house          bigint
                         ,id_area           bigint
                         ,id_street         bigint 
                         ,id_house_type_1   integer 
                         ,nm_house_1        varchar(70)
                         ,id_house_type_2   integer 
                         ,nm_house_2        varchar(50)
                         ,id_house_type_3   integer 
                         ,nm_house_3        varchar(50) 
                         ,nm_zipcode        varchar(20) 
                         ,nm_house_full     varchar(250)
                         ,kd_oktmo          varchar(11) 
                         ,nm_fias_guid      uuid 
                         ,dt_data_del       timestamp without time zone 
                         ,id_data_etalon    bigint 
                         ,kd_okato          varchar(11)
                         ,vl_addr_latitude  numeric 
                         ,vl_addr_longitude numeric 
        )
        LANGUAGE plpgsql
        SECURITY DEFINER        
 AS $$
  -- -------------------------------------------------------------------------------------
  --  2021-12-31/2022-01-28  Загрузка регионального фрагмента из ОТДАЛЁННОГО справочника 
  --                         адресов домов.
  --  2022-10-14 Выгружаю всё, имеющее значимый uuid.
  -- -------------------------------------------------------------------------------------
  DECLARE
    _exec text;
    
    _select text = $_$
  
           WITH RECURSIVE aa1 (
                                 id_area_parent             
                                ,id_area 
                                 --
                                ,tree_d            
                                ,level_d
                                ,cicle_d                               
            
            ) AS (
                     SELECT 
                         x.id_area_parent   
                        ,x.id_area    
                         --
                        ,CAST (ARRAY [x.id_area] AS bigint []) 
                        ,1
                        ,FALSE
                       
                     FROM %I.adr_area x 
                   
                        WHERE(x.id_area_parent IS NULL) AND (x.id_area = %L) AND
           	              (x.dt_data_del IS NULL) AND (x.id_data_etalon IS NULL)
                   
                     UNION ALL
                     
                     SELECT 
                         x.id_area_parent   
                        ,x.id_area  
                       -- --	       
                        ,CAST (aa1.tree_d || x.id_area AS bigint [])
                        ,(aa1.level_d + 1) t
                        ,x.id_area = ANY (aa1.tree_d)               
                       
                     FROM %I.adr_area x  
                      
                       INNER JOIN aa1 ON (aa1.id_area = x.id_area_parent ) AND (NOT aa1.cicle_d)
                       
           	      WHERE (x.dt_data_del IS NULL) AND (x.id_data_etalon IS NULL)
            )
               SELECT  h.id_house            
                     , aa1.id_area                   
                     , h.id_street         
                     , h.id_house_type_1     
                     , h.nm_house_1         
                     , h.id_house_type_2    
                     , h.nm_house_2            
                     , h.id_house_type_3    
                     , h.nm_house_3          
                     , h.nm_zipcode          
                     , h.nm_house_full       
                     , h.kd_oktmo           
                     , h.nm_fias_guid       
                     , h.dt_data_del         
                     , h.id_data_etalon     
                     , h.kd_okato            
                     , h.vl_addr_latitude   
                     , h.vl_addr_longitude                
                     
               FROM aa1 
                   INNER JOIN %I.adr_house h ON (h.id_area = aa1.id_area)
              
               WHERE (h.nm_fias_guid IS NOT NULL); 
    $_$;
  
    -- (h.dt_data_del IS NULL) AND (h.id_data_etalon IS NULL) AND 
  
  BEGIN
    _exec := format (_select, p_schema_name, p_id_region, p_schema_name, p_schema_name);            
    -- RAISE NOTICE '%', _exec;  
      
    RETURN QUERY
         SELECT x1.* FROM gar_link.dblink (p_conn, _exec) AS x1
          (
                  id_house          bigint
                 ,id_area           bigint
                 ,id_street         bigint 
                 ,id_house_type_1   integer 
                 ,nm_house_1        varchar(70)
                 ,id_house_type_2   integer 
                 ,nm_house_2        varchar(50)
                 ,id_house_type_3   integer 
                 ,nm_house_3        varchar(50) 
                 ,nm_zipcode        varchar(20) 
                 ,nm_house_full     varchar(250)
                 ,kd_oktmo          varchar(11) 
                 ,nm_fias_guid      uuid 
                 ,dt_data_del       timestamp without time zone 
                 ,id_data_etalon    bigint 
                 ,kd_okato          varchar(11)
                 ,vl_addr_latitude  numeric 
                 ,vl_addr_longitude numeric 
           ); 
    END;             
$$;
COMMENT ON FUNCTION gar_tmp_pcg_trans.f_adr_house_unload_data (text, bigint, text) IS
'Загрузка регионального фрагмента из ОТДАЛЁННОГО справочника адресов домов';
-- -----------------------------------------------------
-- USE CASE:
--      SELECT * FROM gar_tmp_pcg_trans.f_adr_house_unload_data ('unnsi'
-- 				, 52, (gar_link.f_conn_set (4))
-- 	);
-- -------------------------------------------------------------------
-- Successfully run. Total query runtime: 5 secs 701 msec.
-- 891734 rows affected.
