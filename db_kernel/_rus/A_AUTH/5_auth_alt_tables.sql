/* ========================================================================= */
/*  DBMS name:      PostgreSQL 8                                             */
/*  Created on:     20.04.2015 19:11:22                                      */
/*    2015-05-29  тип t_timestampz заменён на t_timestamp                    */
/*         заменены значения по умолчанию  и правятся функции                */ 
/*  ------------------------------------------------------------------------ */
/*   2015-07-03  Добавлены группа и клиентские объекты.                      */
/*  ------------------------------------------------------------------------ */
/*  Новая генерация схемы: 21.07.2015 16:46:18                               */
/*  ------------------------------------------------------------------------ */
/*  Новая генерация схемы: 06.08.2015                                        */ 
/*  2015-08-25       Добавлены ограничения на доступ к данным.               */
/*  ------------------------------------------------------------------------ */
/*  2015-10-03 Roman:  Удалены таблицы: auth_role_perm_serv_object,          */ 
/*                                      auth_role_perm_serv_object_hist      */  
/*  Cоответствие LOGIN,  роли, матрицы прав доступа к серверному объекту     */
/*  auth_role_perm_serv_object - Роль и разрешение для серверного объекта    */
/*  cтала единой таблицей, объединяющей роль, серверный объект и разрешение. */ 
/*  ------------------------------------------------------------------------ */
/*  Nick:  По такой-же схеме сделана модификация клиентской части.           */
/*  ------------------------------------------------------------------------ */
/*  2015-10-21 Roman:  Введена таблица auth_log_data                         */ 
/*                Из auth_log удаляются IMPACT_TYPE, IMPACT_DESCR            */
/* ========================================================================= */
SET search_path=auth,nso,com,public,pg_catalog;

/*==============================================================*/
/* Table: auth_user                                             */
/*==============================================================*/
--
ALTER TABLE auth_user
   ADD CONSTRAINT fk_auth_user_can_have_auth_log FOREIGN KEY (id_log)
      REFERENCES auth_log (id_log)
      ON DELETE RESTRICT ON UPDATE RESTRICT;

ALTER TABLE auth_user
   ADD CONSTRAINT fk_nso_record_defines_high_sequrity_level FOREIGN KEY (high_level_id)
      REFERENCES nso.nso_record (rec_id)
      ON DELETE RESTRICT ON UPDATE RESTRICT;

ALTER TABLE auth_user
   ADD CONSTRAINT fk_nso_record_defines_low_sequrity_level FOREIGN KEY (low_level_id)
      REFERENCES nso.nso_record (rec_id)
      ON DELETE RESTRICT ON UPDATE RESTRICT;

ALTER TABLE auth_user
   ADD CONSTRAINT fk_nso_record_defines_user FOREIGN KEY (user_employe_id)
      REFERENCES nso.nso_record (rec_id)
      ON DELETE RESTRICT ON UPDATE RESTRICT;

/*==============================================================*/
/* Table: auth_user_hist                                        */
/*==============================================================*/
--
ALTER TABLE auth_user_hist
   ADD CONSTRAINT fk_auth_log_has_auth_user_hist FOREIGN KEY (id_log)
      REFERENCES auth_log (id_log)
      ON DELETE RESTRICT ON UPDATE RESTRICT;
/*==============================================================*/
/* Table: auth_sql_clause_log                                   */
/*==============================================================*/
-- ALTER TABLE auth_sql_clause_log
--    ADD CONSTRAINT fk_auth_log_has_auth_sql_clause_log foreign key ( id_log )
--       REFERENCES auth_log ( id_log )
--       ON DELETE RESTRICT ON UPDATE RESTRICT;
--
-- 2015-10-21
ALTER TABLE auth_sql_clause_log
   ADD CONSTRAINT fk_auth_log_data_has_auth_sql_log FOREIGN KEY (data_log_id)
      REFERENCES auth_log_data (data_log_id)
      ON DELETE RESTRICT ON UPDATE RESTRICT;

/*==============================================================*/
/* Table: auth_log_data                                         */
/*==============================================================*/
ALTER TABLE auth_log_data
   ADD CONSTRAINT fk_auth_log_has_auth_log_data FOREIGN KEY (id_log)
      REFERENCES auth_log (id_log)
      ON DELETE RESTRICT ON UPDATE RESTRICT;
--
-- 2015-10-21
/*==============================================================*/
/* Table: auth_role                                             */
/*==============================================================*/
ALTER TABLE auth_role
   ADD CONSTRAINT fk_auth_role_can_have_auth_log FOREIGN KEY (id_log)
      REFERENCES auth_log (id_log)
      ON DELETE RESTRICT ON UPDATE RESTRICT;

