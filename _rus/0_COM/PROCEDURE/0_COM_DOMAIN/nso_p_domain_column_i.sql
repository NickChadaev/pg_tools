/*
	Входные параметры
          p_parent_attr_code  t_str60   -- Код родительского атрибута
         ,p_attr_type_code    t_str60   -- Код типа атрибута
         --
         ,p_attr_code         t_str60    -- Код атрибута
         ,p_attr_name         t_str250   -- Наименование атрибута
         ,p_attr_uuid         t_guid     -- UUID атрибута
         -- По умолчанию
         ,p_domain_nso_code   t_str60 = NULL -- Код НСО-домена
         -- 
         ,p_date_from         t_timestamp = CURRENT_TIMESTAMP::timestamp(0) without time zone     -- Начало периода актуальности
         ,p_date_to           t_timestamp = '9999-12-31 00:00:00'::timestamp(0) without time zone -- Конец периода актуальности 

	Выходные параметры:
				 rsp_main.rc = nn - процедура завершилась успешно
				 rsp_main.rc = -1 - процедура завершилась с ошибкой
             --
             rsp_main.errm = <Сообщение>

*/
DROP FUNCTION IF EXISTS com_domain.nso_p_domain_column_i (public.t_str60, public.t_str60, public.t_str60, public.t_str250, public.t_guid, public.t_str60, public.t_timestamp, public.t_timestamp);
CREATE OR REPLACE FUNCTION com_domain.nso_p_domain_column_i (		
          p_parent_attr_code  public.t_str60   -- Код родительского атрибута
         ,p_attr_type_code    public.t_str60   -- Код типа атрибута
         ,p_attr_code         public.t_str60   -- Код атрибута
         ,p_attr_name         public.t_str250  -- Наименование атрибута
         ,p_attr_uuid         public.t_guid    -- UUID атрибута
          --  По умолчанию 
         ,p_domain_nso_code   public.t_str60 = NULL -- Код НСО-домена
          -- 
         ,p_date_from         public.t_timestamp = now()::public.t_timestamp     -- Начало периода актуальности
         ,p_date_to           public.t_timestamp = '9999-12-31 00:00:00'::public.t_timestamp -- Конец периода актуальности 
)
  RETURNS  public.result_long_t  
      SECURITY DEFINER -- 2015-04-05 Nick
      LANGUAGE plpgsql
      SET search_path = com_domain,com,nso,public
  AS 
