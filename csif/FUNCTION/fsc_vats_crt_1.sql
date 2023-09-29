DROP FUNCTION IF EXISTS fsc_receipt_pcg.fsc_vats_crt_1 (vats_type_sum_t[]);
CREATE OR REPLACE FUNCTION fsc_receipt_pcg.fsc_vats_crt_1(
       p_vats_type_sum    vats_type_sum_t[] 
)
    RETURNS json 
    SECURITY DEFINER
    LANGUAGE plpgsql  

AS $$
   -- ============================================================================ --
   --    2023-05-19 Создание объекта `vats" - Ставка и сумма налогов в кассе.
   -- ============================================================================ --

   DECLARE
    JKEY    CONSTANT text    := 'vats';
    QTY_VTS CONSTANT integer := 6; 
     
    __lts_vats_mess text := '"%s": Количество различных видов оплаты не должно превышать: %s';
    __null_mess     text := '"%s": Эти данные являются обязательными: "%s[%s]" = %L';
    __result json;
    
    __vats_type_sum  vats_type_sum_t; 
    __i integer;
      
   BEGIN
      IF (array_length (p_vats_type_sum, 1) > QTY_VTS) 
        THEN
           RAISE '%', format (__lts_vats_mess, JKEY, QTY_VTS);
      END IF;

      __i := 1;
      FOREACH __vats_type_sum IN ARRAY p_vats_type_sum
        LOOP
           IF (__vats_type_sum.vats_type IS NULL)
             THEN
                  RAISE '%', format (__null_mess, JKEY, 'vats_type', __i, __vats_type_sum.vats_type);     
           END IF; 
		   
           __i := __i + 1;
        END LOOP;
   
      __result := json_strip_nulls (to_json(p_vats_type_sum));
      
      RETURN __result;
   END;
  
$$;

COMMENT ON FUNCTION fsc_receipt_pcg.fsc_vats_crt_1 (vats_type_sum_t[])     
    IS 'Создание объекта `vats" - Ставка и сумма налогов в кассе.';
--
--  USE CASE:
          --    SELECT fsc_receipt_pcg.fsc_vats_crt_1 (array[('vat0', 200.2)]::vats_type_sum_t[]);
          --    SELECT fsc_receipt_pcg.fsc_vats_crt_1 (array[('vat20', 200.2), ('vat10', 300.01)]::vats_type_sum_t[]);
          --    SELECT fsc_receipt_pcg.fsc_vats_crt_1 (array[('vat20', 200.2), (NULL, 300.01)]::vats_type_sum_t[]);
          --    SELECT fsc_receipt_pcg.fsc_vats_crt_1 (array[('vat20', NULL), ('vat10', 300.01)]::vats_type_sum_t[]);
		  
-- NOTICE: [{"vats_type":"vat0","vats_sum":200.20}]
-- NOTICE: [{"vats_type":"vat20","vats_sum":200.20},{"vats_type":"vat10","vats_sum":300.01}]
-- ERROR:  "vats": Эти данные являются обязательными: "vats_type[2]" = NULL
-- [{"vats_type":"vat20"},{"vats_type":"vat10","vats_sum":300.01}]


