DROP FUNCTION IF EXISTS fsc_receipt_pcg.fsc_mark_quantity_crt_2 (integer, integer);
CREATE OR REPLACE FUNCTION fsc_receipt_pcg.fsc_mark_quantity_crt_2(
      p_numerator    integer
     ,p_denominator  integer
     
  )
    RETURNS json 
    SECURITY DEFINER
    LANGUAGE plpgsql  

AS $$
   -- =========================================================================================== --
   --    2023-05-19'Создание объекта "mark_quantity" - дробное количество маркированного товара'
   -- =========================================================================================== --

   DECLARE
     JKEY  CONSTANT text = 'mark_quantity';
     JKEYS CONSTANT text[] = array['numerator', 'denominator']::text[];  

     __result json;
      
   BEGIN
     IF NOT ((p_numerator IS NOT NULL) AND (p_denominator IS NOT NULL)) 
        THEN
             RAISE 'mark_quantity: NULL значения запрещены';
     END IF;   
   
     IF (p_numerator <= 0) 
        THEN
             RAISE 'mark_quantity: %: "numerator" должен быть > 0', p_numerator;
     END IF;
   
     IF (p_denominator <= 0) 
        THEN
             RAISE 'mark_quantity: %: "denominator" должен быть > 0', p_denominator;
     END IF;

     IF NOT (p_numerator < p_denominator) 
        THEN
             RAISE 'mark_quantity: %, %: "numerator" должен быть меньше, чем "denominator"', p_numerator, p_denominator;
     END IF;
     
       __result := json_strip_nulls (json_build_object(JKEYS[1], p_numerator, JKEYS[2], p_denominator));
       
       RETURN __result;
   END;
  
$$;

COMMENT ON FUNCTION fsc_receipt_pcg.fsc_mark_quantity_crt_2 (integer, integer)     
    IS 'Создание объекта "mark_quantity" - дробное количество маркированного товара';
--
--  USE CASE:
--            SELECT fsc_receipt_pcg.fsc_mark_quantity_crt_2 (1,2);
--            SELECT fsc_receipt_pcg.fsc_mark_quantity_crt_2 (10,2);
--            SELECT fsc_receipt_pcg.fsc_mark_quantity_crt_2 (0,133);
--            SELECT fsc_receipt_pcg.fsc_mark_quantity_crt_2 (133, -33);
--            SELECT fsc_receipt_pcg.fsc_mark_quantity_crt_2 (NULL, -33);
--------------------------------------------------------------------------------------------------------------
-- {"numerator":1,"denominator":2}
-- ERROR:  10, 2: "numerator" должен быть меньше, чем "denominator"
-- ERROR:  0: "numerator" должен быть > 0
