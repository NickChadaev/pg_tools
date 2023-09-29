DROP FUNCTION IF EXISTS fsc_receipt_pcg.fsc_client_crt_1 (text, text, text, text, text, text, text, text, text);
CREATE OR REPLACE FUNCTION fsc_receipt_pcg.fsc_client_crt_1 (

       p_name           text DEFAULT NULL::text
     , p_inn            text DEFAULT NULL::text
     , p_email          text DEFAULT NULL::text              -- НЕТ ЕГО
     , p_phone          text DEFAULT NULL::text              -- НЕТ ЕГО
     , p_birthdate      text DEFAULT NULL::text
     , p_citizenship    text DEFAULT NULL::text 
     , p_document_code  text DEFAULT NULL::text 
     , p_document_data  text DEFAULT NULL::text 
     , p_address        text DEFAULT NULL::text 
     
 )
    RETURNS json 
    SECURITY DEFINER
    LANGUAGE plpgsql

AS $$
   -- ============================================================================ --
   --    2023-05-18  Создание объекта  "client"  Уровень 1.
   -- ============================================================================ --

   DECLARE
     JKEY  CONSTANT text      := 'client';
     JKEYS CONSTANT text[]    := array['email', 'phone','name','inn','birthdate','citizenship','document_code','document_data','address']::text[];  
     JQ    CONSTANT integer[] := array[  64,     19,     256,   NULL,    10,          3,            2,               64,          256]::integer[];
     --                                   1       2       3      4      5           6             7                  8           9
     
     INN_PATTERN CONSTANT text := '(^[0-9]{10}$)|(^[0-9]{12}$)';
     
     __lts_mess  text := '"%s": Длина "%s" должна быть не больше %s символов';
     __eqs_mess  text := '"%s": Длина "%s" должна быть ровно %s символов';
     __eqn_mess  text := '"%s": Длина "%s" должна быть ровно %s цифр';
     __null_mess text := '"%s": Эти данные являются обязательными: "%s" = %L, "%s" = %L';
     __inn_mess  text := '"%s": Неправильный формат ИНН: "%s" = %L';

     __jdata  text[];
     __result json;
      
   BEGIN
     __jdata := array [p_email, p_phone, p_name, p_inn, p_birthdate, p_citizenship, p_document_code, p_document_data, p_address];
     
     IF NOT (char_length(__jdata[1]) <= JQ[1]) 
       THEN
           RAISE '%', format (__lts_mess, JKEY, JKEYS[1], JQ[1]);              
            
       ELSIF NOT (char_length(__jdata[2]) <= JQ[2])
            THEN  
                 RAISE '%', format (__lts_mess, JKEY, JKEYS[2], JQ[2]);      

       ELSIF NOT (char_length(__jdata[3]) <= JQ[3])
            THEN  
                 RAISE '%', format (__lts_mess, JKEY, JKEYS[3], JQ[3]);   
                 
       ELSIF NOT (__jdata[4] ~ INN_PATTERN)
             THEN
                 RAISE '%', format (__inn_mess, JKEY, JKEYS[4], __jdata[4]);   
                 
       ELSIF NOT (char_length(__jdata[5]) = JQ[5])
             THEN
                 RAISE '%', format (__eqs_mess, JKEY, JKEYS[5], JQ[5]);                 
                 
       ELSIF NOT (char_length(__jdata[6]) = JQ[6])
             THEN
                 RAISE '%', format (__eqs_mess, JKEY, JKEYS[6], JQ[6]);                 

       ELSIF NOT (char_length(__jdata[7]) = JQ[7])
             THEN
                 RAISE '%', format (__eqs_mess, JKEY, JKEYS[7], JQ[7]);                 
                 
       ELSIF NOT (char_length(__jdata[8]) <= JQ[8])
            THEN  
                 RAISE '%', format (__lts_mess, JKEY, JKEYS[8], JQ[8]);   

       ELSIF NOT (char_length(__jdata[9]) <= JQ[9])
            THEN  
                 RAISE '%', format (__lts_mess, JKEY, JKEYS[9], JQ[9]);   
                 
       END IF;
      
       __result := json_strip_nulls (json_object (JKEYS, __jdata));
       
       RETURN __result;
   END;
  
$$;

COMMENT ON FUNCTION fsc_receipt_pcg.fsc_client_crt_1 (text, text, text, text, text, text, text, text, text)     
    IS 'Создание объекта "client"';
--
--  USE CASE:
--            SELECT fsc_receipt_pcg.fsc_client_crt_1 ();
--            SELECT fsc_receipt_pcg.fsc_client_crt_1 ('1','2','3','4', p_address := 'xxxx');
--            SELECT fsc_receipt_pcg.fsc_client_crt_1 (p_name := 'ООО "МОСОБЛЕИРЦ"', p_inn := '5037008735');
--            SELECT fsc_receipt_pcg.fsc_client_crt_1 (p_name := 'ООО "МОСОБЛЕИРЦ"', p_inn := '5037008735'
--                   , p_document_data := 'QWEERTTYYOPUOIP[I[[B,BNNNNNNNNNNNNNNNNNNNNNNNNNNNNNN2222222222]]]'                              
-- );
--------------------------------------------------------------------------------------------------------------
-- {}
--{"client" : {"email":"1","phone":"2","name":"3","inn":"4","address":"xxxx"}}
-- {"email":"3","phone":"4","name":"1","inn":"2","address":"xxxx"}
--
-- {"client" : {"name":"ООО \"МОСОБЛЕИРЦ\"","inn":"5037008735"}}
  
