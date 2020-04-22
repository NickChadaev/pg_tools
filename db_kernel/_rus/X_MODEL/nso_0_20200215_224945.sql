ALTER TABLE nso_log ADD CONSTRAINT pk_nso_log PRIMARY KEY(id_log);
ALTER TABLE nso_object ADD CONSTRAINT fk_nso_log_idents_nso_obj FOREIGN KEY (id_log) REFERENCES nso_log(id_log) ON DELETE NO ACTION ON UPDATE NO ACTION;
