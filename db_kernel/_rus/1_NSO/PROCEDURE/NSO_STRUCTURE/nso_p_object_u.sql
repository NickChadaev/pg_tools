/* ---------------------------------------------------------------------------------------------------------------------
        Входные параметры:
                1) p_nso_id          public.id_t        -- ID НСО, поисковый аргумент,  всегда NOT NULL
                2) p_parent_nso_code public.t_str60     -- Код родительского НСО,       если NULL - сохраняется старое значение.
                3) p_nso_type_code   public.t_str60     -- Код типа НСО,                если NULL - сохраняется старое значение.
                4) p_nso_uuid        public.t_guid      -- UUID НСО,                    если NULL - сохраняется старое значение.
                5) p_is_intra_op     public.t_boolean   -- Признак интраоперабельности, если NULL - сохраняется старое значение.
                6) p_new_nso_code    public.t_str60     -- Код НСО, новое значение,     если NULL - сохраняется старое значение.
                7) p_nso_name        public.t_str250    -- Наименование НСО,            если NULL - сохраняется старое значение.
                8) p_date_from       public.t_timestamp -- Дата начала актуальности,    если NULL - сохраняется старое значение.
                9) p_date_to         public.t_timestamp -- Дата конца актуальтности,    если NULL - сохраняется старое значение.
	Выходные параметры:
                1) _result        public.result_long_t                -- Пользовательский тип для индикации успешности выполнения
                1.1) _result.rc   bigint                  -- ID НСО (при успехе) / -1 (при ошибке)
                1.2) _result.errm character varying(2048) -- Сообщение
--------------------------------------------------------------------------------------------------------------------- */
DROP FUNCTION IF EXISTS nso_structure.nso_p_object_u(public.id_t,public.t_str60,public.t_str60,public.t_guid,public.t_boolean,public.t_str60,public.t_str250);
CREATE OR REPLACE FUNCTION nso_structure.nso_p_object_u
(
        p_nso_id          public.id_t                   -- ID НСО, поисковый аргумент,  всегда NOT NULL
       ,p_parent_nso_code public.t_str60     DEFAULT NULL -- Код родительского НСО, если NULL - сохраняется старое значение.
       ,p_nso_type_code   public.t_str60     DEFAULT NULL -- Код типа НСО если NULL - сохраняется старое значение.
       ,p_nso_uuid        public.t_guid      DEFAULT NULL -- UUID НСО если NULL - сохраняется старое значение.
       ,p_is_intra_op     public.t_boolean   DEFAULT NULL -- Признак интраоперабельности
       ,p_new_nso_code    public.t_str60     DEFAULT NULL -- Код НСО, новое значение
       ,p_nso_name        public.t_str250    DEFAULT NULL -- Наименование НСО
)
      RETURNS public.result_long_t 
      SET search_path = nso, com, utl, com_codifier, com_domain, nso_strucrure, com_error, public,pg_catalog
  AS 
 $$
   -- ================================================================================================
   --       Author: Gregory
   --       Create date: 2015-09-03
   --       Description: Обновление нормативно-справочного объекта
   --       Modification: 2015-11-02 Gregory добавлен аргумент p_new_nso_code  Ревизия 1044
   --           2016-05-15 Nick Внесены изменения в коды объектов базы: 'C_VIEW' и 'C_MAT_VIEW'
   --           2017-05-28 Nick Изменилась уникальность заголовка. NSO_ID + NSO_CODE  
   --           2019-08-20 Nick Новое ядро.
   -- ================================================================================================
  DECLARE
    _parent_nso_id      public.id_t;
    _is_group           public.t_boolean;
    _nso_type_id        public.id_t;
    _nso_code_old       public.t_str60;
    _nso_code_new       public.t_str60;
    _record             RECORD;
    _result             public.result_long_t;
     --
    _parent_nso_code public.t_str60  := utl.com_f_empty_string_to_null (upper( btrim (p_parent_nso_code))); -- Код родительского НСО, если NULL - сохраняется старое значение.
    _nso_type_code   public.t_str60  := utl.com_f_empty_string_to_null (upper( btrim (p_nso_type_code)));   -- Код типа НСО если NULL - сохраняется старое значение.
    _new_nso_code    public.t_str60  := utl.com_f_empty_string_to_null (upper( btrim (p_new_nso_code)));    -- Код НСО, новое значение
    _nso_name        public.t_str250 := utl.com_f_empty_string_to_null (btrim (p_nso_name));-- Наименование НСО
     --
    c_ERR_FUNC_NAME public.t_sysname = 'nso_p_object_u';
     --    
    _exception      public.exception_type_t;
    _err_args       public.t_arr_text := ARRAY [''];        
    --        
    c_MESS_OK_0 public.t_text = 'Успешно обновлен нормативно-справочный объект с кодом "';
    c_MESS_OK_1 public.t_text = '".';
                
  BEGIN
        IF p_nso_id IS NULL
        THEN
                RAISE SQLSTATE '60000'; -- NULL значения запрещены
        END IF;

        SELECT nso_id, is_group_nso INTO _parent_nso_id, _is_group  FROM ONLY nso.nso_object
            WHERE (nso_code = _parent_nso_code);

        IF (_parent_nso_code IS NOT NULL) AND (_parent_nso_id IS NULL)
        THEN
                _err_args [1] := _parent_nso_code;
                RAISE SQLSTATE '62003';
        END IF;
        --
        IF NOT (_is_group)
          THEN
                _err_args [1] := _parent_nso_code;
                RAISE SQLSTATE '62003';
        END IF;
        --
        _nso_type_id := com_codifier.com_f_obj_codifier_get_id (_nso_type_code);

        IF (_nso_type_code IS NOT NULL) AND (_nso_type_id IS NULL)
        THEN
                _err_args [1] := _nso_type_code;
                RAISE SQLSTATE '62010';
        END IF;
        --
  	    _nso_code_old := nso_structure.nso_f_object_get_code (p_nso_id);
        --
        UPDATE ONLY nso.nso_object
        SET
             parent_nso_id = COALESCE (_parent_nso_id, parent_nso_id) -- Идентификатор родительского НСО
            ,nso_type_id   = COALESCE (_nso_type_id,   nso_type_id)   -- Тип НСО
            ,nso_uuid      = COALESCE (p_nso_uuid,     nso_uuid)      -- UUID НСО
            ,nso_release   = nso_release + 1 -- Версия НСО
            ,is_intra_op   = COALESCE (p_is_intra_op, is_intra_op) -- Признак интраоперабельности
            ,nso_code      = COALESCE (_new_nso_code, nso_code)    -- Код НСО, новое значение
            ,nso_name      = COALESCE (_nso_name,     nso_name)    -- Наименование НСО
  	    WHERE nso_id = p_nso_id;
  
        IF FOUND
        THEN
             _result.rc = p_nso_id;
             _result.errm = c_MESS_OK_0 || nso_structure.nso_f_object_get_code (p_nso_id) || c_MESS_OK_1;
        ELSE
             _err_args [1] := p_nso_id::text;
              RAISE SQLSTATE '62022'; -- Запись не найдена 
  	    END IF;
    --
  	_nso_code_new := nso_structure.nso_f_object_get_code (p_nso_id);
    --
    IF _nso_code_old != _nso_code_new
    THEN
       RAISE NOTICE 
          'Изменился код НСО: % -> %, обновляются связанные структуры (заголовок, запрос, представление)'
         ,_nso_code_old, _nso_code_new;
       
       UPDATE ONLY nso.nso_column_head
       SET col_code = replace(col_code, _nso_code_old, _nso_code_new)
       WHERE col_code LIKE '%' || _nso_code_old || '%'
           AND nso_id = p_nso_id;

       UPDATE ONLY com.nso_domain_column
       SET attr_code = replace(attr_code, _nso_code_old, _nso_code_new)
       WHERE attr_code LIKE '%' || _nso_code_old || '%';

       UPDATE ONLY nso.nso_key
       SET key_code = replace(key_code, _nso_code_old, _nso_code_new)
       WHERE key_code LIKE '%' || _nso_code_old || '%';

       UPDATE ONLY nso.nso_object
       SET nso_select = nso_structure.nso_f_select_c(nso_code)
       WHERE nso_id = p_nso_id;

       -- Nick 2015-11-09
       FOR _record IN
           SELECT schema_name
                , obj_name
                , obj_type 
                , nso_structure.nso_p_view_c ( upper( btrim ( _nso_code_new ))::public.t_str60, (obj_type = 'C_MAT_VIEW' ), schema_name )
                FROM db_info.f_show_tbv_descr ( NULL, NULL ) WHERE obj_name = 'v_' || lower ( btrim ( _nso_code_old ))    
       LOOP
           IF _record.obj_type = 'C_MAT_VIEW' -- -- Nick 2016-05-16
           THEN
                 EXECUTE 'DROP ' || _record.obj_type || ' IF EXISTS ' || _record.schema_name || '.' || _record.obj_name;
             ELSIF _record.obj_type = 'C_VIEW' -- Nick 2016-05-16
             THEN
                 EXECUTE 'DROP ' || _record.obj_type || ' IF EXISTS ' || _record.schema_name || '.' || _record.obj_name;
           END IF;
       END LOOP;
       -- Nick 2015-11-09
    END IF;
  	
   RETURN _result;
        
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
		
	   _result := (-1, ( com_error.f_error_handling ( _exception, _err_args )));
			
	   RETURN _result;			
	 END;
  END;
 $$
