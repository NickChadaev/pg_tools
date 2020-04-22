/* --------------------------------------------------------------------------------------------------------------------
	Входные параметры:
		p_attr_id	      id_t	                  -- Идентификатор атрибута
		p_parent_attr_id  id_t       DEFAULT NULL -- Идентификатор родительского атрибута
		p_attr_type_id	   id_t       DEFAULT NULL -- Тип атрибута
		p_is_intra_op	   t_boolean  DEFAULT NULL -- Признак итраоперабельности
		p_attr_code	      t_str60    DEFAULT NULL -- Код атрибута(новый)
		p_attr_name	      t_str250   DEFAULT NULL -- Наименование атрибута
		p_domain_nso_id	id_t       DEFAULT NULL -- Идентификатор НСО домена
		p_attr_uuid       t_guid     DEFAULT NULL -- UUID атрибута
	Выходные параметры:	
		при успешном завершении:
                        rsp_main.rc   = <0>
                        rsp_main.errm = <Сообщение о успешности завершения>
		при неуспешном завершении:
			rsp_main.rc   = <-1>
			rsp_main.errm = <Сообщение об ошибке> 
-----------------------------------------------------------------------------------------------------------------------
	Особенности:
		могут быть обновлены в любом случае, вне зависимости от использования обновляемой записи:
			parent_attr_id -- Идентификатор родительского атрибута
			is_intra_op    -- Признак итраоперабельности
		если запись не используется в com.nso_column_header, ind.ind_type_header, возможно обновление:
			attr_type_id   -- Тип атрибута, с последующим обновлением small_code
			attr_code      -- Код атрибута
			attr_name      -- Наименование атрибута
		если запись не используется в com.nso_column_header, ind.ind_type_header, и тип данных равен t_ref:
			domain_nso_id  -- Идентификатор НСО домена
-------------------------------------------------------------------------------------------------------------------- */
DROP FUNCTION IF EXISTS com_domain.nso_p_domain_column_u (public.id_t, public.id_t, public.id_t, public.t_boolean, public.t_str60, public.t_str250, public.id_t, public.t_guid);
CREATE OR REPLACE FUNCTION com_domain.nso_p_domain_column_u (
           p_attr_id	     public.id_t	                 -- Идентификатор атрибута
          ,p_parent_attr_id  public.id_t      DEFAULT NULL -- Идентификатор родительского атрибута
          ,p_attr_type_id	 public.id_t      DEFAULT NULL -- Тип атрибута
          ,p_is_intra_op	 public.t_boolean DEFAULT NULL -- Признак итраоперабельности
          ,p_attr_code	     public.t_str60   DEFAULT NULL -- Код атрибута(новый)
          ,p_attr_name	     public.t_str250  DEFAULT NULL -- Наименование атрибута
          ,p_domain_nso_id	 public.id_t      DEFAULT NULL -- Идентификатор НСО домена
          ,p_attr_uuid       public.t_guid    DEFAULT NULL -- UUID атрибута
)
 RETURNS public.result_long_t
 SET search_path = com_domain, com, ind, nso, auth, public
 AS
 $$
    -- ================================================================================================================ 
    -- Author: Gregory
    -- Create date: 2015-06-19
    -- Description:	Обновление атрибута по идентификатору.
    -- 2015-08-15 Gregory: актуализация.
    -- 2016-03-22 Nick Гриша,солнце ясное и премудрое, я пол-дня потратил на то, что понять, почему не обновляется
    --                  атрибутный состав, вот оно что, ты заблокировал обновления, в том случае, если атрибут
    --                  уже используется. Давай откроем обновление имени, и будем выдавать частичное сообщение, о том,
    --                  что этот атрибут уже используется.
    -- ------------------------------------------------------------
    -- 2016-06-30 Gregory Обновление UUID записи в домене атрибутов
    -- 2016-08-22  Nick Домен колонок используется в auth.auth_role_attr
    -- ------------------------------------------------------------
    -- 2019-07-01 Nick Новое ядро
    -- ================================================================================================================ 
  DECLARE
   _in_nch public.t_boolean := FALSE; -- Используется в nso.nso_column_head
   _in_ith public.t_boolean := FALSE; -- Используется в ind.ind_type_header
   _in_rat public.t_boolean := FALSE; -- Используется в auth.auth_role_attr  Nick 2016-08-22
   _in_all public.t_boolean := FALSE; -- Общий признак Nick 2016-08-22
   -- ------------------------------------------------------------------------------
   _is_ref public.t_boolean := FALSE; -- Тип атрибута = 'T_REF'
  
   _attr_code	public.t_str60; -- Nick 2016-08-22 Код атрибута(новый)
  
   c_ERR_FUNC_NAME public.t_sysname := 'nso_p_domain_column_u';
   c_MESS000 public.t_str1024; -- Сообщение, Nick 2016-03-22
     
   rsp_main public.result_long_t;
      --
   _exception  public.exception_type_t;
   _err_args   public.t_arr_text := ARRAY [''];
  
  BEGIN
   IF p_attr_id IS NULL
    THEN
      RAISE SQLSTATE '60000'; -- NULL значения запрещены
   END IF;
     
   _attr_code := utl.com_f_empty_string_to_null (upper(btrim (p_attr_code))); -- Nick 2016-08-22 Код атрибута(новый)
  
   SELECT EXISTS (SELECT attr_id FROM ONLY nso.nso_column_head WHERE attr_id = p_attr_id LIMIT 1) INTO _in_nch;
   SELECT EXISTS (SELECT attr_id FROM ONLY ind.ind_type_header WHERE attr_id = p_attr_id LIMIT 1) INTO _in_ith;
   SELECT EXISTS (SELECT attr_id FROM ONLY auth.auth_role_attr WHERE attr_id = p_attr_id LIMIT 1) INTO _in_rat; -- Nick 2016-08-22
  
   _in_all := _in_nch OR _in_ith OR _in_rat;
  
  SELECT 'T_REF'::public.t_str60 = 
        (SELECT codif_code 
                  FROM ONLY com.obj_codifier WHERE (codif_id = p_attr_type_id)
        )::public.t_str60 INTO _is_ref;
     -- ---------------------------------------------------------------------------------------------------
     -- 2016-03-22 Nick. Если атрибут  уже используется, то режим частичного обновления, т.е обновляем
     --        parent_attr_id, is_intra_op, attr_name. Если атрибут не используется - то полное обновление   
     -- --------------------------------------------------------------------------------------------------- 
  IF ( _in_all ) THEN
          c_MESS000 := 'Успешно выполнено частичное обновление атрибута.';
  ELSE
          c_MESS000 := 'Успешно выполнено полное обновление атрибута.';
  END IF;
          
  UPDATE ONLY com.nso_domain_column
    SET
       parent_attr_id  = COALESCE ( p_parent_attr_id, parent_attr_id )    -- Эти три атрибута обновляются всегда
      ,is_intra_op     = COALESCE ( p_is_intra_op, is_intra_op )
      ,attr_name       = COALESCE ( btrim ( p_attr_name ), attr_name )
      ,attr_uuid       = COALESCE ( p_attr_uuid, attr_uuid )
         -- ------------------------------------------------------------------
         --  Остальные, только при условии "свободы" атрибута. Nick 2016-03-22    
         -- ------------------------------------------------------------------
      ,attr_type_id  = COALESCE ( CASE WHEN _in_all THEN NULL ELSE p_attr_type_id END, attr_type_id )
      ,small_code    = COALESCE ( CASE WHEN _in_all THEN NULL ELSE
  	                                 (SELECT small_code FROM ONLY com.obj_codifier WHERE codif_id = p_attr_type_id) END, small_code 
                         )
      ,attr_code       = COALESCE ( CASE WHEN _in_all THEN NULL ELSE _attr_code END, attr_code )  -- Nick 2016-08-22 Код атрибута(новый)
      ,domain_nso_id   = COALESCE ( CASE WHEN _is_ref IS FALSE OR _in_all THEN NULL ELSE p_domain_nso_id END, domain_nso_id )
      ,domain_nso_code = COALESCE (
                                    (SELECT nso_code FROM ONLY nso.nso_object
                                         WHERE nso_id = CASE WHEN _is_ref IS FALSE OR _in_all
                                                             THEN domain_nso_id ELSE p_domain_nso_id 
                                                        END), domain_nso_code 
                         )
  WHERE (attr_id = p_attr_id);
  
  IF FOUND
  THEN
      rsp_main.rc   := p_attr_id;
      rsp_main.errm := c_MESS000;
      
      RETURN rsp_main; -- Nick
  ELSE
      _err_args [1] := p_attr_id::text;
  	  RAISE SQLSTATE '61073'; -- Запись не найдена
  END IF;

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
 $$
