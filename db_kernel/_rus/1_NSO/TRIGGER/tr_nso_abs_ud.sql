SET search_path = nso, public;
DROP TRIGGER IF EXISTS tr_nso_abs_ud ON nso.nso_abs CASCADE;
DROP FUNCTION IF EXISTS nso.tr_nso_abs_ud() CASCADE;
CREATE OR REPLACE FUNCTION nso.tr_nso_abs_ud()
RETURNS TRIGGER AS
$$
-- ======================================================================================== --
-- Author: Gregory                                                                          --
-- Create date: 2015-08-29                                                                  --
-- Description:	Триггер, обрабатывающий события UPDATE и DELETE таблицы nso.nso_abs         --
--   2015-10-03  Nick внёс изменения в текст сообщения.                                     --
--   2015-11-22  Gregory - явный перечень столбцов. Ревизия 1122.                           --
--   2020-01-30  Nick Новое ядро. Столбец "section_number".                                 --
-- ======================================================================================== --
 BEGIN
  IF TG_OP = 'UPDATE'
	THEN
		NEW.log_id = nso.nso_p_nso_log_i('4','Обновление данных "NSO_ABS", ID записи: ' || NEW.rec_id);
		OLD.is_actual = FALSE;
		INSERT INTO nso.nso_abs_hist
                (       rec_id
                       ,col_id
                       ,s_type_code
                       ,s_key_code
                       ,section_number  -- Nick 2019-07-11/2020-01-30
                       ,is_actual
                       ,log_id
                       ,val_cell_abs
                ) VALUES (
                        OLD.rec_id
                       ,OLD.col_id
                       ,OLD.s_type_code
                       ,OLD.s_key_code
                       ,OLD.section_number
                       ,OLD.is_actual
                       ,OLD.log_id
                       ,OLD.val_cell_abs
                );
		RETURN NEW;
	ELSIF TG_OP = 'DELETE'
	THEN
		OLD.log_id = nso.nso_p_nso_log_i ('5','Удаление данных "NSO_ABS", ID записи: ' || OLD.rec_id);
		OLD.is_actual = FALSE;
		INSERT INTO nso.nso_abs_hist
                (       rec_id
                       ,col_id
                       ,s_type_code
                       ,s_key_code
                       ,section_number  -- Nick 2019-07-11/2020-01-30
                       ,is_actual
                       ,log_id
                       ,val_cell_abs
                ) VALUES (
                        OLD.rec_id
                       ,OLD.col_id
                       ,OLD.s_type_code
                       ,OLD.s_key_code
                       ,OLD.section_number
                       ,OLD.is_actual
                       ,OLD.log_id
                       ,OLD.val_cell_abs
                );
		RETURN OLD;
	END IF;
 END;
$$
LANGUAGE plpgsql
SECURITY DEFINER; -- Nick 2016-02-26

COMMENT ON FUNCTION nso.tr_nso_abs_ud() IS '286: Триггер, обрабатывающий события UPDATE и DELETE таблицы nso.nso_abs фиксирует изменения в nso.nso_abs_hist';

-- Применение триггера
CREATE TRIGGER tr_nso_abs_ud BEFORE UPDATE OR DELETE ON nso.nso_abs_0
FOR EACH ROW EXECUTE PROCEDURE nso.tr_nso_abs_ud();

-- SELECT * FROM nso.nso_abs WHERE rec_id = 
-- SELECT * FROM ONLY nso.nso_abs WHERE rec_id = 
-- SELECT * FROM nso.nso_abs_hist WHERE rec_id = 

-- UPDATE ONLY nso.nso_abs SET log_id = log_id WHERE rec_id =
-- SELECT * FROM session_nso_log

