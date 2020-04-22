/*============================================================================*/
/* DBMS name:      PostgreSQL 8                                               */
/* Created on:     10.02.2015 18:25:11                                        */
/*    2015-03-21 Появился частичный индекс на кратком коде                    */
/*    29.03.2015 18:19:37 Добавлен объект                                     */
/*    28.04.2015 Изменена иерархия объектов                                   */
/* -------------------------------------------------------------------------- */                                                               
/* 2015-05-28:  Добавлены атрибуты в Кодификатор                              */                                                                
/*    Дата создания              date_create                                  */        
/*    Дата начала актуальности   date_from                                    */
/*    Дата конца актуальности    date_to                                      */
/*    UUID                       codif_uuid                                   */
/*              Добавлена nso_domain_column                                   */ 
/* 2015-06-05:  Добавлен атрибут impact_type d таблицу nso_domain_column_hist */
/* -------------------------------------------------------------------------- */
/* 22.06.2015 15:15:34  obj_codifier, obj_object, nso_domain_column имеют     */
/*                      историю.                                              */ 
/* ---------------------------------------------------------------------------*/
/* Nick 2015-10-02  Добавлена таблица "Конфигурация ПТК"                      */
/* Nick 2015-11-16  Добавлен атрибут "Объект-домен".                          */ 
/* Nick 2015-11-16  Добавлен атрибуты: "Объект-домен", "Тип объекта-потомка". */
/* ---------------------------------------------------------------------------*/
/* Nick 2019-05-21  Nick Новое ядро.                                          */
/*============================================================================*/
                                                   
SET search_path=com, public, pg_catalog;

ALTER TABLE com.com_log ALTER COLUMN schema_name SET DEFAULT 'com'; -- 2019-07-11

ALTER TABLE com.nso_domain_column
   ADD CONSTRAINT fk_nso_domain_column_can_have_com_log FOREIGN KEY (id_log)
      REFERENCES com.com_log (id_log)
      ON DELETE RESTRICT ON UPDATE RESTRICT;

ALTER TABLE com.nso_domain_column
   ADD CONSTRAINT fk_nso_domain_column_grouping_nso_domain_column FOREIGN KEY (parent_attr_id)
      REFERENCES com.nso_domain_column (attr_id)
      ON DELETE RESTRICT ON UPDATE RESTRICT;

ALTER TABLE com.nso_domain_column
   ADD CONSTRAINT fk_nso_object_can_define_nso_domain_column FOREIGN KEY (domain_nso_id)
      REFERENCES nso.nso_object (nso_id)
      ON DELETE RESTRICT ON UPDATE RESTRICT;

-- Nick 2015-11-16 -- -- 2016-02-02 goback Nick
-- alter table nso_domain_column
--    add constraint fk_nso_object_can_define_obj_domain_column foreign key (domain_object_id)
--       references com.obj_object (object_id)
--       on delete restrict on update restrict;
-- Nick 2015-11-16 -- -- 2016-02-02 goback Nick

ALTER TABLE com.nso_domain_column
   ADD CONSTRAINT fk_obj_codifier_typify_nso_domain_column FOREIGN KEY (attr_type_id)
      REFERENCES com.obj_codifier (codif_id)
      ON DELETE RESTRICT ON UPDATE RESTRICT;

ALTER TABLE com.nso_domain_column_hist
   ADD CONSTRAINT fk_nso_domain_column_hist_hase_com_log FOREIGN KEY (id_log)
      REFERENCES com.com_log (id_log)
      ON DELETE RESTRICT ON UPDATE RESTRICT;

ALTER TABLE com.obj_codifier
   ADD CONSTRAINT fk_obj_codifier_can_has_com_log FOREIGN KEY (id_log)
      REFERENCES com.com_log (id_log)
      ON DELETE RESTRICT ON UPDATE RESTRICT;

ALTER TABLE com.obj_codifier
   ADD CONSTRAINT fk_obj_codifier_grouping_obj_codifier FOREIGN KEY (parent_codif_id)
      REFERENCES com.obj_codifier (codif_id)
      ON DELETE RESTRICT ON UPDATE RESTRICT;

ALTER TABLE com.obj_codifier_hist
   ADD CONSTRAINT fk_obj_codifier_hist_has_com_log FOREIGN KEY (id_log)
      REFERENCES com.com_log (id_log)
      ON DELETE RESTRICT ON UPDATE RESTRICT;
