SET search_path = com, public;
DROP TRIGGER IF EXISTS tr_obj_object_iud ON com.obj_object;
DROP FUNCTION IF EXISTS com.tr_obj_object_iud();
CREATE OR REPLACE FUNCTION com.tr_obj_object_iud()
RETURNS TRIGGER AS

$$
-- ==================================================================================================== 
-- Author: Gregory
-- Create date: 2015-06-28
-- Description:	Триггер, обрабатывающий события INSERT, UPDATE и DELETE
--    2015-11-19 Замена * на явное определение столбцов, Ревизия  1115.
--    2016-05-31 Nick Явное определение даты создания
--    2017-02-08 Nick  Новое событие "Q - Обновление документа с изменением его уровня секретности"
--    2017-01-03 Nick  Для объектов типа "Реестр платежей" создаётся показатель типа "Измерение реестра платежей
--                     Триггер типа AFTER.  
--    2017-06-15 Nick  Колонка "object_stype_id" - в работе. Снова триггер типа BEFORE.
-- -------------------------------------------------------------------------------------------------------------
--    2017-06-25 Gregory Для функционирования механизма версионности, по сути только на object_mod_date:
--     необходимо: а) в триггере, в разделе DELETE, задвоить копирование оперативной строки, с текущим mod, 
--     а затем создать дополнительную строку со значением "object_mod_date" равным дате удаления.
--                 б) в этом-же триггере, в разделе INSERT сделать принудительное зануление "object_mod_date"
--                    чтобы перебить вставку даты пользователем/функцией. 
-- -------------------------------------------------------------------------------------------------------------
--    2017-12-10 Nick  введён атрибут - "дата деактивации объекта".
--    2018-02-06 Nick  Первая установка владельца объекта. В контексте COALESCE запрещены функции работающие с 
--                     наборами данных.
-- -------------------------------------------------------------------------------------------------------------
--    2020-05-01 Nick Новоя ядро. Изменился атрибутный состав "obj_object"
-- ============================================================================================================= 
 DECLARE 
        rsp_main           public.result_t; 
        _object_owner1_id  public.t_guid;        
 BEGIN
	IF TG_OP = 'INSERT'
	THEN
		NEW.id_log = com.com_p_com_log_i ( '6', 'Создание  объекта: "' || NEW.object_uuid ::t_str60 ||
                                         '", Уровень секретности: "' || nso.nso_f_record_def_val (NEW.object_secret_id) ||
                                         '", Тип: "' || ( SELECT c.codif_name FROM ONLY com.obj_codifier c WHERE ( c.codif_id = NEW.object_type_id )) || '"'
       ); 
		NEW.object_create_date = now()::public.t_timestamp; -- !! Nick 2020-05-01
		NEW.object_mod_date   := NULL;    -- Gregory 2017-06-25
        NEW.object_deact_date := NULL; -- Nick 2017-12-10
        -- Nick 2018-02-21 Первая установка
        NEW.object_owner_id := auth.auth_f_default_owner_get_id();
        --
        -- !!! 2020-05-01 Nick
        --        _object_owner1_id := ((nso.nso_f_record_s (NEW.object_owner_id)).mas_val [8]::public.t_guid);
        NEW.object_owner1_id := COALESCE (com.com_f_global_get ('X_OWNER1')::public.t_guid, _object_owner1_id); 
      -- Nick 2018-02-21 Первая установка
      RETURN NEW;
     
     ELSIF TG_OP = 'UPDATE'
	THEN
      IF ( NEW.object_secret_id <> OLD.object_secret_id ) 
           THEN
                NEW.id_log = com.com_p_com_log_i ( 'Q', 'Обновление объекта: "' || NEW.object_uuid ::t_str60 || '", изменение уровня секретности. '
                                                   'Уровень секретности: "'  || nso.nso_f_record_def_val (NEW.object_secret_id) ||
                                                   '", Старый уровень: "' || nso.nso_f_record_def_val (OLD.object_secret_id) ||
                                                   '", Тип: "' || ( SELECT c.codif_name FROM ONLY com.obj_codifier c WHERE ( c.codif_id = NEW.object_type_id )) || '"'
                );
      ELSE
           NEW.id_log = com.com_p_com_log_i ( '7', 'Обновление объекта: "' || NEW.object_uuid ::t_str60 || 
                                              '", Уровень секретности: "' || nso.nso_f_record_def_val (NEW.object_secret_id) ||
                                              '", Тип: "' || ( SELECT c.codif_name FROM ONLY com.obj_codifier c WHERE ( c.codif_id = NEW.object_type_id )) || '"'
           );
      END IF;

	  NEW.object_mod_date = now()::public.t_timestamp; -- !! Nick 2020-05-01
      NEW.object_deact_date := NULL; -- Nick 2017-12-10
      OLD.object_deact_date := NULL; -- Nick 2017-12-10
      --
      NEW.object_owner_id := auth.auth_f_default_owner_get_id();
		INSERT INTO com.obj_object_hist ( object_id
                                       ,parent_object_id
                                       ,object_type_id
                                       ,object_stype_id   -- Nick 2017-06-15
                                       ,object_short_name -- 2020-05-01 Nick
                                       ,object_uuid
                                       ,object_create_date
                                       ,object_mod_date
                                       ,object_read_date
                                       ,object_deact_date -- Nick 2017-12-10
                                       ,object_secret_id
                                       ,object_owner_id
                                       ,object_owner1_id  -- Nick 2017-11-16
                                       ,id_log
                ) VALUES (    OLD.object_id           
                             ,OLD.parent_object_id    
                             ,OLD.object_type_id
                             ,OLD.object_stype_id -- Nick  2017-06-15
                             ,OLD.object_short_name -- 2020-05-01 Nick
                             ,OLD.object_uuid         
                             ,OLD.object_create_date  
                             ,OLD.object_mod_date     
                             ,OLD.object_read_date 
                             ,OLD.object_deact_date -- Nick 2017-12-10    
                             ,OLD.object_secret_id    
                             ,OLD.object_owner_id     
                             ,OLD.object_owner1_id  -- Nick 2017-11-16
                             ,OLD.id_log
                );
		RETURN NEW;
	ELSIF TG_OP = 'DELETE'
	THEN
		OLD.id_log = com.com_p_com_log_i ( '8', 'Удаление объекта: "' || OLD.object_uuid ::t_str60 ||
                                         '", Уровень секретности: "' || nso.nso_f_record_def_val (OLD.object_secret_id) ||
                                         '", Тип: "' || ( SELECT c.codif_name FROM ONLY com.obj_codifier c WHERE ( c.codif_id = OLD.object_type_id )) || '"'
      );
      		INSERT INTO com.obj_object_hist
		(
                        object_id
                       ,parent_object_id
                       ,object_type_id
                       ,object_stype_id
                       ,object_short_name -- 2020-05-01 Nick
                       ,object_uuid
                       ,object_create_date
                       ,object_mod_date
                       ,object_read_date
                       ,object_deact_date -- Nick 2017-12-10                       
                       ,object_secret_id
                       ,object_owner_id
                       ,object_owner1_id                      
                       ,id_log
                ) VALUES ( OLD.object_id
                          ,OLD.parent_object_id
                          ,OLD.object_type_id
                          ,OLD.object_stype_id
                          ,OLD.object_short_name -- 2020-05-01 Nick
                          ,OLD.object_uuid
                          ,OLD.object_create_date
                          ,OLD.object_mod_date
                          ,OLD.object_read_date
                          ,now()::public.t_timestamp -- Nick 2017-12-10
                          ,OLD.object_secret_id
                          ,OLD.object_owner_id
                          ,OLD.object_owner1_id  -- Nick 2017-11-16
                          ,OLD.id_log
                );
		RETURN OLD;
	END IF;
 END;
