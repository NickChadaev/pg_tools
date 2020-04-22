          			SELECT  ( regexp_replace( auth_server_object_code , E'^\\w+\\.', '' )) AS constr_name
          				,auth_server_object_name
          				,auth_schema AS schemaname
          			FROM auth.auth_server_object
          			WHERE 	(auth_server_object_name ilike 'Первичный ключ:%') AND
          				(auth_schema = 'com')
          			ORDER BY schemaname, 1
--
          			SELECT  ( regexp_replace( auth_server_object_code , E'^\\w+\\.', '' )) AS constr_name
          				,auth_server_object_name
          				,auth_schema AS schemaname
          			FROM auth.auth_server_object
          			WHERE 	--(auth_server_object_name ilike 'Первичный ключ:%') AND
          				(auth_schema = 'com')
          			ORDER BY schemaname, 1   
          			--
-- 'ak1_com_notify'    |'Ограничение уникальности: com_notify(receiver_id, pk_rec_id, action_type_id, object_type_id, object_id)'|'com'
-- 'ak1_com_ptk_config'|'Ограничение уникальности: com_ptk_config(ptk_type_id, ptk_exn_id)'                                      |'com'
-- 'ak1_obj_codifier'  |'Ограничение уникальности: obj_codifier(codif_code)'                                                     |'com'
          			
   SELECT * FROM db_info.f_show_unique_descr('com', 'obj_codifier');   
   -----------------------------------------------------------------
-- 'com'|23762|'obj_codifier'|'Определяет наиболее фундаментальные свойства сущностей БД, к таким свойствам относятся: тип объекта, тип данных, константы'|3|'small_code'|'Краткий код'|24242|'ak3_obj_codifier'|'C_UNIQUE_INDEX'|'Ограничение уникальности атрибута "Краткий код"'
-- 'com'|23762|'obj_codifier'|'Определяет наиболее фундаментальные свойства сущностей БД, к таким свойствам относятся: тип объекта, тип данных, константы'|1|'codif_id'|'Идентификатор экземпляра'|24172|'pk_obj_codifier'|'C_PRIMARY_KEY'|'Первичный ключ Кодификатора'
-- 'com'|23762|'obj_codifier'|'Определяет наиболее фундаментальные свойства сущностей БД, к таким свойствам относятся: тип объекта, тип данных, константы'|9|'codif_uuid'|'UUID'|24162|'ak4_obj_codifier'|'C_UNIQUE_INDEX'|'Ограничение уникальности атрибута "UUID"'

   SELECT index_name, table_name,  attr_number, field_name, index_type 
         FROM db_info.f_show_unique_descr('com', 'obj_codifier') ORDER BY index_name, attr_number;   

   SELECT index_name, table_name,  attr_number, field_name, index_type 
         FROM db_info.f_show_unique_descr('com') ORDER BY index_name, attr_number;   
         
   SELECT index_name, table_name,  array_agg(field_name), attr_number, index_type 
         FROM db_info.f_show_unique_descr('com', 'obj_codifier') GROUP BY index_name, table_name, index_type, attr_number 
                                                 ORDER BY index_name, attr_number; 

   SELECT index_name, table_name,  string_agg (field_name, ', '), index_type 
         FROM db_info.f_show_unique_descr ('com', 'obj_codifier') GROUP BY index_name, table_name, index_type 
                                                 ORDER BY index_name 
 -- 'ak1_com_notify'    |'Ограничение уникальности: com_notify(receiver_id, pk_rec_id, action_type_id, object_type_id, object_id)'|'com'
-- 'ak1_com_ptk_config'|'Ограничение уникальности: com_ptk_config(ptk_type_id, ptk_exn_id)'                                      |'com'
-- 'ak1_obj_codifier'  |'Ограничение уникальности: obj_codifier(codif_code)'                                                     |'com'

    SELECT index_name 
           ,CASE index_type WHEN 'C_PRIMARY_KEY' THEN 'Первичный ключ: '
                            WHEN  'C_UNIQUE_INDEX' THEN 'Ограничение уникальности: '
                            ELSE  'Поисковый индекс: ' 
            END || table_name  || ' ('  || string_agg (field_name, ', ') || ')'
           ,index_type                    
         FROM db_info.f_show_unique_descr ('com', 'obj_codifier') GROUP BY index_name, table_name, index_type 
                                                 ORDER BY index_name           			

