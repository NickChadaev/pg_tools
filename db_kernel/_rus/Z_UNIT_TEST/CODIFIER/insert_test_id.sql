-- ------------------------------------------------------------------------------------- --
--  2019-07-15 Nick Прототип UNIT теста для функции com_codifier.obj_p_codifier_i (<id>) --
-- ------------------------------------------------------------------------------------- --
DO
  $$   
     DECLARE
      C_PARENT_CODIF_CODE  public.t_str60 := 'C_CODIF_ROOT';
      
      _arr_ids   public.t_arr_id := (SELECT array_agg (codif_id::int8) FROM com_codifier.com_f_obj_codifier_s_sys (C_PARENT_CODIF_CODE, p_level_d :=2));
      _parent_codif_id  public.id_t;

      _rec_res   RECORD;
      rsp_main   public.result_long_t;
      
      C_FUNC_SIGN TEXT := 'com_codifier.obj_p_codifier_i (public.id_t, public.t_str60, public.t_str250, public.t_guid, public.t_code1, public.t_timestamp, public.t_timestamp)';
      
     BEGIN
       _parent_codif_id := utl.f_array_random_get_element (_arr_ids); 
       RAISE NOTICE 'Этап 1: Выбор: % -- % -- %', _arr_ids, _parent_codif_id, C_PARENT_CODIF_CODE;
       --
       SELECT * FROM com_codifier.com_f_obj_codifier_s_sys (_parent_codif_id, p_level_d :=1) INTO _rec_res;
       RAISE NOTICE 'Этап 2: Исходные значения: %', _rec_res;
       --
       SELECT * FROM plpgsql_check_function (c_func_sign) INTO _rec_res;
       RAISE NOTICE 'Этап 3: Проверка кода функции: %', _rec_res;

       FOR _rec_res IN SELECT * FROM plpgsql_show_dependency_tb (c_func_sign) 
       LOOP 
           RAISE NOTICE 'Этап 4: Проверка зависимостей в коде функции: %', _rec_res;
       END LOOP;
       --
       rsp_main := com_codifier.obj_p_codifier_i (
        p_parent      := _parent_codif_id    -- ID родительского идентификатора      
       ,p_code        := ('XX_CODE_' || (random()*10000)::text)::public.t_str60       -- Код                                                          
       ,p_name        := ('XX_NAME_' || (random()*10000)::text)::public.t_str250      -- Наименование                                        
       ,p_codif_uuid  :=   newid()             -- UUID       
       ,p_date_from   := '2015-01-01'::public.t_timestamp     -- Начало периода актуальности
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
-- NOTICE:  Этап 1: Выбор Кода типа атрибута: {1,2,9,10,11,12,13,14,15,16,17,419} -- 10 -- C_CODIF_ROOT
-- NOTICE:  Этап 2: Исходные значения: (10,1,0,C_DOC_TYPE,"Перечень видов/типов документов","2017-10-09 13:54:12",11963295-fef4-445b-957c-ed941062020d,{10},1,"Перечень видов/типов документов",10,t)
-- NOTICE:  Этап 3: Проверка кода функции: ()
-- NOTICE:  Этап 4: Проверка зависимостей в коде функции: (FUNCTION,18158,com_error,f_error_handling,"(exception_type_t,t_arr_text)")
-- NOTICE:  Этап 4: Проверка зависимостей в коде функции: (FUNCTION,18201,utl,com_f_empty_string_to_null,"(t_text)")
-- NOTICE:  Этап 4: Проверка зависимостей в коде функции: (RELATION,22556,com,obj_codifier,)
-- NOTICE:  Этап 5: Выполнение: (424,"Создание экземпляра кодификатора выполнено успешно")
-- NOTICE:  Этап 6: Результат: (424,10,0,XX_CODE_3336.93555090576,XX_NAME_5701.04028563946,"2015-01-01 00:00:00",4eb55170-a4fd-4d28-853f-917cb48154c8,{424},1,XX_NAME_5701.04028563946,0,f)

-- Query returned successfully with no result in 104 msec

-- SELECT * FROM com.com_f_com_log_s (); -- НЕТ В LOG
-- SELECT * FROM com_codifier.com_f_obj_codifier_s_sys (425)
-- select * from com.obj_codifier WHERE ( codif_id IN (424, 425) );
