/*==============================================================*/
/* DBMS name:      PostgreSQL 8                                 */
/* Created on:     10.02.2015 18:25:11                          */
/*            2015-05-29  NSO_DOMAIN_COLUMN  в схему COM        */
/* -------------------------------------------------------------*/
/* 2020-04-30 Журнал секционирется, отмена декларативных        */ 
/*                                                 ограничений  */
/*==============================================================*/

SET search_path=nso,com,public,pg_catalog;

ALTER TABLE nso.nso_log_1  ALTER COLUMN schema_name SET DEFAULT 'nso'; --2019-07-11
--
-- foreign key constraints are not supported on partitioned tables
--  Исходно ставим "foreign key constraints" на секцию 0
--
ALTER TABLE nso.nso_abs_0
   ADD CONSTRAINT fk_nso_column_head_is_owner_nso_abs_0 FOREIGN KEY (col_id)
      REFERENCES nso.nso_column_head (col_id)
      ON DELETE RESTRICT ON UPDATE RESTRICT;

ALTER TABLE nso.nso_abs_0
   ADD CONSTRAINT fk_nso_record_is_contains_abs_0 FOREIGN KEY (rec_id)
      REFERENCES nso.nso_record (rec_id)
      ON DELETE RESTRICT ON UPDATE RESTRICT;

-- ALTER TABLE nso.nso_abs_0
--    ADD CONSTRAINT fk_nso_log_idents_nso_abs_0 FOREIGN KEY (log_id)
--       REFERENCES nso.nso_log (id_log)
--       ON DELETE RESTRICT ON UPDATE RESTRICT;
--      
--    
--
ALTER TABLE nso.nso_blob_0
   ADD CONSTRAINT fk_nso_head_is_owner_nso_blob_0 FOREIGN KEY (col_id)
      REFERENCES nso.nso_column_head (col_id)
      ON DELETE RESTRICT ON UPDATE RESTRICT;

ALTER TABLE nso.nso_blob_0
   ADD CONSTRAINT fk_nso_record_has_blob_0 FOREIGN KEY (rec_id)
      REFERENCES nso.nso_record (rec_id)
      ON DELETE RESTRICT ON UPDATE RESTRICT;
      
-- ALTER TABLE nso.nso_blob_0
--    ADD CONSTRAINT fk_nso_log_idents_nso_blob_0 FOREIGN KEY (log_id)
--       REFERENCES nso.nso_log (id_log)
--       ON DELETE RESTRICT ON UPDATE RESTRICT;  
--      
--      
--      
ALTER TABLE nso.nso_ref
   ADD CONSTRAINT fk_nso_head_is_owner_nso_ref FOREIGN KEY (col_id)
      REFERENCES nso.nso_column_head (col_id)
      ON DELETE RESTRICT ON UPDATE RESTRICT;

ALTER TABLE nso.nso_ref
   ADD CONSTRAINT fk_nso_record_has_nso_ref FOREIGN KEY (rec_id)
      REFERENCES nso.nso_record (rec_id)
      ON DELETE RESTRICT ON UPDATE RESTRICT;
      
-- ALTER TABLE nso.nso_ref
--    ADD CONSTRAINT fk_nso_log_idents_nso_ref FOREIGN KEY (log_id)
--       REFERENCES nso.nso_log (id_log)
--       ON DELETE RESTRICT ON UPDATE RESTRICT;       
---
-- -------------------------------------------------------------------------      
--      
ALTER TABLE nso.nso_column_head
   ADD CONSTRAINT fk_nso_column_headre_is_parent FOREIGN KEY (parent_col_id)
      REFERENCES nso.nso_column_head (col_id)
      ON DELETE RESTRICT ON UPDATE RESTRICT;

ALTER TABLE nso.nso_column_head
   ADD CONSTRAINT fk_nso_domain_column_define_nso_column_head FOREIGN KEY (attr_id)
      REFERENCES com.nso_domain_column (attr_id)   -- Nick 2015-05-29
      ON DELETE RESTRICT ON UPDATE RESTRICT;

ALTER TABLE nso.nso_column_head
   ADD CONSTRAINT fk_nso_object_has_nso_column_head FOREIGN KEY (nso_id)
      REFERENCES nso.nso_object (nso_id)
      ON DELETE RESTRICT ON UPDATE RESTRICT;
--
-- ALTER TABLE nso.nso_column_head
--     ADD CONSTRAINT fk_nso_log_idents_nso_column_head FOREIGN KEY (log_id)
--        REFERENCES nso.nso_log (id_log)
--        ON DELETE RESTRICT ON UPDATE RESTRICT;      
--      
      
ALTER TABLE nso.nso_key
   ADD CONSTRAINT fk_nso_object_has_nso_key FOREIGN KEY (nso_id)
      REFERENCES nso.nso_object (nso_id)
      ON DELETE RESTRICT ON UPDATE RESTRICT;

ALTER TABLE nso.nso_key
   ADD CONSTRAINT fk_obj_codifier_define_key_type FOREIGN KEY (key_type_id)
      REFERENCES com.obj_codifier (codif_id)
      ON DELETE RESTRICT ON UPDATE RESTRICT;

