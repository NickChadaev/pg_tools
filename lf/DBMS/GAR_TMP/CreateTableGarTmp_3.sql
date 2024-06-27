/*==============================================================*/
/* DBMS name:      PostgreSQL 13                                */
/* Created on:     02.12.2022 16:50:01                          */
/*==============================================================*/

SET search_path=gar_tmp;
--
DROP TABLE IF EXISTS gar_tmp.xxx_adr_area_gap CASCADE;
/*==============================================================*/
/*  Table: gar_tmp.xxx_adr_area_gap                             */
/*==============================================================*/
CREATE TABLE gar_tmp.xxx_adr_area_gap OF gar_tmp.xxx_adr_area_proc_t;

ALTER TABLE gar_tmp.xxx_adr_area_gap 
    ADD CONSTRAINT pk_xxx_adr_area_gap PRIMARY KEY (nm_fias_guid);

ALTER TABLE gar_tmp.xxx_adr_area_gap ALTER COLUMN curr_date SET NOT NULL;
ALTER TABLE gar_tmp.xxx_adr_area_gap ALTER COLUMN check_kind SET NOT NULL;
    
ALTER TABLE gar_tmp.xxx_adr_area_gap ALTER COLUMN curr_date SET DEFAULT current_date;
ALTER TABLE gar_tmp.xxx_adr_area_gap ALTER COLUMN check_kind SET DEFAULT '0';

ALTER TABLE gar_tmp.xxx_adr_area_gap 
    DROP CONSTRAINT IF EXISTS chk_xxx_adr_area_gap;
   
ALTER TABLE gar_tmp.xxx_adr_area_gap 
   ADD CONSTRAINT chk_xxx_adr_area_gap 
                       CHECK ( check_kind = '0' -- Входной контроль типов
                            OR check_kind = '1' -- Постобработка, дубликаты
                            OR check_kind = '2' -- Резерв
);    
    
COMMENT ON TABLE gar_tmp.xxx_adr_area_gap IS 'Адресные объекты не прошедшие входной контроль (типы)';

COMMENT ON COLUMN gar_tmp.xxx_adr_area_gap.id_area             IS 'ID адресной области ФИАС';   
COMMENT ON COLUMN gar_tmp.xxx_adr_area_gap.nm_area             IS 'Имя адресной области ФИАС';   
COMMENT ON COLUMN gar_tmp.xxx_adr_area_gap.nm_area_full        IS 'Полное имя адресной области ФИАС';   
COMMENT ON COLUMN gar_tmp.xxx_adr_area_gap.id_area_type        IS 'ID типа адресной области ФИАС';   
COMMENT ON COLUMN gar_tmp.xxx_adr_area_gap.nm_area_type        IS 'Имя типа адресной области ФИАС';   
COMMENT ON COLUMN gar_tmp.xxx_adr_area_gap.id_area_parent      IS 'ID родительской адр. области ФИАС';   
COMMENT ON COLUMN gar_tmp.xxx_adr_area_gap.nm_fias_guid_parent IS 'UUID родительской области ОБЩИЙ';    
COMMENT ON COLUMN gar_tmp.xxx_adr_area_gap.kd_oktmo            IS 'Код ОКТМО';   
COMMENT ON COLUMN gar_tmp.xxx_adr_area_gap.nm_fias_guid        IS 'UUID адресной области ОБЩИЙ';   
COMMENT ON COLUMN gar_tmp.xxx_adr_area_gap.kd_okato            IS 'Код ОКАТО';   
COMMENT ON COLUMN gar_tmp.xxx_adr_area_gap.nm_zipcode          IS 'Почтовый индекс';   
COMMENT ON COLUMN gar_tmp.xxx_adr_area_gap.kd_kladr            IS 'Код КЛАДР';   
COMMENT ON COLUMN gar_tmp.xxx_adr_area_gap.tree_d              IS 'Путь от корня ВНУТРЕННИЙ';   
COMMENT ON COLUMN gar_tmp.xxx_adr_area_gap.level_d             IS 'Уровень ВНУТРЕННИЙ';   
COMMENT ON COLUMN gar_tmp.xxx_adr_area_gap.obj_level           IS 'Уровень объекта ФИАС';   
COMMENT ON COLUMN gar_tmp.xxx_adr_area_gap.level_name          IS 'Имя уровня ФИАС';   
COMMENT ON COLUMN gar_tmp.xxx_adr_area_gap.oper_type_id        IS 'Тип операции ФИАС';   
COMMENT ON COLUMN gar_tmp.xxx_adr_area_gap.oper_type_name      IS 'Имя операции ФИАС';   
COMMENT ON COLUMN gar_tmp.xxx_adr_area_gap.curr_date           IS 'Текущая дата';   
COMMENT ON COLUMN gar_tmp.xxx_adr_area_gap.check_kind          IS 'Вид контроля: входной (типы данных)/Постобработка, дубликаты';  


