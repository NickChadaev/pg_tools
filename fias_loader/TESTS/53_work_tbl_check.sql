--
--  2023-09-26
--

SELECT  
--
 h.*
    
FROM public.fias_not_found_06u n

INNER JOIN gar_tmp.xxx_adr_house h ON (h.fias_guid = n.guid)

; -- 160

--
WITH z AS (
            SELECT  
               --
               h.nm_fias_guid AS guid
                
            FROM public.fias_not_found_06u n
            INNER JOIN gar_tmp.adr_house h ON (h.nm_fias_guid = n.guid)
          )
          
      , v AS ( SELECT m.guid
                 
               FROM public.fias_not_found_06u m
          
               EXCEPT
               
               SELECT z.guid
                 
               FROM z
             )  
		  
  -- SELECT * FROM z; -- 72   2023-09-27  -- 68
  -- SELECT * FROM v; -- 148 + 72 = 220    -- 2023-09-27 152
 
     SELECT h.* FROM v

     INNER JOIN gar_tmp.xxx_adr_house h ON (h.fias_guid = v.guid) -- 107  ( 148 - 107 = 41) (152 - 111 = 41)

    ORDER BY h.fias_guid;
    -- 2023-09-27 -- 111
--
-- ---------------------------------------  2023-09-28
--
WITH z AS (
            SELECT  
               --
               h.nm_fias_guid AS guid
                
            FROM public.fias_not_found_06u n
            INNER JOIN gar_tmp.adr_house h ON (h.nm_fias_guid = n.guid)
          )
          
      , v AS ( SELECT m.guid
                 
               FROM public.fias_not_found_06u m
          
               EXCEPT
               
               SELECT z.guid
                 
               FROM z
             )  
       , x AS ( SELECT
                     ah.* 
                    ,2 AS type_object
                    --
                    ,aa.id_addr_obj
		            ,aa.tree_d
		            ,aa.level_d
                
                FROM v
     
     
                INNER JOIN gar_tmp.xxx_adr_house ah ON (ah.fias_guid = v.guid) -- 107  ( 148 - 107 = 41)
                -- INNER JOIN gar_tmp.xxx_adr_area  aa ON (aa.id_addr_obj = ah.id_addr_parent) 
                -- LEFT JOIN gar_tmp.xxx_adr_area  aa ON (aa.id_addr_obj = ah.id_addr_parent) 
	            LEFT JOIN gar_tmp.xxx_adr_area  aa ON (aa.fias_guid = ah.parent_fias_guid) 
	 
                 -- (152 - 111 = 41)

                ORDER BY ah.fias_guid
    )
         SELECT 
                nh.id_house AS id_obj        
               ,x.*   

         FROM x
                LEFT JOIN LATERAL 
                     ( SELECT z.id_house, z.nm_fias_guid FROM ONLY gar_tmp.adr_house z
                          WHERE (z.id_data_etalon IS NULL) AND (z.dt_data_del IS NULL) 
                                   AND
                                (z.nm_fias_guid = x.fias_guid)
                       ORDER BY z.id_house
             
                     ) nh ON TRUE;                    
    
--
-- -----------------------------------------  2023-09-28
--
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
              , h.house_num                AS house_num
              --
              , h.add_num1                 AS add_num1            
              , h.add_num2                 AS add_num2            
              , h.house_type               AS house_type          
              , h.house_type_name          AS house_type_name     
              , h.house_type_shortname     AS house_type_shortname
              --
              , h.add_type1                AS add_type1          
              , h.add_type1_name           AS add_type1_name     
              , h.add_type1_shortname      AS add_type1_shortname
              , h.add_type2                AS add_type2          
              , h.add_type2_name           AS add_type2_name     
              , h.add_type2_shortname      AS add_type2_shortname
                --
               ,(p.type_param_value -> '5'::text)  AS nm_zipcode   
               ,(p.type_param_value -> '7'::text)  AS kd_oktmo
               ,(p.type_param_value -> '6'::text)  AS kd_okato    
              --
              , h.oper_type_id
              , h.oper_type_name
              
           FROM gar_tmp.xxx_adr_house h  
              
              INNER JOIN gar_tmp.xxx_obj_fias f ON (f.obj_guid = h.fias_guid) 
              LEFT OUTER JOIN gar_tmp.xxx_type_param_value p ON (h.id_house = p.object_id)              
              
            WHERE (f.id_obj IS NULL) AND (f.type_object = 2) 
                    AND
                  (h.fias_guid IN ( WITH z AS (
                                               SELECT  
                                                       --
                                                       h.nm_fias_guid AS guid
                                                        
                                                    FROM public.fias_not_found_06u n
                                                    INNER JOIN gar_tmp.adr_house h ON (h.nm_fias_guid = n.guid)
                                                  )
                                                  
                                              , v AS ( SELECT m.guid
                                                         
                                                       FROM public.fias_not_found_06u m
                                                  
                                                       EXCEPT
                                                       
                                                       SELECT z.guid
                                                         
                                                       FROM z
                                                     )
                                          SELECT v.guid FROM v           
                                    )
                  ) ;

---------------------------------------------------------------------------------------
SELECT gar_tmp_pcg_trans.f_adr_street_get ('gar_tmp'::TEXT, '4abbc6a2-c552-4d10-b7cc-f9f439affe88'::uuid);
   --  (,,,,,,,,,,) -- Отлично.
