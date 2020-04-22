SET search_path = nso, public;

DROP FUNCTION IF EXISTS nso.tr_nso_record_ud() CASCADE;
CREATE OR REPLACE FUNCTION nso.tr_nso_record_ud()

RETURNS TRIGGER AS
$$
-- ======================================================================================== --
-- Author: Gregory                                                                          -- 
-- Create date: 2015-09-06                                                                  --
-- Description:	Триггер, обрабатывающий события UPDATE и DELETE таблицы nso.nso_record      --
--   2015-10-03   Nick внёс изменения в текст сообщения.                                    --
--   2015-11-22  Gregory. Явное указание перечня столбцов. Ревизия 1122.                    --
--   2020-01-30  Nick Новое ядро. Столбец "section_number".                                 --
-- ======================================================================================== --

 DECLARE
     _nso_code public.t_str60;
 BEGIN
   -- Для описания воздействия
   SELECT nso_code INTO _nso_code
        FROM ONLY nso.nso_object -- fk_nso_object_contains_nso_records
                WHERE (nso_id = OLD.nso_id); -- OLD для UPDATE и DELETE есть всегда

   IF TG_OP = 'UPDATE'
	 THEN
       NEW.log_id    = nso.nso_p_nso_log_i('4','Обновление данных: "' || _nso_code || '", ID записи: ' || OLD.rec_id);
       NEW.date_from = CURRENT_TIMESTAMP::public.t_timestamp;
       OLD.date_to   = NEW.date_from;
       OLD.actual    = FALSE;
       --
       INSERT INTO nso.nso_record_hist
                (
                        rec_id
                       ,parent_rec_id
                       ,rec_uuid
                       ,nso_id
                       ,actual
                       ,section_number  -- Nick 2020-01-30
                       ,date_from
                       ,date_to
                       ,log_id
                ) VALUES(
                        OLD.rec_id
                       ,OLD.parent_rec_id
                       ,OLD.rec_uuid
                       ,OLD.nso_id
                       ,OLD.actual
                       ,OLD.section_number
                       ,OLD.date_from
                       ,OLD.date_to
                       ,OLD.log_id
                );
                RETURN NEW; -- даем триггеру завершиться внесением изменений
	ELSIF TG_OP = 'DELETE'
	THEN
       OLD.log_id = nso.nso_p_nso_log_i('5','Удаление данных: "' || _nso_code || '", ID записи: ' || OLD.rec_id);
       OLD.date_to = CURRENT_TIMESTAMP::public.t_timestamp;
       OLD.actual = FALSE;
       INSERT INTO nso.nso_record_hist
                (
                        rec_id
                       ,parent_rec_id
                       ,rec_uuid
                       ,nso_id
                       ,actual
                       ,section_number  -- Nick 2020-01-30
                       ,date_from
                       ,date_to
                       ,log_id
                ) VALUES(
                        OLD.rec_id
                       ,OLD.parent_rec_id
                       ,OLD.rec_uuid
                       ,OLD.nso_id
                       ,OLD.actual
                       ,OLD.section_number
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

COMMENT ON FUNCTION nso.tr_nso_record_ud() IS 
  '265: Триггер, обрабатывающий события UPDATE и DELETE таблицы nso.nso_record фиксирует изменения в nso.nso_record_hist';

-- Применение триггера
CREATE TRIGGER tr_nso_record_ud BEFORE UPDATE OR DELETE ON nso.nso_record
FOR EACH ROW EXECUTE PROCEDURE nso.tr_nso_record_ud();

-- SELECT * FROM nso.nso_record
-- SELECT * FROM ONLY nso.nso_record WHERE rec_id = 6; 
-- SELECT * FROM nso.nso_record_hist

-- UPDATE ONLY nso.nso_record SET log_id = log_id WHERE rec_id = 6; ROLLBACK;
-- DELETE FROM ONLY nso.nso_record WHERE rec_id = 6; ROLLBACK;
-- SELECT * FROM session_nso_log 

