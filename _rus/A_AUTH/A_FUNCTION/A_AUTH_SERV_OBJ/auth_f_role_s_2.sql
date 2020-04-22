/*
    Входные параметры:
    1)  p_role_id           public.id_t NULL    -- идентификатор роли

    Выходные параметры:
    1)  role_id             public.id_t,        -- Идентификатор роли
    2)  parent_role_id      public.id_t,        -- Идентификатор родительской роли
    3)  system_oid          oid,                -- Системный OID
    4)  role_name           public.t_sysname,   -- Имя роли
    5)  role_description    public.t_str1024,   -- Описание роли
    6)  role_date_create    public.t_timestamp, -- Дата создания
    7)  role_date_update    public.t_timestamp, -- Дата обновления
    8)  related_role_ids    public.t_arr_id,    -- Массив ID ролей участников данной роли
    9)  related_role_oids   public.t_arr_id,    -- Массив OID ролей участников данной роли
    10) related_role_names  text[],             -- Массив наименований ролей участников данной роли
    11) is_superuser        public.t_boolean,   -- Суперпользователь
    12) is_inherit          public.t_boolean,   -- Возможность наследования
    13) is_createrole       public.t_boolean,   -- Возможность создания роли
    14) is_createdb         public.t_boolean,   -- Возможность создания базы
    15) is_catupdate        public.t_boolean,   -- Возможность модификации каталога
    16) is_login            public.t_boolean,   -- Возможность подключения к базе
    17) is_replication      public.t_boolean,   -- Возможность выполнения репликации
    18) conn_limit          public.t_int,       -- Количество одновременных подключений
    19) passwd_until_date   public.t_timestamp, -- Дата окончания действия пароля
    20) is_block            public.t_boolean,   -- Возможность блокирования пользователей
    21) is_send_recieve     public.t_boolean,   -- Возможность приёма - передачи данных
    22) time_logout         public.t_int,       -- Допустимое время не активности (минуты)
    23) qty_try_conn        public.small_t,     -- Максимальное количество допустимых попыток соединения
    24) is_blocked          public.t_boolean,   -- Признак заблокированного пользователя
    25) block_until         public.t_timestamp, -- Дата окончания блокировки
    26) block_reason        public.t_fullname,  -- Причина блокировки
    27) who_blocked         public.t_sysname    -- Заблокировавший пользователь
*/

DROP FUNCTION IF EXISTS auth_serv_obj.auth_f_role_s( public.id_t );
CREATE OR REPLACE FUNCTION auth_serv_obj.auth_f_role_s (
    p_role_id   public.id_t DEFAULT NULL::public.id_t   -- идентификатор роли
)
RETURNS TABLE  (
    role_id             public.id_t         -- Идентификатор роли
    ,parent_role_id     public.id_t         -- Идентификатор родительской роли
    ,system_oid         oid                 -- Системный OID
    ,role_name          public.t_sysname    -- Имя роли
    ,role_description   public.t_str1024    -- Описание роли
    ,role_date_create   public.t_timestamp  -- Дата создания
    ,role_date_update   public.t_timestamp  -- Дата обновления
    ,related_role_ids   public.t_arr_id     -- Массив ID ролей участников данной роли
    ,related_role_oids  public.t_arr_id     -- Массив OID ролей участников данной роли
    ,related_role_names text[]              -- Массив наименований ролей участников данной роли
    ,is_superuser       public.t_boolean    -- Суперпользователь
    ,is_inherit         public.t_boolean    -- Возможность наследования
    ,is_createrole      public.t_boolean    -- Возможность создания роли
    ,is_createdb        public.t_boolean    -- Возможность создания базы
    ,is_catupdate       public.t_boolean    -- Возможность модификации каталога
    ,is_login           public.t_boolean    -- Возможность подключения к базе
    ,is_replication     public.t_boolean    -- Возможность выполнения репликации
    ,conn_limit         public.t_int        -- Количество одновременных подключений
    ,passwd_until_date  public.t_timestamp  -- Дата окончания действия пароля
    ,is_block           public.t_boolean    -- Возможность блокирования пользователей
    ,is_send_recieve    public.t_boolean    -- Возможность приёма - передачи данных
    ,time_logout        public.t_int        -- Допустимое время не активности (минуты)
    ,qty_try_conn       public.small_t      -- Максимальное количество допустимых попыток соединения
    ,is_blocked         public.t_boolean    -- Признак заблокированного пользователя
    ,block_until        public.t_timestamp  -- Дата окончания блокировки
    ,block_reason       public.t_fullname   -- Причина блокировки
    ,who_blocked        public.t_sysname    -- Заблокировавший пользователь

) 
 SET search_path = auth, auth_serv_obj, nso, com, public, pg_catalog