$$
LANGUAGE plpgsql 
SECURITY DEFINER; -- Nick 2016-02-26

COMMENT ON FUNCTION com.tr_obj_object_iud() IS '318: Обработка событий INSERT, UPDATE, DELETE в реестре объектов, история в com.obj_object_hist';

-- Применение триггера
CREATE TRIGGER tr_obj_object_iud
BEFORE INSERT OR UPDATE OR DELETE
ON com.obj_object
FOR EACH ROW
EXECUTE PROCEDURE com.tr_obj_object_iud();

-- SELECT * FROM com.obj_object
-- SELECT * FROM ONLY com.obj_object
-- SELECT * FROM com.obj_object_hist

-- INSERT INTO com.obj_object(
--             object_id, parent_object_id, object_type_id, object_uuid, object_create_date, 
--             object_mod_date, object_read_date, object_secret_id, object_owner_id, 
--             id_log)
--     VALUES (DEFAULT, NULL, 1, '1a317326-ec5e-429a-935d-5b59996e212a', '2015-06-16 19:00:04', 
--             '2015-06-16 19:00:04', '2015-06-16 19:00:04', 1, 1, 
--             NULL);
-- 1

-- UPDATE ONLY com.obj_object SET object_mod_date = '2015-06-16 01:02:05' WHERE object_id = 1
-- DELETE FROM ONLY com.obj_object WHERE object_id = 1

-- SELECT * FROM ONLY com.obj_object WHERE object_id = 1
-- ALTER TABLE com.obj_object ADD COLUMN object_stype_id id_t

