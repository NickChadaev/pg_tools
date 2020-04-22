/*
	Входные параметры
   p_nso_code          public.t_str60  -- Код объекта владельца
   p_parent_col_code   public.t_str60  -- Код родителского атрибута
   p_attr_code         public.t_str60  -- Код атрибута
   -- По умолчанию
   p_number_col        public.small_t  -- Номер колонки, если NULL - то номер вычисляется по максимальному
   p_mandatory         public.t_boolean     DEFAULT FALSE -- Обязательность заполнения
   p_act_name          public.t_str250      DEFAULT NULL  -- Актуальное имя атритута
   p_final_sw          public.t_boolean     DEFAULT FALSE -- если TRUE то записываем сообщение в LOG 
   --                           --  Используется только при записи последнего атрибута. 
   p_act_code          public.t_str60       DEFAULT NULL -- Актуальный код атрибута       

	Выходные параметры
				  > 0 - процедура завершилась успешно, ид вновь созданной записи
				 -1 - процедура завершилась с ошибкой, вывод ошибки

	Особенности
				порядковые номера для одной коллекции атрибутов не должны повторяться, все группирирующие атрибуты имеют номер = 0
				IF parent =  NULL, то атрибут привязывается к групповому атрибуту для данного НСО
*/
DROP FUNCTION IF EXISTS nso_structure.nso_p_column_head_i (public.t_str60, public.t_str60, public.small_t, public.t_boolean, public.t_str60, public.t_str250, public.t_boolean);	 				   
CREATE OR REPLACE FUNCTION nso_structure.nso_p_column_head_i (	 
                          p_nso_code          public.t_str60  -- Код объекта владельца
                         ,p_attr_code         public.t_str60  -- Код атрибута
                         -- По умолчанию
                         ,p_number_col        public.small_t    DEFAULT NULL  -- Номер колонки, если NULL - то номер вычисляется по максимальному
                         ,p_mandatory         public.t_boolean  DEFAULT FALSE -- Обязательность заполнения
                         ,p_act_code          public.t_str60    DEFAULT NULL  -- Актуальный код, если NULL то берём код родителя +  код НСО + номер строки
                         ,p_act_name          public.t_str250   DEFAULT NULL  -- Актуальное имя, если NULL - берём имя домена 
                         ,p_final_sw          public.t_boolean  DEFAULT FALSE -- если TRUE то записываем сообщение в LOG 
						   )
  RETURNS public.result_long_t 
      SECURITY DEFINER -- 2015-04-05 Nick
      LANGUAGE plpgsql
      SET search_path = nso, com, utl, com_codifier, com_domain, nso_strucrure, com_error, public,pg_catalog
   AS 
