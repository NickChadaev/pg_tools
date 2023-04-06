# vim: et ts=4 sw=4

import psycopg2, psycopg2.extras, psycopg2.extensions

def _quote_ident(ident):
    # функция ``psycopg2.extensions.quote_ident(str, scope)`` {see: libpq docs for PQescapeIdentifier()}
    # может оказаться непригодной когда нужно заэкранировать
    # для использования в разных ``scope``

    assert isinstance(ident, str)

    return '"{}"'.format(ident.replace('"', '""'))

def _prepare_many_values(prefix, values, types):
    bparams = []
    val_map = {}

    for b, bval in enumerate(values):
        vparams = []
    
        for i, v in enumerate(bval):
            param = '{}_b{}_p{}'.format(prefix, b, i)

            if types is not None:
                t = types[i]
            else:
                t = None

            if t is not None:
                sql = '%({})s::{}'.format(param, t)
            else:
                sql = '%({})s'.format(param)

            vparams.append(sql)
            val_map[param] = v

        vparams_sql = '({})'.format(', '.join(vparams))

        bparams.append(vparams_sql)

    bparams_sql = ', '.join(bparams)

    return bparams_sql, val_map

def sync_tables(
            src_con, dst_con,
            src_sch, src_tab, src_fun_args,
            dst_sch, dst_tab,
            fields, types, pk_i, exprs, pk_expr,
            arraysize,
            hint_fun=None,
            hint_fun_args=None,
            _quote_ident_func=_quote_ident,
            _prepare_many_values_func=_prepare_many_values,
        ):
    # подключение к БД источника данных
    assert src_con is not None
    # подключение к БД назначения данных
    assert dst_con is not None
    # схема таблицы источника даных
    assert isinstance(src_sch, str)
    # имя таблицы (или имя функции) источника данных
    assert isinstance(src_tab, str)
    # если заполнено то список аргументов функции источника данных
    assert src_fun_args is None or isinstance(src_fun_args, list)
    # схема таблицы назначения даных
    assert isinstance(dst_sch, str)
    # имя таблицы назначения даных
    assert isinstance(dst_tab, str)
    # список имён полей (str), ориентируясь на таблицу назначения
    assert isinstance(fields, list)
    # список типов (SQL-выражения) которые будут уточнять значения в соответствии с таблицей назначения
    assert isinstance(types, list)
    # первичный ключ, int or tuple of int,
    # номера (начиная с 0) какие поля из fields есть паервичные
    assert isinstance(pk_i, (int, tuple))
    # если заполнено то SQL-выражение получения данных полей источника данных
    assert exprs is None or isinstance(exprs, list)
    # если заполнено то SQL-выражение описывающее первичный ключ str (поле или кортеж полей) источника данных
    assert pk_expr is None or isinstance(pk_expr, str)
    # какими пачками вытягивать данные
    assert isinstance(arraysize, int)
    # функция tuple(function_schema,function_name) подсказки над чем работать "что могло поменяться?" источника данных
    assert hint_fun is None or isinstance(hint_fun, tuple)
    # список аргументов функции подказки источника данных, если они требуются
    assert hint_fun_args is None or isinstance(hint_fun_args, list)

    # у функции слишком много аргументов, вероятно можно надопускать ошибок в них,
    # поэтому не помешает их эта чуть-более расширенная (дополнительная) проверка
    assert not src_con.autocommit
    assert src_con.isolation_level == psycopg2.extensions.ISOLATION_LEVEL_REPEATABLE_READ
    assert not dst_con.autocommit
    assert dst_con.isolation_level == psycopg2.extensions.ISOLATION_LEVEL_REPEATABLE_READ
    assert [f for f in fields if isinstance(f, str)] == fields
    assert [t for t in types if isinstance(t, str)] == types and \
            len(types) == len(fields)
    assert not isinstance(pk_i, tuple) or \
            tuple(i for i in pk_i if isinstance(i, int) and i >= -len(fields) and i < len(fields)) == pk_i
    assert not isinstance(exprs, list) or \
            [e for e in exprs if e is None or isinstance(e, str)] == exprs and \
            len(exprs) == len(fields)
    assert arraysize > 1
    assert not isinstance(hint_fun, tuple) or \
            tuple(i for i in hint_fun if isinstance(i, str)) == hint_fun and \
            len(hint_fun) == 2

    if src_fun_args is not None:
        sargs_sql, sargs_map = _prepare_many_values('sargs', [src_fun_args], None)

        stexpr_sql = '{}.{} {}'.format(
            _quote_ident_func(src_sch),
            _quote_ident_func(src_tab),
            sargs_sql,
        )
    else:
        sargs_map = {}
        stexpr_sql = '{}.{}'.format(
            _quote_ident_func(src_sch),
            _quote_ident_func(src_tab),
        )

    if exprs is not None:
        sexprs_sql = ', '.join(
            e if e is not None
            else 'st.{}'.format(_quote_ident_func(fields[i]))
            for i, e in enumerate(exprs)
        )
    else:
        sexprs_sql = ', '.join(
            'st.{}'.format(_quote_ident_func(e))
            for e in fields
        )

    if pk_expr is not None:
        spk_sql = pk_expr
    else:
        if isinstance(pk_i, tuple):
            spk_sql = '({})'.format(
                ', '.join(
                    'st.{}'.format(_quote_ident_func(fields[i]))
                    for i in pk_i
                ),
            )
        else:
            spk_sql = 'st.{}'.format(_quote_ident_func(fields[pk_i]))

    if isinstance(pk_i, tuple):
        pk_types = [types[i] for i in pk_i]
    else:
        pk_types = [types[pk_i]]

    fields_sql = ', '.join(
        _quote_ident_func(f)
        for f in fields
    )
    dfields_sql = ', '.join(
        'dt.{}'.format(_quote_ident_func(f))
        for f in fields
    )
    dsfields_sql = ', '.join(
        'st.{}'.format(_quote_ident_func(f))
        for f in fields
    )

    # dpk -- dest-table primary key
    # dspk -- source-table primary key: on destination site
    # dfpk -- dest-table primary key: as fields
    # dsfpk -- source-table primary key: on destination side, as fields

    if isinstance(pk_i, tuple):
        dfpk_sql = ', '.join(
            'dt.{}'.format(_quote_ident_func(fields[i]))
            for i in pk_i
        )
        dsfpk_sql = ', '.join(
            'st.{}'.format(_quote_ident_func(fields[i]))
            for i in pk_i
        )
        dpk_sql = '({})'.format(dfpk_sql)
        dspk_sql = '({})'.format(dsfpk_sql)
    else:
        dpk_sql = 'dt.{}'.format(_quote_ident_func(fields[pk_i]))
        dspk_sql = 'st.{}'.format(_quote_ident_func(fields[pk_i]))
        dfpk_sql = dpk_sql
        dsfpk_sql = dspk_sql

    fetch_sql = 'select {sexprs_sql}\n' \
            'from {stexpr_sql} st\n' \
            'order by {spk_sql}'.format(
                stexpr_sql=stexpr_sql,
                sexprs_sql=sexprs_sql,
                spk_sql=spk_sql,
            )

    fetch_hinted_sql_tpl = 'select {sexprs_sql}\n' \
            'from {stexpr_sql} st\n' \
            'where {spk_sql} in (values {{hintvalues}})\n' \
            'order by {spk_sql}'.format(
                stexpr_sql=stexpr_sql,
                sexprs_sql=sexprs_sql,
                spk_sql=spk_sql,
            )

    delete_sql_tpl = 'with st ({fields_sql}) as (values {{svalues_sql}})\n' \
            'delete from {dst_sch}.{dst_tab} dt\n' \
            'using st\n' \
            'where (%(prev_pk)s is null or {dpk_sql} > %(prev_pk)s) and {dpk_sql} <= %(last_pk)s and\n' \
            '({dpk_sql} not in (select {dsfpk_sql} from st) or {dpk_sql} = {dspk_sql} and ({dfields_sql}) is distinct from ({dsfields_sql}))\n'.format(
                dst_sch=_quote_ident_func(dst_sch),
                dst_tab=_quote_ident_func(dst_tab),
                fields_sql=fields_sql,
                dfields_sql=dfields_sql,
                dsfields_sql=dsfields_sql,
                dpk_sql=dpk_sql,
                dspk_sql=dspk_sql,
                dsfpk_sql=dsfpk_sql,
            )

    delete_hinted_sql_tpl = 'delete from {dst_sch}.{dst_tab} dt\n' \
            'where {dpk_sql} in (values {{hintvalues}})'.format(
                dst_sch=_quote_ident_func(dst_sch),
                dst_tab=_quote_ident_func(dst_tab),
                dpk_sql=dpk_sql,
            )

    final_delete_sql = 'delete from {dst_sch}.{dst_tab} dt\n' \
            'where %(prev_pk)s is null or {dpk_sql} > %(prev_pk)s\n'.format(
                dst_sch=_quote_ident_func(dst_sch),
                dst_tab=_quote_ident_func(dst_tab),
                dpk_sql=dpk_sql,
            )

    insert_sql_tpl = 'with st ({fields_sql}) as (values {{svalues_sql}}),\n' \
            'dt_pk as (select {dfpk_sql} pk from {dst_sch}.{dst_tab} dt\n' \
            'where (%(prev_pk)s is null or {dpk_sql} > %(prev_pk)s) and {dpk_sql} <= %(last_pk)s)\n' \
            'insert into {dst_sch}.{dst_tab} ({fields_sql})\n' \
            'select st.* from st\n' \
            'where {dspk_sql} not in (select dt_pk.* from dt_pk)'.format(
                dst_sch=_quote_ident_func(dst_sch),
                dst_tab=_quote_ident_func(dst_tab),
                fields_sql=fields_sql,
                dpk_sql=dpk_sql,
                dspk_sql=dspk_sql,
                dfpk_sql=dfpk_sql,
            )

    insert_hinted_sql_tpl = 'with st ({fields_sql}) as (values {{svalues_sql}})\n' \
            'insert into {dst_sch}.{dst_tab} ({fields_sql})\n' \
            'select st.* from st'.format(
                dst_sch=_quote_ident_func(dst_sch),
                dst_tab=_quote_ident_func(dst_tab),
                fields_sql=fields_sql,
            )

    with src_con.cursor() as src_cur, dst_con.cursor() as dst_cur:
        src_cur.arraysize = arraysize

        if hint_fun:
            hint_args_sql, hint_args_map = _prepare_many_values(
                    'hintargs',
                    [hint_fun_args if hint_fun_args is not None else []],
                    None)

            fetch_hints_sql = 'select st.*\nfrom {}.{} {} st'.format(
                _quote_ident_func(hint_fun[0]),
                _quote_ident_func(hint_fun[1]),
                hint_args_sql,
            )

            src_cur.execute(fetch_hints_sql, hint_args_map)

            hint_rows = src_cur.fetchall()

            if True:    # TODO  в будущем тут надо сделать цикл и удалять пачками по arraysize,
                        #       затем второй цикл добавлять пачками по arraysize
                if not hint_rows:
                    # изменений не было. реплицировать ни чего не будем

                    return

                hintvalues_sql, hintvalues_params = _prepare_many_values_func(
                        'hintvalues', hint_rows, pk_types)

                delete_hinted_sql = delete_hinted_sql_tpl.format(
                    hintvalues=hintvalues_sql,
                )

                dst_cur.execute(delete_hinted_sql, hintvalues_params)

                fetch_hinted_sql = fetch_hinted_sql_tpl.format(
                    hintvalues=hintvalues_sql,
                )

                sql_params = {}
                sql_params.update(sargs_map)
                sql_params.update(hintvalues_params)

                src_cur.execute(fetch_hinted_sql, sql_params)

                rows = src_cur.fetchall()

                if not rows:
                    # вставлять нечего, только удалили лишнее и всё

                    return

                svalues_sql, svalues_map = _prepare_many_values_func(
                        'svalue', rows, types)

                insert_hinted_sql = insert_hinted_sql_tpl.format(
                    svalues_sql=svalues_sql,
                )

                dst_cur.execute(insert_hinted_sql, svalues_map)

                # репликация по подсказкам завершена,
                # и далее поэтому обычную репликацию запускать НЕ будем

                return

        def do_del_or_ins_cycle(del_or_ins_sql_tpl):
            nonlocal prev_pk

            prev_pk = None

            src_cur.execute(fetch_sql, sargs_map)

            while True:
                rows = src_cur.fetchmany()

                if not rows:
                    break

                last_row = rows[len(rows) - 1]

                if isinstance(pk_i, tuple):
                    last_pk = tuple(last_row[i] for i in pk_i)
                else:
                    last_pk = last_row[pk_i]

                svalues_sql, svalues_map = _prepare_many_values_func(
                        'svalue', rows, types)

                del_or_ins_sql = del_or_ins_sql_tpl.format(svalues_sql=svalues_sql)

                sql_params = {
                    'prev_pk': prev_pk,
                    'last_pk': last_pk,
                }
                sql_params.update(svalues_map)

                dst_cur.execute(del_or_ins_sql, sql_params)

                prev_pk = last_pk

        prev_pk = None

        # фаза удаления

        do_del_or_ins_cycle(delete_sql_tpl)

        # удаляем остатки (или же удаляем всю таблицу, если данных не было ни каких)

        dst_cur.execute(
            final_delete_sql,
            {
                'prev_pk': prev_pk,
            }
        )

        # фаза вставки

        do_del_or_ins_cycle(insert_sql_tpl)
