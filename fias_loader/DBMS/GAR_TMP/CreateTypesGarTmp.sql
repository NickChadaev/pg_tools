-- --------------------------------------
--  2022-01-11/2022-02-07  Базовые типы     
-- --------------------------------------
DO
  $$
   BEGIN
       CREATE TYPE gar_tmp.adr_objects_t AS ( 
            id_object          bigint
           ,id_area            bigint
           ,id_house           bigint
           ,id_object_type     integer
           ,id_street          bigint 
           ,nm_object          varchar(250)
           ,nm_object_full     varchar(500)
           ,nm_description     varchar(150)
           ,dt_data_del        timestamp without time zone
           ,id_data_etalon     bigint 
           ,id_metro_station   integer
           ,id_autoroad        integer
           ,nn_autoroad_km     numeric
           ,nm_fias_guid       uuid 
           ,nm_zipcode         varchar(20)
           ,kd_oktmo           varchar(11)
           ,kd_okato           varchar(11)
           ,vl_addr_latitude   numeric
           ,vl_addr_longitude  numeric
       );
       
       COMMENT ON TYPE gar_tmp.adr_objects IS 'С_Отдельные сооружения и территории (!)';

    EXCEPTION           
       WHEN OTHERS THEN 
           RAISE WARNING '%, %', SQLSTATE, SQLERRM;
   END;
  $$;
--
--  2022-02-07
--
DO
  $$
   BEGIN
       CREATE TYPE gar_tmp.adr_area_t AS (
            id_area            bigint 
           ,id_country         integer
           ,nm_area            varchar(120) 
           ,nm_area_full       varchar(4000)
           ,id_area_type       integer 
           ,id_area_parent     bigint 
           ,kd_timezone        integer 
           ,pr_detailed        smallint 
           ,kd_oktmo           varchar(11)  
           ,nm_fias_guid       uuid 
           ,dt_data_del        timestamp without time zone 
           ,id_data_etalon     bigint 
           ,kd_okato           varchar(11)
           ,nm_zipcode         varchar(20)
           ,kd_kladr           varchar(15)
           ,vl_addr_latitude   numeric
           ,vl_addr_longitude  numeric
       );
       
       COMMENT ON TYPE gar_tmp.adr_area_t IS 'С_Гео-регионы (!)';

    EXCEPTION           
       WHEN OTHERS THEN 
           RAISE WARNING '%, %', SQLSTATE, SQLERRM;
   END;
  $$;
--
DO
  $$
   BEGIN
       CREATE TYPE gar_tmp.adr_street_t AS (
           id_street         bigint                     
          ,id_area           bigint                     
          ,nm_street         varchar(120)               
          ,id_street_type    integer                   
          ,nm_street_full    varchar(255)               
          ,nm_fias_guid      uuid                       
          ,dt_data_del       timestamp without time zone
          ,id_data_etalon    bigint                     
          ,kd_kladr          varchar(15)                
          ,vl_addr_latitude  numeric                    
          ,vl_addr_longitude numeric                    
       );
       
       COMMENT ON TYPE gar_tmp.adr_street_t IS 'С_Улицы (!)';

    EXCEPTION           
       WHEN OTHERS THEN 
           RAISE WARNING '%, %', SQLSTATE, SQLERRM;
   END;
  $$;
--
DO
  $$
   BEGIN
     CREATE TYPE gar_tmp.adr_house_t AS (
          id_house          bigint                     
         ,id_area           bigint                     
         ,id_street         bigint                     
         ,id_house_type_1   integer                    
         ,nm_house_1        varchar(70)                
         ,id_house_type_2   integer                    
         ,nm_house_2        varchar(50)                
         ,id_house_type_3   integer                    
         ,nm_house_3        varchar(50)                
         ,nm_zipcode        varchar(20)                
         ,nm_house_full     varchar(250)               
         ,kd_oktmo          varchar(11)                
         ,nm_fias_guid      uuid                       
         ,dt_data_del       timestamp without time zone
         ,id_data_etalon    bigint                     
         ,kd_okato          varchar(11)                
         ,vl_addr_latitude  numeric                    
         ,vl_addr_longitude numeric                    
     );
     
     COMMENT ON TYPE gar_tmp.adr_house_t IS 'С_Адреса (!)';

    EXCEPTION           
       WHEN OTHERS THEN 
           RAISE WARNING '%, %', SQLSTATE, SQLERRM;
   END;
  $$;
