DROP VIEW if EXISTS public.hh4;
CREATE OR REPLACE VIEW  public.hh4 AS
WITH aa (
             id_house       
            ,id_addr_parent 
            --
            ,fias_guid        
            ,parent_fias_guid 
            --   
            ,nm_parent_obj  
            ,region_code
            --
            ,parent_type_id
            ,parent_type_name
            ,parent_type_shortname
            --
            ,parent_level_id
            ,parent_level_name
            ,parent_short_name	        
            --
            ,house_num
            ,add_num1
            ,add_num2
            --
            ,house_type 
            ,house_type_name
            ,house_type_shortname
            --
            ,add_type1
            ,add_type1_name
            ,add_type1_shortname
            --
            ,add_type2
            ,add_type2_name     
            ,add_type2_shortname
            --
            ,change_id
            --
            ,oper_type_id
            ,oper_type_name     
            --
            ,user_id
            ,rn
            
 ) AS (
        SELECT
           h.object_id
          ,NULLIF (ia.parent_obj_id, 0)
          --
          ,h.object_guid
          ,y.object_guid
          --
          ,y.object_name     -- e.g.  parent_name
          ,ia.region_code
           --
          ,x.id
          ,x.type_name
          ,x.type_shortname
          --
          ,z.level_id
          ,z.level_name
          ,z.short_name
          --          
          ,h.house_num 
          ,h.add_num1
          ,h.add_num2
          --
          ,h.house_type
          ,t.type_name
          ,t.type_shortname
          --
          ,h.add_type1
          ,a1.type_name
          ,a1.type_shortname
          --
          ,h.add_type2
          ,a2.type_name
          ,a2.type_shortname
          --
          ,h.change_id
          --
          ,h.oper_type_id
          ,ot.oper_type_name
          --
          ,session_user
          --
          ,row_number() OVER (PARTITION BY ia.parent_obj_id, h.house_type, h.add_type1, h.add_type2
                                         , upper(h.house_num), upper(h.add_num1), upper(h.add_num2) 
                                         ORDER BY h.change_id DESC
                             ) AS rn
          
        FROM gar_fias.as_houses h
          INNER JOIN gar_fias.as_reestr_objects r ON ((r.object_id = h.object_id) AND (r.is_active))
          --
          INNER JOIN gar_fias.as_house_type t ON ((t.house_type_id = h.house_type) 
                                                 )
          --    Проверить      -- LEFT OUTER                             
          INNER JOIN gar_fias.as_adm_hierarchy ia ON ((ia.object_id = r.object_id) AND (ia.is_active) 
                                                     )
	      --  LEFT OUTER
          INNER JOIN gar_fias.as_addr_obj y ON (y.object_id = ia.parent_obj_id)  
                              AND ((y.is_actual AND y.is_active)
                              )
          LEFT OUTER  JOIN gar_fias.as_object_level z ON (z.level_id = y.obj_level) AND (z.is_active) 
                                                         
          LEFT OUTER JOIN gar_fias.as_addr_obj_type x ON (x.id = y.type_id) -- AND (x.is_active) -- 2022-12-29
          LEFT OUTER JOIN gar_fias.as_add_house_type a1 ON (a1.add_type_id = h.add_type1) 
          LEFT OUTER JOIN gar_fias.as_add_house_type a2 ON (a2.add_type_id = h.add_type2)  
          --
          LEFT OUTER JOIN gar_fias.as_operation_type ot ON (ot.oper_type_id = h.oper_type_id) AND (ot.is_active)
          
       WHERE ((h.is_actual AND h.is_active)
                ) 
 )
   SELECT 
             aa.id_house       
            ,aa.id_addr_parent 
            --
            ,aa.fias_guid        
            ,aa.parent_fias_guid 
            --   
            ,aa.nm_parent_obj  
            ,aa.region_code
            --
            ,aa.parent_type_id
            ,aa.parent_type_name
            ,aa.parent_type_shortname
            --
            ,aa.parent_level_id
            ,aa.parent_level_name
            ,aa.parent_short_name	        
            --
            ,aa.house_num
            ,aa.add_num1
            ,aa.add_num2
            --
            ,aa.house_type 
            ,aa.house_type_name
            ,aa.house_type_shortname
            --
            ,aa.add_type1
            ,aa.add_type1_name
            ,aa.add_type1_shortname
            --
            ,aa.add_type2
            ,aa.add_type2_name     
            ,aa.add_type2_shortname
            --
            ,aa.oper_type_id
            ,aa.oper_type_name     
            --
            ,aa.user_id
			,aa.change_id
			--,aa.rn
   
   FROM aa 
       WHERE (aa.rn = 1) -- 617502
        ORDER BY aa.rn DESC, aa.id_addr_parent, aa.house_num; 

--------------------------------------------------------
SELECT * FROM public.hh4  -- 617502
   except
SELECT * FROM public.hh5 ; -- 617502   


SELECT * FROM gar_tmp_pcg_trans.f_xxx_adr_house_show_data ()
   EXCEPT
SELECT * FROM gar_tmp_pcg_trans."_OLD_f_xxx_adr_house_show_data" (); 

SELECT * FROM gar_tmp_pcg_trans.f_xxx_adr_house_show_data () where (ID_HOUSE IN ( 36506749, 79571913))
   UNION ALL
SELECT * FROM gar_tmp_pcg_trans."_OLD_f_xxx_adr_house_show_data" ()  where (ID_HOUSE IN ( 36506749, 79571913));    
