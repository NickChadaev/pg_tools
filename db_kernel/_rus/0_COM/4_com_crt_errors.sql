-- ================================================================================================
-- Author:	SVETA
-- Create date: 2013-07-29
-- Description:	Создание и начальное заполнение таблицы ошибок. Для всех полей, 
-- участвующих в индексе поле по умолчанию = ''. Если оставить null, то индекс не отработает.
-- -------------------------------------------------------------------------------------------------
-- 2015-02-15 Nick. Таблица разделяется на две: 
--       com.sys_errors - данные для обработки ошибок DB-engine.
--       com.obj_errors - данные для обработки ошибок в API-DB.
-- Nick.         
--  2015-03-18 t_code6 заменён на t_code5    
--  2015-10-04 В ak1_sys_errors ON com.sys_errors
--     добавлена tbl_name, связано с появлением в IND_VALUE и IND_VALU_HIST одноимённых ограничений. 
--     Ограничение созданное в таблице-родителе, наследуется в таблице-потомке.
--  2019-04-09 Nick. Рефакторинг структуры com.obj_errors. Сообщение можетбыть шаблоном.
--  2019-06-04 Nick. Из obj_errors удаляется столбец "func_name".
-- =================================================================================================

SET search_path = com, public;

DROP TABLE IF EXISTS com.sys_errors CASCADE;
CREATE TABLE com.sys_errors (
      err_id       BIGSERIAL         NOT NULL -- PK таблицы   Nick 2013-08-19 добавил  PRIMARY KEY
     ,err_code     public.t_code5    NOT NULL -- код/номер ошибки 
     ,message_out  public.t_text              -- как выводить пользователю -- not null после заполнения текста ошибок
     ,sch_name     public.t_sysname  NOT NULL -- имя схемы
     ,constr_name  public.t_sysname  NOT NULL -- имя ограничения (Nick Увеличить длину sysnames ???!!!)
     ,opr_type     public.t_code1    NOT NULL 
     ,tbl_name     public.t_sysname  NOT NULL -- имя таблицы
);
ALTER TABLE com.sys_errors ADD CONSTRAINT pk_sys_errors PRIMARY KEY (err_id); 

ALTER TABLE com.sys_errors 
  ADD CONSTRAINT ak1_sys_errors UNIQUE (err_code, constr_name, tbl_name, opr_type); 

ALTER TABLE com.sys_errors 
  ADD  CONSTRAINT chk_sys_errors_operation_iud CHECK (opr_type = 'i' OR opr_type = 'd' or opr_type = 'u') ;

COMMENT ON TABLE com.sys_errors IS 'Таблица, используемая для обработки ошибок DB-engine';

COMMENT ON COLUMN com.sys_errors.err_id       IS 'Идентификатор';
COMMENT ON COLUMN com.sys_errors.err_code     IS 'Код ошибки';
COMMENT ON COLUMN com.sys_errors.message_out  IS 'Текст выходного сообщения об обработанной ошибке';
COMMENT ON COLUMN com.sys_errors.sch_name     IS 'Имя схемы';
COMMENT ON COLUMN com.sys_errors.constr_name  IS 'Имя ограничения';
COMMENT ON COLUMN com.sys_errors.opr_type     IS 'Тип операции';
COMMENT ON COLUMN com.sys_errors.tbl_name     IS 'Имя таблицы';
--
-- ---------------------------------------------------------------
-- Сообщения начинаются с 60000,  
--
DROP TABLE IF EXISTS com.obj_errors CASCADE;
CREATE TABLE com.obj_errors (
      err_code    public.t_code5    NOT NULL    -- код/номер ошибки 
     ,message_out public.t_text     NOT NULL                                                               -- Заполняется всегда   
     ,sch_name    public.t_sysname  NOT NULL DEFAULT ''  -- имя схемы                                      -- Общие сообщения, либо сообщения для конкретной схемы
     ,qty         public.small_t    NOT NULL DEFAULT 0   -- метасимволов format   Если 0 то message_out является простым текстом, в противном случае - это шаблон. 
);

COMMENT ON TABLE com.obj_errors IS 'Таблица используемая для обработки ошибок DB-API';

COMMENT ON COLUMN com.obj_errors.err_code    IS 'Код ошибки';
COMMENT ON COLUMN com.obj_errors.message_out IS 'Текст/Шаблон выходного сообщения об обработанной ошибке';
COMMENT ON COLUMN com.obj_errors.sch_name    IS 'Имя схемы';
COMMENT ON COLUMN com.obj_errors.qty         IS 'Количество метасимволов format';
--
ALTER TABLE com.obj_errors ADD CONSTRAINT pk_obj_errors PRIMARY KEY (err_code); 
CREATE INDEX ie1_obj_errors ON com.obj_errors (sch_name);
--
-- SELECT * FROM com.sys_errors;
-- SELECT * FROM com.obj_errors;
--
