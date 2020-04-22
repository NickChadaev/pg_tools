SET search_path = com, public;
DROP TRIGGER IF EXISTS tr_obj_errors_iu ON com.obj_errors;
DROP FUNCTION IF EXISTS com.tr_obj_errors_iu();
CREATE OR REPLACE FUNCTION com.tr_obj_errors_iu()
RETURNS TRIGGER AS

$$
-- =============================================================================== 
-- Author: Nick
-- Create date: 2019-06-04
-- Description:	Триггерная функция, обрабатывающий события INSERT, UPDATE
-- -------------------------------------------------------------------------------
-- 2019-06-09 Дополнительные проверки связанные с форматированием сообщения. 
--            1) - В шаблоне всегда совпадает количество символов "{" и "}".
--            2) - В шаблоне всегда присутствует "{0}".
-- =============================================================================== 
/*
com.obj_errors (
      err_code    public.t_code5    NOT NULL    -- код/номер ошибки 
     ,message_out public.t_text     NOT NULL                                                               -- Заполняется всегда   
     ,sch_name    public.t_sysname  NOT NULL DEFAULT ''  -- имя схемы                                      -- Общие сообщения, либо сообщения для конкретной схемы
     ,qty         public.small_t    NOT NULL DEFAULT 0   -- количество метасимволов format   Если 0 то message_out является простым текстом, в противном случае - это шаблон. 
);

COMMENT ON TABLE com.obj_errors IS 'Таблица используемая для обработки ошибок DB-API';

COMMENT ON COLUMN com.obj_errors.err_code    IS 'Код ошибки';
COMMENT ON COLUMN com.obj_errors.message_out IS 'Текст/Шаблон выходного сообщения об обработанной ошибке';
COMMENT ON COLUMN com.obj_errors.sch_name    IS 'Имя схемы';
COMMENT ON COLUMN com.obj_errors.qty         IS 'Количество метасимволов format;
 */
DECLARE 
        rsp_main  public.result_t; 
        
        c_L   public.t_text := '{';
        c_R   public.t_text := '}';
        c_I   public.t_text := '{0}';
        
        _qty_1   public.t_int;     
        _qty_2   public.t_int;     
        
 BEGIN
     IF TG_OP = 'INSERT'
     THEN
          _qty_1 := utl.utl_f_count_str (NEW.message_out, c_L);
          _qty_2 := utl.utl_f_count_str (NEW.message_out, c_R);
          
          IF (_qty_1 > 0) OR (_qty_2 > 0)
            THEN
               IF ((_qty_1 = _qty_1) AND (utl.utl_f_count_str (NEW.message_out, c_I) > 0))
                 THEN
                     NEW.qty := _qty_1; -- Посчитали;
                 ELSE
                       RAISE 'В шаблоне сообщения допущена ошибка, неправильный синтаксис'; -- Неправильный синтаксис шаблона сообщения.
               END IF;
            ELSE
                NEW.qty := 0;
          END IF; -- _qty_1 > 0 
          
        RETURN NEW;
     
     ELSIF TG_OP = 'UPDATE'
        THEN
           _qty_1 := utl.utl_f_count_str (NEW.message_out, c_L);
           _qty_2 := utl.utl_f_count_str (NEW.message_out, c_R);

           IF (_qty_1 > 0) OR (_qty_2 > 0)
             THEN
                IF ((_qty_1 = _qty_1) AND (utl.utl_f_count_str (NEW.message_out, c_I) > 0))
                  THEN
                      NEW.qty := _qty_1; -- Посчитали;
                  ELSE
                        RAISE 'В шаблоне сообщения допущена ошибка, неправильный синтаксис'; -- Неправильный синтаксис шаблона сообщения.
                END IF; 
             ELSE
                 NEW.qty := 0;
           END IF; -- _qty_1 > 0
          
           RETURN NEW;
           
	 END IF;
 END;
$$
LANGUAGE plpgsql 
SECURITY DEFINER; -- Nick 2016-02-26

COMMENT ON FUNCTION com.tr_obj_errors_iu() IS '67: Обработка событий INSERT, UPDATE, DELETE в реестре объектов, история в com.obj_errors_hist';

-- Применение триггера
CREATE TRIGGER tr_obj_errors_iu BEFORE INSERT OR UPDATE ON com.obj_errors FOR EACH ROW
      EXECUTE PROCEDURE com.tr_obj_errors_iu();
-----------------------------------------
