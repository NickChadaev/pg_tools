DROP FUNCTION IF EXISTS utl.f_array_random_get_element(anyarray);
CREATE OR REPLACE FUNCTION utl.f_array_random_get_element(anyarray) 
RETURNS anyelement 
 AS 
  $$
     --  ============================================================================= --
     --  Author     : Serge                                                            --
     --  Create date: 2017-01-13                                                       --
     --  Description: Получить элемент из массива.                                     --
     --  2017-01-27 Nick ошибка при накате функции. В какой схеме она создаётся ???    --
     --  2019-04-12 Nick STABLE, новое ядро.                                           --
     --  ============================================================================= --
  
    SELECT $1 [floor(random() * array_length($1, 1)) + 1]
    
  $$ LANGUAGE sql STABLE;


COMMENT ON FUNCTION utl.f_array_random_get_element(pg_catalog.anyarray)
IS '136: Получить элемент из массива. Случайный выбор.
    
    Входные параметры:
       1)  anyarray -- Массив

    Выходные параметры:
       1) anyelement   -- случайный Элемент списка
';
------------------------------------------------------------
-- SELECT  utl.f_array_random_get_element(ARRAY[1,2,3,45,6]);
-- SELECT utl.f_array_random_get_element(array_agg(codif_id)) FROM utl.com_f_obj_codifier_s_sys ();
-- SELECT utl.f_array_random_get_element(array_agg(err_code::text)) FROM utl.com_v_errors ;