LANGUAGE plpgsql 
SECURITY DEFINER; -- Nick 2016-02-26

COMMENT ON FUNCTION nso_structure.nso_p_object_u(public.id_t,public.t_str60,public.t_str60,public.t_guid,public.t_boolean,public.t_str60,public.t_str250)
IS '217: Обновление нормативно-справочного объекта, аргумент ID НСО
        Входные параметры:
                1) p_nso_id          public.id_t        -- ID НСО, поисковый аргумент,  всегда NOT NULL
                2) p_parent_nso_code public.t_str60     -- Код родительского НСО,       если NULL - сохраняется старое значение.
                3) p_nso_type_code   public.t_str60     -- Код типа НСО,                если NULL - сохраняется старое значение.
                4) p_nso_uuid        public.t_guid      -- UUID НСО,                    если NULL - сохраняется старое значение.
                5) p_is_intra_op     public.t_boolean   -- Признак интраоперабельности, если NULL - сохраняется старое значение.
                6) p_new_nso_code    public.t_str60     -- Код НСО, новое значение,     если NULL - сохраняется старое значение.
                7) p_nso_name        public.t_str250    -- Наименование НСО,            если NULL - сохраняется старое значение.

        Выходные параметры:
                1) _result        public.result_long_t                -- Пользовательский тип для индикации успешности выполнения
                1.1) _result.rc   bigint                  -- ID НСО (при успехе) / -1 (при ошибке)
                1.2) _result.errm character varying(2048) -- Сообщение';
