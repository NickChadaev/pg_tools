DROP VIEW IF EXISTS com.all_v_event_log_er; 
CREATE OR REPLACE VIEW com.all_v_event_log_er AS
	SELECT xc0.id_log,
    xc0.user_name,
    xc0.host_name,
    xc0.impact_date,
    lower((xc0.schema_name)::text) AS sch_name,
    xc0.impact_type,
        CASE xc0.impact_type
            WHEN '!'::bpchar THEN 'Ошибка при выполнении функции'::text
            ELSE NULL::text
        END AS i_descr,
    xc0.impact_descr
   FROM com.com_log_1 xc0
   WHERE (xc0.impact_type = '!')        
UNION ALL
 SELECT xn1.id_log,
    xn1.user_name,
    xn1.host_name,
    xn1.impact_date,
    lower((xn1.schema_name)::text) AS sch_name,
    xn1.impact_type,
        CASE xn1.impact_type
            WHEN '!'::bpchar THEN 'Ошибка при выполнении функции'::text
            ELSE NULL::text
        END AS i_descr,
    xn1.impact_descr
   FROM nso.nso_log_1 xn1
    WHERE (xn1.impact_type = '!')        
  ORDER BY 4 DESC;

COMMENT ON VIEW com.all_v_event_log_er IS '306: Журнал ошибок';

COMMENT ON COLUMN com.all_v_event_log_er.id_log       IS 'ID события';
COMMENT ON COLUMN com.all_v_event_log_er.user_name    IS 'Имя пользователя';
COMMENT ON COLUMN com.all_v_event_log_er.host_name    IS 'IP хоста';
COMMENT ON COLUMN com.all_v_event_log_er.impact_date  IS 'Дата события';
COMMENT ON COLUMN com.all_v_event_log_er.sch_name     IS 'Схема';
COMMENT ON COLUMN com.all_v_event_log_er.impact_type  IS 'Код воздействия, локальный в пределах схемы';
COMMENT ON COLUMN com.all_v_event_log_er.i_descr      IS 'Описание воздействия';
COMMENT ON COLUMN com.all_v_event_log_er.impact_descr IS 'Расширенное описание воздействия';

-- SELECT * FROM com.all_v_event_log_er WHERE (impact_date > '2020-01-02');
-- SELECT * FROM com.all_v_event_log_er WHERE (impact_date > '2020-01-02') AND (sch_name = 'com');
