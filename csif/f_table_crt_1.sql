--
--    2023-07-27
--
-- sudo apt-cache search oracle_fdw 
-- sudo apt-get install postgresql-13-oracle-fdw
-- sudo apt-get install postgresql-13-orafce  

DROP FOREIGN TABLE IF EXISTS fiscalization.ssp_pay_hist_fisc;
CREATE FOREIGN TABLE fiscalization.ssp_pay_hist_fisc(
     id_pay_fisc       bigint OPTIONS (key 'true') NOT NULL   
    ,id_pay            bigint    NOT NULL                        
	,type_object       integer   NOT NULL    -- rcp_type                      
    ,nn_pay_kkt        text          NULL                        
	,dt_pay_fisc       date      NOT NULL                         
    ,kd_oper_type      integer   NOT NULL    -- 1                    
	,kd_error          integer       NULL                         
    ,kd_error_type     integer       NULL                        
	,kd_state_pay_hist integer   NOT NULL    -- 0 ??                     
    ,fisc_uid          text          NULL                        
	,fisc_info         text          NULL                         
)
    SERVER moe_test
    OPTIONS (schema 'CURR', table 'SSP_PAY_HIST_FISC');   
    
 -- SELECT id_receipt, id_pay, rcp_type, date(dt_create), rcp_status, rcp_nmb FROM public._xxx    

INSERT INTO fiscalization.ssp_pay_hist_fisc (
     id_pay_fisc       
    ,id_pay              
	,type_object                      
    ,nn_pay_kkt          
	,dt_pay_fisc          
    ,kd_oper_type            
	,kd_state_pay_hist           
    ,fisc_uid            
	,fisc_info            
)    
   
 SELECT id_receipt      AS id_pay_fisc
      , id_pay          
      , rcp_type        AS type_object
      , NULL            AS nn_pay_kkt 
      , dt_create       AS dt_pay_fisc  --  date(dt_create)
      , 1               AS kd_oper_type
      , rcp_status      AS kd_state_pay_hist
      , rcp_nmb         AS fisc_uid 
      , NULL            AS fisc_info 
FROM public._xxx;
--
select * from fiscalization.ssp_pay_hist_fisc;
BEGIN;
update fiscalization.ssp_pay_hist_fisc set TYPE_OBJECT = 1;
commit;
delete from fiscalization.ssp_pay_hist_fisc;