-- ----------------------------------------------------------------------
-- SELECT * FROM plpgsql_check_function_tb ('nso_structure.nso_p_object_u(public.id_t,public.t_str60,public.t_str60,public.t_guid,public.t_boolean,public.t_str60,public.t_str250)');
--
-- SELECT * FROM plpgsql_check_function_tb (
--     'nso_structure.nso_p_object_u (public.id_t,public.t_str60,public.t_str60,public.t_guid,public.t_boolean,public.t_str60,public.t_str250)'
--     , security_warnings := true, fatal_errors := false
--     );
-------------------------------------------------------
-- 'nso_p_object_u'|119|'EXECUTE'|'00000'|'text type variable is not sanitized'|'The EXECUTE expression is SQL injection vulnerable.'|'Use quote_ident, quote_literal or format function to secure variable.'|'security'|19|'SELECT 'DROP ' || _record.obj_type || ' IF EXISTS ' || _record.schema_name || '.' || _record.obj_name'|''
-- 'nso_p_object_u'|122|'EXECUTE'|'00000'|'text type variable is not sanitized'|'The EXECUTE expression is SQL injection vulnerable.'|'Use quote_ident, quote_literal or format function to secure variable.'|'security'|19|'SELECT 'DROP ' || _record.obj_type || ' IF EXISTS ' || _record.schema_name || '.' || _record.obj_name'|''
    
--
-- 'nso_p_object_u'|101|'FOR over SELECT rows'|'42883'|'function nso.nso_p_view_c(t_str60, boolean, t_sysname) does not exist'
-- 'nso_p_object_u'|108|'     IF'|'55000'|'record "_record" is not assigned yet'
-- 'nso_p_object_u'|110|'EXECUTE'|'55000'|'record "_record" is not assigned yet'
-- 'nso_p_object_u'|110|'EXECUTE'|'XX000'|'cached plan is not valid plan'
-- 'nso_p_object_u'|110|'EXECUTE'|'55000'|'record "_record" is not assigned yet'
-- 'nso_p_object_u'|113|'EXECUTE'|'55000'|'record "_record" is not assigned yet'
-- 'nso_p_object_u'|113|'EXECUTE'|'XX000'|'cached plan is not valid plan'   !!!
-- 'nso_p_object_u'|  8|'DECLARE'|'00000'|'never read variable "_record"'
--
--  Функция в другой схеме, меняю код.
--
-- 'nso_p_object_u'|110|'EXECUTE'|'00000'|'text type variable is not sanitized'|'The EXECUTE expression is SQL injection vulnerable.'
-- 'nso_p_object_u'|113|'EXECUTE'|'00000'|'text type variable is not sanitized'|'The EXECUTE expression is SQL injection vulnerable.'