$$
  -- ========================================================================
  --  Author:		SVETA
  --  Create date: 2013-07-25
  --  Description:	Добавление новой строки в справочник атрибутов
  --  20140-04-04 Anna Код и имя строго больше 2.
  -- ------------------------------------------------------------------------
  --  Адаптация к домену EBD.  2015-03-09 Nick
  --     2015-03-09   Нет различий между NODE и GROUP  Nick.
  --     2015-03-21   Добавлен краткий код типа.
  --     2015-05-30   Перенос в схему COM. Исключены обращения к NSO.NSO_LOG
  --     2015-07-20 Gregory «FROM com.obj_codifier» изменено на
  --     «FROM ONLY com.obj_codifier», добавлено поле журнала учета изменений
  -- ------------------------------------------------------------------------
  --  2015-11-18 Nick Заполнение дополнительного атрибута "Документ-домен". 
  --  2016-02-02 goback - откат назад Nick
  --  2016-06-29 Nick Сохранение кода домена НСО
  -- ========================================================================
  DECLARE 
    c_ERR_FUNC_NAME               public.t_sysname = 'nso_p_domain_column_i';
    c_SEQ_NAME_NSO_DOMAIN_COLUMN  public.t_sysname = 'com.nso_domain_column_attr_id_seq'; -- 32 символа  !!!
    --
    c_MESS00  public.t_str1024 = 'Создание атрибута выполнено успешно';  
    --
    c_ATTR_TYPE  public.t_str60 := 'C_ATTR_TYPE';  -- Корень ветки типов атрибутов в кодификаторе
    c_DOMEN_NODE public.t_str60 := 'C_DOMEN_NODE'; -- Тип - узловой/группирующий атрибут
    c_TREF       public.t_str60 := 'T_REF';        -- Тип атрибут ссылка на НСО    
    --
    _parent_attr_code public.t_str60  := utl.com_f_empty_string_to_null (upper(btrim (p_parent_attr_code))); -- Код родительского атрибута
    _attr_type_code   public.t_str60  := utl.com_f_empty_string_to_null (upper(btrim (p_attr_type_code))); -- Код типа атрибута
    _attr_code        public.t_str60  := utl.com_f_empty_string_to_null (upper(btrim (p_attr_code))); -- Код атрибута
    _attr_name        public.t_str250 := utl.com_f_empty_string_to_null (btrim (p_attr_name));               -- Имя атрибута 
    _domain_nso_code  public.t_str60  := utl.com_f_empty_string_to_null (upper(btrim (p_domain_nso_code))); -- Код НСО-домена
    --
    _attr_id  public.id_t;
    --
     rsp_main public.result_long_t;
    --
    _exception  public.exception_type_t;
    _err_args   public.t_arr_text := ARRAY [''];
    -- ----------------------------
  BEGIN
  	  -- проверка на корректность данных
     IF (   ( _parent_attr_code IS NULL ) OR ( _attr_type_code IS NULL ) 
         OR ( _attr_code        IS NULL ) OR ( _attr_name      IS NULL )
         OR ( p_attr_uuid       IS NULL ) OR ( p_date_from     IS NULL)
         OR ( p_date_to         IS NULL )
        )
      THEN
        RAISE SQLSTATE '60000'; -- NULL значения запрещены
     END IF;
     --
     IF (NOT EXISTS (SELECT FROM com_codifier.com_f_obj_codifier_s (c_ATTR_TYPE, _attr_type_code))
      ) THEN
             _err_args [1] := _attr_type_code;
      	     RAISE SQLSTATE '61070'; -- неверный тип атрибута
     END IF;
      
   -- Атрибут быть привязан только к  узловому элементу  
   IF ( c_DOMEN_NODE <> ( SELECT c.codif_code FROM ONLY com.nso_domain_column d, ONLY com.obj_codifier c 
          WHERE ( d.attr_type_id = c.codif_id ) AND ( d.attr_code = _parent_attr_code ))
      )    
     THEN
             _err_args [1] := c_DOMEN_NODE;
      	     RAISE SQLSTATE '61071';  
   END IF;
   --
   -- Неправильный код родительского атрибута
   --
   IF ( NOT EXISTS (SELECT 1 FROM ONLY com.nso_domain_column WHERE (attr_code = _parent_attr_code)))
    THEN
          _err_args [1] := _parent_attr_code;
          RAISE SQLSTATE '61051';
   END IF;

   -- для ссылочного поля НСО, код НС-объекта обязательно должен быть заполнен
   IF ((_attr_type_code = c_TREF) AND (_domain_nso_code IS NULL)) 
    THEN
         _err_args [1] := c_TREF;
        RAISE SQLSTATE '61072';
   END IF;
   --
   IF ( p_date_from > p_date_to ) THEN
      _err_args [1] := p_date_from::text;
      _err_args [2] := p_date_to::text;
      RAISE SQLSTATE '60005';
   END IF;   
   --  
  	INSERT INTO com.nso_domain_column
  		(  parent_attr_id       
        ,attr_type_id     
        ,small_code     
        ,attr_code            
        ,attr_name            
        ,attr_uuid            
        ,domain_nso_id        
        ,domain_nso_code -- 2016-06-29 Nick
        ,date_from            
        ,date_to   
        ,id_log
      )
  	    VALUES ( (SELECT attr_id FROM ONLY com.nso_domain_column WHERE ( attr_code = _parent_attr_code)) 
                ,(SELECT codif_id FROM ONLY com.obj_codifier WHERE ( codif_code = _attr_type_code))
                ,(SELECT small_code FROM ONLY com.obj_codifier WHERE ( codif_code = _attr_type_code))
                ,_attr_code            
                ,_attr_name            
                ,p_attr_uuid            
                ,CASE WHEN _domain_nso_code IS NOT NULL THEN
                            (SELECT nso_id FROM ONLY nso.nso_object WHERE ( btrim (nso_code) = _domain_nso_code ))
                      ELSE
                         NULL
                 END
                ,_domain_nso_code -- Nick 2016-06-29
                ,p_date_from            
                ,p_date_to                  
		,NULL
       );
      _attr_id := CURRVAL (c_SEQ_NAME_NSO_DOMAIN_COLUMN);
  
  		rsp_main := ( _attr_id, c_MESS00 );
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

