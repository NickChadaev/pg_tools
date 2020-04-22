SET search_path = nso, public;

DROP TRIGGER IF EXISTS tr_nso_ref_ud ON nso.nso_ref;
DROP FUNCTION IF EXISTS nso.tr_nso_ref_ud();

CREATE OR REPLACE FUNCTION nso.tr_nso_ref_ud()
RETURNS TRIGGER AS	
$$
-- ======================================================================================= --
-- Author: Gregory                                                                         --
-- Create date: 2015-09-06                                                                 --
-- Description:	Триггер, обрабатывающий события UPDATE и DELETE таблицы nso.nso_ref        --
--   2015-10-03   Nick внёс изменения в текст сообщения.                                   --
--   2015-11-22  Gregory. Явное указание перечня столбцов. Ревизия 1122.                   --
--   2020-01-30  Nick. Новое ядро.                                                         -- 
-- ======================================================================================= --
 BEGIN
        IF TG_OP = 'UPDATE'
	THEN
		NEW.log_id = nso.nso_p_nso_log_i ('4','Обновление данных "NSO_REF", ID записи: ' || NEW.rec_id);
		OLD.is_actual = FALSE;
		INSERT INTO nso.nso_ref_hist
                (
                        rec_id
                       ,col_id
                       ,is_actual
                       ,log_id
                       ,ref_rec_id
                ) VALUES(
                        OLD.rec_id
                       ,OLD.col_id
                       ,OLD.is_actual
                       ,OLD.log_id
                       ,OLD.ref_rec_id
                );
		RETURN NEW;
	ELSIF TG_OP = 'DELETE'
	THEN
		OLD.log_id = nso.nso_p_nso_log_i ('5','Удаление данных "NSO_REF", ID записи: ' || OLD.rec_id);
		OLD.is_actual = FALSE;
		
		INSERT INTO nso.nso_ref_hist
                (
                        rec_id
                       ,col_id
                       ,is_actual
                       ,log_id
                       ,ref_rec_id
                ) VALUES(
                        OLD.rec_id
                       ,OLD.col_id
                       ,OLD.is_actual
                       ,OLD.log_id
                       ,OLD.ref_rec_id
                );
		RETURN OLD;
	END IF;
 END;
$$
LANGUAGE plpgsql 
SECURITY DEFINER; -- Nick 2016-02-26

COMMENT ON FUNCTION nso.tr_nso_ref_ud() IS '265: Триггер, обрабатывающий события UPDATE и DELETE таблицы nso.nso_ref фиксирует изменения в nso.nso_ref_hist';

-- Применение триггера
CREATE TRIGGER tr_nso_ref_ud BEFORE UPDATE OR DELETE ON nso.nso_ref
FOR EACH ROW EXECUTE PROCEDURE nso.tr_nso_ref_ud();

-- SELECT * FROM nso.nso_ref WHERE rec_id =
-- SELECT * FROM ONLY nso.nso_ref WHERE rec_id =
-- SELECT * FROM nso.nso_ref_hist WHERE rec_id =

-- UPDATE ONLY nso.nso_ref SET log_id = log_id WHERE rec_id =
-- SELECT * FROM session_nso_log

