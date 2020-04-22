DROP TRIGGER IF EXISTS tr_obj_codifier_iud ON com.obj_codifier;
DROP FUNCTION IF EXISTS com.tr_obj_codifier_iud();
CREATE OR REPLACE FUNCTION com.tr_obj_codifier_iud()
  RETURNS TRIGGER 
  SET search_path = com, public 
  AS
$$
-- ================================================================================================
-- Author: Gregory
-- Create date: 2015-06-28
-- Description:	Триггер, обрабатывающий события INSERT, UPDATE и DELETE
--    2015-11-19 Замена * на явное определение столбцов, Ревизия  1115.
--    2016-5-31  Явное определение date_create, date_from  Rev 3078
--    2016-11-02 Gregory оптимизация истории изменений
--    2019-05-23 Nick - новое ядро  
--    2019-07-14 Nick  "date_from" теперь не зависит от "date_create", обратная зависимость.
--                     В момент создания "date_create" = "date_from"        
-- ================================================================================================
 BEGIN
	IF TG_OP = 'INSERT'
	THEN
		NEW.id_log = com.com_p_com_log_i ('0','Создание записи в кодификаторе: ' || NEW.codif_code );
      -- 2016-05-31 Gregory
		NEW.create_date = NEW.date_from; -- CURRENT_TIMESTAMP::TIMESTAMP(0) WITHOUT TIME ZONE;
	--	NEW.date_from = NEW.create_date; -- Nick 2019-07-14
		NEW.date_to = '9999-12-31 00:00:00'::TIMESTAMP(0) WITHOUT TIME ZONE;
      -- 201605-31 Gregory
		RETURN NEW;
		
	ELSIF TG_OP = 'UPDATE'
	THEN
		IF -- 2016-11-02 Gregory
                        NEW.parent_codif_id IS NOT DISTINCT FROM OLD.parent_codif_id
                    AND NEW.small_code = OLD.small_code
                    AND NEW.codif_code = OLD.codif_code
                    AND NEW.codif_name = OLD.codif_name
                    AND NEW.date_to    = OLD.date_to
                    AND NEW.codif_uuid = OLD.codif_uuid
               THEN RETURN NEW;
        END IF;
	
		NEW.id_log = com.com_p_com_log_i ( '2','Обновление данных в кодификаторе: ' || NEW.codif_code );
		NEW.date_from = CURRENT_TIMESTAMP::TIMESTAMP(0) WITHOUT TIME ZONE;
		OLD.date_to = NEW.date_from;
		INSERT INTO com.obj_codifier_hist
		(
                        codif_id
                       ,parent_codif_id
                       ,small_code
                       ,codif_code
                       ,codif_name
                       ,create_date
                       ,date_from
                       ,date_to
                       ,codif_uuid
                       ,id_log
                ) VALUES(OLD.codif_id
                       ,OLD.parent_codif_id
                       ,OLD.small_code
                       ,OLD.codif_code
                       ,OLD.codif_name
                       ,OLD.create_date
                       ,OLD.date_from
                       ,OLD.date_to
                       ,OLD.codif_uuid
                       ,OLD.id_log
                );
		RETURN NEW;
	ELSIF TG_OP = 'DELETE'
	THEN
		OLD.id_log = com.com_p_com_log_i ('1','Удаление записи в кодификаторе: ' ||  OLD.codif_code);
		OLD.date_to = CURRENT_TIMESTAMP::TIMESTAMP(0) WITHOUT TIME ZONE;
		INSERT INTO com.obj_codifier_hist
		(
                        codif_id
                       ,parent_codif_id
                       ,small_code
                       ,codif_code
                       ,codif_name
                       ,create_date
                       ,date_from
                       ,date_to
                       ,codif_uuid
                       ,id_log
                ) VALUES(OLD.codif_id
                       ,OLD.parent_codif_id
                       ,OLD.small_code
                       ,OLD.codif_code
                       ,OLD.codif_name
                       ,OLD.create_date
                       ,OLD.date_from
                       ,OLD.date_to
                       ,OLD.codif_uuid
                       ,OLD.id_log
                );
		RETURN OLD;
	END IF;
 END;
$$
LANGUAGE plpgsql 
SECURITY DEFINER; -- Nick 2016-02-26

COMMENT ON FUNCTION com.tr_obj_codifier_iud() IS '165: Обработка событий INSERT, UPDATE, DELETE в кодификаторе. История в obj_codifier_hist';

-- Применение триггера
CREATE TRIGGER tr_obj_codifier_iud
BEFORE INSERT OR UPDATE OR DELETE
ON com.obj_codifier
FOR EACH ROW
EXECUTE PROCEDURE com.tr_obj_codifier_iud();

-- SELECT * FROM com.obj_codifier
-- SELECT * FROM ONLY com.obj_codifier
-- SELECT * FROM com.obj_codifier_hist

-- INSERT INTO com.obj_codifier(
--             codif_id, parent_codif_id, small_code, codif_code, codif_name, 
--             create_date, date_from, date_to, codif_uuid, id_log)
--     VALUES (DEFAULT, 1, 'г', 'T_CODIF_TEST', 'Тестовый экземпляр кодификатора', 
--             '2015-06-16 19:00:04', '2015-06-16 19:00:04', '9999-12-31 00:00:00', '1a317326-ec5e-429a-935d-5b59996e212e', NULL);
-- 108

-- UPDATE ONLY com.obj_codifier SET codif_name = 'Тестовый экземпляр 123' WHERE codif_id = 108
-- DELETE FROM ONLY com.obj_codifier WHERE codif_id = 108
-- ------------------------------------------------------------------------
-- SELECT * FROM com.com_f_obj_codifier_s_sys('C_EXEC_TYPE'); 
-- 'Предконтрактное исполнение'|'2015-11-02 17:41:19'|'14b1374a-1932-48eb-9efa-ff9228dbe9e1'
-- 'По ведомости исполнения'   |'2015-11-02 17:41:19'|'b3bf7519-6be1-4881-8921-73e619ad906c'
-- SELECT * FROM com.obj_p_codifier_u ('C_STAT_EXEC', NULL, 'По ведомости исполнения' );
