/* --------------------------------------------------------------------------------------------------------------------
	Входные параметры:
		 p_nso_code	t_str60		-- Код НСО
		,p_view_type	t_boolean	-- Тип представления(true - материализованное, false - обычное),
							по умолчанию false 
		,p_sch_name	t_sysname	-- Имя схемы, по умолчанию 'nso'
	Выходные параметры:	
		при успешном завершении:
                        rsp_main.rc   = <0>
                        rsp_main.errm = <Сообщение о успешности завершения>
		при неуспешном завершении:
			rsp_main.rc   = <-1>
			rsp_main.errm = <Сообщение о ошибке> 
-----------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------- */
DROP FUNCTION IF EXISTS nso_structure.nso_p_view_c ( public.t_str60, public.t_boolean, public.t_sysname);
CREATE OR REPLACE FUNCTION nso_structure.nso_p_view_c(
             	p_nso_code  public.t_str60, -- Код НСО
             	p_view_type public.t_boolean DEFAULT FALSE,  -- Тип представления(true - материализованное, false - обычное), по умолчанию false 
             	p_sch_name  public.t_sysname DEFAULT 'nso'::public.t_sysname  -- Имя схемы, по умолчанию 'nso'	
)
  RETURNS public.result_long_t 
  SET search_path = nso, nso_structure, nso_data, utl, public, pg_catalog
