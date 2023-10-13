/*==============================================================*/
/* DBMS name:      PostgreSQL 13                                */
/* Created on:     13.10.2023 20:21:52                          */
/*==============================================================*/
/*==============================================================*/
/* Table: gar_tmp.xxx_adr_stead                                 */
/*==============================================================*/
DROP TABLE IF EXISTS gar_tmp.xxx_adr_stead CASCADE;
CREATE TABLE gar_tmp.xxx_adr_stead
(
     id_stead              bigint NOT NULL 
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
    ,parent_short_name     varchar(50)  
    ,stead_num             varchar(50)  
    ,stead_cadastr_num     varchar(50)  
    ,oper_type_id          bigint       
    ,oper_type_name        varchar(100) 
);

ALTER TABLE gar_tmp.xxx_adr_stead ADD CONSTRAINT pk_xxx_adr_stead PRIMARY KEY (id_stead);


/*==============================================================*/
/* Table: gar_tmp.adr_stead                                     */
/*==============================================================*/
DROP TABLE IF EXISTS gar_tmp.tmp_adr_stead CASCADE;
drop table if exists gar_tmp.adr_stead CASCADE;
create table if not exists gar_tmp.adr_stead (
   id_stead             bigint               not null,
   id_area              bigint               not null,
   id_street            bigint               null,
   stead_num             varchar(50),  
   stead_cadastr_num     varchar(50),  
   nm_zipcode           varchar(20) null,
   kd_oktmo             varchar(11) null,
   nm_fias_guid         uuid                 null,
   dt_data_del          timestamp            null,
   id_data_etalon       bigint               null,
   kd_okato             varchar(11) null,
   vl_addr_latitude     numeric              null,
   vl_addr_longitude    numeric              null
);

COMMENT ON TABLE gar_tmp.adr_stead IS
'С_Адреса (!)';

ALTER TABLE gar_tmp.adr_stead
   ADD CONSTRAINT pk_adr_stead PRIMARY KEY (id_stead);

