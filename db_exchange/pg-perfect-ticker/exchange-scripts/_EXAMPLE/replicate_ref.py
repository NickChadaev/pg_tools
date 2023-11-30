# -*- mode: python; coding: utf-8 -*-

#
# 2020-10-19 Nick. Исходный вариант скрипта содержал репликацию бизнес-статистики на "fc_cbd". 
#   После переноса бизнес-статистики эта часть исключена из работы. Так-же были исключены: 
#          "face_control_transfer.select_repl()" и "face_control_transfer.cleanup_repl()". 
#   Исчезла необходимость в схеме "face_control_transfer" на стороне "tf_checks". 
#   Всё остальное  - без изменений

import lib_sync_tables
import shlex
import psycopg2, psycopg2.extras, psycopg2.extensions
from lib_pg_perfect_ticker import simple_db_pool

FETCH_COUNT = 500

TF_CHECKS_ID_SQL = '''\
select traffic_face_ident.tf_checks_id ()\
'''

FC_CBD_SELECT_SQL = '''\
select face_control_traffic.select_repl (%(subscriber)s)\
'''

FC_CBD_CLEANUP_SQL = '''\
select face_control_traffic.cleanup_repl (%(subscriber)s)\
'''

UPDATE_CATEGORIES_FROM_FC_SQL = '''\
select face_control_traffic.update_vn_categories_from_fc (ir.instance)
        from face_control_traffic.get_vn_instance_ref_for_tf_checks (%(tf_checks_id)s) ir\
'''

UPDATE_BUSIN_CLIENT_PERSONS_SQL = '''\
select face_control_traffic.update_busin_client_persons ()\
'''

UPDATE_BUSIN_STATS_REFS_SQL = '''\
select traffic_face_ref.update_busin_stats_refs ()\
'''

arg_list = shlex.split(ticker_task_ctx.task_script_arg)

assert len(arg_list) == 2

def get_bool_arg(arg):
    if arg.lower() in ('no', 'false', '0'):
        return False
    if arg.lower() in ('yes', 'true', '1'):
        return True
    raise ValueError('invalid literal for bool: {!r}'.format(arg))

fc_cbd_db_con_dsn = arg_list[0]
remote_media_disabled = get_bool_arg(arg_list[1])

fc_cbd_con = stack.enter_context(
    simple_db_pool.get_db_con_ctxmgr(
        ticker_task_ctx.db_pool,
        fc_cbd_db_con_dsn,
    ),
)

assert not con.autocommit
assert con.isolation_level != psycopg2.extensions.ISOLATION_LEVEL_REPEATABLE_READ
assert not fc_cbd_con.autocommit
assert fc_cbd_con.isolation_level != psycopg2.extensions.ISOLATION_LEVEL_REPEATABLE_READ

con.isolation_level = psycopg2.extensions.ISOLATION_LEVEL_REPEATABLE_READ
fc_cbd_con.isolation_level = psycopg2.extensions.ISOLATION_LEVEL_REPEATABLE_READ

cur = stack.enter_context(con.cursor())
fc_cbd_cur = stack.enter_context(fc_cbd_con.cursor())

fc_cbd_cur.arraysize = FETCH_COUNT

cur.execute(TF_CHECKS_ID_SQL)

tf_checks_id, = cur.fetchone()

fc_cbd_cur.execute(
    FC_CBD_SELECT_SQL,
    {
        'subscriber': 'tf_checks_{}'.format(tf_checks_id),
    },
)

fc_cbd_cur.execute(
    UPDATE_CATEGORIES_FROM_FC_SQL,
    {
        'tf_checks_id': tf_checks_id,
    },
)

fc_cbd_cur.execute(UPDATE_BUSIN_CLIENT_PERSONS_SQL)

# Первая репликация  "fc_cbd" -> "tf_checks"   "traffic_face_ref_var.vn_instance_ref"
lib_sync_tables.sync_tables(
    fc_cbd_con, con,
    'face_control_traffic', 'get_vn_instance_ref_for_tf_checks', [tf_checks_id],
    'traffic_face_ref_var', 'vn_instance_ref',
    [
        'instance',
        'vendor'
    ],
    [
        'bigint',
        'text'
    ],
    0,
    None,
    None,
    FETCH_COUNT,
)

