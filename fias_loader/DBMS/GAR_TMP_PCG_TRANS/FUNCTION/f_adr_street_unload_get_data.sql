DROP FUNCTION IF EXISTS gar_tmp_pcg_trans.f_adr_street_unload_data (text, bigint, text);
CREATE OR REPLACE FUNCTION gar_tmp_pcg_trans.f_adr_street_unload_data (
              p_schema_name   text       -- схема на отдалённом сервере
             ,p_id_region     bigint     -- Номер региона.
             ,p_conn          text       -- connection dblink
)

        RETURNS TABLE  (
                           id_street         bigint       
                          ,id_area           bigint       
                          ,nm_street         varchar(120) 
                          ,id_street_type    integer      
                          ,nm_street_full    varchar(255) 
                          ,nm_fias_guid      uuid         
                          ,dt_data_del       timestamp without time zone 
                          ,id_data_etalon    bigint 
                          ,kd_kladr          varchar(15)  
                          ,vl_addr_latitude  numeric 
                          ,vl_addr_longitude numeric 
        )
        LANGUAGE plpgsql
        SECURITY DEFINER        
 AS $$
  -- -------------------------------------------------------------------------------------
  --  2022-09-28 Загрузка регионального фрагмента из ОТДАЛЁННОГО справочника адресов улиц.
  --  2022-10-14 Выгружаю всё, имеющее значимый uuid.
  --  2022-12-13 Отмена выгрузки значимого UUID.  
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
            )
               SELECT      
                s.id_street          
               ,aa1.id_area          
               ,s.nm_street          
               ,s.id_street_type     
               ,s.nm_street_full     
               ,s.nm_fias_guid       
               ,s.dt_data_del        
               ,s.id_data_etalon     
               ,s.kd_kladr           
               ,s.vl_addr_latitude   
               ,s.vl_addr_longitude  
                     
               FROM aa1 
                   INNER JOIN %I.adr_street s ON (s.id_area = aa1.id_area)
               ;    
               -- WHERE (s.nm_fias_guid IS NOT NULL);   --  2022-12-13
    $_$;
  
  BEGIN
    _exec := format (_select, p_schema_name, p_id_region, p_schema_name, p_schema_name);            
      
    RETURN QUERY
         SELECT x1.* FROM gar_link.dblink (p_conn, _exec) AS x1
          (
                id_street         bigint       
               ,id_area           bigint       
               ,nm_street         varchar(120) 
               ,id_street_type    integer      
               ,nm_street_full    varchar(255) 
               ,nm_fias_guid      uuid         
               ,dt_data_del       timestamp without time zone 
               ,id_data_etalon    bigint 
               ,kd_kladr          varchar(15)  
               ,vl_addr_latitude  numeric 
               ,vl_addr_longitude numeric 
           ); 
    END;             
$$;
COMMENT ON FUNCTION gar_tmp_pcg_trans.f_adr_street_unload_data (text, bigint, text) IS
'Загрузка регионального фрагмента из ОТДАЛЁННОГО справочника адресов улиц';
-- -----------------------------------------------------
-- USE CASE:
--      SELECT * FROM gar_tmp_pcg_trans.f_adr_street_unload_data ('unnsi'
-- 				, 24, (gar_link.f_conn_set (11))
-- 	);
-- -------------------------------------------------------------------
-- Successfully run. Total query runtime: 5 secs 701 msec.
-- 891734 rows affected.
