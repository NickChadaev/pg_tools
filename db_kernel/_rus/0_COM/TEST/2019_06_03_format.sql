SELECT format ('--- %1$s', 'Restore');
SELECT format ('--- %1$I', 'Restore');
SELECT format ('--- %1$L', 'Restore');
--
SELECT format ('--- %1$I, === %2$I', 'Restore', 'Copy');
SELECT format ('--- %1$I, === %2$I', ARRAY['Restore', 'Copy']::text[]);  -- Ошибка
SELECT format ('--- %1$I', ARRAY['Restore', 'Copy']::text[]);            -- Работает
-- Использовать Python функцию  

select * from com.obj_errors where (err_code <> '60000');
-- -------------------------------------------------------------------
-- '60004'|'Запись не найдена'                             |''   |''|0
-- '60005'|'Указан несуществующий родительский объект'     |''   |''|0
-- '61000'|'Указан не существующий идентификатор владельца'|'com'|''|0
-- -------------------------------------------------------------------
-- Зачем "func_name", "qty" ??
--
delete from com.obj_errors where (err_code <> '60000');
--
--  1) "qty" заполняется триггером в момент создания новой записи.
--  2) "qty" определён в момент чтения сообщения об ошибке. 
--              Сравнивается с длинной массива. 
--              Получаем результат - выровненный массив, лишнее отбрасывается, недостающее добавляется ('', '', '').
--              На основе результата формируется сообщение-результат.
-- ------------------------------------------------------------------
--  Имя функции - под вопросом.
-- ----------------------------
--  2019-06-04 
--
ALTER TABLE com.obj_errors DROP COLUMN func_name;
DROP INDEX IF EXISTS ie1_obj_errors;
CREATE INDEX ie1_obj_errors ON com.obj_errors (sch_name);
 
 
 >>> 'Coordinates: {0}, {1}'.format(*coord)
'Coordinates: latitude, longitude'
>>> 'Coordinates: {0}, {1}'.format(*coord1)
'Coordinates: 37.24N, -115.81W'
