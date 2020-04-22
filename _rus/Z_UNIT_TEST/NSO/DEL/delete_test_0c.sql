-- ---------------------------------------------------------------------------------- --
--  2019-07-10 Nick Прототип UNIT теста для функции nso_structure.nso_p_object_u ()   --
--       Первый вариант, обновляем только "nso_object", код объекта не меняется.      --
--       Почему ?? Структуры объекта ещё нет.                                         --
-- ---------------------------------------------------------------------------------- --
DO
  $$
     DECLARE
      _arr_code   public.t_arr_code := (SELECT array_agg (nso_code::text) 
                                                  FROM nso_structure.nso_f_object_s_sys() 
                                                           WHERE (date_from = '2011-01-01'::public.t_timestamp));
      _nso_code  public.t_str60;
      --
      C_FUNC_SIGN text := 'nso_structure.nso_p_object_d (public.t_str60, public.t_boolean)';
      
      rsp_main   public.result_long_t;  
      _rec_res   RECORD;
      
     BEGIN
       PERFORM utl.f_debug_on ();
        --
       _nso_code         := utl.f_array_random_get_element (_arr_code);
       --
       RAISE NOTICE 'Этап 1: Выбор НСО: % -- %', _arr_code, _nso_code;
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
       rsp_main := nso_structure.nso_p_object_d ( _nso_code ); -- Без возможности удаления узлов.
       -- ---------------------------------------
       RAISE NOTICE 'Этап 5: Выполнение: %', rsp_main;
       IF ( rsp_main.rc < 0 ) THEN
          RAISE EXCEPTION '%', rsp_main.errm;
       END IF;
       --
       SELECT * FROM nso_structure.nso_f_object_s_sys (_nso_code) INTO _rec_res;
       RAISE NOTICE 'Этап 6: Результат: %', _rec_res;
      --
     END;
  $$
     language plpgsql;
-- ------------------------------------------------------------------------------------
-- NOTICE:  Этап 1: Выбор НСО: {N_CODE_2010.83455700427,N_CODE_7207.34263304621,N_CODE_259.176990948617,N_CODE_2244.96691022068,N_CODE_3839.96238466352,N_CODE_9197.47962616384,N_CODE_9407.1429502219,N_CODE_365.252592600882} -- N_CODE_9407.1429502219
-- NOTICE:  Этап 2: Исходные значения: (36,N_CODE_9407.1429502219,6,NSO_UDF,ИМЯ_3568.71751137078,"2011-01-01 00:00:00",156,C_NSO_CLASS,Классификатор,0,9d266258-0c93-4a13-8e5a-b45cabcc740a,t,f,f,f,f,0,"2011-01-01 00:00:00","9999-12-31 00:00:00",{36},1,ИМЯ_3568.71751137078)
-- NOTICE:  Этап 3: Проверка кода функции: ("warning extra:00000:20:DECLARE:never read variable ""c_debug""")
-- NOTICE:  Этап 4: Проверка зависимостей в коде функции: (FUNCTION,19153,com_domain,nso_p_domain_column_d,"(t_str60)")
-- NOTICE:  Этап 4: Проверка зависимостей в коде функции: (FUNCTION,18351,com_error,f_error_handling,"(exception_type_t,t_arr_text)")
-- NOTICE:  Этап 4: Проверка зависимостей в коде функции: (FUNCTION,18394,nso,nso_p_nso_log_i,"(t_code1,t_text)")
-- NOTICE:  Этап 4: Проверка зависимостей в коде функции: (FUNCTION,19135,nso_structure,nso_p_object_d,"(id_t,t_boolean)")
-- NOTICE:  Этап 4: Проверка зависимостей в коде функции: (FUNCTION,18423,utl,com_f_empty_string_to_null,"(t_text)")
-- NOTICE:  Этап 4: Проверка зависимостей в коде функции: (FUNCTION,18430,utl,f_debug_status,"()")
-- NOTICE:  Этап 4: Проверка зависимостей в коде функции: (RELATION,18595,nso,nso_abs,)
-- NOTICE:  Этап 4: Проверка зависимостей в коде функции: (RELATION,18612,nso,nso_blob,)
-- NOTICE:  Этап 4: Проверка зависимостей в коде функции: (RELATION,18631,nso,nso_column_head,)
-- NOTICE:  Этап 4: Проверка зависимостей в коде функции: (RELATION,18658,nso,nso_key,)
-- NOTICE:  Этап 4: Проверка зависимостей в коде функции: (RELATION,18669,nso,nso_key_attr,)
-- NOTICE:  Этап 4: Проверка зависимостей в коде функции: (RELATION,18705,nso,nso_object,)
-- NOTICE:  Этап 4: Проверка зависимостей в коде функции: (RELATION,18744,nso,nso_record,)
-- NOTICE:  Этап 4: Проверка зависимостей в коде функции: (RELATION,18769,nso,nso_record_unique,)
-- NOTICE:  Этап 4: Проверка зависимостей в коде функции: (RELATION,18776,nso,nso_ref,)
-- NOTICE:  <nso_p_nso_log_i> 3, Физическое удаление НСО: N_CODE_9407.1429502219
-- NOTICE:  <nso_p_nso_log_i> 5, Удаление данных объекта: N_CODE_9407.1429502219
-- NOTICE:  Этап 5: Выполнение: (36,"Успешно удален нормативно-справочный объект с кодом ""N_CODE_9407.1429502219"".")
-- NOTICE:  Этап 6: Результат: (,,,,,,,,,,,,,,,,,,,,,)
-- 
-- Query returned successfully with no result in 237 msec.

-- select * from com.all_log where (schema_name = 'NSO');
-- select * from com.all_log where (schema_name = 'COM');
-- select * from nso.nso_f_nso_log_s ();
-- select * from com.com_f_com_log_s ();
-- select * from nso_structure.nso_f_object_s_sys ('CL_LOCAL');
--------------------------------------------------------------------------
-- 12|'CL_LOCAL'               | 4|'NSO_CLASS'|'Локальные классификаторы'
-- 27|'THC_RANGE'              |12|'CL_LOCAL' |'Перечень рангов (вспомогательный классификатор)'
-- 32|'N_CODE_9039.88895006478'|12|'CL_LOCAL' |'N_CODE_9039.88895006478'
-- 41|'N_CODE_3839.96238466352'|12|'CL_LOCAL' |'ИМЯ_4438.89244459569'
-- -----------------------------------------------------------------------
-- SELECT * FROM nso_structure.nso_p_object_d ('CL_LOCAL', true);
-- 12|'Успешно удален нормативно-справочный объект с кодом "CL_LOCAL".'
--
-- select * from nso.nso_f_nso_log_s ();
-- select * from com.com_f_com_log_s ();
--
-- select * from nso_structure.nso_f_object_s_sys ('CL_LOCAL');