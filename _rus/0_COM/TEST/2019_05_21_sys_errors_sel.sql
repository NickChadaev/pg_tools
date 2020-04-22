SELECT * FROM com.sys_errors WHERE ( tbl_name = 'obj_codifier');

UPDATE com.sys_errors 
   SET message_out = 'Нарушено ограничение уникальности: дублируется «Код записи»'
        WHERE (err_code = '23505') AND ( constr_name = 'ak1_obj_codifier');
--
UPDATE com.sys_errors 
   SET message_out = 'Нарушено ограничение уникальности: дублируется «Наименование»'
        WHERE (err_code = '23505') AND ( constr_name = 'ak2_obj_codifier');
--
--  2019-05-31
--
UPDATE com.sys_errors 
   SET message_out = 'Некорректный родитель'
        WHERE (err_code = '23503') AND ( constr_name = 'fk_obj_codifier_grouping_obj_codifier') AND (opr_type = 'i');
--
UPDATE com.sys_errors 
   SET message_out = 'Невозможно удаление родительского элемента'
        WHERE (err_code = '23503') AND ( constr_name = 'fk_obj_codifier_grouping_obj_codifier') AND (opr_type = 'd');


--
-- 9	23505	Нарушено ограничение уникальности: дублируется «Наименование».	com	ak2_obj_codifier	i	obj_codifier
-- 11	23505	Нарушено ограничение уникальности: дублируется «Код записи».	com	ak1_obj_codifier	i	obj_codifier


--  CREATE TABLE com.sys_errors (
--        err_id       BIGSERIAL         NOT NULL -- PK таблицы   Nick 2013-08-19 добавил  PRIMARY KEY
--       ,err_code     public.t_code5    NOT NULL -- код/номер ошибки 
--       ,message_out  public.t_text              -- как выводить пользователю -- not null после заполнения текста ошибок
--       ,sch_name     public.t_sysname  NOT NULL -- имя схемы
--       ,constr_name  public.t_sysname  NOT NULL -- имя ограничения (Nick Увеличить длину sysnames ???!!!)
--       ,opr_type     public.t_code1    NOT NULL 
--       ,tbl_name     public.t_sysname  NOT NULL -- имя таблицы
--  );
