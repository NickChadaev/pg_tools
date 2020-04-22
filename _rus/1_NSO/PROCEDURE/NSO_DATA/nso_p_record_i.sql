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
-- ====================================================================================
-- 2015-06-11 Nick. Добавил BLOB, пока заглушка.
-- 2015-06-16 Nick. Заглушку "открыл".
-- 2015-07-06 Nick. Доработки, связанные с введением "режима тишины" и контроля ссылочных значений.
-- 2015-10-06 Nick. Ссылка может быть NULL
-- 2016-07-13 Gregory. Контроль уникальности.
-- 2016-08-17 Nick  Пропущенная ошибка возникающая при контроле уникальности.
-- 2016-11-12 Nick  Абсолютное значение типа t_text (t_arr_values -> t_arr_text, t_str2048 -> t_text) 
-- 2018-01-16 Nick  Обратно: t_arr_text -> t_arr_values
/* --------------------------------------------------------------------------------------------------------------------------------------------------
	Входные параметры

   p_rec_uuid             t_guid       -- Идентификатор текущей записи          not null,
   p_parent_rec_uuid      t_guid       -- Идентификатор родительской записи          null,
   --
	p_nso_code             t_str60      --  Код НСО
	p_mas_val              t_arr_values -- Массив значений для ячеек, при отсутствии данных необходимо передать null, для ссылочного значения передаём UUID.
   -- 
   -- По умолчанию
   -- 
   p_silent_mode          t_boolean     -- Режим тишины, выводятся только сообщения связанные с EXECEPTION, not null default true,
   p_actual               t_boolean     -- Актуальность                   not null default true,
   p_date_from            t_timestamp   -- Дата начала актуальности       not null default CURRENT_TIMESTAMP::timestamp(0) without time zone,
   p_date_to              t_timestamp   -- Дата завершения актуальности   not null default '9999-12-31 00:00:00'::timestamp(0) without time zone,

	Выходные параметры
				  0 - процедура завершилась успешно
				 -1 - процедура завершилась с ошибкой

	Особенности
				При добавлении записи в структуру, содержащие ссылочные атрибуты, ссылочные значения должны являтся UUID из классификатора-родителя 
            (загрузка по UUID, а не по значениям)

--------------------------------------------------------------------------------------------------------------------------------------------------*/
SET search_path = nso,com,public;

-- DROP FUNCTION IF EXISTS nso.nso_p_record_i ( t_guid, t_guid, t_str60, t_arr_text, t_boolean, t_timestamp, t_timestamp);
-- DROP FUNCTION IF EXISTS nso.nso_p_record_i ( t_guid, t_guid, t_str60, t_arr_values, t_boolean, t_boolean, t_timestamp, t_timestamp);

CREATE OR REPLACE FUNCTION nso.nso_p_record_i (
    p_rec_uuid         t_guid       -- Идентификатор текущей записи          not null,
   ,p_parent_rec_uuid  t_guid       -- Идентификатор родительской записи          null,
    --
	,p_nso_code         t_str60      -- Код НСО
	,p_mas_val          t_arr_values -- Массив значений для ячеек, при отсутствии данных необходимо передать null, для ссылочного значения передаём UUID.
    -- 
    -- По умолчанию
    -- 
   ,p_silent_mode   t_boolean   = TRUE -- Режим тишины, выводятся только сообщения связанные с EXECEPTION 
   ,p_actual        t_boolean   = TRUE                                                   -- Актуальность                   
   ,p_date_from     t_timestamp = CURRENT_TIMESTAMP::timestamp(0) without time zone      -- Дата начала актуальности       
   ,p_date_to       t_timestamp = '9999-12-31 00:00:00'::timestamp(0) without time zone  -- Дата завершения актуальности   
)
  RETURNS  result_t 
      SECURITY DEFINER  
      LANGUAGE plpgsql 
  AS
