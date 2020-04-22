-- -------------------------------------------------------------------------------------
--  2019-07-10 Nick Прототип UNIT теста для функции com_domain.nso_p_domain_column_u ()
-- -------------------------------------------------------------------------------------
DO
  $$
     DECLARE
      _arr_id  int8[] := (SELECT array_agg (attr_id::int8) FROM com_domain.nso_f_domain_column_s ('APP_NODE'));

      rsp_main   public.result_long_t;

      _attr_id	 public.id_t;
      _rec_res   RECORD;

      C_FUNC_SIGN TEXT := 'com_domain.nso_p_domain_column_u (public.id_t, public.id_t, public.id_t, public.t_boolean, public.t_str60, public.t_str250, public.id_t, public.t_guid)';
      
     BEGIN
       _attr_id := utl.f_array_random_get_element (_arr_id); 
       RAISE NOTICE 'Этап 1: Выбор ID атрибута: % --%', _arr_id, _attr_id;
       --
       SELECT * FROM com_domain.nso_f_domain_column_s (_attr_id) INTO _rec_res;
       RAISE NOTICE 'Этап 2: Старые значения: %', _rec_res;
       --
       SELECT * FROM plpgsql_check_function (c_func_sign) INTO _rec_res;
       RAISE NOTICE 'Этап 3: Проверка кода функции: %', _rec_res;

       FOR _rec_res IN SELECT * FROM plpgsql_show_dependency_tb (c_func_sign) 
       LOOP 
           RAISE NOTICE 'Этап 4: Проверка зависимостей в коде функции: %', _rec_res;
       END LOOP;
       --
       rsp_main := com_domain.nso_p_domain_column_u (
           p_attr_id	     := _attr_id                 -- Идентификатор атрибута
         --  ,p_parent_attr_id   public.id_t      DEFAULT NULL -- Идентификатор родительского атрибута
         --  ,p_attr_type_id	 public.id_t      DEFAULT NULL -- Тип атрибута
          ,p_is_intra_op     := FALSE  -- Признак итраоперабельности   А он не нужен !!!
         --  ,p_attr_code	          public.t_str60   DEFAULT NULL -- Код атрибута(новый)
          ,p_attr_name	     := 'Тест_' || (random ()* 10000)::text -- public.t_str250  DEFAULT NULL -- Наименование атрибута
       );
      RAISE NOTICE 'Этап 5: Выполнение: %', rsp_main;
      IF ( rsp_main.rc < 0 ) THEN
          RAISE EXCEPTION '%', rsp_main.errm;
      END IF;
      --
      SELECT * FROM com_domain.nso_f_domain_column_s (_attr_id) INTO _rec_res;
      RAISE NOTICE 'Этап 6: Результат: %', _rec_res;
      -- 
     END;
  $$
     language plpgsql;
-- ------------------------------------------------------------------------------------
-- NOTICE:  Этап 1: Выбор ID атрибута: {24,27,28} --28
-- NOTICE:  Этап 2: Старые значения: (28,24,IND_APP_NODE,"Прикладные атрибуты схемы IND",41,C_DOMEN_NODE,"Узловой Атрибут",,0,,,637a1331-12aa-4c46-bb5a-47d746a4ea22,"2019-05-24 11:03:09",f,"2019-05-24 11:03:09","9999-12-31 00:00:00",{28},1,"Прикладные атрибуты схемы IND",,,,203)
-- NOTICE:  Этап 3: Проверка кода функции: ()
-- NOTICE:  Этап 4: Проверка зависимостей в коде функции: (FUNCTION,18158,com_error,f_error_handling,"(exception_type_t,t_arr_text)")
-- NOTICE:  Этап 4: Проверка зависимостей в коде функции: (FUNCTION,18201,utl,com_f_empty_string_to_null,"(t_text)")
-- NOTICE:  Этап 4: Проверка зависимостей в коде функции: (RELATION,18220,auth,auth_role_attr,)
-- NOTICE:  Этап 4: Проверка зависимостей в коде функции: (RELATION,18259,com,nso_domain_column,)
-- NOTICE:  Этап 4: Проверка зависимостей в коде функции: (RELATION,18284,com,obj_codifier,)
-- NOTICE:  Этап 4: Проверка зависимостей в коде функции: (RELATION,18354,ind,ind_type_header,)
-- NOTICE:  Этап 4: Проверка зависимостей в коде функции: (RELATION,18398,nso,nso_column_head,)
-- NOTICE:  Этап 4: Проверка зависимостей в коде функции: (RELATION,18472,nso,nso_object,)
-- NOTICE:  Этап 5: Выполнение: (28,"Успешно выполнено полное обновление атрибута.")
-- NOTICE:  Этап 6: Результат: (28,24,IND_APP_NODE,Тест_600.654170848429,41,C_DOMEN_NODE,"Узловой Атрибут",,0,,,637a1331-12aa-4c46-bb5a-47d746a4ea22,"2019-05-24 11:03:09",f,"2019-07-10 16:25:47","9999-12-31 00:00:00",{28},1,Тест_600.654170848429,,,,908)
-- Query returned successfully with no result in 145 msec.
-- 
