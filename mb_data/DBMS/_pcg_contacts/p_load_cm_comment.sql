DROP PROCEDURE IF EXISTS pcg_contacts.p_load_cm_comment (timestamp, timestamp, bigint);

CREATE OR REPLACE PROCEDURE pcg_contacts.p_load_cm_comment( 
                    p_dt_start    timestamp 
                   ,p_dt_end      timestamp
                   ,p_id_facility bigint   
)
  LANGUAGE plpgsql
  SECURITY INVOKER
 AS
$$
 DECLARE

   _exec text;
 
 BEGIN  
 
  _exec = format($_$ SELECT id_comment, 
                                         c.id_comment_parent 
                                        ,c.id_entity
                                        ,c.kd_sys_entity
                                        ,c.id_usr_create
                               	        ,c.nm_comment 
                                        ,c.dt_comment  
                                        ,CASE 
                                           WHEN c.dt_del IS NOT NULL THEN TRUE
                                             ELSE FALSE
                                         END pr_del
                                        
                       FROM contacts.cm_comment c
							 INNER JOIN dict.acc_user u ON (c.id_usr_create = u.acc_id_usr )
                       WHERE ((dt_change >= %1$L AND  dt_change < %2$L)
                                  OR 
                              (dt_comment >= %1$L AND dt_comment < %2$L)
                             ) 
                                  AND
					         (u.id_facility = %3$L)     
                   $_$, p_dt_start, p_dt_end, p_id_facility 
   );
 
   INSERT INTO contacts.cm_comment (
                        id_comment
                      , id_comment_parent
                      , id_entity
                      , kd_sys_entity
                      , id_usr_create 
                      , nm_comment
                      , dt_comment
                      , pr_del
    )
   SELECT * FROM dblink ('ccrm', _exec)
                      
        AS cm_comment (  id_comment         bigint 
                        ,id_comment_parent  bigint 
                        ,id_entity          bigint 
                        ,kd_sys_entity      int4 
                        ,id_usr_create      integer 
                        ,nm_comment         text  
                        ,dt_comment         timestamp  
                        ,pr_del             boolean
                    )                    
   ON conflict (id_comment) DO
   UPDATE SET id_comment_parent = excluded.id_comment_parent,
              nm_comment        = excluded.nm_comment,
              pr_del            = excluded.pr_del  
              
   WHERE cm_comment.id_comment_parent IS DISTINCT FROM excluded.id_comment_parent
      OR cm_comment.id_comment_parent <> excluded.id_comment_parent
      OR cm_comment.nm_comment <> excluded.nm_comment
      OR cm_comment.pr_del <> excluded.pr_del;

  EXCEPTION           
       WHEN OTHERS THEN 
        BEGIN
          RAISE 'PCG_CONTACTS.P_LOAD_CM_COMMENT: % -- %', SQLSTATE, SQLERRM;
        END;        
 END;
$$;
 
COMMENT ON PROCEDURE pcg_contacts.p_load_cm_comment (timestamp, timestamp, bigint)
     IS 'Загрузка комментариев к экземпляру сущности';
     
 --  USE CASE
 --
 --  CALL pcg_contacts.p_load_cm_comment ('2023-01-14', '2024-03-14', 22);
 -- -----------------------------------------------------------------------
--   SELECT c.*, u.*, f.*  FROM contacts.cm_comment c
--                  INNER JOIN dict.acc_user u ON (c.id_usr_create = u.acc_id_usr )
--                   INNER JOIN dict.d_facility f ON (f.id_dict = u.id_facility)
--                        WHERE ((c.dt_change >= '2023-01-14 00:00:00' AND  c.dt_change < '2024-03-14 00:00:00')
--           

--                                   OR
--                               (dt_comment >= '2023-01-14 00:00:00' AND dt_comment < '2024-03-14 00:00:00')
--                              )
--                                   AND
--                              (u.id_facility = 22)
 -----------------------------------------------------------------------------------
 
