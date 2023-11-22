--
--  2023-11-21  Два дополнительных типа, всё-таки они станут адресными объектами
--

-- SELECT * FROM gar_tmp.adr_area_type ORDER BY id_area_type;
-----------------------------------------------------------
-- 142|'Выселки'|'в-ки'|0|''
-- 143|'Животноводческая точка'|'жт'|0|''
-- 144|'Ферма'|'ферма'|0|''

-- SELECT * FROM gar_tmp.xxx_adr_area_type ORDER BY id_area_type;

INSERT INTO gar_tmp.adr_area_type (
      id_area_type
     ,nm_area_type
     ,nm_area_type_short
     ,pr_lead
)
VALUES (  143
         ,'Животноводческая точка'
         ,'жт'
         ,0 
)
,(  144
   ,'Ферма'
   ,'ферма' 
   ,0
);
--
INSERT INTO gar_tmp.xxx_adr_area_type (
     fias_ids
     ,id_area_type
     ,fias_type_name
     ,nm_area_type
     ,fias_type_shortname
     ,nm_area_type_short
     ,pr_lead
     ,fias_row_key
     ,is_twin
 )    
   VALUES (
             ARRAY[135,364]::bigint[]
            ,143
            ,'Животноводческая точка'
            ,'Животноводческая точка'
            ,'жт'
            ,'жт'
            ,0
            ,gar_tmp_pcg_trans.f_xxx_replace_char('Животноводческая точка')
            ,TRUE
)
, (
    ARRAY[208,411]
    ,144
    ,'Ферма'
    ,'Ферма'
    ,'ферма'
    ,'ферма'
    ,0
    ,gar_tmp_pcg_trans.f_xxx_replace_char('Ферма')
    ,TRUE
);
SELECT * FROM gar_tmp_pcg_trans.f_zzz_adr_area_type_show_tmp_data ('gar_tmp') WHERE (id_area_type IN (143,144));
-- SELECT * FROM gar_fias.as_addr_obj_type WHERE (id IN (135,208));
-- SELECT * FROM gar_fias.as_addr_obj_type WHERE (lower(type_name) IN ('животноводческая точка','ферма'));
--------------------------------------------------------------------------------------------------------
-- 135|'8'|'Животноводческая точка'|'жт'|'Животноводческая точка'|'1900-01-01'|'1900-01-01'|'2015-11-05'|t
-- 208|'8'|'Ферма'|'ферма'|'Ферма'|'1900-01-01'|'1900-01-01'|'2015-11-05'|t
-- 364|'16'|'Животноводческая точка'|'жт'|'Животноводческая точка'|'1900-01-01'|'1900-01-01'|'2015-12-31'|t
-- 411|'16'|'Ферма'|'ферма'|'Ферма'|'1900-01-01'|'1900-01-01'|'2015-12-31'|t
