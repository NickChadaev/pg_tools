-- -------------------------------------------------------------------------------------------------- --
--  2019-12-31 Nick Прототип UNIT теста для функции "nso_structure.nso_p_key_i"                       --
--   Один запуск - Несколько сформированных маркеров/ключей.  DEFKEY + ...                            --
--                                           Размер маркера/ключа является величиной  случайной.      --
-- -------------------------------------------------------------------------------------------------- --
--  2020-04-07 Nick Переход на pgtap.                                                                 --
-- -------------------------------------------------------------------------------------------------- --

DO
  $$
     DECLARE
      _arr_nso_code  public.t_arr_code := (SELECT array_agg (nso_code::text) 
                                                    FROM nso_structure.nso_f_object_s_sys() 
                                                               WHERE (date_create = '2011-01-01'::public.t_timestamp)
                                          );
      _arr_key_len   public.t_arr_nmb  := ARRAY [2, 1, 10, 3, 4]::smallint[];
      _arr_key_type_code  public.t_arr_code:= (SELECT array_agg (codif_code::text) 
                                                          FROM com_codifier.com_f_obj_codifier_s('C_KEY_TYPE') 
                                                                      WHERE (codif_code <> 'DEFKEY')
                                              );
      --
      _arr_atr_code  public.t_arr_code;
      _arr_key_code  public.t_arr_code;
      --
      _nso_code       public.t_str60;
      _attr_code      public.t_str60;
      _key_type_code  public.t_str60;
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
       SELECT * FROM plpgsql_check_function (C_FUNC_SIGN) INTO _rec_res;
       RAISE NOTICE 'Этап 1: Проверка кода функции: %', _rec_res;

       FOR _rec_res IN SELECT * FROM plpgsql_show_dependency_tb (C_FUNC_SIGN) 
       LOOP 
            RAISE NOTICE 'Этап 2: Проверка зависимостей в коде функции: %', _rec_res;
       END LOOP;      
       --
       -- Должен быть по крайней мере один объект с сформированным оглавлениенм.
       --
       LOOP
          _nso_code := utl.f_array_random_get_element (_arr_nso_code);
          _arr_nso_code := array_remove (_arr_nso_code::text[], _nso_code::text);
          EXIT WHEN (_nso_code IS NULL);
          --
          _head_len := (SELECT count(*) FROM nso_structure.nso_f_column_head_nso_s (_nso_code)
                              WHERE (key_id IS NULL)
                        );
          _key_len  := utl.f_array_random_get_element (_arr_key_len);              
          EXIT WHEN ((_head_len > 1) AND (_key_len <= _head_len));
       END LOOP;
       --
       IF (_nso_code IS NULL)
         THEN
               RAISE 'Не найден НСО со сформированным заголовком';
       END IF;
       
       RAISE NOTICE 'Этап 3: Выбор НСО: nso_code = "%", _head_len = "%", key_len = "%"'
                                                                   , _nso_code, _head_len, _key_len;
       --
       -- Выбор Атрибута делается случайным образом.
       --
       _arr_atr_code := (SELECT array_agg (attr_code::text) 
                                  FROM nso_structure.nso_f_column_head_nso_s(_nso_code) 
                            WHERE ((number_col > 0) AND (key_id IS NULL))
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
       --
       IF NOT EXISTS (SELECT 1 FROM nso_structure.nso_f_column_head_nso_s (_nso_code) 
                            WHERE (key_type_code = 'DEFKEY')
       ) THEN
               rsp_main :=  nso_structure.nso_p_key_i (				         
               		   p_nso_code	    :=  _nso_code     -- Код НСО
               		  ,p_key_type_code  := 'DEFKEY'       -- Тип кода ключа
                      ,p_attr_codes     :=  _arr_key_code -- Массив кодов атрибутов, образующих ключ         
               );         
              -- ---------------------------------------
              RAISE NOTICE 'Этап 4: Выполнение: %', rsp_main;
              IF ( rsp_main.rc < 0 ) THEN
                           RAISE EXCEPTION '%', rsp_main.errm;
              END IF;
         ELSE     
              RAISE NOTICE 'Этап 4: DEFKEY уже существует';  
       END IF;       
       --
       -- Любой отличный от DEFKEY
       --
       LOOP
         _key_type_code := utl.f_array_random_get_element (_arr_key_type_code);
         _arr_key_type_code := array_remove (_arr_key_type_code::text[], _key_type_code::text);
       
         _head_len := (SELECT count(*) FROM nso_structure.nso_f_column_head_nso_s (_nso_code)
                                                              WHERE (key_id IS NULL)
                       );
         _key_len := utl.f_array_random_get_element (_arr_key_len);              
         EXIT WHEN ((_head_len > 1) AND 
                    (_key_len <= _head_len) AND
                    (NOT EXISTS (SELECT 1 FROM nso_structure.nso_f_column_head_nso_s (_nso_code) 
                                         WHERE (key_type_code = _key_type_code)
                                )
                    )  
                   );
       END LOOP;
             
       RAISE NOTICE 'Этап 5: Второй ключ: nso_code = "%",  head_len = "%", key_len = "%"'
                                                                ,_nso_code, _head_len, _key_len;
       --
       _ind := 1;
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
       --
       rsp_main :=  nso_structure.nso_p_key_i (				         
       		   p_nso_code	    :=  _nso_code     -- Код НСО
       		  ,p_key_type_code  := _key_type_code -- Тип кода ключа
              ,p_attr_codes     := _arr_key_code  -- Массив кодов атрибутов, образующих ключ         
       );         
       -- ---------------------------------------
       RAISE NOTICE 'Этап 6: Выполнение: %', rsp_main;
       IF ( rsp_main.rc < 0 ) THEN
                       RAISE EXCEPTION '%', rsp_main.errm;
       END IF;      
       --
       FOR _rec_res IN SELECT * FROM nso_structure.nso_f_column_head_nso_s (_nso_code)
       LOOP
            RAISE NOTICE 'Этап 7: Результат: %', _rec_res;
       END LOOP;       
       --
      RAISE NOTICE '--';
      RAISE NOTICE '*********';
      RAISE NOTICE '--';
      
     END;
  $$
     LANGUAGE plpgsql;
-- ------------------------------------------------------------------------------------
--