DROP TABLE IF EXISTS gar_tmp.xxx_adr_street_gap CASCADE;
/*==============================================================*/
/*  Table: gar_tmp.xxx_adr_street_gap                           */
/*==============================================================*/
CREATE TABLE gar_tmp.xxx_adr_street_gap OF gar_tmp.xxx_adr_street_proc_t;

ALTER TABLE gar_tmp.xxx_adr_street_gap 
    ADD CONSTRAINT pk_xxx_adr_street_gap PRIMARY KEY (nm_fias_guid);

ALTER TABLE gar_tmp.xxx_adr_street_gap ALTER COLUMN curr_date SET NOT NULL;
ALTER TABLE gar_tmp.xxx_adr_street_gap ALTER COLUMN check_kind SET NOT NULL;
    
ALTER TABLE gar_tmp.xxx_adr_street_gap ALTER COLUMN curr_date SET DEFAULT current_date;
ALTER TABLE gar_tmp.xxx_adr_street_gap ALTER COLUMN check_kind SET DEFAULT '0';

ALTER TABLE gar_tmp.xxx_adr_street_gap 
    DROP CONSTRAINT IF EXISTS chk_xxx_adr_street_gap;
   
ALTER TABLE gar_tmp.xxx_adr_street_gap 
   ADD CONSTRAINT chk_xxx_adr_street_gap 
                       CHECK ( check_kind = '0' -- Входной контроль типов
                            OR check_kind = '1' -- Постобработка, дубликаты
                            OR check_kind = '2' -- Резерв
);    
    
COMMENT ON TABLE gar_tmp.xxx_adr_street_gap IS 'Улицы не прошедшие входной контроль (типы)';

COMMENT ON COLUMN gar_tmp.xxx_adr_street_gap.id_street         IS 'ID улицы ФИАС';           
COMMENT ON COLUMN gar_tmp.xxx_adr_street_gap.nm_street         IS 'Наименование улицы ФИАС';           
COMMENT ON COLUMN gar_tmp.xxx_adr_street_gap.nm_street_full    IS 'Наименование улицы полное ФИАС';           
COMMENT ON COLUMN gar_tmp.xxx_adr_street_gap.id_street_type    IS 'ID типа улицы ФИАС';           
COMMENT ON COLUMN gar_tmp.xxx_adr_street_gap.nm_street_type    IS 'Имя типа улицы ФИАС';           
COMMENT ON COLUMN gar_tmp.xxx_adr_street_gap.id_area           IS 'ID адресной области ФИАС';           
COMMENT ON COLUMN gar_tmp.xxx_adr_street_gap.nm_fias_guid_area IS 'UUID адресной области ФИАС';           
COMMENT ON COLUMN gar_tmp.xxx_adr_street_gap.nm_fias_guid      IS 'UUID улицы ОБЩИЙ';           
COMMENT ON COLUMN gar_tmp.xxx_adr_street_gap.kd_kladr          IS 'Код КЛАДР';           
COMMENT ON COLUMN gar_tmp.xxx_adr_street_gap.tree_d            IS 'Путь от корня ВНУТРЕННИЙ';           
COMMENT ON COLUMN gar_tmp.xxx_adr_street_gap.level_d           IS 'Уровень ВНУТРЕННИЙ';           
COMMENT ON COLUMN gar_tmp.xxx_adr_street_gap.obj_level         IS 'Уровень объекта ФИАС';           
COMMENT ON COLUMN gar_tmp.xxx_adr_street_gap.level_name        IS 'Имя уровня ФИАС';           
COMMENT ON COLUMN gar_tmp.xxx_adr_street_gap.oper_type_id      IS 'Тип операции ФИАС';           
COMMENT ON COLUMN gar_tmp.xxx_adr_street_gap.oper_type_name    IS 'Имя операции ФИАС';           
COMMENT ON COLUMN gar_tmp.xxx_adr_street_gap.curr_date         IS 'Текущая дата';           
COMMENT ON COLUMN gar_tmp.xxx_adr_street_gap.check_kind        IS 'Вид контроля: входной (типы данных)/Постобработка, дубликаты';           


DROP TABLE IF EXISTS gar_tmp.xxx_adr_house_gap CASCADE;
/*==============================================================*/
/*  Table: gar_tmp.xxx_adr_house_gap                           */
/*==============================================================*/
CREATE TABLE gar_tmp.xxx_adr_house_gap OF gar_tmp.xxx_adr_house_proc_t;

ALTER TABLE gar_tmp.xxx_adr_house_gap 
    ADD CONSTRAINT pk_xxx_adr_house_gap PRIMARY KEY (nm_fias_guid);

ALTER TABLE gar_tmp.xxx_adr_house_gap ALTER COLUMN curr_date SET NOT NULL;
ALTER TABLE gar_tmp.xxx_adr_house_gap ALTER COLUMN check_kind SET NOT NULL;
    
ALTER TABLE gar_tmp.xxx_adr_house_gap ALTER COLUMN curr_date SET DEFAULT current_date;
ALTER TABLE gar_tmp.xxx_adr_house_gap ALTER COLUMN check_kind SET DEFAULT '0';

