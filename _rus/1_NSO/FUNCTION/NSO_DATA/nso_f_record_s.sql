-- ============================================================================ 
-- Author:		ANNA
-- Create date: 2013-08-20
-- Create date: 2013-09-27 ANNA Оптимизация скрипта
-- Description:	Выборка одной записи НСО
--         2014-05-05: Анна: отключение сканирование таблицы и сортировка.
--         2014-07-30: Nick - Функция перенесена на версию 3.0
--     !!!! После вызова этой функции ОБЯЗАТЕЛЬНО SET enable_seqscan = ON; !!!!
-- ----------------------------------------------------------------------------
-- 2015-05-05 Переход на домен ЕБД, иерахическая структура nso_record, 
--                                  рекурсивный запрос.
--   Пока только текущие данные, без истории.
-- ============================================================================ 
-- ----------------------------------------------------------------------------
-- 2015-06-13 Добавлена связка для BLOB 
--						Роман
-- Результату +: 17;22;;"d9898060-ce57-45fb-baeb-79645ea27ff8";4;
--               "SPR_BLOB_FC_BLOB";"Фотография";".";"0";
--               "JPG | 940221_311_Korosten_Novograd-V_L_5141.JPG (5216 kB)"
--   2016-11-12  Nick, Абсолютное значение типа t_text (t_arr_values -> t_arr_text, t_str2048 -> t_text) 
--   2016-11-14  Gregory, добавлены ref_rec_id и col_id, изменен тип rec_id, активирован parent_rec_id
-- ============================================================================ 
--	Входные параметры:
--						 p_rec  - id записи
--	Выходные параметры:
--					таблица со всеми значениями НСО 
--					В ячейках храняться только реальные значения, если данных нет, 
--					то пустые записи в таблицу Cells не заносятся
--   ==========================================================================
SET SEARCH_PATH=nso,com,public,pg_catalog;

DROP FUNCTION IF EXISTS nso.nso_f_record_s ( public.id_t, public.id_t );
CREATE OR REPLACE FUNCTION nso.nso_f_record_s ( p_nso_id  public.id_t, p_rec_id  public.id_t )

RETURNS TABLE (
                        nso_id          public.id_t       -- ID НСО
                      , rec_id          public.id_t       -- ID записи -- 2016-11-14 Gregory
                      , ref_rec_id      public.id_t       -- Значение ссылка -- 2016-11-14 Gregory
                      , parent_rec_id   public.id_t       -- ID родительской записи
                      , rec_uuid        public.t_guid     -- UUID записи
                      , col_id          public.id_t       -- ID колонки -- 2016-11-14 Gregory
                      , number_col      public.small_t    -- номер колонки
                      , col_code        public.t_str60    -- код колонки
                      , col_name        public.t_str250   -- наименование колонки
                      , s_type_code     public.t_code1    -- тип значения
                      , s_key_code      public.t_code1    -- тип ключа, принадлежность к ключу
                      , n_value         public.t_text     -- величина
				) 
