DROP FUNCTION IF EXISTS public.f_check_uuids (p_uuid text);
CREATE OR REPLACE FUNCTION public.f_check_uuid (p_uuid text)
 RETURNS boolean
 AS
   --
   --  Nick 2021-09-17
   --
 $$
    SELECT (((p_uuid ~ '^[a-fA-F0-9]{8}(-[a-fA-F0-9]{4}){4}[a-fA-F0-9]{8}$') AND (p_uuid IS NOT NULL)) 
               OR
            (p_uuid IS NULL)
           );
 $$
   LANGUAGE sql STABLE;

 COMMENT ON FUNCTION public.f_check_uuid (text) IS 'Проверка корректности UUID';
--
--  USE CASE:
--
--     SELECT public.f_check_uuid (gen_random_uuid()::text); 
--            f_check_uuids 
--          ---------------
--                 t
