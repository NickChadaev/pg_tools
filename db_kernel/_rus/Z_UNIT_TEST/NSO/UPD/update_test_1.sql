-- ---------------------------------------------------------------------------------- --
--  2019-07-10 Nick Прототип UNIT теста для функции nso_structure.nso_p_object_u ()   --
--       Первый вариант, обновляем только "nso_object", код объекта не меняется.      --
--       Почему ?? Структуры объекта ещё нет.                                         --
-- ---------------------------------------------------------------------------------- --
DO
  $$
     DECLARE
      _arr_parent_code public.t_arr_code := (
         SELECT array_agg (nso_code::text) 
                                   FROM nso_structure.nso_f_object_s_sys() 
                                                        WHERE (nso_type_code = 'C_NSO_NODE')
      );
      _parent_attr_code  public.t_str60;
      -- 
      _arr_code  public.t_arr_code := (
                    SELECT array_agg (nso_code::text) 
                                   FROM ONLY nso.nso_object 
                                                WHERE (date_create = '2011-01-01'::public.t_timestamp)
      );
      --
      _nso_code      public.t_str60;
      _nso_code_new  public.t_str60;
      --
      _arr_type_code  public.t_arr_code := ARRAY ['C_NSO_CLASS', 'C_NSO_TTH', 'C_NSO_SPR', 'C_NSO_SPR_DAY_MESS', 'C_NSO_RBR'];
      _nso_type_code  public.t_str60;
      
      _arr_intra_op   public.t_arr_boolean := ARRAY [true, false];
      _intra_op       public.t_boolean;
      --
      C_FUNC_SIGN text := 'nso_structure.nso_p_object_u (public.t_str60, public.t_str60, public.t_str60, public.t_guid, public.t_boolean, public.t_str60, public.t_str250)';
      
      rsp_main   public.result_long_t;  
      _rec_res   RECORD;
      
     BEGIN
       PERFORM utl.f_debug_on ();
        --
       _nso_code         := utl.f_array_random_get_element (_arr_code);
       _nso_code_new     := _nso_code || '_Хрень_++' || (random()*10000)::public.t_str60; 
       _nso_type_code    := utl.f_array_random_get_element (_arr_type_code);
       _intra_op         := utl.f_array_random_get_element (_arr_intra_op);
       _parent_attr_code := utl.f_array_random_get_element (_arr_parent_code);
       --
       RAISE NOTICE 'Этап 1: Выбор НСО: % -- % -- % -- % -- % -- %',
                                           _arr_code, _nso_code, _nso_code_new, _nso_type_code, _parent_attr_code, _intra_op;
       --
       SELECT * FROM nso_structure.nso_f_object_s_sys (_nso_code, p_limit := 1) INTO _rec_res;
       RAISE NOTICE 'Этап 2: Исходные значения: %', _rec_res;
       --
       SELECT * FROM plpgsql_check_function (C_FUNC_SIGN) INTO _rec_res;
       RAISE NOTICE 'Этап 3: Проверка кода функции: %', _rec_res;
       --
       FOR _rec_res IN SELECT * FROM plpgsql_show_dependency_tb (C_FUNC_SIGN) 
       LOOP 
            RAISE NOTICE 'Этап 4: Проверка зависимостей в коде функции: %', _rec_res;
       END LOOP;
       --
       -- Выбор типа делается случайным образом.
       --
       rsp_main := nso_structure.nso_p_object_u (
          p_nso_code        := _nso_code          -- ID НСО, поисковый аргумент,  всегда NOT NULL
         ,p_parent_nso_code := _parent_attr_code  -- Код родительского НСО, если NULL - сохраняется старое значение.
         ,p_nso_type_code   := _nso_type_code     -- Код типа НСО если NULL - сохраняется старое значение.
         ,p_nso_uuid        := newid ()           -- UUID НСО если NULL - сохраняется старое значение.
         ,p_is_intra_op     := _intra_op          -- Признак интраоперабельности
         ,p_new_nso_code    := _nso_code_new -- Код НСО, новое значение
         ,p_nso_name        := 'ИМЯ_++_' || (random() * 10000)::public.t_str250 -- Наименование НСО
       );
       --
       RAISE NOTICE 'Этап 5: Выполнение: %', rsp_main;
       IF ( rsp_main.rc < 0 ) THEN
          RAISE EXCEPTION '%', rsp_main.errm;
       END IF;
       --
       SELECT * FROM nso_structure.nso_f_object_s_sys (_nso_code_new) INTO _rec_res;
       RAISE NOTICE 'Этап 6: Результат: %', _rec_res;
      --
     END;
  $$
     language plpgsql;
-- ------------------------------------------------------------------------------------
-- select * from com.all_log where (schema_name = 'NSO');
-- select * from nso.nso_f_nso_log_s ();
