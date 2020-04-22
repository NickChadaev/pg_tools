SET search_path = nso, public;

DROP TRIGGER IF EXISTS tr_nso_key_ud ON nso.nso_key;
DROP FUNCTION IF EXISTS nso.tr_nso_key_ud();

CREATE OR REPLACE FUNCTION nso.tr_nso_key_ud()
RETURNS TRIGGER AS
$$
-- ====================================================================================== --
--  Author: Gregory                                                                       --
--  Create date: 2015-08-30                                                               --
--  Description:	Триггер, обрабатывающий события UPDATE и DELETE таблицы nso.nso_key   --
--    2015-11-22  Gregory. Явное указание перечня столбцов. Ревизия 1122.                 --
-- ====================================================================================== --
 BEGIN
	IF TG_OP = 'UPDATE'
	THEN
		NEW.log_id = nso.nso_p_nso_log_i ('D','Обновление заголовка ключа: ' || NEW.key_code);
		NEW.date_from = CURRENT_TIMESTAMP::public.t_timestamp;
		OLD.date_to = NEW.date_from;
		INSERT INTO nso.nso_key_hist
		(    key_id
            ,nso_id
            ,key_type_id
            ,key_small_code
            ,key_code
            ,on_off
            ,date_from
            ,date_to
            ,log_id
                ) VALUES(
                          OLD.key_id
                         ,OLD.nso_id
                         ,OLD.key_type_id
                         ,OLD.key_small_code
                         ,OLD.key_code
                         ,OLD.on_off
                         ,OLD.date_from
                         ,OLD.date_to
                         ,OLD.log_id
                );
		RETURN NEW;
	ELSIF TG_OP = 'DELETE'
	THEN
		OLD.log_id = nso.nso_p_nso_log_i('E','Удаление заголовка ключа: ' || OLD.key_code);
		OLD.date_to = CURRENT_TIMESTAMP::public.t_timestamp;
		INSERT INTO nso.nso_key_hist
		(    key_id
            ,nso_id
            ,key_type_id
            ,key_small_code
            ,key_code
            ,on_off
            ,date_from
            ,date_to
            ,log_id
                ) VALUES(
                           OLD.key_id
                          ,OLD.nso_id
                          ,OLD.key_type_id
                          ,OLD.key_small_code
                          ,OLD.key_code
                          ,OLD.on_off
                          ,OLD.date_from
                          ,OLD.date_to
                          ,OLD.log_id
                );
		RETURN OLD;
	END IF;
 END;
$$
LANGUAGE plpgsql
SECURITY DEFINER; -- Nick 2016-02-26

COMMENT ON FUNCTION nso.tr_nso_key_ud() IS '265: Триггер, обрабатывающий события UPDATE и DELETE таблицы nso.nso_key
	фиксирует изменения в nso.nso_key_hist';

-- Применение триггера
CREATE TRIGGER tr_nso_key_ud BEFORE UPDATE OR DELETE ON nso.nso_key
FOR EACH ROW EXECUTE PROCEDURE nso.tr_nso_key_ud();

-- SELECT * FROM nso.nso_key WHERE key_id = 33
-- SELECT * FROM ONLY nso.nso_key
-- SELECT * FROM nso.nso_key_hist

-- UPDATE ONLY nso.nso_key SET log_id = log_id WHERE key_id = 33

