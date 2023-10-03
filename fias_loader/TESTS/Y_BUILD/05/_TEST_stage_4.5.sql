SELECT hh.* FROM gar_tmp.xxx_adr_house hh -- 6494
   INNER JOIN gar_tmp.xxx_obj_fias xx ON (hh.fias_guid = xx.obj_guid) 
WHERE ((xx.type_object = 2) AND (xx.id_obj IS NULL)) ;

SELECT hh.* FROM gar_tmp.xxx_adr_house hh -- 111 !!!  и ДОЛЖНЫ ОБНОВЛЯТЬСЯ
   INNER JOIN gar_tmp.xxx_obj_fias xx ON (hh.fias_guid = xx.obj_guid) 
   INNER JOIN public.fias_not_found_06u n ON (hh.fias_guid = n.guid)    
WHERE ((xx.type_object = 2) AND (xx.id_obj IS NULL)) ;

        SELECT 
                h.id_house
              , h.id_addr_parent
              , h.fias_guid         AS nm_fias_guid
              , h.parent_fias_guid  AS nm_fias_guid_parent
        
              , (SELECT (id_area is not null)  from gar_tmp_pcg_trans.f_adr_street_get ('unnsi', h.parent_fias_guid)) as P1
              , (SELECT (id_area is not null)  from gar_tmp_pcg_trans.f_adr_AREA_get ('unnsi', h.parent_fias_guid)) as P1			  

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
                  (((h.fias_guid = ANY (NULL)) AND 
	               (NULL IS NOT NULL)) OR (NULL IS NULL)
	              )                     
