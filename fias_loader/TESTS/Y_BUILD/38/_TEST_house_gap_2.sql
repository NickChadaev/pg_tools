SELECT * FROM gar_tmp.adr_street WHERE (nm_fias_guid IN ('b4f4095d-d0d1-4014-861b-15e89e2805e6','d8419d82-4527-4d3a-8f87-1ce81667767f'));
-----------------------------------------------------------------------------------------------------------------------------------------
-- 94381|1551|'Молотовая'|38|'Молотовая ул.'|'b4f4095d-d0d1-4014-861b-15e89e2805e6'
-- 94204|3700000066|'Индустриальная'|38|'Индустриальная ул.'|'d8419d82-4527-4d3a-8f87-1ce81667767f'
--
SELECT * FROM gar_tmp_pcg_trans.f_adr_street_get ('gar_tmp', 'b4f4095d-d0d1-4014-861b-15e89e2805e6'::uuid); -- ++
SELECT * FROM gar_tmp_pcg_trans.f_adr_street_get ('gar_tmp', 'd8419d82-4527-4d3a-8f87-1ce81667767f'::uuid); -- ++ 
--
SELECT * FROM gar_tmp.adr_house WHERE (nm_fias_guid IN (
'bafb64c8-5e73-43a3-acb3-33f6382c74aa'
,'e80f6b8b-bee4-4b5d-b98b-81ffb3835adf'
,'65484bb1-06e6-4cdf-9f8d-29d71e2e8855'
,'4a008a4c-1885-47fd-b77c-4423653dc18c'
));
