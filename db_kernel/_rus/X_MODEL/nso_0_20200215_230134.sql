ALTER TABLE nso_record ADD CONSTRAINT fk_nso_log_idents_nso_rec FOREIGN KEY (log_id) REFERENCES nso_log(id_log) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE nso_section ADD CONSTRAINT fk_nso_log_idents_nso_section FOREIGN KEY (log_id) REFERENCES nso_log(id_log) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE nso_column_head ADD CONSTRAINT fk_nso_column_headre_is_parent FOREIGN KEY (parent_col_id) REFERENCES nso_column_head(col_id) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE nso_column_head ADD CONSTRAINT fk_nso_object_has_nso_column_head FOREIGN KEY (nso_id) REFERENCES nso_object(nso_id) ON DELETE NO ACTION ON UPDATE NO ACTION;
