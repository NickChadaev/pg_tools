-- -------------------------------------------------------------------------------------------------- --
--  2020-01-10 Nick Прототип UNIT теста для функции "nso_structure.nso_p_key_d"                       --
--                    Один запуск - один удалённый маркер/ключ.                                       --
-- -------------------------------------------------------------------------------------------------- --
DO
  $$
     DECLARE
      _arr_nso_code  public.t_arr_code := (SELECT array_agg (nso_code::text) FROM nso_structure.nso_f_object_s_sys() WHERE (date_create = '2011-01-01'::public.t_timestamp));
      _arr_key_id       public.t_arr_id;
      --
      _nso_code  public.t_str60;
      _key_id    public.id_t;
      --
      C_FUNC_SIGN text := 'nso_structure.nso_p_key_d (public.t_str60)';
      
      rsp_main   public.result_long_t;  
      _rec_res   RECORD;
      
     BEGIN
       PERFORM utl.f_debug_on ();
       --
       -- Должен быть по крайней мере один объект с сформированным оглавлениенм.
       --
       LOOP
          _nso_code := utl.f_array_random_get_element (_arr_nso_code);
          _arr_nso_code := array_remove (_arr_nso_code::text[], _nso_code::text);
          EXIT WHEN (_nso_code IS NULL);
          --
          _arr_key_id := (SELECT array_agg (DISTINCT key_id::bigint) FROM nso_structure.nso_f_column_head_nso_s(_nso_code) WHERE (key_id IS NOT NULL));
          _key_id     := utl.f_array_random_get_element (_arr_key_id); 
          _arr_key_id := array_remove (_arr_key_id::bigint[], _key_id::bigint);
          EXIT WHEN ((_key_id IS NOT NULL) OR (_nso_code IS NULL));
       END LOOP;
       --
       IF (_nso_code IS NULL)
         THEN
               RAISE 'Не найден НСО со сформированным заголовком';
       END IF;
       --       
       RAISE NOTICE 'Этап 1: Выбор НСО: % -- %', _nso_code, _key_id;
       --
       FOR _rec_res IN SELECT * FROM plpgsql_check_function (C_FUNC_SIGN) 
       LOOP 
            RAISE NOTICE 'Этап 2: Проверка кода функции: %', _rec_res;
       END LOOP;
       --       
       FOR _rec_res IN SELECT * FROM plpgsql_show_dependency_tb (C_FUNC_SIGN) 
       LOOP 
            RAISE NOTICE 'Этап 3: Проверка зависимостей в коде функции: %', _rec_res;
       END LOOP;
       --
       -- Выбор Атрибута делается случайным образом.
       --
       rsp_main :=  nso_structure.nso_p_key_d ((SELECT key_code FROM ONLY nso.nso_key WHERE key_id = _key_id));				         
       -- ---------------------------------------
       RAISE NOTICE 'Этап 4: Выполнение: %', rsp_main;
       IF ( rsp_main.rc < 0 ) THEN
                   RAISE EXCEPTION '%', rsp_main.errm;
       END IF;
       --
       FOR _rec_res IN SELECT * FROM nso_structure.nso_f_column_head_nso_s (_nso_code) 
       LOOP 
           RAISE NOTICE 'Этап 5: Результат: %', _rec_res;
       END LOOP;
       --
     END;
  $$
     LANGUAGE plpgsql;
