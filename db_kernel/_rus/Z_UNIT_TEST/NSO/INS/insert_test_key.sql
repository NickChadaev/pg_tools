-- -------------------------------------------------------------------------------------------------- --
--  2019-12-31 Nick Прототип UNIT теста для функции "nso_structure.nso_p_key_i"                       --
--   Один запуск - один сформированный маркер/ключ.                                                   --
--                                           Размер маркера/ключа является величиной  случайной.      --
-- -------------------------------------------------------------------------------------------------- --
DO
  $$
     DECLARE
      _arr_nso_code  public.t_arr_code := (SELECT array_agg (nso_code::text) FROM nso_structure.nso_f_object_s_sys() WHERE (date_create = '2011-01-01'::public.t_timestamp));
      _arr_key_len   public.t_arr_nmb  := ARRAY [2, 1, 3, 4]::smallint[];
      _arr_key_type_code  public.t_arr_code:= (SELECT array_agg (codif_code::text) FROM com_codifier.com_f_obj_codifier_s('C_KEY_TYPE') WHERE (codif_code <> 'DEFKEY'));
      --
      _arr_atr_code       public.t_arr_code;
      _arr_key_code       public.t_arr_code;
      --
      _nso_code  public.t_str60;
      _attr_code public.t_str60;
      --
      _head_len  public.small_t;
      _key_len   public.small_t;
      _ind       public.small_t := 1;
      
      C_FUNC_SIGN text := 'nso_structure.nso_p_key_i ( public.t_str60, public.t_str60, public.t_arr_code, public.t_boolean, public.t_timestamp, public.t_timestamp )';
      
      rsp_main   public.result_long_t;  
      _rec_res   RECORD;
      
     BEGIN
       PERFORM utl.f_debug_on ();
       --
       -- Должен быть по крайней мере один объект с сформированным оглавлениенм.
       --
       LOOP
          _nso_code := utl.f_array_random_get_element (_arr_nso_code);
          _arr_nso_code := array_remove (_arr_nso_code::text[], _nso_code::text);
          EXIT WHEN (_nso_code IS NULL);
          --
          _head_len := (SELECT count(*) FROM nso_structure.nso_f_column_head_nso_s(_nso_code));
          _key_len  := utl.f_array_random_get_element (_arr_key_len);   
          EXIT WHEN ((_head_len > 1) AND (_key_len <= _head_len));
       END LOOP;
       --
       IF (_nso_code IS NULL)
         THEN
               RAISE 'Не найден НСО со сформированным заголовком';
       END IF;
       
       RAISE NOTICE 'Этап 1: Выбор НСО: % -- % -- %', _nso_code, _head_len, _key_len;
       --
       SELECT * FROM plpgsql_check_function (C_FUNC_SIGN) INTO _rec_res;
       RAISE NOTICE 'Этап 2: Проверка кода функции: %', _rec_res;

       FOR _rec_res IN SELECT * FROM plpgsql_show_dependency_tb (C_FUNC_SIGN) 
       LOOP 
            RAISE NOTICE 'Этап 3: Проверка зависимостей в коде функции: %', _rec_res;
       END LOOP;
       --
       -- Выбор Атрибута делается случайным образом.
       --
       _arr_atr_code := (SELECT array_agg (attr_code::text) 
                                FROM nso_structure.nso_f_column_head_nso_s(_nso_code) WHERE (number_col > 0)
                        );           
       -- 
       -- Сначала 'DEFKEY'
       --
       LOOP
           _attr_code := utl.f_array_random_get_element (_arr_atr_code);
           _arr_atr_code := array_remove (_arr_atr_code::text[], _attr_code::text);
           IF (_ind = 1 ) THEN
                  _arr_key_code := ARRAY [_attr_code::varchar(60)];
             ELSE
                  _arr_key_code := _arr_key_code::varchar(60)[] || _attr_code::varchar(60);
           END IF;
           _ind := _ind + 1;
           
           EXIT WHEN (_ind > _key_len);  
       END LOOP;
         
       rsp_main :=  nso_structure.nso_p_key_i (				         
       		   p_nso_code	    :=  _nso_code     -- Код НСО
       		  ,p_key_type_code  := 'DEFKEY'       -- Тип кода ключа
              ,p_attr_codes     :=  _arr_key_code -- Массив кодов атрибутов, образующих ключ         
       );         
      -- ---------------------------------------
      RAISE NOTICE 'Этап 5: Выполнение: %', rsp_main;
      IF ( rsp_main.rc < 0 ) THEN
                   RAISE EXCEPTION '%', rsp_main.errm;
      END IF;
      --
      SELECT * FROM nso_structure.nso_f_column_head_nso_s (_nso_code) INTO _rec_res;
      RAISE NOTICE 'Этап 6: Результат: %', _rec_res;

      RAISE NOTICE '--';
      RAISE NOTICE '*********';
      RAISE NOTICE '--';
      --
     END;
  $$
     LANGUAGE plpgsql;
