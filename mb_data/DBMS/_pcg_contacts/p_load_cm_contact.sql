DROP PROCEDURE IF EXISTS pcg_contacts.p_load_cm_contact (timestamp, timestamp,  bigint);
CREATE OR REPLACE PROCEDURE pcg_contacts.p_load_cm_contact (
   p_dt_start    timestamp
  ,p_dt_end      timestamp
  ,p_id_facility bigint   
)  
  LANGUAGE plpgsql
  SECURITY INVOKER
AS
$$
  DECLARE
   _exec text = format
                    ( $_$ SELECT  c.id_contact 
                                 ,c.dt_beg 
                                 ,c.dt_end 
                                 ,c.id_contact_method 
                                 ,c.kd_tp_contact 
                                 ,c.id_usr_create 
                                 ,c.id_reg 
                                 ,c.kd_system 
                                 ,c.id_entity 
                                 ,c.id_jur_contact 
                                 ,c.kd_entity 
                                 ,c."data" 
                                 ,c.kd_status
                             FROM contacts.cm_contact c        
							 INNER JOIN dict.acc_user u ON (c.id_usr_create = u.acc_id_usr )
                             
                           WHERE ((dt_change >= %1$L AND dt_change < %2$L)
                                     OR 
                                  (dt_beg >= %1$L AND dt_beg < %2$L)
                                 ) 
                                   AND
                                 (u.id_facility = %3$L)
                                 
                      $_$, p_dt_start, p_dt_end, p_id_facility
                    );
  BEGIN
     
   INSERT INTO contacts.cm_contact (id_contact
                                  , dt_beg
                                  , dt_end
                                  , id_contact_method
                                  , kd_tp_contact
                                  , id_usr_create
                                  , id_reg
                                  , kd_system
                                  , id_entity
                                  , id_jur_contact
                                  , kd_entity
                                  , "data"
                                  , kd_status
     )
   SELECT * 
     FROM dblink ('ccrm', _exec) 
     AS cm_contact (   id_contact         bigint 
                     , dt_beg             timestamp 
                     , dt_end             timestamp 
                     , id_contact_method  int4 
                     , kd_tp_contact      int4 
                     , id_usr_create      bigint 
                     , id_reg             int8 
                     , kd_system          int4 
                     , id_entity          bigint 
                     , id_jur_contact     bigint 
                     , kd_entity          int8 
                     , "data"             jsonb 
                     , kd_status          int4
                    )
   WHERE id_usr_create NOT IN 
      (SELECT unnest(vl_param) id_user FROM dict.dct_spec_params WHERE kd_param = 2)
     AND CASE
           WHEN id_entity IS NOT NULL
             THEN 
               id_entity NOT IN (SELECT unnest(vl_param) id_client 
                                  FROM dict.dct_spec_params WHERE kd_param = 1
                                )
           ELSE TRUE
         END   
         
   ON conflict (id_contact) DO
   
   UPDATE SET DATA = excluded.data
   WHERE cm_contact.dt_end         IS DISTINCT FROM excluded.dt_end
      OR cm_contact.id_entity      IS DISTINCT FROM excluded.id_entity
      OR cm_contact.id_jur_contact IS DISTINCT FROM excluded.id_jur_contact
      OR cm_contact.kd_entity      IS DISTINCT FROM excluded.kd_entity
      OR cm_contact.data           IS DISTINCT FROM excluded.data
      OR cm_contact.kd_status <> excluded.kd_status
      OR cm_contact.id_reg         IS DISTINCT FROM excluded.id_reg;

  EXCEPTION           
       WHEN OTHERS THEN 
        BEGIN
          RAISE 'PCG_CONTACTS.P_LOAD_CM_CONTACT: % -- %', SQLSTATE, SQLERRM;
        END; 
                                     
 END;     
$$;                

COMMENT ON PROCEDURE pcg_contacts.p_load_cm_contact (timestamp, timestamp,  bigint)
        IS 'Загрузка зарегистрированных обращений';
-- USE CASE
--          CALL pcg_contacts.p_load_cm_contact ('2023-01-14', '2024-03-14', 22);
--          SELECT count(1) FROM contacts.cm_contact;  -- 168
