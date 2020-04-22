-- ---------------------------------------------------------------------------------------- --
--  2019-07-15 Nick Прототип UNIT теста для функции com_codifier.obj_p_codifier_i (<code>)  --
-- ---------------------------------------------------------------------------------------- --
DO
  $$   
     DECLARE
      C_PARENT_CODIF_CODE  public.t_str60 := 'C_CODIF_ROOT';
      
      _arr_codes   public.t_arr_code := (SELECT array_agg (codif_code::text) FROM com_codifier.com_f_obj_codifier_s_sys (C_PARENT_CODIF_CODE, p_level_d :=2));
      _parent_codif_code  public.t_str60;

      _rec_res   RECORD;
      rsp_main   public.result_long_t;
      
      C_FUNC_SIGN TEXT := 'com_codifier.obj_p_codifier_i (public.t_str60, public.t_str60, public.t_str250, public.t_guid, public.t_code1, public.t_timestamp, public.t_timestamp)';
      
     BEGIN
       _parent_codif_code := utl.f_array_random_get_element (_arr_codes); 
       RAISE NOTICE 'Этап 1: Выбор: % -- % -- %', _arr_codes, _parent_codif_code, C_PARENT_CODIF_CODE;
       --
       SELECT * FROM com_codifier.com_f_obj_codifier_s_sys (_parent_codif_code, p_level_d :=1) INTO _rec_res;
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
        p_parent      := _parent_codif_code    -- Код родительского идентификатора      
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
-- NOTICE:  Этап 1: Выбор: {C_CODIF_ROOT,C_OBJ_TYPE,C_E_COPY_TYPE,C_DOC_TYPE,C_OBJECT_LINK,C_CD_TYPES,C_IND_TYPE,C_EXEC_TYPE,C_AUTH_CONST,C_ACTION_TYPE,C_RUBBISH_TYPE,C_ACCOUNT_TYPE} -- C_OBJ_TYPE -- C_CODIF_ROOT
-- NOTICE:  Этап 2: Исходные значения: (2,1,Y,C_OBJ_TYPE,"Типы объектов","2019-07-15 04:57:18",d9989755-cc3e-4e50-b293-337dc986b3fd,{2},1,"Типы объектов",3,t)
-- NOTICE:  Этап 3: Проверка кода функции: ()
-- NOTICE:  Этап 4: Проверка зависимостей в коде функции: (FUNCTION,18126,com_codifier,com_f_obj_codifier_get_id,"(t_str60)")
-- NOTICE:  Этап 4: Проверка зависимостей в коде функции: (FUNCTION,18158,com_error,f_error_handling,"(exception_type_t,t_arr_text)")
-- NOTICE:  Этап 4: Проверка зависимостей в коде функции: (FUNCTION,18201,utl,com_f_empty_string_to_null,"(t_text)")
-- NOTICE:  Этап 4: Проверка зависимостей в коде функции: (RELATION,22556,com,obj_codifier,)
-- NOTICE:  Этап 5: Выполнение: (426,"Создание экземпляра кодификатора выполнено успешно")
-- NOTICE:  Этап 6: Результат: (426,2,0,XX_CODE_2365.47181382775,XX_NAME_9570.49116957933,"2015-01-01 00:00:00",9b4b998e-d848-4d96-843b-e9c5742fa093,{426},1,XX_NAME_9570.49116957933,0,f)
-- Query returned successfully with no result in 113 msec.

-- SELECT * FROM com.com_f_com_log_s (); -- НЕТ В LOG
-- SELECT * FROM com_codifier.com_f_obj_codifier_s_sys () WHERE (date_from = '2015-01-01 00:00:00')
-- select * from com.obj_codifier WHERE ( codif_id IN (424, 425) );
