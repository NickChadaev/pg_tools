-- ====================================================================================
-- Author:		SVETA
-- Create date: 2013-08-16
-- Description:	Вставка  одной строки в классификатор/Справочник линейной структуры
-- Moify: 2014-05-20. Anna. Добавлено удаление из nso_temp_log в exception
-- ------------------------------------------------------------------------------------
--  2015-04-21 Nick  Переход на домен ЕБД.   
-- ------------------------------------------------------------------------------------
--  2015-04-22 Nick  Что осталось:
--    -  1 - все ошибки, связанные с nso_record, nso_abs, nso_ref
--    -  2 - контроль уникальности
--    -  3 - разрушающее тестирование
--    -  4 - логгирование
--    -  5 - активация НСО
--    -  6 - ссылки и абсолютные значения в одном флаконе
--    -  7 - отображение данных:
--         -  7.1 - def_value
--         -  7.2 - прямое представление
--         -  7.3 - инвертированное представление.    
-- ======================================================================================================
-- 2015-06-11 Nick.    Добавил BLOB, пока заглушка.
-- 2015-06-16 Nick.    Заглушку "открыл".
-- 2015-07-06 Nick.    Доработки, связанные с введением "режима тишины" и контроля ссылочных значений.
-- 2015-10-06 Nick.    Ссылка может быть NULL
-- 2016-07-13 Gregory. Контроль уникальности.
-- 2016-08-17 Nick     Пропущенная ошибка возникающая при контроле уникальности.
-- 2016-11-12 Nick,    Абсолютное значение типа t_text (t_arr_values -> t_arr_text, t_str2048 -> t_text) 
-- 2017-06-11 Nick,    Вместо массива p_mas_val используем структуру "Ключ-Значение".
-- 2018-09-05 Nick,    Все ключи hstore принудительно в вехний регистр. В заголовке НСО они всегда вверху.
/* ------------------------------------------------------------------------------------------------------
	Входные параметры

   p_rec_uuid         public.t_guid   -- Идентификатор текущей записи          not null,
   p_parent_rec_uuid  public.t_guid   -- Идентификатор родительской записи          null,
   --
	p_nso_code         public.t_str60  --  Код НСО
   p_val              public.t_text   -- Cтруктура "Ключ-Значение"
   -- 
   -- По умолчанию
   -- 
   p_silent_mode      public.t_boolean   -- Режим тишины, выводятся только сообщения связанные с EXECEPTION, not null default true,
   p_actual           public.t_boolean   -- Актуальность                   not null default true,
   p_date_from        public.t_timestamp -- Дата начала актуальности       not null default CURRENT_TIMESTAMP::timestamp(0) without time zone,
   p_date_to          public.t_timestamp -- Дата завершения актуальности   not null default '9999-12-31 00:00:00'::timestamp(0) without time zone,

	Выходные параметры
				  0 - процедура завершилась успешно
				 -1 - процедура завершилась с ошибкой

	Особенности
				При добавлении записи в структуру, содержащие ссылочные атрибуты, ссылочные значения должны являтся UUID из классификатора-родителя 
            (загрузка по UUID, а не по значениям)

--------------------------------------------------------------------------------------------------------------------------------------------------*/
SET search_path = nso,com,public;

-- DROP FUNCTION IF EXISTS nso.nso_p_record_i2 (public.t_guid, public.t_guid, public.t_str60, public.t_text, public.t_boolean, public.t_boolean, public.t_timestamp, public.t_timestamp);
CREATE OR REPLACE FUNCTION nso.nso_p_record_i2 (

    p_rec_uuid        public.t_guid   -- Идентификатор текущей записи          not null,
   ,p_parent_rec_uuid public.t_guid   -- Идентификатор родительской записи          null,
    --
	,p_nso_code        public.t_str60  -- Код НСО
   ,p_val             public.t_text   -- Cтруктура "Ключ-Значение"
    -- 
    -- По умолчанию
    -- 
   ,p_silent_mode  public.t_boolean   = TRUE -- Режим тишины, выводятся только сообщения связанные с EXECEPTION 
   ,p_actual       public.t_boolean   = TRUE                                                   -- Актуальность                   
   ,p_date_from    public.t_timestamp = CURRENT_TIMESTAMP::timestamp(0) without time zone      -- Дата начала актуальности       
   ,p_date_to      public.t_timestamp = '9999-12-31 00:00:00'::timestamp(0) without time zone  -- Дата завершения актуальности   
)
  RETURNS  public.result_t 
      SECURITY DEFINER  
      LANGUAGE plpgsql 
  AS
