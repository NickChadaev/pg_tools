ALTER TABLE obj_object ADD CONSTRAINT fk_nso_record_is_owner_obj_object FOREIGN KEY (object_owner_id) REFERENCES nso_record(rec_id) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE obj_object ADD CONSTRAINT fk_nso_record_defines_object_secret_level FOREIGN KEY (object_secret_id) REFERENCES nso_record(rec_id) ON DELETE NO ACTION ON UPDATE NO ACTION;