-- ------------------------------------------------------------------------------------
-- NOTICE:  Этап 1: Выбор НСО: N_CODE_2244.96691022068 -- 22 -- 4
-- NOTICE:  Этап 2: Проверка кода функции: ()
-- NOTICE:  Этап 3: Проверка зависимостей в коде функции: (FUNCTION,23560,com_codifier,com_f_obj_codifier_s_sys,"(t_str60)")
-- NOTICE:  Этап 3: Проверка зависимостей в коде функции: (FUNCTION,23588,com_error,f_error_handling,"(exception_type_t,t_arr_text)")
-- NOTICE:  Этап 3: Проверка зависимостей в коде функции: (FUNCTION,23631,nso,nso_p_nso_log_i,"(t_code1,t_text)")
-- NOTICE:  Этап 3: Проверка зависимостей в коде функции: (FUNCTION,23644,nso_structure,nso_f_object_get_id,"(t_str60)")
-- NOTICE:  Этап 3: Проверка зависимостей в коде функции: (FUNCTION,23668,utl,com_f_empty_string_to_null,"(t_text)")
-- NOTICE:  Этап 3: Проверка зависимостей в коде функции: (FUNCTION,23675,utl,f_debug_status,"()")
-- NOTICE:  Этап 3: Проверка зависимостей в коде функции: (RELATION,23840,nso,nso_abs,)
-- NOTICE:  Этап 3: Проверка зависимостей в коде функции: (RELATION,23876,nso,nso_column_head,)
-- NOTICE:  Этап 3: Проверка зависимостей в коде функции: (RELATION,23903,nso,nso_key,)
-- NOTICE:  Этап 3: Проверка зависимостей в коде функции: (RELATION,23914,nso,nso_key_attr,)
-- NOTICE:  <com.com_f_obj_codifier_s_sys> {"{tree_d,ASC}"}
-- NOTICE:  <com.com_f_obj_codifier_s_sys> {0,0,0,0,0,0,0,1,0,0,0}
-- NOTICE:  <com.com_f_obj_codifier_s_sys> {8}
-- NOTICE:  <nso_p_key_i>, N_CODE_2244.96691022068, DEFKEY, {A_CODE_5861.59058380872,A_CODE_2840.45612439513,A_CODE_3349.06225092709}
-- NOTICE:  <nso_p_nso_log_i> C, Создан ключ: "K_N_CODE_2244.96691022068_DEFKEY"
-- NOTICE:  Этап 5: Выполнение: (1,"Выполнено успешно")
-- NOTICE:  Этап 6: Результат: (27,,0,91,D_N_CODE_2244.96691022068,"Заголовок - ИМЯ_7525.54070204496",7,U,C_DOMEN_NODE,"Узловой Атрибут",f,,,,,,,,0)
-- Query returned successfully with no result in 217 msec.


