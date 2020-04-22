-- --------------------------------------------------------------------------------------------------- --
--  2019-09-16 Nick. Прототип UNIT теста для функции nso_structure.nso_p_column_head_u ()              --
--   Один запуск - одно обновлённое оглавление.                                                        --
--     Вводная 1: Размер оглавления зависит от количества  использованных атрибутов, может меняться    -- 
--                как в сторону уменьшения, так и в сторону увеличения размера. НЕТ (Что у Григория ?) --
-- --------------------------------------------------------------------------------------------------- --
--     Вводная 2: Выбираем массив атрибутов, основная часть теста заключается в повторении             --  
--                 "_head_qty" раз обновления оглавления. На каждой итерации выбирается элемент        --
--                 оглавления, далее выполняется фукция обновления, обновлённый элемент исключается из --
--                 списка доступных для обновления элементов оглавления.     OK                        --
-- --------------------------------------------------------------------------------------------------- --
DO
  $$
     DECLARE
      _arr_nso_code public.t_arr_code := (SELECT array_agg (nso_code::text) FROM nso_structure.nso_f_object_s_sys() WHERE (date_create = '2011-01-01'::public.t_timestamp));
      _arr_attr_id  public.t_arr_id := (SELECT array_agg (attr_id::int8) FROM com_domain.nso_f_domain_column_s ('APP_NODE'));
      --
      _arr_head_attr_id public.t_arr_id;
      _attr_head_id     public.id_t;
      --
      _nso_code  public.t_str60;
      _attr_id   public.id_t;
      --
      _head_len  public.small_t;
      _ind       public.small_t := 1;
      _head_qty  public.small_t;
      
      C_FUNC_SIGN text := 'nso_structure.nso_p_column_head_u (public.id_t, public.id_t, public.t_str60, public.t_str250, public.small_t)';
      
      rsp_main   public.result_long_t;  
      _rec_res   RECORD;
      
     BEGIN
        PERFORM utl.f_debug_on ();
        --
        LOOP
           _nso_code := utl.f_array_random_get_element (_arr_nso_code);
           _head_len := nso_structure.nso_f_column_head_size_get (_nso_code);
            EXIT WHEN _head_len > 0; 
        END LOOP;
       
       RAISE NOTICE 'Этап 1: Выбор исходного объекта: % -- %', _nso_code, _head_len;
       --
       SELECT array_agg (a) FROM nso_structure.nso_f_column_head_nso_s (_nso_code) a WHERE (number_col > 0) INTO _rec_res;
       RAISE NOTICE 'Этап 2: Старое оглавление: %', _rec_res;
       --
       SELECT * FROM plpgsql_check_function (C_FUNC_SIGN) INTO _rec_res;
       RAISE NOTICE 'Этап 3: Проверка кода функции: %', _rec_res;

       FOR _rec_res IN SELECT * FROM plpgsql_show_dependency_tb (C_FUNC_SIGN) 
       LOOP 
             RAISE NOTICE 'Этап 4: Проверка зависимостей в коде функции: %', _rec_res;
       END LOOP;
       --
       -- Сформировать новый массив, его длина выбирается из диапазона от 2 до _head_len
       --
       _head_qty := ROUND (utl.random (2::numeric, _head_len::numeric), 0)::public.small_t;
       RAISE NOTICE 'Этап 5: Количество выполняемых обновлений: %', _head_qty;
       
       -- Выбор типа делается случайным образом.
       --
       _arr_head_attr_id := (SELECT array_agg (col_id::int8) FROM nso_structure.nso_f_column_head_nso_s (_nso_code) WHERE (number_col > 0));
       _ind := 1;
       WHILE (_ind <= _head_qty)
        LOOP
          _attr_head_id := utl.f_array_random_get_element (_arr_head_attr_id);
          _attr_id      := utl.f_array_random_get_element (_arr_attr_id);
          --
          RAISE NOTICE 'Этап 6: Массивы, элементы: % -- % -- % -- %'
                                       , _ind, _arr_head_attr_id, _attr_head_id, _attr_id;
          --
          rsp_main := nso_structure.nso_p_column_head_u
           (
              p_col_id   := _attr_head_id   -- Идентификатор колонки, всегда NOT NULL
             ,p_attr_id  := _attr_id        -- Идентификатор атрибута из домена атрибутов -- если NULL - сохраняется старое значение.
             ,p_col_code := 'U_CODE_' || (random()*10000)::public.t_str60    -- Код колонки -- если NULL - сохраняется старое значение.
             ,p_col_name := 'U_ИМЯ_' || (random()*10000)::public.t_str250    -- Имя колонки -- если NULL - сохраняется старое значение.
           ); 		    
 		   ----------------
          _ind := _ind + 1;
          
          _arr_head_attr_id := array_remove (_arr_head_attr_id::int8[], _attr_head_id::int8);
        END LOOP;
      -- ---------------------------------------
      RAISE NOTICE 'Этап 7: Выполнение: %', rsp_main;
      IF ( rsp_main.rc < 0 ) THEN
                                  RAISE EXCEPTION '%', rsp_main.errm;
      END IF;
      --
      SELECT array_agg (a) FROM nso_structure.nso_f_column_head_nso_s (_nso_code) a INTO _rec_res;
      RAISE NOTICE 'Этап 8: Результат: %', _rec_res;
      --
     END;
  $$
     LANGUAGE plpgsql;
