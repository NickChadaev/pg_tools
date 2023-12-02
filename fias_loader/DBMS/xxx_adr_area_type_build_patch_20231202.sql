-- ---------------------------------------------------------------------------------
--  2023-12-02   Промзона
-- ---------------------------------------------------------------------------------

-- SELECT * FROM gar_tmp.adr_area_type ORDER BY id_area_type;
BEGIN;
  UPDATE gar_tmp.xxx_adr_area_type  
     SET fias_ids = FIAS_IDS || 177::bigint
  WHERE (id_area_type = 39);
 
  SELECT * FROM gar_tmp_pcg_trans.f_zzz_adr_area_type_show_tmp_data ('gar_tmp') 
  WHERE (id_area_type = 39);
-- ROLLBACK;
COMMIT;
