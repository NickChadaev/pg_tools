/* --------------------------------------------------------------------------------- 
	Входные параметры:
		p_domain_name t_sysname  -- Имя домена

	Выходные параметры:

------------------------------------------------------------------------------------- */
DROP FUNCTION IF EXISTS utl.com_f_domain_prop_s ( public.t_sysname );
CREATE OR REPLACE FUNCTION utl.com_f_domain_prop_s (
                        p_domain_name  public.t_sysname = NULL::public.t_sysname -- Имя домена
) 
RETURNS TABLE(
	 domain_name   public.t_sysname   -- Имя домена
	,type_len      public.t_int       -- Длина
	,numeric_scale public.t_int       -- Точность
	,base_name     public.t_sysname   -- Имя базового типа
	,category      public.t_code1     -- Категория
)
AS
$$
   -- ================================================================== --
   -- Author: Nick                                                       --
   -- Create date: 2017-05-20                                            --
   -- Description:	Отображение свойств домена/Пользовательского типа    --
   -- ================================================================== --
 DECLARE
        T_MONEY     public.t_sysname := 't_money'; 
        T_DECIMAL   public.t_sysname := 't_decimal';
        cS          public.t_code1   := 'S';

        _type_name  public.t_sysname := utl.com_f_empty_string_to_null (btrim ( lower ( p_domain_name ))); 
        
 BEGIN
	RETURN QUERY
                SELECT t1.typname::public.t_sysname AS domain_name
                     , CASE  
                        WHEN ( t1.typname NOT IN ( T_MONEY, T_DECIMAL ) )
                        THEN
                            CASE  
                               WHEN ((t1.typlen = -1) AND ( NOT t1.typbyval ) AND (t1.typcategory = cS ) AND (t1.typtypmod>0)) 
                               THEN
                                  (t1.typtypmod - 4)::public.t_int 
                               ELSE
                                    t1.typlen::public.t_int 
                            END
                        ELSE
                            t3.numeric_precision::public.t_int             
                        END AS type_len
                       --
                     , CASE  
                        WHEN ( t1.typname IN ( T_MONEY, T_DECIMAL ) )
                        THEN
                             t3.numeric_scale::public.t_int   
                        ELSE
                            0::public.t_int             
                        END AS numerci_scale
                     , t2.typname::public.t_sysname 
                     , t1.typcategory::public.t_code1     
                 FROM pg_type t1 
                              INNER JOIN pg_type t2 ON ( t1.typbasetype = t2.oid )
                              LEFT OUTER JOIN information_schema.domains t3 ON ( t3.domain_name = t1.typname )
                WHERE (( t1.typname ~ _type_name ) AND ( _type_name IS NOT NULL )) OR
                      ((( t1.typname ~ '^t_' ) OR ( t1.typname ~ '_t$' )) AND ( _type_name IS NULL )); 
 END;
$$
   STABLE
   SECURITY INVOKER -- 2015-04-05 Nick
   LANGUAGE plpgsql;
COMMENT ON FUNCTION utl.com_f_domain_prop_s (t_sysname) IS '143: Отображение свойств домена 

		1)  p_domain_name  public.t_sysname = NULL -- Имя домена

	Выходные параметры:
      1)	 domain_name   public.t_sysname   -- Имя домена
      2)	,type_len      public.t_int       -- Длина   -1 означает что тип имеет неограниченную длину
      3)	,numeric_scale public.t_int       -- Точность
      4)	,base_name     public.t_sysname   -- Имя базового типа
      5)	,category      public.t_code1     -- Категория, значения этого атрибута означают:  
                          "A" -  домен типа "массив", его длина всегда неограниченна.
                          "B" -  домен типа "логическое значение".
                          "D" -  домен типа "Дата".                        
                          "I" -  домен типа "Интеренет"                                 
                          "N" -  домен типа "Число"
                          "T" -  домен типа "Время"    
                          "S" -  домен типа "Строка"                                                                                     
                          "U" -  домент комплексного типа (XML, JSON, BLOB), его длина неограничена.                                                           
';
-- ---------------------------------------------------------------------			
-- SELECT * FROM utl.com_f_domain_prop_s('t_code1');
-- SELECT * FROM utl.com_f_domain_prop_s ();
-- SELECT * FROM utl.com_f_domain_prop_s ('');
-- SELECT * FROM utl.com_f_domain_prop_s ('public.result_long_t');
-- -----------------------------------------------------
--  Проверка данных в кодификаторе.
--  SELECT p.* FROM utl.com_f_obj_codifier_s_sys ('C_ATTR_TYPE') x
--        INNER JOIN utl.com_f_domain_prop_s (x.codif_code) p ON TRUE 	