$$
-- =================================================================================== --
--  Author:	SVETA                                                                      --
--  Create date: 2013-08-13                                                            --
--  Description:	Добавление нового атрибута                                         --
-- ----------------------------------------------------------------------------------- -- 
--  2015-03-09 Nick адаптация к домену EBD                                             --
--     Должен быть опциональный атрибут - XML структура заголовка                      --
--     В следующем релизе нужно добавить его и создать новую функцию,                  -- 
--     создающую заголовок на основе XML-структуры за один вызов.                      --
--     В противном случае за...шся создавать сложные стуктуры для ТТХ.                 --
-- ----------------------------------------------------------------------------------- --
--   SECURITY DEFINER -- 2015-04-05 Nick                                               --
--   2015-05-30  При завершении создания заголовка, активирую НСО,                     -- 
--      В активный НСО можно заносить данные, для него можно создавать                 -- 
--      представления, как простые так и материализованные.                            --
-- ----------------------------------------------------------------------------------- --
--  2015-07-04  Добавляю актуальный код атрибута, передаваемый как параметр.           --
-- ----------------------------------------------------------------------------------- --
--  2015-10-21    Ревизия 894 nso_p_column_head_i fix  Gregory                         -- 
-- ----------------------------------------------------------------------------------- --
-- Gregory добавил проверку nso_record на предмет возможного дополнения данных         --
-- ----------------------------------------------------------------------------------- --
-- Nick. Update записи. ПОЧЕМУ в LOG попадают данные только о первой                   --
--              обновлённой записи !!!!!                                               --
-- 154|'postgres'|'::1/128'|'4'|'2015-10-21 20:40:13'|                                 --
--                            'Обновление данных: "CL_TEST", ID записи: 3'             --
-- ----------------------------------------------------------------------------------- --
-- 2016-11-09  Gregory  Введено обращение к функции логгирования.                      --
-- 2017-12-19  Gregory c_SEQ_NAME_NSO_LOG                                              --
--                     nso.nso_log_id_log_seq -> com.all_history_id_seq.               --
-- ----------------------------------------------------------------------------------- --
-- 2019-08-08  Nick  Новое ядро. Убран из параметров технический родительский атрибут. --
-- 2020-04-14  Nick  section_number.
-- =================================================================================== --

 DECLARE 
   c_SEQ_NAME_NSO_COLUMN_HEAD public.t_sysname = 'nso.nso_column_head_col_id_seq';

   c_ERR_FUNC_NAME public.t_sysname = 'nso_p_column_head_i'; --имя процедуры
   c_CODIF_NODE    public.t_str60   = 'C_DOMEN_NODE'; -- Узловой атрибут
   c_MESS00        public.t_str1024 = 'Создание элемента заголовка НСО выполнено успешно';
   c_MESS03        public.t_code1   = '9';   --  создание  элемента заголовка ( Создание всего заголовка завершено).
   c_MESS04        public.t_str60   = 'Создан заголовок НСО: "';
   c_MESS06        public.t_str60   = '"';

   cPOINT public.t_code1 = '_';

   ---------------------
   _nso_id       public.id_t;
   _col_id       public.id_t;
   _number_col   public.small_t;
   --
   _attr_id      public.id_t;
   _attr_scode   public.t_code1;
   -- ----------------------------------------------------------------------------------------------------
   _nso_code         public.t_str60  := utl.com_f_empty_string_to_null (btrim (upper (p_nso_code)));  -- Код объекта владельца
   _parent_col_code  public.t_str60  := 'D_' || _nso_code;  -- Код родительского атрибута
   _attr_code        public.t_str60  := utl.com_f_empty_string_to_null (btrim (upper (p_attr_code))); -- Код атрибута
   _act_code         public.t_str60  := utl.com_f_empty_string_to_null (btrim (upper (p_act_code)));  -- Актуальный код
   _act_name         public.t_str250 := utl.com_f_empty_string_to_null (btrim (p_act_name));          -- Актуальное имя
  
   _col_code public.t_str60;   -- Актуальные код и имя
   _col_name public.t_str250;

   _log_id   public.id_t;

   rsp_main  public.result_long_t;
    --
   _exception  public.exception_type_t;
   _err_args   public.t_arr_text := ARRAY [''];
    --
   C_DEBUG public.t_boolean := utl.f_debug_status();

 BEGIN
    IF (   ( _nso_code        IS NULL ) 
        OR ( _attr_code       IS NULL ) 
        OR ( p_mandatory      IS NULL )
        OR ( p_final_sw       IS NULL ) 
       )
     THEN
       RAISE SQLSTATE '60000'; -- NULL значения запрещены
    END IF;

	 -- Проверка того, что нельзя создавать колонки из атрибутов узловых/группирующих типов.  ????????????????
    IF ( c_CODIF_NODE = (SELECT attr_type_code FROM com_domain.nso_f_domain_column_s (_attr_code) WHERE (level_d = 1))) 
      THEN
         _err_args [1] := _attr_code;
         RAISE SQLSTATE '62030';
    END IF;

    _nso_id := (SELECT nso_id FROM ONLY nso.nso_object WHERE ( nso_code = _nso_code));
    IF ( _nso_id IS NULL ) THEN
       _err_args [1] := _nso_code;
       RAISE SQLSTATE '62020';  -- Нет НСО 
    END IF;
    --
    IF p_number_col IS NULL THEN 
             _number_col :=  (SELECT (MAX(number_col) + 1) FROM ONLY nso.nso_column_head WHERE nso_id = _nso_id);
        ELSE 
             _number_col := p_number_col; 
    END IF;
    --
    -- 2015-04-26 Актуальные код и имя колонки.
    --
    IF _act_code IS NULL THEN
           _col_code := upper (_nso_code || cPOINT || _attr_code || cPOINT || (_number_col::public.t_str20)); -- 
      ELSE
           _col_code := _act_code; 
    END IF;
    --
    IF _act_name IS NULL THEN
          _col_name := btrim (
              (SELECT attr_name FROM ONLY com.nso_domain_column WHERE ( attr_code = _attr_code)) 
          );
       ELSE 
          _col_name := _act_name;
    END IF;

    SELECT attr_id, small_code FROM ONLY com.nso_domain_column 
       INTO _attr_id, _attr_scode WHERE ( attr_code = _attr_code ); -- 2015-05-30
    -- Если данных нет, то последующий INSERT развалится
    -- Но где проверка того, что коды всегда в верхнем регистре ??
    _log_id = nso.nso_p_nso_log_i ( c_MESS03, c_MESS04 || btrim ( _nso_code ) || c_MESS06 );
    --
    -- Nick 2019-08-09
    IF C_DEBUG
      THEN
         RAISE NOTICE '<%>, %, %, %, %, %, %, %, %', c_ERR_FUNC_NAME
            ,_nso_code,  _parent_col_code, _attr_code, p_mandatory        
            ,p_final_sw, _attr_scode,      _col_code,  _col_name;
    END IF;      
    -- Nick 2019-08-09
    --    
    INSERT INTO nso.nso_column_head (
                parent_col_id  
               ,attr_id  
               ,attr_scode       
               ,nso_id         
               ,number_col    
               ,col_code     -- 2015-04-26
               ,col_name                    
               ,mandatory
               ,log_id       -- Gregory 2016-11-09      
	 )
	 VALUES (  (SELECT c.col_id FROM ONLY nso.nso_column_head c, ONLY com.nso_domain_column d 
                    WHERE (c.attr_id = d.attr_id) AND (d.attr_code = _parent_col_code)
               )
              ,_attr_id
              ,_attr_scode
              ,_nso_id
              ,_number_col
              ,_col_code
              ,_col_name
              ,p_mandatory
              ,_log_id -- Gregory 2016-11-09 
     );
  _col_id := CURRVAL ( c_SEQ_NAME_NSO_COLUMN_HEAD ); 
   --
   --  2015-05-30 
   IF ( p_final_sw ) THEN
     UPDATE ONLY nso.nso_object SET active_sign = TRUE, nso_select = nso_structure.nso_f_select_c (_nso_code)
     WHERE ( nso_id = _nso_id );
   END IF;
  --
  -- Gregory 2015-10-21
  -- Nick 2019-08-08 Добавляю номер секции  "section_sign"
  --
  IF ( EXISTS ( SELECT TRUE FROM ONLY nso.nso_record WHERE ( nso_id = _nso_id ) LIMIT 1 )) 
  THEN -- Если уже есть данные, то вставляе запись с пустым значением в добавляемом столбце.
      IF _attr_scode = 'T'
      THEN -- REF     Не секционированная таблица
          INSERT INTO nso.nso_ref
            SELECT rec_id, _col_id, actual, _log_id, NULL -- ref_rec_id public.id_t NOT NULL | INSERT или UPDATE в таблице "nso_ref" нарушает ограничение внешнего ключа "fk_nso_record_may_be_ref"
                FROM ONLY nso.nso_record  WHERE nso_id = _nso_id;
      --
      ELSIF _attr_scode = 'q'
      THEN -- BLOB  Секционированная таблица
          INSERT INTO nso.nso_blob
            SELECT rec_id, _col_id, actual, _log_id, _attr_scode, section_number, NULL, NULL, NULL -- Nick 2091-08-08/2020-04-14
                FROM ONLY nso.nso_record WHERE nso_id = _nso_id;
      --
      ELSE -- ABS Секционированная таблица
          INSERT INTO nso.nso_abs
            SELECT rec_id, _col_id, _attr_scode, '0', section_number, actual, _log_id, NULL -- Nick 2091-08-08/2020-04-14
                FROM ONLY nso.nso_record WHERE nso_id = _nso_id;
      END IF;
  END IF;
  -- Nick 2019-08-08 Добавляю номер секции  "section_sign"
  
  rsp_main := ( _col_id, c_MESS00 );
  RETURN rsp_main;

 EXCEPTION
	WHEN OTHERS  THEN 
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

             _exception.func_name := c_ERR_FUNC_NAME; 
		
	   rsp_main := (-1, ( com_error.f_error_handling ( _exception, _err_args )));
			
	   RETURN rsp_main;			
	 END;
 END;
