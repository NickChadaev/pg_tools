SELECT aa.* FROM gar_tmp.xxx_adr_area aa -- 298
   INNER JOIN gar_tmp.xxx_obj_fias xx ON (aa.fias_guid = xx.obj_guid) 
WHERE ((xx.type_object = 1) AND (xx.id_obj IS NULL))-- and (nm_addr_obj = 'Юннатов');

         SELECT 
                x.id_addr_obj AS id_street     
                --
               ,x.nm_addr_obj AS nm_street     
               ,x.nm_addr_obj AS nm_street_full
               --
               ,x.addr_obj_type_id AS id_street_type
               ,x.addr_obj_type    AS nm_street_type         
                --
			   -- ---------------------------------------
			   ,EXISTS (SELECT 1 FROM gar_tmp.xxx_adr_street_type 
                                 WHERE (x.addr_obj_type_id  = ANY (fias_ids))
                     ) AS type_exists
               -- ----------------------------------------                
                
               ,x.id_addr_parent   AS id_area     
               ,x.parent_fias_guid AS nm_fias_guid_area
               --
               ,(SELECT (id_AREA IS not NULL)
                  FROM gar_tmp_pcg_trans.f_adr_area_get ('unnsi', x.parent_fias_guid)               
               ) as PARENT_exists
               --
               ,x.fias_guid AS nm_fias_guid  
               ,(p.type_param_value -> '11'::text) AS kd_kladr    --  varchar(15) null,
                --
               ,x.tree_d                
               ,x.level_d               
                --
               ,x.obj_level       
               ,x.level_name      
               --
               ,x.oper_type_id    
               ,x.oper_type_name  
               
            FROM gar_tmp.xxx_adr_area x  
               INNER JOIN gar_tmp.xxx_obj_fias f ON (f.obj_guid = x.fias_guid) 
               LEFT OUTER JOIN gar_tmp.xxx_type_param_value p ON (x.id_addr_obj = p.object_id)
   
          WHERE (f.id_obj IS NULL) AND (f.type_object = 1) 
                    AND
                  (((x.fias_guid = ANY (NULL)) AND 
	               (NULL IS NOT NULL)) OR (NULL IS NULL)
	              )
          ORDER BY x.tree_d ;

SELECT * FROM gar_tmp_pcg_trans.f_adr_area_get ('unnsi'::text, '6a5b8826-dc74-4694-bbba-776daa464be1'::UUID);
SELECT * FROM gar_tmp_pcg_trans.f_adr_area_get ('gar_tmp'::text, 'e6b77740-76ec-4559-b6ec-aecdb910303e'::uuid); -- !!!!! НЕТ