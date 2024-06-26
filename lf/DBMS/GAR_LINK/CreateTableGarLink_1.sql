/*===============================================================*/
/* DBMS name:      PostgreSQL 13                                 */
/* Created on:     09.11.2022 16:19:52                           */
/* ------------------------------------------------------------- */
/* Индексы адресных таблиц, используются везде, но запихнул сюда */
/*===============================================================*/

SET search_path=gar_link;

/*==============================================================*/
/* Table: gar_link.adr_indecies                                 */
/*==============================================================*/
DROP TABLE IF EXISTS gar_link.adr_indecies CASCADE;
CREATE TABLE gar_link.adr_indecies (
      table_name   text    NOT NULL
    , index_name   text    NOT NULL
    , index_body   text    NOT NULL  
    , index_kind   boolean NOT NULL DEFAULT true  
    , unique_sign  boolean NOT NULL DEFAULT false
    );

ALTER TABLE gar_link.adr_indecies ADD CONSTRAINT pk_adr_indecies PRIMARY KEY (index_name);

COMMENT ON TABLE gar_link.adr_indecies IS 'Список индексов адресных таблиц, необходим для динамической перестройки.';

COMMENT ON COLUMN gar_link.adr_indecies.table_name IS 'Имя таблицы';
COMMENT ON COLUMN gar_link.adr_indecies.index_name IS 'Имя индекса';
COMMENT ON COLUMN gar_link.adr_indecies.index_body IS 'Идексное выражение';
COMMENT ON COLUMN gar_link.adr_indecies.index_kind IS 'Вид индекса: TRUE-эксплуатационный, FALSE-процессинговый';
COMMENT ON COLUMN gar_link.adr_indecies.index_kind IS 'Признак уникальности: TRUE-уникальный, FALSE-неуникальный. Может быть перелпределён.';
--
--
/*===============================================================*/
/* DBMS name:      PostgreSQL 13                                 */
/* Created on:     09.11.2022 16:19:52                           */
/* ------------------------------------------------------------- */
/* Индексы адресных таблиц, используются везде, но запихнул сюда */
/*===============================================================*/

SET search_path=gar_link;
/*==============================================================*/
/* Table: gar_link.adr_indecies   Данные.                       */
/*==============================================================*/
INSERT INTO gar_link.adr_indecies (table_name, index_name, index_body, index_kind, unique_sign)
 VALUES ('adr_area','adr_area_i1', 'ON %I.adr_area USING btree (id_area_parent)', true , false )
       ,('adr_area','adr_area_i2', 'ON %I.adr_area USING btree (id_area_type)', true, false)
       ,('adr_area','adr_area_i3', 'ON %I.adr_area USING btree (id_country)', true, false)
       ,('adr_area','adr_area_i4', 'ON %I.adr_area USING btree (kd_timezone)', true, false)
       ,('adr_area','adr_area_i5', 'ON %I.adr_area USING btree (id_data_etalon)', true, false)
       ,('adr_area','adr_area_i6', 'ON %I.adr_area USING btree (id_country, upper((nm_area_full)::text))', true, false)
       ,('adr_area','adr_area_i7', 'ON %I.adr_area USING btree (nm_fias_guid)', true, false )       
       ,('adr_area','adr_area_i8', 'ON %I.adr_area USING btree (id_country, upper((nm_area)::text))', true, false)
       ,('adr_area','adr_area_i9', 'ON %I.adr_area USING btree (kd_okato)', true, false)
       ,('adr_area','index_nm_area_on_adr_area_trigram', 'ON %I.adr_area USING gin (nm_area gin_trgm_ops)', true, false)
       ,('adr_area','adr_area_ak1', 'ON %I.adr_area USING btree (id_country, id_area_parent, id_area_type, upper((nm_area)::text)) WHERE (id_data_etalon IS NULL)', true, true)
         --
       ,('adr_area','_xxx_adr_area_ak1', 'ON %I.adr_area USING btree (id_country ASC NULLS LAST, id_area_parent ASC NULLS LAST, id_area_type ASC NULLS LAST, upper(nm_area::text) ASC NULLS LAST) WHERE (id_data_etalon IS NULL) AND (dt_data_del IS NULL)', false, true)
       ,('adr_area','_xxx_adr_area_ie2', 'ON %I.adr_area USING btree (nm_fias_guid) WHERE (id_data_etalon IS NULL) AND (dt_data_del IS NULL)', false, true)       
;
--
INSERT INTO gar_link.adr_indecies (table_name, index_name, index_body, index_kind, unique_sign)
 VALUES ('adr_street','adr_street_i1', 'ON %I.adr_street USING btree (id_area)', true, false )
       ,('adr_street','adr_street_i2', 'ON %I.adr_street USING btree (id_street_type)', true, false)
       ,('adr_street','adr_street_i3', 'ON %I.adr_street USING btree (id_data_etalon)', true, false)
       ,('adr_street','adr_street_i4', 'ON %I.adr_street USING btree (nm_fias_guid)', true, false)
       ,('adr_street','adr_street_ak1', 'ON %I.adr_street USING btree (id_area, upper((nm_street)::text), id_street_type) WHERE (id_data_etalon IS NULL)', true, true)
         --
       ,('adr_street','_xxx_adr_street_ie2', 'ON %I.adr_street USING btree (nm_fias_guid ASC NULLS LAST) WHERE id_data_etalon IS NULL AND dt_data_del IS NULL', false, true)
       ,('adr_street','_xxx_adr_street_ak1', 'ON %I.adr_street USING btree (id_area ASC NULLS LAST, upper(nm_street::text) ASC NULLS LAST, id_street_type ASC NULLS LAST) WHERE (id_data_etalon IS NULL) AND (dt_data_del IS NULL)', false, true)       
;
--
INSERT INTO gar_link.adr_indecies (table_name, index_name, index_body, index_kind, unique_sign)
 VALUES ('adr_house','adr_house_i1', 'ON %I.adr_house USING btree (id_area)', true, false)
       ,('adr_house','adr_house_i2', 'ON %I.adr_house USING btree (id_street)', true, false)
       ,('adr_house','adr_house_i3', 'ON %I.adr_house USING btree (id_house_type_1)', true, false)
       ,('adr_house','adr_house_i4', 'ON %I.adr_house USING btree (id_house_type_2)', true, false)
       ,('adr_house','adr_house_i5', 'ON %I.adr_house USING btree (id_house_type_3)', true, false)
       ,('adr_house','adr_house_i7', 'ON %I.adr_house USING btree (nm_fias_guid)', true, false)
       ,('adr_house','adr_house_idx1', 'ON %I.adr_house USING btree (id_area) WHERE (id_street IS NULL)', true, false)       
       ,('adr_house','adr_house_ak1', 'ON %I.adr_house USING btree (id_area, upper((nm_house_full)::text), id_street) WHERE (id_data_etalon IS NULL)', true, true)
         --
       ,('adr_house','_xxx_adr_house_ie2', 'ON %I.adr_house USING btree (nm_fias_guid ASC NULLS LAST) WHERE (id_data_etalon IS NULL) AND (dt_data_del IS NULL)', false, true)
       ,('adr_house','_xxx_adr_house_ak1', 'ON %I.adr_house USING btree (id_area ASC NULLS LAST, upper (nm_house_full::text) ASC NULLS LAST, id_street ASC NULLS LAST,id_house_type_1 ASC NULLS LAST)  WHERE (id_data_etalon IS NULL) AND (dt_data_del IS NULL)', false, true)       
;

SELECT * FROM gar_link.adr_indecies;
