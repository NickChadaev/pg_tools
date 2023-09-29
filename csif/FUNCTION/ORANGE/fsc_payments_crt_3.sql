DROP FUNCTION IF EXISTS fsc_orange_pcg.fsc_payments_crt_3 (public.payments_rt[]);
CREATE OR REPLACE FUNCTION fsc_orange_pcg.fsc_payments_crt_3(
       p_payments    public.payments_rt[] 
)
    RETURNS json 
    SECURITY DEFINER
    LANGUAGE plpgsql  

AS $$
   -- ============================================================================ --
   --    2023-08-08 Создание объекта "payments" - Тип и сумма оплаты
   -- ============================================================================ --

   DECLARE
     JKEY     CONSTANT text       := 'payments';
     PMT_TYPE CONSTANT integer [] := fsc_orange_pcg.c_pmt_type();

     __pmt_type_sum  public.payments_rt;
     __result        json;
      
   BEGIN
      FOREACH __pmt_type_sum IN ARRAY p_payments
         LOOP
           IF NOT (__pmt_type_sum.type = ANY (PMT_TYPE))
             THEN
                RAISE '"payments": Вид оплаты должен принадлежать множеству "[%]"', PMT_TYPE;
		   END IF;	  
         END LOOP;
      
      __result := json_strip_nulls (to_json(p_payments));
      
      RETURN __result;
   END;
  
$$;

COMMENT ON FUNCTION fsc_orange_pcg.fsc_payments_crt_3 (public.payments_rt[])     
    IS 'Создание объекта "payments" - Тип и сумма оплаты';
--
--  USE CASE:
          -- ---------------------------------------------------------------------------------------------------
          --    SELECT fsc_orange_pcg.fsc_payments_crt_3 (array[(9, 200.2)]::public.payments_rt[]);
		  --       ERROR:  "payments": Вид оплаты должен принадлежать множеству "[{1,2,14,15,16}]"
--              SELECT fsc_orange_pcg.fsc_payments_crt_3 (array[(1, 200.2)]::public.payments_rt[]);
--                  [{"type":1,"amount":200.20}]
--              SELECT fsc_orange_pcg.fsc_payments_crt_3 (array[(1, 200.2), (2, 800.2)]::public.payments_rt[]);
--                  [{"type":1,"amount":200.20},{"type":2,"amount":800.20}]
          -- ---------------------------------------------------------------------------------------------------
		  
