DROP TRIGGER IF EXISTS tr_nso_domain_column_iud ON com.nso_domain_column;
DROP FUNCTION IF EXISTS com.tr_nso_domain_column_iud();
CREATE OR REPLACE FUNCTION com.tr_nso_domain_column_iud()
RETURNS TRIGGER 
SET search_path = com, public
AS
 $$
-- ===================================================================================== 
-- Author: Gregory
-- Create date: 2015-06-28
-- Description:	Триггер, обрабатывающий события INSERT, UPDATE и DELETE
--      2015-11-19 Замена * на явное определение столбцов, Ревизия  1115.
-- 2015-11-17 Новый атрибут типа "ссылка на документ"   -- 2016-02-02 goback Nick
-- 2016-05-31 Явное определение attr_create_date, date_from, date_to Gregory Rev 3078
-- ------------------------------------------------------------------------------------- 
-- 2016-06-19 Nick  Дополнительный атрибут в NSO_DOMAIN_COLUMN, nso_code            
-- 2016-11-02 Gregory оптимизация истории изменений
-- 2019-05-23 Nick  Новое ядро   
-- 2019-07-14 Nick  "date_from" теперь не зависит от "attr_create_date", обратная 
--          зависимость справедлива: В момент создания "attr_create_date" = "date_from"        
-- ===================================================================================== 
  BEGIN
	IF TG_OP = 'INSERT'
	THEN
		NEW.id_log = com.com_p_com_log_i ( '3', 'Создание атрибута в домене: ' || NEW.attr_code );
      -- 2016-05-31 Gregory
		NEW.attr_create_date = NEW.date_from ; --CURRENT_TIMESTAMP::TIMESTAMP(0) WITHOUT TIME ZONE;
		-- NEW.date_from = NEW.attr_create_date;  -- Nick 209-07-14
		NEW.date_to = '9999-12-31 00:00:00'::TIMESTAMP(0) WITHOUT TIME ZONE;
      -- 2016-05-31 Gregory
		RETURN NEW;
	ELSIF TG_OP = 'UPDATE'
	THEN
		IF -- 2016-11-02 Gregory
                        NEW.parent_attr_id IS NOT DISTINCT FROM OLD.parent_attr_id
                    AND NEW.attr_type_id = OLD.attr_type_id
                    AND NEW.small_code = OLD.small_code
                    AND NEW.attr_uuid = OLD.attr_uuid
                    AND NEW.is_intra_op = OLD.is_intra_op
                    AND NEW.attr_code = OLD.attr_code
                    AND NEW.attr_name = OLD.attr_name
                    AND NEW.domain_nso_id IS NOT DISTINCT FROM OLD.domain_nso_id
                    AND NEW.domain_nso_code IS NOT DISTINCT FROM OLD.domain_nso_code
                    AND NEW.date_to = OLD.date_to
                THEN RETURN NEW;
                END IF;
	
		NEW.id_log = com.com_p_com_log_i ( '5', 'Обновление атрибута в домене: ' || NEW.attr_code );
		NEW.date_from = CURRENT_TIMESTAMP::TIMESTAMP(0) WITHOUT TIME ZONE;
		OLD.date_to = NEW.date_from;
		INSERT INTO com.nso_domain_column_hist 
		(
                        attr_id
                       ,parent_attr_id
                       ,attr_type_id
                       ,small_code
                       ,attr_uuid
                       ,attr_create_date
                       ,is_intra_op
                       ,attr_code
                       ,attr_name
                       ,domain_nso_id
                       ,domain_nso_code -- 2016-06-19 
                       ,date_from
                       ,date_to
                       ,id_log
                ) VALUES(OLD.attr_id
                       ,OLD.parent_attr_id
                       ,OLD.attr_type_id
                       ,OLD.small_code
                       ,OLD.attr_uuid
                       ,OLD.attr_create_date
                       ,OLD.is_intra_op
                       ,OLD.attr_code
                       ,OLD.attr_name
                       ,OLD.domain_nso_id
                       ,OLD.domain_nso_code -- 2016-06-19 
                       ,OLD.date_from
                       ,OLD.date_to
                       ,OLD.id_log
                );
		RETURN NEW;
	ELSIF TG_OP = 'DELETE'
	THEN
		OLD.id_log = com.com_p_com_log_i ( '4', 'Удаление атрибута из домена: ' || OLD.attr_code );
		OLD.date_to = CURRENT_TIMESTAMP::TIMESTAMP(0) WITHOUT TIME ZONE;
		INSERT INTO com.nso_domain_column_hist  
		(
                        attr_id
                       ,parent_attr_id
                       ,attr_type_id
                       ,small_code
                       ,attr_uuid
                       ,attr_create_date
                       ,is_intra_op
                       ,attr_code
                       ,attr_name
                       ,domain_nso_id
                       ,domain_nso_code -- 2016-06-19 
                       ,date_from
                       ,date_to
                       ,id_log
                ) VALUES(OLD.attr_id
                       ,OLD.parent_attr_id
                       ,OLD.attr_type_id
                       ,OLD.small_code
                       ,OLD.attr_uuid
                       ,OLD.attr_create_date
                       ,OLD.is_intra_op
                       ,OLD.attr_code
                       ,OLD.attr_name
                       ,OLD.domain_nso_id
                       ,OLD.domain_nso_code -- 2016-06-19 
                       ,OLD.date_from
                       ,OLD.date_to
                       ,OLD.id_log
                );
		RETURN OLD;
	END IF;
  END;
 $$
LANGUAGE plpgsql 
SECURITY DEFINER; -- Nick 2016-02-26

COMMENT ON FUNCTION com.tr_nso_domain_column_iud() IS '165: Обработка событий INSERT, UPDATE, DELETE в домене атрибутов. История в nso_domain_column_hist';

-- Применение триггера
CREATE TRIGGER tr_nso_domain_column_iud
BEFORE INSERT OR UPDATE OR DELETE
ON com.nso_domain_column
FOR EACH ROW
EXECUTE PROCEDURE com.tr_nso_domain_column_iud();

-- delete from com.nso_domain_column where attr_id = 35
-- select * from com.com_log ORDER BY 5 DESC
-- select * from ONLY com.nso_domain_column where attr_id = 36
-- UPDATE ONLY com.nso_domain_column SET attr_name='Денежная величина' where attr_id = 37
-- 
-- INSERT INTO com.nso_domain_column (
--             attr_id, parent_attr_id, attr_type_id, small_code, attr_uuid, 
--             attr_create_date, is_intra_op, attr_code, attr_name, domain_nso_id, 
--             date_from, date_to, id_log)
--     VALUES (37, 3, 19, 'A', 'a3f7c200-e43e-49c7-a2b7-f76b770556c3', 
--             '2015-06-21 20:53:17', FALSE, 'TEST_ATTR', 'Тест', NULL, 
--             '2015-06-21 21:04:14', '2015-06-28 02:25:25', NULL);

-- SELECT * FROM ONLY com.nso_domain_column WHERE attr_id = 37  -- 'Денежная величина'
-- ALTER TABLE com.nso_domain_column ADD COLUMN domain_object_id id_t

