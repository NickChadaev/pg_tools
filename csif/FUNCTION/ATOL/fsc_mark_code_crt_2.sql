DROP FUNCTION IF EXISTS fsc_receipt_pcg.fsc_mark_code_crt_2 (text, text, text, text, text, text, text, text, text, text);
CREATE OR REPLACE FUNCTION fsc_receipt_pcg.fsc_mark_code_crt_2 (

      p_unknown text DEFAULT NULL -- нераспознанный код товара
     ,p_ean8    text DEFAULT NULL -- Код товара в формате EAN-8
     ,p_ean13   text DEFAULT NULL -- Код товара в формате EAN-13.
     ,p_itf14   text DEFAULT NULL -- Код товара в формате ITF-14.
     ,p_gs10    text DEFAULT NULL -- Код товара в формате GS1, нанесенный на товар, не подлежащий маркировке средствами идентификации.
     ,p_gs1m    text DEFAULT NULL -- Код товара в формате GS1, нанесенный на товар, подлежащий маркировке средствами идентификации.
     ,p_short   text DEFAULT NULL -- Код товара в формате короткого кода маркировки, нанесенный на товар, подлежащий маркировке средствами идентификации.
     ,p_fur     text DEFAULT NULL -- Контрольно-идентификационный знак мехового изделия.
     ,p_egais20 text DEFAULT NULL -- Код товара в формате ЕГАИС-2.0.
     ,p_egais30 text DEFAULT NULL -- Код товара в формате ЕГАИС-3.0.
  )
    RETURNS json 
    SECURITY DEFINER
    LANGUAGE plpgsql  

AS $$
   -- ========================================================================================= --
   --    2023-05-22  Создание объекта "mark_code" - Маркировка товара средствами идентификации
   -- ========================================================================================= --

   DECLARE
     JKEY  CONSTANT text      := 'makr_code';
     JKEYS CONSTANT text[]    := array ['unknown', 'ean8', 'ean13', 'itf14', 'gs10', 'gs1m', 'short', 'fur', 'egais20', 'egais30']::text[];  
     JQ    CONSTANT integer[] := array [   32,       8,      13,      14,      38,    200,      38,     20,    33,        14     ]::integer[];
     -- --------------------------------------------------------------------------------------------------------------------------------------
     --                                     1        2        3        4        5      6         7       8      9         10
     
     __lts_mess text := '"%s": Длина "%s" должна быть не больше %s символов';
     __eqs_mess text := '"%s": Длина "%s" должна быть ровно %s символов';
     __eqn_mess text := '"%s": Длина "%s" должна быть ровно %s цифр';
     
     __jdata text [] := array[NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL]::text[];
     
     __result json;
      
   BEGIN
      IF (p_unknown IS NOT NULL) 
         THEN
             IF NOT (char_length(p_unknown) <= JQ[1])
               THEN
                  RAISE '%', format (__lts_mess, JKEY, JKEYS[1], JQ[1]);
             END IF;           
             __jdata [1] := p_unknown;
             
      ELSIF (p_ean8 IS NOT NULL)
         THEN
              IF NOT (char_length(p_ean8) =  JQ[2])
               THEN
                  RAISE '%', format (__eqn_mess, JKEY, JKEYS[2], JQ[2]);         
             END IF;          
             __jdata [2] := p_ean8;
             
      ELSIF (p_ean13 IS NOT NULL)
         THEN
              IF NOT (char_length(p_ean13) = JQ[3])
               THEN
                  RAISE '%', format (__eqn_mess, JKEY, JKEYS[3], JQ[3]);        
             END IF;          
             __jdata [3] := p_ean13;
             
      ELSIF (p_itf14 IS NOT NULL)
         THEN
             IF NOT (char_length(p_itf14) = JQ[4])
               THEN
                  RAISE  '%', format (__eqn_mess, JKEY, JKEYS[4], JQ[4]);           
             END IF;     
             __jdata [4] := p_itf14;
         
      ELSIF (p_gs10 IS NOT NULL)
         THEN
             IF NOT (char_length(p_gs10) <= JQ[5])
               THEN
                  RAISE '%', format (__lts_mess, JKEY, JKEYS[5], JQ[5]);
             END IF;           
             __jdata [5] := p_gs10;             
             
      ELSIF (p_gs1m IS NOT NULL)
         THEN
             IF NOT (char_length(p_gs10) <= JQ[6])
               THEN
                  RAISE '%', format (__lts_mess, JKEY, JKEYS[6], JQ[6]);
             END IF;            
             __jdata [6] := p_gs1m;                                

      ELSIF (p_short IS NOT NULL)
         THEN
             IF NOT (char_length(p_short) <= JQ[7])
               THEN
                  RAISE '%', format (__lts_mess, JKEY, JKEYS[7], JQ[7]);
             END IF;            
             __jdata [7] := p_short;                                

      ELSIF (p_fur IS NOT NULL)
         THEN
             IF NOT (char_length(p_fur) = JQ[8])
               THEN
                  RAISE  '%', format (__eqs_mess, JKEY, JKEYS[8], JQ[8]);        
             END IF;           
             __jdata [8] := p_fur;     

      ELSIF ( p_egais20 IS NOT NULL)
         THEN
             IF NOT (char_length(p_egais20) = JQ[9])
               THEN
                  RAISE  '%', format (__eqs_mess, JKEY, JKEYS[9], JQ[9]);  
             END IF;  
             __jdata [9] := p_egais20;   

      ELSIF ( p_egais30 IS NOT NULL)
         THEN
             IF NOT (char_length(p_egais30) = JQ[10])
               THEN
                  RAISE '%', format (__eqs_mess, JKEY, JKEYS[10], JQ[10]);
             END IF;  
             __jdata [10] := p_egais30;               
      END IF;

      __result := json_strip_nulls (json_object (JKEYS, __jdata));
       
       RETURN __result;
   END;
  
$$;

COMMENT ON FUNCTION fsc_receipt_pcg.fsc_mark_code_crt_2 (text, text, text, text, text, text, text, text, text, text)
    IS 'Создание объекта "mark_code" - Маркировка товара средствами идентификации';
--
--  USE CASE:
--            SELECT fsc_receipt_pcg.fsc_mark_code_crt_2 (p_unknown := '123456789--9999999999999999999999999999999999999999999999999999999999999999www');
--            SELECT fsc_receipt_pcg.fsc_mark_code_crt_2 (p_ean13 := '1234567890123', p_egais30 :='jkhhhhh');
--            SELECT fsc_receipt_pcg.fsc_mark_code_crt_2 (p_egais30 := '12345678901234');
--------------------------------------------------------------------------------------------------------------
