DROP FUNCTION IF EXISTS gar_link.f_index_get (text, text, boolean);
CREATE OR REPLACE FUNCTION gar_link.f_index_get (
              p_idx_name     text -- Имя индекса.   
             ,p_chema_name   text -- Имя схемы приёмника. 
             ,p_mode_c       boolean = TRUE -- Создание индексов FALSE - удаление             
)
    LANGUAGE plpgsql 
    RETURNS text
    SECURITY DEFINER
    AS 

  $$
   -- --------------------------------------------------------------------------
   --   2022-11-09  Формирование индексного выражения, создание/удаления.
   -- --------------------------------------------------------------------------                 
    DECLARE 
       _mess text;
       --
      _idx_name    text;
      _idx_names_0 text[] := ARRAY [
                                  'adr_area_i1 '
                                 ,'adr_area_i2 '
                                 ,'adr_area_i3 '
                                 ,'adr_area_i4 '
                                 ,'adr_area_i5 '
                                 ,'adr_area_i6 '
                                 ,'adr_area_i7 '
                                 ,'adr_area_i8 '
                                 ,'adr_area_i9 '
                                 ,'index_nm_area_on_adr_area_trigram '
                                 ]::text[];
       --
      _idx_signs_0 text[] := ARRAY [
                                  'ON %I.adr_area USING btree (id_area_parent)'
                                 ,'ON %I.adr_area USING btree (id_area_type)'
                                 ,'ON %I.adr_area USING btree (id_country)'
                                 ,'ON %I.adr_area USING btree (kd_timezone)'
                                 ,'ON %I.adr_area USING btree (id_data_etalon)'
                                 ,'ON %I.adr_area USING btree (id_country, upper((nm_area_full)::text))'
                                 ,'ON %I.adr_area USING btree (nm_fias_guid)'
                                 ,'ON %I.adr_area USING btree (id_country, upper((nm_area)::text))'
                                 ,'ON %I.adr_area USING btree (kd_okato)'
                                 ,'ON %I.adr_area USING gin (nm_area gin_trgm_ops)'
                                 ]::text[];
       
      _u_idx_name_0 text := 'adr_area_ak1 ';                           

      _u_idx_sign_0 text := 'ON %I.adr_area USING btree 
                (id_country, id_area_parent, id_area_type, upper((nm_area)::text))
                      WHERE (id_data_etalon IS NULL)';                           
       --
       ---- 
       --
      _idx_name_1  text := '_xxx_adr_area_ie2 ';

      _idx_sign_1  text := 'ON %I.adr_area USING btree
                     (nm_fias_guid) WHERE (id_data_etalon IS NULL) AND (dt_data_del IS NULL)';
                     
      _u_idx_name_1 text := '_xxx_adr_area_ak1 ';
       --
      _u_idx_sign_1 text := 'ON %I.adr_area USING btree
                             (id_country     ASC NULLS LAST
                             ,id_area_parent ASC NULLS LAST
                             ,id_area_type   ASC NULLS LAST
                             ,upper (nm_area::text) ASC NULLS LAST
                             )
                          WHERE (id_data_etalon IS NULL) AND (dt_data_del IS NULL)';          
       --                   
       ----
       --
      _crt_idx    text := $_$ CREATE INDEX IF NOT EXISTS %s; $_$;  
      _crt_un_idx text := $_$ CREATE UNIQUE INDEX IF NOT EXISTS %s; $_$; 
      _drp_idx    text := $_$ DROP INDEX IF EXISTS %I.%s; $_$; 
      
      _exec    text;
   
    BEGIN
     IF p_mode_c -- Create
       THEN 
         _exec := format (_crt_idx, p_idx_name || format (_idx_signs [0], p_schema_name));
         RAISE NOTICE '%', _exec;
          
        ELSE --Drop
             _exec := format (_drp_idx, p_schema_name, p_idx_name);
             RAISE NOTICE '%', _exec;
     END IF; --
     
     RETURNS _exec;
    END;
  $$;
  
COMMENT ON FUNCTION gar_link.f_index_get (text, text, boolean) 
  IS 'Получить индексное выражение';  
-- ----- ----------------------------------------------------
-- USE CASE:
--




 
