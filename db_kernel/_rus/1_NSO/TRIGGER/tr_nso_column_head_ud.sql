SET search_path = nso, public;
DROP TRIGGER IF EXISTS tr_nso_column_head_ud ON nso.nso_column_head;
DROP FUNCTION IF EXISTS nso.tr_nso_column_head_ud ();
CREATE OR REPLACE FUNCTION nso.tr_nso_column_head_ud ()
RETURNS TRIGGER AS
$$
-- =========================================================================================== --
-- Author: Gregory                                                                             --
-- Create date: 2015-08-30                                                                     --
-- Description:	Триггер, обрабатывающий события UPDATE и DELETE таблицы nso.nso_column_head    --
--   2015-11-22  Gregory. Явное указание перечня столбцов. Ревизия 1122.                       --
--   2020-01-30  Nick  Новое ядро                                                              --
-- =========================================================================================== --
 BEGIN
	IF TG_OP = 'UPDATE'
	THEN
		NEW.log_id = nso.nso_p_nso_log_i ('A','Обновление элемента заголовка: ' || NEW.col_code);
		NEW.date_from = CURRENT_TIMESTAMP::public.t_timestamp;
		OLD.date_to = NEW.date_from;
		INSERT INTO nso.nso_column_head_hist
                (   col_id
                   ,parent_col_id
                   ,attr_id
                   ,attr_scode
                   ,nso_id
                   ,col_code
                   ,col_name
                   ,number_col
                   ,mandatory
                   ,date_from
                   ,date_to
                   ,log_id
                   
                ) VALUES (  OLD.col_id
                           ,OLD.parent_col_id
                           ,OLD.attr_id
                           ,OLD.attr_scode
                           ,OLD.nso_id
                           ,OLD.col_code
                           ,OLD.col_name
                           ,OLD.number_col
                           ,OLD.mandatory
                           ,OLD.date_from
                           ,OLD.date_to
                           ,OLD.log_id
                );
		RETURN NEW;
	ELSIF TG_OP = 'DELETE'
	THEN
		OLD.log_id = nso.nso_p_nso_log_i ('B','Удаление элемента заголовка: ' ||  OLD.col_code);
		OLD.date_to = CURRENT_TIMESTAMP::public.t_timestamp;
		INSERT INTO nso.nso_column_head_hist
                (
                     col_id
                    ,parent_col_id
                    ,attr_id
                    ,attr_scode
                    ,nso_id
                    ,col_code
                    ,col_name
                    ,number_col
                    ,mandatory
                    ,date_from
                    ,date_to
                    ,log_id
                    
                ) VALUES (
                           OLD.col_id
                          ,OLD.parent_col_id
                          ,OLD.attr_id
                          ,OLD.attr_scode
                          ,OLD.nso_id
                          ,OLD.col_code
                          ,OLD.col_name
                          ,OLD.number_col
                          ,OLD.mandatory
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

COMMENT ON FUNCTION nso.tr_nso_column_head_ud () 
  IS '265: Обработка событий UPDATE и DELETE в заголовке НСО, фиксирует изменения в nso.nso_column_head_hist';

-- Применение триггера
CREATE TRIGGER tr_nso_column_head_ud BEFORE UPDATE OR DELETE ON nso.nso_column_head
FOR EACH ROW EXECUTE PROCEDURE nso.tr_nso_column_head_ud();

-- SELECT * FROM nso.nso_column_head
-- SELECT * FROM ONLY nso.nso_column_head
-- SELECT * FROM nso.nso_column_head_hist

-- UPDATE ONLY nso.nso_column_head SET log_id = log_id WHERE col_id = 2

