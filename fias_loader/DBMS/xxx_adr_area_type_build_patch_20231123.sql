-- ----------------------------------------------------------------------
--    2023-11-23  
-- ----------------------------------------------------------------------
-- -+    1) Справочник adr_area_type
--       -+    2) Накат patch + обновление процессингового пакета.
--       -+?   3) Анализ LOGs, посмотреть убитые ранее дома.  
--       
--                 -- "Километр" уходит в справочник элементов уличной сети
--                    на это нужна модификация спрАвочников, как общего, так и xxx_adr....
--                 
--                 -- функциии создания/обновления элемента уличной сети      
--                    получают дополнение: при поиске "parent", если по завершению
--                    поиска id_area IS NULL, то ищем "parent" в элементах уличной сети и 
--                    забираем оттуда "id_area".
--                    
--                 -- как плохо, что в adr_street нет отношения подчинённости.
--                 
--                 -- процессинговый пакет собираем на ту-же дату, что ивчера.
--                 
--                 -- Ещё один patch
-- --------------------------------------------------------------------------------------------------

--  SELECT * FROM unnsi.adr_area_type WHERE id_area_type = 94;
--  SELECT * FROM unnsi.adr_street_type WHERE (id_street_type = 42);
--  ---------------------------------------------------------------
--  UPDATE unnsi.adr_area_type SET dt_data_del = '2023-11-15'
--  WHERE (id_area_type = 94);
-- --  --
--  UPDATE unnsi.adr_street_type SET dt_data_del = NULL
--  WHERE (id_street_type = 42);

UPDATE gar_tmp.adr_area_type SET dt_data_del = '2023-11-15'
WHERE (id_area_type = 94);
--
DELETE FROM gar_tmp.xxx_adr_area_type WHERE (id_area_type = 94);
--
UPDATE gar_tmp.adr_street_type SET dt_data_del = NULL
WHERE (id_street_type = 42);

-- '{263,141,369}'|94|'Километр'|'Километр'|'км'|'км'|0|'километр'|t

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
             ARRAY[263,141,369]::bigint[]
            ,42
            ,'Километр'
            ,'Километр'
            ,'км'
            ,'км'
            ,gar_tmp_pcg_trans.f_xxx_replace_char('Километр')
            ,TRUE
)
 ON CONFLICT (fias_row_key) DO NOTHING;
 
SELECT * FROM gar_tmp_pcg_trans.f_zzz_street_type_show_tmp_data ('gar_tmp') WHERE (id_street_type = 42);
--

