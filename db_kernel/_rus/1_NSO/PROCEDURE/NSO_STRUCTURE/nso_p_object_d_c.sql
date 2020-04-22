/* ---------------------------------------------------------------------------------------------------------------------
        Входные параметры:
                1) p_nso_code  public.t_str60   -- Код НСО
                2) p_node_flag public.t_boolean -- Разрешение на удаление узлового элемента, по умолчанию FALSE (запрещено)
	Выходные параметры:
                1) _result        public.result_long_t                -- Пользовательский тип для индикации успешности выполнения
                1.1) _result.rc   bigint                  -- 0 (при успехе) / -1 (при ошибке)
                1.2) _result.errm character varying(2048) -- Сообщение
--------------------------------------------------------------------------------------------------------------------- */
DROP FUNCTION IF EXISTS nso_structure.nso_p_object_d (public.t_str60,public.t_boolean);
CREATE OR REPLACE FUNCTION nso_structure.nso_p_object_d
(
        p_nso_code  public.t_str60   -- Код НСО
       ,p_node_flag public.t_boolean -- Разрешение на удаление узлового элемента
                DEFAULT FALSE -- По умолчанию - запрещено
)
RETURNS public.result_long_t 
   SET search_path = nso, com, utl, com_codifier, com_domain, nso_strucrure, com_error, public,pg_catalog
 AS 
$$
   -- =======================================================================
   -- Author: Gregory
   -- Create date: 2015-09-06
   -- Description: Удаление нормативно-справочного объекта
   -- -------------------------------------------------------------------
   -- Nick 2016-08-26  Удаление записей из таблицы контроля уникальности.
   -- =======================================================================
   DECLARE
     _nso_code        public.t_str60 := utl.com_f_empty_string_to_null (upper( btrim (p_nso_code)));
     _nso_id          public.id_t;
     _is_group        public.t_boolean;
     _result          public.result_long_t;
     c_ERR_FUNC_NAME  public.t_sysname := 'nso_p_object_d';
     c_MESS_OK        public.t_str1024;
     --   
     _exception  public.exception_type_t;
     _err_args   public.t_arr_text := ARRAY [''];
     --
     C_DEBUG public.t_boolean := utl.f_debug_status();
     
   BEGIN
      IF _nso_code IS NOT NULL
      THEN
          SELECT nso_id, is_group_nso INTO _nso_id, _is_group FROM ONLY nso.nso_object
          WHERE (nso_code = _nso_code);
          
          c_MESS_OK = 'Успешно удален нормативно-справочный объект с кодом "' || _nso_code || '".';

          IF _nso_id IS NOT NULL
          THEN
               IF (_is_group AND p_node_flag) OR _is_group IS FALSE
               THEN
                   PERFORM nso.nso_p_nso_log_i ('3','Физическое удаление НСО: ' || _nso_code); -- важно первым засветиться в логе
                   IF _is_group
                   THEN
                         PERFORM nso_structure.nso_p_object_d(nso_id, p_node_flag) FROM ONLY nso.nso_object
                          WHERE parent_nso_id = _nso_id;
                   END IF;
                   --
                   DELETE FROM ONLY nso.nso_abs WHERE rec_id IN
                           (SELECT rec_id FROM ONLY nso.nso_record WHERE nso_id = _nso_id);
                   --
                   DELETE FROM ONLY nso.nso_blob WHERE rec_id IN
                           (SELECT rec_id FROM ONLY nso.nso_record WHERE nso_id = _nso_id);  
                   --  
                   DELETE FROM ONLY nso.nso_ref WHERE rec_id IN
                           (SELECT rec_id FROM ONLY nso.nso_record WHERE nso_id = _nso_id);
                   -- Nick 2016-08-26 
                   DELETE FROM nso.nso_record_unique WHERE ( rec_id IN (
                           (SELECT rec_id FROM ONLY nso.nso_record WHERE nso_id = _nso_id)
                   ));
                   -- Nick 2016-08-26
                   DELETE FROM ONLY nso.nso_record WHERE nso_id = _nso_id;
                   --
                   DELETE FROM ONLY nso.nso_key_attr WHERE key_id IN
                           (SELECT key_id FROM ONLY nso.nso_key WHERE nso_id = _nso_id);
                   --
                   DELETE FROM ONLY nso.nso_key         WHERE nso_id = _nso_id;
                   DELETE FROM ONLY nso.nso_column_head WHERE nso_id = _nso_id;
                   DELETE FROM ONLY nso.nso_object      WHERE nso_id = _nso_id;
                   -- Nick 2016-08-26 Очищаем домен колонок

                   IF ( NOT _is_group ) THEN
                          _result := com_domain.nso_p_domain_column_d ( 'D_' || _nso_code );
                          IF ( _result.rc <0 ) THEN
                                                      RAISE '%', _result.errm;
                          END IF;
                   END IF;
               ELSE
                       _result.rc = -1;
                       _result.errm = 'Удаление запрещено';
                       RETURN _result;
               END IF;
           ELSE  -- Запись не найдена 
               _err_args [1] := _nso_id::text;
               RAISE SQLSTATE '62022';
          END IF; -- Запись не найдена 
      ELSE
              RAISE SQLSTATE '60000'; -- NULL значения запрещены
      END IF;
    	
  	 _result.rc = _nso_id;
     _result.errm = c_MESS_OK;
    
    RETURN _result;
        
   EXCEPTION
        WHEN OTHERS THEN
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

COMMENT ON FUNCTION nso_structure.nso_p_object_d (public.t_str60,public.t_boolean) 
IS '193: Удаление Нормативно-Справочного Объекта, аргумент код НСО
        Входные параметры:
                1) p_nso_code  public.t_str60   -- Код НСО
                2) p_node_flag public.t_boolean -- Разрешение на удаление узлового элемента, по умолчанию FALSE (запрещено)
	Выходные параметры:
                1) _result        public.result_long_t                -- Пользовательский тип для индикации успешности выполнения
                1.1) _result.rc   bigint                  -- 0 (при успехе) / -1 (при ошибке)
                1.2) _result.errm character varying(2048) -- Сообщение';

-- SELECT * FROM nso.nso_p_object_d('SPR_RNTD');
-- UPDATE или DELETE в таблице "nso_object" нарушает ограничение внешнего ключа "fk_nso_object_can_define_nso_domain_column" таблицы "nso_domain_column"
-- SELECT * FROM com.nso_f_domain_column_s();
-- SELECT * FROM com.nso_p_domain_column_d('FC_SPR_RNTD');

-- SELECT * FROM nso.nso_p_object_d(NULL);
-- -1;"Все параметры явялются обязательными, NULL значения запрещены. Ошибка произошла в функции: "nso_p_object_d"."

-- SELECT * FROM nso.nso_p_object_d('SPR_PAYMENT_STATUS_');
-- -1;"Запись не найдена. Ошибка произошла в функции: "nso_p_object_d"."

-- SELECT * FROM nso.nso_p_object_d('SPR_PAYMENT_STATUS'); ROLLBACK;
-- 
