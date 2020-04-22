-- -------------------------------------------------------------------------------------
--  2019-07-10 Nick Прототип UNIT теста для функции com_domain.nso_p_domain_column_d ()
--     Все delete делаем в технической ветки.
-- -------------------------------------------------------------------------------------
DO
  $$
     DECLARE
      
      rsp_main public.result_long_t;

      _attr_id            public.id_t;
      _parent_attr_code   public.t_str60 := 'IND_APP_NODE';
      _arr_id             int8[] := (SELECT array_agg(attr_id::text) 
                                        FROM com_domain.nso_f_domain_column_s (_parent_attr_code)
                                                WHERE ( attr_code <> _parent_attr_code )
                                    );

      _rec_res  RECORD;

      C_FUNC_SIGN TEXT := 'com_domain.nso_p_domain_column_d (public.id_t)';
      
     BEGIN
       _attr_id := utl.f_array_random_get_element (_arr_id); 
       RAISE NOTICE 'Этап 1: Выбор Кода типа атрибута: % -- %', _arr_id, _attr_id;
       --
       SELECT * FROM com_domain.nso_f_domain_column_s (_attr_id) INTO _rec_res;
       RAISE NOTICE 'Этап 2: Исходные значения: %', _rec_res;
       --
       SELECT * FROM plpgsql_check_function (c_func_sign) INTO _rec_res;
       RAISE NOTICE 'Этап 3: Проверка кода функции: %', _rec_res;

       FOR _rec_res IN SELECT * FROM plpgsql_show_dependency_tb (c_func_sign) 
       LOOP 
           RAISE NOTICE 'Этап 4: Проверка зависимостей в коде функции: %', _rec_res;
       END LOOP;
       --
       rsp_main := com_domain.nso_p_domain_column_d (_attr_id);		
       RAISE NOTICE 'Этап 5: Выполнение: %', rsp_main;
       -- --------------------------------------------
       --  В случае неуспеха НЕ ГЕНЕРИРУЕМ EXCEPTION
       --
       -- IF ( rsp_main.rc < 0 ) THEN
       --    RAISE EXCEPTION '%', rsp_main.errm;
       -- END IF;
       --
     END;
  $$
     language plpgsql;
-- ------------------------------------------------------------------------------------
-- NOTICE:  Этап 1: Выбор Кода типа атрибута: {29,30,31,32,33,34} -- 30
-- NOTICE:  Этап 2: Исходные значения: (30,28,I_CODE_2305.17598800361,ИМЯ_6767.2683019191,325,T_CODE2,"Код размерностью 2 символа",2,0,bpchar,S,ed78cfa2-ed0d-44c2-942b-c4974ec15c96,"2019-07-11 07:19:01",f,"2019-07-11 07:19:01","9999-12-31 00:00:00",{30},1,ИМЯ_6767.2683019191,,,,913)
-- NOTICE:  Этап 3: Проверка кода функции: ()
-- NOTICE:  Этап 4: Проверка зависимостей в коде функции: (FUNCTION,18158,com_error,f_error_handling,"(exception_type_t,t_arr_text)")
-- NOTICE:  Этап 4: Проверка зависимостей в коде функции: (RELATION,18259,com,nso_domain_column,)
-- NOTICE:  Этап 5: Выполнение: (30,"Успешно удален атрибут")
-- NOTICE:  Этап 6: Результат: (28,24,IND_APP_NODE,Тест_600.654170848429,41,C_DOMEN_NODE,"Узловой Атрибут",,0,,,637a1331-12aa-4c46-bb5a-47d746a4ea22,"2019-05-24 11:03:09",f,"2019-07-10 16:25:47","9999-12-31 00:00:00",{28},1,Тест_600.654170848429,,,,908)
-- Query returned successfully with no result in 84 msec.--

-- SELECT * FROM com_domain.nso_f_domain_column_s ('IND_APP_NODE');
-- SELECT * FROM com.com_f_com_log_s ();