AS
$$
    /*========================================================================================= */
    /* DBMS name:      PostgreSQL 8                                                             */
    /* Created on:     02.09.2015 11:00:00                                                      */
    /* ---------------------------------------------------------------------------------------- */
    /*  Особенности:                                                                            */
    /*    Аргумент - идентификатор роли, если аргумента нет, то отображается список всех ролей. */
    /*    В отличии от первоначальной функции рекурсия используется не для построения           */
    /*    иерархического списка от текущей позиции, а для нахождения всех участников роли.      */
    /*    Сам список не строится в виде дерева                                                  */
    /* ---------------------------------------------------------------------------------------- */
    /* Модификация:                                                                             */
    /*     2015-09-04 Роман. Отображение свойств существующей роли (аргумент "Имя роли").       */
    /*     2015-12-15 Ревизия 1355 Связь по имени роли.  Roman                                  */              
    /*     2018-08-17 Nick Переход на PostgresPro 9.6.6. "catupdate"  Всегда FALSE              */
    /*     2019-07-20 Nick Переход на новое ядро.                                               */
    /*========================================================================================= */
 BEGIN
    RETURN QUERY(
        WITH RECURSIVE role_info AS (
            SELECT
                -- Данные из таблицы роли
                auth_role.role_id,              -- Идентификатор роли
                auth_role.parent_role_id,       -- Идентификатор родительской роли
                auth_role.system_oid,           -- Системный OID
                --- Системный атрибут роли пользователя
                sysrol_info.role_name,          -- Имя роли пользователя
                -- Продолжение данных из таблицы роли
                auth_role.role_description,     -- Описание роли
                auth_role.date_create,          -- Дата создания
                auth_role.date_update,          -- Дата обновления
                --- Информация о ролях участниках данной роли
                related_roles.role_ids,         -- Массив ID ролей участников данной роли
                related_roles.role_system_oids, -- Массив OID ролей участников данной роли
                related_roles.role_names,       -- Массив наименований ролей участников данной роли
                --- Системные атрибуты роли пользователя
                -- sysrol_info.role_name,       -- Имя роли пользователя
                sysrol_info.is_superuser,       -- Суперпользователь
                sysrol_info.is_inherit,         -- Возможность наследования
                sysrol_info.is_createrole,      -- Возможность создания роли
                sysrol_info.is_createdb,        -- Возможность создания базы
                sysrol_info.is_catupdate,       -- Возможность модификации каталога
                sysrol_info.is_login,           -- Возможность подключения к базе
                sysrol_info.is_replication,     -- Возможность выполнения репликации
                sysrol_info.conn_limit,         -- Количество одновременных подключений
                sysrol_info.passwd_until_date,  -- Дата окончания действия пароля
                --- Атрибуты роли
                -- auth_role.system_oid,            -- Системный OID
                -- sysrol_attr_info.reg_data,       -- Дата регистрации
                sysrol_attr_info.is_block,          -- Возможность блокирования пользователей
                sysrol_attr_info.is_send_recieve,   -- Возможность приёма - передачи данных
                sysrol_attr_info.time_logout,       -- Допустимое время не активности (минуты)
                sysrol_attr_info.qty_try_conn,      -- Максимальное количество допустимых попыток соединения
                sysrol_attr_info.is_blocked,        -- Признак заблокированного пользователя
                sysrol_attr_info.block_until,       -- Дата окончания блокировки
                sysrol_attr_info.block_reason,      -- Причина блокировки
                sysrol_attr_info.who_blocked        -- Заблокировавший пользователь

				
				
            FROM ONLY auth.auth_role,
            LATERAL (
                SELECT
                    CAST( rolname AS public.t_sysname ) AS role_name,       -- Имя роли
                    CAST( rolsuper AS public.t_boolean ) AS  is_superuser,      -- Суперпользователь
                    CAST( rolinherit AS public.t_boolean ) AS is_inherit,       -- Возможность наследования
                    CAST( rolcreaterole AS public.t_boolean ) AS is_createrole, -- Возможность создания роли
                    CAST( rolcreatedb AS public.t_boolean ) AS is_createdb,     -- Возможность создания базы
                    FALSE::public.t_boolean AS is_catupdate,                   -- Nick 2018-08-17. Возможность модификации каталога
                    CAST( rolcanlogin AS public.t_boolean ) AS is_login,        -- Возможность подключения к базе
                    CAST( rolreplication AS public.t_boolean ) AS is_replication,   -- Возможность выполнения репликации
                    CAST( rolconnlimit AS public.t_int ) AS conn_limit,     -- Количество одновременных подключений
                    CAST( rolvaliduntil AS public.t_timestamp )AS passwd_until_date -- Дата окончания действия пароля
                FROM pg_catalog.pg_roles
                WHERE (pg_roles.rolname = (BTRIM(auth_role.role_name))::text) AND (auth_role.system_oid IS NOT NULL)
                UNION ALL
                SELECT
                    'public'::public.t_sysname AS role_name,        -- Имя роли
                    false::public.t_boolean AS  is_superuser,       -- Суперпользователь
                    false::public.t_boolean AS is_inherit,          -- Возможность наследования
                    false::public.t_boolean AS is_createrole,       -- Возможность создания роли
                    false::public.t_boolean AS is_createdb,         -- Возможность создания базы
                    false::public.t_boolean AS is_catupdate,        -- Возможность модификации каталога
                    false::public.t_boolean AS is_login,            -- Возможность подключения к базе
                    false::public.t_boolean AS is_replication,      -- Возможность выполнения репликации
                    0::public.t_int AS conn_limit,              -- Количество одновременных подключений
                    'infinity'::public.t_timestamp AS passwd_until_date -- Дата окончания действия пароля
                WHERE (auth_role.system_oid IS NULL)

            ) AS sysrol_info,
            LATERAL (
                SELECT
                utl.auth_f_get_user_attr_s (sysrol_info.role_name, 'reg_data', 'infinity'::public.t_timestamp) AS reg_data,     -- Дата регистрации
                utl.auth_f_get_user_attr_s (sysrol_info.role_name, 'time_logout', 0::public.t_int) AS time_logout,          -- Допустимое время не активности (минуты)
                utl.auth_f_get_user_attr_s (sysrol_info.role_name, 'qty_try_conn', 3::public.small_t) AS qty_try_conn,          -- Максимальное количество допустимых попыток соединения
                utl.auth_f_get_user_attr_s (sysrol_info.role_name, 'is_blocked', TRUE::public.t_boolean) AS is_blocked,         -- Признак заблокированного пользователя
                utl.auth_f_get_user_attr_s (sysrol_info.role_name, 'block_until', NULL::public.t_timestamp) AS block_until,     -- Дата окончания блокировки
                utl.auth_f_get_user_attr_s (sysrol_info.role_name, 'block_reason', ''::public.t_fullname) AS block_reason,      -- Причина блокировки
                utl.auth_f_get_user_attr_s (sysrol_info.role_name, 'who_blocked', ''::public.t_sysname) AS who_blocked,         -- Заблокировавший пользователь
                utl.auth_f_get_user_attr_s (sysrol_info.role_name, 'is_block', false::public.t_boolean) AS is_block,            -- Возможность блокирования пользователей
                utl.auth_f_get_user_attr_s (sysrol_info.role_name, 'is_send_recieve', false::public.t_boolean) AS is_send_recieve   -- Возможность приёма - передачи данных
            ) AS sysrol_attr_info,
            LATERAL (
                WITH RECURSIVE
                    roles AS (
                        SELECT
                            r.role_id,
                            r.parent_role_id,
                            ARRAY [ r.role_id::bigint ]  AS tree_d
                        FROM ONLY auth.auth_role r
                        WHERE r.role_id = auth_role.role_id
                        UNION ALL
                            SELECT
                                child.role_id,
                                child.parent_role_id,
                                parent.tree_d ||  ARRAY [ child.role_id::bigint ]
                            FROM ONLY auth.auth_role child
                            JOIN roles parent ON (parent.parent_role_id = child.role_id)
                            WHERE NOT (child.role_id = ANY(parent.tree_d))
                    ),
                    inherit_roles AS (
                        SELECT DISTINCT
                             id.id AS id
                        FROM roles,
                        LATERAL ( SELECT unnest (tree_d ) As id FROM roles ) AS id
                    ),
                    inherit_agg_roles AS(
                        SELECT array_agg(a.id) AS role_ids,
                        array_agg(c.oid::bigint) As role_system_oids,
                        array_agg(c.rolname::text) As role_names
                        FROM inherit_roles a
                        JOIN auth.auth_role b ON (b.role_id = a.id)
                        JOIN pg_roles c ON (c.oid = b.system_oid)
                    )
                    SELECT
                        CAST ( role_ids AS public.t_arr_id ) AS role_ids,
                        CAST ( role_system_oids AS public.t_arr_id ) AS role_system_oids,
                        role_names
                    FROM inherit_agg_roles
            ) AS related_roles

            WHERE ( COALESCE ( p_role_id, auth_role.role_id ) = auth_role.role_id )
        ) SELECT * FROM role_info
    );
 END;
