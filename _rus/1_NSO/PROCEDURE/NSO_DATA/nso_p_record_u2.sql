/* -----------------------------------------------------------------------------------------------------
        Входные параметры:
                1) p_rec_uuid        public.t_guid       -- Идентификатор текущей записи
                2) p_parent_rec_uuid public.t_guid       -- Идентификатор родительской записи
                -- 
                3) p_val             public.t_text       -- структура "Ключ-Значение"
                4) p_silent_mode     public.t_boolean DEFAULT TRUE   -- Режим тишины, выводятся только сообщения связанные с EXECEPTION
                5) p_actual          public.t_boolean DEFAULT TRUE   -- Актуальность

	Выходные параметры:
                1) _result        public.result_t                -- Пользовательский тип для индикации успешности выполнения
                1.1) _result.rc   bigint                  -- 0 (при успехе) / -1 (при ошибке)
                1.2) _result.errm character varying(2048) -- Сообщение
--------------------------------------------------------------------------------------------------------------------- */
-- ОШИБКА:  удалить объект функция nso_p_record_u2(t_guid,t_guid,t_text,t_boolean,t_boolean) нельзя, так как от него зависят другие объекты
-- DETAIL:  правило r_utl_spr_match_lc_status_u для отношения: представление utl.v_spr_match_lc_status зависит от объекта функция nso_p_record_u2(t_guid,t_guid,t_text,t_boolean,t_boolean)
-- правило r_uio_spr_k_u для отношения: представление uio.v_spr_k зависит от объекта функция nso_p_record_u2(t_guid,t_guid,t_text,t_boolean,t_boolean)
-- правило r_rsk_spr_rsk_status_u для отношения: представление rsk.v_spr_rsk_status зависит от объекта функция nso_p_record_u2(t_guid,t_guid,t_text,t_boolean,t_boolean)
-- правило r_rsk_spr_rsk_obsertn_u для отношения: представление rsk.v_spr_rsk_obsertn зависит от объекта функция nso_p_record_u2(t_guid,t_guid,t_text,t_boolean,t_boolean)
-- правило r_rsk_spr_risk_u для отношения: представление rsk.v_spr_risk зависит от объекта функция nso_p_record_u2(t_guid,t_guid,t_text,t_boolean,t_boolean)
-- правило r_rsk_spr_probablt_u для отношения: представление rsk.v_spr_probablt зависит от объекта функция nso_p_record_u2(t_guid,t_guid,t_text,t_boolean,t_boolean)
-- правило r_rsk_spr_impct_u для отношения: представление rsk.v_spr_impct зависит от объекта функция nso_p_record_u2(t_guid,t_guid,t_text,t_boolean,t_boolean)
-- правило r_nso_trouble_state_u для отношения: представление v_trouble_state зависит от объекта функция nso_p_record_u2(t_guid,t_guid,t_text,t_boolean,t_boolean)
-- правило r_nso_trouble_severity_u для отношения: представление v_trouble_severity зависит от объекта функция nso_p_record_u2(t_guid,t_guid,t_text,t_boolean,t_boolean)
-- правило r_nso_spr_val_nds_u для отношения: представление v_spr_val_nds зависит от объекта функция nso_p_record_u2(t_guid,t_guid,t_text,t_boolean,t_boolean)
-- правило r_nso_spr_type_build_u для отношения: представление v_spr_type_build зависит от объекта функция nso_p_record_u2(t_guid,t_guid,t_text,t_boolean,t_boolean)
-- правило r_nso_spr_treasr_u для отношения: представление v_spr_treasr зависит от объекта функция nso_p_record_u2(t_guid,t_guid,t_text,t_boolean,t_boolean)
-- правило r_nso_spr_tar_res_u для отношения: представление v_spr_tar_res зависит от объекта функция nso_p_record_u2(t_guid,t_guid,t_text,t_boolean,t_boolean)
-- правило r_nso_spr_stages_list_u для отношения: представление v_spr_stages_list зависит от объекта функция nso_p_record_u2(t_guid,t_guid,t_text,t_boolean,t_boolean)
-- правило r_nso_spr_rsk_status_u для отношения: представление v_spr_rsk_status зависит от объекта функция nso_p_record_u2(t_guid,t_guid,t_text,t_boolean,t_boolean)
-- правило r_nso_spr_rsk_obsertn_u для отношения: представление v_spr_rsk_obsertn зависит от объекта функция nso_p_record_u2(t_guid,t_guid,t_text,t_boolean,t_boolean)
-- правило r_nso_spr_risk_u для отношения: представление v_spr_risk зависит от объекта функция nso_p_record_u2(t_guid,t_guid,t_text,t_boolean,t_boolean)
-- правило r_nso_spr_report_list_u для отношения: представление v_spr_report_list зависит от объекта функция nso_p_record_u2(t_guid,t_guid,t_text,t_boolean,t_boolean)
-- правило r_nso_spr_ptk_u для отношения: представление v_spr_ptk зависит от объекта функция nso_p_record_u2(t_guid,t_guid,t_text,t_boolean,t_boolean)
-- правило r_nso_spr_probablt_u для отношения: представление v_spr_probablt зависит от объекта функция nso_p_record_u2(t_guid,t_guid,t_text,t_boolean,t_boolean)
-- правило r_nso_spr_pre_job_list_u для отношения: представление v_spr_pre_job_list зависит от объекта функция nso_p_record_u2(t_guid,t_guid,t_text,t_boolean,t_boolean)
-- правило r_nso_spr_position_u для отношения: представление v_spr_position зависит от объекта функция nso_p_record_u2(t_guid,t_guid,t_text,t_boolean,t_boolean)
-- правило r_nso_spr_pk_u для отношения: представление v_spr_pk зависит от объекта функция nso_p_record_u2(t_guid,t_guid,t_text,t_boolean,t_boolean)
-- правило r_nso_spr_payment_direction_u для отношения: представление v_spr_payment_direction зависит от объекта функция nso_p_record_u2(t_guid,t_guid,t_text,t_boolean,t_boolean)
-- правило r_nso_spr_okopf_u для отношения: представление v_spr_okopf зависит от объекта функция nso_p_record_u2(t_guid,t_guid,t_text,t_boolean,t_boolean)
-- правило r_nso_spr_okogu_u для отношения: представление v_spr_okogu зависит от объекта функция nso_p_record_u2(t_guid,t_guid,t_text,t_boolean,t_boolean)
-- правило r_nso_spr_okfs_u для отношения: представление v_spr_okfs зависит от объекта функция nso_p_record_u2(t_guid,t_guid,t_text,t_boolean,t_boolean)
-- правило r_nso_spr_object_status_u для отношения: представление v_spr_object_status зависит от объекта функция nso_p_record_u2(t_guid,t_guid,t_text,t_boolean,t_boolean)
-- правило r_nso_spr_object_plan_status_u для отношения: представление v_spr_object_plan_status зависит от объекта функция nso_p_record_u2(t_guid,t_guid,t_text,t_boolean,t_boolean)
-- правило r_nso_spr_metod_entr_u для отношения: представление v_spr_metod_entr зависит от объекта функция nso_p_record_u2(t_guid,t_guid,t_text,t_boolean,t_boolean)
-- правило r_nso_spr_match_lc_status_u для отношения: представление v_spr_match_lc_status зависит от объекта функция nso_p_record_u2(t_guid,t_guid,t_text,t_boolean,t_boolean)
-- правило r_nso_spr_k_u для отношения: представление v_spr_k зависит от объекта функция nso_p_record_u2(t_guid,t_guid,t_text,t_boolean,t_boolean)
-- правило r_nso_spr_job_type_u для отношения: представление v_spr_job_type зависит от объекта функция nso_p_record_u2(t_guid,t_guid,t_text,t_boolean,t_boolean)
-- правило r_nso_spr_job_direction_u для отношения: представление v_spr_job_direction зависит от объекта функция nso_p_record_u2(t_guid,t_guid,t_text,t_boolean,t_boolean)
-- правило r_nso_spr_invest_form_u для отношения: представление v_spr_invest_form зависит от объекта функция nso_p_record_u2(t_guid,t_guid,t_text,t_boolean,t_boolean)
-- правило r_nso_spr_impct_u для отношения: представление v_spr_impct зависит от объекта функция nso_p_record_u2(t_guid,t_guid,t_text,t_boolean,t_boolean)
-- правило r_nso_spr_goal_u для отношения: представление v_spr_goal зависит от объекта функция nso_p_record_u2(t_guid,t_guid,t_text,t_boolean,t_boolean)
-- правило r_nso_spr_found_type_u для отношения: представление v_spr_found_type зависит от объекта функция nso_p_record_u2(t_guid,t_guid,t_text,t_boolean,t_boolean)
-- правило r_nso_spr_foreign_state_u для отношения: представление v_spr_foreign_state зависит от объекта функция nso_p_record_u2(t_guid,t_guid,t_text,t_boolean,t_boolean)
-- правило r_nso_spr_fin_src_u для отношения: представление v_spr_fin_src зависит от объекта функция nso_p_record_u2(t_guid,t_guid,t_text,t_boolean,t_boolean)
-- правило r_nso_spr_event_u для отношения: представление v_spr_event зависит от объекта функция nso_p_record_u2(t_guid,t_guid,t_text,t_boolean,t_boolean)
-- правило r_nso_spr_enterprise_role_u для отношения: представление v_spr_enterprise_role зависит от объекта функция nso_p_record_u2(t_guid,t_guid,t_text,t_boolean,t_boolean)
-- правило r_nso_spr_employe_u для отношения: представление v_spr_employe зависит от объекта функция nso_p_record_u2(t_guid,t_guid,t_text,t_boolean,t_boolean)
-- правило r_nso_spr_division_u для отношения: представление v_spr_division зависит от объекта функция nso_p_record_u2(t_guid,t_guid,t_text,t_boolean,t_boolean)
-- правило r_nso_spr_dir_expense_u для отношения: представление v_spr_dir_expense зависит от объекта функция nso_p_record_u2(t_guid,t_guid,t_text,t_boolean,t_boolean)
-- правило r_nso_spr_day_mess_u для отношения: представление v_spr_day_mess зависит от объекта функция nso_p_record_u2(t_guid,t_guid,t_text,t_boolean,t_boolean)
-- правило r_nso_spr_crypt_u для отношения: представление v_spr_crypt зависит от объекта функция nso_p_record_u2(t_guid,t_guid,t_text,t_boolean,t_boolean)
-- правило r_nso_spr_cost_type_u для отношения: представление v_spr_cost_type зависит от объекта функция nso_p_record_u2(t_guid,t_guid,t_text,t_boolean,t_boolean)
-- правило r_nso_spr_cost_ind_u для отношения: представление v_spr_cost_ind зависит от объекта функция nso_p_record_u2(t_guid,t_guid,t_text,t_boolean,t_boolean)
-- правило r_nso_spr_contract_kind_u для отношения: представление v_spr_contract_kind зависит от объекта функция nso_p_record_u2(t_guid,t_guid,t_text,t_boolean,t_boolean)
-- правило r_nso_spr_context_list_u для отношения: представление v_spr_context_list зависит от объекта функция nso_p_record_u2(t_guid,t_guid,t_text,t_boolean,t_boolean)
-- правило r_nso_spr_cel_resours_u для отношения: представление v_spr_cel_resours зависит от объекта функция nso_p_record_u2(t_guid,t_guid,t_text,t_boolean,t_boolean)
-- правило r_nso_spr_bank_u для отношения: представление v_spr_bank зависит от объекта функция nso_p_record_u2(t_guid,t_guid,t_text,t_boolean,t_boolean)
-- правило r_nso_spr_action_u для отношения: представление v_spr_action зависит от объекта функция nso_p_record_u2(t_guid,t_guid,t_text,t_boolean,t_boolean)
-- правило r_nso_sp_coef_u для отношения: представление v_sp_coef зависит от объекта функция nso_p_record_u2(t_guid,t_guid,t_text,t_boolean,t_boolean)
-- правило r_nso_main_route_task_status_u для отношения: представление v_main_route_task_status зависит от объекта функция nso_p_record_u2(t_guid,t_guid,t_text,t_boolean,t_boolean)
-- правило r_nso_kl_secr_u для отношения: представление v_kl_secr зависит от объекта функция nso_p_record_u2(t_guid,t_guid,t_text,t_boolean,t_boolean)
-- правило r_nso_exn_data_permission_u для отношения: представление v_exn_data_permission зависит от объекта функция nso_p_record_u2(t_guid,t_guid,t_text,t_boolean,t_boolean)
-- правило r_nso_cl_test_u для отношения: представление v_cl_test зависит от объекта функция nso_p_record_u2(t_guid,t_guid,t_text,t_boolean,t_boolean)
-- правило r_nso_cl_test3_u для отношения: представление v_cl_test3 зависит от объекта функция nso_p_record_u2(t_guid,t_guid,t_text,t_boolean,t_boolean)
-- правило r_nso_cl_okv_u для отношения: представление v_cl_okv зависит от объекта функция nso_p_record_u2(t_guid,t_guid,t_text,t_boolean,t_boolean)
-- правило r_ind_spr_context_list_u для отношения: представление ind.v_spr_context_list зависит от объекта функция nso_p_record_u2(t_guid,t_guid,t_text,t_boolean,t_boolean)
-- правило r_exn_sp_coef_u для отношения: представление exn.v_sp_coef зависит от объекта функция nso_p_record_u2(t_guid,t_guid,t_text,t_boolean,t_boolean)
-- правило r_drc_trouble_state_u для отношения: представление drc.v_trouble_state зависит от объекта функция nso_p_record_u2(t_guid,t_guid,t_text,t_boolean,t_boolean)
-- правило r_drc_trouble_severity_u для отношения: представление drc.v_trouble_severity зависит от объекта функция nso_p_record_u2(t_guid,t_guid,t_text,t_boolean,t_boolean)
-- правило r_com_sp_coef_u для отношения: представление com.v_sp_coef зависит от объекта функция nso_p_record_u2(t_guid,t_guid,t_text,t_boolean,t_boolean)
-- правило r_auth_spr_crypt_u для отношения: представление auth.v_spr_crypt зависит от объекта функция nso_p_record_u2(t_guid,t_guid,t_text,t_boolean,t_boolean)
-- правило r_nso_exn_account_u для отношения: представление v_exn_account зависит от объекта функция nso_p_record_u2(t_guid,t_guid,t_text,t_boolean,t_boolean)
-- HINT:  Для удаления зависимых объектов используйте DROP ... CASCADE.
-- ********** Ошибка **********

