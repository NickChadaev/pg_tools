BEGIN;
ROLLBACK;
SELECT fias_ids, id_area_type, fias_type_name, nm_area_type, fias_type_shortname, nm_area_type_short, pr_lead, fias_row_key, is_twin
	FROM gar_tmp.xxx_adr_area_type WHERE (id_area_type = 40);

UPDATE gar_tmp.xxx_adr_area_type SET fias_ids = fias_ids || 44::bigint WHERE (id_area_type = 40);
COMMIT;
	