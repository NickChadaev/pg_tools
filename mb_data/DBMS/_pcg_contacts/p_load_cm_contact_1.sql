DROP PROCEDURE IF EXISTS pcg_contacts.p_load_cm_contact_1 (timestamp, timestamp,  bigint);
CREATE OR REPLACE PROCEDURE pcg_contacts.p_load_cm_contact_1 (
   p_dt_start    timestamp
  ,p_dt_end      timestamp
  ,p_id_facility bigint   
)  
  LANGUAGE plpgsql
  SECURITY INVOKER
AS
$$
 DECLARE
   _exec  text = format ($_$ 
            SELECT cc.id_contact,
                       split_part (substring(cm.nm_message from 'Приложение:</b> (.*)'), '<br', 1) nm_app,
                       lower(split_part (substring(cm.nm_message from 'Устройство:</b> (.*)'), '<br', 1)) nm_device,
                       split_part (substring(cm.nm_message from 'Версия ОС:</b> (.*)'), '<br', 1) nm_ver_os
                  FROM contacts.cm_contact cc
                
                JOIN contacts.cm_contact_service ccs --Берем только первое обращение процесса
                  ON (cc.id_contact = ccs.id_contact)
                
                JOIN contacts.cm_message_service cms --Берем только первое сообщение по обращению
                  ON ccs.id_service = cms.id_service
                 AND cms.id_message = (SELECT min(id_message)
                                         FROM contacts.cm_message_service
                                          WHERE id_service = cms.id_service
                                       )
                                       
                JOIN contacts.cm_message cm ON cms.id_message = cm.id_message
                                              AND cm.kd_tp_contact = 1
                INNER JOIN dict.acc_user u ON (cm.id_usr = u.acc_id_usr)                              
                WHERE cc.kd_system = 104 AND cc.id_contact_method = 3 AND 
                      cm.dt_message >= %1$L AND cm.dt_message < %2$L AND 
                      u.id_facility = %3$L
             $_$, p_dt_start, p_dt_end, p_id_facility
    );
 
 BEGIN
   -- Отдельно добавляем атрибуты сообщений ЛК, чтобы загрузка отрабатывала быстрее
   
   WITH upd_attr_lk
     AS (SELECT id_contact,
                COALESCE (jsonb_build_object('KD_SOFTWARE',
                             CASE
                               WHEN nm_device LIKE 'mozilla/5.0%%' THEN 1 --Браузер
                               WHEN nm_device IS NULL THEN 3 --Не найдено
                               ELSE 2 --В остальных случаях это приложение
                             END,
                             
                             'KD_DEVICE',
                             CASE
                               WHEN nm_device LIKE '%windows nt%' OR nm_device LIKE '%macintosh%' THEN 2 --ПК
                               WHEN nm_device LIKE '%android%'
                                 OR nm_device LIKE '%iphone%'
                                 OR nm_device LIKE '%ipad%'
                                 OR (nm_device IS NOT NULL AND nm_device NOT LIKE 'mozilla/5.0%%') THEN 1 --Телефон
                               ELSE 3 --Не найдено
                             END), '{}'::jsonb
                         ) vl_data
           FROM dblink ('ccrm', _exec) 
           AS cm_contact ( id_contact bigint 
                          ,nm_app     text 
                          ,nm_device  text 
                          ,nm_ver_os  text
                        )
   )
   UPDATE contacts.cm_contact cc SET DATA = COALESCE (data, '{}'::jsonb) || ual.vl_data
   FROM upd_attr_lk ual WHERE (cc.id_contact = ual.id_contact);
   
  EXCEPTION           
       WHEN OTHERS THEN 
        BEGIN
          RAISE 'PCG_CONTACTS.P_LOAD_CM_CONTACT_1: % -- %', SQLSTATE, SQLERRM;
        END; 

 END;
$$;
 
COMMENT ON PROCEDURE pcg_contacts.p_load_cm_contact_1 (timestamp, timestamp, bigint)
     IS 'Отдельно добавляем атрибуты сообщений ЛК';
     --
     -- USE CASE:
     --
     -- CALL pcg_contacts.p_load_cm_contact_1 ('2023-01-14', '2024-03-14', 22);     
