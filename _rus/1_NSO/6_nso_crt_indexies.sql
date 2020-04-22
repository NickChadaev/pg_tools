-- ------------------------------------------------------------------------------
-- Дополнительные поисковые индексы с частичным покрытием. Только для nso.nso_abs_0. 
-- 2015-07-04  Nick
-- 2016-06-30  Nick Индекс всё-же строится на основе "val_cell_abs"
-- 2020-01-21 Начальные секции  
-- ------------------------------------------------------------------------------
--+  41|5|'a'|'AKKEY1'|'Уникальный ключ 1'
--+  42|5|'b'|'AKKEY2'|'Уникальный ключ 2'
--+  43|5|'c'|'AKKEY3'|'Уникальный ключ 3'
--+  44|5|'d'|'PKKEY' |'Идентификационный ключ'
--+  45|5|'e'|'IEKEY' |'Поисковый ключ'
--   46|5|'f'|'FKKEY' |'Ссылочный ключ'
--+  47|5|'g'|'DEFKEY'|'Значение по умолчанию'
-----------------------------------------------
                                               

SET search_path=nso,com,public,pg_catalog;

DROP INDEX IF EXISTS IE_a_nso_abs;
CREATE INDEX IE_a_nso_abs ON nso_abs (val_cell_abs) WHERE ( s_key_code = 'a');
COMMENT ON INDEX IE_a_nso_abs IS 'a, AKKEY1 - Уникальный ключ 1';
-- 
DROP INDEX IF EXISTS IE_b_nso_abs;
CREATE INDEX IE_b_nso_abs ON nso_abs (val_cell_abs) WHERE ( s_key_code = 'b');
COMMENT ON INDEX IE_b_nso_abs IS 'b, AKKEY2 - Уникальный ключ 2';
-- 
DROP INDEX IF EXISTS IE_c_nso_abs;
CREATE INDEX IE_c_nso_abs ON nso_abs (val_cell_abs) WHERE ( s_key_code = 'c');
COMMENT ON INDEX IE_c_nso_abs IS 'c, AKKEY3 - Уникальный ключ 3';
-- 
DROP INDEX IF EXISTS IE_d_nso_abs;
CREATE INDEX IE_d_nso_abs ON nso_abs (val_cell_abs) WHERE ( s_key_code = 'd');
COMMENT ON INDEX IE_d_nso_abs IS 'd, PKKEY - Идентификационный ключ';
-- 
DROP INDEX IF EXISTS IE_e_nso_abs;
CREATE INDEX IE_e_nso_abs ON nso_abs (val_cell_abs) WHERE ( s_key_code = 'e');
COMMENT ON INDEX IE_e_nso_abs IS 'e, IEKEY - Поисковый ключ';
-- 
--
DROP INDEX IF EXISTS IE_g_nso_abs;
CREATE INDEX IE_g_nso_abs ON nso_abs (val_cell_abs) WHERE ( s_key_code = 'g');
COMMENT ON INDEX IE_g_nso_abs IS 'g, DEFKEY - Значение по умолчанию';
-- 
-- SELECT * FROM ONLY nso_abs WHERE  ( s_key_code = 'g'); -- 30 ms 521 строка
-- SELECT * FROM ONLY nso_abs WHERE  ( s_key_code = '0');
