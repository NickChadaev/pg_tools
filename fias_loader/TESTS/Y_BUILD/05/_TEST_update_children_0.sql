--
--  2023-10-26 Первый тест  для обновления двойников
--
-- EXPLAIN ANALYZE
     WITH z (  id_addr_obj
              ,id_addr_parent
              ,nm_addr_obj
              ,addr_obj_type_id
              ,date_create
              ,id_lead
         ) AS 
           (
             -- Выбираю записи, принадлежание обрабатываемой дате.
             SELECT  id_addr_obj
                    ,x.id_addr_parent
                    ,upper(x.nm_addr_obj)
                    ,x.addr_obj_type_id
                    ,x.date_create
                    ,x.id_lead
                   
                  FROM gar_fias.gap_adr_area x 
                    WHERE (x.date_create = current_date) 
              ORDER BY  x.nm_addr_obj, X.id_addr_obj DESC     
            )
            --select * from z;
            ---------------
              SELECT distinct on (a.fias_guid, b.fias_guid)
                     a.fias_guid AS fias_guid_new
                   , b.fias_guid AS fias_guid_old 
                   , Z.ID_LEAD
                   , z.id_addr_parent  
                   , z.nm_addr_obj 
                   , z.addr_obj_type_id              
                   , z.id_addr_obj AS id_addr_obj_new
                   , b.id_addr_obj AS id_addr_obj_old
              FROM z
                JOIN gar_fias.gap_adr_area a ON (z.id_lead = a.id_addr_obj) AND  (z.date_create = a.date_create)

                                               --  (z.id_addr_parent = a.id_addr_parent)  AND
                                              --  (z.nm_addr_obj = upper(a.nm_addr_obj)) AND
                                             --   (z.addr_obj_type_id = a.addr_obj_type_id) AND
                                             --   (z.id_lead = a.id_addr_obj) AND
                                           --   
                 --                                
                JOIN gar_fias.gap_adr_area b ON (z.id_lead <> b.id_addr_obj) AND (b.date_create = z.date_create) AND
                                                (z.id_lead = a.id_addr_obj)            AND
                                                (z.id_addr_parent = b.id_addr_parent)  AND
                                                (z.nm_addr_obj = upper(b.nm_addr_obj)) AND
                                                (z.addr_obj_type_id = b.addr_obj_type_id)                                               
                                                		  
;
