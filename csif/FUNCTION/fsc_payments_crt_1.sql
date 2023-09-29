DROP FUNCTION IF EXISTS fsc_receipt_pcg.fsc_payments_crt_1 (pmt_type_sum_t[]);
CREATE OR REPLACE FUNCTION fsc_receipt_pcg.fsc_payments_crt_1(
       p_pmt_type_sum    pmt_type_sum_t[] 
)
    RETURNS json 
    SECURITY DEFINER
    LANGUAGE plpgsql  

AS $$
   -- ============================================================================ --
   --    2023-05-19 Создание объекта "payments" - Вид и сумма оплаты
   -- ============================================================================ --

   DECLARE
     JKEY     CONSTANT text       := 'payments';
     QTY_PMT  CONSTANT integer    := 10; 
     PMT_TYPE CONSTANT int4range  := int4range('[0,9]');
     
     __pmt_type_sum  pmt_type_sum_t;
     __result        json;
      
   BEGIN
      IF (array_length (p_pmt_type_sum, 1) > QTY_PMT) 
        THEN
          RAISE '"payments": Количество различных видов оплаты не должно превышать: %', QTY_PMT;
      END IF;  

      FOREACH __pmt_type_sum IN ARRAY p_pmt_type_sum
         LOOP
           IF NOT (PMT_TYPE @> __pmt_type_sum.pmt_type)
             THEN
                RAISE '"payments": Вид оплаты должен находится в диапазоне от % до %', lower(PMT_TYPE), upper(PMT_TYPE)-1;
		   END IF;	  
         END LOOP;
      
      __result := json_strip_nulls (to_json(p_pmt_type_sum));
      
      RETURN __result;
   END;
  
$$;

COMMENT ON FUNCTION fsc_receipt_pcg.fsc_payments_crt_1 (pmt_type_sum_t[])     
    IS 'Создание объекта "payments" - Вид и сумма оплаты';
--
--  USE CASE:
          --    SELECT fsc_receipt_pcg.fsc_payments_crt_1 (array[('1', 200.2)]::pmt_type_sum_t[]);
          --    SELECT fsc_receipt_pcg.fsc_payments_crt_1 (array[(12, 200.2), (0, 300.01)]::pmt_type_sum_t[]);
          -- ERROR:  Вид оплаты должен находится в диапазоне от 0 до 9
-- NOTICE: [{"pmt_type":1,"pmt_sum":200.20}]
-- NOTICE: [{"pmt_type":1,"pmt_sum":200.20},{"pmt_type":0,"pmt_sum":300.01}]