-- ALTER TABLE nso.nso_key
--    ADD CONSTRAINT fk_nso_log_idents_nso_key FOREIGN KEY (log_id)
--       REFERENCES nso.nso_log (id_log)
--       ON DELETE RESTRICT ON UPDATE RESTRICT;
--      
--      
ALTER TABLE nso.nso_key_attr
   ADD CONSTRAINT fk_nso_column_head_may_be_nso_key_attr FOREIGN KEY (col_id)
      REFERENCES nso.nso_column_head (col_id)
      ON DELETE RESTRICT ON UPDATE RESTRICT;

ALTER TABLE nso.nso_key_attr
   ADD CONSTRAINT fk_nso_key_nas_key_attr FOREIGN KEY (key_id)
      REFERENCES nso.nso_key (key_id)
      ON DELETE RESTRICT ON UPDATE RESTRICT;
      
-- ALTER TABLE nso.nso_key_attr
--    ADD CONSTRAINT fk_nso_log_idents_nso_key_attr FOREIGN KEY (log_id)
--       REFERENCES nso.nso_log (id_log)
--       ON DELETE RESTRICT ON UPDATE RESTRICT;
      
--
-- 2019-07-11
--
ALTER TABLE nso.nso_object
   ADD CONSTRAINT fk_nso_section_has_nso_object FOREIGN KEY (section_number)
      REFERENCES nso.nso_section (section_number)
      ON DELETE RESTRICT ON UPDATE RESTRICT;
--
ALTER TABLE nso.nso_object
   ADD CONSTRAINT fk_nso_object_grouping_nso_object FOREIGN KEY (parent_nso_id)
      REFERENCES nso.nso_object (nso_id)
      ON DELETE RESTRICT ON UPDATE RESTRICT;

ALTER TABLE nso.nso_object
   ADD CONSTRAINT fk_obj_codifier_typify_nso_object FOREIGN KEY (nso_type_id)
      REFERENCES com.obj_codifier (codif_id)
      ON DELETE RESTRICT ON UPDATE RESTRICT;
--
ALTER TABLE nso.nso_record
   ADD CONSTRAINT fk_nso_object_contains_nso_records FOREIGN KEY (nso_id)
      REFERENCES nso.nso_object (nso_id)
      ON DELETE RESTRICT ON UPDATE RESTRICT;

ALTER TABLE nso.nso_record
   ADD CONSTRAINT fk_nso_rec_groups_nso_rec FOREIGN KEY (parent_rec_id)
      REFERENCES nso.nso_record (rec_id)
      ON DELETE RESTRICT ON UPDATE RESTRICT;
--
-- -----------------------------------------------------------------------------
--
-- ALTER TABLE nso.nso_object
--    ADD CONSTRAINT fk_nso_log_idents_nso_obj FOREIGN KEY (id_log)
--       REFERENCES nso.nso_log (id_log)
--       ON DELETE RESTRICT ON UPDATE RESTRICT;

-- ALTER TABLE nso.nso_record
--     ADD CONSTRAINT fk_nso_log_idents_nso_rec FOREIGN KEY (log_id)
--        REFERENCES nso.nso_log (id_log)
--        ON DELETE RESTRICT ON UPDATE RESTRICT;
--        
-- ALTER TABLE nso.nso_section
--     ADD CONSTRAINT fk_nso_log_idents_nso_section FOREIGN KEY (log_id)
--        REFERENCES nso.nso_log (id_log)
--        ON DELETE RESTRICT ON UPDATE RESTRICT;
       
------------------------------------------------------------------
-- Из унаследованных таблиц
------------------------------------------------------------------
-- alter table nso.nso_abs_hist
--    add constraint fk_nso_log_idents_nso_abs_hist foreign key (log_id)
--       references nso.nso_log (id_log)
--       on delete restrict on update restrict;
-- --
-- 
-- alter table nso.nso_blob_hist
--    add constraint fk_nso_log_idents_nso_blob_hist foreign key (log_id)
--       references nso.nso_log (id_log)
--       on delete restrict on update restrict;
-- --
-- 
-- alter table nso.nso_column_head_hist
--    add constraint fk_nso_log_idents_nso_column_head_hist foreign key (log_id)
--       references nso.nso_log (id_log)
--       on delete restrict on update restrict;
-- --
-- alter table nso.nso_key_attr_hist
--    add constraint fk_nso_log_idents_nso_key_attr_hist foreign key (log_id)
--       references nso.nso_log (id_log)
--       on delete restrict on update restrict;
-- --
-- alter table nso.nso_key_hist
--    add constraint fk_nso_log_idents_nso_key_hist foreign key (log_id)
--       references nso.nso_log (id_log)
--       on delete restrict on update restrict;
-- --
-- 
-- alter table nso.nso_record_hist
--    add constraint fk_nso_log_idents_nso_rec_hist foreign key (log_id)
--       references nso.nso_log (id_log)
--       on delete restrict on update restrict;
-- --
-- alter table nso.nso_ref_hist
--    add constraint fk_nso_log_idents_nso_ref_hist foreign key (log_id)
--       references nso.nso_log (id_log)
--       on delete restrict on update restrict;
--
-- alter table nso.nso_object_hist
--    add constraint fk_nso_log_idents_nso_obj_hist foreign key (id_log)
--       references nso.nso_log (id_log)
--       on delete restrict on update restrict;
       
-- --
-- alter table nso.nso_ref_hist
--    add constraint fk_nso_log_idents_nso_ref_hist foreign key (log_id)
--       references nso.nso_log (id_log)
--       on delete restrict on update restrict;
--
----------------------------------------------------------------------
