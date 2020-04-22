/* ----------------------------------------------------------------------------------------------------------------- 
	Входные параметры:
		1) p_impact_type   t_code1,   -- Тип воздействия
		2) p_impact_descr  t_str1024  -- Описание воздействия
	Выходные параметры:
		1) bigint -- Идентификатор новой записи
   ----------------------------------------------------------------------------------------------------------------- */
DROP FUNCTION IF EXISTS nso.nso_p_nso_log_i ( public.t_code1, public.t_text );
CREATE OR REPLACE FUNCTION nso.nso_p_nso_log_i(
	p_impact_type  public.t_code1   -- Тип воздействия
	,p_impact_descr public.t_text    -- Описание воздействия
)
   RETURNS public.id_t 
   SET search_path = nso, public, pg_catalog
  AS 
  $$
      -- ================================================================================================================= 
      -- Author: Gregory
      -- Create date: 2015-08-28
      -- Description:	Создание записи nso.nso_log
      -- -------------------------------------------------------------------------------------------------------------- --
      -- Modification: 2015-09-11 Уникальной записи в session_nso_log основано на прадигме: "Один пользователь с одного --
      --                       рабочего места выполняет одну прикладную транзакцию изменяющую состояние НСО.            --
      --                       Это вполне допустимо для НСО, которая является схемой, работающей в основном на "чтение".--
      -- -------------------------------------------------------------------------------------------------------------- --
      -- Modification: 2015-09-13  Версия с txid_current, запасной вариант pg_backend_pid.                              --
      -- -------------------------------------------------------------------------------------------------------------- --
      -- 2016-12-22 Nick CURRENT_USER заменён SESSION_USER. Использована функция auth.auth_f_get_user_attr_s ()         -- 
      -- -----------------------------------------------------------------------------------------------------------------
      -- 2016-11-07 Nick Новая последовательность для LOG таблиц                                                        --  
      -- -------------------------------------------------------------------------------------------------------------- --
      -- 2016-12-21 Nick  Убран Exception.                                                                              --
      -- -------------------------------------------------------------------------------------------------------------- --
      -- 2016-12-22 Nick Использована функция auth.auth_f_get_user_attr_s ()   для определения IP- адреса клиента.      -- 
      -- ================================================================================================================= 
      -- 2017-01-24 Nick "p_impact_descr"  t_text                                                                       --
      -- -------------------------------------------------------------------------------------------------------------- --
      -- 2018-06-28 Nick Отладочный вывод входных параметров.                                                           --
      -- ============================================================================================================== -- 
    DECLARE
       _tx_id              public.id_t;
       _log_id             public.id_t;
       c_SEQ_NAME_NSO_LOG  public.t_sysname = 'com.all_history_id_seq';
       с_HOST              public.t_sysname = 'host';
       
    BEGIN
      -- Nick 2018-06-28
      IF (utl.f_debug_status())
        THEN
               RAISE NOTICE '<nso_p_nso_log_i> %, %', p_impact_type, p_impact_descr;
      END IF;
      -- Nick 2018-06-28
      IF NOT EXISTS
      (
          SELECT 1 FROM pg_type
              WHERE typname = 'session_nso_log' AND typnamespace = pg_my_temp_schema()
      )
      THEN
              CREATE TEMPORARY TABLE session_nso_log
              (
                      tx_id  public.id_t PRIMARY KEY
                     ,log_id public.id_t DEFAULT NULL
              )
              WITHOUT OIDS
              ON COMMIT PRESERVE ROWS;
      END IF;
      _tx_id = txid_current();
      --
      SELECT log_id INTO _log_id FROM session_nso_log WHERE tx_id = _tx_id;
      IF _log_id IS NULL
      THEN
          INSERT INTO nso.nso_log (user_name, host_name, impact_type, impact_date, impact_descr) 
            VALUES
              (
       	   	     SESSION_USER::public.t_str250  		 -- user_name  -- Nick 2016-1107
                ,utl.auth_f_get_user_attr_s ( SESSION_USER::public.t_sysname
                                            , с_HOST::public.t_sysname
                                            , inet_client_addr ()
                 )::public.t_str250 --  
                ,p_impact_type					  -- impact_type
                ,now()::public.t_timestamp -- impact_date
                ,btrim (p_impact_descr)					  -- impact_descr
        	);
            _log_id = CURRVAL(c_SEQ_NAME_NSO_LOG);
            INSERT INTO session_nso_log VALUES(_tx_id, _log_id);
  	  END IF;
  	  
      RETURN _log_id;
    END;
  $$
LANGUAGE plpgsql 
SECURITY DEFINER;
COMMENT ON FUNCTION nso.nso_p_nso_log_i(public.t_code1,public.t_text ) IS '150: Создание записи в журнале учёта изменений 
	Входные параметры:
		1) p_impact_type  t_code1,  -- Тип воздействия
		2) p_impact_descr t_text    -- Описание воздействия
	Выходные параметры:
		1) bigint -- Идентификатор новой записи';


-- -----------------------------------------------------
-- SELECT * FROM plpgsql_check_function_tb ('nso.nso_p_nso_log_i(public.t_code1,public.t_text)');
-- ERROR:  improper qualified name (too many dotted names): nso.nso_p_nso_log_i(public.t_code1,public.t_text)
-- КОНТЕКСТ:  PL/pgSQL function parse_ident(text) line 3 at RETURN
-- SQL statement "SELECT parse_ident($1)"
-- PL/pgSQL function __plpgsql_check_getfuncid(text) line 4 at PERFORM

-- SELECT * FROM plpgsql_show_dependency_tb ('nso.nso_p_nso_log_i(public.t_code1,public.t_text)');
-- SELECT * FROM plpgsql_check_function_tb ('com.com_p_com_log_i(t_code1, t_text)');; -- OK
--  Не сработало.
--
-- SELECT nso.nso_p_nso_log_i(NULL, NULL);
-- SELECT nso.nso_p_nso_log_i(NULL, '');
-- SELECT nso.nso_p_nso_log_i('', NULL);
-- SELECT nso.nso_p_nso_log_i('', '');
-- SELECT nso.nso_p_nso_log_i('3', 'Тестирование функции nso_p_nso_log_i.');
-- SELECT * FROM nso.nso_log ORDER BY 5 DESC;
-- SELECT * FROM session_nso_log;
-- SELECT * FROM nso.nso_log;
