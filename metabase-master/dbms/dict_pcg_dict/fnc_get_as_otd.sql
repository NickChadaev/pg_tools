CREATE OR REPLACE FUNCTION fnc_get_as_otd (
  p_id_facility bigint = NULL::bigint
)
RETURNS SETOF integer AS
$body$
      select kd_otd
      from dict.dct_otdels
      where (nm_otd like '%Абонентский пункт%'
          or nm_otd like '%Абонентская служба%')
        and id_facility = p_id_facility
$body$
LANGUAGE 'sql'
STABLE
CALLED ON NULL INPUT
SECURITY INVOKER
PARALLEL UNSAFE
COST 5 ROWS 1000;

COMMENT ON FUNCTION fnc_get_as_otd(p_id_facility bigint)
IS 'Получение АП/АС организации';
