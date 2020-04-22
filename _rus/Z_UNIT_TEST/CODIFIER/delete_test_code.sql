-- ---------------------------------------------------------------------------------------- --
--  2019-07-15 Nick Прототип UNIT теста для функции com_codifier.obj_p_codifier_u (<code>)  --
-- ---------------------------------------------------------------------------------------- --
DO
  $$   
     DECLARE
      C_PARENT_CODIF_CODE  public.t_str60 := 'C_CODIF_ROOT';
      
      _arr_codes   public.t_arr_code := (SELECT array_agg (codif_code::text) 
                                            FROM com_codifier.com_f_obj_codifier_s_sys () 
                                                  WHERE (date_from = '2015-01-01 00:00:00')
      );
      _act_codif_code  public.t_str60;

      _rec_res   RECORD;
      rsp_main   public.result_long_t;
      
      C_FUNC_SIGN TEXT := 'com_codifier.obj_p_codifier_d (public.t_str60)';
      
     BEGIN
       _act_codif_code := utl.f_array_random_get_element (_arr_codes); 
       RAISE NOTICE 'Этап 1: Выбор: % -- % -- %', _arr_codes, _act_codif_code, C_PARENT_CODIF_CODE;
       --
       SELECT * FROM com_codifier.com_f_obj_codifier_s_sys (_act_codif_code, p_level_d :=1) INTO _rec_res;
       RAISE NOTICE 'Этап 2: Исходные значения: %', _rec_res;
       --
       SELECT * FROM plpgsql_check_function (c_func_sign) INTO _rec_res;
       RAISE NOTICE 'Этап 3: Проверка кода функции: %', _rec_res;

       FOR _rec_res IN SELECT * FROM plpgsql_show_dependency_tb (c_func_sign) 
       LOOP 
           RAISE NOTICE 'Этап 4: Проверка зависимостей в коде функции: %', _rec_res;
       END LOOP;
       --
       rsp_main := com_codifier.obj_p_codifier_d (_act_codif_code);
      --
      RAISE NOTICE 'Этап 5: Выполнение: %', rsp_main;
      IF ( rsp_main.rc < 0 ) THEN
          RAISE EXCEPTION '%', rsp_main.errm;
      END IF;
      --
     END;
  $$
     language plpgsql;
-- ------------------------------------------------------------------------------------

-- SELECT * FROM com.com_f_com_log_s (); -- НЕТ В LOG
-- SELECT * FROM com_codifier.com_f_obj_codifier_s_sys () WHERE (date_from = '2015-01-01 00:00:00');

-- NOTICE:  Этап 1: Выбор: {XX_CODE_2928.23602911085,XX_CODE_1669.61374226958} -- XX_CODE_1669.61374226958 -- C_CODIF_ROOT
-- NOTICE:  Этап 2: Исходные значения: (425,16,0,XX_CODE_1669.61374226958,XX_NAME_4071.67444005609,"2015-01-01 00:00:00",781f52c7-2e95-432c-a1bf-1dbc1ba9aa74,{425},1,XX_NAME_4071.67444005609,0,f)
-- NOTICE:  Этап 3: Проверка кода функции: ()
-- NOTICE:  Этап 4: Проверка зависимостей в коде функции: (FUNCTION,18126,com_codifier,com_f_obj_codifier_get_id,"(t_str60)")
-- NOTICE:  Этап 4: Проверка зависимостей в коде функции: (FUNCTION,18158,com_error,f_error_handling,"(exception_type_t,t_arr_text)")
-- NOTICE:  Этап 4: Проверка зависимостей в коде функции: (FUNCTION,18201,utl,com_f_empty_string_to_null,"(t_text)")
-- NOTICE:  Этап 4: Проверка зависимостей в коде функции: (RELATION,22556,com,obj_codifier,)
-- NOTICE:  Этап 5: Выполнение: (425,"Запись успешно удалена")
-- Query returned successfully with no result in 124 msec.