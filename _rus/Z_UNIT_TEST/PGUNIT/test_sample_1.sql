SET search_path=pgunit, public;
DROP FUNCTION IF EXISTS pgunit.test_sample ();
CREATE FUNCTION pgunit.test_sample () RETURNS testfunc[]
AS
$body$
SELECT pgunit.testcase(
    $setUp$
        -- setUp code is executed before ANY test function code (see below).
        -- Effect of this execution is persistent only during the code
        -- block execution and rolled back after the test is finished.
        CREATE TABLE tst(id INTEGER);
    $setUp$,
    ARRAY[

        'DC::insert test', $sql$
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
        $sql$
    ]
);
$body$
    LANGUAGE sql;
    
