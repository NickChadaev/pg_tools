DROP FUNCTION IF EXISTS nso_data.nso_f_record_def_val (public.id_t, public.t_str60);
CREATE OR REPLACE FUNCTION nso_data.nso_f_record_def_val ( p_rec      public.id_t
                                                          ,p_key_code public.t_str60 = 'DEFKEY' 
)
  RETURNS public.t_text
  SET search_path = nso, com, utl, com_codifier, nso_data, com_domain, nso_strucrure, com_error, public,pg_catalog
AS
 $$
   -- ==============================================================================
   -- Author:		ANNA
   -- Create date: 2013-08-05
   -- Description:	Выбор значения по умолчанию
   -- ------------------------------------------------------------------------------
   --	Входные параметры
   --	              p_rec public.id_t  - ID записи НСО
   --        ------------------------------------------------------------------------- 
   --   Возможные значения кода ключа: 
   --                                  33|4|'a'|'AKKEY1'    |'Уникальный ключ 1'
   --                                  34|4|'b'|'AKKEY2'    |'Уникальный ключ 2'
   --                                  35|4|'c'|'AKKEY3'    |'Уникальный ключ 3'
   --                                  36|4|'d'|'PKKEY'     |'Идентификационный ключ'
   --                                  37|4|'e'|'IEKEY'     |'Поисковый ключ'
   --                                  38|4|'f'|'FKKEY'     |'Ссылочный ключ'
   --                                  39|4|'g'|'DEFKEY'    |'Значение по умолчанию'
   --   ------------------------------------------------------------------------------- 
   --	Выходные параметры
   --			Значение в формате public.t_text
   --	Особенности:
   --		       Проверка по очередно выполняется по полям с ключами 'DEFKEY'
   --                      ,если поле пустое, то по всем ключам
   --                      ,если поле всё же пустое, то "". 
   -- ------------------------------------------------------------------------------
   -- Modification:  Май-Июнь 2014 года:
   --               Переписан Роман во время выполнения нагрузочного тестирования 
   --               2014-08-05 Оптимизирована ещё раз для верии 2.0 Nick
   -- -------------------------------------------------------------------------------
   --  2015-04-22  Nick переписана для домена EBD. 
   --              Первый вариант - только абсолютные значения
   --  2015-05-30  В nso_column_head появился краткий код
   --  2015-04-22  Что будет если в значение по умолчанию входит несколько атрибутов:
   --              ответ простой - конкатенация каждого отдельного значения в строку
   --  2015-08-19 Убрал "Нет данных", заменил на "". Nick  
   --  2015-10-05 При разъименовании ссылки, попадаем всегда на DEFVAL
   --             p_key_code - не передаём.       
   --  2016-04-16 Nick Введена опция ONLY для OBJ_CODIFIR             
   --  2019-09-17 Nick Новое ядро. Возвращается результат типа "public.t_text".
   -- ------------------------------------------------------------------------------
 
   DECLARE 
           _str     public.t_text; -- Nick 2019-09-17 
           _str0    public.t_text;

           cEMP   public.t_code1 := '';

           _nso_id  public.id_t;
           _col_id  public.id_t;

           _codif_code public.t_arr_code;
           _arr_len    public.t_int; 
           _i          public.t_int;

           _not_data    public.t_text := ''; -- Нет данных  2015-08-19 Nick
           _small_code  public.t_code1;

           _parent_code public.t_str60 := 'C_KEY_TYPE'; -- Родитель. Типы ключевых атрибутов

   BEGIN
    CASE p_key_code
       WHEN 'AKKEY1' THEN _small_code := 'a';  -- 'Уникальный ключ 1'
       WHEN 'AKKEY2' THEN _small_code := 'b';  -- 'Уникальный ключ 2'
       WHEN 'AKKEY3' THEN _small_code := 'c';  -- 'Уникальный ключ 3'
       WHEN 'PKKEY'  THEN _small_code := 'd';  -- 'Идентификационный ключ'
       WHEN 'IEKEY'  THEN _small_code := 'e';  -- 'Поисковый ключ'
       WHEN 'FKKEY'  THEN _small_code := 'f';  -- 'Ссылочный ключ'
       WHEN 'DEFKEY' THEN _small_code := 'g';  -- 'Значение по умолчанию'
       ELSE
          _small_code := 'g';  -- 'Значение по умолчанию' 
    END CASE;

    _nso_id := (SELECT nso_id FROM ONLY nso.nso_record WHERE ( rec_id = p_rec )); -- выбираем к какому НСО относиться запись
    _str := cEMP;
    FOR _col_id IN SELECT a.col_id FROM ONLY nso.nso_key k, ONLY nso.nso_key_attr a 
                WHERE ( a.key_id = k.key_id ) AND ( k.nso_id = _nso_id ) AND ( k.key_small_code = _small_code) 
       LOOP 
          -- Тип столбца, BLOBы пока не учитываем 
          CASE (SELECT h.attr_scode FROM ONLY nso.nso_column_head h WHERE ( h.col_id = _col_id ))
           WHEN 'T' THEN -- Ссылка на НСО
              _str0 := nso_data.nso_f_record_def_val ((SELECT r.ref_rec_id FROM ONLY nso.nso_ref r WHERE (r.rec_id = p_rec) AND (r.col_id =_col_id)));  -- , p_key_code  2015-10-05  
           ELSE
              _str0 := (SELECT c.val_cell_abs FROM ONLY nso.nso_abs c WHERE (c.rec_id = p_rec) AND (c.col_id =_col_id));
         END CASE;     
         _str := _str || ' ' || _str0;
    END LOOP;

    IF ( _str <> cEMP) THEN -- IS NOT NULL
		RETURN btrim (_str);
    ELSE 
       -- ---------------------------------------------------------------------------------------
       -- Оживляем функционал поиска по списку ключей, критерий выхода - первое найденное значение
       -- Ничего не нашли, используем далее всё кроме _key_code 
       --
       _codif_code := ( SELECT array_agg ( btrim(c.codif_code) ) FROM ONLY com.obj_codifier c, ONLY com.obj_codifier p -- Nick 2016-04-16
                                   WHERE ( c.parent_codif_id = p.codif_id )
                                     AND ( p.codif_code = _parent_code ) -- Родитель. Типы ключевых атрибутов
                                     AND ( c.codif_code NOT IN ( p_key_code ) )
                      );
       _arr_len := array_length ( _codif_code, 1 );
       _i := 0;

       WHILE ( _i <  _arr_len ) LOOP
          CASE _codif_code [_i]
             WHEN 'AKKEY1' THEN _small_code := 'a';  -- 'Уникальный ключ 1'
             WHEN 'AKKEY2' THEN _small_code := 'b';  -- 'Уникальный ключ 2'
             WHEN 'AKKEY3' THEN _small_code := 'c';  -- 'Уникальный ключ 3'
             WHEN 'PKKEY'  THEN _small_code := 'd';  -- 'Идентификационный ключ'
             WHEN 'IEKEY'  THEN _small_code := 'e';  -- 'Поисковый ключ'
             WHEN 'FKKEY'  THEN _small_code := 'f';  -- 'Ссылочный ключ'
             WHEN 'DEFKEY' THEN _small_code := 'g';  -- 'Значение по умолчанию'
             ELSE
                _small_code := 'g';  -- 'Значение по умолчанию' 
          END CASE;
          
          _str := cEMP;
          FOR _col_id IN  SELECT a.col_id FROM ONLY nso.nso_key k, ONLY nso.nso_key_attr a 
                               WHERE ( a.key_id = k.key_id ) 
                                      AND ( k.nso_id = _nso_id ) 
                                      AND ( k.key_small_code = _small_code )
             LOOP
                 CASE (SELECT h.attr_scode FROM ONLY nso.nso_column_head h WHERE (h.col_id = _col_id))
                   WHEN 'T' THEN -- Ссылка на НСО
                      _str0 := nso_data.nso_f_record_def_val ((SELECT r.ref_rec_id FROM ONLY nso.nso_ref r WHERE (r.rec_id = p_rec) AND (r.col_id =_col_id))); -- , p_key_code  2015-10-05   
                   ELSE
                      _str0 := (SELECT c.val_cell_abs FROM ONLY nso.nso_abs c WHERE (c.rec_id = p_rec) AND (c.col_id =_col_id));
                 END CASE;     
                 _str := _str || ' ' || _str0;
          END LOOP;

          IF ( _str = cEMP ) THEN -- IS NULL
               _i := _i + 1; 
           ELSE
		           RETURN btrim (_str);
          END IF;
       END LOOP;
    END IF;   

    IF (_str <> cEMP ) THEN -- IS NOT NULL
       RETURN btrim (_str);
    END IF;

    RETURN _not_data;
   END;
 $$
    STABLE  -- Пока, потому, что использую SET
    SECURITY DEFINER -- 2015-04-05 Nick
    LANGUAGE plpgsql;
