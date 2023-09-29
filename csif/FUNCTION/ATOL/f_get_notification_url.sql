DROP FUNCTION IF EXISTS fsc_receipt_pcg.f_get_notification_url (integer, uuid) CASCADE;
CREATE OR REPLACE FUNCTION fsc_receipt_pcg.f_get_notification_url (
                         p_id_org_app   integer
                        ,p_app_guid     uuid = NULL                       
)
    RETURNS text
    LANGUAGE sql
    STABLE

AS $$
--
-- 2023-08-11
--
      SELECT  
       	    x2.notification_url   
      FROM fiscalization.fsc_org_app x0 
         
          JOIN fiscalization.fsc_app x2 ON (x2.id_app = x0.id_app)
         
      WHERE ( x0.id_org_app = p_id_org_app) AND (
                ((x2.app_guid = p_app_guid) AND (p_app_guid IS NOT NULL))
                    OR
                (p_app_guid IS NULL)
             )            
                  ORDER BY x2.id_app LIMIT 1;                 
$$;

COMMENT ON FUNCTION fsc_receipt_pcg.f_get_notification_url (integer, uuid)
    IS 'Получить url для отсылки уведомлений об обработке';
-- ------------------------------------------------------------------------
--   USE CASE:
--  SELECT fsc_receipt_pcg.f_get_notification_url (195);
-- EXPLAIN ANALYZE
--    SELECT fsc_receipt_pcg.f_get_notification_url (195, '212f1d68-88ee-4d14-882b-1c945bcc785b');