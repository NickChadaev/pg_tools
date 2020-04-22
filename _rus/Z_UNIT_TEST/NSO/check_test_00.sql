--
--  ВЫборочный контроль, сформированных тестами структур НСО
--
db_k=# SELECT * FROM nso_structure.nso_f_object_s_sys('N_CODE_5576.835511715821');
-[ RECORD 1 ]---+-------------------------------------
nso_id          | 16
nso_code        | N_CODE_5576.835511715821
parent_nso_id   | 8
parent_nso_code | SPR_LOCAL
nso_name        | ИМЯ_8827.949646800163
date_create     | 2011-01-01 00:00:00
nso_type_id     | 342
nso_type_code   | C_NSO_SPR_DAY_MESS
nso_type_name   | Предупреждение
nso_release     | 0
nso_uuid        | 4c349b9a-98dc-479c-965c-a2a8ac66bbb0
active_sign     | t
is_group_nso    | f
is_intra_op     | f
is_m_view       | f
unique_check    | f
count_rec       | 0
date_from       | 2011-01-01 00:00:00
date_to         | 9999-12-31 00:00:00
tree_d          | {16}
level_d         | 1
tree_name_d     | ИМЯ_8827.949646800163

-- Заголовка НЕТ
SELECT nso_structure.nso_f_column_head_size_get(16);
SELECT nso_structure.nso_f_column_head_size_get('N_CODE_5576.835511715821');

SELECT nso_structure.nso_f_column_head_size_get('N_CODE_5015.6228804410575'); -- 23

Смотри XLSX-таблицы:
   - 'objects_data-1586945070085.xlsx' -- список объектов, актуальный
   - 'header_data-1586944924402.xlsx'  -- заголовок 'N_CODE_5015.6228804410575'
