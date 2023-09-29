SELECT * FROM public.org WHERE (dt_remove IS NULL); -- 57
SELECT * FROM public.app WHERE (dt_remove IS NULL); -- 55
--
SELECT * FROM fiscalization.fsc_org; -- 72
SELECT * FROM fiscalization.fsc_app; -- 63

SELECT count(1), nm_org_name FROM fiscalization.fsc_org GROUP BY nm_org_name ORDER BY 1 DESC; 
SELECT count(1), nm_app FROM fiscalization.fsc_app GROUP BY nm_app ORDER BY 1 DESC; 

SELECT * FROM fiscalization.fsc_org_app ORDER BY id_org_app DESC; -- 183
SELECT * FROM fiscalization.fsc_org_app ORDER BY id_org DESC, id_app; -- 183

SELECT * FROM fsc_receipt_pcg.f_org_get (125); -- 1 -- OK
SELECT * FROM fsc_receipt_pcg.f_org_get (p_id_fsc_provider := 1);  -- 1 -- OK
--
SELECT * FROM fsc_receipt_pcg.f_org_get (); -- 61  Кто не попал ??  + Дополнительные организации (банки) -- нет у них фискализационных касс

WITH z0 AS (
            SELECT id_org FROM fiscalization.fsc_org -- 72
               EXCEPT 
            SELECT id_org FROM fsc_receipt_pcg.f_org_get () -- 61
)
SELECT z1.* FROM fiscalization.fsc_org  z1
   INNER JOIN z0 ON (z0.id_org = z1.id_org) -- AND (z1.org_status)
ORDER BY z1.id_org;   
   
-- 61 + 8 = 69  .. + 3   = 72
   --    SELECT * FROM fsc_receipt_pcg.f_org_get (); -- 63
   --    SELECT * FROM fsc_receipt_pcg.f_org_get (p_id_fsc_provider := 2); -- 53
   --    SELECT * FROM fsc_receipt_pcg.f_org_get (p_id_fsc_provider := 1); -- 53
   
   INSERT INTO fiscalization.fsc_app_param(	id_app, id_fsc_provider, app_params) VALUES (69, 1, '{}');
   INSERT INTO fiscalization.fsc_app_param(	id_app, id_fsc_provider, app_params) VALUES (68, 1, '{}');  
   INSERT INTO fiscalization.fsc_app_param(	id_app, id_fsc_provider, app_params) VALUES (67, 1, '{}');      

   --    SELECT * FROM fsc_receipt_pcg.f_org_get (p_id_fsc_provider := 1); -- 3 ???  
   --    SELECT * FROM fsc_receipt_pcg.f_org_get (p_id_fsc_provider := NULL);
    
   -- SELECT distinct * FROM  fiscalization.fsc_org where (org_status) 