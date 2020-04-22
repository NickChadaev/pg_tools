/*
      Аргументы:
                 p_paren        t_str60    -- ID родительского идентификатора      
          	,p_code         t_str60    -- Код                                                          
		,p_name         t_str250   -- Наименование                                        
                ,p_codif_uuid   t_guid     -- UUID       
                --  Далее значения по умолчанию
                ,p_scode        t_code1 = ''0'' -- Краткий код                                           
                ,p_date_from    t_timestamp = CURRENT_TIMESTAMP::timestamp(0) without time zone,     -- Дата начала актуальности
                ,p_date_to      t_timestamp = ''9999-12-31 00:00:00''::timestamp(0) without time zone, -- Дата конца актуальности
                -- 
   	Выходные величины: 
		 result_long_t.rc > 0 - процедура завершилась успешно, ID созданной записи
		 result_long_t.rc -1  - процедура завершилась с ошибкой, сообщение об ошибке

	Особенности
				Для генерации ИД PK используется последовательность com_codifier.obj_codifier_codif_id_seq
---------------------------------------------------------------------------------------------*/
DROP FUNCTION IF EXISTS com_codifier.obj_p_codifier_i (public.t_str60, public.t_str60, public.t_str250, public.t_guid, public.t_code1, public.t_timestamp, public.t_timestamp);
CREATE OR REPLACE FUNCTION com_codifier.obj_p_codifier_i (
                 p_parent      public.t_str60       -- Код родительской записи
                ,p_code        public.t_str60       -- Код                                                          
                ,p_name        public.t_str250      -- Наименование                                        
                ,p_codif_uuid  public.t_guid        -- UUID       
                 --  Далее значения по умолчанию
                ,p_scode       public.t_code1 = '0' -- Краткий код                                           
                 -- 
                ,p_date_from   public.t_timestamp = now()::public.t_timestamp     -- Начало периода актуальности
                ,p_date_to     public.t_timestamp = '9999-12-31 00:00:00'::public.t_timestamp -- Конец периода актуальности 
)
  RETURNS public.result_long_t  
     SECURITY DEFINER -- 2015-04-05
     LANGUAGE plpgsql 
     SET search_path = com_codifier,com_error, com, public, pg_catalog   
  AS 
