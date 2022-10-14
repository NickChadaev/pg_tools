DROP FUNCTION IF EXISTS gar_tmp_pcg_trans.f_adr_area_unload_data (text, bigint, text);
CREATE OR REPLACE FUNCTION gar_tmp_pcg_trans.f_adr_area_unload_data (
              p_schema_name   text       -- схема на отдалённом сервере
             ,p_id_region     bigint     -- Номер региона.
             ,p_conn          text       -- connection dblink
)

        RETURNS TABLE  (
                             id_area           bigint       
                            ,id_country        integer      
                            ,nm_area           varchar(120) 
                            ,nm_area_full      varchar(4000)
                            ,id_area_type      integer      
                            ,id_area_parent    bigint       
                            ,kd_timezone       integer      
                            ,pr_detailed       smallint     
                            ,kd_oktmo          varchar(11)  
                            ,nm_fias_guid      uuid         
                            ,dt_data_del       timestamp without time zone 
                            ,id_data_etalon    bigint 
                            ,kd_okato          varchar(11) 
                            ,nm_zipcode        varchar(20) 
                            ,kd_kladr          varchar(15) 
                            ,vl_addr_latitude  numeric
                            ,vl_addr_longitude numeric
      )                   
        LANGUAGE plpgsql
        SECURITY DEFINER        
 AS $$
  -- -------------------------------------------------------------------------------------
  --  2022-09-08  Загрузка регионального фрагмента из ОТДАЛЁННОГО справочника 
  --                         георегионов.
  --  2022-10-14 Выгружаю всё, имеющее значимый uuid.
  -- -------------------------------------------------------------------------------------
  DECLARE
    _exec text;
    
    _select text = $_$
  
           WITH RECURSIVE aa1 (
                                 id_area           
                                ,id_country        
                                ,nm_area           
                                ,nm_area_full      
                                ,id_area_type      
                                ,id_area_parent    
                                ,kd_timezone       
                                ,pr_detailed       
                                ,kd_oktmo          
                                ,nm_fias_guid      
                                ,dt_data_del        
                                ,id_data_etalon    
                                ,kd_okato          
                                ,nm_zipcode        
                                ,kd_kladr          
                                ,vl_addr_latitude  
                                ,vl_addr_longitude 
                                 --
                                ,tree_d            
                                ,level_d
                                ,cicle_d                               
            
            ) AS (
                     SELECT 
                         x.id_area           
                        ,x.id_country        
                        ,x.nm_area           
                        ,x.nm_area_full      
                        ,x.id_area_type      
                        ,x.id_area_parent    
                        ,x.kd_timezone       
                        ,x.pr_detailed       
                        ,x.kd_oktmo          
                        ,x.nm_fias_guid      
                        ,x.dt_data_del        
                        ,x.id_data_etalon    
                        ,x.kd_okato          
                        ,x.nm_zipcode        
                        ,x.kd_kladr          
                        ,x.vl_addr_latitude  
                        ,x.vl_addr_longitude 
                         --
                        ,CAST (ARRAY [x.id_area] AS bigint []) 
                        ,1
                        ,FALSE
                       
                     FROM %I.adr_area x 
                     WHERE (x.id_area_parent IS NULL) AND (x.id_area = %L) 
                            AND (x.dt_data_del IS NULL) AND (x.id_data_etalon IS NULL)
                   
                     UNION ALL
                     
                     SELECT 
                         x.id_area           
                        ,x.id_country        
                        ,x.nm_area           
                        ,x.nm_area_full      
                        ,x.id_area_type      
                        ,x.id_area_parent    
                        ,x.kd_timezone       
                        ,x.pr_detailed       
                        ,x.kd_oktmo          
                        ,x.nm_fias_guid      
                        ,x.dt_data_del        
                        ,x.id_data_etalon    
                        ,x.kd_okato          
                        ,x.nm_zipcode        
                        ,x.kd_kladr          
                        ,x.vl_addr_latitude  
                        ,x.vl_addr_longitude 
                         --	       
                        ,CAST (aa1.tree_d || x.id_area AS bigint [])
                        ,(aa1.level_d + 1) t
                        ,x.id_area = ANY (aa1.tree_d)               
                       
                     FROM %I.adr_area x  
                      
                       INNER JOIN aa1 ON (aa1.id_area = x.id_area_parent ) AND (NOT aa1.cicle_d)
            )
               SELECT   aa1.id_area           
                       ,aa1.id_country        
                       ,aa1.nm_area           
                       ,aa1.nm_area_full      
                       ,aa1.id_area_type      
                       ,aa1.id_area_parent    
                       ,aa1.kd_timezone       
                       ,aa1.pr_detailed       
                       ,aa1.kd_oktmo          
                       ,aa1.nm_fias_guid      
                       ,aa1.dt_data_del       
                       ,aa1.id_data_etalon    
                       ,aa1.kd_okato          
                       ,aa1.nm_zipcode        
                       ,aa1.kd_kladr          
                       ,aa1.vl_addr_latitude  
                       ,aa1.vl_addr_longitude 
                     
               FROM aa1                    
               WHERE (aa1.nm_fias_guid IS NOT NULL);  
    $_$;
  
  BEGIN
    _exec := format (_select, p_schema_name, p_id_region, p_schema_name, p_schema_name);            
      
    RETURN QUERY
         SELECT x1.* FROM gar_link.dblink (p_conn, _exec) AS x1
          (
                 id_area           bigint       
                ,id_country        integer      
                ,nm_area           varchar(120) 
                ,nm_area_full      varchar(4000)
                ,id_area_type      integer      
                ,id_area_parent    bigint       
                ,kd_timezone       integer      
                ,pr_detailed       smallint     
                ,kd_oktmo          varchar(11)  
                ,nm_fias_guid      uuid         
                ,dt_data_del       timestamp without time zone 
                ,id_data_etalon    bigint 
                ,kd_okato          varchar(11) 
                ,nm_zipcode        varchar(20) 
                ,kd_kladr          varchar(15) 
                ,vl_addr_latitude  numeric
                ,vl_addr_longitude numeric
           ); 
    END;             
$$;
COMMENT ON FUNCTION gar_tmp_pcg_trans.f_adr_area_unload_data (text, bigint, text) IS
'Загрузка регионального фрагмента из ОТДАЛЁННОГО справочника георегинов';
-- -----------------------------------------------------
-- USE CASE:
--      SELECT * FROM gar_tmp_pcg_trans.f_adr_area_unload_data ('unnsi'
-- 				, 24, (gar_link.f_conn_set (11))
-- 	);
-- -------------------------------------------------------------------
-- Successfully run. Total query runtime: 5 secs 701 msec.
-- 891734 rows affected.
--     SELECT * FROM gar_link.v_servers_active;
