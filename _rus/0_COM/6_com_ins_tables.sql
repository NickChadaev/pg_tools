/*===================================================================================== */
/* DBMS name:      PostgreSQL 8                                                         */
/* Created on:     10.02.2015 18:25:11                                                  */
/*    2015-03-21 Появился частичный индекс на кратком коде                              */
/*    29.03.2015 18:19:37 Добавлен объект                                               */
/*    28.04.2015 Изменена иерархия объектов                                             */
/* ------------------------------------------------------------------------------------ */                                                               
/* 2015-05-28:  Добавлены атрибуты в Кодификатор                                        */                                                                
/*    Дата создания              date_create                                            */        
/*    Дата начала актуальности   date_from                                              */
/*    Дата конца актуальности    date_to                                                */
/*    UUID                       codif_uuid                                             */
/*              Добавлена nso_domain_column                                             */ 
/* 2015-06-05:  Добавлен атрибут impact_type d таблицу nso_domain_column_hist           */
/* ------------------------------------------------------------------------------------ */
/* 22.06.2015 15:15:34  obj_codifier, obj_object, nso_domain_column имеют               */
/*                      историю.                                                        */ 
/* ------------------------------------------------------------------------------------ */
/* Nick 2015-10-01 Кодификатор допускает одинаковые имена в различных ветках.           */
/*      add CONSTRAINT ak2_obj_codifier UNIQUE (codif_name, parent_codif_id)            */
/* ------------------------------------------------------------------------------------ */
/* Nick 2015-10-02 Добавлена таблица "Конфигурация ПТК"                                 */
/* Nick 2015-11-16  Добавлен атрибуты: "Объект-домен", "Тип объекта-потомка".           */
/* ------------------------------------------------------------------------------------ */
/* Nick 2015-12-30  Убрано                                                              */ 
/*     ALTER TABLE com_ptk_config ADD CONSTRAINT ak2_com_ptk_config UNIQUE (ptk_uuid)   */ 
/* ------------------------------------------------------------------------------------ */
/* Nick 2016-02-03  Выделено в отдельный файл                                           */                                      
/* ------------------------------------------------------------------------------------ */
/* 2016-11-07 Nick  Общая последовательность для исторических таблиц и LOG.             */
/*      Все LOG таблицы наследуют от "ALL_LOG".                                         */
/* ------------------------------------------------------------------------------------ */
/* 2016-11-12 Nick Пересмотрены  правила работы с LOG. id_log - должен быть уникальным. */
/*===================================================================================== */
SET search_path=com, public, pg_catalog;
--
--  2016-02-03 Nick
--
INSERT INTO com.com_log (  user_name      
                          ,host_name      
                          ,impact_type    
                          ,impact_date    
                          ,impact_descr   
)        
VALUES (      session_user::public.t_str250          
             ,COALESCE (utl.auth_f_get_user_attr_s ( SESSION_USER::public.t_sysname
         		                             ,'host'::public.t_sysname
         		                             , inet_client_addr ()
	      )::public.t_str250 , '/var/run/postgresql')::public.t_str250 
             ,'0'  -- создание записи в кодификаторе
             ,(CURRENT_TIMESTAMP::TIMESTAMP(0) WITHOUT TIME ZONE)
             ,'Начальное заполнение схемы COM, создание записи в кодификаторе'
    );
--
-- 2015-10-02 Nick
--
/*==============================================================*/
/* Table: obj_codifier                                          */
/*==============================================================*/

