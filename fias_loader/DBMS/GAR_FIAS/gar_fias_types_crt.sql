-- ---------------------------------------------
--  2022-08-29  Базовые типы. Дефектные записи.     
-- ---------------------------------------------
DO
  $$
   BEGIN
       CREATE TYPE gar_fias.gap_adr_area_t AS (
                    id_addr_obj      bigint  
                   ,id_addr_parent   bigint 
                   ,fias_guid        uuid 
                   ,parent_fias_guid uuid 
                   ,nm_addr_obj      varchar(250) 
                   ,addr_obj_type_id bigint
                   ,addr_obj_type    varchar(50) 
                   ,obj_level        bigint
                   ,level_name       varchar(100) 
                   --
                   ,region_code   varchar(4)   
                   ,area_code     varchar(4)   
                   ,city_code     varchar(4)   
                   ,place_code    varchar(4)   
                   ,plan_code     varchar(4)   
                   ,street_code   varchar(4)   
                   --
                   ,change_id    bigint
                   ,prev_id      bigint
                   --
                   ,oper_type_id     bigint
                   ,oper_type_name   varchar(100)
                    --                                     
                   ,start_date       date      
                   ,end_date         date      
                    --
                   ,id_lead          bigint    		   
                   ,tree_d           bigint[] 
                   ,level_d          integer           
       );
       
       COMMENT ON TYPE gar_fias.gap_adr_area_t IS 'G_Гео-регионы';

    EXCEPTION           
       WHEN OTHERS THEN 
           RAISE WARNING '%, %', SQLSTATE, SQLERRM;
   END;
  $$;
--
