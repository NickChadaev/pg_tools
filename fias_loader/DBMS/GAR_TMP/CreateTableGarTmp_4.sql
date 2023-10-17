/*==============================================================*/
/* DBMS name:      PostgreSQL 13                                */
/* Created on:     13.10.2023 20:21:52                          */
/*  Всё о структурах хранения данных по земельным участкам.     */
/*==============================================================*/

/*==============================================================*/
/*           Table: gar_tmp.adr_stead_t                         */
/*==============================================================*/
DO
  $$
   BEGIN
     CREATE TYPE gar_tmp.adr_stead_t AS (

               id_stead           bigint        
              ,id_area            bigint        
              ,id_street          bigint        
              ,stead_num          varchar(250)  
              ,stead_cadastr_num  varchar(250)  
              --
              ,kd_oktmo   varchar(11)           
              ,kd_okato   varchar(11)           
              ,nm_zipcode varchar(20)           
              --
              ,nm_fias_guid       uuid          
              ,dt_data_del        timestamp     
              ,id_data_etalon     bigint        
              ,vl_addr_latitude   numeric       
              ,vl_addr_longitude  numeric         
    );
     
     COMMENT ON TYPE gar_tmp.adr_stead_t IS 'Земельные участки';

    EXCEPTION           
       WHEN OTHERS THEN 
           RAISE WARNING '%, %', SQLSTATE, SQLERRM;
   END;
  $$;

/*==============================================================*/
/*       Table: gar_tmp.xxx_adr_stead_proc_t                    */
/*==============================================================*/

-- DROP TYPE IF EXISTS gar_tmp.xxx_adr_stead_proc_t CASCADE;
DO
  $$
   BEGIN
       CREATE TYPE gar_tmp.xxx_adr_stead_proc_t AS (
       
            id_stead              bigint  
           ,id_addr_parent        bigint  
           ,fias_guid             uuid    
           ,parent_fias_guid      uuid 
           ,nm_parent_obj         varchar(250) 
           ,region_code           varchar(4)   

           ,parent_type_id        bigint       
           ,parent_type_name      varchar(250) 
           ,parent_type_shortname varchar(50)  

           ,parent_level_id       bigint       
           ,parent_level_name     varchar(100) 

           ,stead_num             varchar(250)  
           ,stead_cadastr_num     varchar(250)     
            --
           ,kd_oktmo              varchar(11) 
           ,kd_okato              varchar(11) 
           ,nm_zipcode            varchar(20) 
           --
           ,oper_type_id           bigint 
           ,oper_type_name         varchar(100) 
           ,curr_date              date
           ,check_kind             char(1)            
       );
       
       COMMENT ON TYPE gar_tmp.xxx_adr_stead_proc_t 
                 IS 'Используется в процессе обработки адресов земельных участков';

    EXCEPTION           
       WHEN OTHERS THEN 
           RAISE WARNING '%, %', SQLSTATE, SQLERRM;
   END;
$$;

/*==============================================================*/
/* Table: gar_tmp.xxx_adr_stead                                 */
/*==============================================================*/
DROP TABLE IF EXISTS gar_tmp.xxx_adr_stead CASCADE;
CREATE TABLE gar_tmp.xxx_adr_stead
(
     id_stead              bigint NOT NULL 
    ,id_addr_parent        bigint 
    ,fias_guid             uuid   NOT NULL 
    ,parent_fias_guid      uuid 
    ,nm_parent_obj         varchar(250) 
    ,region_code           varchar(4)   
    ,parent_type_id        bigint       
    ,parent_type_name      varchar(250) 
    ,parent_type_shortname varchar(50)  
    ,parent_level_id       bigint       
    ,parent_level_name     varchar(100) 
    ,stead_num             varchar(250)   NOT NULL 
    ,oper_type_id          bigint       
    ,oper_type_name        varchar(100) 
);

ALTER TABLE gar_tmp.xxx_adr_stead ADD CONSTRAINT pk_xxx_adr_stead PRIMARY KEY (id_stead);
COMMENT ON TABLE gar_tmp.xxx_adr_stead IS 'Временная таблица "Земельные участки"';

/*==============================================================*/
/* Table: gar_tmp.adr_stead                                     */
/*==============================================================*/
DROP TABLE IF EXISTS gar_tmp.adr_stead CASCADE;
CREATE TABLE IF NOT EXISTS gar_tmp.adr_stead (

   id_stead           bigint        NOT NULL,
   id_area            bigint        NOT NULL,
   id_street          bigint            NULL,
   stead_num          varchar(250)  NOT NULL,  
   stead_cadastr_num  varchar(250)      NULL,  
   --
   kd_oktmo   varchar(11)  NULL,
   kd_okato   varchar(11)  NULL,
   nm_zipcode varchar(20)  NULL,
   --
   nm_fias_guid       uuid           NOT NULL,
   dt_data_del        timestamp          NULL,
   id_data_etalon     bigint             NULL,
   vl_addr_latitude   numeric            NULL,
   vl_addr_longitude  numeric            NULL
);

