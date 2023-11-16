-- ===========================================================
--  2023-11-16 Справочник адресных регионов и улиц. 
--          Логическое удалениек не используемых более улиц.
--   Выполнять на одной из баз кластера Big_2 после наката функционального пакета
--   "gar_tmp_trans_pcg" и патчей "xxx_all_types_build_patch_20231108.sql", 
--   "xxx_all_types_build_patch_20231115.sql"
-- ===========================================================

BEGIN;
   WITH x (
           id_area_type
       )
        AS (
             SELECT id_area_type 
             FROM gar_tmp_pcg_trans.f_zzz_adr_area_type_show_tmp_data ('unnsi') 
             WHERE (id_area_type_tmp IS NULL)
        )
    UPDATE unnsi.adr_area_type AS z SET dt_data_del = '2023-11-15 00:00:00'
    FROM x 
    WHERE (z.id_area_type = x.id_area_type);    

    SELECT * FROM unnsi.adr_area_type ORDER BY id_area_type;
COMMIT; 
-- ROLLBACK;
-- SELECT * FROM gar_tmp.adr_area_type WHERE (dt_data_del IS NOT NULL);
 
 --------------------------------------------

BEGIN;
   WITH x (
           id_street_type
       )
        AS (
             SELECT id_street_type 
             FROM gar_tmp_pcg_trans.f_zzz_street_type_show_tmp_data ('unnsi') 
             WHERE (id_street_type_tmp IS NULL)
        )
   UPDATE unnsi.adr_street_type AS z SET dt_data_del = '2023-11-15 00:00:00'
   FROM x 
   WHERE (z.id_street_type = x.id_street_type);  
 
   SELECT * FROM unnsi.adr_street_type ORDER BY id_street_type;
COMMIT; 
-- ROLLBACK;
-- SELECT * FROM gar_tmp.adr_street_type WHERE (dt_data_del IS NOT NULL);
 
