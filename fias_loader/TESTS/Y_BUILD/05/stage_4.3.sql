BEGIN;
 SET LOCAL search_path = gar_fias_pcg_load, gar_fias, public;

 SET plpgsql_check.enable_tracer = OFF;
 SET plpgsql_check.tracer = OFF;
 SET plpgsql_check.tracer_verbosity TO verbose;
 
\timing

 SELECT * FROM gar_tmp_pcg_trans.f_adr_street_ins ('gar_tmp', 'gar_tmp', 'gar_tmp'); 
 SELECT * FROM gar_tmp.adr_street_hist WHERE (id_region = 0) AND (date_create >= (now() - INTERVAL '1 DAY'))
        ORDER BY date_create;

-- SELECT * FROM gar_tmp.xxx_adr_area WHERE (fias_guid IN (
--  '0cea9d82-4384-46d3-9a22-6d857a14f107'
-- ,'5296e770-88ab-40da-8df7-d5c1ae8f1f08'
-- ,'146d6237-c774-4542-9535-a8d4dd14def8'
-- ,'049bd9f9-ebfa-4e6f-a07b-edb7f43994c6'
-- ,'e874d77b-eaae-4dd1-aae7-9e7a5de350ac'
-- ,'c65e14e4-9a94-4a64-8d71-406418463ce3'
-- ,'012d0b3f-b23f-46ee-86ca-348dfd33ada3'
-- ,'a2a088e3-f36f-4c07-b05b-b8b437f99253'
-- ,'3be41afe-4ae9-4a1b-8e22-9990e07ee7ff'
-- ,'61eaa3be-b7ce-46d3-9a36-482cc401e065'
-- ,'31524a8d-f5df-4a22-9697-1791caf72692'
-- ,'68dd546f-b3b6-423b-a6b5-5f5032e4ce81'
-- ,'8d58ca8c-a65a-4370-a5d4-584f44ac5b73'
-- ,'2daaed0f-4c44-4332-8928-e93120385656'
-- ,'b24a138d-ee8f-42fb-b05a-28ff84f937a2'
-- ,'bf24881d-00cb-460d-9ad5-b1359fac1b42'
-- ,'0dde2371-ae78-441c-a78f-46a510a484ca'
-- ,'e31d0897-8a46-48d3-a213-7ae993c50de9'
-- ,'7248f5e2-99b1-47e2-a5e4-190ea89df774'
-- ,'e8031e05-0550-4045-a587-cd5d9d41478d'
-- ,'bd7e3cec-c71c-4b96-8b67-7eec2651a8b8'
-- ,'c692373c-54e8-4f06-93a9-979b9b9c6f7c'
-- ,'369aee13-6904-43a2-b3ab-15365e1655d1'
-- ,'64198789-a489-45d9-a15b-111f58d9009a'
-- ,'2afcbebe-4123-4cf9-ab08-c98e134ef39a'
-- ,'0da140b2-b46d-4ef1-9174-574377b1e86b'
-- ,'5b8bba72-59a1-4e73-b917-848e7dd36c32'
-- ,'fffd8162-a968-4f92-9a49-d691a8424848'
-- ,'354baa65-215d-4df5-aec0-1b6dbfada0c9'
-- ,'89e7b4b0-aa0c-4977-b631-79709c13a773'
-- ));
  
SELECT * FROM gar_tmp.adr_street ORDER BY id_street DESC LIMIT 255;  
  
-- ROLLBACK;  -- 249
COMMIT;
