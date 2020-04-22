/* ------------------------------------------------------------------------------------------------------------------
	Входные параметры:
		1) p_user_name    t_str60     -- Логин пользователя
		2) p_impact_type  t_code1     -- Тип воздействия
      3) p_date_from    t_timestamp -- Дата воздействия, нижняя граница
      4) p_date_to      t_timestamp -- Дата воздействия, верхняя граница

	Выходные параметры:
		1) id_log       id_t        -- ID воздействия
		2) user_name    t_str250    -- Имя пользователя
		3) host_name    t_str250    -- Имя хоста
		4) impact_type  t_code1     -- Тип воздействия
		5) impact_info  t_str1024   -- Расшифровка типа воздействия
		6) impact_date  t_timestamp -- Дата воздействия
		7) impact_descr t_str1024   -- Описание воздействия
        Особенности: поддерживает произвольный набор входных параметров
   ------------------------------------------------------------------------------------------------------------------ */
DROP FUNCTION IF EXISTS com.com_f_com_log_s ( public.t_sysname, public.t_code1, public.t_timestamp, public.t_timestamp );

CREATE OR REPLACE FUNCTION com.com_f_com_log_s (
        p_user_name   public.t_sysname   DEFAULT NULL -- Логин пользователя
       ,p_impact_type public.t_code1     DEFAULT NULL -- Тип воздействия
       ,p_date_from   public.t_timestamp DEFAULT NULL -- Дата воздействия нижняя граница
       ,p_date_to     public.t_timestamp DEFAULT NULL -- Дата воздействия верхняя граница
) 
RETURNS TABLE(
	id_log       public.id_t        -- ID воздействия
       ,user_name    public.t_str250    -- Имя пользователя
       ,host_name    public.t_str250    -- Имя хоста
       ,impact_type  public.t_code1     -- Тип воздействия
       ,impact_info  public.t_str1024   -- Расшифровка типа воздействия
       ,impact_date  public.t_timestamp -- Дата воздействия
       ,impact_descr public.t_text      -- Описание воздействия -- nick 2017-01-24
)
 SET search_path = com, public
 AS
$$
  -- ===============================================================================================
  -- Author: Gregory
  -- Create date: 2016-11-11
  -- Description:	Отображение журнала учёта и изменений схемы COM
  -- -----------------------------------------------------------------------------------------------
  -- 2016-11-12 Nick id_log вместо order_number.  Сохраняем традиции.
  -- 2016-11-25 Nick Перестройка функции, диапазон дат.
  -- 2017-01-24 Nick Перестройка выходного набора. "IMPACT_DESCR" типа public.t_text
  -- 2019-05-24 Nick Новое ядро 
  -- ===============================================================================================
  DECLARE
        _user_name    public.t_sysname := btrim (p_user_name);
        _impact_type  public.t_code1   := p_impact_type; 
        
  BEGIN
	RETURN QUERY
		SELECT
                 l.id_log::id_t
                ,l.user_name
                ,l.host_name
                ,l.impact_type
                ,CASE l.impact_type
                     WHEN '0'::public.t_code1 THEN 'Создание записи в кодификаторе'
                     WHEN '1'::public.t_code1 THEN 'Удаление записи в кодификаторе'
                     WHEN '2'::public.t_code1 THEN 'Обновление данных в кодификаторе'
                     --
                     WHEN '3'::public.t_code1 THEN 'Создание атрибута в домене'
                     WHEN '4'::public.t_code1 THEN 'Удаление атрибута из домена'
                     WHEN '5'::public.t_code1 THEN 'Обновление атрибута в домене'
                     --
                     WHEN '6'::public.t_code1 THEN 'Создание  объекта'
                     WHEN '7'::public.t_code1 THEN 'Обновление объекта'
                     WHEN 'Q'::public.t_code1 THEN 'Обновление объекта  с изменением уровня секретности'
                     WHEN '8'::public.t_code1 THEN 'Удаление объекта'
                     WHEN '9'::public.t_code1 THEN 'Создание записи в конфигурации'
                     --
                     WHEN 'A'::public.t_code1 THEN 'Обновление записи в конфигурации'
                     WHEN 'B'::public.t_code1 THEN 'Удаление записи в конфигурации'
                     WHEN 'C'::public.t_code1 THEN 'Установка текущей конфигурации'
                     --
                     WHEN 'D'::public.t_code1 THEN 'Экспорт ветви кодификатора в XML'
                     WHEN 'E'::public.t_code1 THEN 'Импорт ветви кодификатора из XML'
                     --
                     WHEN 'F'::public.t_code1 THEN 'Экспорт ветви домена колонки в XML'
                     WHEN 'G'::public.t_code1 THEN 'Импорт ветви домена колонки из XML'
                     --
                     WHEN 'N'::public.t_code1 THEN 'Выключение текущего ПТК'
                     WHEN 'H'::public.t_code1 THEN 'Установка текущего ПТК'
                     WHEN 'I'::public.t_code1 THEN 'Создание нового ПТК'
                     WHEN 'J'::public.t_code1 THEN 'Обновление ПТК'
                     WHEN 'K'::public.t_code1 THEN 'Удаление ПТК'
                     --
                     WHEN 'L'::public.t_code1 THEN 'Экспорт ПТК' -- Nick 2017-01-24
                     WHEN 'M'::public.t_code1 THEN 'Импорт ПТК'

                     WHEN '!'::public.t_code1 THEN 'Неуспешное завершение функции'
                     ELSE 
                        NULL::public.t_str1024
                 END::public.t_str1024 AS impact_info
                ,l.impact_date
                ,l.impact_descr::public.t_text
		FROM com.com_log l
		WHERE   
                    (
                            _user_name IS NULL
                         OR (
                                    _user_name IS NOT NULL
                                AND l.user_name = _user_name
                            )
                    )
                AND (
                            _impact_type IS NULL
                         OR (
                                    _impact_type IS NOT NULL
                                AND l.impact_type = _impact_type
                            )
                    )   -- 2016-11-25 Nick
                AND (
                            p_date_from IS NULL
                         OR (
                                    p_date_from IS NOT NULL
                                AND l.impact_date >= p_date_from
                            )
                    )
                AND (
                            p_date_to IS NULL
                         OR (
                                    p_date_to IS NOT NULL
                                AND l.impact_date <= p_date_to
                            )
                    )
		ORDER BY l.impact_date DESC;
  END;
