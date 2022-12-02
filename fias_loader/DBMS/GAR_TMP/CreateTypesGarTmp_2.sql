-- ----------------------------------------------------------------
--  2022-12-02  Типы, описывающие структуры из процесса загрузки.     
-- ----------------------------------------------------------------
-- DROP TYPE IF EXISTS gar_tmp.xxx_adr_area_proc_t CASCADE;
DO
  $$
   BEGIN
       CREATE TYPE gar_tmp.xxx_adr_area_proc_t AS (
            id_area              bigint
           ,nm_area              varchar(250)
           ,nm_area_full         varchar(250)
           ,id_area_type         bigint
           ,nm_area_type         varchar(50)
           ,id_area_parent       bigint
           ,nm_fias_guid_parent  uuid 
           ,kd_oktmo             text
           ,nm_fias_guid         uuid 
           ,kd_okato             text
           ,nm_zipcode           text
           ,kd_kladr             text
           ,tree_d               bigint[] 
           ,level_d              integer 
           ,obj_level            bigint
           ,level_name           varchar(100)
           ,oper_type_id         bigint
           ,oper_type_name       varchar(100)
           ,curr_date            date
           ,check_kind           char(1)
       );
       COMMENT ON TYPE gar_tmp.xxx_adr_area_proc_t 
                 IS 'Используется в процессе обработки адресных регионов.';

    EXCEPTION           
       WHEN OTHERS THEN 
           RAISE WARNING '%, %', SQLSTATE, SQLERRM;
   END;
$$;
-- 
-- DROP TYPE IF EXISTS gar_tmp.xxx_adr_street_proc_t CASCADE;
DO
  $$
   BEGIN
       CREATE TYPE gar_tmp.xxx_adr_street_proc_t AS (
            id_street         bigint 
           ,nm_street         varchar(250) 
           ,nm_street_full    varchar(250) 
           ,id_street_type    bigint 
           ,nm_street_type    varchar(50) 
           ,id_area           bigint 
           ,nm_fias_guid_area uuid 
           ,nm_fias_guid      uuid 
           ,kd_kladr          text 
           ,tree_d            bigint[] 
           ,level_d           integer 
           ,obj_level         bigint 
           ,level_name        varchar(100) 
           ,oper_type_id      bigint 
           ,oper_type_name    varchar(100) 
           ,curr_date         date
           ,check_kind        char(1)           
       );
       COMMENT ON TYPE gar_tmp.xxx_adr_street_proc_t 
                 IS 'Используется в процессе обработки улиц';

    EXCEPTION           
       WHEN OTHERS THEN 
           RAISE WARNING '%, %', SQLSTATE, SQLERRM;
   END;
$$;
--
-- DROP TYPE IF EXISTS gar_tmp.xxx_adr_house_proc_t CASCADE;
DO
  $$
   BEGIN
       CREATE TYPE gar_tmp.xxx_adr_house_proc_t AS (
            id_house               bigint 
           ,id_addr_parent         bigint 
           ,nm_fias_guid           uuid 
           ,nm_fias_guid_parent    uuid 
           ,nm_parent_obj          varchar(250)
           ,region_code            varchar(4)
           ,parent_type_id         bigint 
           ,parent_type_name       varchar(250)
           ,parent_type_shortname  varchar(50)
           ,parent_level_id        bigint 
           ,parent_level_name      varchar(100)
           ,parent_short_name      varchar(50)
           ,house_num              varchar(50)
           ,add_num1               varchar(50)
           ,add_num2               varchar(50)
           ,house_type             bigint 
           ,house_type_name        varchar(50)
           ,house_type_shortname   varchar(20)
           ,add_type1              bigint 
           ,add_type1_name         varchar(100)
           ,add_type1_shortname    varchar(20)
           ,add_type2              bigint 
           ,add_type2_name         varchar(100)
           ,add_type2_shortname    varchar(20)
           ,nm_zipcode             text
           ,kd_oktmo               text
           ,kd_okato               text
           ,oper_type_id           bigint 
           ,oper_type_name         varchar(100) 
           ,curr_date              date
           ,check_kind             char(1)            
       );
       COMMENT ON TYPE gar_tmp.xxx_adr_house_proc_t 
                 IS 'Используется в процессе обработки домов';

    EXCEPTION           
       WHEN OTHERS THEN 
           RAISE WARNING '%, %', SQLSTATE, SQLERRM;
   END;
$$;
