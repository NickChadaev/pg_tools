ALTER TABLE obj_object ADD CONSTRAINT fk_obj_codifier_can_defines_object_stype FOREIGN KEY (object_stype_id) REFERENCES obj_codifier(codif_id) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE obj_object ADD CONSTRAINT fk_obj_object_can_have_com_log FOREIGN KEY (id_log) REFERENCES com_log(id_log) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE obj_object ADD CONSTRAINT fk_obj_codifier_defines_object_type FOREIGN KEY (object_type_id) REFERENCES obj_codifier(codif_id) ON DELETE NO ACTION ON UPDATE NO ACTION;
