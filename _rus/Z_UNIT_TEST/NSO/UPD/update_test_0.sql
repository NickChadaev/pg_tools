-- ---------------------------------------------------------------------------------- --
--  2019-07-10 Nick Прототип UNIT теста для функции nso_structure.nso_p_object_u ()   --
--       Первый вариант, обновляем только "nso_object", код объекта не меняется.      --
--       Почему ?? Структуры объекта ещё нет.                                         --
-- ---------------------------------------------------------------------------------- --
-- 2020-04-15 PgTAP                                                                   --
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

      _arr_code  public.t_arr_code := (
                    SELECT array_agg (nso_code::text) 
                                   FROM ONLY nso.nso_object 
                                                WHERE (date_create = '2011-01-01'::public.t_timestamp)
      );
      _nso_code  public.t_str60;
      --
      _arr_type_code  public.t_arr_code := ARRAY ['C_NSO_CLASS', 'C_NSO_TTH', 'C_NSO_SPR', 'C_NSO_SPR_DAY_MESS', 'C_NSO_RBR'];
      _nso_type_code  public.t_str60;
      
      _arr_intra_op   public.t_arr_boolean := ARRAY [true, false];
      _intra_op       public.t_boolean;
      --
      C_FUNC_SIGN text := 'nso_structure.nso_p_object_u (public.id_t,public.t_str60,public.t_str60,public.t_guid,public.t_boolean,public.t_str60,public.t_str250)';
      
      rsp_main   public.result_long_t;  
      _rec_res   RECORD;
      
     BEGIN
       PERFORM utl.f_debug_on ();
        --
       _nso_code         := utl.f_array_random_get_element (_arr_code);
       _nso_type_code    := utl.f_array_random_get_element (_arr_type_code);
       _intra_op         := utl.f_array_random_get_element (_arr_intra_op);
       _parent_attr_code := utl.f_array_random_get_element (_arr_parent_code);
       --
       RAISE NOTICE 'Этап 1: Выбор НСО: nso_code = "%", nso_type_code = "%", parent_attr_code = "%", intra_op = "%"',
                                 _nso_code, _nso_type_code, _parent_attr_code, _intra_op;
       --
       FOR _rec_res IN SELECT * FROM nso_structure.nso_f_object_s_sys (_nso_code) 
       LOOP 
            RAISE NOTICE 'Этап 2: Исходные значения: %', _rec_res;
       END LOOP;
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
        p_nso_id          := nso_structure.nso_f_object_get_id (_nso_code) -- ID НСО, поисковый аргумент,  всегда NOT NULL
       ,p_parent_nso_code := _parent_attr_code  -- Код родительского НСО, если NULL - сохраняется старое значение.
       ,p_nso_type_code   := _nso_type_code     -- Код типа НСО если NULL - сохраняется старое значение.
       ,p_nso_uuid        := newid ()           -- UUID НСО если NULL - сохраняется старое значение.
       ,p_is_intra_op     := _intra_op          -- Признак интраоперабельности
       ,p_nso_name        := 'ИМЯ_++_' || (random()*10000)::public.t_str250 -- Наименование НСО
     );
-- ---------------------------------------
      RAISE NOTICE 'Этап 5: Выполнение: %', rsp_main;
      IF ( rsp_main.rc < 0 ) THEN
          RAISE EXCEPTION '%', rsp_main.errm;
      END IF;
      --
      FOR _rec_res IN SELECT * FROM nso_structure.nso_f_object_s_sys (_nso_code) 
       LOOP 
            RAISE NOTICE 'Этап 6: Результат: %', _rec_res;
      END LOOP;
     END;
  $$
     language plpgsql;
-- ------------------------------------------------------------------------------------
-- NOTICE:  Этап 1: Выбор НСО: {N_CODE_8749.95611142367,N_CODE_2708.56954157352,N_CODE_365.252592600882,N_CODE_259.176990948617,N_CODE_1707.80570246279,N_CODE_2010.83455700427,N_CODE_9197.47962616384,N_CODE_2244.96691022068_ХРЕНЬ_++} -- N_CODE_2708.56954157352 -- C_NSO_CLASS -- CL_RF -- f
-- NOTICE:  Этап 2: Исходные значения: (34,N_CODE_2708.56954157352,10,CL_RF,ИМЯ_1868.81485860795,"2011-01-01 00:00:00",342,C_NSO_SPR_DAY_MESS,Предупреждение,1,ae145a42-c977-4350-a308-a8f10d32ded7,t,f,t,f,f,0,"2019-07-23 14:14:10","9999-12-31 00:00:00",{34},1,ИМЯ_1868.81485860795)
-- NOTICE:  Этап 3: Проверка кода функции: ()
-- NOTICE:  Этап 4: Проверка зависимостей в коде функции: (FUNCTION,18319,com_codifier,com_f_obj_codifier_get_id,"(t_str60)")
-- NOTICE:  Этап 4: Проверка зависимостей в коде функции: (FUNCTION,18351,com_error,f_error_handling,"(exception_type_t,t_arr_text)")
-- NOTICE:  Этап 4: Проверка зависимостей в коде функции: (FUNCTION,18384,db_info,f_show_tbv_descr,"(character varying,character[])")
-- NOTICE:  Этап 4: Проверка зависимостей в коде функции: (FUNCTION,19172,nso_structure,nso_f_object_get_code,"(id_t)")
-- NOTICE:  Этап 4: Проверка зависимостей в коде функции: (FUNCTION,18410,nso_structure,nso_f_select_c,"(t_str60)")
-- NOTICE:  Этап 4: Проверка зависимостей в коде функции: (FUNCTION,18416,nso_structure,nso_p_view_c,"(t_str60,t_boolean,t_sysname)")
-- NOTICE:  Этап 4: Проверка зависимостей в коде функции: (FUNCTION,18423,utl,com_f_empty_string_to_null,"(t_text)")
-- NOTICE:  Этап 4: Проверка зависимостей в коде функции: (RELATION,18492,com,nso_domain_column,)
-- NOTICE:  Этап 4: Проверка зависимостей в коде функции: (RELATION,18631,nso,nso_column_head,)
-- NOTICE:  Этап 4: Проверка зависимостей в коде функции: (RELATION,18658,nso,nso_key,)
-- NOTICE:  Этап 4: Проверка зависимостей в коде функции: (RELATION,18705,nso,nso_object,)
-- NOTICE:  <nso_p_nso_log_i> 4, Обновление данных объекта: N_CODE_2708.56954157352
-- NOTICE:  Этап 5: Выполнение: (34,"Успешно обновлен нормативно-справочный объект с кодом ""N_CODE_2708.56954157352"".")
-- NOTICE:  Этап 6: Результат: (34,N_CODE_2708.56954157352,10,CL_RF,ИМЯ_++_7667.48402733356,"2011-01-01 00:00:00",156,C_NSO_CLASS,Классификатор,2,fc044830-bcab-49d7-9a53-e5eef8553d64,t,f,f,f,f,0,"2019-08-23 08:29:25","9999-12-31 00:00:00",{34},1,ИМЯ_++_7667.48402733356)
-- Query returned successfully with no result in 212 msec.
--
-- select * from com.all_log where (schema_name = 'NSO');
-- select * from nso.nso_f_nso_log_s ();
