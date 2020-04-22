--
-- 2019-06-24  Nick Постинсталляционный скрипт. 
--
     ALTER DATABASE db_k SET search_path = public, com, com_codifier, com_domain, com_object, com_relation, com_error
                                     ,nso, nso_structure, nso_data, nso_exchange
                                     ,ind, ind_structure, ind_data, ind_exchange
                                     ,auth, auth_serv_obj, auth_apr, auth_exchange, uio, utl, db_info, pg_catalog; 
     ALTER DATABASE db_k SET utl.x_debug = false; 

     COMMENT ON DATABASE db_k IS 'Прототип базы. Ядро 2.0 от 2018-12-14. Релиз от 2019-08-11 (Hg Ревизия 203)';
-- 