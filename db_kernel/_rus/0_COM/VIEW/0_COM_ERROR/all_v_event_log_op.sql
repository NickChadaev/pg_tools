DROP VIEW IF EXISTS com.all_v_event_log_op; 
CREATE OR REPLACE VIEW com.all_v_event_log_op AS
	SELECT xc0.id_log,
    xc0.user_name,
    xc0.host_name,
    xc0.impact_date,
    lower((xc0.schema_name)::text) AS sch_name,
    xc0.impact_type,
        CASE xc0.impact_type
            WHEN '0'::bpchar THEN 'Создание записи в кодификаторе'::text
            WHEN '1'::bpchar THEN 'Удаление записи в кодификаторе'::text
            WHEN '2'::bpchar THEN 'Обновление данных в кодификаторе'::text
            WHEN '3'::bpchar THEN 'Создание атрибута в домене'::text
            WHEN '4'::bpchar THEN 'Удаление атрибута из домена'::text
            WHEN '5'::bpchar THEN 'Обновление атрибута в домене'::text
            WHEN '6'::bpchar THEN 'Создание  объекта'::text
            WHEN '7'::bpchar THEN 'Обновление объекта'::text
            WHEN 'Q'::bpchar THEN 'Обновление объекта с изменением уровня секретности'::text
            WHEN '8'::bpchar THEN 'Удаление объекта'::text
            WHEN '9'::bpchar THEN 'Создание записи в конфигурации'::text
            WHEN 'A'::bpchar THEN 'Обновление записи в  конфигурации'::text
            WHEN 'B'::bpchar THEN 'Удаление записи в конфигурации'::text
            WHEN 'C'::bpchar THEN 'Установка текущей конфигурации'::text
            WHEN 'D'::bpchar THEN 'Экспорт ветви кодификатора в XML'::text
            WHEN 'E'::bpchar THEN 'Импорт ветви кодификатора из XML'::text
            WHEN 'F'::bpchar THEN 'Экспорт ветви домена колонки в XML'::text
            WHEN 'G'::bpchar THEN 'Импорт ветви домена колонки из XML'::text
            WHEN 'N'::bpchar THEN 'Выключение текущего ПТК'::text
            WHEN 'H'::bpchar THEN 'Установка текущего ПТК'::text
            WHEN 'I'::bpchar THEN 'Создание нового ПТК'::text
            WHEN 'J'::bpchar THEN 'Обновление ПТК'::text
            WHEN 'K'::bpchar THEN 'Удаление ПТК'::text
            WHEN 'L'::bpchar THEN 'Экспорт ПТК'::text
            WHEN 'M'::bpchar THEN 'Импорт ПТК'::text
            ELSE NULL::text
        END AS i_descr,
    ac0.object_id,
    ac0.object_name,
    xc0.impact_descr
   FROM (com.com_log_1 xc0
     LEFT JOIN LATERAL ( 
           SELECT 
             c0.id_log 
            ,c0.object_id
            ,c0.object_short_name AS object_name
           FROM com.obj_object_hist c0 WHERE (c0.id_log = xc0.id_log)
           
        UNION ALL
     
           SELECT 
             c1.id_log
            ,c1.object_id 
            ,c1.object_short_name AS object_name
           FROM com.obj_object c1 WHERE (c1.id_log = xc0.id_log)
           
        UNION ALL
        
         SELECT c2.id_log 
               ,c2.codif_id   AS object_id
               ,c2.codif_name AS object_name
           FROM com.obj_codifier c2 WHERE (c2.id_log = xc0.id_log)
           
        UNION ALL
        
         SELECT c3.id_log
            ,c3.attr_id   AS object_id
            ,c3.attr_name AS object_name
           FROM com.nso_domain_column c3 WHERE (c3.id_log = xc0.id_log)
           
--         UNION ALL
--          SELECT com_ptk_config.id_log,
--             com_ptk_config.ptk_config_id AS object_id,
--             com_ptk_config.ptk_name AS object_name
--            FROM com.com_ptk_config
      ) ac0 ON ((xc0.id_log::bigint) = (ac0.id_log)::bigint)
    )
      WHERE (xc0.impact_type <> '!')        