INSERT INTO com.obj_codifier (small_code, codif_code, codif_name, codif_uuid,  id_log)
 VALUES ( 'Z', 'C_CODIF_ROOT', 'Корневой экземпляр кодификатора', '1A3A6326-EC5E-429A-935D-5B59996E212E'::t_guid
          , CURRVAL('all_history_id_seq'::regclass)
);
--
INSERT INTO com.obj_codifier (parent_codif_id, small_code, codif_code, codif_name, codif_uuid,  id_log)
 VALUES ((SELECT codif_id FROM com.obj_codifier WHERE ( codif_code = 'C_CODIF_ROOT')), 
          'Y', 'C_OBJ_TYPE', 'Типы объектов', 'D9989755-CC3E-4E50-B293-337DC986B3FD'
         , CURRVAL('all_history_id_seq'::regclass)
);
INSERT INTO com.obj_codifier (parent_codif_id, small_code, codif_code, codif_name, codif_uuid,  id_log)
 VALUES ((SELECT codif_id FROM com.obj_codifier WHERE (codif_code = 'C_OBJ_TYPE')), 
          'v', 'C_NSO_TYPE', 'Объект НСО', 'A55A8C90-C73B-4C01-9167-EDF3A43CD717'
         , CURRVAL('all_history_id_seq'::regclass)
);
--
INSERT INTO com.obj_codifier (parent_codif_id, small_code, codif_code, codif_name, codif_uuid,  id_log)
 VALUES ((SELECT codif_id FROM com.obj_codifier WHERE ( codif_code = 'C_CODIF_ROOT')), 
          'X', 'C_ATTR_TYPE', 'Типы атрибутов', '2B5385A8-2C74-4B81-91E1-CFC524633D1C'
         , CURRVAL('all_history_id_seq'::regclass)
);
--
INSERT INTO com.obj_codifier (parent_codif_id, small_code, codif_code, codif_name, codif_uuid,  id_log)
 VALUES ((SELECT codif_id FROM com.obj_codifier WHERE ( codif_code = 'C_CODIF_ROOT')), 
          'W', 'C_KEY_TYPE', 'Типы ключей', '4DD3A974-AE6D-4B07-B021-AB75D3DDBD94'
         , CURRVAL('all_history_id_seq'::regclass)
);
-- ---------------------------------------------------------------------------------
INSERT INTO com.obj_codifier (parent_codif_id, small_code, codif_code, codif_name, codif_uuid,  id_log)
 VALUES ((SELECT codif_id FROM com.obj_codifier WHERE ( codif_code = 'C_NSO_TYPE')), 
          'V', 'C_NSO_NODE', 'Узловой НСО', 'A10B5017-BF64-4647-B4EF-F2A1E62492DA'
         , CURRVAL('all_history_id_seq'::regclass)
);
-- ---------------------------------------------------------------------------------
INSERT INTO com.obj_codifier (parent_codif_id, small_code, codif_code, codif_name, codif_uuid,  id_log)
 VALUES ((SELECT codif_id FROM com.obj_codifier WHERE (codif_code = 'C_ATTR_TYPE')), 
          'U', 'C_DOMEN_NODE', 'Узловой Атрибут', 'F5A782BA-6F11-4F96-978D-950E7C6D6792'
         , CURRVAL('all_history_id_seq'::regclass)
);
-- ---------------------------------------------------------------------------------
-- 2015-04-28 Nick
-- 
-- INSERT INTO com.obj_codifier (parent_codif_id, small_code, codif_code, codif_name, codif_uuid,  id_log)
--  VALUES ((SELECT codif_id FROM com.obj_codifier WHERE (codif_code = 'C_OBJ_TYPE')), 
--           't', 'C_EXN_TYPE', 'Объекты предметной области', 'CC2FED7D-52CF-4BC0-9D15-5FDC05B7DEB5'
--          , CURRVAL('all_history_id_seq'::regclass)
-- );
--
INSERT INTO com.obj_codifier (parent_codif_id, small_code, codif_code, codif_name, codif_uuid,  id_log)
 VALUES ((SELECT codif_id FROM com.obj_codifier WHERE (codif_code = 'C_OBJ_TYPE')), 
          'u', 'C_BD_TYPE', 'Объекты БД', '682A9C76-937B-4239-A3DF-2D5EECE3580C'
         , CURRVAL('all_history_id_seq'::regclass)
);
-- ---------------
-- 2015-09-15 Nick
-- ---------------
INSERT INTO com.obj_codifier (parent_codif_id, small_code, codif_code, codif_name, codif_uuid,  id_log)
 VALUES ((SELECT codif_id FROM com.obj_codifier WHERE (codif_code = 'C_CODIF_ROOT')), 
          '0', 'C_E_COPY_TYPE', 'Перечень типов электронных копий', 'AE17CB62-5908-43EF-901D-A6D5EDB46FAC'
         , CURRVAL('all_history_id_seq'::regclass)
);
--
-- SELECT * FROM com.obj_codifier; TRUNCATE com.obj_codifier;
--
INSERT INTO com.com_log (  user_name      
                          ,host_name      
                          ,impact_type    
                          ,impact_date    
                          ,impact_descr
)        
VALUES (      session_user::public.t_str250          
             ,COALESCE (utl.auth_f_get_user_attr_s ( SESSION_USER::public.t_sysname
         		                             ,'host'::public.t_sysname
         		                             , inet_client_addr ()
	      )::public.t_str250 , '/var/run/postgresql')::public.t_str250 
             ,'3'  -- cоздание атрибута в домене
             ,(CURRENT_TIMESTAMP::TIMESTAMP(0) WITHOUT TIME ZONE)
             ,'Начальное заполнение схемы COM, cоздание атрибута в домене'
    );
/*==============================================================*/
/* Table: nso_domain_column                                     */
/*==============================================================*/

