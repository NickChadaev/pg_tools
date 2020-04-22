ALTER TABLE exn_obj_relation ADD CONSTRAINT fk_exn_obj_relation_links_paren_obj_object FOREIGN KEY (exn_parent_object_id) REFERENCES obj_object(object_id) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE exn_obj_relation ADD CONSTRAINT fk_exn_obj_relation_links_child_obj_object FOREIGN KEY (exn_obj_object_id) REFERENCES obj_object(object_id) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE exn_obj_relation ADD CONSTRAINT fk_obj_codifier_defines_type_exn_obj_relation FOREIGN KEY (exn_perm_type_id) REFERENCES obj_codifier(codif_id) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE exn_obj_relation ADD CONSTRAINT fk_exn_obj_relation_hase_com_log FOREIGN KEY (id_log) REFERENCES com_log(id_log) ON DELETE NO ACTION ON UPDATE NO ACTION;