LANGUAGE plpgsql 
SECURITY DEFINER; -- Nick 2016-02-26

COMMENT ON FUNCTION com_domain.nso_p_domain_column_u (public.id_t, public.id_t, public.id_t, public.t_boolean, public.t_str60, public.t_str250, public.id_t, public.t_guid)
IS '105: Обновление записи в домене атрибутов. Агрумент ID атрибута

	Аргументы:
		1) p_attr_id	    public.id_t                   -- Идентификатор атрибута
		2) p_parent_attr_id public.id_t      DEFAULT NULL -- Идентификатор родительского атрибута
		3) p_attr_type_id   public.id_t      DEFAULT NULL -- Тип атрибута
		4) p_is_intra_op    public.t_boolean DEFAULT NULL -- Признак итраоперабельности
		5) p_attr_code      public.t_str60   DEFAULT NULL -- Код атрибута(новый)
		6) p_attr_name      public.t_str250  DEFAULT NULL -- Наименование атрибута
		7) p_domain_nso_id  public.id_t      DEFAULT NULL -- Идентификатор НСО домена
		8) p_attr_uuid      public.t_guid    DEFAULT NULL -- UUID атрибута
		
	Выходные данные:
		1) result_t.rc      public.id_t                -- 0 при удачном завешении функции, в случае неудачи -1
		2) result_t.errm    public.t_text              -- Сообщение';
