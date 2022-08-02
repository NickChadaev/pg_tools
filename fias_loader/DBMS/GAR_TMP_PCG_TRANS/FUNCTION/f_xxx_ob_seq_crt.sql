DROP FUNCTION IF EXISTS gar_tmp_pcg_trans.f_xxx_obj_seq_crt (text, bigint);
DROP FUNCTION IF EXISTS gar_tmp_pcg_trans.f_xxx_obj_seq_crt (text, text, bigint, bigint);
DROP FUNCTION IF EXISTS gar_tmp_pcg_trans.f_xxx_obj_seq_crt (text, bigint, bigint, text);

DROP FUNCTION IF EXISTS gar_tmp_pcg_trans.f_xxx_obj_seq_crt (text, bigint, bigint, text, text, text, text);
CREATE OR REPLACE FUNCTION gar_tmp_pcg_trans.f_xxx_obj_seq_crt (
              p_seq_name        text   -- Имя последовательности
             ,p_id_region       bigint -- ID региона
             ,p_init_value      bigint -- Начальное значение
              --                                  Схемы
             ,p_adr_area_sch    text = 'unnsi' --   Адресные пространства
             ,p_adr_street_sch  text = 'unnsi' --   Улицы
             ,p_adr_house_sch   text = 'unnsi' --   Дома
              --
             ,p_seq_hist_name   text  = NULL  -- Имя исторической последовательности (УСТАРЕЛО)
)
    RETURNS SETOF bigint
    LANGUAGE plpgsql
 AS
  $$
   DECLARE
     _r   bigint;
     _rh  bigint;
           
     _exec text;
 
     _sq_set text = $_$ 
                        SELECT setval('%s'::regclass, %s::bigint);
                    $_$; 
                     
     _smax text = $_$
          WITH x (max_id) AS (
             SELECT MAX (id_area) FROM %I.adr_area 
                       WHERE (id_area >= %s) AND (id_area < %s)
                UNION 
             SELECT MAX (id_street) FROM %I.adr_street 
                       WHERE (id_street >= %s) AND (id_street < %s)
                UNION 
             SELECT MAX (id_house) FROM %I.adr_house 
                       WHERE (id_house >= %s) AND (id_house < %s)
          )
            SELECT coalesce (MAX(x.max_id), 1) FROM x ;      
      $_$;               
 
     _seq_name      text := btrim (lower (p_seq_name));      -- Имя последовательности
     _seq_hist_name text := btrim (lower (p_seq_hist_name)); -- Имя исторической последовательности (УСТАРЕЛО)
     _id_region  bigint := p_id_region;  -- ID региона
     _init_value bigint := p_init_value; -- Начальное значение    
 
     _val     bigint;
     _min_val bigint;
     _max_val bigint;
      
   BEGIN
     -- --------------------------------------------------------------------------
     --  2021-12-10 Nick  Создание и установка значения для последовательной,
     --    генерирующей ID адресных объектов.
     -- --------------------------------------------------------------------------
     --  2022-01-13 Nick  Последовательности для актуальных и исторических данных 
     --                   становятся независимыми.
     -- --------------------------------------------------------------------------
     --  2022-04-12 Nick. На фиг все премудрости, последовательность одна.
     --  2022-05-16 Nick. Последовательности устанавливаются исходя из актуальных 
     --                    значения в таблицах.
     -- --------------------------------------------------------------------------
     _min_val := _init_value * _id_region;
     _max_val := _min_val + (_init_value / 100) * 99;

     _exec := format (_smax
                         ,p_adr_area_sch  ,_min_val, _max_val
                         ,p_adr_street_sch,_min_val, _max_val
                         ,p_adr_house_sch ,_min_val, _max_val
      );
      EXECUTE _exec INTO _val;
      
      IF NOT (_val = 1 ) THEN
           _val := _val + 10;
      END IF;
      
      _exec := format (_sq_set, _seq_name, _val);
      EXECUTE _exec INTO _r;
      
      RETURN NEXT _r;     
      
      IF (p_seq_hist_name IS NOT NULL)
        THEN
            _exec := format (_sq_set, _seq_hist_name, (_r + 10000000000::bigint));
             EXECUTE _exec INTO _rh;
        
             RETURN NEXT _rh;
      END IF;
   END;                   
  $$;
 
ALTER FUNCTION gar_tmp_pcg_trans.f_xxx_obj_seq_crt (text, bigint, bigint, text, text, text, text) OWNER TO postgres;  

COMMENT ON FUNCTION gar_tmp_pcg_trans.f_xxx_obj_seq_crt (text, bigint, bigint, text, text, text, text) 
IS 'Установка последовательности для формирования ID новых адресныях объектов';
----------------------------------------------------------------------------------
-- USE CASE:
-----------------------------------------------------------------
--  SELECT gar_tmp_pcg_trans.f_xxx_obj_seq_crt 
--    ('gar_tmp.obj_seq', 22, 100000000, 'gar_tmp.obj_hist_seq');
-- --------------------------------------------------------------
-- DROP SEQUENCE gar_tmp.obj_1_seq;
-- DROP SEQUENCE gar_tmp.obj_hist_1_seq;
-- CREATE SEQUENCE gar_tmp.obj_1_seq INCREMENT 1 START 1;
-- CREATE SEQUENCE gar_tmp.obj_hist_1_seq INCREMENT 1 START 1;
-----------------------------------------------------------------  
-- SELECT gar_tmp_pcg_trans.f_xxx_obj_seq_crt ('gar_tmp.obj_seq', 2, 100000000, 'gar_tmp.obj_hist_seq');
--   200004262
-- 10200013033
-----------------------------------------------------------------
