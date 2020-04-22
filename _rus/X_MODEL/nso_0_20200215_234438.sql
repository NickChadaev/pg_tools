ALTER TABLE nso_ref ADD CONSTRAINT fk_nso_head_is_owner_nso_ref FOREIGN KEY (col_id) REFERENCES nso_column_head(col_id) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE nso_ref ADD CONSTRAINT fk_nso_record_has_nso_ref FOREIGN KEY (rec_id) REFERENCES nso_record(rec_id) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE nso_ref ADD CONSTRAINT fk_nso_log_idents_nso_ref FOREIGN KEY (log_id) REFERENCES nso_log(id_log) ON DELETE NO ACTION ON UPDATE NO ACTION;
