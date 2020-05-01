/* --------------------------------------------------------------------------------------------------------------------
	Входные параметры:
		1) p_impact_type   t_code1,   -- Тип воздействия
		2) p_impact_descr  t_str1024  -- Описание воздействия
	Выходные параметры:
		1) id_t -- Идентификатор новой записи
-------------------------------------------------------------------------------------------------------------------- */
DROP FUNCTION IF EXISTS com.com_p_com_log_i ( public.t_code1, public.t_text );
CREATE OR REPLACE FUNCTION com.com_p_com_log_i (
  	 p_impact_type   public.t_code1  -- Тип воздействия
	,p_impact_descr  public.t_text  -- Описание воздействия
)

RETURNS public.id_t 
SET search_path = com, public
AS 
 $$
-- ====================================================================================================================
-- Author: Gregory
-- Create date: 2015-06-28
-- Description:	Создание записи com.com_log
-- 2016-12-22 Nick CURRENT_USER заменён SESSION_USER. Использована функция auth.auth_f_get_user_attr_s ()
-- 2018-02-20 Nick Избавление от DEFAULT в INSERT.
-- 2019-05-24 Nick Новое ядро
-- 2020-05-01 Nick Модификация, имя схемы (обязятельно), т.к. больше нет значений по умолчанию
-- ====================================================================================================================
  DECLARE
        с_HOST         public.t_sysname := 'host';
        c_SOCKET_NAME  public.t_str250  := '/var/run/postgresql';
        _id_log        public.id_t;

  BEGIN
	INSERT INTO com.all_log_1 (schema_name, user_name, host_name, impact_type, impact_date, impact_descr)
    VALUES (
                  'com'::public.t_sysname
         		 ,SESSION_USER::public.t_str250 				   -- user_name
         		 -- Потенциально здесь ошибка
         		,COALESCE (utl.auth_f_get_user_attr_s ( SESSION_USER::public.t_sysname
         		                             ,с_HOST::public.t_sysname
         		                             , inet_client_addr ()
			)::public.t_str250 , c_SOCKET_NAME)::public.t_str250         -- host_name  inet_client_addr()
         		,p_impact_type 			    -- impact_type
         		,now()::public.t_timestamp  -- impact_date
         		,btrim (p_impact_descr)		-- impact_descr
	)
     RETURNING id_log INTO _id_log;
     
   RETURN _id_log;
  END;
 $$
LANGUAGE plpgsql SECURITY DEFINER;
COMMENT ON FUNCTION com.com_p_com_log_i ( public.t_code1, public.t_text ) IS '318: Создание записи в LOG
	Входные параметры:
		1) p_impact_type  public.t_code1,  -- Тип воздействия
		2) p_impact_descr public.t_text    -- Описание воздействия

	Выходные параметры:
		1) public.id_t -- Идентификатор новой записи';

-- SELECT com.com_p_com_log_i(NULL, NULL);
-- SELECT com.com_p_com_log_i(NULL, '');
-- SELECT com.com_p_com_log_i('', NULL);
-- SELECT com.com_p_com_log_i('', '');
-- SELECT com.com_p_com_log_i('0', 'Тестирование функции com_p_com_log_i.');
-- SELECT * FROM com.com_f_com_log_s ();