-- ------------------------------------------------------------------------------------
--    SELECT * FROM nso_structure.nso_f_column_head_nso_s('N_CODE_365.252592600882');
--
-- NOTICE:  Этап 1: Выбор НСО: N_CODE_365.252592600882 -- 4
-- NOTICE:  Этап 3: Проверка зависимостей в коде функции: (FUNCTION,23588,com_error,f_error_handling,"(exception_type_t,t_arr_text)")
-- NOTICE:  Этап 3: Проверка зависимостей в коде функции: (FUNCTION,23631,nso,nso_p_nso_log_i,"(t_code1,t_text)")
-- NOTICE:  Этап 3: Проверка зависимостей в коде функции: (FUNCTION,23649,nso_structure,nso_f_select_c,"(t_str60)")
-- NOTICE:  Этап 3: Проверка зависимостей в коде функции: (FUNCTION,23668,utl,com_f_empty_string_to_null,"(t_text)")
-- NOTICE:  Этап 3: Проверка зависимостей в коде функции: (FUNCTION,23675,utl,f_debug_status,"()")
-- NOTICE:  Этап 3: Проверка зависимостей в коде функции: (RELATION,23840,nso,nso_abs,)
-- NOTICE:  Этап 3: Проверка зависимостей в коде функции: (RELATION,23903,nso,nso_key,)
-- NOTICE:  Этап 3: Проверка зависимостей в коде функции: (RELATION,23914,nso,nso_key_attr,)
-- NOTICE:  Этап 3: Проверка зависимостей в коде функции: (RELATION,23950,nso,nso_object,)
-- NOTICE:  <nso_p_nso_log_i> E, Удаление заголовка ключа: K_N_CODE_365.252592600882_DEFKEY
-- NOTICE:  <nso_p_key_d>, K_N_CODE_365.252592600882_DEFKEY, 4, {97,82,96}
-- NOTICE:  <nso_p_nso_log_i> 4, Обновление данных объекта: N_CODE_365.252592600882
-- NOTICE:  Этап 4: Выполнение: (4,"Успешно удален ключ ""K_N_CODE_365.252592600882_DEFKEY""")
-- NOTICE:  Этап 5: Результат: (24,,0,88,D_N_CODE_365.252592600882,"Заголовок - ИМЯ_36.7417838424444",7,U,C_DOMEN_NODE,"Узловой Атрибут",f,,,,,,,,0)
-- NOTICE:  Этап 5: Результат: (37,24,1,60,A_CODE_5185.90887077153,ИМЯ_6112.30916343629,288,C,T_STR1024,"Строка размерностью 1024 символов",t,5,t,2,312,b,AKKEY2,"Уникальный ключ 2",1)
-- NOTICE:  Этап 5: Результат: (82,24,1,29,A_CODE_6457.68525544554,ИМЯ_2315.02825394273,283,7,T_CODE2,"Код размерностью 2 символа",t,,,,,,,,1)
-- NOTICE:  Этап 5: Результат: (38,24,2,31,A_CODE_6733.96073281765,ИМЯ_838.589826598763,293,H,T_DATE,Дата,t,,,,,,,,1)
-- NOTICE:  Этап 5: Результат: (83,24,2,56,A_CODE_3961.07673179358,ИМЯ_462.285792455077,296,K,T_GUID,UUID,t,,,,,,,,1)
-- NOTICE:  Этап 5: Результат: (84,24,3,40,A_CODE_3255.62299694866,ИМЯ_5812.58767284453,308,П,T_JSON,"Тип JSON (Java Script Objects Notation)",t,,,,,,,,1)
-- NOTICE:  Этап 5: Результат: (85,24,4,46,A_CODE_9670.76737899333,ИМЯ_4945.55887300521,303,T,T_REF,"Атрибут-ссылка на НСО",t,,,,,,,,1)
-- NOTICE:  Этап 5: Результат: (86,24,5,43,A_CODE_5456.26219827682,ИМЯ_8379.25737258047,277,1,SMALL_T,"Короткое целое",t,,,,,,,,1)
-- NOTICE:  Этап 5: Результат: (87,24,7,78,A_CODE_5968.59124489129,ИМЯ_8594.48546543717,303,T,T_REF,"Атрибут-ссылка на НСО",t,,,,,,,,1)
-- NOTICE:  Этап 5: Результат: (88,24,8,42,A_CODE_5987.73748613894,ИМЯ_9410.52801441401,287,B,T_STR250,"Строка 250 символов",t,,,,,,,,1)
-- NOTICE:  Этап 5: Результат: (89,24,9,44,A_CODE_3539.94682431221,ИМЯ_9956.93157892674,277,1,SMALL_T,"Короткое целое",t,,,,,,,,1)
-- NOTICE:  Этап 5: Результат: (90,24,10,36,A_CODE_3043.44683885574,ИМЯ_7869.22550294548,309,Ф,ID_T,"Идентификатор (Long Integer)",t,,,,,,,,1)
-- NOTICE:  Этап 5: Результат: (91,24,11,65,A_CODE_4584.3830704689,ИМЯ_4326.91076304764,300,P,T_INN_UL,"ИНН юридического лица",t,,,,,,,,1)
-- NOTICE:  Этап 5: Результат: (92,24,12,79,A_CODE_626.581516116858,ИМЯ_8287.98749484122,303,T,T_REF,"Атрибут-ссылка на НСО",t,,,,,,,,1)
-- NOTICE:  Этап 5: Результат: (93,24,14,56,A_CODE_8401.69165283442,ИМЯ_1214.37787543982,296,K,T_GUID,UUID,t,,,,,,,,1)
-- NOTICE:  Этап 5: Результат: (94,24,15,26,A_CODE_2258.08601826429,ИМЯ_6670.64007371664,281,5,T_BOOLEAN,Логическое,t,,,,,,,,1)
-- NOTICE:  Этап 5: Результат: (95,24,16,76,A_CODE_2692.48744938523,ИМЯ_9813.75557836145,303,T,T_REF,"Атрибут-ссылка на НСО",t,,,,,,,,1)
-- NOTICE:  Этап 5: Результат: (96,24,17,60,A_CODE_2373.45471046865,ИМЯ_5782.34682325274,288,C,T_STR1024,"Строка размерностью 1024 символов",t,,,,,,,,1)
-- NOTICE:  Этап 5: Результат: (97,24,18,52,A_CODE_6064.26353566349,ИМЯ_1770.08431404829,297,L,T_SYSNAME,"Имя таблицы",t,,,,,,,,1)
-- NOTICE:  Этап 5: Результат: (98,24,19,48,A_CODE_214.003613218665,ИМЯ_5310.0311383605,303,T,T_REF,"Атрибут-ссылка на НСО",t,5,t,3,312,b,AKKEY2,"Уникальный ключ 2",1)
-- NOTICE:  Этап 5: Результат: (99,24,20,48,A_CODE_2979.52525317669,ИМЯ_8353.47797721624,303,T,T_REF,"Атрибут-ссылка на НСО",t,5,t,1,312,b,AKKEY2,"Уникальный ключ 2",1)
-- NOTICE:  Этап 5: Результат: (100,24,21,35,A_CODE_514.808730222285,ИМЯ_2937.86105234176,280,4,T_FLOAT,Вещественое,t,,,,,,,,1)
-- NOTICE:  Этап 5: Результат: (101,24,22,61,A_CODE_365.120465867221,ИМЯ_3564.44256845862,303,T,T_REF,"Атрибут-ссылка на НСО",t,,,,,,,,1)
-- NOTICE:  Этап 5: Результат: (102,24,23,51,A_CODE_677.717993967235,ИМЯ_7553.57964430004,289,D,T_STR2048,"Строка размерностью 2048 символов",t,,,,,,,,1)
-- 
-- Query returned successfully with no result in 544 msec.