--
        WITH
	      pk_lst (  constr_name  
                       ,schemaname
                       ,auth_server_object_name
                       ,t1      -- Имя таблицы
                       ,c1      -- Имя столбца
                       ,c1_desc -- Описание солбца
              )
	      AS (SELECT
 		            z.index_name
                          , z.schema_name
       		          , CASE index_type WHEN 'C_PRIMARY_KEY' THEN 'Первичный ключ: '
                              WHEN  'C_UNIQUE_INDEX' THEN 'Ограничение уникальности: '
                              ELSE  'Поисковый индекс: ' 
                            END || table_name  || ' ('  || string_agg (field_name, ', ') || ')' AS auth_server_object_name
   	                 , z.table_name
                         , (string_agg (z.field_name::text, ', ')) AS field_name
                         , (string_agg (z.field_desc::text, ', ')) AS field_desc
                    FROM db_info.f_show_unique_descr ('com') z
                         WHERE (z.index_type = 'C_PRIMARY_KEY')
                          GROUP BY z.index_name, z.schema_name, z.table_name, z.index_type
                 ) SELECT * FROM pk_lst  

                SELECT schema_name
                     , obj_type
                     , obj_name           AS tablename
                     , column_name        AS columnname
                     , column_description AS description 
                          FROM db_info.f_show_col_descr () 
                                    WHERE (schema_name = ANY (ARRAY['com', 'nso', 'ind']))
                      UNION ALL
                      
                SELECT schema_name
                    , obj_type
                    , obj_name           AS tablename
                    , column_name        AS columnname
                    , column_description AS description 
                          FROM db_info.f_show_col_descr(p_object_type := 'v') 
                                    WHERE (schema_name = ANY (ARRAY['com', 'nso', 'ind']))
                      UNION ALL
                      
                SELECT schema_name
                     , obj_type
                     , obj_name           AS tablename
                     , column_name        AS columnname
                     , column_description AS description 
                          FROM db_info.f_show_col_descr(p_object_type := 'm')  
                                    WHERE (schema_name = ANY (ARRAY['com', 'nso', 'ind']))
                 ORDER BY 1, 2;
--                 
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++   
--
SELECT * FROM com.com_f_obj_codifier_s_sys(9);
			SELECT 	*
			FROM auth.auth_server_object
				INNER JOIN com.obj_codifier codifer ON (codifer.codif_id = auth_serv_object_type_id)
			WHERE (auth_server_object_name ilike 'Внешний ключ%') AND (codifer.codif_code = 'C_CHECK') AND
                              (auth_schema = 'com')
			ORDER BY schemanam

			SELECT 	 ( regexp_replace( auth_server_object_code , E'^\\w+\\.', '' ) )as constr_name
				,auth_server_object_name
				,auth_schema AS schemaname
			FROM auth.auth_server_object
				INNER JOIN com.obj_codifier codifer ON (codifer.codif_id = auth_serv_object_type_id)
			WHERE (auth_server_object_name ilike 'Внешний ключ%') AND (codifer.codif_code = 'C_CHECK') AND
                              (auth_schema = 'com')
			ORDER BY schemaname      

-- 'fk_auth_user_is_com_notify_receiver'            |'Внешний ключ: com_notify(receiver_id) -> auth_user(user_id)'            |'com'
-- 'fk_auth_user_is_com_notify_sender'              |'Внешний ключ: com_notify(sender_id) -> auth_user(user_id)'              |'com'
-- 'fk_com_notify_sch_ver_id_compare_is_sch_version'|'Внешний ключ: com_notify(sch_ver_id_compare) -> sch_version(version_id)'|'com'
-- 'fk_com_notify_sch_ver_id_is_sch_version'        |'Внешний ключ: com_notify(sch_ver_id) -> sch_version(version_id)'        |'com'