ALTER TABLE auth_role
   ADD CONSTRAINT fk_auth_role_inherits_auth_role FOREIGN KEY (parent_role_id)
      REFERENCES auth_role (role_id)
      ON DELETE RESTRICT ON UPDATE RESTRICT;

/*==============================================================*/
/* Table: auth_role_hist                                        */
/*==============================================================*/
ALTER TABLE auth_role_hist ADD CONSTRAINT fk_auth_log_connects_auth_role_hist FOREIGN KEY (id_log)
      REFERENCES auth_log (id_log)
      ON DELETE RESTRICT ON UPDATE RESTRICT;

/*==============================================================*/
/* Table: auth_user_role                                        */
/*==============================================================*/
ALTER TABLE auth.auth_user_role
   ADD CONSTRAINT fk_auth_user_role_belongs_role FOREIGN KEY (role_id)
      REFERENCES auth.auth_role (role_id)
      ON DELETE RESTRICT ON UPDATE RESTRICT;

ALTER TABLE auth.auth_user_role
   ADD CONSTRAINT fk_auth_user_role_has_zero_role FOREIGN KEY (init_role_id)
      REFERENCES auth.auth_role (role_id)
      ON DELETE RESTRICT ON UPDATE RESTRICT;

ALTER TABLE auth.auth_user_role
   ADD CONSTRAINT fk_auth_user_has_auth_roles FOREIGN KEY (user_id)
      REFERENCES auth.auth_user (user_id)
      ON DELETE RESTRICT ON UPDATE RESTRICT;

ALTER TABLE auth.auth_user_role
  ADD CONSTRAINT fk_auth_user_role_can_have_auth_log FOREIGN KEY (id_log)
      REFERENCES auth.auth_log (id_log) MATCH SIMPLE
      ON UPDATE RESTRICT ON DELETE RESTRICT;

/*==============================================================*/
/* Table: auth_role_perm_serv_object       REMOVED    Roman     */
/*==============================================================*/

/*==============================================================*/
/* Table: auth_role_perm_serv_object_hist    REMOVED   Roman     */
/*==============================================================*/

/*==============================================================*/
/* Table: auth_role_perm_serv_object          RENAME  Roman     */
/*==============================================================*/
ALTER TABLE auth_role_perm_serv_object
   ADD CONSTRAINT fk_auth_log_can_link_auth_role_server_obj_permition FOREIGN KEY (id_log)
      REFERENCES auth_log (id_log)
      ON DELETE RESTRICT ON UPDATE RESTRICT;
--
ALTER TABLE auth_role_perm_serv_object
   ADD CONSTRAINT fk_auth_server_object_has_auth_permissions FOREIGN KEY (serv_object_id)
      REFERENCES auth_server_object (serv_object_id)
      ON DELETE RESTRICT ON UPDATE RESTRICT;
--
ALTER TABLE auth_role_perm_serv_object
   ADD CONSTRAINT fk_auth_server_permission_joins_server_object FOREIGN KEY (serv_perm_id)
      REFERENCES auth_server_permission (serv_perm_id)
      ON DELETE RESTRICT ON UPDATE RESTRICT;
-- ADD Roman
ALTER TABLE auth_role_perm_serv_object
   ADD CONSTRAINT fk_auth_role_perm_server_object_connects_role FOREIGN KEY (role_id)
      REFERENCES auth_role (role_id)
      ON DELETE RESTRICT ON UPDATE RESTRICT;
/*==============================================================*/
/* Table: auth_server_permission                                */
/*==============================================================*/
ALTER TABLE auth_server_permission
   ADD CONSTRAINT fk_auth_log_can_link_auth_server_permition FOREIGN KEY (id_log)
      REFERENCES auth_log (id_log)
      ON DELETE RESTRICT ON UPDATE RESTRICT;
/*==============================================================*/
/* Table: auth_server_object                                    */
/*==============================================================*/
ALTER TABLE auth_server_object
   ADD CONSTRAINT fk_auth_log_can_link_auth_server_object FOREIGN KEY (id_log)
      REFERENCES auth_log (id_log)
      ON DELETE RESTRICT ON UPDATE RESTRICT;
--
ALTER TABLE auth_server_object
   ADD CONSTRAINT fk_auth_server_object_grouping_objects FOREIGN KEY (parent_serv_object_id)
      REFERENCES auth_server_object (serv_object_id)
      ON DELETE RESTRICT ON UPDATE RESTRICT;