COMMENT ON TABLE gar_tmp.adr_stead IS 'Земельные участки';

ALTER TABLE gar_tmp.adr_stead
   ADD CONSTRAINT pk_adr_stead PRIMARY KEY (id_stead);

--  ВНИМАНИЕ, первый вариант эксплуатационного индексного покрытия.
--
CREATE UNIQUE INDEX adr_stead_ak1 ON gar_tmp.adr_stead USING btree (id_area, upper((stead_num)::text), id_street) WHERE (id_data_etalon IS NULL);
CREATE INDEX adr_stead_i1 ON gar_tmp.adr_stead USING btree (id_area);
CREATE INDEX adr_stead_i2 ON gar_tmp.adr_stead USING btree (id_street);                          
CREATE INDEX adr_stead_i3 ON gar_tmp.adr_stead USING btree (nm_fias_guid);                       
CREATE INDEX adr_stead_i4 ON gar_tmp.adr_stead USING btree (id_area) WHERE (id_street IS NULL);

--   Процессинговое индексное покрытие.
-- CREATE UNIQUE INDEX _xxx_adr_stead_ak1 ON gar_tmp.adr_stead USING btree (id_area, upper((stead_num)::text), id_street) WHERE ((id_data_etalon IS NULL) AND (dt_data_del IS NULL));
-- CREATE UNIQUE INDEX _xxx_adr_stead_ie2 ON gar_tmp.adr_stead USING btree (nm_fias_guid) WHERE ((id_data_etalon IS NULL) AND (dt_data_del IS NULL));

/*==============================================================*/
/* Table: gar_tmp.adr_stead_aux                                 */
/*==============================================================*/
DROP TABLE IF EXISTS gar_tmp.adr_stead_aux CASCADE;
CREATE TABLE gar_tmp.adr_stead_aux (
	 id_stead  bigint    NOT NULL
	,op_sign   bpchar(1) NOT NULL
);

ALTER TABLE gar_tmp.adr_stead_aux ADD CONSTRAINT
	pk_adr_stead_aux PRIMARY KEY (id_stead);

ALTER TABLE gar_tmp.adr_stead_aux ADD CONSTRAINT
	adr_stead_aux_op_sign_check CHECK (op_sign = ANY (ARRAY['I'::bpchar, 'U'::bpchar]));

COMMENT ON TABLE gar_tmp.adr_house_aux IS 'Земельные участки, вспомогательная таблица';

/*==============================================================*/
/* Table: gar_tmp.adr_stead_hist                                */
/*==============================================================*/
DROP TABLE IF EXISTS gar_tmp.adr_stead_hist CASCADE;
CREATE TABLE IF NOT EXISTS gar_tmp.adr_stead_hist (
   adr_stead_hist  bigserial  NOT NULL,
   date_create     timestamp  NOT NULL DEFAULT now(),
   f_server_name   text,
   id_region       bigint
) INHERITS (gar_tmp.adr_stead);

COMMENT ON TABLE gar_tmp.adr_stead_hist IS 'Земельные участки, история';

ALTER TABLE gar_tmp.adr_stead_hist
   ADD CONSTRAINT pk_adr_stead_hist PRIMARY KEY (adr_stead_hist);
--
-- 2022-08-12  Отмена наследования.
--
ALTER TABLE gar_tmp.adr_stead_hist NO INHERIT gar_tmp.adr_stead;


DROP TABLE IF EXISTS gar_tmp.xxx_adr_stead_gap CASCADE;
/*==============================================================*/
/*  Table: gar_tmp.xxx_adr_stead_gap                            */
/*==============================================================*/
CREATE TABLE gar_tmp.xxx_adr_stead_gap OF gar_tmp.xxx_adr_stead_proc_t;

ALTER TABLE gar_tmp.xxx_adr_stead_gap 
    ADD CONSTRAINT pk_xxx_adr_stead_gap PRIMARY KEY (fias_guid);

ALTER TABLE gar_tmp.xxx_adr_stead_gap ALTER COLUMN curr_date SET NOT NULL;
ALTER TABLE gar_tmp.xxx_adr_stead_gap ALTER COLUMN check_kind SET NOT NULL;
    
ALTER TABLE gar_tmp.xxx_adr_stead_gap ALTER COLUMN curr_date SET DEFAULT current_date;
ALTER TABLE gar_tmp.xxx_adr_stead_gap ALTER COLUMN check_kind SET DEFAULT '0';

ALTER TABLE gar_tmp.xxx_adr_stead_gap 
    DROP CONSTRAINT IF EXISTS chk_xxx_adr_stead_gap;
   
ALTER TABLE gar_tmp.xxx_adr_stead_gap 
   ADD CONSTRAINT chk_xxx_adr_stead_gap 
                       CHECK ( check_kind = '0' -- Входной контроль типов
                            OR check_kind = '1' -- Постобработка, дубликаты
                            OR check_kind = '2' -- Резерв
);    
    
COMMENT ON TABLE gar_tmp.xxx_adr_stead_gap IS 'Земельные участки  не прошедшие входной контроль';

