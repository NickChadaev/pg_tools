/* ---------------------------------------------------------------------------------------------------------------------
        Входные параметры:
                1) p_nso_code     public.t_str60   -- Код НСО
                2) p_unique_check public.t_boolean -- Контроль уникальности
	Выходные параметры:
                1) _result        public.result_long_t                -- Пользовательский тип для индикации успешности выполнения
                1.1) _result.rc   bigint                  -- ID НСО (при успехе) / -1 (при ошибке)
                1.2) _result.errm character varying(2048) -- Сообщение
--------------------------------------------------------------------------------------------------------------------- */
DROP FUNCTION IF EXISTS nso_data.nso_p_object_unique_check_on(public.t_str60,public.t_boolean);
CREATE OR REPLACE FUNCTION nso_data.nso_p_object_unique_check_on
(
        p_nso_code     public.t_str60   -- Код НСО
       ,p_unique_check public.t_boolean -- Контроль уникальности
                DEFAULT TRUE
)
  RETURNS public.result_long_t
        SET search_path = nso, com, utl, com_codifier, com_domain, nso_data, db_info, com_error, public,pg_catalog
  AS 
  $$
	-- =============================================================================== 
	-- Author: Gregory
	-- Create date: 2016-07-10
	-- Description: Контроль уникальности НСО
	--  2019-09-04 Nick Новое ядро
	-- ===============================================================================   
   DECLARE
      _nso_id   public.id_t;
      _nso_name public.t_str250;
      _log_id   public.id_t;
        
      _tr_nso_object_ud public.t_boolean;
      
      _result          public.result_long_t;
      
      c_ERR_FUNC_NAME public.t_sysname = 'nso_p_object_unique_check_on';
      c_MESS_ON       public.t_str1024 = 'Контроль уникальности Активен.';
      c_MESS_OFF      public.t_str1024 = 'Контроль уникальности Неактивен.';
      c_MESS_NOT      public.t_str1024 = 'Отсутствуют метки уникальности.'; -- Nick 2016-07-19
      c_MESS_OK       public.t_str1024 = 'Режим контроля уникальности не меняется.';
      
      _nso_code  public.t_str60  := utl.com_f_empty_string_to_null (btrim (upper (p_nso_code)));  -- Код объекта владельца
      --
      _exception  public.exception_type_t;
      _err_args   public.t_arr_text := ARRAY [''];

   BEGIN
        IF _nso_code IS NOT NULL
        THEN
                SELECT nso_id, nso_name INTO _nso_id, _nso_name
                 FROM ONLY nso.nso_object WHERE (nso_code = _nso_code);
        ELSE
                RAISE SQLSTATE '60000'; -- NULL значения запрещены
        END IF;

        IF _nso_id IS NULL
        THEN
               _err_args [1] := _nso_code;
               RAISE SQLSTATE '62020';  -- Нет НСО 
        END IF;
        
        IF (SELECT unique_check != p_unique_check FROM ONLY nso.nso_object WHERE (nso_id = _nso_id))
        THEN
             IF EXISTS ( SELECT 1 FROM ONLY nso.nso_key nk
                                    JOIN ONLY nso.nso_key_attr nka ON (nka.key_id = nk.key_id)
                             WHERE (nk.nso_id = _nso_id) AND (nk.key_small_code IN ('a', 'b', 'c', 'd')) 
                         LIMIT 1
             )
             THEN    -- Nick 2016-07-19
               _tr_nso_object_ud := db_info.db_info_f_trigger_status_get ('tr_nso_object_ud'::public.t_sysname);
               
               -- Проверить !!! Nick 2019-09-04
               -- SELECT tgenabled != 'D' INTO _tr_nso_object_ud FROM pg_trigger WHERE tgname = 'tr_nso_object_ud';
               IF _tr_nso_object_ud THEN ALTER TABLE nso.nso_object DISABLE TRIGGER tr_nso_object_ud; END IF;        
               
               RAISE NOTICE '%', c_MESS_ON  || ' ' || _nso_code || '. ' || _nso_name;

               IF p_unique_check 
               THEN -- ON
                    _log_id = nso.nso_p_nso_log_i ('I', c_MESS_ON  || ' ' || _nso_code || '. ' || _nso_name);
               ELSE -- OFF
                    _log_id = nso.nso_p_nso_log_i ('J', c_MESS_OFF || ' ' || _nso_code || '. ' || _nso_name);
               END IF;

               UPDATE ONLY nso.nso_object SET unique_check = p_unique_check, id_log = _log_id
               WHERE (nso_id = _nso_id);
               -- RETURNING nso_id   Зачем ??? Nick 2016-07-19
               -- INTO _nso_id;
               
               IF p_unique_check
               THEN
                    INSERT INTO nso.nso_record_unique
                          SELECT nr.rec_id, nk.key_small_code, true FROM ONLY nso.nso_record nr
                                          JOIN ONLY nso.nso_key nk USING (nso_id)
                          WHERE (nr.nso_id = _nso_id) AND (nk.key_small_code IN ('a', 'b', 'c', 'd'));
               ELSE
                     DELETE FROM nso.nso_record_unique WHERE rec_id IN (
                             SELECT rec_id FROM ONLY nso.nso_record WHERE (nso_id = _nso_id)
                     );
               END IF;

               IF _tr_nso_object_ud THEN ALTER TABLE nso.nso_object ENABLE TRIGGER tr_nso_object_ud; END IF;        

               _result.rc = _nso_id;
               IF p_unique_check
               THEN
                       _result.errm = c_MESS_ON;
               ELSE
                       _result.errm = c_MESS_OFF;
               END IF;

             ELSE
                     _result.rc = -1;
                     _result.errm = c_MESS_NOT;
             END IF;
        ELSE
                _result.rc = 0;
                _result.errm = c_MESS_OK;
        END IF;

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
SECURITY DEFINER
LANGUAGE plpgsql ;