SET search_path = nso_data, nso, com, public;

DROP FUNCTION IF EXISTS nso_data.nso_p_record_u2 ( public.t_guid, public.t_guid, public.t_text, public.t_boolean, public.t_boolean ) ; 
CREATE OR REPLACE FUNCTION nso_data.nso_p_record_u2
(
        p_rec_uuid        public.t_guid   -- Идентификатор текущей записи
       ,p_parent_rec_uuid public.t_guid   -- Идентификатор родительской записи
       ,p_val             public.t_text   -- Cтруктура "Ключ-Значение"
       ,p_silent_mode     public.t_boolean  DEFAULT TRUE -- Режим тишины, выводятся только сообщения связанные с EXECEPTION
       ,p_actual          public.t_boolean  DEFAULT TRUE  -- Актуальность
)
RETURNS public.result_t 
      SET search_path = nso, com, utl, db_info, com_error, com_codifier, com_domain, 
                        nso_structure, nso_data, public, pg_catalog
 AS
$$
   -- =====================================================================================================
   -- Author: Gregory
   -- Create date: 2015-09-28
   -- Description: Обновление записи
   -- --------------------------------------------
   -- 2015-10-14 Исправления ревизия 846   Gregory 
   -- 2015-12-11 Redmine gap #174 При проверке ссылочного значения введён контроль на NULL,
   --            Если ссылочное значение = NULL, то делаем проверку принадлежности к домену. Nick  
   -- 2016-07-13 Gregory. Контроль уникальности.
   -- 2016-11-12 Nick,  Абсолютное значение типа t_text (t_arr_values на t_arr_text, t_str2048 на t_text) 
   -- 2017-05-21 Nick,  Вместо массива p_mas_val используем структуру "Ключ-Значение".
   --                   Убираем даты начала, конца актуальности.
   -- 2018-09-05 Nick,  Все ключи hstore принудительно в вехний регистр. В заголовке НСО они всегда вверху.
   -- 2020-02-11 Nick   Переход на новое ядро.
   -- =====================================================================================================
