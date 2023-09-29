 --
 --  2023-08-31
 --
 ALTER TABLE fiscalization.fsc_receipt DROP CONSTRAINT chk_receipt_status;
 ALTER TABLE fiscalization.fsc_receipt ADD CONSTRAINT chk_receipt_status CHECK (rcp_status = ANY (ARRAY[0, 1, 2, 3, 4, 5, 6]));
 
ALTER TABLE fiscalization.fsc_receipt DETACH PARTITION fiscalization.fsc_receipt_45;

BEGIN;
INSERT INTO fiscalization.fsc_receipt
SELECT * FROM fiscalization.fsc_receipt_45; -- 2187 rows affected.

SELECT * FROM fiscalization.fsc_receipt WHERE (rcp_status = 4); -- 96
SELECT * FROM fiscalization.fsc_receipt WHERE (rcp_status = 5); -- 2091
COMMIT;
--
SELECT * FROM fiscalization.fsc_receipt WHERE (rcp_status = 6);
DROP TABLE fiscalization.fsc_receipt_45;