$$
   DECLARE 
     с_FUNC_NAME        public.t_sysname  := 'nso_p_record_i2'; --имя процедуры
     c_DOMAIN_NODE      public.t_str60    := 'C_DOMEN_NODE';
     c_NSO_REC_SEQ_NAME public.t_sysname  := 'nso.nso_record_rec_id_seq';
     c_MES000           public.t_str1024  := 'Выполнено успешно'; 
     -- 
     _nso_id      public.id_t; 
     _rec_id      public.id_t; 
     _ref_rec_id  public.id_t;
     _arr_column  public.column_t2[];
     --
     rsp_main public.result_t;
     _rsp     public.result_t;
     --
     _len_arr_type_code  public.t_int;
     _ind                public.t_int := 1;           
     --
     _unique_check       public.t_boolean; -- 2016-07-19 Gregory
     -- Nick 2017-06-11
     _mas_val public.t_arr_text; -- Массив значений для ячеек, при отсутствии данных необходимо передать null, для ссылочного значения передаём UUID.
     _val     hstore;
     c_DEBUG  public.t_boolean := utl.f_debug_status();

   BEGIN
    -- =================================================================================
    --  1. Начальная установка
      _nso_id := ( SELECT nso_id FROM ONLY nso.nso_object WHERE ( nso_code = upper (btrim (p_nso_code))));
      _unique_check := ( SELECT unique_check FROM ONLY nso.nso_object WHERE nso_id = _nso_id);
      _arr_column := ARRAY ( SELECT ROW ( col_id
                                        , number_col     -- Nick 2017-06-11
                                        , attr_code      -- Nick 2017-06-11
                                        , attr_type_scode
                                        , CASE 
                                             WHEN key_type_scode IS NULL THEN '0'
                                             ELSE
                                                  key_type_scode
                                          END       
                                   ) 
                              FROM nso.nso_f_column_head_nso_s ( upper (btrim (p_nso_code)) )
                                  WHERE ( attr_type_code <> c_DOMAIN_NODE ) ORDER BY number_col
      );
      -- 
      _len_arr_type_code := array_length (_arr_column, 1);

      -- 2018-09-05  Ключи нужно всегда поднимать в верхний регистр.
      _val := com.f_hstore_key_mod (p_val); -- Nick 2017-06-11 Отлавливать прерывание  2020-02-11 НЕТ ФУНКЦИИ

      IF c_DEBUG THEN
          RAISE NOTICE '1) <%>, %, %, %', с_FUNC_NAME, _arr_column, _len_arr_type_code, _val;
      END IF;

   -- ==================================================================================
   -- 2. Проверяем добавляемые данные 
   --	   + 2.1 Формирую вспомогательный массив
   --    + 2.2 на соответствие типу данных
   --    - 2.3 на уникальность по ключевым атрибутам, используя функцию NSO_F_Value_Check
   -- ==================================================================================
       -- 2.1
       _ind := 2;
       _mas_val [1] := NULL;
       WHILE ( _ind <= _len_arr_type_code ) LOOP
          _mas_val := _mas_val || NULL;
          _ind := _ind + 1;
       END LOOP;

      IF c_DEBUG THEN
          RAISE NOTICE '2) <%>, %', с_FUNC_NAME, _mas_val;
      END IF;
      --  
      -- 2.2
      _ind := 1;
   	WHILE ( _ind <= _len_arr_type_code ) LOOP 
                _rsp := utl.com_f_value_check ( _arr_column [_ind].col_stype
                                              , (_val -> _arr_column [_ind].col_code)  -- Nick 2017-06-11
                 );
                IF ( _rsp.rc = -1 ) THEN
                      RAISE EXCEPTION '%', _rsp.errm ; -- Ошибка преобразования типа
                END IF;
                IF ( NOT p_silent_mode ) THEN
                               RAISE NOTICE '%', _rsp.errm;
                END IF;
                _mas_val [_ind] := (_val -> _arr_column [_ind].col_code); -- Nick 2017-06-11
                _ind := _ind + 1;
      END LOOP;

      IF c_DEBUG THEN
          RAISE NOTICE '3) <%>, %', с_FUNC_NAME, _mas_val;
      END IF;
   -- ============================================
   --	3. Добавляем данные
   -- ============================================
   	INSERT INTO nso.nso_record (   parent_rec_id
                                    ,rec_uuid     
                                    ,nso_id       
                                    ,actual       
                                    ,date_from    
                                    ,date_to      
                                  ) 
      VALUES (
               NULL -- Временно 
              ,p_rec_uuid   
              ,_nso_id       -- Более не нужен, далее использую для контроля ссылочного значения.     
              ,p_actual     
              ,p_date_from  
              ,p_date_to    
      );
      _rec_id := CURRVAL ( c_NSO_REC_SEQ_NAME );

      _ind := 1;
   	WHILE ( _ind <= _len_arr_type_code ) LOOP   
         IF ( _arr_column [_ind].col_stype = 'T' ) THEN -- Ссылка
            IF ( _mas_val [_ind] IS NOT NULL ) THEN -- Nick 2015-10-06
                            --  --------------------------------------     
                            --  Nick 2015-07-06
                            --  ---------------
                            --
                            --  Определить тот домен, к которому принадлежит атрибут, это nso_id.  !!!!
                            --
                            _nso_id := ( SELECT d.domain_nso_id FROM ONLY nso.nso_column_head nh, ONLY com.nso_domain_column d 
                                                                                WHERE ( nh.attr_id = d.attr_id ) AND ( nh.col_id = _arr_column [_ind].col_id )
                            ); -- ID НСО-домена.
                            _ref_rec_id := ( SELECT r.rec_id FROM ONLY nso.nso_record r 
                                                   WHERE (r.rec_uuid = CAST ( _mas_val [_ind] AS t_guid )) AND ( r.nso_id = _nso_id)
                            );-- Разыменование UUID-ссылки в ID
                            IF ( _ref_rec_id IS NULL ) THEN
                               RAISE SQLSTATE '90003'; -- 'Неправильное ссылочное значение, не принадлежащее НСО-ДОМЕНУ'; 
                            END IF;
              ELSE
                    _ref_rec_id := NULL;
            END IF;
            --
            INSERT INTO nso.nso_ref (
                         rec_id     
                        ,col_id     
                        ,is_actual  
                        ,ref_rec_id 
                     )
                     VALUES (
                         _rec_id
                        ,_arr_column [_ind].col_id  -- Идентификатор столбца 
                        ,p_actual
                        ,_ref_rec_id  
            );
            -- иначе значение атрибута либо BLOB либо абсолютное 
   	   ELSE
   	          IF ( _arr_column [_ind].col_stype = 'q' ) THEN -- BLOB   Создаём запись с пустым значением, потом - функция  blob_push
                     INSERT INTO nso.nso_blob (  rec_id  
                                                ,col_id   
                     ) 
                      VALUES ( _rec_id              -- Идентификатор записи     
                             , _arr_column [_ind].col_id  -- Идентификатор столбца 
                
                      );
                ELSE 
                       -- Абсолютная величина
   	              INSERT INTO nso.nso_abs (    rec_id        --       id_t                 not null,
                                                ,col_id        --       id_t                 not null,
                                                ,s_type_code   --       t_code1              not null,
                                                ,s_key_code    --       t_code1              not null,
                                                ,is_actual     --       t_boolean            not null default true,
                                                ,val_cell_abs  --       t_text            not null
                                             )
                      VALUES ( _rec_id  
                             , _arr_column [_ind].col_id    -- Идентификатор столбца 
                             , _arr_column [_ind].col_stype -- Код типа виличины
                             , _arr_column [_ind].key_stype -- Код типа ключа
                             , p_actual
                             , _mas_val [_ind]
                      );  
                END IF; -- BLOB ??    
   	   END IF; -- Ссылка ??
   	   
         _ind := _ind + 1;
   	END LOOP;-- while
   	rsp_main := ( _rec_id, c_MES000 );

