/*
	Входные параметры
							 p_err_number     t_code5     -- номер ошибки			         
							,p_err_message    t_str1024   -- сообщение об ошибке							
                     ,p_user_type      t_str1024   -- наименование пользовательского типа 
                     ,p_err_func_name  t_sysname   -- название функции

	Выходные параметры
				 _str_out t_str1024  текст ошибки

	Особенности
	Текст каждого типа ошибки парситься и по имени ограничения и номеру ошибки берется текст ошибки из таблицы com.error_handling

	работа с xml:           2200_ (L,M,N,S,T)
	нарушение ограничение длины символьного поля    22001  value too long for type character varying(255)

	флаг определяет, режим отладки функционального слоя
*/

-- DROP FUNCTION IF EXISTS com_error.f_error_handling (public.t_code5, public.t_text, public.t_sysname, public.t_sysname);	
DROP FUNCTION IF EXISTS com_error.f_error_handling (public.exception_type_t, public.t_sysname, public.t_sysname);	

DROP FUNCTION IF EXISTS com_error.f_error_handling (public.exception_type_t, public.t_sysname);	
CREATE OR REPLACE FUNCTION com_error.f_error_handling (	
                      p_exception      public.exception_type_t -- Диагностика			         
                     ,p_user_type      public.t_sysname   -- наименование пользовательского типа 
)

     RETURNS   public.t_text  
     LANGUAGE plpgsql 
     SECURITY DEFINER -- INVOKER
     SET search_path = com_error, com, public, pg_catalog   
   AS 
$$
    -- ===========================================================================================================
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
    -- -----------------------------------------------------------------------------------------------------------
    --  2015-02-19 Переходим на домен EDB. Убираю на хрен рукоделие Романа. 
    --  2015-04-05 Добавлен SECURITY INVOKER
    --  2015-04-14 Вторая функция, реализующая обработку ошибок преобразования типов. 
    --             Отличается от базового варианта com_f_error_handling наличием дополнительного параметра,
    --             передающего наименование типа данных, определённого пользователем. 
    --  2017-12-18 Nick Модификация функции, сообщения об ошибках логгируются.
    --  2019-06-21 Nick Новое ядро. Получаю на вход коды SQLSTATE '22xxx', после этого ищу в obj_errors
    --                  коды '22xxx'.
    -- ===========================================================================================================
 DECLARE 
   _str_out     public.t_text;
   _bad_value   public.t_text;
   --
   c_MES003 public.t_str1024 = 'Необработанная ошибка: ';
   c_MES004 public.t_str1024 = 'код = ';
   c_MES005 public.t_str1024 = ', текст = ';
   c_MES009 public.t_str1024 = '. Ошибка произошла в функции: "';
   c_MES010 public.t_str1024 = '".';

   c_DP  public.t_code1 = ':';  
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
    -- Nick 2019-06-22
    --
    _err_target  public.t_arr_text := ARRAY [''::text];
   -- ------------------------------------------------------------------- --
   --   exception_type_t.state           --  'Код исключения SQLSTATE';   --
   --   exception_type_t.schema_name     --  'Имя схемы';                 --
   --   exception_type_t.func_name       --  'Имя функции';               --
   --   exception_type_t.table_name      --  'Имя таблицы';               --
   --   exception_type_t.constraint_name --  'Имя ограничения';           --
   --   exception_type_t.column_name     --  'Имя столбца';               --
   --   exception_type_t.datatype        --  'Имя типа данных';           --
   --   exception_type_t.message         --  'Сообщение';         SQLERRM --
   --   exception_type_t.detail          --  'Детали';                    --
   --   exception_type_t.hint            --  'Подсказка';                 --
   --   exception_type_t.context         --  'Контекст (стек вызовов)';   --
   -- ------------------------------------------------------------------- --
   --   p_exception.state           := RETURNED_SQLSTATE         SQLSTATE --
   --   p_exception.schema_name     := SCHEMA_NAME                        --
   --   p_exception.table_name      := TABLE_NAME 	                      --
   --   p_exception.constraint_name := CONSTRAINT_NAME                    --
   --   p_exception.column_name     := COLUMN_NAME                        --
   --   p_exception.datatype        := PG_DATATYPE_NAME                   --
   --   p_exception.message         := MESSAGE_TEXT              SQLERRM  --
   --   p_exception.detail          := PG_EXCEPTION_DETAIL                --
   --   p_exception.hint            := PG_EXCEPTION_HINT                  --
   --   p_exception.context         := PG_EXCEPTION_CONTEXT;              --
   --                                                                     --
   --   p_exception.func_name       := c_ERR_FUNP_NAME;                   --
   -------------------------------------------------------------------------
   