--
ALTER TABLE auth_server_object
   ADD CONSTRAINt fk_obj_codifier_defines_server_obj_type FOREIGN KEY (auth_serv_object_type_id)
      REFERENCES com.obj_codifier (codif_id)
      ON DELETE RESTRICT ON UPDATE RESTRICT;

/*==============================================================*/
/* Table: auth_server_object_perm_hist                          */
/*==============================================================*/
ALTER TABLE auth_server_object_perm_hist
   ADD CONSTRAINT fk_auth_log_links_auth_server_object_perm_hist FOREIGN KEY (id_log)
      REFERENCES auth_log (id_log)
      ON DELETE RESTRICT ON UPDATE RESTRICT;

/*==============================================================*/
/* Table: auth_client_object                                    */
/*==============================================================*/
ALTER TABLE auth_client_object
   ADD CONSTRAINT fk_auth_client_object_can_link_auth_log FOREIGN KEY (id_log)
      REFERENCES auth_log (id_log)
      ON DELETE RESTRICT ON UPDATE RESTRICT;

ALTER TABLE auth_client_object
   ADD CONSTRAINT fk_auth_clint_object_grouping FOREIGN KEY (parent_client_object_id)
      REFERENCES auth_client_object (client_object_id)
      ON DELETE RESTRICT ON UPDATE RESTRICT;

ALTER TABLE auth_client_object
   ADD CONSTRAINT fk_obj_codifier_defines_type_client_object FOREIGN KEY (client_object_type_id)
      REFERENCES com.obj_codifier (codif_id)
      ON DELETE RESTRICT ON UPDATE RESTRICT;

/*==============================================================*/
/* Table: auth_client_permition                                 */
/*==============================================================*/
ALTER TABLE auth_client_permition
   ADD CONSTRAINT fk_auth_client_domain_permision_can_link_auth_log FOREIGN KEY (id_log)
      REFERENCES auth_log (id_log)
      ON DELETE RESTRICT ON UPDATE RESTRICT;

/*==============================================================*/
/* Table: auth_client_object_perm_hist                          */
/*==============================================================*/
ALTER TABLE auth_client_object_perm_hist
   ADD CONSTRAINT fk_auth_log_has_auth_client_object_perm_hist FOREIGN KEY (id_log)
      REFERENCES auth_log (id_log)
      ON DELETE RESTRICT ON UPDATE RESTRICT;

/*==============================================================*/
/* Table: auth_group                                            */
/*==============================================================*/
/*==============================================================*/
/* Table: auth_group_role                                       */
/*==============================================================*/
/*==============================================================*/
/* Table: auth_group_role_hist                                  */
/*==============================================================*/
/*==============================================================*/
/* Table: auth_role_data_access_perm                            */
/*==============================================================*/
/*==============================================================*/
/* Table: auth_data_types_access_perm                           */
/*==============================================================*/
/*==============================================================*/
/* Table: auth_data_access_perm                                 */
/*==============================================================*/
/*==============================================================*/
/* Table: auth_data_access_perm_hist                            */
/*==============================================================*/

/*==============================================================*/
/* Table: apr_glb_role                                          */
/*==============================================================*/
ALTER TABLE auth.apr_glb_role
   ADD CONSTRAINT fk_apr_glb_roles_inherits_apr_glb_roles FOREIGN KEY (parent_apr_role_id)
      REFERENCES auth.apr_glb_role (apr_role_id)
      ON DELETE RESTRICT ON UPDATE RESTRICT;
--
ALTER TABLE auth.apr_glb_role
   ADD CONSTRAINT fk_obj_codifier_defines_apr_role_type FOREIGN KEY (role_type_id)
      references com.obj_codifier (codif_id)
      ON DELETE RESTRICT ON UPDATE RESTRICT;
--
ALTER TABLE auth.apr_glb_role
   ADD CONSTRAINT fk_obj_object_generates_apr_glb_role FOREIGN KEY (apr_role_id)
      REFERENCES com.obj_object (object_id)
      ON DELETE RESTRICT ON UPDATE RESTRICT;
--
ALTER TABLE auth.apr_glb_role
   ADD CONSTRAINT fk_auth_log_can_link_apr_glb_role FOREIGN KEY (id_log)
      REFERENCES auth.auth_log (id_log) MATCH SIMPLE
      ON UPDATE RESTRICT ON DELETE RESTRICT;
