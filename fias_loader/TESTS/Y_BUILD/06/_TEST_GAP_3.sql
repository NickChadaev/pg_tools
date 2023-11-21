SELECT a.*, p.* FROM unnsi.adr_area a 
    INNER JOIN unnsi.adr_area p ON (p.id_area = a.id_area_parent)
WHERE (a.nm_fias_guid = 'a35ffd78-10de-44ec-9db8-09923d14a4cd'); -- Есть

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
                       
                     FROM unnsi.adr_area x 
                     WHERE (x.id_area_parent IS NULL) AND (x.id_area = 9) 
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
                       
                     FROM unnsi.adr_area x  
                      
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
                     
               FROM aa1 WHERE (aa1.nm_fias_guid = 'a35ffd78-10de-44ec-9db8-09923d14a4cd');   
--  836 / 836
SELECT * FROM gar_tmp.adr_area WHERE (nm_fias_guid = 'a35ffd78-10de-44ec-9db8-09923d14a4cd');   
--
--  SELECT gar_link.f_server_is();
--  SELECT * FROM gar_link.foreign_servers;   1|'unnsi_prd_s'|'127.0.0.1'|'unnsi_prd_test'|5432|'c_unnsi_prd_s'|'unnsi'|t|'2022-12-29 19:52:26.894684'
BEGIN;
ROLLBACK;
CALL gar_tmp_pcg_trans.p_adr_area_unload ('unnsi', 9, (gar_link.f_conn_set (1)));  -- 836 !!!!
SELECT * FROM unnsi.adr_area WHERE (nm_fias_guid = 'a35ffd78-10de-44ec-9db8-09923d14a4cd');   -- 900005737|185|'Дорожный'|'Калмыкия Респ, Приютненский р-н, Песчаный п., Дорожный п.'|34|15661|2|0|'85628411101'|'a35ffd78-10de-44ec-9db8-09923d14a4cd'
SELECT * FROM gar_tmp.adr_area WHERE (nm_fias_guid = 'a35ffd78-10de-44ec-9db8-09923d14a4cd'); -- Есть !!!
SELECT * FROM gar_tmp.adr_area WHERE (nm_fias_guid = 'a35ffd78-10de-44ec-9db8-09923d14a4cd');  

SELECT * FROM gar_tmp.adr_area WHERE (nm_fias_guid = '36731b50-0051-4a08-82c1-bb88e97e5b6f');  
---------------------------------------------------------------------------------------------
          SELECT 
                h.id_house
              , h.id_addr_parent
              , h.fias_guid         AS nm_fias_guid
              , h.parent_fias_guid  AS nm_fias_guid_parent
              , h.nm_parent_obj
              , h.region_code
              --
              , h.parent_type_id
              , h.parent_type_name
              , h.parent_type_shortname
              , h.parent_level_id
              , h.parent_level_name
              , h.parent_short_name
              -- 
              , h.house_num             AS house_num
              --
              , h.add_num1              AS add_num1            
              , h.add_num2              AS add_num2            
              , h.house_type            AS house_type          
              , h.house_type_name       AS house_type_name     
              , h.house_type_shortname  AS house_type_shortname
              --
              , h.add_type1             AS add_type1          
              , h.add_type1_name        AS add_type1_name     
              , h.add_type1_shortname   AS add_type1_shortname
              , h.add_type2             AS add_type2          
              , h.add_type2_name        AS add_type2_name     
              , h.add_type2_shortname   AS add_type2_shortname
                --
               ,(p.type_param_value -> '5'::text) AS nm_zipcode   
               ,(p.type_param_value -> '7'::text) AS kd_oktmo
               ,(p.type_param_value -> '6'::text) AS kd_okato    
              --
              , h.oper_type_id
              , h.oper_type_name
              
           FROM gar_tmp.xxx_adr_house h   
              
              INNER JOIN gar_tmp.xxx_obj_fias f ON (f.obj_guid = h.fias_guid) 
              LEFT OUTER JOIN gar_tmp.xxx_type_param_value p ON (h.id_house = p.object_id)              
              
            WHERE (f.id_obj IS NOT NULL) AND (f.type_object = 2) AND
                  (h.parent_fias_guid = 'a35ffd78-10de-44ec-9db8-09923d14a4cd');
                   