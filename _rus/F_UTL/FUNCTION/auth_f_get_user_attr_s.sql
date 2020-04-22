/*
    Входные данные
    1) p_user_name      public.t_sysname    --  Имя пользователя
    2) p_attr_name      public.t_sysname    --  Наименование атрибута
    3) p_attr_val_def   anyelement          --  Элемент значения по умолчанию
                                                (для динамического определения
                                                типа возвращаемого значения
                                                и подстановки дефолного значения
                                                в случае если атрибут не заведен)
    Выходные данные
    1) p_attr_val       anyelement          --  Значение атрибута (Тип динамически определяется по значению p_attr_val_def )

    Особенности:
    Функция читает атрибут из защищенной таблицы pg_roles.rolconfig

    Атрибуты добавляются следующим способом
    ALTER ROLE auth_manager SET user_attr.reg_data TO '2015-07-30 23:01:00.684+03';

    Для этого механизма необходимо в файл postgres.conf добавить пользовательские расширения свойств
    ( ТОЛЬКО ДЛЯ АТРИБУТОВ ИМЕЮШИХ ЗНАЧЕНИЯ ПО УМОЛЧАНИЮ, т.е. 
      ALTER ROLE auth_manager SET user_attr.reg_data TO DEFAULT; 
    )

    # Add settings for extensions here
    #------------------------------------------------------------------------------------------------------------
    #custom_variable_classes = 'user_attr,role_attr' # Раскомментировать для PosgreSQL версии ниже или равной 9.2
    #
    user_attr.reg_data        = '9999-12-31 00:00:00'          # Дата регистрации пользователя
    user_attr.is_blocked      = 'true'                         # Признак заблокированного пользователя
    user_attr.time_logout     = '0'                            # Допустимое время не активности (минуты)
    user_attr.block_until     = '9999-12-31 00:00:00'          # Дата окончания блокировки
    user_attr.block_reason    = 'Без причины признак дурачины' # Причина блокировки
    user_attr.who_blocked     = 'system'                       # Заблокировавший пользователь
    user_attr.employe_id      = '-1'                           # Идентификатор сотрудника
    user_attr.qty_try_conn    = '5'                            # Максимальное количество возможных не успешных попыток соединения

    role_attr.is_block        = 'false'                        # Возможность блокирования пользователей
    role_attr.is_send_recieve = 'false'                        # Возможность приёма - передачи данных
*/

DROP FUNCTION IF EXISTS utl.auth_f_get_user_attr_s ( public.t_sysname, public.t_sysname, anyelement );
CREATE OR REPLACE FUNCTION utl.auth_f_get_user_attr_s (
            IN  p_user_name     public.t_sysname,   --  Имя пользователя
            IN  p_attr_name     public.t_sysname,   --  Наименование атрибута
            IN  p_attr_val_def  anyelement,         --  Значение по умолчанию (для динамического определения
                                                    --  типа возвращаемого значения
                                                    --  и подстановки дефолного значения
                                                    --  в случае если атрибут не заведен)
            OUT p_attr_value   anyelement           --  Значение атрибута (Выходной параметр)
)
SET search_path = utl, public, pg_catalog
AS
 $$
   /*==============================================================*/
   /* DBMS name:      PostgreSQL 8                                 */
   /* Created on:     28.08.2015 11:15:00                          */
   /* Модификация: 2015-08-28                                      */
   /* Получение значения аттрибута для роли пользователя. Роман    */
   /* ------------------------------------------------------------ */
   /* 2019-05-23  Новое ядро, но это последний "динозавр" Романа.  */
   /*==============================================================*/
  DECLARE
    _row_count  integer;
    _user_name  public.t_sysname;   --  Имя пользователя
    
  BEGIN
    _user_name := btrim (E'' || p_user_name);
    --
    IF (_user_name ~* '^(public|postgres)$' ) THEN
        _row_count := 0;
    ELSE
        EXECUTE format ('WITH t1  ( role_config ) AS
            ( SELECT unnest(rolconfig) AS role_config FROM pg_roles WHERE (rolname=((ARRAY[ %L ]::text[])[1])) )
            SELECT CAST ( regexp_replace(role_config, ''^(user_attr.%s=|role_attr.%2$s=)'', '''') AS %s )
            FROM t1 WHERE role_config ~  ''^(user_attr.%2$s=.*|role_attr.%2$s=.*)'' LIMIT 1 OFFSET 0'
            ,_user_name
            , btrim (p_attr_name)
            , pg_typeof (p_attr_val_def)) 
        INTO p_attr_value;
        GET DIAGNOSTICS  _row_count = ROW_COUNT;
        
    END IF;
    --
    IF ( _row_count <= 0 ) THEN
        p_attr_value := p_attr_val_def;
    END IF;

  END;
$$ 
  LANGUAGE plpgsql STABLE SECURITY DEFINER;

COMMENT ON FUNCTION utl.auth_f_get_user_attr_s ( public.t_sysname, public.t_sysname, anyelement ) 
    IS '35: Получение значения атрибута пользователя

Входные данные
    1) p_user_name      public.t_sysname    -- Имя пользователя
    2) p_attr_name      public.t_sysname    -- Наименование атрибута
    3) p_attr_val_def   anyelement          -- Значение по умолчанию (для динамического определения типа возвращаемого значения и подстановки дефолного значения в случае если атрибут не заведен)

Выходные данные
    1) p_attr_val       anyelement          -- Значение атрибута (Тип динамически определяется по значению p_attr_val_def )';

--- SELECT * FROM  auth.auth_f_get_user_attr_s('auth_manager', 'reg_data', '9999-01-30 00:00:00'::public.t_timestamp);
    --- РЕЗУЛЬТАТ: "2015-07-30 23:01:01"::timestamp(0) without time zone
--- SELECT * FROM  auth.auth_f_get_user_attr_s('auth_manager_м10050', 'registry_data', '9999-01-30 00:00:00'::public.t_timestamp);
    --- РЕЗУЛЬТАТ: "9999-01-30 00:00:00"::timestamp(0) without time zone
--- SELECT * FROM  auth.auth_f_get_user_attr_s('ps/5', 'is_block', false::public.t_boolean);

--- SELECT * FROM  auth.auth_f_get_user_attr_s('puBlic', 'reg_data', '9999-01-30 00:00:00'::public.t_timestamp);
