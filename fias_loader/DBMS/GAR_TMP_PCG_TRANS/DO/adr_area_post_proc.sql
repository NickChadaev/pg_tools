 --
 -- 5) Что осталось ??
 --
BEGIN;
 WITH z0 AS (
              DELETE FROM gar_tmp.adr_area a WHERE (a.id_area_type > 1000)
              RETURNING a.*
 )             
   INSERT INTO gar_tmp.xxx_adr_area_gap (
                 id_area              -- bigint,
                ,nm_area              -- character varying(250),
                ,nm_area_full         -- character varying(250),
                ,id_area_type         -- bigint,
                ,nm_area_type         -- character varying(50),
                ,id_area_parent       -- bigint,
                ,nm_fias_guid_parent  -- uuid,
                ,kd_oktmo             -- text,
                ,nm_fias_guid         -- uuid,
                ,kd_okato             -- text,
                ,nm_zipcode           -- text,
                ,kd_kladr             -- text,
                ,tree_d               -- bigint[],
                ,level_d              -- integer,
                ,obj_level            -- bigint,
                ,level_name           -- character varying(100),
                ,oper_type_id         -- bigint,
                ,oper_type_name       -- character varying(100),
                ,curr_date            -- date,
                ,check_kind           -- character(1) 
 )
 
   SELECT 
       z0.id_area                          
      ,z0.nm_area     
      ,z0.nm_area_full                        
      ,z0.id_area_type
      ,NULL AS nm_area_type
      ,z0.id_area_parent
      ,NULL AS nm_fias_guid_parent
      ,z0.kd_oktmo
      ,z0.nm_fias_guid
      ,z0.kd_okato
      ,z0.nm_zipcode
      ,z0.kd_kladr
       --
      ,NULL AS tree_d           -- bigint[],
      ,NULL AS level_d          -- integer,
      ,NULL AS obj_level        -- bigint,
      ,NULL AS level_name       -- character varying(100),
      ,NULL AS oper_type_id     -- bigint,
      ,NULL AS oper_type_name   -- character varying(100),
      ,current_date
      ,'1'

      FROM z0 

      ON CONFLICT (nm_fias_guid) DO UPDATE
          SET
                 id_area              = excluded.id_area            
                ,nm_area              = excluded.nm_area            
                ,nm_area_full         = excluded.nm_area_full       
                ,id_area_type         = excluded.id_area_type       
                ,nm_area_type         = excluded.nm_area_type       
                ,id_area_parent       = excluded.id_area_parent     
                ,nm_fias_guid_parent  = excluded.nm_fias_guid_parent
                ,kd_oktmo             = excluded.kd_oktmo           
                ,kd_okato             = excluded.kd_okato           
                ,nm_zipcode           = excluded.nm_zipcode         
                ,kd_kladr             = excluded.kd_kladr           
                ,tree_d               = excluded.tree_d             
                ,level_d              = excluded.level_d            
                ,obj_level            = excluded.obj_level          
                ,level_name           = excluded.level_name         
                ,oper_type_id         = excluded.oper_type_id       
                ,oper_type_name       = excluded.oper_type_name     
                ,curr_date            = excluded.curr_date          
                ,check_kind           = excluded.check_kind         
          
            WHERE (gar_tmp.xxx_adr_area_gap.nm_fias_guid =  excluded.nm_fias_guid);

   SELECT * FROM gar_tmp.xxx_adr_area_gap;
-- ROLLBACK;
COMMIT;
