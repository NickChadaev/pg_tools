-- --------------------------------------------------------------------------------------------------- --
--  2019-09-18 Nick. Прототип UNIT теста для функции nso_structure.nso_p_column_head_d ()              --
--   Один запуск - один удалённый атрибут, одно обновлённое оглавление.                                --
-- --------------------------------------------------------------------------------------------------- --
--   Выбираем массив атрибутов, основная часть теста заключается в удаления элемента оглавления.       --  
--                 Выбирается элемент оглавления, далее выполняется функция удаления.                  --
-- --------------------------------------------------------------------------------------------------- --
DO
  $$
     DECLARE
      _arr_nso_code public.t_arr_code := (SELECT array_agg (nso_code::text) FROM nso_structure.nso_f_object_s_sys() WHERE (date_create = '2011-01-01'::public.t_timestamp));
       --
     _arr_head_number_col public.t_arr_nmb;
       --
      _nso_code  public.t_str60;
      _attr_nmb  public.small_t;
       --
      _head_len  public.small_t;
      
      C_FUNC_SIGN text := 'nso_structure.nso_p_column_head_d (public.t_str60, public.small_t)';
      
      rsp_main   public.result_long_t;  
      _rec_res   RECORD;
      
     BEGIN
      PERFORM utl.f_debug_on ();
      --
      LOOP
        _nso_code := utl.f_array_random_get_element (_arr_nso_code);
        _arr_head_number_col := (SELECT array_agg (number_col::int2) FROM nso_structure.nso_f_column_head_nso_s (_nso_code) a WHERE (number_col > 0));
        _attr_nmb := utl.f_array_random_get_element (_arr_head_number_col);
        _head_len := nso_structure.nso_f_column_head_size_get (_nso_code);
         EXIT WHEN _head_len > 0; 
      END LOOP;
      
      RAISE NOTICE 'Этап 1: Выбор исходного объекта: % -- % -- %', _nso_code, _head_len, _attr_nmb;
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
      rsp_main := nso_structure.nso_p_column_head_d (_nso_code, _attr_nmb);
      -- -------------------------------------------------------------------
      RAISE NOTICE 'Этап 5: Выполнение: %', rsp_main;
      IF ( rsp_main.rc < 0 ) THEN
                                  RAISE EXCEPTION '%', rsp_main.errm;
      END IF;
      --
      SELECT array_agg (a) FROM nso_structure.nso_f_column_head_nso_s (_nso_code) a INTO _rec_res;
      RAISE NOTICE 'Этап 6: Результат: %', _rec_res;
      --
     END;
  $$
     LANGUAGE plpgsql;