COMMENT ON FUNCTION com_domain.nso_p_domain_column_i (public.t_str60, public.t_str60, public.t_str60, public.t_str250, public.t_guid, public.t_str60, public.t_timestamp, public.t_timestamp) 
   IS '165: Создание записи в домене атрибутов

     Аргументы:
          p_parent_attr_code  public.t_str60   -- Код родительского атрибута
         ,p_attr_type_code    public.t_str60   -- Код типа атрибута
           --
         ,p_attr_code         public.t_str60   -- Код атрибута
         ,p_attr_name         public.t_str250  -- Наименование атрибута
         ,p_attr_uuid         public.t_guid    -- UUID атрибута
           -- По умолчанию
         ,p_domain_nso_code   public.t_str60 = NULL -- Код НСО-домена
          -- 
         ,p_date_from         public.t_timestamp = now()::public.t_timestamp     -- Начало периода актуальности
         ,p_date_to           public.t_timestamp = ''9999-12-31 00:00:00''::public.t_timestamp -- Конец периода актуальности 

     Выходные величины:
				 rsp_main.rc = nn - процедура завершилась успешно
				 rsp_main.rc = -1 - процедура завершилась с ошибкой
             --
             rsp_main.errm = <Сообщение>
';
-- -------------------------------------------------
-- SELECT * FROM plpgsql_check_function_tb ('com_domain.nso_p_domain_column_i ( t_str60, t_str60, t_str60, t_str250, t_guid, t_str60)');
-- SELECT * FROM com_codifier.com_f_obj_codifier_s('C_ATTR_TYPE');
/* Примеры использования
   SELECT * FROM com.nso_f_domain_column_s ('APP_NODE');
   SELECT * FROM com.nso_f_domain_column_s ('NSO_TECH_NODE');
   SELECT * FROM com.nso_f_domain_column_s ();

   SELECT * FROM com.nso_p_domain_column_i ( 'APP_NODE', 'T_GUID', 'FC_UUID', 'Универсальный уникальный идентификатор', '73F64B63-C2BB-4797-8F6A-601462319016');
   SELECT * FROM com.nso_p_domain_column_i ( 'APP_NODE', 'T_STR60', 'FC_CODE', 'Код', '7AAF7FDB-4C36-44F1-A015-E3EA5663D70E');
   SELECT * FROM com.nso_p_domain_column_i ( 'APP_NODE', 'T_STR250', 'FC_NAME', 'Наименование', '7269A319-3EEE-472A-8FBC-A241C86719BE');
   SELECT * FROM com.nso_p_domain_column_i ( 'APP_NODEzz', 'T_STR250', 'FC_NAME', 'Наименование', '7269A319-3EEE-472A-8FBC-A241C86719BE'); !!!!
   SELECT * FROM com.nso_p_domain_column_i ( NULL, 'T_STR250', 'FC_NAME', 'Наименование', '7269A319-3EEE-472A-8FBC-A241C86719BE'); 
*/



