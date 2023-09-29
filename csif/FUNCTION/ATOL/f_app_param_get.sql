DROP FUNCTION IF EXISTS fsc_receipt_pcg.f_app_param_get (uuid, integer) CASCADE;
CREATE OR REPLACE FUNCTION fsc_receipt_pcg.f_app_param_get (
                         p_app_guid        uuid
                        ,p_id_fsc_provider integer  
                         --
                        ,OUT id_app_param  integer
                        ,OUT id_app        integer
                        ,OUT app_params    json
)
    RETURNS SETOF RECORD
    LANGUAGE plpgsql
    STABLE

AS $$
  -- -----------------------------------------------------------------
  --  2023-08-30 Получить параметры для выбранного приложения. 
  -- -----------------------------------------------------------------
  BEGIN
    SELECT x1.id_app_param, x0.id_app, x1.app_params
      FROM fiscalization.fsc_app x0
        INNER JOIN fiscalization.fsc_app_param x1 ON 
                (x0.id_app = x1.id_app) AND (x1.app_status)  
    WHERE (x0.app_status) AND (x0.app_guid = p_app_guid) AND (x1.id_fsc_provider = p_id_fsc_provider) 
    INTO  id_app_param, id_app, app_params;

    RETURN NEXT;    
  END;  
$$;

COMMENT ON FUNCTION fsc_receipt_pcg.f_app_param_get (uuid, integer) IS 'Получить параметры для выбранного приложения';
   --
   -- USE CASE
   --
   -- SELECT * FROM fiscalization.fsc_app; -- 6fe030b2-22af-4e3d-ab2e-36be83e76408
   --    -- АО "Газпром газораспределение Ленинградская область"
   --
   -- SELECT * FROM fsc_receipt_pcg.f_app_param_get ('6fe030b2-22af-4e3d-ab2e-36be83e76408', 2) ;
   -- -------------------------------------------------------------------------------------------
   --          id_app_param	id_app	app_params
   --          177	12	{"secret_key": "0ats2dmlh6a5", "notification_url": null}

