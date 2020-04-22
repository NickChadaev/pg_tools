ALTER TABLE nso_object ADD CONSTRAINT fk_nso_section_has_nso_object FOREIGN KEY (section_number) REFERENCES nso_section(section_number) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE nso_object ADD CONSTRAINT k_nso_object_grouping_nso_object FOREIGN KEY (parent_nso_id) REFERENCES nso_object(nso_id) ON DELETE NO ACTION ON UPDATE NO ACTION;
