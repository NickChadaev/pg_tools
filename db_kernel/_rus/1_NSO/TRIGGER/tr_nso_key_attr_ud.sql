SET search_path = nso, public;

DROP TRIGGER IF EXISTS tr_nso_key_attr_ud ON nso.nso_key_attr;
DROP FUNCTION IF EXISTS nso.tr_nso_key_attr_ud ();

CREATE OR REPLACE FUNCTION nso.tr_nso_key_attr_ud()
RETURNS TRIGGER AS
$$
-- ====================================================================================================================
-- Author: Gregory
-- Create date: 2015-08-30
-- Description:	Триггер, обрабатывающий события UPDATE и DELETE таблицы nso.nso_key_attr
--   2015-11-22  Gregory. Явное указание перечня столбцов. Ревизия 1122.
-- ====================================================================================================================
 BEGIN
	IF TG_OP = 'UPDATE'
	THEN
		NEW.log_id = nso.nso_p_nso_log_i('G','Обновление элемента ключа: ' || (SELECT key_code FROM ONLY nso.nso_key WHERE key_id = NEW.key_id));
		NEW.date_from = CURRENT_TIMESTAMP::public.t_timestamp;
		OLD.date_to = NEW.date_from;
		INSERT INTO nso.nso_key_attr_hist
		(     key_id
             ,col_id
             ,column_nm
             ,date_from
             ,date_to
             ,log_id
                ) VALUES(
                          OLD.key_id
                         ,OLD.col_id
                         ,OLD.column_nm
                         ,OLD.date_from
                         ,OLD.date_to
                         ,OLD.log_id
                );
		RETURN NEW;
	ELSIF TG_OP = 'DELETE'
	THEN
		OLD.log_id = nso.nso_p_nso_log_i('H','Удаление элемента ключа: ' || (SELECT key_code FROM ONLY nso.nso_key WHERE key_id = OLD.key_id));
		OLD.date_to = CURRENT_TIMESTAMP::public.t_timestamp;
		INSERT INTO nso.nso_key_attr_hist
		(
             key_id
            ,col_id
            ,column_nm
            ,date_from
            ,date_to
            ,log_id
                ) VALUES(
                         OLD.key_id
                        ,OLD.col_id
                        ,OLD.column_nm
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

COMMENT ON FUNCTION nso.tr_nso_key_attr_ud() IS '265: Триггер, обрабатывающий события UPDATE и DELETE таблицы nso.nso_key_attr
	фиксирует изменения в nso.nso_key_attr_hist';

-- Применение триггера
CREATE TRIGGER tr_nso_key_attr_ud BEFORE UPDATE OR DELETE ON nso.nso_key_attr
FOR EACH ROW EXECUTE PROCEDURE nso.tr_nso_key_attr_ud();

-- SELECT * FROM nso.nso_key_attr WHERE key_id = 3 AND col_id = 14
-- SELECT * FROM ONLY nso.nso_key_attr
-- SELECT * FROM nso.nso_key_attr_hist

-- UPDATE ONLY nso.nso_key_attr SET log_id = log_id WHERE key_id = 3 AND col_id = 14

