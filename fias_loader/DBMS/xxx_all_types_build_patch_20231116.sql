SELECT * FROM gar_tmp.adr_area_type ORDER BY id_area_type;
SELECT * FROM gar_tmp.adr_area_type WHERE (dt_data_del IS NOT NULL);

BEGIN;
ROLLBACK;
WITH x (
         id_area_type
       )
        AS (
             SELECT id_area_type FROM gar_tmp_pcg_trans.f_zzz_adr_area_type_show_tmp_data ('gar_tmp') WHERE (id_area_type_tmp IS NULL)
        )
 UPDATE gar_tmp.adr_area_type AS z
     SET dt_data_del = '2023-11-15 00:00:00'
 FROM x 
 WHERE (z.id_area_type = x.id_area_type);    

 --------------------------------------------
SELECT * FROM gar_tmp.adr_street_type ORDER BY id_street_type;
SELECT * FROM gar_tmp.adr_street_type WHERE (dt_data_del IS NOT NULL);

BEGIN;
ROLLBACK;

 WITH x (
         id_street_type
       )
        AS (
             SELECT id_street_type FROM gar_tmp_pcg_trans.f_zzz_street_type_show_tmp_data ('gar_tmp') WHERE (id_street_type_tmp IS NULL)
        )
 UPDATE gar_tmp.adr_street_type AS z
     SET dt_data_del = '2023-11-15 00:00:00'
 FROM x 
 WHERE (z.id_street_type = x.id_street_type);  
 