ALTER TABLE gar_tmp.xxx_adr_house_gap 
    DROP CONSTRAINT IF EXISTS chk_xxx_adr_house_gap;
   
ALTER TABLE gar_tmp.xxx_adr_house_gap 
   ADD CONSTRAINT chk_xxx_adr_house_gap 
                       CHECK ( check_kind = '0' -- Входной контроль типов
                            OR check_kind = '1' -- Постобработка, дубликаты
                            OR check_kind = '2' -- Резерв
);    
    
COMMENT ON TABLE gar_tmp.xxx_adr_house_gap IS 'Дома не прошедшие входной контроль (типы)';

COMMENT ON COLUMN gar_tmp.xxx_adr_house_gap.id_house              IS 'ID дома ФИАС';
COMMENT ON COLUMN gar_tmp.xxx_adr_house_gap.id_addr_parent        IS 'ID род. объекта ФИАС';
COMMENT ON COLUMN gar_tmp.xxx_adr_house_gap.nm_fias_guid          IS 'UUID дома ОБЩИЙ';
COMMENT ON COLUMN gar_tmp.xxx_adr_house_gap.nm_fias_guid_parent   IS 'UUID род. объекта. ОБЩИЙ';
COMMENT ON COLUMN gar_tmp.xxx_adr_house_gap.nm_parent_obj         IS 'Имя родительского объекта ФИАС';
COMMENT ON COLUMN gar_tmp.xxx_adr_house_gap.region_code           IS 'Код региона ФИАС';
COMMENT ON COLUMN gar_tmp.xxx_adr_house_gap.parent_type_id        IS 'ID типа род. объекта. ФИАС';
COMMENT ON COLUMN gar_tmp.xxx_adr_house_gap.parent_type_name      IS 'Имя типа род. объекта ФИАС';
COMMENT ON COLUMN gar_tmp.xxx_adr_house_gap.parent_type_shortname IS 'Краткое имя род. объекта'; 
COMMENT ON COLUMN gar_tmp.xxx_adr_house_gap.parent_level_id       IS 'ID уровня родителя ФИАС';
COMMENT ON COLUMN gar_tmp.xxx_adr_house_gap.parent_level_name     IS 'Имя уровня родителя. ФИАС';
COMMENT ON COLUMN gar_tmp.xxx_adr_house_gap.parent_short_name     IS 'Краткое имя родителя ФИАС';
COMMENT ON COLUMN gar_tmp.xxx_adr_house_gap.house_num             IS 'Номер дома';
COMMENT ON COLUMN gar_tmp.xxx_adr_house_gap.add_num1              IS 'Дополнительный номер дома 1';
COMMENT ON COLUMN gar_tmp.xxx_adr_house_gap.add_num2              IS 'Дополнительный номер дома 2';
COMMENT ON COLUMN gar_tmp.xxx_adr_house_gap.house_type            IS 'ID типа дома ФИАС';
COMMENT ON COLUMN gar_tmp.xxx_adr_house_gap.house_type_name       IS 'Имя типа дома ФИАС';
COMMENT ON COLUMN gar_tmp.xxx_adr_house_gap.house_type_shortname  IS 'Краткое имя типа дома ФИАС';
COMMENT ON COLUMN gar_tmp.xxx_adr_house_gap.add_type1             IS 'ID доп.типа дома №1 ФИАС';
COMMENT ON COLUMN gar_tmp.xxx_adr_house_gap.add_type1_name        IS 'Имя доп.типа дома №1 ФИАС';
COMMENT ON COLUMN gar_tmp.xxx_adr_house_gap.add_type1_shortname   IS 'Краткое имя доп.типа дома №1 ФИАС';
COMMENT ON COLUMN gar_tmp.xxx_adr_house_gap.add_type2             IS 'ID доп.типа дома №2 ФИАС';
COMMENT ON COLUMN gar_tmp.xxx_adr_house_gap.add_type2_name        IS 'Имя доп.типа дома №2 ФИАС';
COMMENT ON COLUMN gar_tmp.xxx_adr_house_gap.add_type2_shortname   IS 'Краткое имя доп.типа дома №2 ФИАС';
COMMENT ON COLUMN gar_tmp.xxx_adr_house_gap.nm_zipcode            IS 'Почтовый индекс';
COMMENT ON COLUMN gar_tmp.xxx_adr_house_gap.kd_oktmo              IS 'Код ОКТМО';
COMMENT ON COLUMN gar_tmp.xxx_adr_house_gap.kd_okato              IS 'Код ОКАТО';
COMMENT ON COLUMN gar_tmp.xxx_adr_house_gap.oper_type_id          IS 'Тип операции ФИАС';           
COMMENT ON COLUMN gar_tmp.xxx_adr_house_gap.oper_type_name        IS 'Имя операции ФИАС';           
COMMENT ON COLUMN gar_tmp.xxx_adr_house_gap.curr_date             IS 'Текущая дата';           
COMMENT ON COLUMN gar_tmp.xxx_adr_house_gap.check_kind            IS 'Вид контроля: входной (типы данных)/Постобработка, дубликаты';      
