/*==============================================================*/
/* DBMS name:      PostgreSQL 13                                */
/* Created on:     18.11.2022 12:47:01                          */
/*==============================================================*/

SET search_path=gar_tmp;
--
DROP TABLE IF EXISTS gar_tmp.xxx_object_type_alias CASCADE;
CREATE TABLE gar_tmp.xxx_object_type_alias
(
     id_object_type integer NOT NULL
    ,fias_row_key   text    NOT NULL
    ,object_kind    char(1) NOT NULL DEFAULT '0' -- адресные пространства    
);

ALTER TABLE gar_tmp.xxx_object_type_alias 
    ADD CONSTRAINT pk_xxx_object_type_alias PRIMARY KEY (fias_row_key);
    
ALTER TABLE gar_tmp.xxx_object_type_alias 
    DROP CONSTRAINT IF EXISTS chk_xxx_object_type_alias_object_kind;
   
ALTER TABLE gar_tmp.xxx_object_type_alias 
   ADD CONSTRAINT chk_xxx_object_type_alias_object_kind 
                       CHECK ( object_kind = '0' -- адресные пространства
                            OR object_kind = '1' -- улицы
                            OR object_kind = '2' -- Дома
);    
    
COMMENT ON TABLE gar_tmp.xxx_object_type_alias IS 'Таблица псевдонимов для адресных объектов';

COMMENT ON COLUMN gar_tmp.xxx_object_type_alias.id_object_type IS 'ID типа субъекта (псевдоним)';
COMMENT ON COLUMN gar_tmp.xxx_object_type_alias.fias_row_key   IS 'Текстовый ключ строки';
COMMENT ON COLUMN gar_tmp.xxx_object_type_alias.object_kind    IS 
                           'Вид объекта: 0-адресные пространства, 1-улицы, 2 - Дома.';