--
/*==============================================================*/
/* Table: apr_obj_role                                          */
/*==============================================================*/
ALTER TABLE auth.apr_obj_role
   ADD CONSTRAINT fk_nso_record_defines_perm_obj_app_role foreign key (perm_rec_id)
      REFERENCES nso.nso_record (rec_id)
      ON DELETE RESTRICT ON UPDATE RESTRICT;

ALTER TABLE auth.apr_obj_role
   ADD CONSTRAINT fk_obj_object_generates_apr_obj_role FOREIGN KEY (apr_role_id)
      REFERENCES com.obj_object (object_id)
      ON DELETE RESTRICT ON UPDATE RESTRICT;

ALTER TABLE auth.apr_obj_role
   ADD CONSTRAINT fk_obj_object_protected_apr_obj_role FOREIGN KEY (obj_object_id)
      REFERENCES com.obj_object (object_id)
      ON DELETE RESTRICT ON UPDATE RESTRICT;

ALTER TABLE auth.apr_obj_role
   ADD CONSTRAINT fk_auth_log_can_link_apr_obj_role FOREIGN KEY (id_log)
      REFERENCES auth.auth_log (id_log) MATCH SIMPLE
      ON UPDATE RESTRICT ON DELETE RESTRICT;

/*==============================================================*/
/* Table: auth_role_perm_client_object                          */
/*==============================================================*/
ALTER TABLE auth.auth_role_perm_client_object
   ADD CONSTRAINT fk_apr_role_ui_cmd_apr_role FOREIGN KEY (apr_role_id)
      REFERENCES com.obj_object (object_id)
      ON DELETE RESTRICT ON UPDATE RESTRICT;
--
ALTER TABLE auth.auth_role_perm_client_object
   ADD CONSTRAINT fk_auth_role_perm_client_object_cmd_apr_role FOREIGN KEY (client_object_id)
      REFERENCES auth.auth_client_object (client_object_id)
      ON DELETE RESTRICT ON UPDATE RESTRICT;
--
ALTER TABLE auth.auth_role_perm_client_object
   ADD CONSTRAINT fk_auth_log_can_link_auth_client_object_permition FOREIGN KEY (id_log)
      REFERENCES auth.auth_log (id_log) MATCH SIMPLE
      ON UPDATE RESTRICT ON DELETE RESTRICT;

/*==============================================================*/
/* Table: apr_glb_role_access                                   */
/*==============================================================*/
ALTER TABLE auth.apr_glb_role_access
   ADD CONSTRAINT fk_apr_role_has_access_apr_role FOREIGN KEY (apr_role_id)
      REFERENCES com.obj_object (object_id)
      ON DELETE RESTRICT ON UPDATE RESTRICT;

ALTER TABLE auth.apr_glb_role_access
   ADD CONSTRAINT fk_nso_record_defines_perm_glb_app_role FOREIGN KEY (perm_rec_id)
      REFERENCES nso.nso_record (rec_id)
      ON DELETE RESTRICT ON UPDATE RESTRICT;

ALTER TABLE auth.apr_glb_role_access
   ADD CONSTRAINT fk_obj_codifier_defines_object_type_apr_role_access FOREIGN KEY (object_type_id)
      REFERENCES com.obj_codifier (codif_id)
      ON DELETE RESTRICT ON UPDATE RESTRICT;


ALTER TABLE auth.apr_glb_role_access
   ADD CONSTRAINT fk_auth_log_can_link_apr_glb_role_access FOREIGN KEY (id_log)
      REFERENCES auth.auth_log (id_log) MATCH SIMPLE
      ON UPDATE RESTRICT ON DELETE RESTRICT;

/*==============================================================*/
/* Table: apr_role_user                                         */
/*==============================================================*/
ALTER TABLE auth.apr_role_user
   ADD CONSTRAINT fk_apr_role_user_auth_user FOREIGN KEY (user_id)
      REFERENCES auth.auth_user (user_id)
      ON DELETE RESTRICT ON UPDATE RESTRICT;

ALTER TABLE auth.apr_role_user
   ADD CONSTRAINT fk_apr_role_has_apr_role_user FOREIGN KEY (apr_role_id)
      REFERENCES com.obj_object (object_id)
      ON DELETE RESTRICT ON UPDATE RESTRICT;

ALTER TABLE auth.apr_role_user
   ADD CONSTRAINT fk_auth_log_can_link_apr_role_user FOREIGN KEY (id_log)
      REFERENCES auth.auth_log (id_log) MATCH SIMPLE
      ON UPDATE RESTRICT ON DELETE RESTRICT;

