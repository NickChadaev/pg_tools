DROP FUNCTION IF EXISTS fsc_receipt_pcg.fsc_agent_info_crt_2(agent_info_t, json, json, json);
CREATE OR REPLACE FUNCTION fsc_receipt_pcg.fsc_agent_info_crt_2(
       p_type                      agent_info_t       -- Тип агента по предмету расчёта 
     , p_paying_agent              json DEFAULT NULL  -- Атрибуты платёжного агента
     , p_receive_payments_operator json DEFAULT NULL  -- Атрибуты по приёму платежей
     , p_money_transfer_operator   json DEFAULT NULL  -- Атрибуты оператора перевода  
 )
    RETURNS json 
    SECURITY DEFINER
    LANGUAGE plpgsql  

AS $$
   -- ============================================================================ --
   --  2023-05-19  Все матрёшки (первого, второго и третьего уровней должны 
   --               возвращать значение, ключ -- в вызывающей функциии   ????
   --  2023-05-23  Создание объекта  "agent_info" - платёжный агент.
   -- ============================================================================ --

   DECLARE
     JKEY2 CONSTANT text = 'agent_info';
     JKEYS3 CONSTANT text[] = array['type', 'paying_agent', 'receive_payments_operator', 'money_transfer_operator']::text[];  

     __result json;
      
   BEGIN
       __result := json_build_object ( JKEYS3[1], p_type
                                      ,JKEYS3[2], p_paying_agent
                                      ,JKEYS3[3], p_receive_payments_operator
                                      ,JKEYS3[4], p_money_transfer_operator                                                                
       );
       
       RETURN json_strip_nulls (__result);
       
   END;
  
$$;

COMMENT ON FUNCTION fsc_receipt_pcg.fsc_agent_info_crt_2 (agent_info_t, json, json, json)     
    IS 'Создание объекта "Платёжный агент"';
--
--  USE CASE:
--              see "_TEST_fsc_agent_info_crt_2"   
  
