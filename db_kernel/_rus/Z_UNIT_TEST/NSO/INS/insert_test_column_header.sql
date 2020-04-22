-- -------------------------------------------------------------------------------------------------- --
--  2019-08-09 Nick Прототип UNIT теста для функции nso_structure.nso_p_column_head_i ()              --
--   Один запуск - одно сформированное оглавление.  Размер оглавления является величиной  случайной.  --
-- -------------------------------------------------------------------------------------------------- --
--  2020-04-07 Nick Переход на pgtap.                                                                 --
-- -------------------------------------------------------------------------------------------------- --
DO
  $$
     DECLARE
      _arr_nso_code  public.t_arr_code := (SELECT array_agg (nso_code::text) FROM nso_structure.nso_f_object_s_sys() WHERE (date_create = '2011-01-01'::public.t_timestamp));
      _arr_atr_code  public.t_arr_code := (SELECT array_agg (attr_code::text) FROM com_domain.nso_f_domain_column_s('APP_NODE'));
      _arr_head_len  public.t_arr_nmb := ARRAY [2, 12, 23, 7, 10]::smallint[];
      --
      _nso_code  public.t_str60;
      _attr_code public.t_str60;
      _head_len  public.small_t;
      _ind       public.small_t := 1;
      
      C_FUNC_SIGN text := 'nso_structure.nso_p_column_head_i (public.t_str60, public.t_str60, public.small_t, public.t_boolean, public.t_str60, public.t_str250, public.t_boolean)';
      
      rsp_main   public.result_long_t;  
      _rec_res   RECORD;
      
     BEGIN
        PERFORM utl.f_debug_on ();
        --
       _nso_code  := utl.f_array_random_get_element (_arr_nso_code);
       _head_len  := utl.f_array_random_get_element (_arr_head_len);
       
       RAISE NOTICE 'Этап 1: Выбор НСО, размера оглавления: nso_code = "%", head_len = "%"', _nso_code, _head_len;
       --
       FOR _rec_res IN SELECT * FROM nso_structure.nso_f_column_head_nso_s (_nso_code)
       LOOP
           RAISE NOTICE 'Этап 2: Исходные значения: %', _rec_res;  
       END LOOP;
       --
       SELECT * FROM plpgsql_check_function (C_FUNC_SIGN) INTO _rec_res;
       RAISE NOTICE 'Этап 3: Проверка кода функции: %', _rec_res;

       FOR _rec_res IN SELECT * FROM plpgsql_show_dependency_tb (C_FUNC_SIGN) 
       LOOP 
            RAISE NOTICE 'Этап 4: Проверка зависимостей в коде функции: %', _rec_res;
       END LOOP;
       --
       -- Выбор типа делается случайным образом.
       --
       WHILE (_ind <= _head_len)
         LOOP
           _attr_code := utl.f_array_random_get_element (_arr_atr_code);
           rsp_main := nso_structure.nso_p_column_head_i (	 
                    p_nso_code   :=  _nso_code       -- Код объекта владельца
                   ,p_attr_code  :=  _attr_code      -- Код атрибута
                   ,p_number_col :=  _ind            -- Номер колонки, если NULL - то номер вычисляется по максимальному
                   ,p_mandatory  :=  TRUE            -- Обязательность заполнения
                   ,p_act_code   :=  'A_CODE_' || (random()*10000)::public.t_str60 -- Актуальный код, если NULL то берём код родителя +  код НСО + номер строки
                   ,p_act_name   :=  'ИМЯ_' || (random()*10000)::public.t_str250   -- Актуальное имя, если NULL - берём имя домена 
                   ,p_final_sw   :=  (_ind = _head_len)::public.t_boolean           -- если TRUE то записываем сообщение в LOG 
 		    );         
           _ind := _ind + 1;
           --
           RAISE NOTICE 'Этап 5: Выполнение: %', rsp_main;
           IF ( rsp_main.rc < 0 ) THEN
                        RAISE EXCEPTION '%', rsp_main.errm;
           END IF;
         END LOOP;
      -- ----------------------------------------------------------------------------
      FOR _rec_res IN SELECT * FROM nso_structure.nso_f_column_head_nso_s (_nso_code)
       LOOP
           RAISE NOTICE 'Этап 6: Результат: %', _rec_res;
       END LOOP;

      RAISE NOTICE '--';
      RAISE NOTICE '*********';
      RAISE NOTICE '--';
             
     END;
  $$
     LANGUAGE plpgsql;
-- ------------------------------------------------------------------------------------