-- ------------------------------------------------------------------------------------
-- NOTICE:  Этап 1: Выбор исходного объекта: N_CODE_365.252592600882_ХРЕНЬ_++9784.85577274114 -- 2 -- 2
-- NOTICE:  Этап 2: Старое оглавление: ("{""(37,24,1,60,A_CODE_5185.90887077153,ИМЯ_6112.30916343629,288,C,T_STR1024,\\""Строка размерностью 1024 символов\\"",t,,,,,,,,1)"",""(38,24,2,31,A_CODE_6733.96073281765,ИМЯ_838.589826598763,293,H,T_DATE,Дата,t,,,,,,,,1)""}")
-- NOTICE:  Этап 3: Проверка кода функции: ()
-- NOTICE:  Этап 4: Проверка зависимостей в коде функции: (FUNCTION,18351,com_error,f_error_handling,"(exception_type_t,t_arr_text)")
-- NOTICE:  Этап 4: Проверка зависимостей в коде функции: (FUNCTION,18394,nso,nso_p_nso_log_i,"(t_code1,t_text)")
-- NOTICE:  Этап 4: Проверка зависимостей в коде функции: (FUNCTION,18410,nso_structure,nso_f_select_c,"(t_str60)")
-- NOTICE:  Этап 4: Проверка зависимостей в коде функции: (FUNCTION,18423,utl,com_f_empty_string_to_null,"(t_text)")
-- NOTICE:  Этап 4: Проверка зависимостей в коде функции: (FUNCTION,18430,utl,f_debug_status,"()")
-- NOTICE:  Этап 4: Проверка зависимостей в коде функции: (RELATION,18595,nso,nso_abs,)
-- NOTICE:  Этап 4: Проверка зависимостей в коде функции: (RELATION,18612,nso,nso_blob,)
-- NOTICE:  Этап 4: Проверка зависимостей в коде функции: (RELATION,18631,nso,nso_column_head,)
-- NOTICE:  Этап 4: Проверка зависимостей в коде функции: (RELATION,18658,nso,nso_key,)
-- NOTICE:  Этап 4: Проверка зависимостей в коде функции: (RELATION,18669,nso,nso_key_attr,)
-- NOTICE:  Этап 4: Проверка зависимостей в коде функции: (RELATION,18705,nso,nso_object,)
-- NOTICE:  Этап 4: Проверка зависимостей в коде функции: (RELATION,18744,nso,nso_record,)
-- NOTICE:  Этап 4: Проверка зависимостей в коде функции: (RELATION,18776,nso,nso_ref,)
-- NOTICE:  <nso_p_column_head_d>, N_CODE_365.252592600882_ХРЕНЬ_++9784.85577274114, 2, 40, 38, A_CODE_6733.96073281765
-- NOTICE:  <nso_p_nso_log_i> B, Удаление элемента заголовка: "A_CODE_6733.96073281765". ДАННЫЕ ПРОПАЛИ.
-- NOTICE:  <nso_p_column_head_d>, <NULL>
-- NOTICE:  <nso_structure.nso_f_select_c>, WITH rr ( rec_id, parent_rec_id, rec_uuid, date_from, n_col, ref_id, n_value )
--     AS ( WITH dt (nso_id, rec_id, parent_rec_id, rec_uuid, date_from, section_sign, col_id, ns_col)
--    		  AS (
--    		     SELECT o.nso_id, r.rec_id, r.parent_rec_id, r.rec_uuid, r.date_from, r.section_sign
--    		           ,h.col_id, h.number_col
--    			   FROM ONLY nso.nso_object o 
--    			      JOIN ONLY nso.nso_column_head h ON (o.nso_id = h.nso_id) AND (h.number_col > 0)
--    			      JOIN ONLY nso.nso_record r ON (o.nso_id = r.nso_id)
--    			   WHERE(o.nso_code = 'N_CODE_365.252592600882_ХРЕНЬ_++9784.85577274114')
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
--             ) SELECT rr.rec_id, rr.parent_rec_id, CAST(MAX(CASE rr.n_col WHEN 1 THEN utl.com_f_empty_string_to_null(rr.n_value) ELSE NULL END) AS t_str1024) AS a_code_5185_90887077153
-- 
-- , rr.rec_uuid, rr.date_from FROM rr GROUP BY rr.rec_id, rr.parent_rec_id, rr.rec_uuid, rr.date_from
-- NOTICE:  <nso_p_nso_log_i> 4, Обновление данных объекта: N_CODE_365.252592600882_ХРЕНЬ_++9784.85577274114
-- NOTICE:  Этап 5: Выполнение: (38,"Успешно удален элемента заголовка ""A_CODE_6733.96073281765"", НСО ""N_CODE_365.252592600882_ХРЕНЬ_++9784.85577274114"".")
-- NOTICE:  Этап 6: Результат: ("{""(24,,0,88,D_N_CODE_365.252592600882_ХРЕНЬ_++9784.85577274114,\\""Заголовок - ИМЯ_36.7417838424444\\"",7,U,C_DOMEN_NODE,\\""Узловой Атрибут\\"",f,,,,,,,,0)"",""(37,24,1,60,A_CODE_5185.90887077153,ИМЯ_6112.30916343629,288,C,T_STR1024,\\""Строка размерностью 1024 символов\\"",t,,,,,,,,1)""}")
-- 
-- Query returned successfully with no result in 288 msec.
--
-- SELECT * FROM nso.nso_f_nso_log_s();
