/*
	Входные параметры

   p_parent_nso_id        id_t                 null,       Идентификатор родительского НСО
   p_nso_type_id          id_t                 not null,   Тип НСО
   --
   p_nso_code             t_str60              not null,   Код НСО
   p_nso_name             t_str250             not null,   Наименование НСО
   p_nso_uuid             t_guid               not null,   UUID НСО
   --------  По умолчанию
   p_is_group_nso         t_boolean            not null default false,     Признак узлового НСО
   --
   p_date_from            t_timestamp          not null default CURRENT_TIMESTAMP::timestamp(0) without time zone,
   p_date_to              t_timestamp          not null default '9999-12-31 00:00:00'::timestamp(0) without time zone,
   p_date_create          t_timestamp          not null default CURRENT_TIMESTAMP::timestamp(0) without time zone,
);

	Выходные параметры
				  nso_id  - ID вновь созданного объекта процедура завершилась успешно
				 -1 - процедура завершилась с ошибкой, вывод ошибки
				
	Особенности
				Особенности создания НСО:
					При создании элемента НСО создается запись в таблице NSO_DOMAIN_COLUMN  с типом 'TGROUPATR'  
               и запись в таблице NSO_COLUMN_HEAD, с созданными ид из таблицы NSO_DOMAIN_COLUMN  (создание заголовка таблицы)
					Код атрибута формируется по правилам 'D_'+ код_НСО. 
					Наименование атрибута формируется по правилам 'Заголовок ' + имя_НСО
					Тип НСО определяется по родительскому узлу
				   Для генерации уидов используется функция newid().
*/
DROP FUNCTION IF EXISTS nso_structure.nso_p_object_i (public.t_str60, public.t_str60, public.t_str60, public.t_str250, public.t_guid, public.t_boolean, public.t_timestamp, public.t_timestamp);
CREATE OR REPLACE FUNCTION nso_structure.nso_p_object_i (       
                        p_parent_nso_code  public.t_str60   --  Код родительского НСО
                       ,p_nso_type_code    public.t_str60   --  Тип НСО
                       --
                       ,p_nso_code   public.t_str60    --  Код НСО
                       ,p_nso_name   public.t_str250   --  Наименование НСО
                       ,p_nso_uuid   public.t_guid     --  UUID НСО
                       --------  По умолчанию
                       ,p_is_group_nso public.t_boolean = FALSE  --   Признак узлового НСО
                       --
                       ,p_date_from  public.t_timestamp = now()::public.t_timestamp
                       ,p_date_to    public.t_timestamp = '9999-12-31 00:00:00'::public.t_timestamp
					   )  
 RETURNS public.result_long_t 
      SECURITY DEFINER -- 2015-04-05 Nick
      LANGUAGE plpgsql
      SET search_path = nso, com, utl, com_codifier, com_domain, nso_strucrure, com_error, public,pg_catalog
   AS 
