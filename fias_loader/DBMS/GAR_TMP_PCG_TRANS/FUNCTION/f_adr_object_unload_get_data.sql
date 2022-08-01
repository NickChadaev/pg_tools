DROP FUNCTION IF EXISTS gar_tmp_pcg_trans.f_adr_object_unload_data (text, bigint, text);
CREATE OR REPLACE FUNCTION gar_tmp_pcg_trans.f_adr_object_unload_data (
              p_schema_name   text       -- схема на отдалённом сервере
             ,p_id_region     bigint     -- Номер региона.
             ,p_conn          text       -- connection dblink
)

        RETURNS TABLE  (
                  id_object         bigint 
                 ,id_area           bigint 
                 ,id_house          bigint 
                 ,id_object_type    integer
                 ,id_street         bigint 
                 ,nm_object         varchar(250)
                 ,nm_object_full    varchar(500)
                 ,nm_description    varchar(150)
                 ,dt_data_del       timestamp without time zone 
                 ,id_data_etalon    bigint 
                 ,id_metro_station  integer
                 ,id_autoroad       integer
                 ,nn_autoroad_km    numeric
                 ,nm_fias_guid      uuid 
                 ,nm_zipcode        varchar(20)
                 ,kd_oktmo          varchar(11)
                 ,kd_okato          varchar(11)
                 ,vl_addr_latitude  numeric
                 ,vl_addr_longitude numeric
        )
        LANGUAGE plpgsql
        SECURITY DEFINER        
 AS $$
  -- -------------------------------------------------------------------------------------
  --  2021-12-31/2022-01-28  Загрузка регионального фрагмента из ОТДАЛЁННОГО справочника 
  --                         адресных объектов.
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
          
               SELECT 
                       r.id_object        
                      ,aa1.id_area          
                      ,r.id_house         
                      ,r.id_object_type   
                      ,r.id_street        
                      ,r.nm_object        
                      ,r.nm_object_full   
                      ,r.nm_description   
                      ,r.dt_data_del      
                      ,r.id_data_etalon   
                      ,r.id_metro_station 
                      ,r.id_autoroad      
                      ,r.nn_autoroad_km   
                      ,r.nm_fias_guid     
                      ,r.nm_zipcode       
                      ,r.kd_oktmo         
                      ,r.kd_okato         
                      ,r.vl_addr_latitude 
                      ,r.vl_addr_longitude 
                     
               FROM aa1 
                INNER JOIN %I.adr_objects r ON (r.id_area = aa1.id_area) 
                
                 WHERE (r.dt_data_del IS NULL) AND (r.id_data_etalon IS NULL) AND 
                       (r.id_house IS NOT NULL);
    $_$;
  
  BEGIN
    _exec := format (_select, p_schema_name, p_id_region, p_schema_name, p_schema_name);            
    --  RAISE NOTICE '%', _exec;  
	 
    RETURN QUERY
         SELECT x1.* FROM gar_link.dblink (p_conn, _exec) AS x1
          (
                  id_object         bigint 
                 ,id_area           bigint 
                 ,id_house          bigint 
                 ,id_object_type    integer
                 ,id_street         bigint 
                 ,nm_object         varchar(250)
                 ,nm_object_full    varchar(500)
                 ,nm_description    varchar(150)
                 ,dt_data_del       timestamp without time zone 
                 ,id_data_etalon    bigint 
                 ,id_metro_station  integer
                 ,id_autoroad       integer
                 ,nn_autoroad_km    numeric
                 ,nm_fias_guid      uuid 
                 ,nm_zipcode        varchar(20)
                 ,kd_oktmo          varchar(11)
                 ,kd_okato          varchar(11)
                 ,vl_addr_latitude  numeric
                 ,vl_addr_longitude numeric
           ); 
    END;             
$$;
COMMENT ON FUNCTION gar_tmp_pcg_trans.f_adr_object_unload_data (text, bigint, text) IS
'Загрузка регионального фрагмента из ОТДАЛЁННОГО справочника адресных объектов';
-- -----------------------------------------------------
-- USE CASE:
--      SELECT * FROM gar_tmp_pcg_trans.f_adr_object_unload_data ('unnsi'
-- 				, 52, (gar_link.f_conn_set ('c_unnsi_l', 'unnsi_nl'))
-- 	);
-- -------------------------------------------------------------------
-- Successfully run. Total query runtime: 6 secs 701 msec.
-- 6 secs 483 msec. 813177 rows affected.