AS
 $$
   -- ==========================================================================================--
   -- Author: Gregory                                                                           --
   -- Create date: 2015-05-25                                                                   --
   -- Description:	Конструктор представлений.                                                   --
   -- ----------------------------------------------------------------------------------------- --
   --  Особенности: Функция использует заранее подготовленный запрос nso.nso_object.nso_select  --
   --  	формируемый функцией nso_structure.nso_f_select_c(p_nso_code public.t_str60)         --
   --  	и добавленый с помощью                                                               --
   --  		UPDATE ONLY nso.nso_object SET nso_select = nso.nso_f_select_c (_nso_code)       --
   --  		WHERE (nso_code = p_nso_code);                                                   --
   -- ----------------------------------------------------------------------------------------- --
   -- Modification: 2015_09_20 Nick все обращениия к no.nso_object только с опцией ONLY         --
   -- ----------------------------------------------------------------------------------------- --
   -- Modification: 2015-09-25 Gregory правила для нематериализованного представления           --
   -- ----------------------------------------------------------------------------------------- --
   -- 2015-10-14 Исправления ревизия 846   Gregory                                              --
   -- ----------------------------------------------------------------------------------------- --
   -- 2016-09-12 Gregory исправления, недостающие lower btrim                                   --
   -- ----------------------------------------------------------------------------------------- --
   -- 2017-10-09 Nick Исключаем дублирование столбцов при назначении обного и того-же           --
   --  атрибута различным меткам.                                                               --
   -- ----------------------------------------------------------------------------------------- --
   -- 2017-10-13 Nick Модификация от "2017-10-09" вызвала наружение отношения порядка           --
   -- в выходном наборе, DISTINCT нарушил порядока, сделанные внутри функции.                   --
   -- Делаем нормальный режим отладки, далее причёсываем тест.                                  --
   -- ----------------------------------------------------------------------------------------- --
   -- 2017-12-13 Nick Исправлено формирование имён атрибутов, добавлена дата начала             --
   --                 актуальности.                                                             --
   -- ----------------------------------------------------------------------------------------- --
   -- 2017-12-13 Gregory перевод на функции nso_p_record_i2(), nso_p_record_u2()                --
   -- ----------------------------------------------------------------------------------------- --
   -- 2018-04-11 Nick.  Rev. 8816/809                                                           --
   --                 SELECT COALESCE(delete(hstore(d), n.list), hstore(d))::t_text             --
   -- ----------------------------------------------------------------------------------------- --
   -- 2018-06-28 Nick Logging, раздача прав сразу после создания представления. Права           --
   --  раздаются на основе списка ролей, возвращаемого функцией auth.auth_f_role_s();           --
   -- ----------------------------------------------------------------------------------------- --
   -- 2018-09-03 Nick Проблема заключается в том, что в правилах для UPDATE,                    --
   --     В конструкторе табличных значений VALUES(), для ссылочных атрибутов в случае          --
   --     (NEW.<value> = OLD.<value>) нужно ставить разъименованные ссылки с исполь-            --
   --     зованием функции nso.nso_f_record_get_uuid (). Только в этом случае при обновлении    --
   --     можно указывать не все атрибуты.                                                      --
   -- ----------------------------------------------------------------------------------------- --
   -- 2019-07-19 Nick Новое ядро.                                                               --
   -- ========================================================================================= --
   DECLARE
     _nso_code public.t_str60   := utl.com_f_empty_string_to_null (upper(btrim (p_nso_code)));
     _sch_name public.t_sysname := utl.com_f_empty_string_to_null (lower(btrim (p_sch_name)));
 
   	_view_name public.t_sysname := 'v_'::public.t_sysname ; -- Составное имя представления(с префиксом по-умолчанию)
   	_exec_str  public.t_description; -- Команда для EXECUTE
   	_comments  public.t_description; -- Коментарии к представлению
   	_rules     public.t_description; -- 2015-09-25 Gregory правила к нематериализованному представлению
 
    _attr          RECORD; -- Запись с данными атрибута для формирования списка колонок
    _attr_part_ref text;   -- Часть имени атрибута, используется для ссылок.
    _attr_part     text;   -- Просто часть имени атрибута.
 
    C_DEBUG t_boolean := utl.f_debug_status(); -- Флаг вывода промежуточных значений  
   
   	-- Переменные для обработки ошибок
   	rsp_main  public.result_long_t; -- Структура, хранящая код успешости завершения и сообщение об ошибке.
    -- 
    --  Nick 2018-06-28
    _role_name   public.t_sysname;
    _impact_type public.t_code1;
    --  Nick 2018-06-28
 
    c_ERR_FUNС_NAME public.t_sysname := 'nso_p_view_c'; -- Имя функции в которой произошла ошибка.
    c_TREF          public.t_str60   := 'T_REF';                   -- Nick 2016-11-20
    c_HOST          public.t_sysname := 'host'::public.t_sysname;  -- Nick 2018-06-28
    --
    _rules_a   public.t_text; -- 2018-09-03 Nick правила, имена для INSERT, UPDATE
    _rules_i   public.t_text; --                          значения для INSERT 
    _rules_u   public.t_text; --                          значения для UPDATE
    --
    _exception  public.exception_type_t;
    _err_args   public.t_arr_text := ARRAY ['']; 
 
   BEGIN
   	-- Проверка входных значений
   	IF _nso_code IS NULL
   	THEN
   		RAISE SQLSTATE '60000'; -- NULL значения запрещены
   	END IF;
       
   	IF NOT EXISTS ( SELECT 1 FROM ONLY nso.nso_object WHERE nso_code = _nso_code)
   	THEN
        _err_args [1] := _nso_code;
        RAISE SQLSTATE '62020'; -- Нет такого НСО
   	END IF;
   
   	IF NOT EXISTS (SELECT 1 FROM pg_catalog.pg_namespace WHERE lower (nspname) = _sch_name)
   	THEN
   	        _err_args [1] := _sch_name;
   		     RAISE SQLSTATE '60004'; -- Нет такой схемы !!! 
   	END IF;
   
   	IF (( SELECT nso_select FROM ONLY nso.nso_object WHERE nso_code = _nso_code) IS NULL)
   	THEN
        _err_args [1] := _nso_code;
         RAISE SQLSTATE '62021'; -- Запись не найдена (Нет SELECT запроса) !!! Объект не активен.
   	END IF;
   
   	-- Генерация имени представления
   	_view_name := _view_name || _nso_code;
   	IF C_DEBUG THEN 
        RAISE NOTICE '<%>, Point 0. _view_name = %, sch_name = %', c_ERR_FUNС_NAME, _view_name, _sch_name;
   	END IF;
    --  ---------------
    --  Nick 2015-10-13
   	--  ------------------------------------------------------------------------------------------
   	IF EXISTS (SELECT 1 FROM db_info.f_show_tbv_descr ( _sch_name, 'v') WHERE ( obj_name =  lower(_view_name))) 
   	THEN
   		_exec_str := 'DROP VIEW IF EXISTS ';
   	ELSE 
   	    IF EXISTS (SELECT 1 FROM db_info.f_show_tbv_descr ( _sch_name, 'm') WHERE ( obj_name = lower(_view_name)))  
   	      THEN
   		  _exec_str := 'DROP MATERIALIZED VIEW IF EXISTS ';	
               ELSE
   		  _exec_str := NULL;
             END IF;	  		
   	END IF;
      --
   	-- Генерация полного имени представления
   	_view_name := _sch_name || '.' || _view_name;
   
   	-- Вывод имени представления в историю
   	IF C_DEBUG THEN 
         RAISE NOTICE '<%>, Point 1. _view_name = %, _exec_str = %', c_ERR_FUNС_NAME, _view_name, _exec_str;
   	END IF;
   
   	-- Формирование команды и удаление представления
   	IF _exec_str IS NOT NULL
   	THEN
   		-- Формирование команды
   		_exec_str := _exec_str || _view_name;
   
   		-- Вывод команды в историю
   		IF C_DEBUG THEN 
           RAISE NOTICE '<%>, Point 2. _exec_str = %', c_ERR_FUNС_NAME, _exec_str;
   		END IF;
   
   		-- Удаление представления
   		EXECUTE _exec_str::text;
   	END IF;
   
   	-- Формирование коментариев представления
   	_comments :=
   		_view_name || ' IS ''' || (SELECT nso_name FROM ONLY nso.nso_object WHERE nso_code = _nso_code)::text || ''';';
   	IF p_view_type
   	THEN
   		_comments := 'COMMENT ON MATERIALIZED VIEW ' || _comments;
   	ELSE
   		_comments := 'COMMENT ON VIEW ' || 	_comments;
   	END IF;
   
   	-- Формирование коментариев для атрибутов таблицы nso_record(rec_id, parent_rec_id, rec_uuid)
   	_comments :=
   		_comments ||
     		' COMMENT ON COLUMN ' || _view_name || '.rec_id IS ''Идентификатор записи'';' ||
     		' COMMENT ON COLUMN ' || _view_name || '.parent_rec_id IS ''Идентификатор родительской записи'';' ||
     		' COMMENT ON COLUMN ' || _view_name || '.rec_uuid IS ''UUID записи'';' ||
     		' COMMENT ON COLUMN ' || _view_name || '.date_from IS ''Дата начала актуальности'';';
   
   	-- Формирование
   	_exec_str := 'rec_id, parent_rec_id';
    _rules   := '';
    _rules_a := 'WITH data (';
    _rules_i := 'VALUES (';
    _rules_u := 'VALUES (';
 
   	FOR _attr IN
          		SELECT DISTINCT number_col, attr_code, attr_name, attr_type_code  -- Nick 2017-10-09
          		FROM nso_structure.nso_f_column_head_nso_s (_nso_code) WHERE number_col != 0 ORDER BY number_col
   	LOOP
            -- Nick 2018-09-08 Правило для UPDATE
            IF upper (_attr.attr_type_code) = c_TREF  -- Nick 2016-11-20 дополнительные атрибуты представления.
            THEN
               _attr_part     := lower (btrim (REPLACE (_attr.attr_code, '.', '_')));
               _attr_part_ref := _attr_part || '_ref_id';
               _exec_str  :=  _exec_str || ', ' || _attr_part_ref;
               _comments  :=  _comments || ' COMMENT ON COLUMN ' || _view_name || '.' || _attr_part_ref ||
                      ' IS ''' || _attr.attr_name || '(ссылка)' || ''';';
               --
               -- Nick 2018-09-07
               --
               _rules_u := _rules_u || 'CASE WHEN (OLD.' || _attr_part || ' = NEW.' || _attr_part || ') ' || 
                  ' THEN nso_f_record_get_uuid (OLD.' || _attr_part_ref || ')::varchar ' ||
                  ' ELSE NEW.' || _attr_part || '::varchar ' || 
                'END::varchar, ';
             ELSE
                  _attr_part := lower (btrim (REPLACE (_attr.attr_code, '.', '_')));
                  _rules_u := _rules_u || 'NEW.' ||  _attr_part || '::varchar, ';
            END IF;
 
            -- Правило для INSERT. Список имен колонок
            _attr_part := lower ( btrim ( REPLACE (_attr.attr_code, '.', '_')));
            _rules_a := _rules_a || '"' || upper (_attr_part) || '", '; -- Nick 2018-09-03
            _rules_i := _rules_i || 'NEW.' ||  _attr_part || '::varchar, ';
 
            _exec_str := _exec_str || ', ' || _attr_part;
            _comments := _comments || ' COMMENT ON COLUMN ' || _view_name || '.' || _attr_part || ' IS ''' || _attr.attr_name || ''';';
            
 --           -- 2015-09-25 Gregory формирование правил для нематериализованного представления
 --           _rules := _rules || _attr_part || ', ';
      -- Nick 2017-12-13 Забытое
   	END LOOP;
 
    _rules_a := btrim (_rules_a, ', ') || ') AS (';
    _rules_i := btrim (_rules_i, ', ') || ')) SELECT hstore (data.*)::public.t_text AS hstore FROM data)) AS nso_p_record_i2;';
    _rules_u := btrim (_rules_u, ', ') || ')) SELECT hstore (data.*)::public.t_text AS hstore FROM data)) AS nso_p_record_u2;';
 
    IF C_DEBUG THEN
             RAISE NOTICE '<%>, Point_3. _exec_str = %', c_ERR_FUNС_NAME, _exec_str;
             RAISE NOTICE '<%>, Point_4. _rules = %',    c_ERR_FUNС_NAME, _rules;
             RAISE NOTICE '<%>, Point_5. _rules_a = %',  c_ERR_FUNС_NAME, _rules_a;
             RAISE NOTICE '<%>, Point_6. _rules_i = %',  c_ERR_FUNС_NAME, _rules_i;
             RAISE NOTICE '<%>, Point_7. _rules_u = %',  c_ERR_FUNС_NAME, _rules_u;
    END IF;
 
   	_exec_str := _exec_str || ', rec_uuid, date_from';
      -- 2015-09-25 Gregory формирование правил для нематериализованного представления
         _rules := rtrim(_rules, ', ');
   	_rules := 'CREATE OR REPLACE RULE r_' || _sch_name || '_' || _nso_code || '_d
                   AS ON DELETE TO ' || _view_name || ' DO INSTEAD SELECT nso.nso_p_record_d (OLD.rec_id);
                   CREATE OR REPLACE RULE r_' || _sch_name || '_' || _nso_code || '_u
                   AS ON UPDATE TO ' || _view_name || ' DO INSTEAD
                   SELECT nso.nso_p_record_u2
                   (
                       NEW.rec_uuid
                      ,(SELECT rec_uuid FROM ONLY nso.nso_record WHERE rec_id = NEW.parent_rec_id)
                      ,(' ||  _rules_a 
                          || _rules_u 
                          || 
                   'CREATE OR REPLACE RULE r_' || _sch_name || '_' || _nso_code || '_i
                   AS ON INSERT TO ' || _view_name || ' DO INSTEAD
                   SELECT nso.nso_p_record_i2
                     (
                       NEW.rec_uuid
                      ,(SELECT rec_uuid FROM ONLY nso.nso_record WHERE rec_id = NEW.parent_rec_id)
                      ,''' || _nso_code 
                           || '''
                      ,('  || _rules_a 
                           || _rules_i; 
   	
   	-- Вывод в историю
   	IF C_DEBUG
   	THEN
   		RAISE NOTICE '<%>, Point 8. _exec_str = %', c_ERR_FUNС_NAME, _exec_str;
   		RAISE NOTICE '<%>, Point 9. _comments = %', c_ERR_FUNС_NAME, _comments;
   	END IF;
   
   	-- Формирование команды CREATE [MATERIALIZED] VIEW
   	_exec_str :=
   		--'CREATE [MATERIALIZED] VIEW ' ||
   		_view_name ||
   		'(' ||
   		_exec_str || -- Вставка списка колонок
   		') AS(' ||
   		(
   			SELECT nso_select FROM ONLY nso.nso_object WHERE nso_code = _nso_code -- 2016-09-12 Gregory -> lower btrim
   		)::text ||
   		')';
   		
           UPDATE ONLY nso.nso_object SET is_m_view = p_view_type WHERE nso_code = _nso_code; -- 2016-09-12 Gregory -> lower btrim
   	IF p_view_type
   	THEN
   		_exec_str :=
   			'CREATE MATERIALIZED VIEW ' || -- 2017-10-25 Gregory from 'CREATE OR REPLACE MATERIALIZED VIEW'
   			_exec_str;
   	ELSE
   		_exec_str :=
   			'CREATE OR REPLACE VIEW ' ||
   			_exec_str;
   	END IF;
   
     	-- Вывод команды в историю
   	IF C_DEBUG
   	THEN
   		RAISE NOTICE '<%>, Point 10. _exec_str = %', c_ERR_FUNС_NAME, _exec_str;
       RAISE NOTICE '<%>, Point 11. _comments = %', c_ERR_FUNС_NAME, _comments;
   	END IF;
   
         -- Выполнение команды CREATE [MATERIALIZED] VIEW 
   	EXECUTE _exec_str::text;
   
   	-- Применение коментариев к созданому представлению
   	EXECUTE _comments::text;
   
    -- 2015-09-25 Gregory создание правил для нематериализованного представления
    IF p_view_type IS FALSE
    THEN
    	   IF C_DEBUG THEN
               RAISE NOTICE '<%>, Point_12. _rules = %',   c_ERR_FUNС_NAME, _rules;
               RAISE NOTICE '<%>, Point_13. _rules_a = %', c_ERR_FUNС_NAME, _rules_a;
               RAISE NOTICE '<%>, Point_14. _rules_i = %', c_ERR_FUNС_NAME, _rules_i;
               RAISE NOTICE '<%>, Point_15. _rules_u = %', c_ERR_FUNС_NAME, _rules_u;
          END IF;
     EXECUTE _rules::text;
    END IF;
    -- Nick 2018-06-28
    -- Раздача прав
    FOR _role_name IN SELECT role_name FROM auth_serv_obj.auth_f_role_s() 
                        WHERE (NOT (role_description ~* 'Индивид')) AND (role_name NOT IN ('dummy', 'public'))
     LOOP     
          IF (utl.auth_f_get_user_attr_s (_role_name, 'is_read_only', FALSE)) OR (_role_name = 'abi')
            THEN
                 _exec_str := 'GRANT SELECT ON TABLE ';
          ELSE
                 _exec_str := 'GRANT SELECT, UPDATE, INSERT, DELETE ON TABLE ';
          END IF;
       
          _exec_str := _exec_str || _view_name || ' TO ' || _role_name;
            
          IF C_DEBUG THEN
                  RAISE NOTICE '<%>, Pouint 16. grant = %', c_ERR_FUNС_NAME, _exec_str;
          END IF;
   
          EXECUTE _exec_str::text;
    END LOOP;
    -- Logging
    IF p_view_type
      THEN  
           _impact_type := '7'::public.t_code1; -- Создание материализованного представления  
      ELSE   
           _impact_type := '6'::public.t_code1; -- Создание простого представления. 
    END IF;
    --
 	INSERT INTO nso.nso_log	(
                 user_name
                ,host_name
                ,impact_type
                ,impact_date
                ,impact_descr
                ,schema_name
         ) 
         VALUES (
                 SESSION_USER::public.t_str250                   -- user_name
                ,utl.auth_f_get_user_attr_s ( SESSION_USER::public.t_sysname, c_HOST, inet_client_addr ())::public.t_str250    -- host_name
                ,_impact_type                                    -- impact_type
                ,CURRENT_TIMESTAMP::public.t_timestamp           -- impact_date
                ,(_view_name || ' - ' || (SELECT nso_name FROM ONLY nso.nso_object WHERE nso_code = _nso_code))::public.t_text  -- impact_descr
                ,'NSO' -- schema_name
         );
    -- Nick 2018-06-28
   	rsp_main := ((_view_name::regclass::oid)::int8, 'Успешно создано представление'); -- Nick 2018-06-28
   	RETURN rsp_main;
    --
    -- Модифицировал Nick 2015-06-26
    --
    EXCEPTION
    	WHEN OTHERS THEN
	 BEGIN
	    GET STACKED DIAGNOSTICS 
               _exception.state           := RETURNED_SQLSTATE            -- SQLSTATE
              ,_exception.schema_name     := SCHEMA_NAME 
              ,_exception.table_name      := TABLE_NAME 	      
              ,_exception.constraint_name := CONSTRAINT_NAME     
              ,_exception.column_name     := COLUMN_NAME       
              ,_exception.datatype        := PG_DATATYPE_NAME 
              ,_exception.message         := MESSAGE_TEXT                 -- SQLERRM
              ,_exception.detail          := PG_EXCEPTION_DETAIL 
              ,_exception.hint            := PG_EXCEPTION_HINT 
              ,_exception.context         := PG_EXCEPTION_CONTEXT;            -- 
    
              _exception.func_name := c_ERR_FUNС_NAME; 
		  
	    rsp_main := (-1, ( com_error.f_error_handling ( _exception, _err_args )));
			 
	    RETURN rsp_main;			
	 END;
    END;
 $$
LANGUAGE plpgsql
SECURITY DEFINER; -- Nick 2016-02-26

COMMENT ON FUNCTION nso_structure.nso_p_view_c(public.t_str60, public.t_boolean, public.t_sysname) 
   IS '183: Конструктор представлений
	Аргументы:
		1)  p_nso_code  public.t_str60	-- Код НСО
		2) ,p_view_type public.t_boolean	-- Тип представления(TRUE - материализованное, FALSE - обычное), по умолчанию FALSE
		3) ,p_sch_name  public.t_sysname	-- Имя схемы, по умолчанию ''nso''
	Выходные данные:
		1) result_t.rc    bigint	-- OID view при удачном завершении функции, в случае неудачи -1
		2) result_t.errm  text  	-- Сообщение
 ';
----------------------------------------------------------
-- SELECT com.f_debug_on();

-- SELECT * FROM plpgsql_check_function_tb ('nso_structure.nso_p_view_c(public.t_str60, public.t_boolean, public.t_sysname)');
-- SELECT * FROM plpgsql_check_function_tb ('nso_structure.nso_p_view_c(public.t_str60, public.t_boolean, public.t_sysname)', security_warnings := true, fatal_errors := false);
------------------------------------------------------------------------------------------------------------------------------
-- 'nso_p_view_c'|114|'IF'                  |'22P02'|'malformed array literal: "v"'       |'Array value must start with "{" or dimension information.'|''|'error'
-- 'nso_p_view_c'|118|'IF'                  |'22P02'|'malformed array literal: "m"'       |'Array value must start with "{" or dimension information.'|''|'error'
-- 'nso_p_view_c'|287|'EXECUTE'             |'00000'|'text type variable is not sanitized'|'The EXECUTE expression is SQL injection vulnerable.'|'Use quote_ident, quote_literal or format function to secure variable.'|'security'
-- 'nso_p_view_c'|290|'EXECUTE'             |'00000'|'text type variable is not sanitized'|'The EXECUTE expression is SQL injection vulnerable.'|'Use quote_ident, quote_literal or format function to secure variable.'|'security'
-- 'nso_p_view_c'|301|'EXECUTE'             |'00000'|'text type variable is not sanitized'|'The EXECUTE expression is SQL injection vulnerable.'|'Use quote_ident, quote_literal or format function to secure variable.'|'security'
-- 'nso_p_view_c'|305|'FOR over SELECT rows'|'42883'|'function auth_serv_obj.auth_f_role_s() does not exist'|''|'No function matches the given name and argument types. You might need to add explicit type casts.'|'error'
-- 'nso_p_view_c'|321|'EXECUTE'             |'00000'|'text type variable is not sanitized'|'The EXECUTE expression is SQL injection vulnerable.'|'Use quote_ident, quote_literal or format function to secure variable.'|'security'
-- ------------------------------------------------------------------------------------------------------------
-- SELECT * FROM nso_structure.nso_p_view_c('EXN_ACCOUNT', FALSE);
-- ---------------------------------------------------------
-- 57646|'Успешно создано представление'
---------------------------------------------------------

