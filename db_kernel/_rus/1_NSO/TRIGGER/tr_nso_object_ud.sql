DROP TRIGGER IF EXISTS tr_nso_object_ud ON nso.nso_object;
DROP FUNCTION IF EXISTS nso.tr_nso_object_ud();

CREATE OR REPLACE FUNCTION nso.tr_nso_object_ud()
RETURNS TRIGGER 
SET search_path = nso, public
AS
$$
-- ============================================================================================ --
--   Author: Gregory                                                                            --
--   Create date: 2015-09-13                                                                    --
--   Description:	Триггер, обрабатывающий события UPDATE и DELETE таблицы nso.nso_object      --
--     2015-11-22  Gregory. Явное указание перечня столбцов. Ревизия 1122.                      --
--     2017-12-10  Nick  Забытый атрибут unique_check.                                          --
--     2019-07-17  Nick Новое ядро.  Вместо "nso_xml" -- "section_number"                       --
-- ============================================================================================ --
  BEGIN
    IF TG_OP = 'UPDATE'
	THEN
		NEW.id_log = nso.nso_p_nso_log_i ('4','Обновление данных объекта: ' || NEW.nso_code);
		NEW.date_from = now()::public.t_timestamp;
		OLD.date_to = NEW.date_from;
		OLD.active_sign = FALSE;
		INSERT INTO nso.nso_object_hist
                (
                        nso_id
                       ,parent_nso_id
                       ,nso_type_id
                       ,nso_uuid
                       ,date_create
                       ,nso_release
                       ,active_sign
                       ,is_group_nso
                       ,is_intra_op
                       ,is_m_view
                       ,unique_check   -- Nick 2017-12-10
                       ,nso_code
                       ,nso_name
                       ,nso_select
                       ,section_number -- Nick 2019-07-17
                       ,date_from
                       ,date_to
                       ,id_log
                       
                ) VALUES (OLD.nso_id
                         ,OLD.parent_nso_id
                         ,OLD.nso_type_id
                         ,OLD.nso_uuid
                         ,OLD.date_create
                         ,OLD.nso_release
                         ,OLD.active_sign
                         ,OLD.is_group_nso
                         ,OLD.is_intra_op
                         ,OLD.is_m_view
                         ,OLD.unique_check -- Nick 2017-12-10
                         ,OLD.nso_code
                         ,OLD.nso_name
                         ,OLD.nso_select
                         ,OLD.section_number -- Nick 2019-07-17
                         ,OLD.date_from
                         ,OLD.date_to
                         ,OLD.id_log
                );
		RETURN NEW;
	ELSIF TG_OP = 'DELETE'
	THEN
		OLD.id_log = nso.nso_p_nso_log_i('5','Удаление данных объекта: ' || OLD.nso_code);
		OLD.date_to = now()::public.t_timestamp;
		OLD.active_sign = FALSE;

		INSERT INTO nso.nso_object_hist
                (
                        nso_id
                       ,parent_nso_id
                       ,nso_type_id
                       ,nso_uuid
                       ,date_create
                       ,nso_release
                       ,active_sign
                       ,is_group_nso
                       ,is_intra_op
                       ,is_m_view
                       ,unique_check -- Nick 2017-12-10
                       ,nso_code
                       ,nso_name
                       ,nso_select
                       ,section_number -- Nick 2019-07-17
                       ,date_from
                       ,date_to
                       ,id_log
                ) VALUES(OLD.nso_id
                        ,OLD.parent_nso_id
                        ,OLD.nso_type_id
                        ,OLD.nso_uuid
                        ,OLD.date_create
                        ,OLD.nso_release
                        ,OLD.active_sign
                        ,OLD.is_group_nso
                        ,OLD.is_intra_op
                        ,OLD.is_m_view
                        ,OLD.unique_check -- Nick 2017-12-10
                        ,OLD.nso_code
                        ,OLD.nso_name
                        ,OLD.nso_select
                        ,OLD.section_number -- Nick 2019-07-17
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

COMMENT ON FUNCTION nso.tr_nso_object_ud() IS 
 '177: Триггер, обрабатывающий события UPDATE и DELETE таблицы nso.nso_object фиксирует изменения в nso.nso_object_hist';

-- Применение триггера
CREATE TRIGGER tr_nso_object_ud BEFORE UPDATE OR DELETE ON nso.nso_object
FOR EACH ROW EXECUTE PROCEDURE nso.tr_nso_object_ud();

-- SELECT * FROM plpgsql_check_function ('nso.tr_nso_object_ud()', 'nso.nso_object');
--   'warning extra:2F005:control reached end of function without RETURN'

-- UPDATE ONLY nso.nso_object SET id_log = id_log WHERE nso_id = 24
-- SELECT * FROM session_nso_log

