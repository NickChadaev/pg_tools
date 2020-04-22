-- =====================================================
-- Create date: 2014-07-01 Оля
-- Description:	заполнение таблицы ошибок obj_errors.
-- ------------------------------------------------------
-- 2019-05-15 Nick Новое ядро.  Пока без триггера.
-- ------------------------------------------------------
--     +-  1) Минимальное заполнение таблиц сообщений.
--            6000x - общие
--            61xxx - COM
--            62xxx - NSO
--            63xxx - IND
--            64xxx - AUTH
--            65xxx - UTL
-- =====================================================
SET search_path=com,pg_catalog;

-- ---------------------------
--  Общие сообщения
-- ---------------------------
INSERT INTO com.obj_errors( err_code, message_out, sch_name, qty)
    VALUES (60000, 'Все параметры являются обязательными, NULL значения запрещены', '', 0);
--
INSERT INTO com.obj_errors( err_code, message_out, sch_name, qty)
    VALUES (60001, 'В шаблоне сообщения допущена ошибка, неправильный синтаксис', '', 0);    
--
INSERT INTO com.obj_errors( err_code, message_out, sch_name) 
     VALUES (60005, 'Дата начала периода актуальности: {0}, больше его конца: {1}', '');    
--    
INSERT INTO com.obj_errors( err_code, message_out, sch_name)
     VALUES (60004, 'Схема: {0} не существует', '');
--  --

--  -- ----------------------------
--  --   Com
--  -- ----------------------------
--  INSERT INTO com.obj_errors( err_code, message_out, sch_name) 
--      VALUES (61000, 'Указан не существующий идентификатор владельца', 'com');
--  --

-- -----------------------------------------------
--                61xxx - COM
-- -----------------------------------------------
--
INSERT INTO com.obj_errors( err_code, message_out, sch_name, qty) 
    VALUES (61010
          ,'Неустановленная ошибка возникла при создании экземпляра кодификатора, Код = "{0}"'
          , 'com'
          ,1
          );
--
INSERT INTO com.obj_errors( err_code, message_out, sch_name, qty) 
    VALUES (61011
          ,'Удаление экземпляра кодификатора, запись с кодом = "{0}" не существует'
          , 'com'
          ,1
          );
--          
INSERT INTO com.obj_errors( err_code, message_out, sch_name, qty) 
    VALUES (61012
          ,'Удаление экземпляра кодификатора, запись с ID = "{0}" не существует'
          , 'com'
          ,1
          );
 --         
INSERT INTO com.obj_errors( err_code, message_out, sch_name, qty) 
    VALUES (61040, 'Запись кодификатора с ID = "{0}" не найдена', 'com', 1);
--
INSERT INTO com.obj_errors( err_code, message_out, sch_name, qty) 
    VALUES (61041, 'Запись кодификатора с кодом = "{0}" не найдена', 'com', 1);
--
-- Nick 2019-06-28    
--
INSERT INTO com.obj_errors( err_code, message_out, sch_name, qty) 
    VALUES (61070, 'Неправильный тип атрибута, запись кодификатора с кодом = "{0}" не найдена', 'com', 1);
--
INSERT INTO com.obj_errors( err_code, message_out, sch_name, qty) 
    VALUES (61071, 'Атрибут может быть привязан только к узловому элементу, с код типа узлового элемента = "{0}" не найдена', 'com', 1);
--
INSERT INTO com.obj_errors( err_code, message_out, sch_name, qty) 
    VALUES (61072, 'Для ссылочного атрибута НСО, типа "{0}", код НС-объекта обязательно должен быть заполнен', 'com', 1);
--
-- Nick 2019-06-28    
--
-- -----------------
-- Nick 2019-07-01
--
INSERT INTO com.obj_errors( err_code, message_out, sch_name, qty) 
    VALUES (61073, 'Атрибут с ID = "{0}" не найден', 'com', 1);
--
-- Nick 2019-11-13
--
INSERT INTO com.obj_errors( err_code, message_out, sch_name, qty) 
    VALUES (61074, 'Атрибут с кодом = "{0}" не найден', 'com', 1);
-- -----------------
-- Nick 2019-07-01
--
INSERT INTO com.obj_errors( err_code, message_out, sch_name, qty) 
    VALUES (61050
           ,'Значение родительского элемента равное NULL недопустимо для записи с кодом = "{0}"'
           ,'com'
           ,1
           );
--
INSERT INTO com.obj_errors( err_code, message_out, sch_name, qty) 
    VALUES (61051
           ,'Несуществующий код родительского элемента, его величина = "{0}"'
           ,'com'
           ,1
           );
--
--   2019-06-18/2015-04-15  Ошибки связанные с контролем атрибутов
--
INSERT INTO com.obj_errors( err_code, message_out, sch_name) 
     VALUES (60090, 'Слишком длинная строка, произойдёт усечение', '');
--
INSERT INTO com.obj_errors( err_code, message_out, sch_name) 
     VALUES (60091, 'Узловой атрибут не должен иметь значений', '');
--
INSERT INTO com.obj_errors( err_code, message_out, sch_name) 
     VALUES (60092, 'Атрибут-ссылка не проверяется в этой функции', '');