COMMENT ON FUNCTION nso_data.nso_f_record_def_val ( public.id_t, public.t_str60 )  IS '237: Выбор значения по ключу';

-- SELECT * FROM nso.nso_f_record_select_all('SPR_EX_ENTERPRISE')
-- SELECT * FROM nso_data.nso_f_record_def_val(5);
--
-- SELECT a.col_id FROM ONLY nso.nso_key k, ONLY nso.nso_key_attr a 
--               WHERE ( a.key_id = k.key_id ) AND ( k.nso_id = 15 ) AND ( k.key_small_code = 'g') 
-- -------------------------------------------------------------------------------------------
-- SELECT * FROM nso.nso_f_object_s_sys('NSO_SPR'); -- 15|13|'SPR_EMPLOYE'
-- SELECT * FROM nso.nso_f_column_head_nso_s ('SPR_EMPLOYE');   'IEKEY' тип T - ссылка
-- SELECT * FROM nso.nso_f_column_head_nso_s ('SPR_EX_ENTERPRISE'); 
-- -------------------------------------------------------------------------------------------
-- SET enable_seqscan=OFF; 
-- SELECT r.rec_uuid, nso_data.nso_f_record_def_val (r.rec_id) AS emp, nso_data.nso_f_record_def_val (r.rec_id, 'IEKEY') AS exn FROM ONLY nso.nso_record r WHERE ( r.nso_id = 15 ); 9 -- 12
-- SELECT r.* FROM nso.nso_record WHERE r ( r.nso_id = 15 ); 9 -- 12
-- SELECT r.* FROM nso.nso_record WHERE r ( r.nso_id = 15 ); 9 -- 12
--
-- 1||'211da7ab-5800-489a-a742-d0045ca202a6'|7|t|'2015-04-22 12:40:49'|'9999-12-31 00:00:00'|0
-- 2||'d172e867-ad76-498b-9634-dd0f4c583c7f'|7|t|'2015-04-22 12:40:49'|'9999-12-31 00:00:00'|0
-- 3||'50730e34-2a32-40e0-8035-46ea9a2693d9'|7|t|'2015-04-22 12:40:49'|'9999-12-31 00:00:00'|0
-- 4||'c32f2057-c741-4e8e-931c-e1b1c6daf615'|7|t|'2015-04-22 12:40:49'|'9999-12-31 00:00:00'|0
-- -----------------------------------------------------
-- SELECT nso_data.nso_f_record_def_val (9);
-- SELECT nso_data.nso_f_record_def_val (9, 'IEKEY');
-- SELECT nso_data.nso_f_record_def_val (3);
-- SELECT nso_data.nso_f_record_def_val (3, 'PKKEY' );
-- SELECT nso_data.nso_f_record_def_val (2, 'AKKEY1');  -- нет данных ???
-- -----------------------------------------------------
--  SELECT nso_data.nso_f_record_def_val (3559);
--  SELECT nso_data.nso_f_record_def_val (9);
--  SELECT nso_data.nso_f_record_def_val (11);
--  SELECT nso_data.nso_f_record_def_val (12, 'AKKEY1' );
--  SELECT nso_data.nso_f_record_def_val (32, 'AKKEY1' );
-- -----------------------------------------------------
-- SELECT * FROM nso.NSO_F_Record_SelectAll ( 3245064 );
-- -----------------------------------------------------
--  9||'c9dff31b-5845-4722-a0fe-453e31743f04'|15|t|'2015-06-03 21:15:05'|'9999-12-31 00:00:00'|0
-- 10||'b0f44cec-16ec-480b-8c60-e968f94c84af'|15|t|'2015-06-03 21:15:05'|'9999-12-31 00:00:00'|0
-- 11||'d3f49dfd-53f6-4cde-84ee-daba75fbd7c5'|15|t|'2015-06-03 21:15:05'|'9999-12-31 00:00:00'|0
-- 12||'adb69fdb-6a1c-475d-af51-f46b4606bc32'|15|t|'2015-06-03 21:15:05'|'9999-12-31 00:00:00'|0

