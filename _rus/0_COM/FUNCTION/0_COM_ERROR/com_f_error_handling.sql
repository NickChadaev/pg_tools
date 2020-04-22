DROP FUNCTION IF EXISTS com_error.f_error_handling ( public.exception_type_t, public.t_arr_text );	
CREATE OR REPLACE FUNCTION com_error.f_error_handling (	
							 p_exception  public.exception_type_t        -- Структура, с данными об ошибке			         
							,p_err_args   public.t_arr_text DEFAULT NULL -- Заготовки для сообщений							
						 )

  RETURNS public.t_text 
     LANGUAGE plpgsql 
     SECURITY DEFINER -- INVOKER
     SET search_path = com_error, com, public, pg_catalog   
   AS
$$
-- =============================================================================================================
-- Author:		SVETA
-- Create date: 2013-07-25
-- Description:	Функция по обработке ошибок
--  2014-01-16 добавлена обработка ошибки  22001, исправлена описание нумерации ошибок
--  2014-08-19 Роман в проверки not null изменён способ получения описания колонки. 
--             Описание колонки теперь получаеться на основании имени колонки 
--		   	   ,которое берёться из ошибки, и оида таблицы, который берёться на основании имени таблицы.
--             Имя таблицы берёться из названия функции.
--			      В случаее если  описание не возможно получить, тоиспользуеться имя колонки из ошибки.в случаее 
--             если имя отсутствует то выводиться сообщение невозмоно получить имя колонки.
-- -------------------------------------------------------------------------------------------------------------
--  2015-02-19 Переходим на домен EDB. Убираю на хрен рукоделие Романа. 
--  2015-04-05 Добавлен SECURITY INVOKER
--  2015_05_29 Версия под Русские локали
--  2015-10-04 Обработка '23514', ограничение check, не определяется имя таблицы. 
--      В схеме IND существуют две таблицы: IND_VALUE, IND_VALUE_HIST которые имеют одинаковые ограничения. 
--      Временно LIMIT 1;
-- ---------------------------------------------------
--  2017-05-21 Nick Ошибки связанные с типом hstore ??
--  2017-12-18 Nick Модификация функции, сообщения об ошибках логгируются.
-- -------------------------------------------------------------------------------------------------------------
--  2019-05-13 Nick  Ядро версия 2.0  Практически удалён парсинг  сообщений
-- =============================================================================================================
 DECLARE 
   _str_out          public.t_text;
   _qty              public.t_int;
   _constraint_name  public.t_sysname;  
   _table_name       public.t_sysname;
   _col_name         public.t_fieldname;

   -- Резерв

   c_MES003 public.t_str1024 = 'Необработанная ошибка: ';
   c_MES004 public.t_str1024 = 'код = ';
   c_MES005 public.t_str1024 = ', текст = ';
   c_MES006 public.t_str1024 = 'Ошибку: "';
   c_MES007 public.t_str1024 = '" с кодом: "';
   c_MES008 public.t_str1024 = '" необходимо добавить в таблицу по обработки ошибок для функции:  ';
   c_MES009 public.t_str1024 = '. Ошибка произошла в функции: "';
   c_MES010 public.t_str1024 = '".';
   c_MES011 public.t_str1024 = 'Столбец: "';
   c_MES012 public.t_str1024 = '". ';

   -- Добавлено Gregory 2015_05_29
   c_IOU  public.t_sysname = 'insert or update%';
   c_UOD  public.t_sysname = 'update or delete%';
   --
   -- Nick 2019-05-20
   --
    ch_new_line  public.t_code1  = chr(10)::public.t_code1;
    ch_tab       public.t_code1  = chr(9)::public.t_code1;
    --
    c_MESS02     public.t_str60  = 'Детали: ';
    c_MESS03     public.t_str60  = 'Совет: ';
    c_MESS04     public.t_str60  = 'Контекст: ';
    --
    -- Nick 2019-06-07
    --
    _i               public.t_int;
    _err_target      public.t_arr_text := ARRAY [''::text];
    _err_target_len  public.t_int      := 1;
    _err_real_len    public.t_int;
   -- ------------------------------------------------------------------
   --   exception_type_t.state           --  'Код исключения SQLSTATE';
   --   exception_type_t.schema_name     --  'Имя схемы';
   --   exception_type_t.func_name       --  'Имя функции';
   --   exception_type_t.table_name      --  'Имя таблицы';
   --   exception_type_t.constraint_name --  'Имя ограничения';
   --   exception_type_t.column_name     --  'Имя столбца';
   --   exception_type_t.datatype        --  'Имя типа данных';
   --   exception_type_t.message         --  'Сообщение';
   --   exception_type_t.detail          --  'Детали';
   --   exception_type_t.hint            --  'Подсказка';
   --   exception_type_t.context         --  'Контекст (стек вызовов)';
   -- ------------------------------------------------------------------

