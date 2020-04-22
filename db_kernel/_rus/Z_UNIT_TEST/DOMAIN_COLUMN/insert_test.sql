-- ------------------------------------------------------------------------------------- --
--  2019-07-10 Nick Прототип UNIT теста для функции com_domain.nso_p_domain_column_i ()  --
--     Все insert делаем в техническую ветку.                                            --  
--  ------------------------------------------------------------------------------------ --
--  2020-04-02 В рамках борьбы с "pgtap" немного модифицирую скрипт.                     --
-- ------------------------------------------------------------------------------------- --
DO
  $$
     DECLARE
      _arr_code  public.t_arr_code := (SELECT array_agg (codif_code::text) FROM com_codifier.com_f_obj_codifier_s('C_ATTR_TYPE'));
      rsp_main   public.result_long_t;

      _attr_type_code    public.t_str60;
      _parent_attr_code  public.t_str60 := 'IND_APP_NODE';
      _rec_res           RECORD;

      C_FUNC_SIGN TEXT := 'com_domain.nso_p_domain_column_i (public.t_str60, public.t_str60, public.t_str60, public.t_str250, public.t_guid, public.t_str60, public.t_timestamp, public.t_timestamp)';
      
     BEGIN
       _attr_type_code := utl.f_array_random_get_element (_arr_code); 
       RAISE NOTICE 'Этап 1: Выбор типа атрибута, (исходные значения): arr_code = "%"', _arr_code;
       --
       RAISE NOTICE 
                    'Этап 1: Выбор типа атрибута, (выбрано): attr_type_code = "%", _parent_attr_code = "%"', _attr_type_code, _parent_attr_code;

       SELECT * FROM com_domain.nso_f_domain_column_s (_parent_attr_code) INTO _rec_res;
       RAISE NOTICE 'Этап 2: Родитель: %', _rec_res;
       --
       SELECT * FROM plpgsql_check_function (c_func_sign) INTO _rec_res;
       RAISE NOTICE 'Этап 3: Проверка кода функции "com_domain.nso_p_domain_column_i": %', _rec_res;

       FOR _rec_res IN SELECT * FROM plpgsql_show_dependency_tb (c_func_sign) 
       LOOP 
          RAISE NOTICE 'Этап 4: Проверка зависимостей в коде функции "com_domain.nso_p_domain_column_i": %'
                        , _rec_res;
       END LOOP;
       --
       -- Выбор типа делается случайным образом.
       --
       rsp_main := com_domain.nso_p_domain_column_i (		
          p_parent_attr_code :=  _parent_attr_code                  -- Код родительского атрибута
         ,p_attr_type_code   :=  _attr_type_code                    -- Код типа атрибута
         ,p_attr_code        :=   'I_CODE_' || (random()*10000)::text -- Код атрибута
         ,p_attr_name        :=   'ИМЯ_' || (random()*10000)::text    -- Наименование атрибута
         ,p_attr_uuid        :=   newid()                           -- UUID атрибута
        -- ,p_date_to          := NULL
      );
      RAISE NOTICE 'Этап 5: Выполнение: %', rsp_main;
      IF ( rsp_main.rc < 0 ) THEN
          RAISE EXCEPTION '%', rsp_main.errm;
      END IF;
      --
      SELECT * FROM com_domain.nso_f_domain_column_s (rsp_main.rc) INTO _rec_res;
      RAISE NOTICE 'Этап 6: Результат: %', _rec_res;
      --
     END;
  $$
     language plpgsql;
-- ------------------------------------------------------------------------------------
-- NOTICE:  Этап 1: Выбор Кода типа атрибута: {C_DOMEN_NODE,SMALL_T,T_INT,LONGINT_T,T_FLOAT,T_BOOLEAN,T_CODE1,T_CODE2,T_CODE5,T_STR20,T_STR60,T_STR250,T_STR1024,T_STR2048,T_DESCRIPTION,T_TIMESTAMP,T_TIMESTAMPZ,T_DATE,IP_T,XML_T,T_GUID,T_SYSNAME,T_FIELDNAME,T_MONEY,T_INN_UL,T_KPP,T_PHONE_NMB,T_REF,T_TEXT,T_INN_PP,T_DECIMAL,T_BLOB,T_JSON,ID_T,T_INTERVAL,T_BIT4,T_BIT8} -- SMALL_T -- IND_APP_NODE
-- NOTICE:  Этап 2: Исходные значения: (28,24,IND_APP_NODE,Тест_600.654170848429,41,C_DOMEN_NODE,"Узловой Атрибут",,0,,,637a1331-12aa-4c46-bb5a-47d746a4ea22,"2019-05-24 11:03:09",f,"2019-07-10 16:25:47","9999-12-31 00:00:00",{28},1,Тест_600.654170848429,,,,908)
-- NOTICE:  Этап 3: Проверка кода функции: ()
-- NOTICE:  Этап 4: Проверка зависимостей в коде функции: (FUNCTION,19063,com_codifier,com_f_obj_codifier_s,"(t_str60,t_str60)")
-- NOTICE:  Этап 4: Проверка зависимостей в коде функции: (FUNCTION,18158,com_error,f_error_handling,"(exception_type_t,t_arr_text)")
-- NOTICE:  Этап 4: Проверка зависимостей в коде функции: (FUNCTION,18201,utl,com_f_empty_string_to_null,"(t_text)")
-- NOTICE:  Этап 4: Проверка зависимостей в коде функции: (RELATION,18259,com,nso_domain_column,)
-- NOTICE:  Этап 4: Проверка зависимостей в коде функции: (RELATION,18284,com,obj_codifier,)
-- NOTICE:  Этап 4: Проверка зависимостей в коде функции: (RELATION,18472,nso,nso_object,)
-- NOTICE:  Этап 5: Выполнение: (29,"Создание атрибута выполнено успешно")
-- NOTICE:  Этап 6: Результат: (28,24,IND_APP_NODE,Тест_600.654170848429,41,C_DOMEN_NODE,"Узловой Атрибут",,0,,,637a1331-12aa-4c46-bb5a-47d746a4ea22,"2019-05-24 11:03:09",f,"2019-07-10 16:25:47","9999-12-31 00:00:00",{28},1,Тест_600.654170848429,,,,908)
-- Query returned successfully with no result in 133 msec.
--
-- SELECT * FROM com_domain.nso_f_domain_column_s ('IND_APP_NODE');
-- SELECT * FROM com.com_f_com_log_s ();

