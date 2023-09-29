DROP PROCEDURE IF EXISTS fsc_receipt_pcg.p_source_reestr_ins_0 (text, text);
CREATE OR REPLACE PROCEDURE fsc_receipt_pcg.p_source_reestr_ins_0 (
            p_select   text
           ,p_insert   text             
)
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
    -- -------------------------------------------------------------------------
    --  2023-06-28 Создание записей в реестре исходных данных. Финальная часть.
    -- -------------------------------------------------------------------------    
    DECLARE
     __data  record;
     __exec  text;
     --
     __select text := btrim (p_select);
     __insert text := btrim (p_insert);     
     
    BEGIN
            
        FOR __data IN EXECUTE __select 
           LOOP
             __exec := format (__insert
                                ,__data.dt_create   
                                ,__data.company_email  
                                ,__data.company_sno  
                                ,__data.company_inn   
                                ,__data.company_payment_addr  
                                ,__data.company_phones          
                                ,__data.company_name  
                                ,__data.company_bik
                                ,__data.client_name              
                                ,__data.client_inn               
                                ,__data.pmt_type                 
                                ,__data.pmt_sum                  
                                ,__data.item_name                
                                ,__data.item_price               
                                ,__data.item_measure            
                                ,__data.item_sum                
                                ,__data.item_payment_method      
                                ,__data.payment_object           
                                ,__data.item_vat                 
                                ,__data.client_account     
                                ,__data.company_account    
                                ,__data.company_paying_agent 
                                ,__data.bank_name            
                                ,__data.bank_inn             
                                ,__data.bank_bik             
                                ,__data.bank_phones          
                                ,__data.bank_addr     
                                ,__data.type_source_reestr  
                                ,__data.external_id 
			                    ,__data.id_pay
			                    ,__data.rcp_type                                
             );
             EXECUTE __exec;
             
        END LOOP;    
    
   END;
  $$;

COMMENT ON PROCEDURE fsc_receipt_pcg.p_source_reestr_ins_0 (text, text) 
         IS 'Создание записей в реестре исходных данных. Финальная часть.';
-- -----------------------------------------------------------------------------------------------
--  USE CASE:
