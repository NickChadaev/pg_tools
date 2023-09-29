--
--  2023-05-12
--
INSERT INTO fiscalization.fsc_org (	inn, nm_org_name, org_type )
	VALUES ('5036520080', 'ООО МосОблЕИРЦ',1); -- 125
	
SELECT * FROM fiscalization.fsc_org ORDER BY 1 DESC;

INSERT INTO fiscalization.fsc_app(app_guid, secret_key, nm_app, notification_url)
   VALUES ('0fe93f27-69b9-4462-816c-4d74120ecf94'
             ,'50dc7101885643498b9a18fb0696ec9a'  
             ,'ЛКА (ООО МосОблЕИРЦ)'                    -- "Личный кабинет МОЕ", 
             ,'email@ofd.ru'
       ); -- 67
--       
INSERT INTO fiscalization.fsc_app(app_guid, secret_key, nm_app, notification_url)
   VALUES ('90156209-3520-48b2-aa2f-43842a75ebf1'    
             ,'9afd85432cef41258ded2c379e2a4f83'
             ,'Приложение (ООО МосОблЕИРЦ)'             -- "Приложение МОЕ",
             ,'email@ofd.ru'
       ); -- 68
--  
INSERT INTO fiscalization.fsc_app(app_guid, secret_key, nm_app, notification_url)
   VALUES ('edc63d6a-2795-4203-bfb3-d7b54155d1b8'    
             ,'1d4f42e6417d4337b8d2657271fd1af0'
             ,'Ручная коррекция чека (ООО МосОблЕИРЦ)'  -- "Ручная корреция чека МОЕ"
             ,'email@ofd.ru'
       ); -- 69
------------       
-- UPDATE fiscalization.fsc_app 
--    SET nm_app = 'ЛКА (ООО МосОблЕИРЦ)'                    -- "Личный кабинет МОЕ", 
--        ,notification_url = 'email@ofd.ru'
-- WHERE ( id_app = 67); 
------------	   
	   
SELECT * FROM fiscalization.fsc_app order by 1 desc;		-- 67  
SELECT * FROM fiscalization.fsc_data_operator; -- 8 ПЕрвый ОФД

INSERT INTO fiscalization.fsc_org_app(id_org, id_app, id_fsc_data_operator) VALUES (125, 67, 8); -- МОЕ, ЛКА, Первый ОФД                -- 189
INSERT INTO fiscalization.fsc_org_app(id_org, id_app, id_fsc_data_operator) VALUES (125, 69, 8); -- МОЕ, Ручная коррекция, Первый ОФД   -- 190     
INSERT INTO fiscalization.fsc_org_app(id_org, id_app, id_fsc_data_operator) VALUES (125, 68, 8)  -- МОЕ, Приложение, Первый ОФД   
  RETURNING id_org_app;                                                                                                                  -- 191
-- ------------------------------------------------------
-- UPDATE fiscalization.fsc_org_app SET id_app = 69 WHERE (id_org_app = 190);
-- ------------------------------------------------------
SELECT * FROM fiscalization.fsc_org_app ORDER BY 1 DESC;

INSERT INTO fiscalization.fsc_app(app_guid, secret_key, nm_app, notification_url)
   VALUES ('a169ede2-5a71-4e1a-9fcf-c3ce5ea4cf0d'    
             ,'51b0d2217cbe451fa5a1358425bb22f1'
             ,'Приложение (АО "Тинькофф Банк" г. Москва)'             -- "Приложение ",
             ,'email@ofd.ru'
       ) RETURNING *;  -- 73
--
INSERT INTO fiscalization.fsc_app(app_guid, secret_key, nm_app, notification_url)
   VALUES ('9efcf754-1d35-4908-946a-ad54c35e13a0'    
             ,'660e8ab75c03413eb2bb1c0176ce17fd'
             ,'Приложение (Филиал ЛС 7701 Банка ВТБ (ПАО) г. Москва)'             -- "Приложение ",
             ,'email@ofd.ru'
       ) RETURNING *;  -- 72