$$
  STABLE
  SECURITY DEFINER
  LANGUAGE plpgsql;


COMMENT ON FUNCTION auth_serv_obj.auth_f_role_s ( public.id_t ) 
   IS '186: Отображение свойств существующей роли. Аргумент ID роли.
Входные параметры:
    1)  p_role_id           public.id_t NULL    -- идентификатор роли

Выходные параметры:
    1)  role_id             public.id_t,        -- Идентификатор роли
    2)  parent_role_id      public.id_t,        -- Идентификатор родительской роли
    3)  system_oid          oid,                -- Системный OID
    4)  role_name           public.t_sysname,   -- Имя роли
    5)  role_description    public.t_str1024,   -- Описание роли
    6)  role_date_create    public.t_timestamp, -- Дата создания
    7)  role_date_update    public.t_timestamp, -- Дата обновления
    8)  related_role_ids    public.t_arr_id,    -- Массив ID ролей участников данной роли
    9)  related_role_oids   public.t_arr_id,    -- Массив OID ролей участников данной роли
    10) related_role_names  text[],             -- Массив наименований ролей участников данной роли
    11) is_superuser        public.t_boolean,   -- Суперпользователь
    12) is_inherit          public.t_boolean,   -- Возможность наследования
    13) is_createrole       public.t_boolean,   -- Возможность создания роли
    14) is_createdb         public.t_boolean,   -- Возможность создания базы
    15) is_catupdate        public.t_boolean,   -- Возможность модификации каталога
    16) is_login            public.t_boolean,   -- Возможность подключения к базе
    17) is_replication      public.t_boolean,   -- Возможность выполнения репликации
    18) conn_limit          public.t_int,       -- Количество одновременных подключений
    19) passwd_until_date   public.t_timestamp, -- Дата окончания действия пароля
    20) is_block            public.t_boolean,   -- Возможность блокирования пользователей
    21) is_send_recieve     public.t_boolean,   -- Возможность приёма - передачи данных
    22) time_logout         public.t_int,       -- Допустимое время не активности (минуты)
    23) qty_try_conn        public.small_t,     -- Максимальное количество допустимых попыток соединения
    24) is_blocked          public.t_boolean,   -- Признак заблокированного пользователя
    25) block_until         public.t_timestamp, -- Дата окончания блокировки
    26) block_reason        public.t_fullname,  -- Причина блокировки
    27) who_blocked         public.t_sysname    -- Заблокировавший пользователь';
