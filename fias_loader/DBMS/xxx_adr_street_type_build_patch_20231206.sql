-- ----------------------------------------------------------------------
--    2023-12-06  
-- ----------------------------------------------------------------------
--  1) Справочник adr_street_type  -- Пропущённый тип (Маринчук, е... тебя да за ногу, да об забор)
-- --------------------------------------------------------------------------------------------------
BEGIN;
  INSERT INTO gar_tmp.adr_street_type(
      id_street_type, nm_street_type, nm_street_type_short, dt_data_del)
      VALUES ((SELECT max(id_street_type) + 1 FROM gar_tmp.adr_street_type)
            , 'Съезд'
            , 'сзд.'
            , NULL
  );
  --
  INSERT INTO gar_tmp.xxx_adr_street_type (
      fias_ids
     ,id_street_type
     ,fias_type_name
     ,nm_street_type
     ,fias_type_shortname
     ,nm_street_type_short
     ,fias_row_key
     ,is_twin
   )    
      VALUES (
              ARRAY[190]::bigint[]
             ,(SELECT max(id_street_type) FROM gar_tmp.adr_street_type)
             ,'Съезд'
             ,'Съезд'
             ,'сзд.'
             ,'сзд.'
             ,gar_tmp_pcg_trans.f_xxx_replace_char('Съезд')
             ,TRUE
  )
     ON CONFLICT (fias_row_key) DO NOTHING;
 
  SELECT * FROM gar_tmp_pcg_trans.f_zzz_street_type_show_tmp_data ('gar_tmp') 
     WHERE (id_street_type = (SELECT max(id_street_type) FROM gar_tmp.adr_street_type));
--
-- select * from gar_tmp.adr_street_type order by id_street_type;
-- ROLLBACK;
COMMIT;