--
--   2019-06-22  Ошибки связанные с контролем типов, замена '22P02', '22003', '22007', '22008'
--
INSERT INTO com.obj_errors( err_code, message_out, sch_name) 
     VALUES ('22P02', 'Неверное значение для {0}, величина {1}', '');
--
INSERT INTO com.obj_errors( err_code, message_out, sch_name) 
     VALUES ('22003', 'Величина слишком велика для типа {0}', '');
--
INSERT INTO com.obj_errors( err_code, message_out, sch_name) 
     VALUES ('22007', 'Неверное значение для {0}, величина {1}', '');
--
INSERT INTO com.obj_errors( err_code, message_out, sch_name) 
     VALUES ('22008', 'Величина: {0}, слишком велика для типа {1}', '');
--
INSERT INTO com.obj_errors( err_code, message_out, sch_name) 
     VALUES ('600XX', 'Ошибка в переменной типа hstore', '');
--     
-- --            62xxx - NSO
-- --------------------------------------------
--
INSERT INTO com.obj_errors( err_code, message_out, sch_name) 
     VALUES ('62003', 'Ошибка в коде родительского НСО: {0}, его нет, либо он не узловой', 'nso');
--
INSERT INTO com.obj_errors( err_code, message_out, sch_name) 
     VALUES ('62010', 'Ошибка в коде типа НСО: {0}, он отсутствует', 'nso');
-- -------------------------------------------------------------------------
-- 2019-07-19
--
INSERT INTO com.obj_errors( err_code, message_out, sch_name) 
     VALUES ('62020', 'Ошибка в коде НСО: {0}, объект с таким кодом отсутствует', 'nso');
--
INSERT INTO com.obj_errors( err_code, message_out, sch_name) 
     VALUES ('62021', 'Для НСО с кодом: {0}, тест запроса в "nso_select" не сформирован', 'nso');
--
INSERT INTO com.obj_errors( err_code, message_out, sch_name) 
     VALUES ('62022', 'Ошибка, НСО с ID = {0} отсутствует', 'nso');
--
-- 2019-08-09 Заголовок объекта
--
INSERT INTO com.obj_errors( err_code, message_out, sch_name) 
     VALUES ('62030', 'Нельзя создавать колонки из атрибутов узловых/группирующих типов: {0}', 'nso');
--
INSERT INTO com.obj_errors( err_code, message_out, sch_name) 
     VALUES ('62031', 'НСО с кодом = {0}, не имеет колонки с номером = {1}', 'nso');
--
-- 2019-08-25 Заголовок объекта, ключ/маркер
--
INSERT INTO com.obj_errors( err_code, message_out, sch_name) 
     VALUES ('62040', 'Неправильный код = {0} типа маркера (ключа), он не принадлежит ветке {1}', 'nso');
--
INSERT INTO com.obj_errors( err_code, message_out, sch_name) 
     VALUES ('62041', 'Неправильные значения в массиве аттрибутов, образующих ключ = {0}', 'nso');
--     
-- 2019-08-25
INSERT INTO com.obj_errors( err_code, message_out, sch_name) 
     VALUES ('62042', 'Неправильный код = {0} маркера (ключа), маркер не существует', 'nso');
--
-- 2020-02-14 Nick  Ошибки nso_record, начинаются с '62052'
INSERT INTO com.obj_errors( err_code, message_out, sch_name) 
     VALUES ('62052', 'Запись с ID = {0} не существует', 'nso');
--
INSERT INTO com.obj_errors( err_code, message_out, sch_name) 
     VALUES ('62053', 'Неправильное ссылочное значение: {0}, оно не принадлежит НСО-ДОМЕНУ. ID НСО = {1}, ID записи = {2}', 
                      'nso'
);
     
--  -- select *  from  com.obj_errors ORDER by err_code;

-- UPDATE com.obj_errors SET message_out = 'Неустановленная ошибка возникла при создании экземпляра кодификатора, Код = "{0}"'
--                           , sch_name = 'com'
--                           , qty = -1
-- WHERE (err_code = '61010');
-- --
-- UPDATE com.obj_errors SET message_out = 'Запись кодификатора с ID = "{0}" не найдена'
--                           , sch_name = 'com'
-- WHERE (err_code = '61040');
-- --
-- UPDATE com.obj_errors SET message_out = 'Значение родительского элемента равное NULL недопустимо для записи с кодом = "{0}"'
--                           , sch_name = 'com'
-- WHERE (err_code = '61050');
--
-- Ошибки
-- --
-- -- 1)
-- UPDATE com.obj_errors SET message_out = 'Значение родительского элемента равное NULL недопустимо для записи с кодом '
--                           , sch_name = 'com'
-- WHERE (err_code = '61050');
-- --
-- UPDATE com.obj_errors SET message_out = 'Значение родительского элемента равное NULL недопустимо для записи с кодом = {0}'
--                           , sch_name = 'com'
-- WHERE (err_code = '61050');
-- --
-- select *  from  com.obj_errors;

-- UPDATE com.obj_errors SET message_out = 'Удаление экземпляра кодификатора, запись с кодом = "{0}" не существует'
--                           , sch_name = 'com'
-- WHERE (err_code = '61011');
