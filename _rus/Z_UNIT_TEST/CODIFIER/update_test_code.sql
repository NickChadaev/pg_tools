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
      
      C_FUNC_SIGN TEXT := 'com_codifier.obj_p_codifier_u (public.t_str60, public.t_str60, public.t_str250, public.t_code1, public.t_guid)';
      
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
       rsp_main := com_codifier.obj_p_codifier_u (
        p_code        := _act_codif_code      -- Код                                                          
       ,p_name        := ('ZZXX_NAME_' || (random()*10000)::text)::public.t_str250      -- Наименование                                        
       ,p_codif_uuid  :=   newid()             -- UUID       
      );
      --
      RAISE NOTICE 'Этап 5: Выполнение: %', rsp_main;
      IF ( rsp_main.rc < 0 ) THEN
          RAISE EXCEPTION '%', rsp_main.errm;
      END IF;
      --
      SELECT * FROM com_codifier.com_f_obj_codifier_s_sys (rsp_main.rc, p_level_d :=1) INTO _rec_res;
      RAISE NOTICE 'Этап 6: Результат: %', _rec_res;
      --
     END;
  $$
     language plpgsql;
-- ------------------------------------------------------------------------------------

-- SELECT * FROM com.com_f_com_log_s (); -- НЕТ В LOG
-- SELECT * FROM com_codifier.com_f_obj_codifier_s_sys () WHERE (date_from = '2015-01-01 00:00:00');

-- select * from com.obj_codifier WHERE ( codif_id >= 424);
-- NOTICE:  Этап 1: Выбор: {XX_CODE_3336.93555090576,XX_CODE_2928.23602911085,XX_CODE_1669.61374226958,XX_CODE_6097.08005096763} -- XX_CODE_6097.08005096763 -- C_CODIF_ROOT
-- NOTICE:  Этап 2: Исходные значения: (428,419,0,XX_CODE_6097.08005096763,XX_NAME_7523.65608233958,"2015-01-01 00:00:00",900ff75c-dcaf-47cc-a454-472839a474d0,{428},1,XX_NAME_7523.65608233958,0,f)
-- NOTICE:  Этап 3: Проверка кода функции: ()
-- NOTICE:  Этап 4: Проверка зависимостей в коде функции: (FUNCTION,18126,com_codifier,com_f_obj_codifier_get_id,"(t_str60)")
-- NOTICE:  Этап 4: Проверка зависимостей в коде функции: (FUNCTION,18158,com_error,f_error_handling,"(exception_type_t,t_arr_text)")
-- NOTICE:  Этап 4: Проверка зависимостей в коде функции: (FUNCTION,18201,utl,com_f_empty_string_to_null,"(t_text)")
-- NOTICE:  Этап 4: Проверка зависимостей в коде функции: (RELATION,22556,com,obj_codifier,)
-- NOTICE:  Этап 5: Выполнение: (428,"Запись успешно обновлена.")
-- NOTICE:  Этап 6: Результат: (428,419,0,XX_CODE_6097.08005096763,ZZXX_NAME_9969.52513698488,"2019-07-15 09:52:41",c66142e9-029e-4a6e-b81d-a046c9c76ba6,{428},1,ZZXX_NAME_9969.52513698488,0,f)
-- Query returned successfully with no result in 134 msec.