$$
-- ===========================================================================================================================
-- Author:		SVETA
-- Create date: 2013-08-14
-- Description:	Добавление новой записи в кодификатор 
-- --------------------------------------------------------------------------------------------------------------------------- 
-- 2015-02-22  Переход на домен EBD Nick
-- 2015-04-05  SECURITY DEFINER 
-- 2015-05-29  Модификация в связи с добавление атрибута UUID и временных атрибутов
-- 2015-07-20 Gregory «FROM com.obj_codifier» изменено на «FROM ONLY com.obj_codifier», добавлено поле журнала учета изменений
-- ---------------------------------------------------------------------------------------------------------------------------
-- 2019-05-13 Nick  Ядро версия 2.0
-- =========================================================================================================================== 
 DECLARE 
  c_ERR_FUNC_NAME public.t_sysname = 'obj_p_codifier_i'; --имя процедуры
  c_SEQ_NAME      public.t_sysname = 'com.obj_codifier_codif_id_seq';
  c_MESS00        public.t_str1024 = 'Создание экземпляра кодификатора выполнено успешно'; 
  --  
  rsp_main          public.result_long_t; 
  _parent_codif_id  public.id_t;
  --
  _parent_code  public.t_str60  := utl.com_f_empty_string_to_null (upper(btrim (p_parent))); -- Код родительской записи
  _code         public.t_str60  := utl.com_f_empty_string_to_null (upper(btrim (p_code)));   -- Код                                                          
  _name         public.t_str250 := utl.com_f_empty_string_to_null (btrim (p_name));          -- Наименование                                        
  --
  _exception  public.exception_type_t;
  _err_args   public.t_arr_text := ARRAY [''];
  
 BEGIN
      IF ((_code IS NULL) OR (_name IS NULL) OR (p_scode IS NULL) OR 
          (p_codif_uuid IS NULL) OR (p_date_from IS NULL) OR (p_date_to IS NULL)
      ) -- ( _parent IS NULL ) OR
      THEN
	   RAISE SQLSTATE '60000'; -- NULL значения запрещены
      END IF;

      _parent_codif_id := com_codifier.com_f_obj_codifier_get_id (_parent_code);

      IF ((_parent_codif_id IS NULL) AND NOT (_code = 'C_CODIF_ROOT')) 
        THEN
           _err_args [1] := _code;
           RAISE SQLSTATE '61050';
      END IF;
      -- Nick 2019-07-14
      IF ( p_date_from > p_date_to ) THEN
         _err_args [1] := p_date_from::text;
         _err_args [2] := p_date_to::text;
         RAISE SQLSTATE '60005';
      END IF;       
      --
      INSERT INTO com.obj_codifier (  
                 parent_codif_id
                ,small_code
                ,codif_code
                ,codif_name
                ,codif_uuid   
                ,date_from
                ,date_to
                ,id_log
         )
         VALUES
              (  _parent_codif_id
                ,p_scode  
                ,_code 
                ,_name 
                ,p_codif_uuid
                ,p_date_from
                ,p_date_to
                ,NULL
              );                   
    IF FOUND THEN                  
           rsp_main := ( CURRVAL (c_SEQ_NAME), c_MESS00 );  
    ELSE 
         _err_args [1] := _code;
         RAISE SQLSTATE '61010';
    END IF;                        
                                   
    RETURN rsp_main;               
                                   
 EXCEPTION              
	WHEN OTHERS  THEN 
	 BEGIN
	   GET STACKED DIAGNOSTICS 
              _exception.state           := RETURNED_SQLSTATE            -- SQLSTATE
             ,_exception.schema_name     := SCHEMA_NAME 
             ,_exception.table_name      := TABLE_NAME 	      
             ,_exception.constraint_name := CONSTRAINT_NAME     
             ,_exception.column_name     := COLUMN_NAME       
             ,_exception.datatype        := PG_DATATYPE_NAME 
             ,_exception.message         := MESSAGE_TEXT                 -- SQLERRM
             ,_exception.detail          := PG_EXCEPTION_DETAIL 
             ,_exception.hint            := PG_EXCEPTION_HINT 
             ,_exception.context         := PG_EXCEPTION_CONTEXT;            -- 

             _exception.func_name := c_ERR_FUNC_NAME; 
		
	   rsp_main := (-1, ( com_error.f_error_handling ( _exception, _err_args )));
			
	   RETURN rsp_main;			
	END;
 END;
$$;

COMMENT ON FUNCTION  com_codifier.obj_p_codifier_i (public.t_str60, public.t_str60, public.t_str250, public.t_guid, public.t_code1, public.t_timestamp, public.t_timestamp) 
   IS '165: Создание экземпляра кодификатора. Код родительской записи.

       Аргументы:
         p_parent       public.id_t            -- ID родительского идентификатора      
        ,p_code         public.t_str60         -- Код                                                          
        ,p_name         public.t_str250        -- Наименование                                        
        ,p_codif_uuid   public.t_guid          -- UUID       
         --  Далее значения по умолчанию
        ,p_scode        public.t_code1 = ''0'' -- Краткий код        
          -- 
        ,p_date_from   public.t_timestamp = now()::public.t_timestamp     -- Начало периода актуальности
        ,p_date_to     public.t_timestamp = ''9999-12-31 00:00:00''::public.t_timestamp -- Конец периода актуальности 

   	Выходные величины: 
		 public.result_long_t.rc > 0 - процедура завершилась успешно, ID созданной записи
		 public.result_long_t.rc -1  - процедура завершилась с ошибкой, сообщение об ошибке
   ';
--
--  SELECT * FROM com_codifier.obj_p_codifier_i ( NULL, 'C_NSO_SPR_99', 'Справочник', NEWID());
--  SELECT * FROM com_codifier.obj_p_codifier_i ( 'C_OBJ_TYPE', 'C_NSO_RBR', 'Рубрикатор' ); -- Значение по умолчанию
--  SELECT * FROM com_codifier.obj_p_codifier_i ( 'XXXXXXXXXX', 'C_NSO_CLASS11', 'Классификатор11', 'C' );-- Нет такого родителя
--  SELECT * FROM com_codifier.obj_p_codifier_i ( 2, 'C_NSO_CLASS2', 'Классификатор2', '22222222' );
--  SELECT * FROM com_codifier.obj_p_codifier_i ( null, 'C_NSO_CLASS2', 'Классификатор2');
-- SELECT * FROM com_codifier.obj_p_codifier_i ( 2, 'C_NSO_CLASS2wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww', 'Классификатор2', '2' );