--
ALTER TABLE com.obj_object
   ADD CONSTRAINT fk_nso_record_defines_object_secret_level FOREIGN KEY (object_secret_id)
      REFERENCES nso.nso_record (rec_id)
      ON DELETE RESTRICT ON UPDATE RESTRICT;

ALTER TABLE com.obj_object
   ADD CONSTRAINT fk_nso_record_is_owner_obj_object FOREIGN KEY (object_owner_id)
      REFERENCES nso.nso_record (rec_id)
      ON DELETE RESTRICT ON UPDATE RESTRICT;

ALTER TABLE com.obj_object
   ADD CONSTRAINT fk_obj_codifier_defines_object_type FOREIGN KEY (object_type_id)
      REFERENCES com.obj_codifier (codif_id)
      ON DELETE RESTRICT ON UPDATE RESTRICT;

ALTER TABLE com.obj_object
   ADD CONSTRAINT fk_obj_object_can_have_com_log FOREIGN KEY (id_log)
      REFERENCES com.com_log (id_log)
      ON DELETE RESTRICT ON UPDATE RESTRICT;

ALTER TABLE com.obj_object
   ADD CONSTRAINT fk_obj_object_grouping FOREIGN KEY (parent_object_id)
      REFERENCES com.obj_object (object_id)
      ON DELETE RESTRICT ON UPDATE RESTRICT;
-- Nick 2015-11-16
ALTER TABLE com.obj_object
   ADD CONSTRAINT fk_obj_codifier_can_defines_object_stype FOREIGN KEY ()
      REFERENCES com.obj_codifier (codif_id)
      ON DELETE RESTRICT ON UPDATE RESTRICT;
--  Nick 2015-11-16
ALTER TABLE com.obj_object_hist
   ADD CONSTRAINT fk_obj_object_hist_hase_com_log FOREIGN KEY (id_log)
      REFERENCES com.com_log (id_log)
      ON DELETE RESTRICT ON UPDATE RESTRICT;
-- -------------------------------------------------------------------------------------
--    2020-02-15  Связи между объектами.
-- -------------------------------------
ALTER TABLE com.com_obj_nso_relation
   ADD CONSTRAINT fk_com_obj_nso_relation_links_nso_record FOREIGN KEY (nso_record_id)
      REFERENCES nso.nso_record (rec_id)
      ON DELETE RESTRICT ON UPDATE RESTRICT;
--
ALTER TABLE com.com_obj_nso_relation
   ADD CONSTRAINT fk_com_obj_nso_relation_links_obj_object FOREIGN KEY (obj_object_id)
      REFERENCES com.obj_object (object_id)
      ON DELETE RESTRICT ON UPDATE RESTRICT;
--
ALTER TABLE com.com_obj_nso_relation
   ADD CONSTRAINT fk_obj_codifier_defines_type_obj_nso_relation FOREIGN KEY (perm_type_id)
      REFERENCES com.obj_codifier (codif_id)
      ON DELETE RESTRICT ON UPDATE RESTRICT;
--
ALTER TABLE com.com_obj_nso_relation
   ADD CONSTRAINT fk_com_obj_nso_relation_hase_com_log FOREIGN KEY (id_log)
      REFERENCES com.com_log (id_log)
      ON DELETE RESTRICT ON UPDATE RESTRICT;
--
-- ---------------------------------------------------------------------------------------
--
ALTER TABLE com.exn_obj_relation
   ADD CONSTRAINT fk_exn_obj_relation_links_paren_obj_object FOREIGN KEY (exn_parent_object_id)
      REFERENCES com.obj_object (object_id)
      ON DELETE RESTRICT ON UPDATE RESTRICT;
--
ALTER TABLE com.exn_obj_relation
   ADD CONSTRAINT fk_exn_obj_relation_links_child_obj_object FOREIGN KEY (exn_obj_object_id)
      REFERENCES com.obj_object (object_id)
      ON DELETE RESTRICT ON UPDATE RESTRICT;
--
ALTER TABLE com.exn_obj_relation
   ADD CONSTRAINT fk_obj_codifier_defines_type_exn_obj_relation FOREIGN KEY (exn_perm_type_id)
      REFERENCES com.obj_codifier (codif_id)
      ON DELETE RESTRICT ON UPDATE RESTRICT;
--
ALTER TABLE com.exn_obj_relation
   ADD CONSTRAINT fk_exn_obj_relation_hase_com_log FOREIGN KEY (id_log)
      REFERENCES com.com_log (id_log)
      ON DELETE RESTRICT ON UPDATE RESTRICT;
--
