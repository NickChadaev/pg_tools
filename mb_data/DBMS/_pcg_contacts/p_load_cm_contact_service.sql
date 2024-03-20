DROP PROCEDURE IF EXISTS pcg_contacts.p_load_cm_contact_services (timestamp, timestamp,  bigint);
CREATE OR REPLACE PROCEDURE pcg_contacts.p_load_cm_contact_services (
   p_dt_start    timestamp         
  ,p_dt_end      timestamp
  ,p_id_facility bigint   
)  
  LANGUAGE plpgsql
  SECURITY INVOKER
AS
$$
 BEGIN
  INSERT INTO contacts.cm_contact_service ( id_contact
                                          , id_service
                                          , dt_change
                                          , id_usr
                                          , pr_initial_contact 
   )
  SELECT * FROM dblink ('ccrm',
          format ($_$ 
                    SELECT  ccs.id_contact 
                           ,ccs.id_service 
                           ,ccs.dt_change 
                           ,ccs.id_usr 
                           ,ccs.pr_initial_contact
                           
                      FROM contacts.cm_contact_service ccs
                      
                         JOIN contacts.cm_service cs 
                           ON (ccs.id_service = cs.id_service) AND NOT cs.pr_previous
                         INNER JOIN dict.acc_user u ON (ccs.id_usr = u.acc_id_usr)  
                         
                      WHERE (ccs.dt_change >= %1L AND ccs.dt_change < %2L AND u.id_facility < %3L)
                   $_$, p_dt_start, p_dt_end, p_id_facility
          )
    )
      AS cm_contact_service ( id_contact         bigint 
                             ,id_service         bigint 
                             ,dt_change          timestamp 
                             ,id_usr             integer 
                             ,pr_initial_contact boolean
         )    
   --  Х  ... полная
   --WHERE EXISTS 
   --     (SELECT 1 FROM contacts.cm_service WHERE id_service = cm_contact_service.id_service)   ;                    
   ON conflict (id_contact, id_service) DO NOTHING;
  
 END;
$$;

COMMENT ON PROCEDURE pcg_contacts.p_load_cm_contact_services (timestamp, timestamp, bigint)
   IS 'Загрузка связанных с обращением процессов';
 
-- USE CASE:
--      CALL pcg_contacts.p_load_cm_contact_services ('2023-01-14', '2024-03-14', 22);
--      SELECT count (1) FROM contacts.cm_contact_service;   -- 2359
--  -------------------------------------------------------------------------------------------
--  id_contact | id_service |         dt_change          | id_usr  | pr_initial_contact 
--  ------------+------------+----------------------------+---------+--------------------
--      3366827 |    4301639 | 2023-01-16 13:43:47.335436 | 3500924 | t
--      3372828 |    4307630 | 2023-01-17 10:52:09.821089 | 3500924 | t
--      3397666 |    4307986 | 2023-01-18 14:39:49.592028 | 3500924 | t
--      3397684 |    4307990 | 2023-01-18 15:52:42.286119 | 3500924 | t
--      3397706 |    4308012 | 2023-01-18 17:00:22.341531 | 3500924 | t
--      3397722 |    4308026 | 2023-01-19 10:02:35.61255  | 3500924 | t
--      3397848 |    4308146 | 2023-01-20 17:42:24.417016 |     101 | t
--      3397868 |    4308158 | 2023-01-21 12:45:57.879612 |     101 | t
--      3397919 |    4308202 | 2023-01-22 19:06:12.621049 | 3500902 | t
--      3397919 |    4308203 | 2023-01-22 19:06:36.843081 | 3500902 | t
--      3397919 |    4308204 | 2023-01-22 19:07:01.422703 | 3500902 | t
--      3397919 |    4308205 | 2023-01-22 19:09:21.595732 | 3500902 | t
--      3397964 |    4308234 | 2023-01-24 10:07:54.663423 | 3500924 | t
--      3397967 |    4308236 | 2023-01-24 10:13:33.612533 | 3500917 | t
--      3397980 |    4308273 | 2023-01-24 11:07:07.722977 | 3500917 | t
--      3397984 |    4308279 | 2023-01-24 11:25:59.51671  | 3500917 | t
--      3397986 |    4308279 | 2023-01-24 11:30:57.56309  | 3500917 | f
--      3397990 |    4308283 | 2023-01-24 12:18:46.521432 | 3500917 | t
--      3397992 |    4308285 | 2023-01-24 12:21:19.573589 | 3500917 | t
--      3398050 |    4308359 | 2023-01-24 17:12:55.385492 | 3500924 | t
--      3398187 |    4308500 | 2023-01-25 12:58:49.516242 | 3500916 | t
--      3398242 |    4308543 | 2023-01-26 12:08:32.078554 | 3500917 | t
--      3398248 |    4308548 | 2023-01-26 15:54:45.314473 | 3500917 | t
--      3398288 |    4308575 | 2023-01-27 17:46:07.947922 | 3500916 | t
--      3398289 |    4308578 | 2023-01-27 20:59:58.615031 | 3500917 | t
--      3398291 |    4308581 | 2023-01-28 12:20:45.298408 | 3500924 | t
--      3398292 |    4308582 | 2023-01-29 19:40:10.504288 | 3500924 | t
