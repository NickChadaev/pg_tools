SELECT gar_link.f_server_crt ('unnsi_prd_et', '10.196.35.165', 'unnsi_prd_et', 5432, 'postgres', 'postgres', ''); --1
SELECT gar_link.f_schema_import ('unnsi_prd_et', 'unnsi', 'unsi', 'ЭТАЛОН от 2022-12-15'); -- 2

SELECT * FROM unsi.adr_area;
SELECT * FROM unsi.adr_area WHERE (nm_fias_guid = '1a91684d-7af5-4f5e-acf3-d33fe8e3351a');
SELECT * FROM unsi.adr_area WHERE (nm_zipcode = '368160');


SELECT * FROM gar_tmp.adr_area WHERE (nm_fias_guid = '1a91684d-7af5-4f5e-acf3-d33fe8e3351a');
SELECT * FROM gar_tmp.adr_area WHERE (nm_zipcode = '368160'); 

CALL gar_tmp_pcg_trans.p_adr_area_upd_single ('gar_tmp', 'gar_tmp', '1a91684d-7af5-4f5e-acf3-d33fe8e3351a');

                           SELECT id_area
                                , id_country
                                , nm_area
                                , nm_area_full
                                , id_area_type
                                , id_area_parent
                                , kd_timezone
                                , pr_detailed
                                , kd_oktmo
                                , nm_fias_guid
                                , dt_data_del
                                , id_data_etalon
                                , kd_okato
                                , nm_zipcode
                                , kd_kladr
                                , vl_addr_latitude
                                , vl_addr_longitude
                           FROM gar_tmp.adr_area  
                           
                           WHERE (nm_fias_guid = '1a91684d-7af5-4f5e-acf3-d33fe8e3351a') AND
                            (id_data_etalon IS NULL) AND (dt_data_del IS NULL);

--
SELECT * FROM gar_tmp.adr_area WHERE (nm_fias_guid = '1a91684d-7af5-4f5e-acf3-d33fe8e3351a');
--
CALL gar_tmp_pcg_trans.p_adr_area_upd_single ('gar_tmp', 'gar_tmp', '1a91684d-7af5-4f5e-acf3-d33fe8e3351a', p_nm_zipcode := '368177'); -- столбец "p_nm_zipcode" не существует
CALL gar_tmp_pcg_trans.p_adr_area_upd_single ('gar_tmp', 'gar_tmp', '1a91684d-7af5-4f5e-acf3-d33fe8e3351a', p_id_country := 185 ); 
CALL gar_tmp_pcg_trans.p_adr_area_upd_single ('gar_tmp', 'gar_tmp', '1a91684d-7af5-4f5e-acf3-d33fe8e3351a', 999 ); 
CALL gar_tmp_pcg_trans.p_adr_area_upd_single ('gar_tmp', 'gar_tmp', '1a91684d-7af5-4f5e-acf3-d33fe8e3351a', 999 ); 
--
SELECT * FROM gar_tmp.adr_area WHERE (nm_fias_guid = '1a91684d-7af5-4f5e-acf3-d33fe8e3351a');
SELECT * FROM gar_tmp.adr_area_aux WHERE (id_area = 10461);
SELECT * FROM gar_tmp.adr_area_hist WHERE (id_area = 10461) ORDER BY date_create DESC;
--
CALL gar_tmp_pcg_trans.p_adr_area_upd_single ('gar_tmp', 'gar_tmp', '1a91684d-7af5-4f5e-acf3-d33fe8e3351a', p_id_country := 185, p_nm_zipcode := '368160',  p_nm_area := 'Хрень'); 

SELECT * FROM gar_tmp.adr_area WHERE (nm_fias_guid = '1a91684d-7af5-4f5e-acf3-d33fe8e3351a');
SELECT * FROM gar_tmp.adr_area_aux WHERE (id_area = 10461);
SELECT * FROM gar_tmp.adr_area_hist WHERE (id_area = 10461) ORDER BY date_create DESC;

CALL gar_tmp_pcg_trans.p_adr_area_upd_single ('gar_tmp', 'gar_tmp', '1a91684d-7af5-4f5e-acf3-d33fe8e3351a', p_nm_area := 'Чапаево'); 

SELECT * FROM gar_tmp.adr_area WHERE (nm_fias_guid = '1a91684d-7af5-4f5e-acf3-d33fe8e3351a');
SELECT * FROM gar_tmp.adr_area_aux WHERE (id_area = 10461);
SELECT * FROM gar_tmp.adr_area_hist WHERE (id_area = 10461) ORDER BY date_create DESC;

CALL gar_tmp_pcg_trans.p_adr_area_upd_single ('gar_tmp', 'gar_tmp', '3f91684d-7af5-4f5e-acf3-d33fe8e3351a', p_nm_area := 'Дурь'); ---- bad uuid

SELECT * FROM gar_tmp.adr_area WHERE (nm_fias_guid = '1a91684d-7af5-4f5e-acf3-d33fe8e3351a'); 
SELECT * FROM gar_tmp.adr_area_aux WHERE (id_area = 10461);
SELECT * FROM gar_tmp.adr_area_hist WHERE (id_area = 10461) ORDER BY date_create DESC;

