/* -- ============================================================= 
	Входные параметры
	              p_rec_uuid  t_guid  - UUID записи НСО
   ---------------------------------------------------------------- 
	Выходные параметры
			        ID записи id_t
   -- ============================================================= */
DROP FUNCTION IF EXISTS nso_data.nso_f_record_get_id ( public.t_guid );
CREATE OR REPLACE FUNCTION nso_data.nso_f_record_get_id ( p_rec_uuid  public.t_guid )
  RETURNS public.id_t   
AS
 $$
    -- ================================================================ 
    --  Author:		 Nick 
    --  Create date: 2015-08-18
    --  Description:	Выбор ID записи по её UUID
    -- ================================================================
    SELECT rec_id::public.id_t FROM ONLY nso.nso_record WHERE ( rec_uuid = p_rec_uuid );
 $$
    STRICT STABLE  -- Пока, потому, что использую SET
    SECURITY DEFINER -- 2015-04-05 Nick
    LANGUAGE sql;

 COMMENT ON FUNCTION nso_data.nso_f_record_get_id ( public.t_guid ) IS '189: Выбор ID записи по её UUID';

-- SELECT * FROM nso_f_record_get_id ('45dda8e1-9bfa-4d26-8181-0b78a978ba02');
-- ----------------------------------------------------------------------------------
-- SELECT * FROM nso.nso_record LIMIT 10;
-- -------------------------------------------
--  1||'211da7ab-5800-489a-a742-d0045ca202a6'
--  2||'d172e867-ad76-498b-9634-dd0f4c583c7f'
--  3||'50730e34-2a32-40e0-8035-46ea9a2693d9'
--  4||'c32f2057-c741-4e8e-931c-e1b1c6daf615'
--  5||'511f7a89-2262-4d5a-9b60-b5ac9d59e60d'
--  6||'bd59ac54-3946-4e9f-81bb-ac24733812e3'
--  7||'39f15bd7-7023-4cca-8688-14faa376f5f3'
--  8||'e6d06f44-e428-461c-a21a-2b7eda986233'
--  9||'c9dff31b-5845-4722-a0fe-453e31743f04'
-- 10||'b0f44cec-16ec-480b-8c60-e968f94c84af'
-- ---------------------------------------------------------------------------
-- SELECT * FROM nso_f_record_get_id ('511f7a89-2262-4d5a-9b60-b5ac9d59e60d'); -- 5
-- SELECT * FROM nso_f_record_get_id ('511f7a89-2262-4d5a-9b60-b5ac9d59e61d'); -- NULL
