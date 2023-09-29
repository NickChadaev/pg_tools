DROP FUNCTION IF EXISTS fsc_orange_pcg.fsc_check_close_crt_2 (integer, json);
CREATE OR REPLACE FUNCTION fsc_orange_pcg.fsc_check_close_crt_2 (
            p_taxationSystem   integer
           ,p_payments         json 
)
    RETURNS json 
    SECURITY DEFINER
    LANGUAGE plpgsql  

AS $$
   -- ============================================================================ --
   --    2023-08-08 Создание объекта "Check_Close" - Параметры закрытия чека.
   -- ============================================================================ --

   DECLARE
     JKEY             CONSTANT text      := 'checkClose';
     JKEYS            CONSTANT text[]    := array['taxationSystem', 'payments']::text[];       
     TAXATION_SYSTEM  CONSTANT int4range := fsc_orange_pcg.c_taxation_system();
                             
      --  Система налогообложения, 1055:
      --  0 – Общая, ОСН
      --  1 – Упрощенная доход, УСН доход
      --  2 – Упрощенная доход минус расход, УСН доход - расход
      --  3 – Единый налог на вмененный доход, ЕНВД
      --  4 – Единый сельскохозяйственный налог, ЕСН
      --  5 – Патентная система налогообложения, Патент                             
     
     __result  json;
      
   BEGIN
   
      IF NOT (TAXATION_SYSTEM @> p_taxationSystem)
        THEN
           RAISE '"check_close": Код системы налогобложения должен находится в диапазоне от "%" до "%"'
                          , lower(TAXATION_SYSTEM), upper(TAXATION_SYSTEM)-1;
      END IF;   
   
      __result := json_strip_nulls (
                      json_build_object ( JKEYS[1], p_taxationSystem::integer
                                         ,JKEYS[2], p_payments::json
                                        )
      );     
      
      RETURN __result;
   END;
  
$$;

COMMENT ON FUNCTION fsc_orange_pcg.fsc_check_close_crt_2 (integer, json)    
    IS 'Создание объекта "Check_Close" - Параметры закрытия чека.';
--
--  USE CASE:
       -- ---------------------------------------------------------------------------------------------------
       --    SELECT fsc_orange_pcg.fsc_check_close_crt_2 (0, '[{"type":1,"amount":200.20}]', 'ggg@mal.ru');
       --   {"taxationSystem":0,"payments":[{"type":1,"amount":200.20}],"customerContact":"ggg@mal.ru"}	
       --
--           SELECT fsc_orange_pcg.fsc_check_close_crt_2 (0,  fsc_orange_pcg.fsc_payments_crt_3 (array[(1, 200.2)]::public.payments_rt[])
--           , 'ggg@mal.ru');	
       --    --
       --         {"taxationSystem":0,"payments":[{"type":1,"amount":200.20}],"customerContact":"ggg@mal.ru"}			 
       	    
--           SELECT fsc_orange_pcg.fsc_check_close_crt_2 (0,  fsc_orange_pcg.fsc_payments_crt_3 (array[(9, 200.2)]::public.payments_rt[])
--           , 'ggg@mal.ru');
       --    ERROR:  "payments": Вид оплаты должен принадлежать множеству "[{1,2,14,15,16}]"
	   --
       --    SELECT fsc_orange_pcg.fsc_check_close_crt_2 (8, '[{"type":1,"amount":200.20}]', 'ggg@mal.ru');
       --    ERROR:  "check_close": Код системы налогобложения должен находится в диапазоне от "0" до "5"	   
       -- ---------------------------------------------------------------------------------------------------