UNION ALL
 SELECT xn1.id_log,
    xn1.user_name,
    xn1.host_name,
    xn1.impact_date,
    lower((xn1.schema_name)::text) AS sch_name,
    xn1.impact_type,
        CASE xn1.impact_type
            WHEN '0'::bpchar THEN 'Создание НСО'::text
            WHEN '1'::bpchar THEN 'Активация НСО'::text
            WHEN '2'::bpchar THEN 'Выключение (деактивация) НСО'::text
            WHEN '3'::bpchar THEN 'Физическое удаление НСО, влечёт за собой событие ''5'''::text
            WHEN '4'::bpchar THEN 'Обновление данных, запись и ячейки'::text
            WHEN '5'::bpchar THEN 'Удаление данных, запись и ячейки'::text
            WHEN 'X'::bpchar THEN 'Создание новых данных, запись и ячейки'::text
            WHEN '9'::bpchar THEN 'Создание  элемента заголовка'::text
            WHEN 'A'::bpchar THEN 'Обновление элемента заголовка'::text
            WHEN 'B'::bpchar THEN 'Удаление элемента   заголовка'::text
            WHEN 'C'::bpchar THEN 'Создание заголовка  ключа'::text
            WHEN 'D'::bpchar THEN 'Обновление заголовка ключа'::text
            WHEN 'E'::bpchar THEN 'Удаление заголовка ключа, при этом УДАЛЯЮТСЯ элементы ключа и выполняется обновление соответсвующих полей в данных'::text
            WHEN 'F'::bpchar THEN 'Создание элемента ключа'::text
            WHEN 'G'::bpchar THEN 'Обновление элемента ключа'::text
            WHEN 'H'::bpchar THEN 'Удаление элемента ключа'::text
            WHEN 'Y'::bpchar THEN 'Экспорт объекта НСО'::text
            WHEN 'Z'::bpchar THEN 'Импорт объекта НСО'::text
            WHEN 'I'::bpchar THEN 'Включение контроля уникальности'::text
            WHEN 'J'::bpchar THEN 'Выключение контроля уникальности'::text
            WHEN '6'::bpchar THEN 'Создание простого представления'::text
            WHEN '7'::bpchar THEN 'Создание материализованного представления'::text
            ELSE NULL::text
        END AS i_descr,
    an1.object_id,
    an1.object_name,
    xn1.impact_descr
   FROM (nso.nso_log_1 xn1
     LEFT JOIN LATERAL ( 
                SELECT  n1.id_log
                       ,n1.nso_id AS object_id
                       ,(n1.nso_name)::public.t_fullname AS object_name
                FROM nso.nso_object n1 WHERE (n1.id_log = xn1.id_log)
                  
                  UNION ALL
                  
               SELECT n2.log_id AS id_log
                     ,n2.rec_id AS object_id
                     ,(nso_structure.nso_f_object_get_code(n2.nso_id))::public.t_fullname AS object_name
                 FROM nso.nso_record n2 WHERE (n2.log_id = xn1.id_log)
	   ) an1 ON (((xn1.id_log)::bigint = (an1.id_log)::bigint))
	  )
    WHERE (xn1.impact_type <> '!')        
  ORDER BY 4 DESC;

COMMENT ON VIEW com.all_v_event_log_op IS '317: Общая история операций';

COMMENT ON COLUMN com.all_v_event_log_op.id_log       IS 'ID события';
COMMENT ON COLUMN com.all_v_event_log_op.user_name    IS 'Имя пользователя';
COMMENT ON COLUMN com.all_v_event_log_op.host_name    IS 'IP хоста';
COMMENT ON COLUMN com.all_v_event_log_op.impact_date  IS 'Дата события';
COMMENT ON COLUMN com.all_v_event_log_op.sch_name     IS 'Схема';
COMMENT ON COLUMN com.all_v_event_log_op.impact_type  IS 'Код воздействия, локальный в пределах схемы';
COMMENT ON COLUMN com.all_v_event_log_op.i_descr      IS 'Описание воздействия';
COMMENT ON COLUMN com.all_v_event_log_op.object_id    IS 'ID объекта';
COMMENT ON COLUMN com.all_v_event_log_op.object_name  IS 'Имя объекта';
COMMENT ON COLUMN com.all_v_event_log_op.impact_descr IS 'Расширенное описание воздействия';

-- SELECT * FROM com.all_v_event_log_op WHERE (impact_date > '2020-01-02');  141 ms, 30 rows
-- SELECT * FROM com.all_v_event_log_op WHERE (impact_date > '2020-01-02') AND (sch_name = 'com');
-- SELECT * FROM com.com_f_all_log_s (p_date_from := '2020-01-01'); -- 106 ms 30 rows
