--
--  Версия 0. 2023-09-07
--
SELECT  drr.id_pay
       ,trunc(drr.date_pay) AS dt_create
       ,CASE
           WHEN drp.id_pay_reestr_type = 6 
             THEN 'sell_correction'         
             
           WHEN drp.id_pay_reestr_type IN (4, 11) 
             THEN 'sell_refund'         
             ELSE 'sell'
        END rcp_type
        
        ,ab.nm_fio      AS client_name
        ,pkg_util.fnc_get_one_value (ab.vl_field, 903) AS client_mail
        ,drr.sum_pay    AS pmt_sum
        ,ser.nm_service AS item_name
        
        ,(   SELECT CASE
                      WHEN sum (trr.sm_pay) > sum(tr.sm_pay) 
                       THEN 'partial_payment'
                      WHEN sum(trr.sm_pay) = sum(tr.sm_pay) 
                       THEN 'full_payment' 
                       ELSE 'advance'      
                     END          
             FROM ssp_abonent_traffic tr  
                    JOIN ssp_abonent_traffic trr ON trr.id_abonent = tr.id_abonent AND 
                                                    trr.dt_period  = tr.dt_period  AND 
                                                    trr.id_org = tr.id_org         AND 
                                                    trr.id_service = tr.id_service AND 
                                                    trr.kd_entity_type = 8         
             WHERE tr.id_entity = drr.id_pay AND tr.kd_entity_type = 16
          ) AS item_payment_method
          
          , 0         AS pmt_type
          , 'vat20'   AS item_vat
          , ag.nm_org AS company_name
          
          ,(  SELECT f.nm_bik_src FROM ssp_buffer_row_field f 
               WHERE f.id_buffer_row_field = st.id_buffer_row_field
           ) AS company_bik
           
          ,(SELECT prm.vl_param FROM ssp_paramval prm 
                 WHERE prm.id_entity = ag.id_org AND prm.id_param = 2010
           ) AS company_phones
           
          ,(SELECT f.nm_inn_src FROM ssp_buffer_row_field f 
                 WHERE f.id_buffer_row_field = st.id_buffer_row_field
           ) AS company_inn
           
          ,'osn' AS company_sno
          ,''    AS company_payment_address    -- !!!!!
               
FROM ssp_disp_reestr_row drr  
        JOIN ssp_disp_reestr_pays drp ON drp.id_reestr = drr.id_reestr  
        JOIN ssp_disp_reestr_info i   ON i.id_reestr = drp.id_reestr_parent  
        JOIN ssp_statement        st  ON st.id_statement = i.id_statement  
        JOIN ssp_workplace        w   ON w.id_workplace = drp.id_workplace  
        JOIN ssp_org              pod ON pod.id_org = w.id_org  
        JOIN ssp_org              ag  ON ag.id_org = pod.id_org_parent  
        JOIN ssp_pay              pa  ON pa.id_pay = drr.id_pay  
        JOIN ssp_abonent          ab  ON ab.id_abonent = pa.id_abonent  
        JOIN ssp_service          ser ON ser.id_service = drr.id_service
        
        -- условие фискализации по агенту на будущее 
        --
        -- JOIN ssp_paramval pr ON pr.id_entity = pod.id_org_parent AND 
        --                         pr.id_param = 305 AND pr.vl_param = 1 
        --
WHERE i.id_distribution > -1        AND 
      drr.id_row_parent IS NOT NULL AND 
      ag.id_org IN (164793, 19850)  AND -- агенты ВТБ, Элекснет
      --
      st.nm_account_src NOT LIKE '40802%' AND 
        -- --- по примерам с боя такой счет есть только по агенту без договора, 
        --     т.е. единичные платежи в выписке.   
        --
      drr.date_pay >= '01.09.2023';
        --
