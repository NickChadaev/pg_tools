/* ----------------------------------------------------------------------------------------
	Входные параметры:
		p_nso_code  t_str60  --Код НСО
	Выходные параметры:
		При успешном завершении функции строка содержащая конструкцию SELECT.
      При неуспешном завершении строка содержащая  текст сообщения об ошибке и начинающаяся
      со слова ОШИБКА:
   ----------------------------------------------------------------------------------------
	Особенности: 
   ----------------------------------------------------------------------------=----------- */
DROP FUNCTION IF EXISTS nso_structure.nso_f_select_c ( public.t_str60 );
CREATE OR REPLACE FUNCTION nso_structure.nso_f_select_c (p_nso_code public.t_str60)
	RETURNS public.t_text AS
$$
    -- ================================================================================================= 
    -- Author: Gregory
    -- Create date: 2015-05-25
    -- Description:	Функция формирует запрос для использования в
    --        nso.nso_p_view_c (p_nso_code t_str60, t_boolean, t_sysname)
    --        Результат помещается в nso.nso_object.nso_select.
    --        Например:	UPDATE nso.nso_object
    --        SET nso_select = nso.nso_f_select_c(p_nso_code)
    --        WHERE nso_code = p_nso_code.
    -- -------------------------------------------------------------------------------------------------
    --  2015-06-25 - добавлена обработка ошибок. Nick
    --  2015-06-04 вставил алиас r в конструкции 
    --                IF EXISTS(SELECT 1 FROM nso.nso_ref r WHERE (r.col_id = _attr.col_id ))
    -- потому, что она находится внутри блока FOR _attr IN SELECT ... LOOP в котором так-же 
    -- используется имя "col_id". Это может привести к ошибкам.  Для читаемости сгенерированного 
    -- текста вставил E'\n'.   
    -- ---------------------
    -- 2015_09_20 Nick все обращениия к nso.nso_object только с опцией ONLY
    -- 2015-09-21 Gregory BLOB val_cel_data_name
    -- 2016-10-17 Gregory Исправлен HardCode 
    -- 2017-11-12 Gregory a.val_cell_abs -> com.com_f_empty_string_to_null(a.val_cell_abs)
    -- 2016-11-12 Nick, Абсолютное значение типа t_text (t_arr_values -> t_arr_text, t_str2048 -> t_text) 
    -- 2017-11-20 Gregory: ref_id  в выходном наборе.
    -- 2017-12-13 Nick Добавлена дата начала актуальности.
    -- 2018-04-12 Nick com.com_f_empty_string_to_null(rr.n_value) -- Защита от пустой строки.
    -- --------------------------------------------------------------------------------------------------
    -- 2019-07-18 Nick  Новое ядро, убран блок EXCEPTION. Убраны ONLY для nso_abs, nso_blob.
    --                  Добавлен атрибут xx.section_sign в первую и третью части UNION.
    --                  Необходимо для выбора соответствующей секции.
    -- ================================================================================================== 
 DECLARE
	_result_string  public.t_text  := ''; -- Конструкция SELECT
	_nso_code       public.t_str60 :=  utl.com_f_empty_string_to_null (upper(btrim(p_nso_code)));
	
	_attr RECORD; -- Запись с данными атрибута
	C_DEBUG         public.t_boolean := utl.f_debug_status(); -- Флаг вывода промежуточных значений
	               -- 2019-07-18 Nick
   
 BEGIN
   -- Проверка входных значений  -- Nick 2019-07-18
   IF p_nso_code IS NULL
   THEN
       RETURN NULL;
   END IF;
   
   IF NOT EXISTS (SELECT 1 FROM ONLY nso.nso_object WHERE nso_code = _nso_code)
   THEN
       RETURN NULL;
   END IF;                        -- Nick 2019-07-18
   
   -- 1 --
   _result_string := 'WITH rr ( rec_id, parent_rec_id, rec_uuid, date_from, n_col, ref_id, n_value )
    AS ( WITH dt (nso_id, rec_id, parent_rec_id, rec_uuid, date_from, section_sign, col_id, ns_col)
   		  AS (
   		     SELECT o.nso_id, r.rec_id, r.parent_rec_id, r.rec_uuid, r.date_from, r.section_sign
   		           ,h.col_id, h.number_col
   			   FROM ONLY nso.nso_object o 
   			      JOIN ONLY nso.nso_column_head h ON (o.nso_id = h.nso_id) AND (h.number_col > 0)
   			      JOIN ONLY nso.nso_record r ON (o.nso_id = r.nso_id)
   			   WHERE(o.nso_code = ''' || _nso_code || ''')
   			) 
   		     SELECT dt.rec_id
   		          , dt.parent_rec_id
                     , dt.rec_uuid
                     , dt.date_from
   		          , dt.ns_col
   		          , NULL::id_t AS ref_id
   		          , a.val_cell_abs::t_text AS ns_value
   		     FROM dt
   		     JOIN nso.nso_abs a ON ((a.rec_id = dt.rec_id) AND (a.col_id = dt.col_id) AND
   		                                 (a.section_sign = dt.section_sign)
   		                                ) 
   		UNION
   		     SELECT dt.rec_id
   		          , dt.parent_rec_id
   		          , dt.rec_uuid
                  , dt.date_from
   		          , dt.ns_col
   		          , r.ref_rec_id::id_t
   		          , nso.nso_f_record_def_val (r.ref_rec_id )::t_text AS ns_value
   		     FROM dt
   		     JOIN ONLY nso.nso_ref r ON (r.rec_id = dt.rec_id)	AND (r.col_id = dt.col_id)
           UNION
   	         SELECT dt.rec_id
   	              , dt.parent_rec_id
   	              , dt.rec_uuid
                     , dt.date_from
   	              , dt.ns_col
   	              , NULL::id_t
   	              , CAST (
   	                    CASE           
   	                        WHEN b.s_type_code = ''н'' THEN ''JPG''
   	                        WHEN b.s_type_code = ''п'' THEN ''PNG''
   	                        WHEN b.s_type_code = ''т'' THEN ''BMP''
   	                        WHEN b.s_type_code = ''у'' THEN ''PDF''
   	                        WHEN b.s_type_code = ''ф'' THEN ''GIF''
   	                        WHEN b.s_type_code = ''х'' THEN ''TIFF''
   	                        WHEN b.s_type_code = ''ц'' THEN ''DOC''
   	                        WHEN b.s_type_code = ''ч'' THEN ''XLS''
   	                        WHEN b.s_type_code = ''ш'' THEN ''PPT''
   	                        WHEN b.s_type_code = ''щ'' THEN ''ODT''
   	                        WHEN b.s_type_code = ''ъ'' THEN ''ODP''
   	                        WHEN b.s_type_code = ''ы'' THEN ''ODS''
   	                        WHEN b.s_type_code = ''ь'' THEN ''ODG''
   	                        WHEN b.s_type_code = ''э'' THEN ''DOCX''
   	                        WHEN b.s_type_code = ''ю'' THEN ''XLSX''
   	                        WHEN b.s_type_code = ''я'' THEN ''PPTX''
   	                        WHEN b.s_type_code = ''ё'' THEN ''TXT''
   	                    END || '' | '' || b.val_cel_data_name
   	                        || '' ('' || pg_size_pretty ( octet_length ( b.val_cell_blob )::bigint ) || '')''
   	                AS t_text ) AS n_value
   	         FROM dt
   	         JOIN nso.nso_blob b ON ((b.rec_id = dt.rec_id) AND (b.col_id = dt.col_id) AND
   	                                      (b.section_sign = dt.section_sign)
   	                                     ) 
            )';

