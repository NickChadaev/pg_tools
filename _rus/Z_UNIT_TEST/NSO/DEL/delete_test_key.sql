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
--    SELECT * FROM nso_structure.nso_f_column_head_nso_s('N_CODE_2244.96691022068');
--
