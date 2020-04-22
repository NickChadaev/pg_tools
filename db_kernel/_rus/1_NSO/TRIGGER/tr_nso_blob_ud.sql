-- ====================================================================================================================
-- Author: Gregory
-- Create date: 2015-09-06
-- Description:	Триггер, обрабатывающий события UPDATE и DELETE таблицы nso.nso_blob
--   2015-10-03  Nick внёс изменения в текст сообщения.
--   2015-11-22  Gregory. Явное указание перечня столбцов. Ревизия 1122.
--   2020-03-30  Nick Новое ядро
-- ====================================================================================================================
SET search_path = nso, public;

DROP TRIGGER IF EXISTS tr_nso_blob_ud ON nso.nso_blob CASCADE;
DROP FUNCTION IF EXISTS nso.tr_nso_blob_ud() CASCADE;

CREATE OR REPLACE FUNCTION nso.tr_nso_blob_ud()
RETURNS TRIGGER AS
$$
 BEGIN
  IF TG_OP = 'UPDATE'
	THEN
		NEW.log_id = nso.nso_p_nso_log_i('4','Обновление данных "NSO_BLOB", ID записи: ' || NEW.rec_id);
		OLD.is_actual = FALSE;
		INSERT INTO nso.nso_blob_hist
                (  rec_id
                  ,col_id
                  ,is_actual
                  ,log_id
                  ,s_type_code        
                  ,section_number    -- Номер секции  Nick 2019-07-11/2020-01-21
                  ,val_cel_hash
                  ,val_cel_data_name
                  ,val_cell_blob
                  
                ) VALUES ( OLD.rec_id
                          ,OLD.col_id
                          ,OLD.is_actual
                          ,OLD.log_id
                          ,OLD.s_type_code
                          ,OLD.section_number
                          ,OLD.val_cel_hash
                          ,OLD.val_cel_data_name
                          ,OLD.val_cell_blob
                );
		RETURN NEW;
	ELSIF TG_OP = 'DELETE'
	THEN
		OLD.log_id = nso.nso_p_nso_log_i('5','Удаление данных "NSO_BLOB", ID записи: ' || OLD.rec_id);
		OLD.is_actual = FALSE;
		INSERT INTO nso.nso_blob_hist
                (   rec_id
                   ,col_id
                   ,is_actual
                   ,log_id
                   ,s_type_code
                   ,section_number    -- Номер секции  Nick 2019-07-11/2020-01-21
                   ,val_cel_hash
                   ,val_cel_data_name
                   ,val_cell_blob
                   
                ) VALUES(OLD.rec_id
                        ,OLD.col_id
                        ,OLD.is_actual
                        ,OLD.log_id
                        ,OLD.s_type_code
                        ,OLD.section_number
                        ,OLD.val_cel_hash
                        ,OLD.val_cel_data_name
                        ,OLD.val_cell_blob
                );
		RETURN OLD;
  END IF;
 END;
$$
LANGUAGE plpgsql 
SECURITY DEFINER; -- Nick 2016-02-26

COMMENT ON FUNCTION nso.tr_nso_blob_ud() IS '286: Триггер, обрабатывающий события UPDATE и DELETE таблицы nso.nso_blob фиксирует изменения в nso.nso_blob_hist';

-- Применение триггера
CREATE TRIGGER tr_nso_blob_ud BEFORE UPDATE OR DELETE ON nso.nso_blob_0 -- Nick 2020-03-30
FOR EACH ROW EXECUTE PROCEDURE nso.tr_nso_blob_ud();

-- SELECT * FROM nso.nso_blob WHERE rec_id =
-- SELECT * FROM ONLY nso.nso_blob WHERE rec_id =
-- SELECT * FROM nso.nso_blob_hist WHERE rec_id =

-- UPDATE ONLY nso.nso_blob SET log_id = log_id WHERE rec_id =
-- SELECT * FROM session_nso_log

-- ----------------------
--  2020-03-30
-- ОШИБКА:  "nso_blob" - секционированная таблица
-- ПОДРОБНОСТИ:  В секционированных таблицах не может быть триггеров BEFORE / FOR EACH ROW.
-- 
-- ********** Ошибка **********
-- 
-- ОШИБКА: "nso_blob" - секционированная таблица
-- SQL-состояние: 42809
-- Подробности: В секционированных таблицах не может быть триггеров BEFORE / FOR EACH ROW.