-- SELECT * FROM nso.nso_f_object_s_sys('SPR_RNTD');

-- SELECT * FROM nso_structure.nso_p_object_u(31, NULL, NULL, NULL, NULL, NULL, 'Справочник результатов НТД.');

-- SELECT * FROM nso_structure.nso_p_object_u(NULL::public.id_t);
-- -1;"Все параметры явялются обязательными, NULL значения запрещены. Ошибка произошла в функции: "nso_p_object_u"."

-- SELECT * FROM nso_structure.nso_p_object_u('100500');
-- -1;"Запись не найдена. Ошибка произошла в функции: "nso_p_object_u"."

-- SELECT * FROM nso.nso_f_object_s_sys (); 7|5|'CL_TEST'|'Тестовый классификатор'
-- SELECT * FROM nso.v_cl_test;
-- SELECT * FROM com.nso_domain_column WHERE ( attr_code like '%CL_TEST%' );

-- SELECT * FROM nso_structure.nso_p_object_u(24);
-- 24;"Успешно обновлен нормативно-справочный объект с кодом "SPR_PAYMENT_STATUS"."

-- Обновляем, смотрил, что-же получилось.
-- 
-- SELECT * FROM nso_structure.nso_p_object_u (7, NULL, NULL, NULL, NULL, 'CL_TEST_NEW', 'Новый тестовый классификатор' );
-- SELECT * FROM nso_structure.nso_p_object_u (7, NULL, NULL, NULL, NULL, 'CL_TEST', 'Тестовый классификатор' );
--
-- SELECT * FROM nso.nso_f_object_s_sys (); -- 7|5|'CL_TEST'|'Тестовый классификатор'
-- SELECT * FROM nso.v_cl_test;
-- SELECT * FROM nso.v_cl_test_new;
-- SELECT * FROM ONLY com.nso_domain_column WHERE ( attr_code like '%CL_TEST%' );
-- SELECT * FROM ONLY nso.nso_key WHERE (key_code like '%CL_TEST%' );
-- SELECT * FROM ONLY nso.nso_key_attr WHERE ( key_id = 1 );
-- SELECT * FROM ONLY nso.nso_key WHERE (key_id IN (1, 2) );
-- ---------------------------------------------------
-- SELECT * FROM nso.nso_f_column_head_nso_s ('CL_TEST_NEW');
-- SELECT * FROM nso.nso_f_column_head_nso_s ('CL_TEST');
-- SELECT * FROM nso_structure.nso_p_object_u('24', 'BUBLIK');
-- -1;"Запись родительского НСО с кодом "BUBLIK" не найдена."

-- SELECT * FROM nso_structure.nso_p_object_u(24, 'SPR_LOCAL');
-- 24;"Успешно обновлен нормативно-справочный объект с кодом "SPR_PAYMENT_STATUS"."

-- SELECT * FROM nso_structure.nso_p_object_u(24, 'SPR_LOCAL', 'BUBLIK');
-- -1;"Запись типа НСО с кодом "BUBLIK" не найдена."

-- SELECT * FROM nso_structure.nso_p_object_u(24, 'SPR_LOCAL', 'C_NSO_SPR');
-- 24;"Успешно обновлен нормативно-справочный объект с кодом "SPR_PAYMENT_STATUS"."

-- SELECT * FROM nso.nso_object_hist

-- SELECT * FROM nso_structure.nso_p_object_u (16, 'SPR_EMPLOYE');
-- -1;"Родительского НСО нет, либо он не узловой. Ошибка произошла в функции: "nso_p_object_u"."

-- SELECT * FROM ONLY nso.nso_object WHERE nso_code = 'CL_TEST' OR nso_id = 5
-- SELECT * FROM nso_structure.nso_p_object_u(7, 'CL_LOCAL');

-- SELECT * FROM nso_structure.nso_p_object_u(7, NULL, NULL, NULL, NULL, 'CL_TEST');
-- SELECT * FROM ONLY nso.nso_object
-- SELECT * FROM ONLY com.nso_domain_column
-- SELECT * FROM ONLY nso.nso_column_head
-- SELECT * FROM ONLY nso.nso_key
-- 