-- WHEN b.s_type_code = ''э'' THEN ''ODC''
-- WHEN b.s_type_code = ''ю'' THEN ''ODB''
-- WHEN b.s_type_code = ''я'' THEN ''ODF''

	-- 2 --			
	_result_string := _result_string || ' SELECT rr.rec_id, rr.parent_rec_id';
		
	FOR _attr IN
		SELECT col_id, number_col, attr_code, attr_type_code 
		      FROM nso_structure.nso_f_column_head_nso_s (_nso_code) WHERE (number_col != 0) ORDER BY number_col
	LOOP
        IF lower (_attr.attr_type_code) = 't_ref'
        THEN
             _result_string := _result_string || 
                        ', CAST(MAX (CASE rr.n_col WHEN ' || _attr.number_col ||
                        ' THEN rr.ref_id ELSE NULL END) AS id_t) AS ' ||
                        lower (replace (_attr.attr_code, '.', '_')) || '_ref_id'|| E'\n';
        END IF;
	
		_result_string := _result_string ||
			', CAST(MAX(CASE rr.n_col WHEN ' || _attr.number_col || ' THEN utl.com_f_empty_string_to_null(rr.n_value) ELSE NULL END) AS '; -- Nick 2018-04-12
      -- -------------------------------------------------------------
      -- Nick 2015-07-04 nso.nso_f_record_def_val возвращает /*t_str2048*/ -- 2016-11-12 t_text
      -- -------------------------------------------------------------
		IF lower (_attr.attr_type_code) = 't_ref'
      -- -------------------------------------------------------------
      -- Gregory 2015-09-21 val_cel_data_name t_fullname < t_str2048
      -- -------------------------------------------------------------
           OR lower (_attr.attr_type_code) = 't_blob'
        THEN
             _result_string := _result_string || 't_text';
         ELSE
             _result_string := _result_string || lower(_attr.attr_type_code);
        END IF;
		_result_string := _result_string || ') AS ' || lower (replace (_attr.attr_code, '.', '_')) || E'\n';
	END LOOP;

    _result_string := _result_string || E'\n' ||
	', rr.rec_uuid, rr.date_from FROM rr GROUP BY rr.rec_id, rr.parent_rec_id, rr.rec_uuid, rr.date_from';

    IF C_DEBUG
       THEN
           RAISE NOTICE '<nso_structure.nso_f_select_c>, %', _result_string;
    END IF;
	
	RETURN _result_string;
 END;