$$
   DECLARE 
     с_FUNC_NAME        t_sysname  := 'nso_p_record_i (t_guid,t_guid,t_str60,t_arr_values,t_boolean,t_boolean,t_timestamp,t_timestamp)'; --имя процедуры
     c_DOMAIN_NODE      t_str60    := 'C_DOMEN_NODE';
     c_NSO_REC_SEQ_NAME t_sysname  := 'nso.nso_record_rec_id_seq';
     c_MES000           t_str1024  := 'Выполнено успешно'; 
     -- 
     _nso_id        public.id_t; 
     _rec_id        public.id_t; 
     _parent_rec_id public.id_t; -- Nick 2017-09-25
     _ref_rec_id    public.id_t;
     _arr_column    public.column_t[];
     --
     rsp_main result_t;
     _rsp     result_t;
     --
     _len_p_mas_val      t_int;
     _len_arr_type_code  t_int;
     _ind                t_int := 1;   
     
     _nso_code  public.t_str60 := upper (btrim (p_nso_code));  -- Nick 2017-09-25      

     _unique_check       t_boolean; -- 2016-07-19 Gregory
   BEGIN
    -- =================================================================================
    --  1. Начальная установка
      _nso_id := ( SELECT nso_id FROM ONLY nso.nso_object WHERE ( nso_code = upper (btrim (p_nso_code))));
      _unique_check := ( SELECT unique_check FROM ONLY nso.nso_object WHERE nso_id = _nso_id);
      _arr_column := ARRAY ( SELECT ROW ( col_id
                                        , attr_type_scode
                                        , CASE 
                                             WHEN key_type_scode IS NULL THEN '0'
                                             ELSE
                                                  key_type_scode
                                          END       
                             ) 
                              FROM nso.nso_f_column_head_nso_s ( _nso_code )
                                                   WHERE ( attr_type_code <> c_DOMAIN_NODE ) ORDER BY number_col
      );
      -- 
      _len_p_mas_val     := array_length ( p_mas_val, 1);
      _len_arr_type_code := array_length (_arr_column, 1);

   -- ==================================================================================
   -- 2. Проверяем добавляемые данные 
   --	   + 2.1 на сооветствие количества данных в строке, количеству атрибутов НСО.
   --    + 2.2 на соответствие типу данных
   --    - 2.3 на уникальность по ключевым атрибутам, используя функцию NSO_F_Value_Check
   -- ==================================================================================
   	IF ( _len_p_mas_val = _len_arr_type_code ) THEN 			
   			WHILE ( _ind <= _len_arr_type_code ) LOOP 
                     _rsp := com.com_f_value_check ( _arr_column [_ind].col_stype, p_mas_val [_ind] );
                     IF ( _rsp.rc = -1 ) THEN
                           RAISE EXCEPTION '%', _rsp.errm ; -- Ошибка преобразования типа
                     END IF;
                     IF ( NOT p_silent_mode ) THEN
                                    RAISE NOTICE '%', _rsp.errm;
                     END IF;
                     _ind := _ind + 1;
            END LOOP;
   	ELSE 
   			RAISE SQLSTATE '63017'; --  'Количество атрибутов не соответствует структуре заголовка';
            -- Не здорово, надо доработать
   	END IF;
   -- ============================================
   --	3. Добавляем данные
   -- ============================================
      -- Nick 2017-09-25
      _parent_rec_id := NULL;
      IF ( p_parent_rec_uuid IS NOT NULL) 
      THEN
           IF nso.nso_f_record_is_valid ( _nso_code, p_parent_rec_uuid ) 
           THEN
              _parent_rec_id := nso.nso_f_record_get_id ( p_parent_rec_uuid );
           ELSE
               RAISE 'Родительский UUID "%", не принадлежит справочнику "%"', p_parent_rec_uuid, _nso_code;
           END IF;
      END IF;
      -- Nick 2017-09-25

   	INSERT INTO nso.nso_record (   parent_rec_id
                                    ,rec_uuid     
                                    ,nso_id       
                                    ,actual       
                                    ,date_from    
                                    ,date_to      
                                  ) 
      VALUES (
               _parent_rec_id -- Nick 2017-09-25
              ,p_rec_uuid   
              ,_nso_id       -- Более не нужен, далее использую для контроля ссылочного значения.     
              ,p_actual     
              ,p_date_from  
              ,p_date_to    
      );
      _rec_id := CURRVAL ( c_NSO_REC_SEQ_NAME );

      _ind := 1;
   	WHILE ( _ind <= _len_p_mas_val ) LOOP   
         IF ( _arr_column [_ind].col_stype = 'T' ) THEN -- Ссылка
            IF ( p_mas_val [_ind] IS NOT NULL ) THEN -- Nick 2015-10-06
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
                                                   WHERE (r.rec_uuid = CAST ( p_mas_val [_ind] AS t_guid )) AND ( r.nso_id = _nso_id)
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
                                                ,val_cell_abs  --       t_str2048            not null
                                             )
                      VALUES ( _rec_id  
                             , _arr_column [_ind].col_id    -- Идентификатор столбца 
                             , _arr_column [_ind].col_stype -- Код типа виличины
                             , _arr_column [_ind].key_stype -- Код типа ключа
                             , p_actual
                             , p_mas_val [_ind]
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
COMMENT ON FUNCTION  nso.nso_p_record_i ( t_guid, t_guid, t_str60, t_arr_values, t_boolean, t_boolean, t_timestamp, t_timestamp ) 
IS '8224/690: Создание новой строки в НСО, заносим абсолютные и ссылочные значения
          	Входные параметры
                  1) p_rec_uuid             t_guid       -- Идентификатор текущей записи          not null,
                  2) p_parent_rec_uuid      t_guid       -- Идентификатор родительской записи          null,
                  --
               	3) p_nso_code             t_str60      -- Код НСО
               	4) p_mas_val              t_arr_values   -- Массив значений для ячеек, при отсутствии данных необходимо передать null, для ссылочного значения передаём UUID.
                  -- 
                  -- По умолчанию
                  -- 
                  5) p_silent_mode          t_boolean     -- Режим тишины, выводятся только сообщения связанные с EXECEPTION, not null default true,
                  6) p_actual               t_boolean     -- Актуальность                   not null default true,
                  7) p_date_from            t_timestamp   -- Дата начала актуальности       not null default CURRENT_TIMESTAMP::timestamp(0) without time zone,
                  8) p_date_to              t_timestamp   -- Дата завершения актуальности   not null default ''9999-12-31 00:00:00''::timestamp(0) without time zone,
               
               	Выходные параметры
               				  0 - процедура завершилась успешно
               				 -1 - процедура завершилась с ошибкой
               
               	Особенности
               				При добавлении записи в структуру, содержащие ссылочные атрибуты, ссылочные значения должны являтся UUID из классификатора-родителя 
                           (загрузка по UUID, а не по значениям)
   ';