BEGIN
   -- RAISE NOTICE '%', p_exception;
   --   
   CASE 
    -- ************************
	-- Обработка ошибок  FK
	--
	WHEN (p_exception.state = '23503') THEN 
        _table_name := btrim (lower (p_exception.table_name));			    
        _constraint_name := btrim (lower (p_exception.constraint_name));
		
	    -- Выходная строка !!	
		_str_out := (SELECT e.message_out FROM com.sys_errors e WHERE ((e.err_code = p_exception.state)
			             	AND (e.constr_name = _constraint_name) 
			             	AND (e.tbl_name    = _table_name)
			             	AND (e.opr_type    = 
			             	-- Изменено Gregory 2015_05_28
                               (CASE WHEN p_exception.message LIKE c_IOU THEN 'i' -- LIKE 'insert or update%' на LIKE c_IOU
			            		     WHEN p_exception.message LIKE c_UOD THEN 'd' -- LIKE 'update or delete%' на LIKE c_UOD                      
                                END
                               )
                           )
                     ) -- WHERE
				);
				
	-- ************************
	-- Обработка ошибок not null
	-- "null value in column "small_code" violates not-null constraint"
	--
	WHEN (p_exception.state = '23502') THEN
        _col_name := btrim (lower (p_exception.column_name));
		--
		_str_out :=  ( SELECT e.message_out FROM com.sys_errors e WHERE ((e.err_code = p_exception.state)
			              	  	AND (e.opr_type = (CASE WHEN btrim (p_exception.func_name) LIKE '%_i' THEN 'i'
                                                           WHEN btrim (p_exception.func_name) LIKE '%_d' THEN 'd'
			              		                   END 
                                                   )
                                        )
				               ) -- WHERE
                         );                       
        _str_out := c_MES011 || _col_name || c_MES012 || _str_out;  

    -- ************************     
	-- Обработка ограничений уникальности
	--
	WHEN (p_exception.state = '23505') THEN
        _constraint_name := btrim (lower (p_exception.constraint_name));
        --
		_str_out := (SELECT e.message_out FROM com.sys_errors e WHERE (
					                 (e.err_code = p_exception.state) AND (e.constr_name = _constraint_name) 
                          ) -- WHERE
			      	);
        -- Nick 2015-02-22 Нет имени таблицы в условии, уже излишне.

    -- ************************    
	-- Обработка всех ограничений check
	--
	WHEN (p_exception.state = '23514') THEN
			--new row for relation "obj_physical_object" violates check constraint "chk_obj_physical_object_accessory_mark_char5_rffs"
        _constraint_name := btrim (lower (p_exception.constraint_name));
		--
		_str_out :=  (SELECT message_out FROM com.sys_errors e 
		                         WHERE ((e.err_code = p_exception.state) 
					                                            AND (e.constr_name = _constraint_name) 
					             )                               
                        ) LIMIT 1; -- Имя таблицы ??? Nick 2015-10-04

    -- ************************		
	-- нарушение ограничение длины символьного поля   Sveta 2014-01-16    
	--
	WHEN (p_exception.state = '22001') THEN
          _constraint_name := btrim (lower (p_exception.constraint_name));
		
     --  ************************
     -- Nick 2017-06-11  Внутренние ошибки  2019-05-16  Анализировать тип данных. 
     --
    WHEN (p_exception.state = 'XX000') THEN
          _str_out := ( SELECT message_out FROM com.sys_errors s WHERE (s.err_code = p_exception.state)); 		
         --
         -- Nick 2017-06-11 
         --
    -- ************************     
	-- ошибки функционального слоя, API базы.
	--
	WHEN (p_exception.state !~* '[A-Z]' AND (CAST ( p_exception.state AS INTEGER ) >= 60000 )) 
	   THEN
	       -- Nick 2019-06-04
	       --
           SELECT message_out, qty INTO _str_out, _qty 
                        FROM com.obj_errors e 
                                                WHERE (e.err_code = p_exception.state);
           IF (_qty > 0) THEN -- Форматируем
                 -- Наращиваю пустой массив
                 WHILE (_err_target_len < _qty) LOOP 
                       _err_target := _err_target::text[] || ''::text;
                       _err_target_len := array_length (_err_target, 1);
                 END LOOP;               
                 --
                 -- Кто больше ??
                 --
                 IF (p_err_args IS NOT NULL) THEN
                     _err_real_len := array_length (p_err_args, 1);
                     IF (_err_target_len > _err_real_len) 
                       THEN
                            _err_target_len := _err_real_len;
                     END IF;
                     --
                     _i := 1;
                     WHILE ( _i <= _err_target_len ) LOOP 
                         _err_target [_i] := p_err_args [_i];
                         _i := _i + 1;
                     END LOOP;               
                     --
                 END IF; -- p_err_args IS NOT NULL

                 _str_out := utl.utl_f_format_str (_str_out, _err_target);
                 --  2019-06-07 Недодумано, как же форматировать.
           END IF; -- _qty > 0
                                                
	-- ************************
	-- необработанные ошибки функционального слоя
	--
	WHEN (p_exception.state = 'P0001') THEN
   
			IF length ( trim ( p_exception.message )) = 5  
			THEN 
				_str_out := ( SELECT  e.message_out FROM com.sys_errors e WHERE ( trim (e.err_code) = trim (p_exception.message))); 
			ELSE 
				_str_out := p_exception.message;
			END IF;
	--необработанные ошибки  
	ELSE 
		_str_out := c_MES003 || c_MES004 || trim ( p_exception.state )|| c_MES005 || trim (p_exception.message);

	END CASE;

	IF ( _str_out IS NULL ) THEN
		_str_out := c_MES006 || trim (p_exception.message) || c_MES007 || trim (p_exception.state) || c_MES008 || trim (p_exception.func_name);
	END IF;
	--
	--  Сформировано краткое сообщение, оно записывается в LOG. Nick 2019-05-20
	--
	INSERT INTO com.all_log	(
                user_name
               ,host_name
               ,impact_type
               ,impact_date
               ,impact_descr
               ,schema_name
        ) 
        VALUES (
                SESSION_USER::public.t_str250                   -- user_name
               ,inet_client_addr()::public.t_str250             -- host_name
               ,'!'                                             -- impact_type
               ,CURRENT_TIMESTAMP::public.t_timestamp           -- impact_date
               ,_str_out || c_MES009 || btrim (p_exception.func_name) || c_MES010 --2014-04-02 Anna (исправлена орфографическая ошибка)					  
                                                                -- impact_descr
               ,upper(db_info.f_get_proc_nspname (btrim (p_exception.func_name))) -- schema_name
        );
	--
	-- Теперь полное сообщение, оно передаётся приложению. Nick 2019-05-20
	--
    _str_out := _str_out ||
       CASE 
           WHEN (utl.com_f_empty_string_to_null (p_exception.detail) IS NULL) 
             THEN '' 
             ELSE (ch_new_line || ch_tab|| c_MESS02 || btrim (p_exception.detail)) 
       END::public.t_text 
           ||
       CASE WHEN (utl.com_f_empty_string_to_null (p_exception.context) IS NULL) 
             THEN '' 
             ELSE (ch_new_line || ch_tab|| c_MESS04 || btrim (p_exception.context)) 
       END::public.t_text 
           ||
       CASE WHEN (utl.com_f_empty_string_to_null (p_exception.hint) IS NULL) 
             THEN '' 
             ELSE (ch_new_line || ch_tab|| c_MESS03 || btrim (p_exception.hint)) 
       END::public.t_text
    ;       
   RETURN _str_out;

 END;
