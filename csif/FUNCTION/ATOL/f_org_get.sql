DROP FUNCTION IF EXISTS fsc_receipt_pcg.f_org_get (integer, integer, integer) CASCADE;
CREATE OR REPLACE FUNCTION fsc_receipt_pcg.f_org_get (
                         p_id_org_app      integer = NULL
                        ,p_id_org          integer = NULL
                        ,p_id_fsc_provider integer = NULL                       
)
    RETURNS TABLE (
       id_org          integer
      ,dt_create       timestamp(0) without time zone 
       --
      ,org_type        integer
      ,inn             varchar(12)
      ,nm_org_name     varchar(150)
      ,nm_org_address  text 
      ,bik             varchar(9)
      ,nm_org_phones   text[]  
       -- 
      ,id_fsc_data_operator integer
      ,nm_ofd               text
       --       
      ,id_fsc_provider integer       
      ,kd_fsc_provider varchar(20)
       --
      ,qty_cash        integer       
      ,grp_cash        varchar(50)
      ,org_cash_params jsonb         
      
    )
    LANGUAGE sql
    STABLE

AS $$
  -- --------------------------------------------------------------------------------------
  --  2023-08-25 Получить список организаций (только организации связанные с приложением)
  -----------------------------------------------------------------------------------------
    WITH x0 AS (
                 SELECT DISTINCT ON (x.id_org )
                    x.id_org   
                   ,x.dt_create
    	           ,x.id_fsc_data_operator
                FROM fiscalization.fsc_org_app x
             
                WHERE (x.org_app_status) 
                        AND 
                            (((x.id_org  = p_id_org) AND (p_id_org IS NOT NULL))
                                 OR
                              (p_id_org IS NULL)
                            )
                        AND      
                            (((x.id_org_app  = p_id_org_app) AND (p_id_org_app IS NOT NULL))
                                 OR
                              (p_id_org_app IS NULL)
                            )                                         
 	           ORDER BY x.id_org 
    )
    --
   SELECT  
           x0.id_org   
          ,x0.dt_create
           --
          ,x1.org_type 		
          ,x1.inn           
          ,x1.nm_org_name   
          ,x1.nm_org_address
          ,x1.bik           
          ,x1.nm_org_phones 
           --
          ,x0.id_fsc_data_operator
          ,x4.nm_ofd
            --
          ,x2.id_fsc_provider
          ,x3.kd_fsc_provider
          --
          ,x2.qty_cash       
          ,x2.grp_cash       
          ,x2.org_cash_params        
           
      FROM x0           
        INNER JOIN      fiscalization.fsc_org x1 ON (x0.id_org = x1.id_org) AND (x1.org_status)
        LEFT OUTER JOIN fiscalization.fsc_data_operator x4 ON (x4.id_fsc_data_operator = x0.id_fsc_data_operator)
        LEFT OUTER JOIN fiscalization.fsc_org_cash x2 ON (x1.id_org = x2.id_org) AND (x2.org_cash_status)
        LEFT OUTER JOIN fiscalization.fsc_provider x3 ON (x3.id_fsc_provider = x2.id_fsc_provider) AND (x3.fsc_status)
   
      WHERE -- (x2.id_fsc_provider IS NOT DISTINCT FROM  p_id_fsc_provider) ???
            (((x2.id_fsc_provider  = p_id_fsc_provider) AND (p_id_fsc_provider IS NOT NULL))
                                                             OR
                                                   (p_id_fsc_provider IS NULL)
            )      

    ORDER BY x0.id_org  
    
   $$;
   
   COMMENT ON FUNCTION fsc_receipt_pcg.f_org_get (integer, integer, integer)  
   IS 'Получить список организаций (только организации связанные с приложением)';
   --
   -- USE CASE
   --    SELECT * FROM fsc_receipt_pcg.f_org_get (); -- 61|63
   --    SELECT * FROM fsc_receipt_pcg.f_org_get (190); --1
   --    SELECT * FROM fsc_receipt_pcg.f_org_get (p_id_fsc_provider := 2); -- 53
   --    SELECT * FROM fsc_receipt_pcg.f_org_get (p_id_fsc_provider := 1); -- 1
   --    SELECT * FROM fsc_receipt_pcg.f_org_get (p_id_org := 125); --  
   --    SELECT * FROM fsc_receipt_pcg.f_org_get (p_id_fsc_provider := 1); -- 3 ???  
   --    SELECT * FROM fsc_receipt_pcg.f_org_get (p_id_fsc_provider := NULL);
    
   -- SELECT distinct * FROM  fiscalization.fsc_org where (org_status)  -- 69