BEGIN
    -- RAISE NOTICE '%', p_exception;
   _str_out := NULL;
   
   CASE p_exception.state
      WHEN '22P02' THEN -- invalid input syntax for integer
         _bad_value := btrim ( substring ( p_exception.message 
                                              FROM (position (c_DP IN p_exception.message ) + 1) 
                                                                FOR LENGTH ( p_exception.message )) 
         );
         SELECT message_out INTO _str_out  
                                  FROM com.obj_errors e  WHERE (e.err_code = p_exception.state);
         _err_target [1] :=  p_user_type;
         _err_target [2] := _bad_value;
         _str_out := utl.utl_f_format_str (_str_out, _err_target);
           
      WHEN '22003' THEN -- Out of range
          SELECT message_out INTO _str_out  
                                 FROM com.obj_errors e  WHERE (e.err_code = p_exception.state);
         _err_target [1] :=  p_user_type;
         _str_out := utl.utl_f_format_str (_str_out, _err_target);

      WHEN '22007' THEN -- invalid input syntax for DATETIME
         _bad_value := btrim ( substring ( p_exception.message 
                                              FROM (position ( c_DP IN p_exception.message ) + 1) 
                                                                 FOR LENGTH ( p_exception.message ))
         );
         SELECT message_out INTO _str_out
                               FROM com.obj_errors e  WHERE (e.err_code = p_exception.state);
        _err_target [1] :=  p_user_type;
        _err_target [2] :=  _bad_value;
        _str_out := utl.utl_f_format_str (_str_out, _err_target);

      -- Вытаскиваю проверяемую величину из текста сообщения, далее дополняю его текстовыми константами на русском языке
      WHEN '22008' THEN -- Datetime Out of range
          _bad_value := btrim (substring ( p_exception.message 
                                              FROM ( position ( c_DP IN p_exception.message ) +1) 
                                                            FOR ( LENGTH ( p_exception.message )))
         );
           SELECT message_out INTO _str_out 
                                  FROM com.obj_errors e  WHERE (e.err_code = p_exception.state);

          _err_target [1] :=  _bad_value;
          _err_target [2] :=  p_user_type;
          _str_out := utl.utl_f_format_str (_str_out, _err_target);
          
       WHEN 'XX000' THEN
           IF ( p_user_type ~* 'hstore' )
             THEN
                  SELECT message_out 
                        INTO _str_out 
                                 FROM com.obj_errors e  WHERE (e.err_code = '600XX');
             ELSE
    		     _str_out := c_MES003 || c_MES004 || btrim ( p_exception.state ) || 
	     	                 c_MES005 || btrim ( p_exception.message );
           END IF;
	ELSE
         SELECT message_out 
                      INTO _str_out 
                                 FROM com.obj_errors e  WHERE (e.err_code = p_exception.state);
	    IF _str_out IS NULL 
	      THEN 
		     _str_out := c_MES003 || c_MES004 || btrim ( p_exception.state ) || 
		                 c_MES005 || btrim ( p_exception.message );
	    END IF;	                 
	END CASE;
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

COMMENT ON FUNCTION com_error.f_error_handling (public.exception_type_t, public.t_sysname) 
   IS '97: Обработка ошибок преобразования типов данных
           Аргументы:
             1)  p_exception  public.exception_type_t -- Диагностика, передаём из функции в которой произошла ошибка преобразования типов.			         
             2) ,p_user_type  public.t_sysname     -- Наименование пользовательского типа 
   ';

/*
Тестирование функции 
-
*/
