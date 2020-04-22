-- -------------------------------------------------------------------------------------
--  2019-07-10 Nick Прототип UNIT теста для функции nso_structure.nso_p_object_i ()
--            Все insert делаем в любую ветку.
-- -------------------------------------------------------------------------------------
--  2020-04-07 Nick Переход на pgtap. Является обязательным начальное заполнение таблицы
--        nso_object. Это файл "4_nso_ins_tables.sql"
-- -------------------------------------------------------------------------------------
DO
  $$
     DECLARE
      _arr_parent_code   public.t_arr_code := (SELECT array_agg (nso_code::text) FROM nso_structure.nso_f_object_s_sys() WHERE (nso_type_code = 'C_NSO_NODE'));
      _parent_attr_code  public.t_str60;
      --
      _arr_type_code   public.t_arr_code := ARRAY ['C_NSO_CLASS', 'C_NSO_TTH', 'C_NSO_SPR', 'C_NSO_SPR_DAY_MESS', 'C_NSO_RBR'];
      _nso_type_code   public.t_str60;
      --
      _nso_code         public.t_str60;
      
      C_FUNC_SIGN text := 'nso_structure.nso_p_object_i (public.t_str60, public.t_str60, public.t_str60, public.t_str250, public.t_guid, public.t_boolean, public.t_timestamp, public.t_timestamp)';
      
      rsp_main   public.result_long_t;  
      _rec_res   RECORD;
      
     BEGIN
        PERFORM utl.f_debug_on ();
       _parent_attr_code := utl.f_array_random_get_element (_arr_parent_code);
       _nso_type_code := utl.f_array_random_get_element (_arr_type_code);
       
       RAISE NOTICE 'Этап 1: Выбор кодов: arr_parent_code = "%", parent_attr_code = "%", nso_type_code = "%"'
                                                         ,_arr_parent_code, _parent_attr_code, _nso_type_code;
       --
       SELECT * FROM nso_structure.nso_f_object_s_sys (_parent_attr_code, p_limit := 1) INTO _rec_res;
       RAISE NOTICE 'Этап 2: Исходные значения, родитель: %', _rec_res;
       --
       SELECT * FROM plpgsql_check_function (C_FUNC_SIGN) INTO _rec_res;
       RAISE NOTICE 'Этап 3: Проверка кода функции: %', _rec_res;

       FOR _rec_res IN SELECT * FROM plpgsql_show_dependency_tb (C_FUNC_SIGN) 
       LOOP 
            RAISE NOTICE 'Этап 4: Проверка зависимостей в коде функции: %', _rec_res;
       END LOOP;
       --
       -- Выбор кода и имени объекта делается случайным образом.
       --
       _nso_code := 'N_CODE_' || (random()*10000)::public.t_str60;
       rsp_main := nso_structure.nso_p_object_i (       
                               p_parent_nso_code := _parent_attr_code  --  Код родительского НСО
                              ,p_nso_type_code   := _nso_type_code    --  Тип НСО
                              ,p_nso_code        := _nso_code         --  Код НСО
                              ,p_nso_name        := 'ИМЯ_' || (random()*10000)::public.t_str250    --  Наименование НСО
                              ,p_nso_uuid        := newid()     --  UUID НСО
                              ,p_date_from       := '2011-01-01'::public.t_timestamp
       					   );
-- ---------------------------------------
      RAISE NOTICE 'Этап 5: Выполнение: %', rsp_main;
      IF ( rsp_main.rc < 0 ) THEN
          RAISE EXCEPTION '%', rsp_main.errm;
      END IF;
      --
      SELECT * FROM nso_structure.nso_f_object_s_sys (_nso_code) INTO _rec_res;
      RAISE NOTICE 'Этап 6: Результат: %', _rec_res;

      RAISE NOTICE '--';
      RAISE NOTICE '*********';
      RAISE NOTICE '--';
      --
     END;
  $$
     language plpgsql;
