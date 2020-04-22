-- ================================================================================= 
-- Author: Gregory  -- Дело премудрого Григория живее всех живых. Nick 2016-03-10.
-- Create date: 2015-07-02
-- Description:	Отображение таблицы nso.nso_log
-- 2016-11-12 Nick Модификация под новый стандарт.
-- 2016-11-25 Nick Перестройка функции, диапазон дат.
-- 2017-01-24 Nick Перестройка выходного набора. "IMPACT_DESCR" типа public.t_text
-- ================================================================================== 
/* ---------------------------------------------------------------------------------- 
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
		7) impact_descr t_text      -- Описание воздействия
------------------------------------------------------------------------------------- 
	Особенности: В качестве расшифрофки типа воздействия берется первое слово из описания воздействия
---------------------------------------------------------------------------------------------------- */
SET search_path = nso, public;

DROP FUNCTION IF EXISTS nso.nso_f_nso_log_s ( public.t_sysname, public.t_code1, public.t_timestamp, public.t_timestamp );
CREATE OR REPLACE FUNCTION nso.nso_f_nso_log_s (
        p_user_name    public.t_sysname   DEFAULT NULL -- Логин пользователя
       ,p_impact_type  public.t_code1     DEFAULT NULL -- Тип воздействия
       ,p_date_from    public.t_timestamp DEFAULT NULL -- Дата воздействия нижняя граница
       ,p_date_to      public.t_timestamp DEFAULT NULL -- Дата воздействия верхняя граница
) 
RETURNS TABLE (
        id_log       public.id_t        -- ID воздействия
       ,user_name    public.t_str250    -- Имя пользователя
       ,host_name    public.t_str250    -- Имя хоста
       ,impact_type  public.t_code1     -- Тип воздействия
       ,impact_info  public.t_str1024   -- Расшифровка типа воздействия
       ,impact_date  public.t_timestamp -- Дата воздействия
       ,impact_descr public.t_text      -- Описание воздействия -- Nick 2017-01-25
)
AS
 $$
  -- ================================================================================= 
  -- Author: Gregory  -- Дело премудрого Григория живее всех живых. Nick 2016-03-10.
  -- Create date: 2015-07-02
  -- Description:	Отображение таблицы nso.nso_log
  -- 2016-11-12 Nick Модификация под новый стандарт.
  -- 2016-11-25 Nick Перестройка функции, диапазон дат.
  -- 2017-01-24 Nick Перестройка выходного набора. "IMPACT_DESCR" типа public.t_text
  -- ================================================================================== 
   DECLARE
      _user_name public.t_sysname := btrim (p_user_name);
      _impact_type public.t_code1 := upper ( p_impact_type ); 
   BEGIN
   	RETURN QUERY
   		SELECT
   			 l.id_log::public.id_t 
   			,l.user_name
   			,l.host_name
            ,l.impact_type
            ,CASE l.impact_type
                WHEN '0'::public.t_code1 THEN 'Создание НСО '::public.t_str1024
                WHEN '1'::public.t_code1 THEN 'Активация НСО'::public.t_str1024
                WHEN '2'::public.t_code1 THEN 'Выключение (деактивация) НСО'::public.t_str1024
                WHEN '3'::public.t_code1 THEN 'Физическое удаление НСО, влечёт за собой событие "5"'::public.t_str1024
                WHEN '4'::public.t_code1 THEN 'Обновление данных, запись и ячейки'::public.t_str1024
                WHEN '5'::public.t_code1 THEN 'Удаление данных, запись и ячейки'::public.t_str1024
                WHEN '8'::public.t_code1 THEN 'Создание прототипа секции'::public.t_str1024
                WHEN 'X'::public.t_code1 THEN 'Создание новых данных, запись и ячейки'::public.t_str1024
                WHEN '9'::public.t_code1 THEN 'Создание  элемента заголовка'::public.t_str1024
                WHEN 'A'::public.t_code1 THEN 'Oбновление элемента заголовка (заменили один на другой) КОНТРОЛЬ ТИПОВ'::public.t_str1024
                WHEN 'B'::public.t_code1 THEN 'Удаление элемента   заголовка. ДАННЫЕ ПРОПАЛИ'::public.t_str1024
                WHEN 'C'::public.t_code1 THEN 'Создание заголовка  ключа'::public.t_str1024
                WHEN 'D'::public.t_code1 THEN 'Обновление заголовка ключа'::public.t_str1024
                WHEN 'E'::public.t_code1 THEN 'Удаление заголовка ключа, при этом УДАЛЯЮТСЯ элементы ключа и выполняется обновление соответсвующих полей в данных'::public.t_str1024
                WHEN 'F'::public.t_code1 THEN 'Создание элемента ключа'::public.t_str1024
                WHEN 'G'::public.t_code1 THEN 'Обновление элемента ключа МЕНЯЕМ ОДИН НА ДРУГОЙ'::public.t_str1024
                WHEN 'H'::public.t_code1 THEN 'Удаление элемента ключа'::public.t_str1024
                WHEN 'Y'::public.t_code1 THEN 'Экспорт объекта НСО'::public.t_str1024
                WHEN 'Z'::public.t_code1 THEN 'Импорт объекта НСО'::public.t_str1024
                WHEN 'I'::public.t_code1 THEN 'Включение контроля уникальности'::public.t_str1024
                WHEN 'J'::public.t_code1 THEN 'Выключение контроля уникальности'::public.t_str1024
                WHEN '!'::public.t_code1 THEN 'Неуспешное завершение функции'::public.t_str1024
                ELSE NULL::public.t_str1024
             END AS impact_info
            ,l.impact_date
   		,l.impact_descr
   		FROM nso.nso_log l
   		WHERE
                           (
                                   _user_name IS NULL
                                OR (
                                           _user_name IS NOT NULL
                                       AND btrim (l.user_name) = _user_name
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
SECURITY DEFINER -- 2015-04-05 Nick
LANGUAGE plpgsql;
COMMENT ON FUNCTION nso.nso_f_nso_log_s ( public.t_sysname, public.t_code1, public.t_timestamp, public.t_timestamp ) 
   IS '152: Отображение журнала учёта и изменений схемы NSO

   Входные параметры:
      1) p_user_name    public.t_str60     -- Логин пользователя                     DEFAULT NULL
      2) p_impact_type  public.t_code1     -- Тип воздействия                        DEFAULT NULL
      3) p_date_from    public.t_timestamp -- Дата воздействия, нижняя граница  >=   DEFAULT NULL
      4) p_date_to      public.t_timestamp -- Дата воздействия, верхняя граница <=   DEFAULT NULL

	Выходные параметры:
	
      1) id_log       public.id_t        -- ID воздействия
      2) user_name    public.t_str250    -- Имя пользователя
      3) host_name    public.t_str250    -- Имя хоста
      4) impact_type  public.t_code1     -- Тип воздействия
      5) impact_info  public.t_str1024   -- Расшифровка типа воздействия
      6) impact_date  public.t_timestamp -- Дата воздействия
      7) impact_descr public.t_text      -- Описание воздействия';
		
-- -----------------------------------------------------------------------------			
-- SELECT * FROM nso.nso_f_nso_log_s ( session_user::t_sysname );
-- SELECT * FROM nso.nso_f_nso_log_s (NULL, NULL, '2016-08-10', '2018-09-30');