SELECT * FROM db_info.f_show_fk_descr ('com');
-- --------------------------------------------
-- 'com'|'com_notify'|'3381: Уведомления'|'fk_auth_user_is_com_notify_receiver'|''|6|'receiver_id'|t|'Идентификатор получателя (пользователя)' |'auth'|'auth_user'|'Пользователь'|1|'user_id'|t|'Идентификатор пользователя'|'RESTRICT'|'RESTRICT'|'6'|'1'
-- 'com'|'com_notify'|'3381: Уведомления'|'fk_auth_user_is_com_notify_sender'  |''|4|'sender_id'  |f|'Идентификатор отправителя (пользователя)'|'auth'|'auth_user'|'Пользователь'|1|'user_id'|f|'Идентификатор пользователя'|'RESTRICT'|'RESTRICT'|'4'|'1'

    SELECT constr_name 
           ,'Внешний ключ: ' || table_name  || '('  || string_agg (field_name, ', ') || ')' || 
           ' -> ' || ref_table || '(' || string_agg (ref_field_name, ', ') || ')' AS auth_server_object_name
           ,schema_name AS schemaname                  
         FROM db_info.f_show_fk_descr ('com') GROUP BY constr_name, table_name, ref_table, ref_field_name, schema_name 
                                                 ORDER BY constr_name	
--
		SELECT d.constr_name 
		     , d.schema_name     AS schemaname
             , 'Внешний ключ: ' || d.table_name  || '('  || string_agg (d.field_name, ', ') || 
               ')' || ' -> ' || d.ref_table || '(' || string_agg (d.ref_field_name, ', ') || 
               ')'               AS auth_server_object_name
		     , d.table_name      AS t1      -- Имя таблицы
		     , string_agg (d.field_name, ', ')     AS c1      -- Имя столбца
		     , string_agg (d.field_desc, ', ')     AS c1_desc -- Описание столбца
		     , d.ref_table       AS t2      -- Таблица-родитель
		     , string_agg (d.ref_field_name, ', ') AS c2      -- Столбец-родитель 
		     , string_agg (d.ref_field_desc, ', ') AS c2_desc -- Описание столбца-родителя
		 FROM db_info.f_show_fk_descr () d
		                 WHERE (d.schema_name = 'com') AND (d.constr_name = 'fk_nso_object_can_define_nso_domain_column')
		 GROUP BY d.constr_name, d.table_name, d.ref_table, 
		          d.ref_field_name, d.schema_name 
         ORDER BY d.constr_name	

SELECT * FROM db_info.f_show_fk_descr ('com', p_fk_name := 'fk_nso_object_can_define_nso_domain_column') ;
SELECT * FROM db_info.f_show_fk_descr ('com');


SELECT * FROM com.sys_errors WHERE ( message_out IS NULL) ORDER BY sch_name, constr_name;;
----------------------------------------------------------------------------------------------
-- 78|'23514'|''|'com'|'chk_com_log_impact_type'                   |'i'|'com_log'
-- 76|'23514'|''|'com'|'chk_sys_errors_operation_iud'              |'i'|'sys_errors'
-- --
-- 48|'23503'|''|'com'|'fk_nso_object_can_define_nso_domain_column'|'i'|'nso_domain_column'
-- 54|'23503'|''|'com'|'fk_nso_record_defines_object_secret_level' |'i'|'obj_object'
-- 55|'23503'|''|'com'|'fk_nso_record_is_owner_obj_object'         |'i'|'obj_object'
-- 69|'23503'|''|'com'|'fk_obj_codifier_can_defines_object_stype'  |'d'|'obj_codifier'
-- 59|'23503'|''|'com'|'fk_obj_codifier_can_defines_object_stype'  |'i'|'obj_object'
-- 56|'23503'|''|'com'|'fk_obj_codifier_defines_object_type'       |'i'|'obj_object'
-- 71|'23503'|''|'com'|'fk_obj_codifier_defines_object_type'       |'d'|'obj_codifier'
-- ------------------------------------------------------------------------------------
-- 77|'23514'|''|'nso'|'chk_nso_log_impact_type'                   |'i'|'nso_log'
-- -
-- 73|'23503'|''|'nso'|'fk_nso_object_can_define_nso_domain_column'|'d'|'nso_object'
-- 75|'23503'|''|'nso'|'fk_nso_record_defines_object_secret_level' |'d'|'nso_record'
-- 74|'23503'|''|'nso'|'fk_nso_record_is_owner_obj_object'         |'d'|'nso_record'         


                                                 		                                                       