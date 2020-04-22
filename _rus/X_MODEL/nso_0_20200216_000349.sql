ALTER TABLE nso_key ADD CONSTRAINT fk_nso_object_has_nso_ke FOREIGN KEY (nso_id) REFERENCES nso_object(nso_id) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE nso_key ADD CONSTRAINT fk_obj_codifier_define_key_type FOREIGN KEY (key_type_id) REFERENCES obj_codifier(codif_id) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE nso_key ADD CONSTRAINT fk_nso_log_idents_nso_key FOREIGN KEY (log_id) REFERENCES nso_log(id_log) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE nso_key_attr ADD CONSTRAINT fk_nso_column_head_may_be_nso_key_attr FOREIGN KEY (col_id) REFERENCES nso_column_head(col_id) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE nso_key_attr ADD CONSTRAINT fk_nso_key_nas_key_attr FOREIGN KEY (key_id) REFERENCES nso_key(key_id) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE nso_key_attr ADD CONSTRAINT fk_nso_log_idents_nso_key_attr FOREIGN KEY (log_id) REFERENCES nso_log(id_log) ON DELETE NO ACTION ON UPDATE NO ACTION;
