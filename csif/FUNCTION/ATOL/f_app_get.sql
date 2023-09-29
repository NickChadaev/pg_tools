DROP FUNCTION IF EXISTS fsc_receipt_pcg.f_app_get (integer, integer, integer) CASCADE;
CREATE OR REPLACE FUNCTION fsc_receipt_pcg.f_app_get (
                         p_id_org_app      integer = NULL
                        ,p_id_app          integer = NULL
                        ,p_id_fsc_provider integer = NULL                       
)
    RETURNS TABLE (
       id_app     integer
      ,dt_create  timestamp(0) without time zone 
       --
      ,nm_app     varchar(150)
      ,app_guid   uuid
      ,app_params jsonb   
       --       
      ,id_fsc_provider integer       
      ,kd_fsc_provider varchar(20)

    )
    LANGUAGE sql
    STABLE

AS $$
  -- --------------------------------------------------------------------------------------
  --  2023-08-25 Получить список приложений (только  приложения связанные с организацией).
  -----------------------------------------------------------------------------------------

   WITH x0 AS (
                SELECT DISTINCT ON (x.id_app)
                   x.id_app   
                  ,x.dt_create
               FROM fiscalization.fsc_org_app x
               
               WHERE (x.org_app_status) 
                        AND (((x.id_app  = p_id_app) AND (p_id_app IS NOT NULL))
                                                 OR
                             (p_id_app IS NULL)
                            )
                        AND      
                            (((x.id_org_app  = p_id_org_app) AND (p_id_org_app IS NOT NULL))
                                 OR
                              (p_id_org_app IS NULL)
                            )                                             
	          ORDER BY  x.id_app   
   )
   
   SELECT DISTINCT
           x0.id_app   
          ,x0.dt_create
           --
          ,x1.nm_app    
          ,x1.app_guid  
          ,x2.app_params
           --
          ,x2.id_fsc_provider
          ,x3.kd_fsc_provider
           
      FROM x0           
        INNER JOIN      fiscalization.fsc_app x1 ON (x0.id_app = x1.id_app) AND (x1.app_status)
        LEFT OUTER JOIN fiscalization.fsc_app_param x2 ON (x1.id_app = x2.id_app) AND (x2.app_status)
        LEFT OUTER JOIN fiscalization.fsc_provider x3 ON (x3.id_fsc_provider = x2.id_fsc_provider) AND (x3.fsc_status)
   
      WHERE (((x2.id_fsc_provider  = p_id_fsc_provider) AND (p_id_fsc_provider IS NOT NULL))
                                                             OR
             (p_id_fsc_provider IS NULL)
            ) 

   -- ORDER BY x0.id_app  
    
   $$;
   
   COMMENT ON FUNCTION fsc_receipt_pcg.f_app_get (integer, integer, integer) 
   IS 'Получить список приложений (только  приложения связанные с организацией)';
   --
   -- USE CASE
   --    SELECT * FROM fsc_receipt_pcg.f_app_get (); -- 61
   --    SELECT * FROM fsc_receipt_pcg.f_app_get (p_id_fsc_provider := 2); -- 54
   --    SELECT * FROM fsc_receipt_pcg.f_app_get (p_id_fsc_provider := 1); -- 54   ???
   --    SELECT * FROM fsc_receipt_pcg.f_app_get (10); --  
   --    SELECT * FROM fsc_receipt_pcg.f_org_get (10);
   --
   --    SELECT * FROM fsc_receipt_pcg.f_app_get (190); --  
   --    SELECT * FROM fsc_receipt_pcg.f_org_get (190);
   --
   --    SELECT * FROM fsc_receipt_pcg.f_app_get (191); --  
   --    SELECT * FROM fsc_receipt_pcg.f_org_get (191);
   --
   --    SELECT * FROM fsc_receipt_pcg.f_app_get (189); --  
   --    SELECT * FROM fsc_receipt_pcg.f_org_get (189);   
   
   --    SELECT * FROM fsc_receipt_pcg.f_app_get (p_id_fsc_provider := 1); -- 3 ???  
   --    SELECT * FROM fsc_receipt_pcg.f_app_get (p_id_fsc_provider := NULL);
    
   -- SELECT distinct * FROM  fiscalization.fsc_org where (org_status)  
