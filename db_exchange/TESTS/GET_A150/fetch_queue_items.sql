CREATE OR REPLACE FUNCTION traffic_face_busin_stat.fetch_unknown_queue_items (
            _instance                  bigint,     --  Инстанс (Номер tf-node ???)
            _vendor                    text,       --  Поставщик  
            _descr_version             text,       --  Описание версии
            _split_num                 integer,    --  Количество разделений ??
            _split_total               integer,    --  Общее количество разделений
            _count                     integer,    --  Количество выбираемых из "unknown_queue" за один SELECT
            OUT unknown_queue_item_id  bigint,     --  ID элемента очереди
            OUT remote_category        text,       --  Отдалённая категория
            OUT little_threshold       numeric,    --  Нижний порог
            OUT medium_threshold       numeric,    --  Средний порог
            OUT large_threshold        numeric,    --  Большой порог 
            OUT good_quality           boolean,    --  Высокое качество
            OUT descr                  bytea       -- ?? (Пожалуй это самое главное)
        )
        RETURNS SETOF record
        LANGUAGE plpgsql
        SECURITY DEFINER
AS 
 $function$
   --
   -- 2020-09-07 Перенесена в рамках второго этапа миграции "busin_stats" с "tf_checks" на "fc_cbd",
   --       Зависимости:
   --                    traffic_face_busin_stat_var.unknown_queue  -- Чтение и удаление
   --                    traffic_face_ref_var.busin_stats_cat_ref   -- Только чтение
   
   DECLARE
       -- граница недозволенной разницы во времени между отставанием в обработке.
       -- то есть ждём обработки параллельных обработчиков, если они работают медленнее чем мы
       
       -- Nick 2020-09-07, что произойдёт, если обработчик работает медленнее.
       
       __diff_before CONSTANT interval := '5 min';
       
       __time_check_before  timestamp WITHOUT time zone;   -- Верхняя грацина ??
       __found_count        integer;
       __deleted_count      integer;
       __r                  record;
       
   BEGIN
       IF _split_total IS NULL THEN
           _split_total := 1;
       END IF;
       
       IF _split_num IS NULL THEN
           _split_num := 1;
       END IF;
       
       IF _split_total <= 0 THEN
           RAISE 'invalid arg _split_total: %', quote_nullable (_split_total);
       END IF;
       
       IF _split_num <= 0 OR _split_num > _split_total THEN
           RAISE 'invalid arg _split_num: %', quote_nullable (_split_num);
       END IF;
       --
       --  Завершена проверка.
       --
       SELECT min (uq.time_check) + __diff_before INTO __time_check_before
               FROM traffic_face_busin_stat_var.unknown_queue uq
                  WHERE uq.vendor = _vendor AND uq.descr_version = _descr_version;
       
       IF __time_check_before IS NULL THEN
           -- очередь вообще пустая, не только для нашего обработчика
           
           RETURN;
       END IF;
       --
       --   Обработка
       LOOP
           __found_count   := 0;
           __deleted_count := 0;
           
           FOR __r IN SELECT
                       uq.unknown_queue_item_id,
                       (uq.attributes ->> 'quality')::numeric quality,
                       (uq.attributes ->> 'score')::numeric score,
                       bscr.remote_category,
                       bscr.little_threshold,
                       bscr.medium_threshold,
                       bscr.large_threshold,
                       bscr.quality_threshold,
                       bscr.score_threshold,
                       uq.descr
                       
                   FROM traffic_face_busin_stat_var.unknown_queue uq
                   -- вот здесь (строчка ниже) молимся Иисусу чтобы не было бы задвоения 
                   --          (Nick: Господь точно услышит эту молитву, но Он спросит нас о нарушениях целостности данных).
                   
                      LEFT JOIN traffic_face_ref_var.busin_stats_cat_ref bscr ON bscr.instance = _instance AND bscr.category = uq.category
                   
                   WHERE uq.vendor = _vendor
                     AND uq.descr_version = _descr_version
                     AND uq.time_check < __time_check_before                -- Время сработки находится внутри заданного интервала
                     AND uq.territory_id % _split_total + 1 = _split_num
                   
                   ORDER BY uq.time_check, uq.unknown_queue_item_id
                            LIMIT _count
           LOOP
               __found_count := __found_count + 1;
               
               IF __r.remote_category IS NULL                               -- Почему ??
               THEN
                   -- из-за этого ``delete from`` функция не является ``stable``
                   DELETE FROM traffic_face_busin_stat_var.unknown_queue uq
                            WHERE uq.unknown_queue_item_id = __r.unknown_queue_item_id;
                   
                   __deleted_count := __deleted_count + 1;
                   
                   CONTINUE;
               END IF;
               
               unknown_queue_item_id := __r.unknown_queue_item_id;
               remote_category       := __r.remote_category;
               little_threshold      := __r.little_threshold;
               medium_threshold      := __r.medium_threshold;
               large_threshold       := __r.large_threshold;
               
               good_quality :=  COALESCE (__r.quality >= __r.quality_threshold, TRUE)
                            AND COALESCE (__r.score >= __r.score_threshold, TRUE);
               descr := __r.descr;
               
               RETURN NEXT;
           END LOOP; -- Основная обработка, включает в себя DELETE FROM traffic_face_busin_stat_var.unknown_queue 
           
           EXIT WHEN __found_count = 0 OR __found_count > __deleted_count;
           
           -- всё что найдено (__found_count) это было же и удалено (__deleted_count).
           -- значит смотрим дальше чтобы не создавать эффект будто ни чего найдено и не было
           --
       END LOOP; -- SELECT * FROM traffic_face_busin_stat_var.unknown_queue;
   END
$function$;

COMMENT ON FUNCTION traffic_face_busin_stat.fetch_unknown_queue_items (bigint, text, text, integer, integer, integer)
IS 'Получить данные из "unknown_queue"';

REVOKE ALL ON FUNCTION traffic_face_busin_stat.fetch_unknown_queue_items (
            _instance bigint,
            _vendor text,
            _descr_version text,
            _split_num integer,
            _split_total integer,
            _count integer
        )
        FROM PUBLIC;
GRANT ALL ON FUNCTION traffic_face_busin_stat.fetch_unknown_queue_items (
            _instance bigint,
            _vendor text,
            _descr_version text,
            _split_num integer,
            _split_total integer,
            _count integer
        )
        TO busin_prof_srv;

-- vi:ts=4:sw=4:et
-- -----------------------------------------------------------------------------------------------------------------
-- USE CASE:
--            SELECT * FROM traffic_face_busin_stat.fetch_unknown_queue_items (
--                         _instance        := 4             --  Инстанс  
--                       , _vendor          := 'tv'          --  Поставщик  
--                       , _descr_version   := '2.5-precise' --  Описание версии
--                       , _split_num       :=  1            --  Количество разделений ??
--                       , _split_total     :=  1            --  Общее количество разделений
--                       , _count           :=  1            --  Количество выбираемых из "unknown_queue" за один SELECT
--            );