INSERT INTO com.nso_domain_column (attr_type_id, small_code, attr_uuid, attr_code, attr_name, id_log)
VALUES (  (SELECT codif_id FROM com.obj_codifier WHERE (codif_code = 'C_DOMEN_NODE'))
         ,(SELECT small_code FROM com.obj_codifier WHERE (codif_code = 'C_DOMEN_NODE')) 
         ,'3CBE8729-1430-405F-8C3E-FE63D6D4A41B'
         ,'DOMAIN_NODE'
         ,'Корневой элемент списка атрибутов'
         , CURRVAL('all_history_id_seq'::regclass)
);
--
-- 2015-03-05
--
INSERT INTO com.nso_domain_column ( parent_attr_id, attr_type_id, small_code, attr_uuid, attr_code, attr_name, id_log)
VALUES (  (SELECT attr_id FROM com.nso_domain_column WHERE ( attr_code = 'DOMAIN_NODE'))
         ,(SELECT codif_id FROM com.obj_codifier WHERE (codif_code = 'C_DOMEN_NODE'))
         ,(SELECT small_code FROM com.obj_codifier WHERE (codif_code = 'C_DOMEN_NODE')) 
         ,'9375C59A-13D4-4F88-BA97-B2C3AA5949F8'
         ,'TECH_NODE'
         ,'Технические атрибуты'
         , CURRVAL('all_history_id_seq'::regclass)
); 
--
INSERT INTO com.nso_domain_column ( parent_attr_id, attr_type_id, small_code, attr_uuid, attr_code, attr_name, id_log)
VALUES (  (SELECT attr_id FROM com.nso_domain_column WHERE ( attr_code = 'DOMAIN_NODE'))
         ,(SELECT codif_id FROM com.obj_codifier WHERE (codif_code = 'C_DOMEN_NODE'))
         ,(SELECT small_code FROM com.obj_codifier WHERE (codif_code = 'C_DOMEN_NODE')) 
         ,'BF27E2D4-2188-4F01-B69B-53BABE869D8B'
         ,'APP_NODE'
         ,'Прикладные атрибуты'
         , CURRVAL('all_history_id_seq'::regclass)
);  
--
INSERT INTO com.nso_domain_column ( parent_attr_id, attr_type_id, small_code, attr_uuid, attr_code, attr_name, id_log)
VALUES (  (SELECT attr_id FROM com.nso_domain_column WHERE ( attr_code = 'TECH_NODE'))
         ,(SELECT codif_id FROM com.obj_codifier WHERE (codif_code = 'C_DOMEN_NODE'))
         ,(SELECT small_code FROM com.obj_codifier WHERE (codif_code = 'C_DOMEN_NODE')) 
         ,'555E2ECB-0FBD-49EB-9478-B55BA74ECA73'
         ,'NSO_TECH_NODE'
         ,'Технические атрибуты схемы NSO'
         , CURRVAL('all_history_id_seq'::regclass)
); 
--
INSERT INTO com.nso_domain_column ( parent_attr_id, attr_type_id, small_code, attr_uuid, attr_code, attr_name, id_log)
VALUES (  (SELECT attr_id FROM com.nso_domain_column WHERE ( attr_code = 'TECH_NODE'))
         ,(SELECT codif_id FROM com.obj_codifier WHERE (codif_code = 'C_DOMEN_NODE'))
         ,(SELECT small_code FROM com.obj_codifier WHERE (codif_code = 'C_DOMEN_NODE')) 
         ,'9DA79BD8-27FC-4C7B-A995-B8B6071C97D4'
         ,'IND_TECH_NODE'
         ,'Технические атрибуты схемы IND'
         , CURRVAL('all_history_id_seq'::regclass)
);  
----

INSERT INTO com.nso_domain_column ( parent_attr_id, attr_type_id, small_code, attr_uuid, attr_code, attr_name, id_log)
VALUES (  (SELECT attr_id FROM com.nso_domain_column WHERE ( attr_code = 'APP_NODE'))
         ,(SELECT codif_id FROM com.obj_codifier WHERE (codif_code = 'C_DOMEN_NODE'))
         ,(SELECT small_code FROM com.obj_codifier WHERE (codif_code = 'C_DOMEN_NODE')) 
         ,'E03B2083-550B-4DEF-AC29-3C4013D9DCDB'
         ,'NSO_APP_NODE'
         ,'Прикладные атрибуты схемы NSO'
         , CURRVAL('all_history_id_seq'::regclass)
); 
--
INSERT INTO com.nso_domain_column ( parent_attr_id, attr_type_id, small_code, attr_uuid, attr_code, attr_name, id_log)
VALUES (  (SELECT attr_id FROM com.nso_domain_column WHERE ( attr_code = 'APP_NODE'))
         ,(SELECT codif_id FROM com.obj_codifier WHERE (codif_code = 'C_DOMEN_NODE'))
         ,(SELECT small_code FROM com.obj_codifier WHERE (codif_code = 'C_DOMEN_NODE')) 
         ,'637A1331-12AA-4C46-BB5A-47D746A4EA22'
         ,'IND_APP_NODE'
         ,'Прикладные атрибуты схемы IND'
         , CURRVAL('all_history_id_seq'::regclass)
);  
--
-- SELECT setval('com.all_history_id_seq', MAX (id_log) + 1) FROM com.all_log; -- Nick 2016-11-12
--
-- select * from com.obj_codifier;
-- select * from com.all_log;