DECLARE
        _rec_id         public.id_t;
        _nso_id         public.id_t;
        _nso_code       public.t_str60;
        _parent_rec_id  public.id_t;
        _arr_column     public.column_t2 [];
        --
        с_FUNC_NAME     public.t_sysname  := 'nso_p_record_u2';
        c_DOMAIN_NODE   public.t_str60    := 'C_DOMEN_NODE';
        c_MES000        public.t_str1024  := 'Выполнено успешно';
        -- 
        _ref_rec_id   public.id_t;
        _unique_check public.t_boolean; -- 2016-07-13 Gregory
        --
        rsp_main public.result_t;
        --        
        _rsp                public.result_t;
        _len_arr_type_code  public.t_int;
        _ind                public.t_int := 1;
        -- 
        -- Nick 2017-05-21
        -- 
        _val  hstore;

        C_DEBUG public.t_boolean = utl.f_debug_status();
        
      --
      _exception  public.exception_type_t;
      _err_args   public.t_arr_text := ARRAY [''];
      _result     public.result_long_t;  -- Nick 2020-03-30
        
  BEGIN
        -- Nick 2017-05-21
        IF (( p_rec_uuid IS NULL ) OR ( utl.com_f_empty_string_to_null ( p_val ) IS NULL ) OR 
            ( p_silent_mode  IS NULL ) OR ( p_actual IS NULL )
           )
         THEN
            	RAISE SQLSTATE '60000'; -- NULL значения запрещены
        END IF;
        --               Nick 2018-09-05
        IF C_DEBUG THEN 
               RAISE NOTICE '<%>, %, %', с_FUNC_NAME, p_rec_uuid, p_val;
        END IF;
        --
        SELECT rec_id, nso_id INTO _rec_id, _nso_id
        FROM ONLY nso.nso_record WHERE rec_uuid = p_rec_uuid;
        --
        -- 2020-02-14 Nick
        --
        IF ( _rec_id IS NULL ) THEN  -- Nick 2015-12-11   Гриня, порву как Шарик шапку.
                 _err_args [1] := _nso_id::text;
                 RAISE SQLSTATE '62052';
        END IF;                      -- Nick 2015_12-11 

        SELECT nso_code, unique_check INTO _nso_code, _unique_check
            FROM ONLY nso.nso_object WHERE nso_id = _nso_id;

        SELECT rec_id INTO _parent_rec_id
            FROM ONLY nso.nso_record WHERE rec_uuid = p_parent_rec_uuid;

        SELECT ARRAY
        (
                SELECT ROW
                (
                         col_id
                       , number_col     -- Nick 2017-05-21
                       , attr_code      -- Nick 2017-05-21
                       , attr_type_scode
                       , CASE WHEN key_type_scode IS NULL
                             THEN '0'
                             ELSE key_type_scode
                         END
                )
                FROM nso_structurte.nso_f_column_head_nso_s ( upper( btrim ( _nso_code )))
                WHERE attr_type_code <> c_DOMAIN_NODE -- 'C_DOMEN_NODE'
                ORDER BY number_col
        )
        INTO _arr_column;
        
        _len_arr_type_code := array_length (_arr_column, 1);

      -- Nick 2017-05-21 начало вторжения   

      -- 2018-09-05  Ключи нужно всегда поднимать в верхний регистр.
      _val := utl.f_hstore_key_mod (p_val); -- Отлавливать прерывание 
          
      --- 2016-07-14 Gregory
      IF _unique_check
      THEN
              UPDATE nso.nso_record_unique SET unique_check = FALSE WHERE ( rec_id = _rec_id );
      END IF;
      ---			
      IF C_DEBUG THEN
         RAISE NOTICE '<%>, %, %', с_FUNC_NAME, _val, _arr_column;
      END IF;

      WHILE ( _ind <= _len_arr_type_code )
      LOOP 
           _rsp := utl.com_f_value_check ( _arr_column [_ind].col_stype
                                       , ( _val -> _arr_column [_ind].col_code )  -- Nick 2017-05-21
           );
           IF ( _rsp.rc = -1 ) THEN
                 RAISE EXCEPTION '%', _rsp.errm ; -- Ошибка преобразования типа
           END IF;
           IF ( NOT p_silent_mode ) THEN
                          RAISE NOTICE '%', _rsp.errm;
           END IF;
           _ind := _ind + 1;
      END LOOP;
      --
      UPDATE ONLY nso.nso_record
        SET
                parent_rec_id = COALESCE ( _parent_rec_id,  parent_rec_id )
               ,actual        = COALESCE (  p_actual, actual )
               ,date_from     = CURRENT_TIMESTAMP::public.t_timestamp      -- Nick 2017-05-21
               ,date_to       = '9999-12-31 00:00:00'::public.t_timestamp
        WHERE rec_id = _rec_id;

       -- 2017-05-21 Nick
      _ind = 1;
   	WHILE ( _ind <= _len_arr_type_code ) LOOP   
         IF ( _arr_column [_ind].col_stype = 'T' ) 
         THEN -- Ссылка
            IF ( ( _val -> _arr_column [_ind].col_code ) IS NOT NULL ) -- Nick 2017-05-21
            THEN -- Nick 2015-12-11 Redmine gap #174
                  --  ---------------     
                  --  Nick 2015-07-06
                  --  -----------------------------------------------------------------------
                  --  Определить тот домен, к которому принадлежит атрибут, это nso_id.  !!!!
                  --
                  _nso_id := ( SELECT d.domain_nso_id FROM ONLY nso.nso_column_head nh
                                                         , ONLY com.nso_domain_column d 
                                WHERE ( nh.attr_id = d.attr_id ) AND 
                                      ( nh.col_id = _arr_column [_ind].col_id )
                  ); -- ID НСО-домена.
                  _ref_rec_id := ( SELECT r.rec_id FROM ONLY nso.nso_record r 
                                     WHERE ( r.rec_uuid = -- Nick 2017-05-21
                                             CAST (_val -> _arr_column [_ind].col_code AS public.t_guid)
                                           ) AND ( r.nso_id = _nso_id )
                  );-- Разыменование UUID-ссылки в ID
                  IF ( _ref_rec_id IS NULL ) THEN
                     _err_args [1] := CAST (_val -> _arr_column [_ind].col_code AS public.t_guid)::text;
                     _err_args [2] := _nso_id::text;
                     _err_args [3] := _rec_id::text;
                  
                     RAISE SQLSTATE '62053'; -- 'Неправильное ссылочное значение, не принадлежащее НСО-ДОМЕНУ'; 
                  END IF;
            ELSE
                  _ref_rec_id := NULL;
            END IF;
            --
            UPDATE ONLY nso.nso_ref
            SET
                 is_actual  = p_actual 
                ,ref_rec_id = COALESCE (_ref_rec_id, ref_rec_id )
            WHERE ( rec_id = _rec_id ) AND ( col_id = _arr_column[_ind].col_id );
                   -- иначе значение атрибута либо BLOB либо абсолютное 
         ELSE -- Не Ссылка
   	          IF ( _arr_column [_ind].col_stype <> 'q' ) THEN -- BLOB   Создаём запись с пустым значением, потом - функция  blob_push
                        -- Абсолютная величина
                        UPDATE ONLY nso.nso_abs
                        SET
                                is_actual    = p_actual -- Nick 2017-05-21
                               ,val_cell_abs = COALESCE ( _val -> _arr_column [_ind].col_code, 
                                                           val_cell_abs
                                               )
                        WHERE rec_id = _rec_id AND col_id = _arr_column[_ind].col_id;
                -- 
                END IF; -- NOT BLOB ??    
   	   END IF; -- Ссылка ??
   	   
         _ind := _ind + 1;
   	END LOOP;-- while
      -- 
      -- Nick 2017-05-21 Конец вторжения

        --- 2016-07-14 Gregory
      IF _unique_check
      THEN
              UPDATE nso.nso_record_unique SET unique_check = TRUE
              WHERE rec_id = _rec_id;
      END IF;
      --- 2016-07-13 Gregory

      rsp_main := (_rec_id, c_MES000);
      RETURN rsp_main;

  EXCEPTION
        WHEN OTHERS THEN 
                BEGIN
	                   GET STACKED DIAGNOSTICS 
                              _exception.state           := RETURNED_SQLSTATE            -- SQLSTATE
                             ,_exception.schema_name     := SCHEMA_NAME 
                             ,_exception.table_name      := TABLE_NAME 	      
                             ,_exception.constraint_name := CONSTRAINT_NAME     
                             ,_exception.column_name     := COLUMN_NAME       
                             ,_exception.datatype        := PG_DATATYPE_NAME 
                             ,_exception.message         := MESSAGE_TEXT                 -- SQLERRM
                             ,_exception.detail          := PG_EXCEPTION_DETAIL 
                             ,_exception.hint            := PG_EXCEPTION_HINT 
                             ,_exception.context         := PG_EXCEPTION_CONTEXT;            -- 
                      
                             _exception.func_name := c_ERR_FUNC_NAME; 
		                 
	                   _result := (-1, ( com_error.f_error_handling ( _exception, _err_args )));
		                 
	                   RETURN _result;   		
	            END;
  END;
$$
LANGUAGE plpgsql
SECURITY DEFINER;

COMMENT ON FUNCTION nso_data.nso_p_record_u2 ( public.t_guid, public.t_guid, public.t_text, public.t_boolean, public.t_boolean ) 
IS '286: Обновление записи. Аргументы в структуре "Ключ-Значение"
          1)  p_rec_uuid        public.t_guid   -- Идентификатор текущей записи
          2) ,p_parent_rec_uuid public.t_guid   -- Идентификатор родительской записи
          3) ,p_val             public.t_text   -- Cтруктура "Ключ-Значение"
          4) ,p_silent_mode     public.t_boolean  DEFAULT TRUE -- Режим тишины, выводятся только сообщения связанные с EXECEPTION
          5) ,p_actual          public.t_boolean  DEFAULT TRUE  -- Актуальность

	Выходные параметры:
                1)   _result public.result_t              -- Пользовательский тип для индикации успешности выполнения
                1.1) _result.rc   bigint                  -- 0 (при успехе) / -1 (при ошибке)
                1.2) _result.errm character varying(2048) -- Сообщение';

-- -------------------------------------------------------------------------------------------
