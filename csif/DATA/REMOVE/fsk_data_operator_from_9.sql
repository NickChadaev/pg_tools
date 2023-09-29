--
--    2023-08-07
--
BEGIN;
COMMIT;
ROLLBACK;

INSERT INTO fiscalization.fsc_data_operator (
	id_fsc_data_operator, dt_create, dt_update, ofd_inn, nm_ofd, ofd_site, ofd_status, nm_ofd_full, fns_info
)
SELECT id_fsc_data_operator, dt_create, dt_update, ofd_inn, nm_ofd, ofd_site, ofd_status, nm_ofd_full, fns_info
 FROM "_OLD_9_fiscalization".fsc_data_operator;	
 --
 SELECT id_fsc_data_operator, dt_create, dt_update, ofd_inn, nm_ofd, ofd_site, ofd_status, nm_ofd_full, fns_info
 FROM fiscalization.fsc_data_operator;	