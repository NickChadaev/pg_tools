/*==============================================================*/
/* DBMS name:      PostgreSQL 13                                */
/* Created on:     29.08.2021 17:51:01                          */
/* ------------------------------------------------------------ */
/*==============================================================*/

/*==============================================================*/
/*    Table: gar_fias.gap_adr_area                              */
/*==============================================================*/
 DROP TABLE IF EXISTS gar_fias.gap_adr_area CASCADE;   
 CREATE TABLE gar_fias.gap_adr_area (
 
        id_addr_obj      bigint  NOT NULL
       ,id_addr_parent   bigint 
       ,fias_guid        uuid 
       ,parent_fias_guid uuid 
       ,nm_addr_obj      varchar(250) 
       ,addr_obj_type_id bigint
       ,addr_obj_type    varchar(50) 
       ,obj_level        bigint
       ,level_name       varchar(100) 
       --
       ,region_code      varchar(4)   
       ,area_code        varchar(4)   
       ,city_code        varchar(4)   
       ,place_code       varchar(4)   
       ,plan_code        varchar(4)   
       ,street_code      varchar(4)   
       --
       ,change_id        bigint
       ,prev_id          bigint
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
             
       ,date_create    date      NOT NULL DEFAULT current_date
       ,descr_gap      text 
 );
 
 COMMENT ON TABLE gar_fias.gap_adr_area IS 'G_Гео-регионы';

 ALTER TABLE gar_fias.gap_adr_area
   ADD CONSTRAINT pk_gap_adr_area PRIMARY KEY (id_addr_obj, date_create);