-- ------------------------------------------------------------------------------------
-- SELECT * FROM plpgsql_check_function_tb ('com_domain.nso_p_domain_column_u (id_t,id_t,id_t,t_boolean,t_str60,t_str250,id_t,t_guid)');
-- "nso_p_domain_column_u";25;"SQL statement";"42P01";"relation "auth.auth_role_attr" does not exist";"";"";"error";41;"SELECT EXISTS (SELECT attr_id FROM ONLY auth.auth_role_attr WHERE attr_id = p_attr_id LIMIT 1)"

-- SELECT * FROM com.nso_p_domain_column_u(NULL::id_t,NULL,NULL,NULL,NULL,NULL,NULL);
-- ------------------------------------------------------------------------------------
-- SELECT * FROM com.nso_f_domain_column_s('APP_NODE');
-- SELECT * FROM com.com_f_obj_codifier_s_sys ('C_ATTR_TYPE'); -- 15|4|'5'|'T_BOOLEAN'|'Логическое'
-- ------------------------------------------------------------------------------------------------
-- SELECT * FROM com.nso_f_domain_column_s('FC_FNAME');
-- SELECT * FROM com.nso_p_domain_column_u ( 13, NULL, 15, NULL, NULL, NULL, NULL, NULL); 'Необработанная ошибка: код = 42703, текст = колонка "_attr_id" не существует. Ошибка произошла в функции: "nso_p_domain_column_u".'
-- SELECT * FROM com.nso_f_domain_column_s(13);
-- -----------------------------------------------------------------------------
-- SELECT * FROM com.nso_p_domain_column_u(100500,NULL,NULL,NULL,NULL,NULL,NULL);

-- SELECT newid()
-- "e92e6ff2-318d-416c-ac89-7690321978d6"
-- SELECT * FROM com.nso_p_domain_column_i('APP_NODE', 't_str60', 'TEST_ATTR', 'Тест', 'e92e6ff2-318d-416c-ac89-7690321978d6');
-- 48;"Выполнено успешно"
-- SELECT * FROM ONLY com.nso_domain_column WHERE attr_code = 'TEST_ATTR';
-- SELECT * FROM com.nso_p_domain_column_u(48,3,19,false,'TEST_ATTR','Тест',NULL);
-- 48|3|'IC_IND_DATE_COMP'|'Тест'
-- -- SELECT * FROM nso.nso_p_domain_column_d(48);
-- -- 0;"Успешно удален атрибут"
-- SELECT * FROM com.nso_f_domain_column_s();
-- SELECT * FROM ONLY nso.nso_domain_column WHERE attr_code = 'FC_PHONE';
-- 25
-- SELECT * FROM nso.nso_p_domain_column_u(25,3,35,false,'FC_PHONE','Телефон',NULL);
-- _exec_str = UPDATE ONLY nso.nso_domain_column SET parent_attr_id=3,is_intra_op=false WHERE attr_id = 25
-- 0;"Успешно обновлен атрибут"

-- SELECT * FROM ONLY nso.nso_domain_column WHERE attr_code = 'FC_EXN';
-- 26
-- SELECT * FROM nso.nso_p_domain_column_u(26,3,36,false,'FC_EXN','Организация',14);
-- _exec_str = UPDATE ONLY nso.nso_domain_column SET parent_attr_id=3,is_intra_op=false WHERE attr_id = 26
-- 0;"Успешно обновлен атрибут."

-- SELECT * FROM com.nso_p_domain_column_u(43,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
-- -1;"Нет новых значений атрибута."
-- -1;"Нет новых значений атрибута."

-- SELECT * FROM ONLY com.nso_domain_column