-- ------------------------------------------------------------------------------------
-- NOTICE:  Этап 1: Выбор Кода типа атрибута: {NSO_ROOT,NSO_NORM,NSO_TTH,NSO_CLASS,CL_RF,CL_ENTERPR,CL_LOCAL,NSO_DIC,NSO_UDF,NSO_SPR,SPR_LOCAL} -- NSO_CLASS -- C_NSO_SPR_DAY_MESS
-- NOTICE:  Этап 2: Исходные значения: (4,NSO_CLASS,1,NSO_ROOT,Классификатор.,"2019-07-15 04:58:48",6,C_NSO_NODE,"Узловой НСО",0,86070d77-a807-4f85-84c4-5d80ac506923,f,t,f,f,f,0,"2019-07-15 04:58:48","9999-12-31 00:00:00",{4},1,Классификатор.)
-- NOTICE:  Этап 3: Проверка кода функции: ()
-- NOTICE:  Этап 4: Проверка зависимостей в коде функции: (FUNCTION,18126,com_codifier,com_f_obj_codifier_get_id,"(t_str60)")
-- NOTICE:  Этап 4: Проверка зависимостей в коде функции: (FUNCTION,18144,com_domain,com_f_domain_get_id,"(t_str60)")
-- NOTICE:  Этап 4: Проверка зависимостей в коде функции: (FUNCTION,18158,com_error,f_error_handling,"(exception_type_t,t_arr_text)")
-- NOTICE:  Этап 4: Проверка зависимостей в коде функции: (FUNCTION,20053,nso,nso_p_nso_log_i,"(t_code1,t_text)")
-- NOTICE:  Этап 4: Проверка зависимостей в коде функции: (FUNCTION,18201,utl,com_f_empty_string_to_null,"(t_text)")
-- NOTICE:  Этап 4: Проверка зависимостей в коде функции: (FUNCTION,18207,utl,f_debug_status,"()")
-- NOTICE:  Этап 4: Проверка зависимостей в коде функции: (RELATION,22523,com,nso_domain_column,)
-- NOTICE:  Этап 4: Проверка зависимостей в коде функции: (RELATION,22556,com,obj_codifier,)
-- NOTICE:  Этап 4: Проверка зависимостей в коде функции: (RELATION,22680,nso,nso_column_head,)
-- NOTICE:  Этап 4: Проверка зависимостей в коде функции: (RELATION,22633,nso,nso_object,)
-- NOTICE:  <nso_p_object_i>, parent_nso_id = "4", nso_type_id = "342", nso_code = "N_CODE_9197.47962616384", nso_name = "N_CODE_9197.47962616384", nso_uuid = "0612bf7b-2c35-4a19-a8f3-290c8145e735", date_create = "2011-01-01 00:00:00", date_from = "2011-01-01 00:00:00", date_to = "9999-12-31 00:00:00", p_is_group_nso = "f"
-- NOTICE:  <nso_p_nso_log_i> 0, Создан НСО: "N_CODE_9197.47962616384 - N_CODE_9197.47962616384"
-- NOTICE:  Этап 5: Выполнение: (35,"Создание НСО выполнено успешно")
-- NOTICE:  Этап 6: Результат: (35,N_CODE_9197.47962616384,4,NSO_CLASS,N_CODE_9197.47962616384,"2011-01-01 00:00:00",342,C_NSO_SPR_DAY_MESS,Предупреждение,0,0612bf7b-2c35-4a19-a8f3-290c8145e735,t,f,f,f,f,0,"2011-01-01 00:00:00","9999-12-31 00:00:00",{35},1,N_CODE_9197.47962616384)
-- Query returned successfully with no result in 187 msec.

-- ------------------------------------------------------------------------------------
-- SELECT * FROM nso_structure.nso_f_object_s_sys() WHERE ( date_create = '2011-01-01 00:00:00');;
-- SELECT * FROM nso.nso_object;
-- 'N_CODE_9039.88895006478'|'N_CODE_9039.88895006478'
-- SELECT * FROM nso.nso_f_nso_log_s ();
-- UPDATE ONLY nso.nso_object SET date_create = date_from;
-- -------------------------------------------------------
-- UPDATE ONLY nso.nso_object SET nso_name = 'Перечень контекстов'  WHERE (nso_code = 'SPR_CONTEXT_LIST');  
-- UPDATE ONLY nso.nso_object SET nso_name = 'Подразделения'  WHERE (nso_code = 'SPR_DIVISION');  
-- UPDATE ONLY nso.nso_object SET nso_name = 'Предприятия'  WHERE (nso_code = 'SPR_EX_ENTERPRISE');  
-- UPDATE ONLY nso.nso_object SET nso_name = 'Должности'  WHERE (nso_code = 'SPR_POSITION');  
-- UPDATE ONLY nso.nso_object SET nso_name = 'Перечень действий'  WHERE (nso_code = 'SPR_ACTION');  
-- UPDATE ONLY nso.nso_object SET nso_name = 'Сотрудники'  WHERE (nso_code = 'SPR_EMPLOYE');  
-- UPDATE ONLY nso.nso_object SET nso_name = 'Перечень целей'  WHERE (nso_code = 'SPR_GOAL');  
-- UPDATE ONLY nso.nso_object SET nso_name = 'Согласования: перечень состояниий жизненного цикла'  WHERE (nso_code = 'SPR_MATCH_LC_STATUS');  
-- UPDATE ONLY nso.nso_object SET nso_name = 'Объекты: перечень состояниий жизненного цикла'  WHERE (nso_code = 'SPR_OBJECT_STATUS');  
-- UPDATE ONLY nso.nso_object SET nso_name = 'Перечень направлений расходования денежных средств'  WHERE (nso_code = 'SPR_PAYMENT_DIRECTION'); 
-- UPDATE ONLY nso.nso_object SET nso_name = 'Перечень ПТК'  WHERE (nso_code = 'SPR_PTK'); 
-- --
-- UPDATE ONLY nso.nso_object SET nso_name = 'Общероссийские классификаторы'  WHERE (nso_code = 'CL_RF'); 
-- UPDATE ONLY nso.nso_object SET nso_name = 'Общероссийский классификатор валют'  WHERE (nso_code = 'CL_OKV'); 
-- UPDATE ONLY nso.nso_object SET nso_name = 'Ведомственные классификаторы'  WHERE (nso_code = 'CL_ENTERPR'); 
-- UPDATE ONLY nso.nso_object SET nso_name = 'Справочник счетов'  WHERE (nso_code = 'SPR_ACCOUNT'); 
-- --
-- UPDATE ONLY nso.nso_object SET nso_name = 'Локальные классификаторы'  WHERE (nso_code = 'CL_LOCAL'); 
-- UPDATE ONLY nso.nso_object SET nso_name = 'Перечень рангов (вспомогательный классификатор)'  WHERE (nso_code = 'THC_RANGE'); 
