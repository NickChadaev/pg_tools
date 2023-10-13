BEGIN;
 SET LOCAL search_path = gar_fias_pcg_load, gar_fias, public;
\timing

 SET plpgsql_check.enable_tracer = OFF;
 SET plpgsql_check.tracer = OFF;
 SET plpgsql_check.tracer_verbosity TO verbose;
 
 SELECT * FROM gar_tmp_pcg_trans.f_adr_area_ins ('gar_tmp', 'gar_tmp', 'gar_tmp'); 

 -- SELECT * FROM gar_tmp.adr_area_hist  WHERE (id_region = 0) AND (date_create >= (now() - INTERVAL '1 DAY'))
 --        ORDER BY date_create DESC;
--
SELECT * FROM gar_tmp.adr_area WHERE ( nm_fias_guid IN (
 '19e29ea6-2bb0-48ba-86e6-aa9d4b88bc14'
,'e6b77740-76ec-4559-b6ec-aecdb910303e'
,'3ad0a2b5-cbf3-496b-a886-6a22f422fcbc'
,'8f7ec767-b484-4be1-a928-f3166745dd99'
,'4091026c-271c-4adf-a3f2-5ca5db3f7bdd'
,'5c02861e-df26-4b11-9e7e-1dd4856e4d31'
,'d2498c26-f6ff-43d4-aa64-49d89c1eeca9'
,'91e63167-7547-4ea1-85ac-8e266f7cd7a8'
,'e5da0543-8b08-4a09-9ff1-ce36ce23cdae'
,'3d3b1572-215b-4242-84e8-742db20e6a8d'
,'7dc22841-e99f-4c93-be21-da579889d779'
,'d33a1599-45d1-4e57-aed6-973c58def43d'
,'b96edc3b-455c-43a8-b163-c5eb573df310'
,'c0856292-889c-4bb9-8141-561f1aee19e3'
,'b52ce704-05b9-4bd5-ac14-5af2ab8c81fa'
,'d951e5b3-a08d-49c8-96b4-3bf3415e832e'
,'cb261099-d15b-42e2-b333-f5c0f98709e0'
,'10545955-a1c6-4d6c-8fdf-858ad88e5e44'
,'2cd50151-d2c0-4b9f-b3fd-3a6734c47cc0'
,'91bb271a-4093-4933-837c-ff8de0c9e511'
,'9a8e9141-6ecd-4dc0-a449-363ce08203f3'
,'e7590fc9-5f6a-408e-a581-86abfacfe101'
,'cb5ee82f-77f6-46f1-8385-01f7cff826ec'
,'ca4b10bd-14fa-48fb-9bce-57c20ef700d6'
));

SELECT * FROM gar_tmp.adr_area_aux;

-- ROLLBACK;
COMMIT;