$$
   -- =================================================================================== --
   -- Author:	SVETA                                                                      --
   -- Create date: 2013-09-05                                                             --
   -- Description:	Создание нового объекта нсо, перегрузка функции NSO_P_Object_I.        --
   --                В функции реализуется создание НСО  (не узловой нсо)                 --
   --                Nick 2013-10-17  Сначала код, потом имя                              --
   -- 2014-04-04 Anna строго больше 2 символов в имени и коде                             --
   -- ----------------------------------------------------------------------------------- --
   -- 2015_02_28  Создаётся объект любого типа: линейный, узловой.                        --
   --             Адаптация к домену EDB. Nick                                            --
   -- 2015_03_21  Появился краткий код атрибута                                           --
   -- 2015_04_26  NEWID() -- СОЗДАТЬ   У заголовка такой-же UUID, как у НСО ???           --
   -- 2016-05-15  Nick Забыты опции ONLY в SELECT и UPDATE.                               --
   -- 2017-11-30  Nick. Изменилось имя последовательности, но в функции осталось старое.  --
   -- ----------------------------------------------------------------------------------- --
   -- 2016-11-09  Gregory  Введено обращение к функции логгирования.                      --
   -- 2017-12-19  Gregory c_SEQ_NAME_NSO_LOG                                              --
   --                     nso.nso_log_id_log_seq -> com.all_history_id_seq.               --
   -- ----------------------------------------------------------------------------------- --
   -- 2019-07-11  Nick Новое ядро, новый атрибут "section_number".                        -- 
   -- 2019-07-17  Nick В момент создания объекта полагаем date_create = date_from         --
   -- =================================================================================== --
   
 DECLARE 
    c_ERR_FUNC_NAME              public.t_sysname = 'nso_p_object_i';
    c_SEQ_NAME_NSO_OBJ           public.t_sysname = 'nso.nso_object_nso_id_seq'; -- nso.nso_object_nso_id_seq
    c_SEQ_NAME_NSO_DOMAIN_COLUMN public.t_sysname = 'com.nso_domain_column_attr_id_seq'; -- com.nso_domain_column_attr_id_seq -- 32 символа  !!!

    c_TECH_NODE  public.t_str60 = 'NSO_TECH_NODE';
    c_CODIF_NODE public.t_str60 = 'C_DOMEN_NODE';

    c_MESS00  public.t_str1024 = 'Создание НСО выполнено успешно';  
    c_MESS01  public.t_str60   = 'D_'; 
    c_MESS02  public.t_str250  = 'Заголовок - ';
    --
    c_MESS03  public.t_code1  = '0'; 
    c_MESS13  public.t_code1  = '1';
    c_MESS04  public.t_str60  = 'Создан НСО: "';
    c_MESS05  public.t_str60  = ' - ';
    c_MESS06  public.t_str60  = '"';

    _parent_nso_id  public.id_t;
    _nso_type_id    public.id_t;
    _nso_id         public.id_t; 
    _attr_id        public.id_t; -- Домен колонок

    _attr_type_id     public.id_t;    -- Nick 2015-05-30
    _attr_type_scode  public.t_code1;

    _parent_nso_code  public.t_str60;   --  Код родительского НСО
    _nso_type_code    public.t_str60;   --  Тип НСО
    _nso_code         public.t_str60;   --  Код НСО
    _nso_name         public.t_str250;  
      
    rsp_main  public.result_long_t;
    --
    _exception  public.exception_type_t;
    _err_args   public.t_arr_text := ARRAY [''];
    --
    C_DEBUG public.t_boolean := utl.f_debug_status();
    
 BEGIN  
    IF (   (p_parent_nso_code IS NULL) 
        OR (p_nso_code        IS NULL) 
        OR (p_nso_name        IS NULL) 
        OR (p_nso_type_code   IS NULL)
        OR (p_nso_uuid        IS NULL)
        OR (p_is_group_nso    IS NULL)
        OR (p_date_from       IS NULL)
        OR (p_date_to         IS NULL)
       )
     THEN
       RAISE SQLSTATE '60000'; -- NULL значения запрещены
    END IF;
    --
    _parent_nso_code := utl.com_f_empty_string_to_null (upper( btrim (p_parent_nso_code)));   --  Код родительского НСО
    _nso_type_code   := utl.com_f_empty_string_to_null (upper( btrim (p_nso_type_code)));   --  Тип НСО
    _nso_code        := utl.com_f_empty_string_to_null (upper( btrim (p_nso_code)));   --  Код НСО
    _nso_name        := utl.com_f_empty_string_to_null (btrim (p_nso_name)); 
    --
	 IF ( NOT ( SELECT is_group_nso FROM ONLY nso.nso_object 
                  WHERE (nso_code = _parent_nso_code )
              )
                   OR
              ( NOT EXISTS (SELECT 1 FROM ONLY nso.nso_object 
                       WHERE (nso_code = _parent_nso_code )
                           )   
               ) 
            )
    THEN  -- Родительского НСО нет, либо он не узловой
             _err_args [1] := _parent_nso_code;
			 RAISE SQLSTATE '62003';
	 END IF;

    -- Nick 2016-05-15 Забыта опция ONLY
    _nso_type_id := com_codifier.com_f_obj_codifier_get_id (_nso_type_code);
    IF ( _nso_type_id IS NULL ) 
    THEN
         _err_args [1] := _parent_nso_code;
         RAISE SQLSTATE '62010';
    END IF;
      -- Nick 2019-07-14
    IF ( p_date_from > p_date_to ) THEN
        _err_args [1] := p_date_from::text;
        _err_args [2] := p_date_to::text;
        RAISE SQLSTATE '60005';
    END IF;  
    --
    _parent_nso_id := (SELECT n.nso_id FROM ONLY nso.nso_object n WHERE ( _parent_nso_code = n.nso_code));
	--
	IF C_DEBUG
	  THEN
	        RAISE NOTICE 
	          '<%>, parent_nso_id = "%", nso_type_id = "%", nso_code = "%", nso_name = "%", nso_uuid = "%", date_create = "%", date_from = "%", date_to = "%", p_is_group_nso = "%"'
	          , c_ERR_FUNC_NAME
	          , _parent_nso_id,_nso_type_id, _nso_code, _nso_name, p_nso_uuid, p_date_from, p_date_from, p_date_to, p_is_group_nso ;
	END IF;
	--
	INSERT INTO nso.nso_object (
                        parent_nso_id  --  Родительский НСО
                       ,nso_type_id    --  Тип НСО
                       --
                       ,nso_code     --  Код НСО
                       ,nso_name     --  Наименование НСО
                       ,nso_uuid     --  UUID НСО
                       --------    По умолчанию
                       ,date_create   -- Nick 2019-07-17
                       ,date_from    
                       ,date_to      
                       --
                       ,is_group_nso -- Признак узлового НСО
                       ,active_sign  -- Признак активного НСО 
                       ,id_log -- 2016-11-09 Gregory
     )
      VALUES (
                        _parent_nso_id  --  Код родительского НСО
                       ,_nso_type_id    --  Тип НСО
                       --
                       ,_nso_code      --  Код НСО
                       ,_nso_name      --  Наименование НСО
                       ,p_nso_uuid      --  UUID НСО    
                       ------           --  По умолчанию
                       ,p_date_from     -- Nick 2019-07-17
                       ,p_date_from    
                       ,p_date_to      
                       ------
                       ,p_is_group_nso -- Признак узлового НСО
                       ,TRUE -- Признак активного НСО. Гупповой/Узловой НСО всегда активен
                       ,nso.nso_p_nso_log_i ( 
                            CASE WHEN p_is_group_nso THEN c_MESS13 ELSE c_MESS03 END
                           ,c_MESS04 || _nso_code || c_MESS05 || _nso_name || c_MESS06 
                        ) -- 2016-11-09 Gregory
      );
    _nso_id := CURRVAL ( c_SEQ_NAME_NSO_OBJ );
    -- если нет ошибок, то создали объект.
    -- 
    --  Строка в журнале !!!!!! Не указан тип воздействия "impact_type".
    --
    -- 2016-11-09 Gregory  Убрано прямое обращение к LOG таблице.

    IF ( p_is_group_nso ) THEN
             rsp_main.rc   := _nso_id;
             rsp_main.errm := c_MESS00;
       RETURN rsp_main;
    END IF;

    -- 2016-05-16 Nick Забыта опция ONLY 
    SELECT codif_id, small_code FROM ONLY com.obj_codifier 
       INTO _attr_type_id, _attr_type_scode WHERE (codif_code = c_CODIF_NODE );    -- Тип узловой 

	 INSERT INTO com.nso_domain_column (
                                parent_attr_id     
                               ,attr_type_id    
                               ,small_code    
                               ,attr_uuid          
                               ,attr_code          
                               ,attr_name    
                               ,date_from          
                               ,date_to                                  
		)
			VALUES ( 
			        com_domain.com_f_domain_get_id (c_TECH_NODE)
                  ,_attr_type_id     -- Тип узловой 
                  ,_attr_type_scode  -- Тип узловой
                  ,p_nso_uuid -- NEWID() -- СОЗДАТЬ   У заголовка такой-же UUID, как у НСО ???    2015-04-26 
        	      ,(c_MESS01 || _nso_code)::public.t_str60
                  ,(c_MESS02 || _nso_name)::public.t_str250 -- все имена корневых атрибутов формирются по правилу "Заголовок" + название НСО
                  ,p_date_from    
                  ,p_date_to 
         );
   _attr_id := CURRVAL (c_SEQ_NAME_NSO_DOMAIN_COLUMN);  
   -- ------------------------------------------------------------------------------------------
   --  2019-07-14 В INSERT введена установка дат актуальности, в оригинальном проекте её не было
   -- ------------------------------------------------------------------------------------------
   INSERT INTO nso.nso_column_head (   attr_id       -- родитель у группового элемента = NULL
                                      ,nso_id     
                                      ,number_col    
                                      ,attr_scode
                                      ,col_code
                                      ,col_name
                                      ,date_from     -- Nick 2019-07-14     
                                      ,date_to                                       

    ) VALUES (   _attr_id
               ,_nso_id
               ,0          -- номер у группирирующих атрибутов = 0
               ,_attr_type_scode
               ,( c_MESS01 || _nso_code )::public.t_str60
			   ,( c_MESS02 || _nso_name )::public.t_str250 -- все имена корневых атрибутов формирются по правилу "Заголовок" + название НСО
               ,p_date_from    
               ,p_date_to 	 -- Nick 2019-07-14
    );         
	
   rsp_main.rc := _nso_id;
   rsp_main.errm := c_MESS00;
   
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
COMMENT ON FUNCTION  nso_structure.nso_p_object_i (public.t_str60, public.t_str60, public.t_str60, public.t_str250, public.t_guid, public.t_boolean, public.t_timestamp, public.t_timestamp) 
   IS '175: Cоздание нового НСО.
       	 Входные параметры:
                        p_parent_nso_code  public.t_str60   --  Код родительского НСО
                       ,p_nso_type_code    public.t_str60   --  Тип НСО
                       --
                       ,p_nso_code         public.t_str60    --  Код НСО
                       ,p_nso_name         public.t_str250   --  Наименование НСО
                       ,p_nso_uuid         public.t_guid     --  UUID НСО
                       --------  По умолчанию
                       ,p_is_group_nso public.t_boolean = FALSE  --   Признак узлового НСО
                       --
                       ,p_date_from  public.t_timestamp = CURRENT_TIMESTAMP::public.t_timestamp
                       ,p_date_to    public.t_timestamp = ''9999-12-31 00:00:00''::public.t_timestamp

          Выходные параметры
			      	  nso_id  - ID вновь созданного объекта процедура завершилась успешно
			      	 -1 - процедура завершилась с ошибкой, вывод ошибки

   '; -- Nick 2014-01-24