$$;

COMMENT ON FUNCTION com_error.f_error_handling ( public.exception_type_t, public.t_arr_text ) 
   IS '97: Обработка ошибок, должна быть использована во всех функциях типа "P". 
           
           Аргументы:
                p_exception  public.exception_type_t        -- Структура, с данными об ошибке			         
               ,p_err_args   public.t_arr_text DEFAULT NULL -- Заготовки для сообщений							

           Результат:
               Строка типа public.t_text  
           ';

/*
--SET lc_messages TO 'en_US.UTF-8';
--SET lc_messages TO 'ru_RU.UTF-8';

Тестирование функции 
-- 
SET lc_messages TO 'en_US.UTF-8';
select * FROM  com.f_error_handling('23503','insert or update on table "nso_domain_column" violates foreign key constraint "fk_obj_codifier_typify_nso_domain_column"','nso_p_domain_column_i')

SET lc_messages TO 'ru_RU.UTF-8';
SET lc_messages TO 'ru_RU.UTF-8';
select * FROM  com.f_error_handling('23503','INSERT или UPDATE в таблице "nso_domain_column" нарушает ограничение внешнего ключа "fk_obj_codifier_typify_nso_domain_column"','nso_p_domain_column_i')

--
select  com.f_error_handling('23503','update or delete on table "obj_codifier" violates foreign key constraint "fk_obj_codifier_typify_nso_domain_column" on table "nso_domain_column"','nso_p_domain_column_i')
--
select com.f_error_handling ('23502','value in column "domain_type" violates not-null constraint','nso_p_domain_column_i')
--
select com.f_error_handling ('23502','value in column "dom_col_i" violates not-null constraint','nso_p_domain_column_i')
--
select com.f_error_handling ('23505','duplicate key value violates unique constraint "xak1nso_domain_column" ','nso_p_domain_column_i')
--
select com.f_error_handling ('23514','new row for relation "obj_physical_object" violates check constraint "chk_obj_physical_object_accessory_mark_char5_rffs"','nso_p_domain_column_i')
--
select com.f_error_handling ('61001','61001','nso_p_domain_column_i')

select com.f_error_handling ('P0001','61001','nso_p_domain_column_i')
--
select  com.f_error_handling('23503','update or delete on table "gis_frame" violates foreign key constraint ""fk_gis_frame_has_gis_graphic_representation"" on table "nso_domain_column"','nso_p_domain_column_i')
-
select com.f_error_handling ('42703','column "codifier_code" does not exist','nso_p_domain_column_i')


--insert or update on table "nso_domain_column" violates foreign key constraint "fk_obj_codifier_typify_nso_domain_column"
update or delete on table "obj_codifier" violates foreign key constraint "fk_obj_codifier_typify_nso_domain_column" on table "nso_domain_column"
select * from nso.nso_domain_column
delete from obj.obj_codifier

*/