$$;

COMMENT ON FUNCTION nso_structure.nso_p_column_head_i (public.t_str60, public.t_str60, public.small_t, public.t_boolean, public.t_str60, public.t_str250, public.t_boolean) 
   IS '298: Добавление новой колонки в заголовок НСО
	Входные параметры:
         p_nso_code       public.t_str60  -- Код объекта владельца
         p_attr_code      public.t_str60  -- Код атрибута
         -- По умолчанию
         p_number_col     public.small_t  -- Номер колонки, если NULL - то номер вычисляется по максимальному
         p_mandatory      public.t_boolean  DEFAULT FALSE -- Обязательность заполнения
         p_act_code       public.t_str60    DEFAULT NULL  -- Актуальный код, если NULL то берём код родителя +  код НСО + номер строки
         p_act_name       public.t_str250   DEFAULT NULL  -- Актуальное имя атритута
         p_final_sw       public.t_boolean  DEFAULT FALSE -- если TRUE то записываем сообщение в LOG 
                                                          -- Используется только при записи последнего атрибута.    

	Выходные параметры:
				    > 0 - процедура завершилась успешно, ID вновь созданной записи
				    -1 - процедура завершилась с ошибкой, вывод ошибки

	Особенности:
				порядковые номера для одной коллекции атрибутов не должны повторяться, все группирирующие атрибуты имеют номер = 0

';

/* Предварительная проверка
  SELECT * FROM plpgsql_check_function_tb ('nso_structure.nso_p_column_head_i (public.t_str60, public.t_str60, public.small_t, public.t_boolean, public.t_str60, public.t_str250, public.t_boolean)');

*/

