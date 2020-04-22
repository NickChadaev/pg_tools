-- -----------------------------------------------------------------------------------------------
-- 2015_10_06 Nick. Продолжение списка типов объектов предметной области, (файла 09_ins_obj_types)
--                  Здесь всё о типах организационной структуры.
-- -----------------------------------------------------------------------------------------------
SET search_path=com,nso,public,pg_catalog;
--
DO   
$$
   DECLARE 
     rsp_main  public.result_long_t; 
     --
     c_PARENT_TYPE  public.t_str60 := 'C_BD_TYPE'; -- Объекты БД
   BEGIN
     rsp_main := com_codifier.obj_p_codifier_i ( 
                                        c_PARENT_TYPE  -- Код родительского идентификатора      
                                       ,'C_STABLE'     -- Код                                                          
                                       ,'Секционированная таблица'             -- Наименование                                        
                                       ,'31C42397-5900-43AB-9D5E-0C2F487877DC' -- UUID
     );
     IF ( rsp_main.rc > 0 ) THEN
           RAISE NOTICE 'C_STABLE  %, ID = %', rsp_main.errm, rsp_main.rc;
     ELSE
         RAISE EXCEPTION 'C_STABLE %', rsp_main.errm;
     END IF;
     -- 
    END;
$$;
-- -----------------------------------------------
--  SELECT * FROM com_codifier.com_f_obj_codifier_s_sys(429);
--  SELECT * FROM com_codifier.com_f_obj_codifier_s_sys('C_BD_TYPE');
--  ------------------------------------------------------------------
-- NOTICE:  C_STABLE  Создание экземпляра кодификатора выполнено успешно, ID = 429
