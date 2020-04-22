DROP FUNCTION IF EXISTS com.tr_all_log_id() CASCADE;
CREATE OR REPLACE FUNCTION com.tr_all_log_id()
RETURNS TRIGGER 
SET search_path = com, public
AS
$$
-- ====================================================================================================================
-- Author: Nick
-- Create date: 2016-11-07
-- Description:	Триггер, обрабатывающий события INSERT, DELETE
-- 2017-12-14 Gregory расширен список схем
-- 2017-12-18 Nick - Небольшие корректировки.
-- 2018-02-20 Nick - Записи из схем, в которых нет LOGGING падают в com.all_log
-- 2019-05-23 Nick - новое ядро
-- ====================================================================================================================
   DECLARE
     _schema_name public.t_sysname;
     
   BEGIN
     IF TG_OP = 'INSERT' THEN
  	_schema_name := upper (NEW.schema_name); 
        CASE  
           WHEN _schema_name ~* '^COM' THEN
              INSERT INTO com.com_log ( user_name, host_name, impact_type, impact_date, impact_descr )
                 VALUES ( NEW.user_name, NEW.host_name, NEW.impact_type, NEW.impact_date, NEW.impact_descr);
           --
           WHEN _schema_name ~* '^NSO' THEN
              INSERT INTO nso.nso_log ( user_name, host_name, impact_type, impact_date, impact_descr )
                 VALUES ( NEW.user_name, NEW.host_name, NEW.impact_type, NEW.impact_date, NEW.impact_descr);
           --      
           WHEN _schema_name ~* '^AUTH' THEN
              INSERT INTO auth.auth_log_1 ( user_name, host_name, impact_type, impact_date, impact_descr )
                 VALUES ( NEW.user_name, NEW.host_name, NEW.impact_type, NEW.impact_date, NEW.impact_descr);
--         --
--         WHEN schema_name ~* '^IND'  THEN                                                                               -- Nick 2017-12-18
--            INSERT INTO ind.ind_log ( user_name, host_name, impact_type, impact_date, impact_descr )
--               VALUES ( NEW.user_name, NEW.host_name, NEW.impact_type, NEW.impact_date, NEW.impact_descr);
           --      
           WHEN _schema_name ~* '^UIO' THEN
              INSERT INTO uio.uio_log (ul_id_log, ul_user_name, ul_host_name, ul_impact_type, ul_impact_date, ul_impact_descr) -- Nick 2017-12-18
                 VALUES ( NEW.ul_user_name, NEW.ul_host_name, NEW.ul_impact_type, NEW.ul_impact_date, NEW.ul_impact_descr);
           --        
           WHEN _schema_name ~* '^UTL' THEN
              INSERT INTO utl.utl_log ( user_name, host_name, impact_type, impact_date, impact_descr )
                 VALUES ( NEW.user_name, NEW.host_name, NEW.impact_type, NEW.impact_date, NEW.impact_descr);
           ELSE 
                 NULL;
        END CASE;
  		RETURN OLD;
  		
   ELSIF TG_OP = 'DELETE' THEN
      _schema_name := upper (OLD.schema_name); 
      CASE upper ( OLD.schema_name ) 
         WHEN _schema_name ~* '^COM'  THEN
                        DELETE FROM com.com_log WHERE ( id_log = OLD.id_log );       -- Nick 2017-12-18
         --
         WHEN _schema_name ~* '^NSO'  THEN
                        DELETE FROM nso.nso_log WHERE ( id_log = OLD.id_log );       -- Nick 2017-12-18
         --
         WHEN _schema_name ~* '^AUTH' THEN
                        DELETE FROM auth.auth_log_1 WHERE ( id_log = OLD.id_log );   -- Nick 2017-12-18
--         WHEN schema_name ~* '^IND' THEN
--                        DELETE FROM ind.ind_log WHERE ( log_id = OLD.log_id );     -- Nick 2017-12-18
         --
         WHEN _schema_name ~* '^UIO' THEN
                        DELETE FROM uio.uio_log WHERE ( ul_id_log = OLD.ul_id_log ); -- Nick 2017-12-18
         --
         WHEN _schema_name ~* '^UTL' THEN
                        DELETE FROM utl.utl_log WHERE ( id_log = OLD.id_log );       -- Nick 2017-12-18
         ELSE
               NULL;
      END CASE;
	RETURN OLD;
     END IF;
   END;
