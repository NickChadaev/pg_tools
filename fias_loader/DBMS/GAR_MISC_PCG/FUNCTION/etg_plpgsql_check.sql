-- FUNCTION: public.plpgsql_check()

-- DROP FUNCTION public.plpgsql_check();

CREATE FUNCTION public.plpgsql_check()
    RETURNS event_trigger
    LANGUAGE 'plpgsql'
    COST 1000
    VOLATILE NOT LEAKPROOF SECURITY DEFINER
    SET search_path=public
AS $BODY$
declare
  rec record;
  v_lineno integer;
  v_position integer;
  v_sqlstate text;
  v_message text;
  v_detail text;
  v_hint text;
  v_query text;
begin
  SELECT --(ss.pcf) . functionid::regprocedure AS functionid,
         (ss.pcf) . lineno AS lineno,
         (ss.pcf) . "position" AS "position",
         --(ss.pcf) . statement AS statement,
         --(ss.pcf) . level AS level,
         (ss.pcf) . sqlstate AS sqlstate,
         (ss.pcf) . message AS message,
         (ss.pcf) . detail AS detail,
         (ss.pcf) . hint AS hint,
         (ss.pcf) . query AS query
    INTO v_lineno,
         v_position,
         v_sqlstate,
         v_message,
         v_detail,
         v_hint,
         v_query
    FROM
      (SELECT public.plpgsql_check_function_tb (pg_proc.oid::regprocedure, 0::oid::regclass, true, false, false, false) AS pcf
         FROM pg_event_trigger_ddl_commands() c
         JOIN pg_proc ON pg_proc.oid = c.objid
         WHERE NOT c.in_extension
           AND c.object_type = 'function'
           AND pg_proc.prolang = ((
                                    SELECT lang.oid
                                    FROM pg_language lang
                                    WHERE lang.lanname = 'plpgsql'::name
               ))
           AND pg_proc.pronamespace <> ((
                                          SELECT nsp.oid
                                          FROM pg_namespace nsp
                                          WHERE nsp.nspname = 'pg_catalog'::name
           ))
           AND pg_proc.prorettype <> ((
                                        SELECT typ.oid
                                        FROM pg_type typ
                                        WHERE typ.typname = 'trigger'::name
           ))) ss
   WHERE NOT EXISTS (SELECT FROM plpgsql_errors_ignore
                      WHERE functionid = (ss.pcf).functionid::regprocedure::text
                        AND lineno = (ss.pcf).lineno
                        AND "position" = coalesce((ss.pcf)."position", -1)
                        AND message = (ss.pcf).message)
     AND (ss.pcf).level IN ('error');

  if FOUND then
    raise e'[%] % at line % position %\nQUERY: %', v_sqlstate, v_message, v_lineno, v_position, v_query
    using DETAIL = coalesce(v_detail, ''),
          HINT = coalesce(v_hint, ''),
          ERRCODE = coalesce(v_sqlstate, '00000');
  end if;
end;
$BODY$;

ALTER FUNCTION public.plpgsql_check()
    OWNER TO postgres;
