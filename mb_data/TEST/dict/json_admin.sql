-- FUNCTION: json.admin(character varying, character varying[], character varying[])

-- DROP FUNCTION IF EXISTS json.admin(character varying, character varying[], character varying[]);

CREATE OR REPLACE FUNCTION json.admin(
	query character varying,
	paramnames character varying[],
	paramvalues character varying[])
    RETURNS jsonb
    LANGUAGE 'plpgsql'
    COST 5000
    VOLATILE PARALLEL UNSAFE
    SET search_path=json
AS $BODY$

BEGIN
  return json('admin', 'sql', query, coalesce(paramnames, '{}'::varchar[]), coalesce(paramvalues, '{}'::varchar[]), true);
END;
$BODY$;

ALTER FUNCTION json.admin(character varying, character varying[], character varying[])
    OWNER TO crm;

GRANT EXECUTE ON FUNCTION json.admin(character varying, character varying[], character varying[]) TO clientdb;

GRANT EXECUTE ON FUNCTION json.admin(character varying, character varying[], character varying[]) TO contacts;

GRANT EXECUTE ON FUNCTION json.admin(character varying, character varying[], character varying[]) TO crm;

GRANT EXECUTE ON FUNCTION json.admin(character varying, character varying[], character varying[]) TO metamodel;

GRANT EXECUTE ON FUNCTION json.admin(character varying, character varying[], character varying[]) TO modcomm;

GRANT EXECUTE ON FUNCTION json.admin(character varying, character varying[], character varying[]) TO price;

GRANT EXECUTE ON FUNCTION json.admin(character varying, character varying[], character varying[]) TO report_crm;

GRANT EXECUTE ON FUNCTION json.admin(character varying, character varying[], character varying[]) TO rest;

GRANT EXECUTE ON FUNCTION json.admin(character varying, character varying[], character varying[]) TO sells;

REVOKE ALL ON FUNCTION json.admin(character varying, character varying[], character varying[]) FROM PUBLIC;