$$
 STABLE SECURITY INVOKER
 LANGUAGE plpgsql;
 
COMMENT ON FUNCTION com.com_f_com_log_s ( public.t_sysname, public.t_code1, public.t_timestamp, public.t_timestamp )
IS '40: Отображение журнала учёта и изменений схемы COM

	Входные параметры:
	 1) p_user_name    public.t_sysname   -- Логин пользователя                     DEFAULT NULL
	 2) p_impact_type  public.t_code1     -- Тип воздействия                        DEFAULT NULL
         3) p_date_from    public.t_timestamp -- Дата воздействия, нижняя граница  >=   DEFAULT NULL
         4) p_date_to      public.t_timestamp -- Дата воздействия, верхняя граница <=   DEFAULT NULL

	Выходные параметры:
		1) id_log         public.id_t        -- ID воздействия
		2) user_name      public.t_str250    -- Имя пользователя
		3) host_name      public.t_str250    -- Имя хоста
		4) impact_type    public.t_code1     -- Тип воздействия
		5) impact_info    public.t_str1024   -- Расшифровка типа воздействия
		6) impact_date    public.t_timestamp -- Дата воздействия
		7) impact_descr   public.t_text      -- Описание воздействия
    ';
-- -------------------------------------------------------------------------------------------------------
-- SELECT * FROM com.com_log -- 13 ms 18 r
-- SELECT * FROM com.com_f_com_log_s ( ); -- 23 ms 18 r
-- SELECT * FROM com.com_f_com_log_s ( session_user::t_sysname); -- 24 ms 18 r
-- SELECT * FROM com.com_f_com_log_s ( session_user::t_sysname, '3' ); -- 13 ms 8 r
-- SELECT * FROM com.com_f_com_log_s ( session_user::t_sysname, '3', '2016-10-06 12:28:04'); -- 13 ms 8 r
-- SELECT * FROM com.com_f_com_log_s ( NULL, '0', '2015-10-06', '2019-10-20'); -- 23 ms 10 r
-- SELECT * FROM com.com_f_com_log_s ( NULL, NULL, '2016-10-06 12:28:04'); -- 13 ms 18 r
-- SELECT * FROM com.com_f_com_log_s ( NULL, '0'); -- 13 ms 10 r
-- SELECT * FROM com.com_f_com_log_s ( session_user::t_sysname, NULL, '2016-10-06 12:28:04'); -- 63 ms 3 r
-- SELECT * FROM com.com_f_com_log_s ( ) WHERE impact_date < '2016-02-29'; -- 5626 ms 23254 r

-- -----------------------------------------------------------------------------
-- SELECT * FROM com.com_f_com_log_s(current_user::t_str250); -- 7622 ms 71815 r
-- SELECT * FROM com.com_f_com_log_s(NULL); -- 7794 ms 71815 r