--- 2016-07-13 Gregory
        IF _unique_check
        THEN
                INSERT INTO nso.nso_record_unique
                SELECT
                        nr.rec_id
                       ,nk.key_small_code
                       ,true
                FROM ONLY nso.nso_record nr JOIN ONLY nso.nso_key nk USING ( nso_id )
                WHERE ( nr.rec_id = _rec_id ) AND ( nk.key_small_code IN ( 'a', 'b', 'c', 'd' ) ); -- Nick 2016-08-17 Ошибка была.
                                                  -- nr.nso_id = _nso_id
        END IF;
---  2016-07-19 Gregory
   	
   	RETURN rsp_main;
   
   EXCEPTION
   	WHEN OTHERS  THEN 
   		BEGIN
   			rsp_main := ( -1, com.f_error_handling ( SQLSTATE, SQLERRM, с_FUNC_NAME) );
   			RETURN rsp_main;			
   		END;
   END;
$$;
COMMENT ON FUNCTION  nso.nso_p_record_i2 (public.t_guid, public.t_guid, public.t_str60, public.t_text, public.t_boolean, public.t_boolean, public.t_timestamp, public.t_timestamp) 
IS '9680/846: Создание новой строки в НСО, заносим абсолютные и ссылочные значения. Cтруктура "Ключ-Значение"
          	Входные параметры
                  1) p_rec_uuid         public.t_guid   -- Идентификатор текущей записи          not null,
                  2) p_parent_rec_uuid  public.t_guid   -- Идентификатор родительской записи          null,
                  --
               	3) p_nso_code         public.t_str60  -- Код НСО
               	4) p_val              public.t_text   -- Cтруктура "Ключ-Значение", для ссылочного значения передаём UUID.
                  -- 
                  -- По умолчанию
                  -- 
                  5) p_silent_mode      public.t_boolean     -- Режим тишины, выводятся только сообщения связанные с EXECEPTION, not null default true,
                  6) p_actual           public.t_boolean     -- Актуальность                   not null default true,
                  7) p_date_from        public.t_timestamp   -- Дата начала актуальности       not null default CURRENT_TIMESTAMP::timestamp(0) without time zone,
                  8) p_date_to          public.t_timestamp   -- Дата завершения актуальности   not null default ''9999-12-31 00:00:00''::timestamp(0) without time zone,
               
               	Выходные параметры
               				  0 - процедура завершилась успешно
               				 -1 - процедура завершилась с ошибкой
               
               	Особенности
               				При добавлении записи в структуру, содержащие ссылочные атрибуты, ссылочные значения должны являтся UUID из классификатора-родителя 
                           (загрузка по UUID, а не по значениям)
   ';

