/*==============================================================*/
/* DBMS name:      PostgreSQL 8                                 */
/* Created on:     10.02.2015 18:25:11                          */
/* 2015-09-30:     Добавлено заполнение журнала.   Nick         */ 
/* 2016-02-05      Изменён состав базисных документов. Nick     */ 
/* 2019-07-11      Секция                                       */
/*==============================================================*/

SET search_path=nso,com,public,pg_catalog;
-- ------------------------------------
-- 2016-11-12
-- ------------------------------------
INSERT INTO nso.nso_log (  user_name      
                          ,host_name      
                          ,impact_type    
                          ,impact_date    
                          ,impact_descr
                          ,schema_name
)        
VALUES (     current_user::public.t_str250          
             ,inet_client_addr()::public.t_str250              
             ,'0'  --  создание НСО 
             ,(CURRENT_TIMESTAMP::TIMESTAMP(0) WITHOUT TIME ZONE)
             ,'Начальное заполнение NSO_OBJECT'
             ,'nso'
    );

-- ------------
-- 2019-07-11 
-- ------------
INSERT INTO nso.nso_section (section_descr, log_id) 
   VALUES ('Общая секция, присутствует всегда', CURRVAL ('all_history_id_seq'::regclass));
    
/*==============================================================*/
/* Table: nso_object                                            */
/*==============================================================*/
-- DELETE FROM nso.nso_object;

-- 0)
INSERT INTO nso.nso_object (nso_type_id, nso_uuid, is_group_nso, nso_code, nso_name, id_log)
VALUES (
   (SELECT codif_id FROM ONLY com.obj_codifier WHERE ( codif_code = 'C_NSO_NODE')) 
  ,'C37C984F-5BA2-4109-BC7F-CDCEC3B07CA5'
  ,true
  ,'NSO_ROOT'
  ,'Корневой элемент'
  , CURRVAL('all_history_id_seq'::regclass)
);
-- 1)
INSERT INTO nso.nso_object (parent_nso_id, nso_type_id, nso_uuid, is_group_nso, nso_code, nso_name, id_log)
VALUES (
   (SELECT nso_id FROM ONLY nso.nso_object WHERE (nso_code = 'NSO_ROOT'))
  ,(SELECT codif_id FROM ONLY com.obj_codifier WHERE ( codif_code = 'C_NSO_NODE')) 
  ,'12E4C262-AD7F-437A-AF66-FE8D2B4C62D3'
  ,true
  ,'NSO_NORM'
  ,'Нормативный документ.'
  , CURRVAL('all_history_id_seq'::regclass)
);
-- 2)
INSERT INTO nso.nso_object (parent_nso_id, nso_type_id, nso_uuid, is_group_nso, nso_code, nso_name, id_log)
VALUES (
   (SELECT nso_id FROM ONLY nso.nso_object WHERE (nso_code = 'NSO_ROOT'))
  ,(SELECT codif_id FROM ONLY com.obj_codifier WHERE ( codif_code = 'C_NSO_NODE')) 
  ,'A096D692-2ACD-4900-8416-D22A2BB6D72A'
  ,true
  ,'NSO_TTH'
  ,'Нормативно-справочная информация.'
  , CURRVAL('all_history_id_seq'::regclass)
);
-- 3)
INSERT INTO nso.nso_object (parent_nso_id, nso_type_id, nso_uuid, is_group_nso, nso_code, nso_name, id_log)
VALUES (
   (SELECT nso_id FROM ONLY nso.nso_object WHERE (nso_code = 'NSO_ROOT'))
  ,(SELECT codif_id FROM ONLY com.obj_codifier WHERE ( codif_code = 'C_NSO_NODE')) 
  ,'86070D77-A807-4F85-84C4-5D80AC506923'
  ,true
  ,'NSO_CLASS'
  ,'Классификатор.'
  , CURRVAL('all_history_id_seq'::regclass)
);
-- 4)
INSERT INTO nso.nso_object (parent_nso_id, nso_type_id, nso_uuid, is_group_nso, nso_code, nso_name, id_log)
VALUES (
   (SELECT nso_id FROM ONLY nso.nso_object WHERE (nso_code = 'NSO_ROOT'))
  ,(SELECT codif_id FROM ONLY com.obj_codifier WHERE ( codif_code = 'C_NSO_NODE')) 
  ,'B57D1485-0816-48C3-A801-0A424E08FA1A'
  ,true
  ,'NSO_DIC'
  ,'Словарь.'
  , CURRVAL('all_history_id_seq'::regclass)
);
-- 5)
INSERT INTO nso.nso_object (parent_nso_id, nso_type_id, nso_uuid, is_group_nso, nso_code, nso_name, id_log)
VALUES (
   (SELECT nso_id FROM ONLY nso.nso_object WHERE (nso_code = 'NSO_ROOT'))
  ,(SELECT codif_id FROM ONLY com.obj_codifier WHERE ( codif_code = 'C_NSO_NODE')) 
  ,'BFFD15FD-6162-489E-B8E9-B848158894EC'
  ,true
  ,'NSO_UDF'
  ,'Унифицированная форма документа.'
  , CURRVAL('all_history_id_seq'::regclass)
);
-- 6) -- Был формуляр
INSERT INTO nso.nso_object (parent_nso_id, nso_type_id, nso_uuid, is_group_nso, nso_code, nso_name, id_log)
VALUES (
   (SELECT nso_id FROM ONLY nso.nso_object WHERE (nso_code = 'NSO_ROOT'))
  ,(SELECT codif_id FROM ONLY com.obj_codifier WHERE ( codif_code = 'C_NSO_NODE')) 
  ,'A17965D4-8661-4A35-9DEA-B46B930EA506'
  ,true
  ,'NSO_SPR'
  ,'Справочник'
  , CURRVAL('all_history_id_seq'::regclass)
);
-- 7)
INSERT INTO nso.nso_object (parent_nso_id, nso_type_id, nso_uuid, is_group_nso, nso_code, nso_name, id_log)
VALUES (
   (SELECT nso_id FROM ONLY nso.nso_object WHERE (nso_code = 'NSO_SPR'))
  ,(SELECT codif_id FROM ONLY com.obj_codifier WHERE ( codif_code = 'C_NSO_NODE')) 
  ,'FD52A781-0F5C-464B-9458-8372BDF9CC7E'
  ,true
  ,'SPR_LOCAL'
  ,'Локальные справочники'
  , CURRVAL('all_history_id_seq'::regclass)
);
-- ------------------------------------------------------------------
-- SELECT * FROM nso.nso_object;
