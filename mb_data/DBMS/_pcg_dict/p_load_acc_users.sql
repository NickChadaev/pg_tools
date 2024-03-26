DROP PROCEDURE IF EXISTS pcg_dict.p_load_acc_user();

DROP PROCEDURE IF EXISTS pcg_dict.p_load_acc_user(bigint);
CREATE OR REPLACE PROCEDURE pcg_dict.p_load_acc_user(p_id_facility bigint)
  LANGUAGE plpgsql
  SECURITY INVOKER
AS
$$
 DECLARE
  _select text =  $_$  SELECT acc_id_usr, nm_usr, concat_ws(' ', nm_last, nm_first, nm_middle) fio, 
                              id_facility, pr_access, kd_otd, kd_otd_list
                       FROM dict.acc_user WHERE (id_facility = %L)
                  $_$;
  _exec  text;

 BEGIN   
    _exec = format(_select, p_id_facility);      
 
    INSERT INTO dict.dct_users (acc_id_usr
                              , nm_usr
                              , fio
                              , id_facility
                              , pr_access
                              , kd_otd
                              , kd_otd_list
    )
    SELECT * FROM dblink ('ccrm', _exec) 
      AS dct_users (acc_id_usr  bigint, 
                    nm_usr      text, 
                    fio         text, 
                    id_facility int4,
                    pr_access   boolean, 
                    kd_otd      int8,
                    kd_otd_list integer[]
        )                      
    ON CONFLICT (acc_id_usr) DO
    UPDATE SET nm_usr      = excluded.nm_usr,
               fio         = excluded.fio,
               id_facility = excluded.id_facility,
               pr_access   = excluded.pr_access,
               kd_otd      = excluded.kd_otd,
               kd_otd_list = excluded.kd_otd_list
               
    WHERE dct_users.nm_usr      <> excluded.nm_usr
       or dct_users.fio         <> excluded.fio
       or dct_users.id_facility <> excluded.id_facility
       or dct_users.pr_access   <> excluded.pr_access
       or dct_users.kd_otd      <> excluded.kd_otd
       or dct_users.kd_otd_list IS DISTINCT FROM excluded.kd_otd_list;
        
  EXCEPTION           
       WHEN OTHERS THEN 
        BEGIN
          RAISE 'PCG_DICT.P_LOAD_ACC_USER: % -- %', SQLSTATE, SQLERRM;
        END;  
        
 END;     
$$;                
COMMENT ON PROCEDURE pcg_dict.p_load_acc_user(bigint) 
                        IS 'Загрузка справочника пользователей выбранной организации';


-- USE CASE
--            CALL pcg_dict.p_load_acc_user();
--            SELECT * FROM dict.dct_users;  --   
--            SELECT count(1) FROM dict.dct_users;  --  4471