-- SELECT * FROM nso.nso_f_record_select_all('SPR_RNTD');
-- SELECT * FROM nso.nso_f_record_s(2899);
-- SELECT * FROM nso.nso_f_record_s(2900);
-- SELECT * FROM nso.nso_p_record_i2 (newid()
--       , NULL
--       , 'SPR_RNTD'
--       , 'SPR_RNTD_FC_CODE_1 => "CODE"
--         , SPR_RNTD_FC_NAME_1 => "NAME"
--         , SPR_RNTD_FC_SPR_RNTD_4 => "45dda8e1-9bfa-4d26-8181-0b78a978ba0d"'
-- );
-- -------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Примеры использования:
--     SELECT com.f_debug_on(); 
--     SELECT * FROM nso.nso_f_column_head_nso_s ( 'CL_TEST') WHERE ( attr_type_code <> 'C_DOMEN_NODE' ) ORDER BY number_col;
--
--     SELECT * FROM nso.nso_p_record_i2 ( '989ED1B4-C691-4391-B9E6-8908100EB067'::t_guid
--                                       , NULL
--                                       , 'CL_TEST'
--                                       , 'CL_TEST_FC_CODE_1 => "ТЕСТ11"
--                                         , CL_TEST_FC_NAME_2 => "Лиса Алиса и Кот Базилио"
--                                         , CL_TEST_FC_UUID_3 => "989ED1B4-C691-4391-B9E6-8908100EB067"'
-- );
--
--7398|'Выполнено успешно'
-- ---------------------------------------------------------------------------------------------------------------------
-- NOTICE:  1) <nso_p_record_i2, {"(37,1,CL_TEST_FC_CODE_1,A,0)","(38,2,CL_TEST_FC_NAME_2,B,g)","(39,3,CL_TEST_FC_UUID_3,K,d)"}, 3, "CL_TEST_FC_CODE_1"=>"ТЕСТ11", "CL_TEST_FC_NAME_2"=>"Лиса Алиса и Кот Базилио", "CL_TEST_FC_UUID_3"=>"989ED1B4-C691-4391-B9E6-8908100EB067"
-- NOTICE:  2) <nso_p_record_i2  {NULL}
---NOTICE:  3) <nso_p_record_i2  {ТЕСТ11,"Лиса Алиса и Кот Базилио",989ED1B4-C691-4391-B9E6-8908100EB067}
--
--     SELECT * FROM nso.nso_p_record_i2 ( '896A6EB6-D462-4D9A-9AB2-2B507958D0FA'::t_guid
--                                       , NULL
--                                       , 'CL_TEST'
--                                       , 'CL_TEST_FC_CODE_1 => "ТЕСТ11"
--                                        , CL_TEST_FC_UUID_3 => "896A6EB6-D462-4D9A-9AB2-2B507958D0FA"'
-- );
--
-- 7399|'Выполнено успешно'

-- SELECT * FROM nso.v_CL_TEST;
--7399||'ТЕСТ11'|''|'896a6eb6-d462-4d9a-9ab2-2b507958d0fa'|'896a6eb6-d462-4d9a-9ab2-2b507958d0fa'
-- -----------------------------------------------------------------------------------------------
--     SELECT * FROM nso.nso_p_record_u2 ( '896A6EB6-D462-4D9A-9AB2-2B507958D0FA'::t_guid
--                                       , NULL
--                                       , 'CL_TEST_FC_CODE_1 => "ТЕСТ12"
--                                        , CL_TEST_FC_UUID_2 => "Хрень ужасная"' -- Нет такого
-- );
-- 7399|'Выполнено успешно'
--
-- SELECT * FROM nso.v_CL_TEST ORDER BY 1;
--     SELECT * FROM nso.nso_p_record_u2 ( '896A6EB6-D462-4D9A-9AB2-2B507958D0FA'::t_guid
--                                       , NULL
--                                       , 'CL_TEST_FC_NAME_2 => "Хрень ужасная"'  
-- );