COMMENT ON FUNCTION nso_data.nso_p_object_unique_check_on (public.t_str60, public.t_boolean)
IS '232: Контроль уникальности НСО
        Входные параметры:
                1) p_nso_code     public.t_str60                -- Код НСО
                2) p_unique_check public.t_boolean DEFAULT TRUE -- Признак активного контроля уникальности
	Выходные параметры:
                1) _result        public.result_long_t                -- Пользовательский тип для индикации успешности выполнения
                1.1) _result.rc   bigint    -- ID НСО (при успехе) / -1 (при ошибке)
                1.2) _result.errm text      -- Сообщение';
/**
SELECT * FROM plpgsql_check_function_tb ('nso_data.nso_p_object_unique_check_on (public.t_str60, public.t_boolean)');                
**/

-- SELECT * FROM nso.nso_p_object_unique_check_on ('spr_rntd', TRUE);
-- SELECT * FROM nso.nso_record_unique WHERE rec_id IN (2900,2899);
-- SELECT * FROM nso.nso_f_record_select_all('spr_rntd');
-- DROP INDEX IF EXISTS ak1_nso_record_unique;
-- CREATE UNIQUE INDEX ak1_nso_record_unique ON nso.nso_record_unique (
--      scode,
--      unique_check,
--   -- nso.nso_f_record_unique_idx(rec_id,scode)
--      nso.nso_f_nso_record_unique_sign_idx(rec_id,scode)
-- )
-- WHERE unique_check IS TRUE;

-- -------------------------------------------------------------------------------------------------------------------
-- Тестирование.
-- SELECT * FROM nso.nso_f_column_head_nso_s ('spr_blob'); -- Нет  уникальностей.
-- SELECT * FROM nso.nso_f_column_head_nso_s ('kl_secr'); -- 'KL_SECR_FC_CODE_2'|'Код'|20|'A'|'T_STR60'|'Строка 60 символов'|t|14|t|1|45|'a'|'AKKEY1'|'Уникальный ключ 1'|1
-- SELECT * FROM nso.nso_f_column_head_nso_s ('CL_TEST'); --'T_GUID'|'UUID'|t|1|t|1|48|'d'|'PKKEY'|'Идентификационный ключ'|1
-- Поехали
-- SELECT * FROM nso.nso_p_object_unique_check_on('spr_blob', TRUE); -- -1|'Отсутствуют метки уникальности.'

-- SELECT * FROM nso.nso_f_nso_object_unique_check('kl_secr');
-- SELECT * FROM nso.nso_p_object_unique_check_on('kl_secr',TRUE); -- 18|'Контроль уникальности Активен.'
-- SELECT * FROM nso.nso_p_object_unique_check_on('CL_TEST',TRUE); -- 7|'Контроль уникальности Активен.'

-- SELECT * FROM nso.nso_record_unique
 
