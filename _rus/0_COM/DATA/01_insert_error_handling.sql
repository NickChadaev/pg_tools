-- ================================================================================
-- Author:		SVETA
-- Create date: 2013-07-29
-- Description:	Создание и начальное заполнение таблицы ошибок
-- для всех полей, участвующих в индексе по умолчанию = ''. 
-- Если оставить null, то индекс не отработает.
-- Файл:  10_com.rerror_handling.sql
-- --------------------------------------------------------------------------------
-- 2014-01-07 Добавлены все подсхемы ('svd','sklt')
-- 2019-05-15 Nick Новое ядро. Сообщение обновляются функциями:
--                    "com.com_p_sys_errors_pk_u()", "com.com_p_sys_errors_fk_u()"
-- ================================================================================
SET search_path = com, public;
--
-- 1. заполнение таблицы  по ошибке 23505 PK+AK
--
--  CREATE TABLE com.sys_errors (
--        err_id       BIGSERIAL         NOT NULL -- PK таблицы   Nick 2013-08-19 добавил  PRIMARY KEY
--       ,err_code     public.t_code5    NOT NULL -- код/номер ошибки 
--       ,message_out  public.t_text              -- как выводить пользователю -- not null после заполнения текста ошибок
--       ,sch_name     public.t_sysname  NOT NULL -- имя схемы
--       ,constr_name  public.t_sysname  NOT NULL -- имя ограничения (Nick Увеличить длину sysnames ???!!!)
--       ,opr_type     public.t_code1    NOT NULL 
--       ,tbl_name     public.t_sysname  NOT NULL -- имя таблицы
--  );
--
INSERT INTO com.sys_errors (err_code, sch_name, constr_name, opr_type, tbl_name)
  SELECT   '23505'
          ,ns.nspname AS sch_name 
          ,c.relname  AS constrant_name
  	      ,'i'        AS opr_type
  	      ,t.relname  AS tbl_name
  	  
  FROM pg_index i 
   JOIN pg_class c       ON (c.oid = i.indexrelid)
   JOIN pg_class t       ON (t.oid = i.indrelid)
   JOIN pg_namespace ns  ON (ns.oid = t.relnamespace)
  WHERE ns.nspname IN ('com', 'nso','ind')
  AND  i.indisunique
ORDER BY ns.nspname,t.relname;
--
--
-- 2. Заполнение таблицы по ошибке 23503 FK  для детей
--
INSERT INTO com.sys_errors (err_code, sch_name, constr_name, opr_type, tbl_name)
  SELECT  
        '23503'
       ,nc.nspname    AS sch_name
       ,const.conname AS constr_name
       ,'i'           AS opr_type
       ,c.relname     AS tbl_name
      
  FROM pg_constraint const
     JOIN pg_class c       ON (c.oid = const.conrelid)
     JOIN pg_class cf      ON (cf.oid = const.confrelid)
     JOIN pg_namespace nc  ON (nc.oid = c.relnamespace)
     JOIN pg_namespace ncf ON (ncf.oid = cf.relnamespace)
  WHERE contype = 'f' AND  nc.nspname IN ('com', 'nso','ind')
  ORDER BY nc.nspname,c.relname;
-- 269
-- sveta 252
--
-- 3. Для родителей
--
INSERT INTO com.sys_errors (err_code, sch_name, constr_name, opr_type, tbl_name)
   SELECT  
         '23503'
       -- ,nc.nspname    AS sch_name
        ,ncf.nspname AS ref_schema
        ,const.conname AS constr_name
        ,'d'           AS opr_type
        ,cf.relname    AS ref_tbl_name
        
   FROM pg_constraint const
     JOIN pg_class c       ON (c.oid = const.conrelid)
     JOIN pg_class cf      ON (cf.oid = const.confrelid)
     JOIN pg_namespace nc  ON (nc.oid = c.relnamespace)
     JOIN pg_namespace ncf ON (ncf.oid = cf.relnamespace)
  WHERE contype = 'f' and  nc.nspname in('com', 'nso','ind')
  ORDER BY ncf.nspname,c.relname;
--
-- 4. Заполнение таблицы по ошибке 23514 check
--
INSERT INTO com.sys_errors (err_code, sch_name, constr_name, opr_type, tbl_name)
  SELECT 
        '23514'
       ,n.nspname 
       ,con.conname 
       ,'i'
       ,c.relname 
       
  FROM pg_class c
    JOIN pg_namespace n    ON  (n.oid = c.relnamespace)
    JOIN pg_constraint con ON  (con.conrelid = c.oid)
  WHERE ( con.contype = 'c' ) AND  n.nspname IN ('com', 'nso','ind');

-- ------------------------------------------------------------------
-- SELECT * FROM com.sys_errors ORDER BY sch_name, tbl_name; -- 78 строк