-- ====================================================================================
--   2022-11-14 Промежуточные типы: 1) - дома, 2) - улицы, 3) - адресные пространства. 
-- ====================================================================================
DO
  $$
   BEGIN
     CREATE TYPE gar_tmp.zzz_adr_area_t AS (
   
       id_area_type       integer     -- ID типа, ОСНОВНОЙ	
      ,nm_area_type       varchar(50) -- Наименованиек типа, ОСНОВНОЕ
      ,nm_area_type_short varchar(10) -- Краткое наименованиек типа, ОСНОВНОЕ
      ,pr_lead            smallint    -- Признак
      ,dt_data_del	      timestamp without time zone -- Дата удаления ОСНОВНАЯ
       ----
      ,fias_ids               bigint[]    -- Исходные идентификаторы ГАР-ФИАС 
      ,id_area_type_tmp       integer     -- ID типа, ПРОМЕЖУТОЧНЫЙ
      ,fias_type_name	      varchar(50) -- Наименованиек типа, ГАР-ФИАС
      ,nm_area_type_tmp  	  varchar(50) -- Наименованиек типа, ПРОМЕЖУТОЧНОЕ
      ,fias_type_shortname    varchar(20) -- Краткое имя типа, ГАР-ФИАС
      ,nm_area_type_short_tmp varchar(10) -- Краткое наименованиек типа ПРОМЕЖУТОЧНОЕ,
      ,fias_row_key	          text        -- Уникальный идентификатор строки
     );
     
     COMMENT ON TYPE gar_tmp.zzz_adr_area_t IS 'С_Адреса #1 (adr_area), промежуточная структура';

    EXCEPTION           
       WHEN OTHERS THEN 
           RAISE WARNING '%, %', SQLSTATE, SQLERRM;
   END;
  $$;

DO
  $$
   BEGIN
     CREATE TYPE gar_tmp.zzz_adr_house_t AS (
         
       id_house_type       integer     -- ID типа, ОСНОВНОЙ	
      ,nm_house_type       varchar(50) -- Наименованиек типа, ОСНОВНОЕ
      ,nm_house_type_short varchar(10) -- Краткое наименованиек типа, ОСНОВНОЕ
      ,kd_house_type_lvl   integer     -- Код уровня ОСНОВНОЙ
      ,dt_data_del	       timestamp without time zone -- Дата удаления ОСНОВНАЯ
       ----
      ,fias_ids                bigint[]    -- Исходные идентификаторы ГАР-ФИАС 
      ,id_house_type_tmp       integer     -- ID типа, ПРОМЕЖУТОЧНЫЙ
      ,fias_type_name	       varchar(50) -- Наименованиек типа, ГАР-ФИАС
      ,nm_house_type_tmp  	   varchar(50) -- Наименованиек типа, ПРОМЕЖУТОЧНОЕ
      ,fias_type_shortname     varchar(20) -- Краткое имя типа, ГАР-ФИАС
      ,nm_house_type_short_tmp varchar(10) -- Краткое наименованиек типа ПРОМЕЖУТОЧНОЕ,
      ,fias_row_key	           text        -- Уникальный идентификатор строки
     );
     
     COMMENT ON TYPE gar_tmp.zzz_adr_house_t IS 'С_Адреса_#3 (adr_house), промежуточная структура';

    EXCEPTION           
       WHEN OTHERS THEN 
           RAISE WARNING '%, %', SQLSTATE, SQLERRM;
   END;
  $$;