-- ------------------------------------------------------------------------------------
-- NOTICE:  Этап 1: Выбор исходного объекта: N_CODE_9197.47962616384 -- 11
-- NOTICE:  Этап 2: Старое оглавление: ("{""(39,19,1,39,U_CODE_2542.993016541,U_ИМЯ_604.480621404946,294,I,IP_T,\\""IP адрес\\"",t,,,,,,,,1)"",""(40,19,2,51,U_CODE_3077.11279485375,U_ИМЯ_2080.44040482491,289,D,T_STR2048,\\""Строка размерностью 2048 символов\\"",t,,,,,,,,1)"",""(41,19,3,37,A_CODE_7792.94576030225,ИМЯ_3229.27274741232,278,2,T_INT,Целое,t,,,,,,,,1)"",""(42,19,4,39,A_CODE_5784.15096737444,ИМЯ_4248.13892692327,294,I,IP_T,\\""IP адрес\\"",t,,,,,,,,1)"",""(43,19,5,67,A_CODE_4845.14883253723,ИМЯ_839.954735711217,277,1,SMALL_T,\\""Короткое целое\\"",t,,,,,,,,1)"",""(44,19,7,29,A_CODE_8572.99068477005,ИМЯ_8467.7166538313,283,7,T_CODE2,\\""Код размерностью 2 символа\\"",t,,,,,,,,1)"",""(45,19,8,29,A_CODE_9721.88211511821,ИМЯ_5288.21131214499,283,7,T_CODE2,\\""Код размерностью 2 символа\\"",t,,,,,,,,1)"",""(46,19,9,23,U_CODE_4301.25526152551,U_ИМЯ_4650.32204985619,392,j,T_BIT4,\\""4-х битовая строка\\"",t,,,,,,,,1)"",""(47,19,10,41,A_CODE_6672.78110980988,ИМЯ_6934.72383078188,299,N,T_MONEY,\\""Денежная единица\\"",t,,,,,,,,1)"",""(48,19,11,59,A_CODE_1939.61209617555,ИМЯ_9503.63967567682,288,C,T_STR1024,\\""Строка размерностью 1024 символов\\"",t,,,,,,,,1)"",""(49,19,12,56,A_CODE_5122.74296954274,ИМЯ_1514.80074506253,296,K,T_GUID,UUID,t,,,,,,,,1)""}")
-- NOTICE:  Этап 3: Проверка кода функции: ()
-- NOTICE:  Этап 4: Проверка зависимостей в коде функции: (FUNCTION,18340,com_domain,nso_f_domain_column_s,"(t_str60)")
-- NOTICE:  Этап 4: Проверка зависимостей в коде функции: (FUNCTION,18349,com_error,com_f_value_check,"(t_code1,t_text)")
-- NOTICE:  Этап 4: Проверка зависимостей в коде функции: (FUNCTION,18351,com_error,f_error_handling,"(exception_type_t,t_arr_text)")
-- NOTICE:  Этап 4: Проверка зависимостей в коде функции: (FUNCTION,18394,nso,nso_p_nso_log_i,"(t_code1,t_text)")
-- NOTICE:  Этап 4: Проверка зависимостей в коде функции: (FUNCTION,58693,nso_data,nso_f_record_def_val,"(id_t)")
-- NOTICE:  Этап 4: Проверка зависимостей в коде функции: (FUNCTION,18410,nso_structure,nso_f_select_c,"(t_str60)")
-- NOTICE:  Этап 4: Проверка зависимостей в коде функции: (FUNCTION,18430,utl,f_debug_status,"()")
-- NOTICE:  Этап 4: Проверка зависимостей в коде функции: (RELATION,18492,com,nso_domain_column,)
-- NOTICE:  Этап 4: Проверка зависимостей в коде функции: (RELATION,18517,com,obj_codifier,)
-- NOTICE:  Этап 4: Проверка зависимостей в коде функции: (RELATION,18595,nso,nso_abs,)
-- NOTICE:  Этап 4: Проверка зависимостей в коде функции: (RELATION,18612,nso,nso_blob,)
-- NOTICE:  Этап 4: Проверка зависимостей в коде функции: (RELATION,18631,nso,nso_column_head,)
-- NOTICE:  Этап 4: Проверка зависимостей в коде функции: (RELATION,18658,nso,nso_key,)
-- NOTICE:  Этап 4: Проверка зависимостей в коде функции: (RELATION,18669,nso,nso_key_attr,)
-- NOTICE:  Этап 4: Проверка зависимостей в коде функции: (RELATION,18705,nso,nso_object,)
-- NOTICE:  Этап 4: Проверка зависимостей в коде функции: (RELATION,18744,nso,nso_record,)
-- NOTICE:  Этап 4: Проверка зависимостей в коде функции: (RELATION,18776,nso,nso_ref,)
-- NOTICE:  Этап 5: Количество выполняемых обновлений: 4
-- NOTICE:  Этап 6: Массивы, элементы: 1 -- {39,40,41,42,43,44,45,46,47,48,49} -- 49 -- 43
-- NOTICE:  <nso_p_column_head_u>, 49, 43, U_CODE_6650.62700398266, U_ИМЯ_7476.31567064673, <NULL>, 56, 35, N_CODE_9197.47962616384, A_CODE_5122.74296954274, 12, 19
-- NOTICE:  <nso_p_nso_log_i> A, Обновление элемента заголовка: "A_CODE_5122.74296954274".
-- NOTICE:  <nso_structure.nso_f_select_c>, WITH rr ( rec_id, parent_rec_id, rec_uuid, date_from, n_col, ref_id, n_value )
--     AS ( WITH dt (nso_id, rec_id, parent_rec_id, rec_uuid, date_from, section_sign, col_id, ns_col)
--    		  AS (
--    		     SELECT o.nso_id, r.rec_id, r.parent_rec_id, r.rec_uuid, r.date_from, r.section_sign
--    		           ,h.col_id, h.number_col
--    			   FROM ONLY nso.nso_object o 
--    			      JOIN ONLY nso.nso_column_head h ON (o.nso_id = h.nso_id) AND (h.number_col > 0)
--    			      JOIN ONLY nso.nso_record r ON (o.nso_id = r.nso_id)
--    			   WHERE(o.nso_code = 'N_CODE_9197.47962616384')
--    			) 
--    		     SELECT dt.rec_id
--    		          , dt.parent_rec_id
--                      , dt.rec_uuid
--                      , dt.date_from
--    		          , dt.ns_col
--    		          , NULL::id_t AS ref_id
--    		          , a.val_cell_abs::t_text AS ns_value
--    		     FROM dt
--    		     JOIN nso.nso_abs a ON ((a.rec_id = dt.rec_id) AND (a.col_id = dt.col_id) AND
--    		                                 (a.section_sign = dt.section_sign)
--    		                                ) 
--    		UNION
--    		     SELECT dt.rec_id
--    		          , dt.parent_rec_id
--    		          , dt.rec_uuid
--                   , dt.date_from
--    		          , dt.ns_col
--    		          , r.ref_rec_id::id_t
--    		          , nso.nso_f_record_def_val (r.ref_rec_id )::t_text AS ns_value
--    		     FROM dt
--    		     JOIN ONLY nso.nso_ref r ON (r.rec_id = dt.rec_id)	AND (r.col_id = dt.col_id)
--            UNION
--    	         SELECT dt.rec_id
--    	              , dt.parent_rec_id
--    	              , dt.rec_uuid
--                      , dt.date_from
--    	              , dt.ns_col
--    	              , NULL::id_t
--    	              , CAST (
--    	                    CASE           
--    	                        WHEN b.s_type_code = 'н' THEN 'JPG'
--    	                        WHEN b.s_type_code = 'п' THEN 'PNG'
--    	                        WHEN b.s_type_code = 'т' THEN 'BMP'
--    	                        WHEN b.s_type_code = 'у' THEN 'PDF'
--    	                        WHEN b.s_type_code = 'ф' THEN 'GIF'
--    	                        WHEN b.s_type_code = 'х' THEN 'TIFF'
--    	                        WHEN b.s_type_code = 'ц' THEN 'DOC'
--    	                        WHEN b.s_type_code = 'ч' THEN 'XLS'
--    	                        WHEN b.s_type_code = 'ш' THEN 'PPT'
--    	                        WHEN b.s_type_code = 'щ' THEN 'ODT'
--    	                        WHEN b.s_type_code = 'ъ' THEN 'ODP'
--    	                        WHEN b.s_type_code = 'ы' THEN 'ODS'
--    	                        WHEN b.s_type_code = 'ь' THEN 'ODG'
--    	                        WHEN b.s_type_code = 'э' THEN 'DOCX'
--    	                        WHEN b.s_type_code = 'ю' THEN 'XLSX'
--    	                        WHEN b.s_type_code = 'я' THEN 'PPTX'
--    	                        WHEN b.s_type_code = 'ё' THEN 'TXT'
--    	                    END || ' | ' || b.val_cel_data_name
--    	                        || ' (' || pg_size_pretty ( octet_length ( b.val_cell_blob )::bigint ) || ')'
--    	                AS t_text ) AS n_value
--    	         FROM dt
--    	         JOIN nso.nso_blob b ON ((b.rec_id = dt.rec_id) AND (b.col_id = dt.col_id) AND
--    	                                      (b.section_sign = dt.section_sign)
--    	                                     ) 
--             ) SELECT rr.rec_id, rr.parent_rec_id, CAST(MAX(CASE rr.n_col WHEN 1 THEN utl.com_f_empty_string_to_null(rr.n_value) ELSE NULL END) AS ip_t) AS u_code_2542_993016541
-- , CAST(MAX(CASE rr.n_col WHEN 2 THEN utl.com_f_empty_string_to_null(rr.n_value) ELSE NULL END) AS t_str2048) AS u_code_3077_11279485375
-- , CAST(MAX(CASE rr.n_col WHEN 3 THEN utl.com_f_empty_string_to_null(rr.n_value) ELSE NULL END) AS t_int) AS a_code_7792_94576030225
-- , CAST(MAX(CASE rr.n_col WHEN 4 THEN utl.com_f_empty_string_to_null(rr.n_value) ELSE NULL END) AS ip_t) AS a_code_5784_15096737444
-- , CAST(MAX(CASE rr.n_col WHEN 5 THEN utl.com_f_empty_string_to_null(rr.n_value) ELSE NULL END) AS small_t) AS a_code_4845_14883253723
-- , CAST(MAX(CASE rr.n_col WHEN 7 THEN utl.com_f_empty_string_to_null(rr.n_value) ELSE NULL END) AS t_code2) AS a_code_8572_99068477005
-- , CAST(MAX(CASE rr.n_col WHEN 8 THEN utl.com_f_empty_string_to_null(rr.n_value) ELSE NULL END) AS t_code2) AS a_code_9721_88211511821
-- , CAST(MAX(CASE rr.n_col WHEN 9 THEN utl.com_f_empty_string_to_null(rr.n_value) ELSE NULL END) AS t_bit4) AS u_code_4301_25526152551
-- , CAST(MAX(CASE rr.n_col WHEN 10 THEN utl.com_f_empty_string_to_null(rr.n_value) ELSE NULL END) AS t_money) AS a_code_6672_78110980988
-- , CAST(MAX(CASE rr.n_col WHEN 11 THEN utl.com_f_empty_string_to_null(rr.n_value) ELSE NULL END) AS t_str1024) AS a_code_1939_61209617555
-- , CAST(MAX(CASE rr.n_col WHEN 12 THEN utl.com_f_empty_string_to_null(rr.n_value) ELSE NULL END) AS small_t) AS u_code_6650_62700398266
-- 
-- , rr.rec_uuid, rr.date_from FROM rr GROUP BY rr.rec_id, rr.parent_rec_id, rr.rec_uuid, rr.date_from
-- NOTICE:  <nso_p_nso_log_i> 4, Обновление данных объекта: N_CODE_9197.47962616384
-- NOTICE:  Этап 6: Массивы, элементы: 2 -- {39,40,41,42,43,44,45,46,47,48} -- 42 -- 62
-- NOTICE:  <nso_p_column_head_u>, 42, 62, U_CODE_9065.70349354297, U_ИМЯ_934.453303925693, <NULL>, 39, 35, N_CODE_9197.47962616384, A_CODE_5784.15096737444, 4, 19
-- NOTICE:  <nso_p_nso_log_i> A, Обновление элемента заголовка: "A_CODE_5784.15096737444".
-- NOTICE:  <nso_structure.nso_f_select_c>, WITH rr ( rec_id, parent_rec_id, rec_uuid, date_from, n_col, ref_id, n_value )
--     AS ( WITH dt (nso_id, rec_id, parent_rec_id, rec_uuid, date_from, section_sign, col_id, ns_col)
--    		  AS (
--    		     SELECT o.nso_id, r.rec_id, r.parent_rec_id, r.rec_uuid, r.date_from, r.section_sign
--    		           ,h.col_id, h.number_col
--    			   FROM ONLY nso.nso_object o 
--    			      JOIN ONLY nso.nso_column_head h ON (o.nso_id = h.nso_id) AND (h.number_col > 0)
--    			      JOIN ONLY nso.nso_record r ON (o.nso_id = r.nso_id)
--    			   WHERE(o.nso_code = 'N_CODE_9197.47962616384')
--    			) 
--    		     SELECT dt.rec_id
--    		          , dt.parent_rec_id
--                      , dt.rec_uuid
--                      , dt.date_from
--    		          , dt.ns_col
--    		          , NULL::id_t AS ref_id
--    		          , a.val_cell_abs::t_text AS ns_value
--    		     FROM dt
--    		     JOIN nso.nso_abs a ON ((a.rec_id = dt.rec_id) AND (a.col_id = dt.col_id) AND
--    		                                 (a.section_sign = dt.section_sign)
--    		                                ) 
--    		UNION
--    		     SELECT dt.rec_id
--    		          , dt.parent_rec_id
--    		          , dt.rec_uuid
--                   , dt.date_from
--    		          , dt.ns_col
--    		          , r.ref_rec_id::id_t
--    		          , nso.nso_f_record_def_val (r.ref_rec_id )::t_text AS ns_value
--    		     FROM dt
--    		     JOIN ONLY nso.nso_ref r ON (r.rec_id = dt.rec_id)	AND (r.col_id = dt.col_id)
--            UNION
--    	         SELECT dt.rec_id
--    	              , dt.parent_rec_id
--    	              , dt.rec_uuid
--                      , dt.date_from
--    	              , dt.ns_col
--    	              , NULL::id_t
--    	              , CAST (
--    	                    CASE           
--    	                        WHEN b.s_type_code = 'н' THEN 'JPG'
--    	                        WHEN b.s_type_code = 'п' THEN 'PNG'
--    	                        WHEN b.s_type_code = 'т' THEN 'BMP'
--    	                        WHEN b.s_type_code = 'у' THEN 'PDF'
--    	                        WHEN b.s_type_code = 'ф' THEN 'GIF'
--    	                        WHEN b.s_type_code = 'х' THEN 'TIFF'
--    	                        WHEN b.s_type_code = 'ц' THEN 'DOC'
--    	                        WHEN b.s_type_code = 'ч' THEN 'XLS'
--    	                        WHEN b.s_type_code = 'ш' THEN 'PPT'
--    	                        WHEN b.s_type_code = 'щ' THEN 'ODT'
--    	                        WHEN b.s_type_code = 'ъ' THEN 'ODP'
--    	                        WHEN b.s_type_code = 'ы' THEN 'ODS'
--    	                        WHEN b.s_type_code = 'ь' THEN 'ODG'
--    	                        WHEN b.s_type_code = 'э' THEN 'DOCX'
--    	                        WHEN b.s_type_code = 'ю' THEN 'XLSX'
--    	                        WHEN b.s_type_code = 'я' THEN 'PPTX'
--    	                        WHEN b.s_type_code = 'ё' THEN 'TXT'
--    	                    END || ' | ' || b.val_cel_data_name
--    	                        || ' (' || pg_size_pretty ( octet_length ( b.val_cell_blob )::bigint ) || ')'
--    	                AS t_text ) AS n_value
--    	         FROM dt
--    	         JOIN nso.nso_blob b ON ((b.rec_id = dt.rec_id) AND (b.col_id = dt.col_id) AND
--    	                                      (b.section_sign = dt.section_sign)
--    	                                     ) 
--             ) SELECT rr.rec_id, rr.parent_rec_id, CAST(MAX(CASE rr.n_col WHEN 1 THEN utl.com_f_empty_string_to_null(rr.n_value) ELSE NULL END) AS ip_t) AS u_code_2542_993016541
-- , CAST(MAX(CASE rr.n_col WHEN 2 THEN utl.com_f_empty_string_to_null(rr.n_value) ELSE NULL END) AS t_str2048) AS u_code_3077_11279485375
-- , CAST(MAX(CASE rr.n_col WHEN 3 THEN utl.com_f_empty_string_to_null(rr.n_value) ELSE NULL END) AS t_int) AS a_code_7792_94576030225
-- , CAST(MAX (CASE rr.n_col WHEN 4 THEN rr.ref_id ELSE NULL END) AS id_t) AS u_code_9065_70349354297_ref_id
-- , CAST(MAX(CASE rr.n_col WHEN 4 THEN utl.com_f_empty_string_to_null(rr.n_value) ELSE NULL END) AS t_text) AS u_code_9065_70349354297
-- , CAST(MAX(CASE rr.n_col WHEN 5 THEN utl.com_f_empty_string_to_null(rr.n_value) ELSE NULL END) AS small_t) AS a_code_4845_14883253723
-- , CAST(MAX(CASE rr.n_col WHEN 7 THEN utl.com_f_empty_string_to_null(rr.n_value) ELSE NULL END) AS t_code2) AS a_code_8572_99068477005
-- , CAST(MAX(CASE rr.n_col WHEN 8 THEN utl.com_f_empty_string_to_null(rr.n_value) ELSE NULL END) AS t_code2) AS a_code_9721_88211511821
-- , CAST(MAX(CASE rr.n_col WHEN 9 THEN utl.com_f_empty_string_to_null(rr.n_value) ELSE NULL END) AS t_bit4) AS u_code_4301_25526152551
-- , CAST(MAX(CASE rr.n_col WHEN 10 THEN utl.com_f_empty_string_to_null(rr.n_value) ELSE NULL END) AS t_money) AS a_code_6672_78110980988
-- , CAST(MAX(CASE rr.n_col WHEN 11 THEN utl.com_f_empty_string_to_null(rr.n_value) ELSE NULL END) AS t_str1024) AS a_code_1939_61209617555
-- , CAST(MAX(CASE rr.n_col WHEN 12 THEN utl.com_f_empty_string_to_null(rr.n_value) ELSE NULL END) AS small_t) AS u_code_6650_62700398266
-- 
-- , rr.rec_uuid, rr.date_from FROM rr GROUP BY rr.rec_id, rr.parent_rec_id, rr.rec_uuid, rr.date_from
-- NOTICE:  <nso_p_nso_log_i> 4, Обновление данных объекта: N_CODE_9197.47962616384
-- NOTICE:  Этап 6: Массивы, элементы: 3 -- {39,40,41,43,44,45,46,47,48} -- 47 -- 74
-- NOTICE:  <nso_p_column_head_u>, 47, 74, U_CODE_8831.97546936572, U_ИМЯ_5545.40313780308, <NULL>, 41, 35, N_CODE_9197.47962616384, A_CODE_6672.78110980988, 10, 19
-- NOTICE:  <nso_p_nso_log_i> A, Обновление элемента заголовка: "A_CODE_6672.78110980988".
-- NOTICE:  <nso_structure.nso_f_select_c>, WITH rr ( rec_id, parent_rec_id, rec_uuid, date_from, n_col, ref_id, n_value )
--     AS ( WITH dt (nso_id, rec_id, parent_rec_id, rec_uuid, date_from, section_sign, col_id, ns_col)
--    		  AS (
--    		     SELECT o.nso_id, r.rec_id, r.parent_rec_id, r.rec_uuid, r.date_from, r.section_sign
--    		           ,h.col_id, h.number_col
--    			   FROM ONLY nso.nso_object o 
--    			      JOIN ONLY nso.nso_column_head h ON (o.nso_id = h.nso_id) AND (h.number_col > 0)
--    			      JOIN ONLY nso.nso_record r ON (o.nso_id = r.nso_id)
--    			   WHERE(o.nso_code = 'N_CODE_9197.47962616384')
--    			) 
--    		     SELECT dt.rec_id
--    		          , dt.parent_rec_id
--                      , dt.rec_uuid
--                      , dt.date_from
--    		          , dt.ns_col
--    		          , NULL::id_t AS ref_id
--    		          , a.val_cell_abs::t_text AS ns_value
--    		     FROM dt
--    		     JOIN nso.nso_abs a ON ((a.rec_id = dt.rec_id) AND (a.col_id = dt.col_id) AND
--    		                                 (a.section_sign = dt.section_sign)
--    		                                ) 
--    		UNION
--    		     SELECT dt.rec_id
--    		          , dt.parent_rec_id
--    		          , dt.rec_uuid
--                   , dt.date_from
--    		          , dt.ns_col
--    		          , r.ref_rec_id::id_t
--    		          , nso.nso_f_record_def_val (r.ref_rec_id )::t_text AS ns_value
--    		     FROM dt
--    		     JOIN ONLY nso.nso_ref r ON (r.rec_id = dt.rec_id)	AND (r.col_id = dt.col_id)
--            UNION
--    	         SELECT dt.rec_id
--    	              , dt.parent_rec_id
--    	              , dt.rec_uuid
--                      , dt.date_from
--    	              , dt.ns_col
--    	              , NULL::id_t
--    	              , CAST (
--    	                    CASE           
--    	                        WHEN b.s_type_code = 'н' THEN 'JPG'
--    	                        WHEN b.s_type_code = 'п' THEN 'PNG'
--    	                        WHEN b.s_type_code = 'т' THEN 'BMP'
--    	                        WHEN b.s_type_code = 'у' THEN 'PDF'
--    	                        WHEN b.s_type_code = 'ф' THEN 'GIF'
--    	                        WHEN b.s_type_code = 'х' THEN 'TIFF'
--    	                        WHEN b.s_type_code = 'ц' THEN 'DOC'
--    	                        WHEN b.s_type_code = 'ч' THEN 'XLS'
--    	                        WHEN b.s_type_code = 'ш' THEN 'PPT'
--    	                        WHEN b.s_type_code = 'щ' THEN 'ODT'
--    	                        WHEN b.s_type_code = 'ъ' THEN 'ODP'
--    	                        WHEN b.s_type_code = 'ы' THEN 'ODS'
--    	                        WHEN b.s_type_code = 'ь' THEN 'ODG'
--    	                        WHEN b.s_type_code = 'э' THEN 'DOCX'
--    	                        WHEN b.s_type_code = 'ю' THEN 'XLSX'
--    	                        WHEN b.s_type_code = 'я' THEN 'PPTX'
--    	                        WHEN b.s_type_code = 'ё' THEN 'TXT'
--    	                    END || ' | ' || b.val_cel_data_name
--    	                        || ' (' || pg_size_pretty ( octet_length ( b.val_cell_blob )::bigint ) || ')'
--    	                AS t_text ) AS n_value
--    	         FROM dt
--    	         JOIN nso.nso_blob b ON ((b.rec_id = dt.rec_id) AND (b.col_id = dt.col_id) AND
--    	                                      (b.section_sign = dt.section_sign)
--    	                                     ) 
--             ) SELECT rr.rec_id, rr.parent_rec_id, CAST(MAX(CASE rr.n_col WHEN 1 THEN utl.com_f_empty_string_to_null(rr.n_value) ELSE NULL END) AS ip_t) AS u_code_2542_993016541
-- , CAST(MAX(CASE rr.n_col WHEN 2 THEN utl.com_f_empty_string_to_null(rr.n_value) ELSE NULL END) AS t_str2048) AS u_code_3077_11279485375
-- , CAST(MAX(CASE rr.n_col WHEN 3 THEN utl.com_f_empty_string_to_null(rr.n_value) ELSE NULL END) AS t_int) AS a_code_7792_94576030225
-- , CAST(MAX (CASE rr.n_col WHEN 4 THEN rr.ref_id ELSE NULL END) AS id_t) AS u_code_9065_70349354297_ref_id
-- , CAST(MAX(CASE rr.n_col WHEN 4 THEN utl.com_f_empty_string_to_null(rr.n_value) ELSE NULL END) AS t_text) AS u_code_9065_70349354297
-- , CAST(MAX(CASE rr.n_col WHEN 5 THEN utl.com_f_empty_string_to_null(rr.n_value) ELSE NULL END) AS small_t) AS a_code_4845_14883253723
-- , CAST(MAX(CASE rr.n_col WHEN 7 THEN utl.com_f_empty_string_to_null(rr.n_value) ELSE NULL END) AS t_code2) AS a_code_8572_99068477005
-- , CAST(MAX(CASE rr.n_col WHEN 8 THEN utl.com_f_empty_string_to_null(rr.n_value) ELSE NULL END) AS t_code2) AS a_code_9721_88211511821
-- , CAST(MAX(CASE rr.n_col WHEN 9 THEN utl.com_f_empty_string_to_null(rr.n_value) ELSE NULL END) AS t_bit4) AS u_code_4301_25526152551
-- , CAST(MAX (CASE rr.n_col WHEN 10 THEN rr.ref_id ELSE NULL END) AS id_t) AS u_code_8831_97546936572_ref_id
-- , CAST(MAX(CASE rr.n_col WHEN 10 THEN utl.com_f_empty_string_to_null(rr.n_value) ELSE NULL END) AS t_text) AS u_code_8831_97546936572
-- , CAST(MAX(CASE rr.n_col WHEN 11 THEN utl.com_f_empty_string_to_null(rr.n_value) ELSE NULL END) AS t_str1024) AS a_code_1939_61209617555
-- , CAST(MAX(CASE rr.n_col WHEN 12 THEN utl.com_f_empty_string_to_null(rr.n_value) ELSE NULL END) AS small_t) AS u_code_6650_62700398266
-- 
-- , rr.rec_uuid, rr.date_from FROM rr GROUP BY rr.rec_id, rr.parent_rec_id, rr.rec_uuid, rr.date_from
-- NOTICE:  <nso_p_nso_log_i> 4, Обновление данных объекта: N_CODE_9197.47962616384
-- NOTICE:  Этап 6: Массивы, элементы: 4 -- {39,40,41,43,44,45,46,48} -- 39 -- 70
-- NOTICE:  <nso_p_column_head_u>, 39, 70, U_CODE_2482.12012462318, U_ИМЯ_5539.67517800629, <NULL>, 39, 35, N_CODE_9197.47962616384, U_CODE_2542.993016541, 1, 19
-- NOTICE:  <nso_p_nso_log_i> A, Обновление элемента заголовка: "U_CODE_2542.993016541".
-- NOTICE:  <nso_structure.nso_f_select_c>, WITH rr ( rec_id, parent_rec_id, rec_uuid, date_from, n_col, ref_id, n_value )
--     AS ( WITH dt (nso_id, rec_id, parent_rec_id, rec_uuid, date_from, section_sign, col_id, ns_col)
--    		  AS (
--    		     SELECT o.nso_id, r.rec_id, r.parent_rec_id, r.rec_uuid, r.date_from, r.section_sign
--    		           ,h.col_id, h.number_col
--    			   FROM ONLY nso.nso_object o 
--    			      JOIN ONLY nso.nso_column_head h ON (o.nso_id = h.nso_id) AND (h.number_col > 0)
--    			      JOIN ONLY nso.nso_record r ON (o.nso_id = r.nso_id)
--    			   WHERE(o.nso_code = 'N_CODE_9197.47962616384')
--    			) 
--    		     SELECT dt.rec_id
--    		          , dt.parent_rec_id
--                      , dt.rec_uuid
--                      , dt.date_from
--    		          , dt.ns_col
--    		          , NULL::id_t AS ref_id
--    		          , a.val_cell_abs::t_text AS ns_value
--    		     FROM dt
--    		     JOIN nso.nso_abs a ON ((a.rec_id = dt.rec_id) AND (a.col_id = dt.col_id) AND
--    		                                 (a.section_sign = dt.section_sign)
--    		                                ) 
--    		UNION
--    		     SELECT dt.rec_id
--    		          , dt.parent_rec_id
--    		          , dt.rec_uuid
--                   , dt.date_from
--    		          , dt.ns_col
--    		          , r.ref_rec_id::id_t
--    		          , nso.nso_f_record_def_val (r.ref_rec_id )::t_text AS ns_value
--    		     FROM dt
--    		     JOIN ONLY nso.nso_ref r ON (r.rec_id = dt.rec_id)	AND (r.col_id = dt.col_id)
--            UNION
--    	         SELECT dt.rec_id
--    	              , dt.parent_rec_id
--    	              , dt.rec_uuid
--                      , dt.date_from
--    	              , dt.ns_col
--    	              , NULL::id_t
--    	              , CAST (
--    	                    CASE           
--    	                        WHEN b.s_type_code = 'н' THEN 'JPG'
--    	                        WHEN b.s_type_code = 'п' THEN 'PNG'
--    	                        WHEN b.s_type_code = 'т' THEN 'BMP'
--    	                        WHEN b.s_type_code = 'у' THEN 'PDF'
--    	                        WHEN b.s_type_code = 'ф' THEN 'GIF'
--    	                        WHEN b.s_type_code = 'х' THEN 'TIFF'
--    	                        WHEN b.s_type_code = 'ц' THEN 'DOC'
--    	                        WHEN b.s_type_code = 'ч' THEN 'XLS'
--    	                        WHEN b.s_type_code = 'ш' THEN 'PPT'
--    	                        WHEN b.s_type_code = 'щ' THEN 'ODT'
--    	                        WHEN b.s_type_code = 'ъ' THEN 'ODP'
--    	                        WHEN b.s_type_code = 'ы' THEN 'ODS'
--    	                        WHEN b.s_type_code = 'ь' THEN 'ODG'
--    	                        WHEN b.s_type_code = 'э' THEN 'DOCX'
--    	                        WHEN b.s_type_code = 'ю' THEN 'XLSX'
--    	                        WHEN b.s_type_code = 'я' THEN 'PPTX'
--    	                        WHEN b.s_type_code = 'ё' THEN 'TXT'
--    	                    END || ' | ' || b.val_cel_data_name
--    	                        || ' (' || pg_size_pretty ( octet_length ( b.val_cell_blob )::bigint ) || ')'
--    	                AS t_text ) AS n_value
--    	         FROM dt
--    	         JOIN nso.nso_blob b ON ((b.rec_id = dt.rec_id) AND (b.col_id = dt.col_id) AND
--    	                                      (b.section_sign = dt.section_sign)
--    	                                     ) 
--             ) SELECT rr.rec_id, rr.parent_rec_id, CAST(MAX(CASE rr.n_col WHEN 1 THEN utl.com_f_empty_string_to_null(rr.n_value) ELSE NULL END) AS t_phone_nmb) AS u_code_2482_12012462318
-- , CAST(MAX(CASE rr.n_col WHEN 2 THEN utl.com_f_empty_string_to_null(rr.n_value) ELSE NULL END) AS t_str2048) AS u_code_3077_11279485375
-- , CAST(MAX(CASE rr.n_col WHEN 3 THEN utl.com_f_empty_string_to_null(rr.n_value) ELSE NULL END) AS t_int) AS a_code_7792_94576030225
-- , CAST(MAX (CASE rr.n_col WHEN 4 THEN rr.ref_id ELSE NULL END) AS id_t) AS u_code_9065_70349354297_ref_id
-- , CAST(MAX(CASE rr.n_col WHEN 4 THEN utl.com_f_empty_string_to_null(rr.n_value) ELSE NULL END) AS t_text) AS u_code_9065_70349354297
-- , CAST(MAX(CASE rr.n_col WHEN 5 THEN utl.com_f_empty_string_to_null(rr.n_value) ELSE NULL END) AS small_t) AS a_code_4845_14883253723
-- , CAST(MAX(CASE rr.n_col WHEN 7 THEN utl.com_f_empty_string_to_null(rr.n_value) ELSE NULL END) AS t_code2) AS a_code_8572_99068477005
-- , CAST(MAX(CASE rr.n_col WHEN 8 THEN utl.com_f_empty_string_to_null(rr.n_value) ELSE NULL END) AS t_code2) AS a_code_9721_88211511821
-- , CAST(MAX(CASE rr.n_col WHEN 9 THEN utl.com_f_empty_string_to_null(rr.n_value) ELSE NULL END) AS t_bit4) AS u_code_4301_25526152551
-- , CAST(MAX (CASE rr.n_col WHEN 10 THEN rr.ref_id ELSE NULL END) AS id_t) AS u_code_8831_97546936572_ref_id
-- , CAST(MAX(CASE rr.n_col WHEN 10 THEN utl.com_f_empty_string_to_null(rr.n_value) ELSE NULL END) AS t_text) AS u_code_8831_97546936572
-- , CAST(MAX(CASE rr.n_col WHEN 11 THEN utl.com_f_empty_string_to_null(rr.n_value) ELSE NULL END) AS t_str1024) AS a_code_1939_61209617555
-- , CAST(MAX(CASE rr.n_col WHEN 12 THEN utl.com_f_empty_string_to_null(rr.n_value) ELSE NULL END) AS small_t) AS u_code_6650_62700398266
-- 
-- , rr.rec_uuid, rr.date_from FROM rr GROUP BY rr.rec_id, rr.parent_rec_id, rr.rec_uuid, rr.date_from
-- NOTICE:  <nso_p_nso_log_i> 4, Обновление данных объекта: N_CODE_9197.47962616384
-- NOTICE:  Этап 7: Выполнение: (0,"Успешно обновлен элемент заголовка.")
-- NOTICE:  Этап 8: Результат: ("{""(19,,0,83,D_N_CODE_9197.47962616384,\\""Заголовок - N_CODE_9197.47962616384\\"",7,U,C_DOMEN_NODE,\\""Узловой Атрибут\\"",f,,,,,,,,0)"",""(39,19,1,70,U_CODE_2482.12012462318,U_ИМЯ_5539.67517800629,302,S,T_PHONE_NMB,\\""Номер телефона\\"",t,,,,,,,,1)"",""(40,19,2,51,U_CODE_3077.11279485375,U_ИМЯ_2080.44040482491,289,D,T_STR2048,\\""Строка размерностью 2048 символов\\"",t,,,,,,,,1)"",""(41,19,3,37,A_CODE_7792.94576030225,ИМЯ_3229.27274741232,278,2,T_INT,Целое,t,,,,,,,,1)"",""(42,19,4,62,U_CODE_9065.70349354297,U_ИМЯ_934.453303925693,303,T,T_REF,\\""Атрибут-ссылка на НСО\\"",t,,,,,,,,1)"",""(43,19,5,67,A_CODE_4845.14883253723,ИМЯ_839.954735711217,277,1,SMALL_T,\\""Короткое целое\\"",t,,,,,,,,1)"",""(44,19,7,29,A_CODE_8572.99068477005,ИМЯ_8467.7166538313,283,7,T_CODE2,\\""Код размерностью 2 символа\\"",t,,,,,,,,1)"",""(45,19,8,29,A_CODE_9721.88211511821,ИМЯ_5288.21131214499,283,7,T_CODE2,\\""Код размерностью 2 символа\\"",t,,,,,,,,1)"",""(46,19,9,23,U_CODE_4301.25526152551,U_ИМЯ_4650.32204985619,392,j,T_BIT4,\\""4-х битовая строка\\"",t,,,,,,,,1)"",""(47,19,10,74,U_CODE_8831.97546936572,U_ИМЯ_5545.40313780308,303,T,T_REF,\\""Атрибут-ссылка на НСО\\"",t,,,,,,,,1)"",""(48,19,11,59,A_CODE_1939.61209617555,ИМЯ_9503.63967567682,288,C,T_STR1024,\\""Строка размерностью 1024 символов\\"",t,,,,,,,,1)"",""(49,19,12,43,U_CODE_6650.62700398266,U_ИМЯ_7476.31567064673,277,1,SMALL_T,\\""Короткое целое\\"",t,,,,,,,,1)""}")
-- 
-- Query returned successfully with no result in 468 msec.

-- 
-- Query returned successfully with no result in 577 msec.
--
-- SELECT * FROM nso_structure.nso_f_column_head_nso_s ('N_CODE_9197.47962616384');
-- SELECT * FROM nso.nso_f_nso_log_s();
-- 1814|'postgres'|'192.168.56.1/32'|'A'|'Oбновление элемента заголовка (заменили один на другой) КОНТРОЛЬ ТИПОВ'|'2019-09-17 15:05:02'
-- ------------------------------------------------------------------------------------------------------------------------------------
-- Ошибка в LOG пишется запись только о первом обновлении оглавления.
--   SELECT array_agg(a) FROM nso_structure.nso_f_column_head_nso_s ('N_CODE_9197.47962616384') a;