--
INSERT INTO fiscalization.fsc_app(app_guid, secret_key, nm_app, notification_url)
   VALUES ('a0d95588-3599-4d65-8f6c-3a481f938a80'    
             ,'c99b29db16df4ed1afcf80ebe0da9d67'
             ,'Приложение (ФИЛИАЛ ЛС 3652 БАНКА ВТБ (ПАО) г. Воронеж)'             -- "Приложение ",
             ,'email@ofd.ru'
       ) RETURNING *;  -- 71
--
INSERT INTO fiscalization.fsc_app(app_guid, secret_key, nm_app, notification_url)
   VALUES ('212f1d68-88ee-4d14-882b-1c945bcc785b'    
             ,'4769a4eb45244cf68f1be90c3e6675d1'
             ,'Приложение (ФИЛИАЛ ЛС 2754 БАНКА ВТБ (ПАО) г. Хабаровск)'             -- "Приложение ",
             ,'email@ofd.ru'
       ) RETURNING *;  -- 70
--
-- ----------------------------------------------------------------------------------
--  SELECT * FROM fiscalization.fsc_org WHERE (inn IN ('7702070139', '7710140679'));
-------------------------------------------------------------------------------------
-- id_org	dt_create	dt_update	dt_remove	inn	nm_org_name	org_type	org_status	bik	nm_org_address	nm_org_phones
-- 136	2023-06-09 16:36:18	NULL	NULL	7710140679	АО "Тинькофф Банк" г. Москва	5	True	44525974	127287, г. Москва, ул. Хуторская 2-я, д. 38А, стр. 26	{"8 (800) 700-66-66"}
-- 141	2023-06-09 16:36:18	NULL	NULL	7702070139	Филиал ЛС 7701 Банка ВТБ (ПАО) г. Москва	5	True	44525745	107031, Москва, ул. Кузнецкий мост, д.17, стр. 1	{"+7 (495) 925-80-00"}
-- 142	2023-06-09 16:36:18	NULL	NULL	7702070139	ФИЛИАЛ ЛС 3652 БАНКА ВТБ (ПАО) г. Воронеж	5	True	42007855	394030, Воронеж, ул Кольцовская, 31	{"+7 (473) 235-60-00"}
-- 143	2023-06-09 16:36:18	NULL	NULL	7702070139	ФИЛИАЛ ЛС 2754 БАНКА ВТБ (ПАО) г. Хабаровск	5	True	40813713	680000, Хабаровск, ул. Муравьёва - Амурского, д. 18, пом. 0, 1	{"+7 (4212) 45-54-55"}
--
INSERT INTO fiscalization.fsc_org_app(id_org, id_app, id_fsc_data_operator) VALUES (136, 73, 8); -- МОЕ, ЛКА, Первый ОФД                -- 189
INSERT INTO fiscalization.fsc_org_app(id_org, id_app, id_fsc_data_operator) VALUES (141, 72, 8); -- МОЕ, Ручная коррекция, Первый ОФД   -- 190     
INSERT INTO fiscalization.fsc_org_app(id_org, id_app, id_fsc_data_operator) VALUES (142, 71, 8); 
INSERT INTO fiscalization.fsc_org_app(id_org, id_app, id_fsc_data_operator) VALUES (143, 70, 8); 
--
SELECT * FROM fiscalization.fsc_org_app order by 1 desc;
---------------------------------------------------------
-- id_org_app	id_org	id_app	dt_create	org_app_status	id_fsc_data_operator
-- 195	143	70	2023-07-17 17:40:26	True	8
-- 194	142	71	2023-07-17 17:40:22	True	8
-- 193	141	72	2023-07-17 17:40:18	True	8
-- 192	136	73	2023-07-17 17:40:15	True	8
-- 191	125	68	2023-07-17 13:48:00	True	8
-- 190	125	69	2023-05-12 16:17:10	True	8
-- 189	125	67	2023-05-12 16:17:04	True	8


