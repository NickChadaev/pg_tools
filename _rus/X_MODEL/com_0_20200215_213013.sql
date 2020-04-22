ALTER TABLE com_obj_nso_relation ADD CONSTRAINT fk_com_obj_nso_relation_links_nso_record FOREIGN KEY (nso_record_id) REFERENCES nso_record(rec_id) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE com_obj_nso_relation ADD CONSTRAINT k_com_obj_nso_relation_links_obj_object FOREIGN KEY (obj_object_id) REFERENCES obj_object(object_id) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE com_obj_nso_relation ADD CONSTRAINT fk_obj_codifier_defines_type_obj_nso_relation FOREIGN KEY (perm_type_id) REFERENCES obj_codifier(codif_id) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE com_obj_nso_relation ADD CONSTRAINT fk_com_obj_nso_relation_hase_com_log FOREIGN KEY (id_log) REFERENCES com_log(id_log) ON DELETE NO ACTION ON UPDATE NO ACTION;