$$
LANGUAGE plpgsql 
SECURITY DEFINER; -- Nick 2016-02-26

COMMENT ON FUNCTION com.tr_all_log_id() IS '80: Обработка событий INSERT, DELETE в таблице сообщений.';

-- Применение триггера
CREATE TRIGGER tr_all_log_i BEFORE INSERT ON com.all_log FOR EACH ROW EXECUTE PROCEDURE com.tr_all_log_id();
CREATE TRIGGER tr_all_log_d BEFORE DELETE ON com.all_log FOR EACH ROW EXECUTE PROCEDURE com.tr_all_log_id(); 
-- ---------------------------------------------------
--  Тесты
-- -------------------------------------------------------------------------------------------------------
-- INSERT INTO com.all_log ( user_name, host_name, impact_type, impact_date, impact_descr, schema_name )
--   VALUES ( 'test1', '192.168.1.20', '0', CURRENT_TIMESTAMP::timestamp(0) without time zone, 'Test COM 1', 'COM');
--   --
--   INSERT INTO com.all_log ( user_name, host_name, impact_type, impact_date, impact_descr, schema_name )
--   VALUES ( 'test1', '192.168.1.20', '0', CURRENT_TIMESTAMP::timestamp(0) without time zone, 'Test COM 1', 'DAS');
-- --
-- SELECT * FROM ONLY com.all_log ORDER BY impact_date DESC LIMIT 10;  
-- SELECT * FROM com.com_log ORDER BY impact_date DESC LIMIT 10;  
-- -- --------------------------------------------------------------------------------------------------
-- INSERT INTO com.all_log ( user_name, host_name, impact_type, impact_date, impact_descr, schema_name )
--  VALUES ( 'test2', '192.168.1.20', '0', CURRENT_TIMESTAMP::timestamp(0) without time zone, 'Test NSO 1', 'NSO');
-- --
-- SELECT * FROM nso.nso_log ORDER BY impact_date DESC;  
-- -- --------------------------------------------------------------------------------------------------
-- INSERT INTO com.all_log ( user_name, host_name, impact_type, impact_date, impact_descr, schema_name )
--   VALUES ( 'test4', '192.168.1.20', '0', CURRENT_TIMESTAMP::timestamp(0) without time zone, 'Test AUTH 2', 'AUTH');
-- -- 
-- SELECT * FROM auth.auth_log_1;
-- --------------------------------------------------------------------------------------------------
-- Из определения структуры схемы AUTH
-- DROP INDEX IF EXISTS ie1_auth_log_1;  
-- -- -- CREATE INDEX ie1_auth_log_1 ON auth.auth_log_1 ( impact_date, impact_type );  
-- -- -- 
-- -- -- DROP INDEX IF EXISTS ie2_auth_log_1;
-- -- -- CREATE INDEX ie2_auth_log_1 ON auth.auth_log_1 ( user_name );
-- -- -- 
-- -- -- ALTER TABLE auth.auth_log_1 DROP CONSTRAINT ak2_auth_log_1;
-- -- -- ALTER TABLE auth.auth_log_1 ADD CONSTRAINT ak2_auth_log_1 UNIQUE ( id_log );
-- -- -- 
-- -- -- ALTER TABLE auth.auth_log_1 ALTER COLUMN schema_name SET DEFAULT 'AUTH';  
-- -- -- ALTER TABLE auth.auth_log_1 ALTER COLUMN id_log SET DEFAULT nextval('com.all_history_id_seq'::regclass) 
-- ---------------------------------------------------------------------
-- SELECT * FROM nso.nso_log;
-- SELECT * FROM com.all_log;
-- DELETE FROM com.all_log;
-- --------------------------
-- SELECT * FROM com.all_log WHERE ( id_log = 7 )
-- DELETE FROM com.all_log WHERE ( id_log = 7 )