-- SELECT * FROM nso_structure.nso_f_column_head_nso_s('N_CODE_2244.96691022068');
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- NOTICE:  Этап 1: Выбор НСО: N_CODE_2010.83455700427 -- 10 -- 4
-- NOTICE:  Этап 2: Проверка кода функции: ()
-- NOTICE:  Этап 3: Проверка зависимостей в коде функции: (FUNCTION,23560,com_codifier,com_f_obj_codifier_s_sys,"(t_str60)")
-- NOTICE:  Этап 3: Проверка зависимостей в коде функции: (FUNCTION,23588,com_error,f_error_handling,"(exception_type_t,t_arr_text)")
-- NOTICE:  Этап 3: Проверка зависимостей в коде функции: (FUNCTION,23631,nso,nso_p_nso_log_i,"(t_code1,t_text)")
-- NOTICE:  Этап 3: Проверка зависимостей в коде функции: (FUNCTION,23644,nso_structure,nso_f_object_get_id,"(t_str60)")
-- NOTICE:  Этап 3: Проверка зависимостей в коде функции: (FUNCTION,23668,utl,com_f_empty_string_to_null,"(t_text)")
-- NOTICE:  Этап 3: Проверка зависимостей в коде функции: (FUNCTION,23675,utl,f_debug_status,"()")
-- NOTICE:  Этап 3: Проверка зависимостей в коде функции: (RELATION,23840,nso,nso_abs,)
-- NOTICE:  Этап 3: Проверка зависимостей в коде функции: (RELATION,23876,nso,nso_column_head,)
-- NOTICE:  Этап 3: Проверка зависимостей в коде функции: (RELATION,23903,nso,nso_key,)
-- NOTICE:  Этап 3: Проверка зависимостей в коде функции: (RELATION,23914,nso,nso_key_attr,)
-- NOTICE:  <com.com_f_obj_codifier_s_sys> {"{tree_d,ASC}"}
-- NOTICE:  <com.com_f_obj_codifier_s_sys> {0,0,0,0,0,0,0,1,0,0,0}
-- NOTICE:  <com.com_f_obj_codifier_s_sys> {8}
-- NOTICE:  <nso_p_key_i>, N_CODE_2010.83455700427, DEFKEY, {A_CODE_7661.57461795956,A_CODE_1039.21201080084,A_CODE_7735.67220661789,A_CODE_9442.24522449076}
-- NOTICE:  <nso_p_nso_log_i> C, Создан ключ: "K_N_CODE_2010.83455700427_DEFKEY"
-- NOTICE:  Этап 5: Выполнение: (-1,"Ограничение уникальности: nso_key (key_code). Нарушается уникальность в: ""key_code"" - ""АКТУАЛЬНЫЙ КОД КЛЮЧА""
-- 	Детали: Key (key_code)=(K_N_CODE_2010.83455700427_DEFKEY) already exists.
-- 	Контекст: SQL statement ""INSERT INTO nso.nso_key (
--             nso_id          
--            ,key_type_id     
--            ,key_small_code  -- Краткий код типа ключа
--            ,key_code         
--            ,on_off          
--            ,date_from      
--            ,date_to
--            ,log_id -- 2016-11-09 Gregory   
--        	)        
--        VALUES (  
--        	   _nso_id
--        	 , _key_type_id
--        	 , _key_small_code -- Nick
--        	 , (c_MESS01 || _nso_code || c_MESS11 || _key_type_code)
--          , p_on_off    
--          , p_date_from 
--          , p_date_to
--          ,_log_id -- 2016-11-09 Gregory   
--         )""
-- PL/pgSQL function nso_structure.nso_p_key_i(t_str60,t_str60,t_arr_code,t_boolean,t_timestamp,t_timestamp) line 83 at SQL statement
-- PL/pgSQL function inline_code_block line 73 at assignment")
-- ERROR:  Ограничение уникальности: nso_key (key_code). Нарушается уникальность в: "key_code" - "АКТУАЛЬНЫЙ КОД КЛЮЧА"
-- 	Детали: Key (key_code)=(K_N_CODE_2010.83455700427_DEFKEY) already exists.
-- 	Контекст: SQL statement "INSERT INTO nso.nso_key (
--             nso_id          
--            ,key_type_id     
--            ,key_small_code  -- Краткий код типа ключа
--            ,key_code         
--            ,on_off          
--            ,date_from      
--            ,date_to
--            ,log_id -- 2016-11-09 Gregory   
--        	)        
--        VALUES (  
--        	   _nso_id
--        	 , _key_type_id
--        	 , _key_small_code -- Nick
--        	 , (c_MESS01 || _nso_code || c_MESS11 || _key_type_code)
--          , p_on_off    
--          , p_date_from 
--          , p_date_to
--          ,_log_id -- 2016-11-09 Gregory   
--         )"
-- PL/pgSQL function nso_structure.nso_p_key_i(t_str60,t_str60,t_arr_code,t_boolean,t_timestamp,t_timestamp) line 83 at SQL statement
-- PL/pgSQL function inline_code_block line 73 at assignment
-- КОНТЕКСТ:  PL/pgSQL function inline_code_block line 81 at RAISE
-- ********** Ошибка **********
-- 
-- ERROR: Ограничение уникальности: nso_key (key_code). Нарушается уникальность в: "key_code" - "АКТУАЛЬНЫЙ КОД КЛЮЧА"
-- 	Детали: Key (key_code)=(K_N_CODE_2010.83455700427_DEFKEY) already exists.
-- 	Контекст: SQL statement "INSERT INTO nso.nso_key (
--             nso_id          
--            ,key_type_id     
--            ,key_small_code  -- Краткий код типа ключа
--            ,key_code         
--            ,on_off          
--            ,date_from      
--            ,date_to
--            ,log_id -- 2016-11-09 Gregory   
--        	)        
--        VALUES (  
--        	   _nso_id
--        	 , _key_type_id
--        	 , _key_small_code -- Nick
--        	 , (c_MESS01 || _nso_code || c_MESS11 || _key_type_code)
--          , p_on_off    
--          , p_date_from 
--          , p_date_to
--          ,_log_id -- 2016-11-09 Gregory   
--         )"
-- PL/pgSQL function nso_structure.nso_p_key_i(t_str60,t_str60,t_arr_code,t_boolean,t_timestamp,t_timestamp) line 83 at SQL statement
-- PL/pgSQL function inline_code_block line 73 at assignment
-- SQL-состояние: P0001
-- Контекст: PL/pgSQL function inline_code_block line 81 at RAISE

