/*-----------------------------------------------------------------------------------------------
	Входные параметры
						 p_nso_code	      public.t_str60    -- Код НСО
						,p_key_type_code  public.t_str60    -- Тип кода ключа
                  ,p_attr_code      public.t_arr_code -- Массив кодов атрибутов, образующих ключ

	Выходные параметры
				  public.result_long_t.rc > 0 - ID созданного атрибута
				  public.result_long_t.rc <   - Процедура завершилась с ошибкой
              public.result_long_t.errm   - Сообщение об ошибке
-----------------------------------------------------------------------------------------------*/
DROP FUNCTION IF EXISTS nso_structure.nso_p_key_i ( public.t_str60, public.t_str60, public.t_arr_code, public.t_boolean, public.t_timestamp, public.t_timestamp );
CREATE OR REPLACE FUNCTION nso_structure.nso_p_key_i (				         
					   p_nso_code	    public.t_str60    -- Код НСО
					  ,p_key_type_code  public.t_str60    -- Тип кода ключа
                      ,p_attr_codes     public.t_arr_code -- Массив кодов атрибутов, образующих ключ
                      --------  По умолчанию
                      ,p_on_off         public.t_boolean = TRUE  --   Признак активного ключа
                       --
                      ,p_date_from      public.t_timestamp = CURRENT_TIMESTAMP::TIMESTAMP(0) WITHOUT TIME ZONE
                      ,p_date_to        public.t_timestamp = '9999-12-31 00:00:00'::TIMESTAMP(0) WITHOUT TIME ZONE
                   )
  RETURNS  public.result_long_t 
      SECURITY DEFINER -- 2015-04-05 Nick
      LANGUAGE plpgsql
      SET search_path = nso, com, utl, com_codifier, com_domain, nso_strucrure, com_error, public,pg_catalog
   AS 
    -- ===============================================================================================
    -- Author:		OLGA
    -- Create date: 2014-09-02
    -- Description:	Добавление новой строки в таблицу ключ
    -- ------------------------------------------------------
    --  2015-03-21 На основе этой функции создаётся новая, создающая ключевую структуру полностью,
    --             заголовок и ссылки на атрибуты
    -- Nick
    -- 2015-05-30 перенес nso_domain_column  в COM
    -- 2015-07-04 Обнаружена ошибка, связанная со старой концепцией: 
    --            "Код атрибута находится в справочнике доменов".  Теперь актуальный код в заголовке.
    -- ----------------------------------------------------------------------------------------------
    -- 2015-10-14 Исправления ревизия 846  Gregory                          
    -- --------------------------------------------------------------------
    -- 2016-11-09  Gregory  Введено обращение к функции логгирования.       
    -- 2017-12-19  Gregory c_SEQ_NAME_NSO_LOG nso.nso_log_id_log_seq -> com.all_history_id_seq.
    -- 2019-08-25  Nick   Новое ядро                        
    -- ===============================================================================================