AS
 $$
   BEGIN
    -- SET enable_seqscan=OFF;
    -- Первый вариант, без рекурсии 2015-05-05
    RETURN QUERY
      WITH r_data ( 
                 nso_id
                ,rec_id
                ,parent_rec_id -- 2016-11-14 Gregory
                ,rec_uuid
                ,col_id
                ,number_col
                ,col_code
                ,col_name
                
      ) AS (
                  SELECT r.nso_id
                       , r.rec_id::public.id_t  -- 2016-11-14 Gregory id_t
                       , r.parent_rec_id -- 2016-11-14 Gregory
                       , r.rec_uuid
                       , h.col_id::public.id_t  -- 2016-11-14 Gregory id_t
                       , h.number_col
                       , h.col_code
                       , h.col_name 
                    FROM ONLY nso.nso_record r 
                        LEFT OUTER JOIN ONLY nso.nso_column_head h ON ( r.nso_id = h.nso_id )
              WHERE ( h.number_col > 0 ) AND ( r.nso_id = p_nso_id ) AND ( r.rec_id = p_rec_id )   
           )
            -- --------------------------------------------------- 
                 SELECT d.nso_id              -- Это абсолютные значения
                      , d.rec_id
                      , NULL::public.id_t     -- Значение ссылка -- 2016-11-14 Gregory
                      , d.parent_rec_id       -- 2016-11-14 Gregory -- NULL::id_t -- ID родительской записи 
                      , d.rec_uuid
                      , d.col_id              -- ID колонки -- 2016-11-14 Gregory
                      , d.number_col
                      , d.col_code
                      , d.col_name
                      , a.s_type_code
                      , a.s_key_code
                      , a.val_cell_abs::public.t_text AS n_value 
                  FROM r_data d
                       JOIN ONLY nso.nso_abs a ON ( d.rec_id = a.rec_id ) AND ( d.col_id = a.col_id )  
              
               UNION 
              
                 SELECT d.nso_id             -- А это разъименованная ссылка
                      , d.rec_id
                      , r.ref_rec_id         -- Значение ссылка -- 2016-11-14 Gregory
                      , d.parent_rec_id      -- ID родительской записи -- 2016-11-14 Gregory
                      , d.rec_uuid
                      , d.col_id             -- ID колонки -- 2016-11-14 Gregory
                      , d.number_col
                      , d.col_code
                      , d.col_name
                      , 'D'::public.t_code1 AS s_type_code -- строка 2048 байт
                      , '0'::public.t_code1 AS s_key_code  -- нет ключа
                      , nso.nso_f_record_def_val( r.ref_rec_id )::t_text AS n_value FROM r_data d
               JOIN ONLY nso.nso_ref r ON ( d.rec_id = r.rec_id ) AND ( d.col_id = r.col_id )

               UNION   
                 SELECT d.nso_id             -- А это разъименованная ссылка
		                , d.rec_id
		                , NULL::public.id_t    -- Значение ссылка -- 2016-11-14 Gregory
                      , d.parent_rec_id      -- ID родительской записи -- 2016-11-14 Gregory
                      , d.rec_uuid
                      , d.col_id             -- ID колонки -- 2016-11-14 Gregory
                      , d.number_col
                      , d.col_code
                      , d.col_name
                      , '..'::public.t_code1 AS s_type_code -- тип BLOB  ставим константу из кодификатора, соответсвующую типу T_BLOB
                      , '0'::public.t_code1 AS s_key_code  -- нет ключа
                      , CAST ( 
				CASE 
					WHEN b.s_type_code = 'н' THEN 'JPG'
					WHEN b.s_type_code = 'п' THEN 'PNG'
					WHEN b.s_type_code = 'т' THEN 'BMP'
					WHEN b.s_type_code = 'у' THEN 'PDF'
					WHEN b.s_type_code = 'ф' THEN 'GIF'
					WHEN b.s_type_code = 'х' THEN 'TIFF'
					WHEN b.s_type_code = 'ц' THEN 'DOC'
					WHEN b.s_type_code = 'ч' THEN 'XLS'
					WHEN b.s_type_code = 'ш' THEN 'PPT'
					WHEN b.s_type_code = 'щ' THEN 'ODT'
					WHEN b.s_type_code = 'ъ' THEN 'ODP'
					WHEN b.s_type_code = 'ы' THEN 'ODS'
					WHEN b.s_type_code = 'ь' THEN 'ODG'
					WHEN b.s_type_code = 'э' THEN 'ODC'
					WHEN b.s_type_code = 'ю' THEN 'ODB'
					WHEN b.s_type_code = 'я' THEN 'ODF'
				END  || ' | ' || b.val_cel_data_name || ' (' || pg_size_pretty( octet_length(b.val_cell_blob)::bigint ) || ')' 
			
                      AS t_text ) AS n_value
-- <краткое описание> - состоит из ТИП BLOB вычисляется из величины s_type_code, без обращений к кодификатору. далее " | ", потом имя файла и его размер.  Например: "PNG | 'my.png 234 Kb"
                   FROM r_data d
               JOIN ONLY nso.nso_blob b ON ( d.rec_id = b.rec_id ) AND ( d.col_id = b.col_id )

      ORDER BY number_col;
   END;
$$
    STABLE
    SECURITY DEFINER -- 2015-04-05 Nick
    LANGUAGE plpgsql;
COMMENT ON FUNCTION nso.nso_f_record_s (  public.id_t, public.id_t  ) IS '7678: Отображение одной записи НСО. Аргументы: - ID НСО, ID записи:
   RETURNS TABLE (
                           nso_id          public.id_t       -- ID НСО
                         , rec_id          public.id_t       -- ID записи
                         , ref_rec_id      public.id_t       -- Значение ссылка
                         , parent_rec_id   public.id_t       -- ID родительской записи
                         , rec_uuid        public.t_guid     -- UUID записи
                         , col_id          public.id_t       -- ID колонки
                         , number_col      public.small_t    -- номер колонки
                         , col_code        public.t_str60    -- код колонки
                         , col_name        public.t_str250   -- наименование колонки
                         , s_type_code     public.t_code1    -- тип значения
                         , s_key_code      public.t_code1    -- тип ключа, принадлежность к ключу
                         , n_value         public.t_text     -- величина
   				) 
';

-- SET enable_seqscan=ON;
--Пример использования:
-- SELECT * FROM nso.nso_f_record_select_all ( 17 ); 
-- SELECT * FROM nso.nso_f_record_s ( 17::id_t, 20::id_t ); 
-- SELECT * FROM nso.nso_f_record_s ( 34::id_t, 2::id_t );  
--
-- SELECT * FROM nso.nso_f_record_select_all ( 14 ); 
-- SELECT * FROM nso.nso_f_record_s ( 14::id_t, 518::id_t );   