-- SELECT * FROM plpgsql_check_function_tb ('nso_structure.nso_p_object_i (public.t_str60, public.t_str60, public.t_str60, public.t_str250, public.t_guid, public.t_boolean) ');
--  'nso_structure.nso_p_object_i'|144|'SQL statement'|'42601'|'INSERT has more target columns than expressions'
/* --------------------------------------------------------------------------------------------------------------------------------------------------------- 
   Примеры использования:
        SELECT * FROM nso.nso_f_object_s_sys();
        SELECT * FROM nso.nso_f_object_s_sys ('NSO_CLASS');
        1) Хотел создать узел, но получился линейный элемент. Но у него тип - Узловой - исправить. 
	          SELECT * FROM nso.nso_p_object_i ( 'NSO_CLASS', 'C_NSO_NODE', 'CL_LOCAL', 'Локальные классификаторы', 'A4E3AD5F-33A0-497E-9237-3CC8745FCA5E'::uuid, true);
           --
        2) Создаю по настоящему узловой
             SELECT * FROM nso.nso_p_object_i ( 'NSO_CLASS', 'C_NSO_NODE', 'CL_ENTERPR', 'Ведомственные классификаторы', 'B40988A7-153A-4907-8B8D-3FB67DE33AC4'::uuid, true);
           --
        3) Создаю линейный классификатор
             SELECT * FROM nso.nso_p_object_i ( 'CL_LOCAL', 'C_NSO_CLASS', 'CL_TEST', 'Тестовый классификатор', '57F81F10-3AA4-4B08-A028-7A595CF8B8C1'::uuid );
             ALTER TABLE nso.nso_column_head ADD COLUMN attr_scode t_code1 NOT NULL;  -- Старый скрипт накатил ???
           --
        4) Создаю ТТХ, UUID - тот-же.
             SELECT * FROM nso.nso_p_object_i ( 'NSO_TTH', 'C_NSO_TTH', 'TC_TU4', 'ТТХ проекта ТУ-4', '2D79DFEA-EA9D-4489-AE1B-4A414F5159AA'::uuid );

        5) Ветка общероссийские классификаторы:
             SELECT * FROM nso.nso_p_object_i ( 'NSO_CLASS', 'C_NSO_NODE', 'CL_RF', 'Общероссийские классификаторы', 'd2e87126-b0bf-4809-8df5-d72d48b983b9'::uuid, true);
             
        6) Общероссийский классификатор единиц измерения CL_OKEI
             SELECT * FROM nso.nso_p_object_i ( 'CL_RF', 'C_NSO_CLASS', 'CL_OKEI', 'Общероссийский классификатор единиц измерения', 
             'DD82A0C1-04B4-4B45-84FA-65CE7B767D27'::uuid, FALSE, '2014-03-12 10:00:00');
               
        6) Общероссийский классификатор стран мира CL_OKSM
             SELECT * FROM nso.nso_p_object_i ( 'CL_RF', 'C_NSO_CLASS', 'CL_OKSM', 'Общероссийский классификатор стран мира', 
             '2239A530-0D51-43A3-BFBA-5A6EAE31DC0E'::uuid, FALSE, '2014-03-12 10:00:00' 
             );  

             SELECT * FROM nso.nso_log;   
             SELECT * FROM nso.nso_column_head;      
      ------------------------------
	'NSO_CLASS'|'Классификатор.'
	'NSO_NORM'|'Норматив.'
	'NSO_TTH'|'Тактико-технические характеристики.'
      ---------------------------------------------------------------------------------------------------------------------------------------------------------- */