$$
  DECLARE 
      _key_id          public.id_t;
      _key_type_id     public.id_t;
      _nso_id          public.id_t;
      _col_id          public.id_t;
      _log_id          public.id_t;
      _key_small_code  public.t_code1;
      --
      _nso_code      public.t_str60 := utl.com_f_empty_string_to_null (upper( btrim (p_nso_code)));   --  Код НСО
      _key_type_code public.t_str60 := utl.com_f_empty_string_to_null (upper( btrim (p_key_type_code)));   --  Тип ключа
      -- 
      _attr_codes  public.t_arr_code; -- Массив кодов атрибутов, образующих ключ
      --
      c_MESS00  public.t_str1024 = 'Выполнено успешно';  
      c_MESS01  public.t_str60   = 'K_'; 
      c_MESS11  public.t_str60   = '_';
      c_MESS03  public.t_code1   = 'C';   --  создание заголовка  ключа 
      c_MESS04  public.t_str60   = 'Создан ключ: "';
      c_MESS06  public.t_str60   = '"';
      --
      c_KEY_TYPE  public.t_str60 = 'C_KEY_TYPE';
      --
      c_ERR_FUNC_NAME     public.t_sysname = 'nso_p_key_i';
      c_SEQ_NAME          public.t_sysname = 'nso.nso_key_key_id_seq';
      -- c_SEQ_NAME_NSO_LOG  public.t_sysname = 'com.all_history_id_seq';
      --
      rsp_main public.result_long_t;
      -- 
      _ind_ar public.t_int = 1; -- Текущий индекс в массиве
     --
     _exception  public.exception_type_t;
     _err_args   public.t_arr_text := ARRAY [''];
     --
     C_DEBUG public.t_boolean := utl.f_debug_status();
     
  BEGIN
     IF (   ( _nso_code      IS NULL ) 
         OR ( _key_type_code IS NULL) 
         OR ( p_attr_codes   IS NULL ) 
        )
      THEN
        RAISE SQLSTATE '60000'; -- NULL значения запрещены
     END IF;
     -- 
     _nso_id := nso_structure.nso_f_object_get_id (_nso_code); -- Nick 2019-08-25   
     IF ( _nso_id IS NULL ) THEN
            _err_args [1] := _nso_code::text;
            RAISE SQLSTATE '62020';
     END IF;
     --
     -- Nick 2015-08-28/2019-08-25 Объединил в один оператор         
     --
     SELECT codif_id, small_code INTO _key_type_id, _key_small_code 
            FROM com_codifier.com_f_obj_codifier_s_sys (C_KEY_TYPE) WHERE (codif_code = _key_type_code);                                                                          
     --                                                                              
     IF (( _key_type_id IS NULL ) OR ( _key_small_code IS NULL )) 
     THEN
          _err_args [1] := _key_type_code::text;
          _err_args [2] := C_KEY_TYPE::text;
          RAISE SQLSTATE '62040'; -- Неправильный код типа ключа
     END IF;
     -- 
     -- Nick 2019-08-25, вычищен мусор в массиве аттрибутов.
     --
     SELECT array_agg (z.col_code::varchar(60) )::public.t_arr_code INTO _attr_codes
     FROM     
         (SELECT unnest (p_attr_codes) AS col_code ) x, ONLY nso.nso_column_head z
      WHERE ( z.col_code = utl.com_f_empty_string_to_null (upper( btrim (x.col_code)))) AND (nso_id = _nso_id);     
     --
     IF (array_length (_attr_codes, 1) IS NULL)
       THEN
          _err_args [1] := p_attr_codes::text;
          RAISE SQLSTATE '62041'; -- Неправильный массив аттрибутов, образующих ключ.     
     END IF;
     --
     IF C_DEBUG 
       THEN
             RAISE NOTICE '<%>, %, %, %', c_ERR_FUNC_NAME, _nso_code, _key_type_code, _attr_codes;
     END IF;
     
     _log_id = nso.nso_p_nso_log_i (c_MESS03, (c_MESS04 || c_MESS01 || _nso_code || c_MESS11 || _key_type_code || c_MESS06));
     INSERT INTO nso.nso_key (
            nso_id          
           ,key_type_id     
           ,key_small_code  -- Краткий код типа ключа
           ,key_code         
           ,on_off          
           ,date_from      
           ,date_to
           ,log_id -- 2016-11-09 Gregory   
       	)        
       VALUES (  
       	   _nso_id
       	 , _key_type_id
       	 , _key_small_code -- Nick
       	 , (c_MESS01 || _nso_code || c_MESS11 || _key_type_code)
         , p_on_off    
         , p_date_from 
         , p_date_to
         ,_log_id -- 2016-11-09 Gregory   
        );
       _key_id := CURRVAL (c_SEQ_NAME);      
       -- --------------------------------------------
       -- 2015-08-27 Gregory: Перенесено. 
       -- 2016-11-09 Gregory  Убрано прямое обращение к LOG таблице.
       -- ----------------------------------------------------------   
        -- 2015-08-27 Gregory: Перенесено выше INSERT INTO nso.nso_log...
        -- Nick: _log_id получен и не изменяется до конца функции.
        --
       _ind_ar := 1;
        WHILE ( _ind_ar <= ARRAY_UPPER ((_attr_codes), 1) ) LOOP -- массив с кодами атрибутов -- Nick 2015-07-04
          _col_id := ( SELECT c.col_id FROM ONLY nso.nso_column_head c 
                                      WHERE (c.col_code = _attr_codes[_ind_ar]) AND (c.nso_id = _nso_id)                                      

          ); 
          INSERT INTO nso.nso_key_attr (
                 key_id        
                ,col_id        
                ,column_nm    
                ,log_id
          ) VALUES (
             _key_id
            ,_col_id 
            ,_ind_ar::public.small_t
            ,_log_id
          );
          _ind_ar := _ind_ar + 1;

   	  -- 2015-08-27 Gregory: Обновление ключа в nso_abs.
        -- 2015-08-28 Nick: Убрал собственную глупость связанную с обновлением LOG_ID  в "nso.nso_key_attr"
        UPDATE ONLY nso.nso_abs SET  s_key_code = _key_small_code, log_id = _log_id WHERE (col_id = _col_id);
       END LOOP;
       -- ----------------------------------------------------------------------
       -- 2016-11-09 Gregory  Убрано обновление таблицы NSO_KEY атрибут  LOG_ID.
       -- ----------------------------------------------------------------------
       rsp_main := ( _key_id, c_MESS00 );
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