# Вторая репликация   "fc_cbd" -> "tf_checks"   "traffic_face_ref_var.vn_category_ref"
lib_sync_tables.sync_tables(
    fc_cbd_con, con,
    'face_control_traffic', 'get_vn_category_ref_for_tf_checks', [tf_checks_id],
    'traffic_face_ref_var', 'vn_category_ref',
    [
        'vn_category_ref_id',
        'instance',
        'category',
        'remote_category',
        'threshold',
        'category_type',
        'category_params',
        'time_start',
        'time_stop',
    ],
    [
        'bigint',
        'bigint',
        'bigint',
        'text',
        'numeric',
        'text',
        'jsonb',
        'timestamp without time zone',
        'timestamp without time zone',
    ],
    0,
    [
        None,
        None,
        None,
        None,
        None,
        None,
        'st.category_params::text',
        None,
        None,
    ],
    None,
    FETCH_COUNT,
)

# Третья репликация  "fc_cbd" -> "tf_checks"   "traffic_face_ref_var.vn_remote_media"
if not remote_media_disabled:
    lib_sync_tables.sync_tables(
        fc_cbd_con, con,
        'face_control_traffic', 'get_remote_media', [tf_checks_id],
        'traffic_face_ref_var', 'vn_remote_media',
        [
            'vn_remote_media_id',
            'instance',
            'category',
            'creat_datetime',
            'remote_media_id',
            'remote_person_id',
            'media_id',
            'person_id',
            'descr_version',
            'descr',
            'feedback'
        ],
        [
            'bigint',
            'bigint',
            'bigint',
            'timestamp with time zone',
            'text',
            'text',
            'bigint',
            'bigint',
            'text',
            'bytea',
            'jsonb'
        ],
        0,
        [
            None,
            None,
            None,
            None,
            None,
            None,
            None,
            None,
            None,
            None,
            'st.feedback::text'
        ],
        None,
        FETCH_COUNT,
        hint_fun=('face_control_traffic', 'get_vn_remote_media_repl_hints'),
        hint_fun_args=['tf_checks_{}'.format(tf_checks_id)],
    )

# Четвёртая репликация  "fc_cbd" -> "tf_checks"   "traffic_face_ref_var.camera_ref"
lib_sync_tables.sync_tables(
    fc_cbd_con, con,
    'face_control', 'api_s_cameras_v', None,
    'traffic_face_ref_var', 'camera_ref',
    [
        'camera_id',
        'camera',
        'camera_type',
        'print_name',
        'place',
        'latitude',
        'longitude',
        'azimuth',
        'note',
        'threshold',
        'territory_id',
        'territory_name',
        'group_id',
        'group_name',
        'camera_category',
        'fsense_point_id',
    ],
    [
        'bigint',
        'text',
        'integer',
        'text',
        'text',
        'numeric',
        'numeric',
        'numeric',
        'text',
        'numeric',
        'bigint',
        'text',
        'bigint',
        'text',
        'integer',
        'bigint',
    ],
    0,
    [
        None,
        None,
        None,
        'st.name',
        'st.place_text',
        None,
        None,
        'st.azimut',
        'st.note',
        'st.min_proc / 100.0',
        None,
        None,
        None,
        None,
        None,
        None,
    ],
    None,
    FETCH_COUNT,
)

# Пятая репликация  "fc_cbd" -> "tf_checks"   "traffic_face_ref_var.vendor_sml_value_map"
lib_sync_tables.sync_tables(
    fc_cbd_con, con,
    'face_control_traffic_var', 'vendor_sml_value_map', None,
    'traffic_face_ref_var', 'vendor_sml_value_map',
    [
        'vendor_sml_value_map_id',
        'instance',
        'vn_sml_value',
        'vendor_sml_value',
    ],
    [
        'bigint',
        'bigint',
        'numeric',
        'numeric',
    ],
    0,
    None,
    None,
    FETCH_COUNT,
)

# Шестая репликация  "fc_cbd" -> "tf_checks"   "traffic_face_ref_var.busin_client_persons"
lib_sync_tables.sync_tables(
    fc_cbd_con, con,
    'face_control_traffic_var', 'busin_client_persons', None,
    'traffic_face_ref_var', 'busin_client_persons',
    [
        'person_id',
        'emp_point_ids',
    ],
    [
        'bigint',
        'bigint[]',
    ],
    0,
    [
        'st.fc_person_id::bigint',
        None,
    ],
    'st.fc_person_id',
    FETCH_COUNT,
    hint_fun=('face_control_traffic', 'get_busin_client_persons_hints'),
    hint_fun_args=['tf_checks_{}'.format(tf_checks_id)],
)

cur.execute(UPDATE_BUSIN_STATS_REFS_SQL)
#
# 2020-10-19 Далее была исключённая репликация бизнес-статистики.
#
con.commit()
fc_cbd_con.commit()

fc_cbd_cur.execute(
    FC_CBD_CLEANUP_SQL,
    {
        'subscriber': 'tf_checks_{}'.format(tf_checks_id),
    },
)

fc_cbd_con.commit()