-- --------------------------------------------------------------------------------
-- SELECT * FROM plpgsql_check_function_tb ('auth_serv_obj.auth_f_role_s ( public.id_t ) ', security_warnings := true, fatal_errors := false);
-- OK
-- SELECT * from auth_serv_obj.auth_f_role_s(NULL::public.id_t);
--- RESULT: 10;;179144;"IDLE";"Empty role";"2015-08-26 18:27:33";"9999-12-31 00:00:00";"{10}";"{179144}";"{IDLE}";f;f;f;f;f;f;f;-1;"";f;f;0;3;t;"";"";""
    --- 11;;179145;"ps/5";"Индивидуальная роль для пользователя "ps/5"(Полежаев Юрий Петрович Начальник отдела)";"2015-08-26 18:27:33";"9999-12-31 00:00:00";"{11}";"{179145}";"{ps/5}";f;f;f;f;f;f;f;-1;"infinity";f;f;0;3;f;"";"";""
    --- 12;11;187160;"test";"тестовая роль";"2015-09-01 17:11:12";"9999-12-31 00:00:00";"{11,12}";"{179145,187160}";"{ps/5,test}";f;t;f;f;f;f;f;-1;"infinity";f;f;0;3;f;"";"";""

-- SELECT * from auth.auth_f_role_s(12);
--- RESULT: 12;11;187160;"test";"тестовая роль";"2015-09-01 17:11:12";"9999-12-31 00:00:00";"{11,12}";"{179145,187160}";"{ps/5,test}";f;t;f;f;f;f;f;-1;"infinity";f;f;0;3;f;"";"";""