$$
  LANGUAGE plpgsql 
  SECURITY DEFINER; -- Nick 2016-02-26

COMMENT ON FUNCTION nso_structure.nso_f_select_c (public.t_str60) IS '179: Создание оператора SELECT
         Аргументы:
         	1)  p_nso_code   public.t_str60     -- Код НСО
         Выходные данные:
         	1)  _result  public.t_text   -- Возвращаемая строка
         	         При успешном завершении функции строка содержит конструкцию SELECT.
                         При неуспешном завершении строка содержит NULL
';
-- --------------------------------------------------------------------------------------------------
-- SELECT * FROM plpgsql_check_function_tb ('nso_structure.nso_f_select_c (public.t_str60)');
-- 'nso_f_select_c'|126|'FOR over SELECT rows'|'42883'|'function nso.nso_f_column_head_nso_s(t_str60) does not exist'|''|'No function matches the given name and argument types. You might need to add explicit type casts.'
--
-- SELECT * FROM plpgsql_check_function_tb ('nso_structure.nso_f_select_c (public.t_str60)', security_warnings := true, fatal_errors := false);
-- --------------------------------------------------------------------------------------------------------------------------------------------
-- 'nso_f_select_c'|126|'FOR over SELECT rows'|'42883'|'function nso.nso_f_column_head_nso_s(t_str60) does not exist'
-- 'nso_f_select_c'|130|'IF'                  |'55000'|'record "_attr" is not assigned yet'
-- 'nso_f_select_c'|132|'assignment'          |'55000'|'record "_attr" is not assigned yet'
-- 'nso_f_select_c'|138|'assignment'          |'55000'|'record "_attr" is not assigned yet'
-- 'nso_f_select_c'|143|'IF'                  |'55000'|'record "_attr" is not assigned yet'
-- 'nso_f_select_c'|151|'assignment'          |'55000'|'record "_attr" is not assigned yet'
-- 'nso_f_select_c'|153|'assignment'          |'55000'|'record "_attr" is not assigned yet'
-- 'nso_f_select_c'| 36|'DECLARE'             |'00000'|'never read variable "_attr"'
-- 'nso_f_select_c'| 37|'DECLARE'             |'00000'|'never read variable "c_debug"'
--
--  По причине отсутствия функции, на вызове которой организуется цикл !!!.

 
-- SELECT nso.nso_f_select_c('SPR_OKEI');
-- SELECT nso.nso_f_select_c('SPR_EMPLOYE'); -- 'ОШИБКА: Неправильно указан код НСО-владельца. Ошибка произошла в функции: "nso_f_select_c (t_str60)".'
-- SELECT nso.nso_f_select_c(NULL);           -- 'ОШИБКА: Все параметры явялются обязательными, NULL значения запрещены. Ошибка произошла в функции: "nso_f_select_c (t_str60)".'
/*
-- Nick 2015-06-04
UPDATE nso.nso_object SET nso_select = nso.nso_f_select_c ('CL_TEST') WHERE (nso_code = 'CL_TEST');
UPDATE nso.nso_object SET nso_select = nso.nso_f_select_c ('KL_SECR') WHERE (nso_code = 'KL_SECR');
UPDATE nso.nso_object SET nso_select = nso.nso_f_select_c ('SPR_EX_ENTERPRISE') WHERE (nso_code = 'SPR_EX_ENTERPRISE');
UPDATE nso.nso_object SET nso_select = nso.nso_f_select_c ('SPR_EMPLOYE') WHERE (nso_code = 'SPR_EMPLOYE');
UPDATE nso.nso_object SET nso_select = nso.nso_f_select_c ('THC_OKEI') WHERE (nso_code = 'THC_OKEI');
UPDATE nso.nso_object SET nso_select = nso.nso_f_select_c ('SPR_OKEI') WHERE (nso_code = 'SPR_OKEI');

*/

-- SELECT nso.nso_p_view_c('SPR_BLOB');

-- UPDATE ONLY nso.nso_object SET nso_select = nso.nso_f_select_c ('SPR_BLOB') WHERE (nso_code = 'SPR_BLOB');
-- SELECT * FROM nso_log ORDER BY 5 DESC;
-- SELECT nso.nso_p_view_c ('SPR_BLOB', true)
-- SELECT * FROM nso.v_spr_blob