COMMENT ON FUNCTION nso_structure.nso_p_key_i ( public.t_str60, public.t_str60, public.t_arr_code, public.t_boolean, public.t_timestamp, public.t_timestamp ) 
   IS '226: Создание заголовка ключа для НСО

   Входные параметры
				   p_nso_code	    public.t_str60    -- Код НСО
				  ,p_key_type_code  public.t_str60    -- Тип кода ключа
                  ,p_attr_code      public.t_arr_code -- Массив кодов атрибутов, образующих ключ

	Выходные параметры
				  public.result_long_t.rc > 0 - ID созданного ключевого атрибута
				  public.result_long_t.rc <   - Процедура завершилась с ошибкой
              public.result_long_t.errm   - Сообщение об ошибке
   ';

 -- --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--  SELECT * FROM plpgsql_check_function_tb ('nso_structure.nso_p_key_i ( public.t_str60, public.t_str60, public.t_arr_code, public.t_boolean, public.t_timestamp, public.t_timestamp )');
-- ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- 'nso_p_key_i'|22|'DECLARE'|'00000'|'never read variable "c_key_type"'        |''|''|'warning extra'||''|''
-- 'nso_p_key_i'|26|'DECLARE'|'00000'|'never read variable "c_seq_name_nso_log"'|''|''|'warning extra'||''|''
-- 'nso_p_key_i'|35|'DECLARE'|'00000'|'never read variable "c_debug"'           |''|''|'warning extra'||''|''
-- ----------------------------------------------------------------------------------------------------------  
-- SELECT * FROM nso.nso_p_key_i('SPR_RNTD','AKKEY1',ARRAY['SPR_RNTD_FC_SPR_RNTD_4']);
-- SELECT * FROM nso.nso_p_key_attr_i('SPR_RNTD','DEFKEY','NAME')
 /*-----------
  SELECT * FROM nso.nso_p_key_i ( 'CL_TEST', 'AKKEY2', ARRAY['FC_PHONE']);
  SELECT * FROM nso.nso_p_key_i ( 'CL_TEST', 'PKKEY', ARRAY['FC_UUID']);
  -- 2015-08-28 
  SELECT * FROM nso.nso_f_column_head_nso_s ( 'SPR_RNTD' );
  -- Сделаем код 'CL_TEST_FC_CODE_1' - Альтернативным ключом №1
  --
  SELECT * FROM nso.nso_f_record_select_all ( 'CL_TEST' ); rec_id IN (1, 2, 3, 4 )
  SELECT * FROM nso.nso_abs WHERE (rec_id IN (1, 2, 3, 4 ));
  SELECT * FROM nso.nso_abs WHERE (col_id = 5);
    1|5|'A'|'0'|t|0|'ТЕСТ1'
    2|5|'A'|'0'|t|0|'ТЕСТ2'
    3|5|'A'|'0'|t|0|'ТЕСТ3'
    4|5|'A'|'0'|t|0|'ТЕСТ4'
  --
  SELECT * FROM nso.nso_p_key_i ( 'CL_TEST', 'AKKEY1', ARRAY['CL_TEST_FC_CODE_1']);
  27|'Выполнено успешно'
  --
    1|5|'A'|'a'|t|62|'ТЕСТ1'
    2|5|'A'|'a'|t|62|'ТЕСТ2'
    3|5|'A'|'a'|t|62|'ТЕСТ3'
    4|5|'A'|'a'|t|62|'ТЕСТ4'
  -- -----------------------------------------------------
  SELECT * FROM nso.nso_log WHERE ( id_log = 62 );
  SELECT * FROM nso.nso_key WHERE ( log_id = 62 );
  SELECT * FROM nso.nso_key_attr WHERE ( log_id = 62 );
  SELECT * FROM nso.nso_p_key_i ( 'CL_TEST', 'IEKEY', NULL);
  SELECT * FROM nso.nso_key;
  SELECT * FROM nso.nso_key_attr;
  DELETE FROM nso.nso_key;
  SELECT * FROM nso.nso_log;

  DELETE FROM nso.nso_key_attr;
  DELETE FROM nso.nso_key;
  DELETE FROM nso.nso_log WHERE ( id_log IN ( 20,21 ));  

  SELECT nso_id FROM nso.nso_object WHERE ( nso_code = upper (btrim ('SPR_EX_ENTERPRISE'))); -- 14
  SELECT codif_id FROM com.obj_codifier WHERE ( codif_code = upper(btrim('DEFKEY')));        -- 39
  SELECT small_code FROM com.obj_codifier WHERE ( codif_code = upper(btrim('DEFKEY')));      -- 'g'
  --
 SELECT c.col_id FROM nso.nso_column_head c, com.nso_domain_column d     -- из разных НСО
                                      WHERE (c.attr_id = d.attr_id) 
                                             AND (c.nso_id = 14 )                                      
                                             AND (btrim (d.attr_code) = btrim (upper( 'FC_CODE' )))
  ---------------------------------------*/

 

