SET search_path = fiscalization, public;

DROP TRIGGER IF EXISTS tg_fsc_receipt_iu ON fiscalization.fsc_receipt_0;

DROP FUNCTION IF EXISTS fiscalization.ftg_fsc_receipt_iu();
CREATE OR REPLACE FUNCTION fiscalization.ftg_fsc_receipt_iu()
RETURNS TRIGGER AS
$$
-- ==============================================================================================
-- Create date: 2023-07-26
-- Description:	Триггер, обрабатывающий события INSERT, UPDATE. Работает в тпределах секции 0.
--              контроль уникальности значения ИНН, вне зависимости от номера чека,
--              что делает невозможной повторную фискализацию в пределах одного batch.
--  2023-08-25 Очевидная глупость, теперь контролируем глобальную уникальность "rcp_nmb", т.е 
--    для всех фискальных провайдеров, но в пределах секции 0. В неё поступают данные.
-- ==============================================================================================
BEGIN
     IF (TG_OP = 'INSERT')
     THEN
        IF NOT EXISTS (SELECT 1 FROM fiscalization.fsc_receipt_0 WHERE (rcp_nmb = NEW.rcp_nmb) AND
                          (rcp_status = NEW.rcp_status)
        )
         THEN
              RETURN NEW;
         ELSE     
              RETURN OLD;
        END IF; 
        
     ELSIF (TG_OP = 'UPDATE')
     THEN
        IF NOT EXISTS (SELECT 1 FROM fiscalization.fsc_receipt_0 WHERE (rcp_nmb = NEW.rcp_nmb) AND
                          (rcp_status = NEW.rcp_status)
        )
         THEN
              RETURN NEW;
         ELSE     
              RETURN OLD;
        END IF;
	END IF;
	
	RETURN OLD;
END;
$$
LANGUAGE plpgsql 
SECURITY DEFINER;  

COMMENT ON FUNCTION fiscalization.ftg_fsc_receipt_iu() IS 'Обработка событий INSERT, UPDATE в fiscalization.fsc_receipt_0';

-- Применение триггера
CREATE TRIGGER tg_fsc_receipt_iu BEFORE INSERT OR UPDATE OR DELETE ON fiscalization.fsc_receipt_0
FOR EACH ROW EXECUTE PROCEDURE fiscalization.ftg_fsc_receipt_iu();

-- SELECT * FROM fiscalization.fsc_receipt_0 LIMIT 10