-- SELECT * FROM nso.nso_object WHERE nso_code = 'CL_TEST'
-- SELECT * FROM nso.nso_p_record_i ( '211DA7AB-5800-489A-A742-D0045CA202A7'::t_guid, NULL, 'CL_TEST', ARRAY ['ТЕСТ2', 'Лига защиты прав бродячих собак', '211DA7AB-5800-489A-A742-D0045CA202A6']);
-- 32537;'Выполнено успешно'
-- -------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Примеры использования:
--     SELECT * FROM nso.nso_f_column_head_nso_s ( 'CL_TEST') WHERE ( attr_type_code <> 'C_DOMEN_NODE' ) ORDER BY number_col;
--     SELECT * FROM nso.nso_p_record_i ( '211DA7AB-5800-489A-A742-D0045CA202A6'::t_guid, NULL, 'CL_TEST', ARRAY ['ТЕСТ1', 'Лига защиты прав бродячих собак', '211DA7AB-5800-489A-A742-D0045CA202A6']);
--     SELECT * FROM nso.nso_p_record_i ( '211DA7AB-5800-489A-A742-D0045CA202A6'::t_guid, NULL, 'CL_TEST', ARRAY ['ТЕСТ1', 'Лига защиты прав бродячих собак', '211DA7AB-5800-489A-A742-D0045CA202A6']);
--     'Ошибку: "duplicate key value violates unique constraint "ak1_nso_record"" с кодом: "23505" необходимо добавить в таблицу по обработки ошибок для функции:  nso_p_object_i. Ошибка произошла в функции: "nso_p_object_i".'
--     ------------------------------------------
--     SELECT * FROM nso.nso_p_record_i ( 'D172E867-AD76-498B-9634-DD0F4C583C7F'::t_guid, NULL, 'CL_TEST', ARRAY ['ТЕСТ2', 'Мытищинский филиал Московской ассоциации уличных девиц', 'D172E867-AD76-498B-9634-DD0F4C583C7F']);
--     SELECT * FROM nso.nso_p_record_i ( '50730E34-2A32-40E0-8035-46EA9A2693D9'::t_guid, NULL, 'CL_TEST', ARRAY ['ТЕСТ3', 'Всероссийский институт карманной тяги', '50730E34-2A32-40E0-8035-46EA9A2693D9']);
--     SELECT * FROM nso.nso_p_record_i ( 'C32F2057-C741-4E8E-931C-E1B1C6DAF615'::t_guid, NULL, 'CL_TEST', ARRAY ['ТЕСТ4', 'Научно-Исследовательский Институт Химических Удобрений и Ядов', 'C32F2057-C741-4E8E-931C-E1B1C6DAF615']);
--     SELECT * FROM nso.nso_p_record_i ( 'D543955B-2D07-490F-B09F-50D796B517E6'::t_guid, NULL, 'CL_TEST', ARRAY ['ТЕСТ5', 'Лиса Алиса и Кот Базилио', 'D543955B-2D07-490F-B09F-50D796B517E6']);
--     SELECT * FROM nso.nso_p_record_i ( 'A5DF7E8A-26EC-4F64-B363-247B90010751'::t_guid, NULL, 'CL_TEST', ARRAY ['ТЕСТ6', 'Баба Яга', 'A5DF7E8A-26EC-4F64-B363-247B90010751'], false);
--     SELECT * FROM nso.nso_p_record_i ( '0F51DCF0-7B99-4A9E-BBE1-565BBF209E47'::t_guid, NULL, 'CL_TEST', ARRAY ['ТЕСТ7', 'Шайтан-Арба', '0F51DCF0-7B99-4A9E-BBE1-565BBF209E47'], false);
--     SELECT * FROM nso.nso_p_record_i ( '0F51DCF0-7B99-4A9E-BBE1-565BBF209E47'::t_guid, NULL, 'CL_TEST', ARRAY ['ТЕСТ7', 'AS', 'Шайтан-Арба', '0F51DCF0-7B99-4A9E-BBE1-565BBF209E47'], false);

--     SELECT * FROM nso.nso_record;
--     SELECT * FROM nso.nso_abs; 
--     SELECT newid(); -- 

-- select * from nso.nso_object where nso_id =119
-- select * from nso.NSO_P_Record_D (1476179, true);
--

-- SELECT ROW ( col_id, attr_type_scode, CASE
--                                              WHEN key_type_scode IS NULL THEN '0'
--                                              ELSE
--                                                   key_type_scode
--                                       END       
-- ) 
--  FROM nso.nso_f_column_head_nso_s ('SPR_EMPLOYE') WHERE ( attr_type_code <> 'C_DOMEN_NODE' )    ORDER BY number_col
-- --
-- SELECT * FROM nso.nso_key;
-- SELECT * FROM nso.nso_key_attr WHERE ( key_id IN ( 13, 15));
-- DELETE FROM nso.nso_key_attr WHERE ( key_id IN ( 13, 15));
