SET search_path=utl, public, pg_catalog;

CREATE OR REPLACE FUNCTION utl.f_hstore_key_mod ( p_data public.t_text           -- Исходная структура
                                                , p_sw   public.t_boolean = TRUE -- Модификатор: TRUE-верхний регистр, FALSE-нижний
)
   RETURNS hstore AS 
   $$
-- ------------------------------------------------------------------------------------------- --
--  2017-10-14 Nick  Функция переводит ключ структуры hstore в верхний, либо в нижний регистры --
--  2020-02-11 Nick - Переходим на новое ядро.                                                 --
-- ------------------------------------------------------------------------------------------- --
   
       SELECT CASE 
         WHEN p_sw THEN hstore ((SELECT array_agg (upper (key)) FROM each (p_data::hstore))
                                  , (SELECT array_agg (value) FROM each (p_data::hstore))
                        ) 
         ELSE 
              hstore ((SELECT array_agg (lower (key)) FROM each (p_data::hstore))
                                  , (SELECT array_agg (value) FROM each (p_data::hstore))
              ) 
         END;
   $$
    SECURITY INVOKER -- 2015-04-05 Nick
    LANGUAGE sql;

COMMENT ON FUNCTION utl.f_hstore_key_mod ( public.t_text, public.t_boolean ) IS '270: Переводит ключ структуры hstore в верхний, либо в нижний регистры.

   Входные величины:
                     p_data public.t_text           -- Исходная структура
                   , p_sw   public.t_boolean = TRUE -- Модификатор: TRUE-верхний регистр, FALSE-нижний
   Результат:
             Преобразованная структура hstore.
';
-- -----------------------------------------------------------------------------------
-- SELECT  com.f_hstore_key_mod ( NULL );
--
-- SELECT  com.f_hstore_key_mod ( 'P_ACTION => "UUID записи из справочника SPR_ACTION"
--  , p_date_perform  => "YYY-MM-DD" 
--  , P_STAGE_PERFORM => "Количество дней"
--  , P_descr         => "Описание действия"
-- ', true
-- );
