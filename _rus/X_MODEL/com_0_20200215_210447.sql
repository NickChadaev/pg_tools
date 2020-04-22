CREATE VIEW v_errors AS SELECT sys_errors.err_id,     sys_errors.err_code,     sys_errors.message_out,     sys_errors.sch_name,     sys_errors.constr_name,         CASE             WHEN ((sys_errors.opr_type)::bpchar = 'i'::bpchar) THEN 'INSERT'::text             WHEN ((sys_errors.opr_type)::bpchar = 'u'::bpchar) THEN 'UPDATE'::text             WHEN ((sys_errors.opr_type)::bpchar = 'd'::bpchar) THEN 'DELETE'::text             ELSE NULL::text         END AS opr_type,     sys_errors.tbl_name,     0 AS qty,     true AS db_engine    FROM sys_errors UNION ALL  SELECT 0 AS err_id,     obj_errors.err_code,     obj_errors.message_out,     obj_errors.sch_name,     ''::character varying AS constr_name,     ''::text AS opr_type,     ''::character varying AS tbl_name,     obj_errors.qty,     false AS db_engine    FROM obj_errors   ORDER BY 2, 4, 5;
