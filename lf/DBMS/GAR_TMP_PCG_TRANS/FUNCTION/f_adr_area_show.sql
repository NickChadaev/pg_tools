DROP FUNCTION IF EXISTS gar_tmp_pcg_trans.f_adr_area_show (bigint);
CREATE OR REPLACE FUNCTION gar_tmp_pcg_trans.f_adr_area_show (
       p_id_area_parent    bigint 
)
    RETURNS TABLE (
      id_area             bigint                      
     ,id_country          integer                     
     ,nm_area             varchar(120)                
     ,nm_area_full        varchar(4000)               
     ,id_area_type        integer
     ,nm_area_type        varchar(50)    -- ++
      -- 
     ,id_area_parent      bigint              
     ,nm_area_parent      varchar(120)   -- ++
     ,nm_fias_guid_parent uuid           -- ++
     --
     ,kd_timezone         integer                     
     ,pr_detailed         smallint                    
     ,kd_oktmo            varchar(11)                 
     ,nm_fias_guid        uuid                        
     ,dt_data_del         timestamp without time zone 
     ,id_data_etalon      bigint                      
     ,kd_okato            varchar(11)                 
     ,nm_zipcode          varchar(20)                 
     ,kd_kladr            varchar(15)                 
     ,vl_addr_latitude    numeric                     
     ,vl_addr_longitude   numeric 
     ,tree_d              bigint[]
     ,level_d             integer
    )
    STABLE
    LANGUAGE sql
 AS
  $$
     WITH RECURSIVE aa1 (
                          id_area                            
                         ,id_country                         
                         ,nm_area                            
                         ,nm_area_full                       
                         ,id_area_type          
                         ,nm_area_type          -- ++
                          --                    
                         ,id_area_parent             
                         ,nm_area_parent        -- ++
                         ,nm_fias_guid_parent   -- ++
                         --                     
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
              ,at.nm_area_type AS nm_area_type          -- ++          
               -- 
              ,x.id_area_parent   
               --
              ,ap.nm_area  AS nm_area_parent            -- ++              
              ,ap.nm_fias_guid AS nm_fias_guid_parent   -- ++
              --
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
             
           FROM unsi.adr_area x 
           
              LEFT OUTER JOIN unsi.adr_area_type at ON (at.id_area_type = x.id_area_type)   -- 
              LEFT OUTER JOIN unsi.adr_area ap ON (ap.id_area = x.id_area_parent)  
              -- 
            WHERE (x.id_area = p_id_area_parent) AND (x.id_area_parent IS NULL)
		 
           UNION ALL
           
           SELECT 
               x.id_area           
              ,x.id_country        
              ,x.nm_area           
              ,x.nm_area_full      
              ,x.id_area_type 
              ,at.nm_area_type AS nm_area_type          -- ++          
               -- 
              ,x.id_area_parent   
               --
              ,ap.nm_area  AS nm_area_parent            -- ++              
              ,ap.nm_fias_guid AS nm_fias_guid_parent   -- ++
              --
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
             
           FROM unsi.adr_area x  
           
             LEFT OUTER JOIN unsi.adr_area_type at ON (at.id_area_type = x.id_area_type)
             LEFT OUTER JOIN unsi.adr_area  ap ON (ap.id_area = x.id_area_parent)
             
             INNER JOIN aa1 ON (aa1.id_area = x.id_area_parent ) AND (NOT aa1.cicle_d)
     )
      SELECT 
             aa1.id_area                            
            ,aa1.id_country                         
            ,aa1.nm_area                            
            ,aa1.nm_area_full                       
            ,aa1.id_area_type          
            ,aa1.nm_area_type          -- ++
             --                    
            ,aa1.id_area_parent             
            ,aa1.nm_area_parent        -- ++
            ,aa1.nm_fias_guid_parent   -- ++
            --                     
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
            --
            ,aa1.tree_d    
            ,aa1.level_d
      
      FROM aa1 ORDER BY aa1.tree_d;
   
  $$;
 
ALTER FUNCTION gar_tmp_pcg_trans.f_adr_area_show (bigint) OWNER TO postgres;  

COMMENT ON FUNCTION gar_tmp_pcg_trans.f_adr_area_show (bigint) 
IS 'Отображение упорядоченного списка адресный пространства ОТДАЛЁННЫЙ СЕРВЕР, ИЕРАРХИЯ".';
-- -----------------------------
-- USE CASE:
--    SELECT * FROM gar_tmp_pcg_trans.f_adr_area_show (2) WHERE (id_area >= 50000000 );
--   {2,94,50000001}   {2,94,2825,50000002}    {2,94,2813,50000009}  {2,94,2825,50000008}
--   DELETE FROM unsi.adr_area WHERE (id_area > 50000000);
