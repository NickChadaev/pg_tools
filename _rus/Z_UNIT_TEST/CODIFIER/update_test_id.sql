-- ---------------------------------------------------------------------------------------- --
--  2019-07-15 Nick Прототип UNIT теста для функции com_codifier.obj_p_codifier_u (<id>)  --
-- ---------------------------------------------------------------------------------------- --
DO
  $$   
     DECLARE
      C_PARENT_CODIF_CODE  public.t_str60 := 'C_CODIF_ROOT';
      
      _arr_ids   public.t_arr_id := (SELECT array_agg (codif_id::int8) 
                                            FROM com_codifier.com_f_obj_codifier_s_sys () 
                                                  WHERE (codif_id >= 424)
      );
      _act_codif_id  public.id_t;

      _rec_res   RECORD;
      rsp_main   public.result_long_t;
      
      C_FUNC_SIGN TEXT := 'com_codifier.obj_p_codifier_u ( public.id_t, public.id_t, public.t_str60, public.t_str250, public.t_code1, public.t_guid)';
      
     BEGIN
       _act_codif_id := utl.f_array_random_get_element (_arr_ids); 
       RAISE NOTICE 'Этап 1: Выбор: % -- % -- %', _arr_ids, _act_codif_id, C_PARENT_CODIF_CODE;
       --
       SELECT * FROM com_codifier.com_f_obj_codifier_s_sys (_act_codif_id, p_level_d :=1) INTO _rec_res;
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
        p_id          := _act_codif_id      -- Код                                                          
       ,p_name        := ('ZZXX_NAME_' || (random()*10000)::text)::public.t_str250      -- Наименование   
       ,p_code        := ('ZZXX_CODE_' || (random()*10000)::text)::public.t_str60
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

-- NOTICE:  Этап 1: Выбор: {426,424,427,425,428} -- 426 -- C_CODIF_ROOT
-- NOTICE:  Этап 2: Исходные значения: (426,2,0,XX_CODE_2365.47181382775,ZZXX_NAME_3177.88823042065,"2019-07-15 09:50:58",e7d41a1b-2a7b-4f5e-8e6f-1055ab65b48b,{426},1,ZZXX_NAME_3177.88823042065,0,f)
-- NOTICE:  Этап 3: Проверка кода функции: ()
-- NOTICE:  Этап 4: Проверка зависимостей в коде функции: (FUNCTION,18158,com_error,f_error_handling,"(exception_type_t,t_arr_text)")
-- NOTICE:  Этап 4: Проверка зависимостей в коде функции: (FUNCTION,18201,utl,com_f_empty_string_to_null,"(t_text)")
-- NOTICE:  Этап 4: Проверка зависимостей в коде функции: (RELATION,22556,com,obj_codifier,)
-- NOTICE:  Этап 5: Выполнение: (426,"Запись в кодификаторе успешно обновлена. Код мог быть изменён")
-- NOTICE:  Этап 6: Результат: (426,2,0,ZZXX_CODE_5275.76894499362,ZZXX_NAME_8185.94946525991,"2019-07-15 10:01:45",1ae423a7-7be1-4917-a1ef-d9e9ba4e6256,{426},1,ZZXX_NAME_8185.94946525991,0,f)
-- Query returned successfully with no result in 124 msec.