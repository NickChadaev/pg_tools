-- SELECT * FROM unnsi.adr_area WHERE (nm_fias_guid = 'cd45ef6f-a597-479c-a5f5-87889e5e87e3');
---------------------------------------------------------------------------------------------
          SELECT count (1)
              , h.parent_level_id
              
           FROM gar_tmp.xxx_adr_house h   
              
              INNER JOIN gar_tmp.xxx_obj_fias f ON (f.obj_guid = h.fias_guid) 
              LEFT OUTER JOIN gar_tmp.xxx_type_param_value p ON (h.id_house = p.object_id)              
              
          WHERE (f.id_obj IS NOT NULL) AND (f.type_object = 2)
          GROUP BY h.parent_level_id ORDER BY 1;

-- 11|7
-- 122|6
-- 86299|8


            ---------------------------------------------------------------------------------------------
          SELECT 
                h.id_house
              , h.id_addr_parent
              , h.fias_guid         AS nm_fias_guid
              , h.parent_fias_guid  AS nm_fias_guid_parent
              , h.nm_parent_obj
              , h.region_code
              --
              , h.parent_type_id
              , h.parent_type_name
              , h.parent_type_shortname
              , h.parent_level_id
              , h.parent_level_name
              , h.parent_short_name
              -- 
              , h.house_num             AS house_num
              --
              , h.add_num1              AS add_num1            
              , h.add_num2              AS add_num2            
              , h.house_type            AS house_type          
              , h.house_type_name       AS house_type_name     
              , h.house_type_shortname  AS house_type_shortname
              --
              , h.add_type1             AS add_type1          
              , h.add_type1_name        AS add_type1_name     
              , h.add_type1_shortname   AS add_type1_shortname
              , h.add_type2             AS add_type2          
              , h.add_type2_name        AS add_type2_name     
              , h.add_type2_shortname   AS add_type2_shortname
                --
               ,(p.type_param_value -> '5'::text) AS nm_zipcode   
               ,(p.type_param_value -> '7'::text) AS kd_oktmo
               ,(p.type_param_value -> '6'::text) AS kd_okato    
              --
              , h.oper_type_id
              , h.oper_type_name
              
           FROM gar_tmp.xxx_adr_house h   
              
              INNER JOIN gar_tmp.xxx_obj_fias f ON (f.obj_guid = h.fias_guid) 
              LEFT OUTER JOIN gar_tmp.xxx_type_param_value p ON (h.id_house = p.object_id)              
              
            WHERE (f.id_obj IS NOT NULL) AND (f.type_object = 2) AND (h.parent_level_id < 8)
                --  (h.parent_fias_guid = 'cd45ef6f-a597-479c-a5f5-87889e5e87e3');
--
SELECT * FROM gar_tmp_pcg_trans.f_adr_area_get ('gar_tmp', 'cd45ef6f-a597-479c-a5f5-87889e5e87e3'::uuid);
SELECT * FROM gar_tmp_pcg_trans.f_adr_area_get ('unnsi', 'cd45ef6f-a597-479c-a5f5-87889e5e87e3'::uuid);


SELECT * FROM gar_tmp.adr_house WHERE (nm_fias_guid IN ('73d022e1-fa7f-4412-b267-02a6ebdfd9eb'
,'a1653f2a-d4fd-43c9-bfc0-04def725938e'
,'81a32a64-1d37-44be-8f56-301aaac1b57a'
,'6a696370-33bc-4a91-a84f-4366a9e0a5ad'
,'a4232a57-8ee2-4aa7-899c-63836b2dea96'
,'78d237b3-4e96-49b0-8278-702070a3272a'
,'5c137769-6907-47b6-8166-7087284850b8'
,'9bf75737-1a7a-44d3-b083-7f684012b849'
,'a83daaa1-e73f-4e88-be10-9b3fd887e383'
,'0bad7bec-d9df-4fd5-a955-b86d36fc0603'
,'fa0470db-bafe-41f5-b29a-dede12b9773f'
,'2d175acf-aa2e-430c-bd28-e13b7c86ced2'
,'cdf8b03b-a79c-48e0-8a9a-0408c1357286'
,'23a31543-e2e2-47cb-a908-0a2bf7262ba5'
,'29b2c3dc-c992-4c8d-b04e-0cc50d74d0c4'
,'02fc09a1-98ff-460c-9ae6-0e8aa425d7ee'
,'5016f16a-2b92-4226-8cba-186162c20448'
,'5366b971-135e-4018-9919-26a0905cff8a'
,'90104754-a930-4e3f-ad83-2d500d7cf334'
,'d6f40c11-64d8-4ef5-839b-37f227abb8ca'
,'8e55b057-f32c-4d14-88e3-40824656c358'
,'bf0324df-6217-4a28-948c-51ba858d741d'
,'b12f6e59-0ed3-47de-8bc6-6a74ecff4bc0'
,'cd57ccec-2f13-40e4-a666-6f68a0c4af83'
,'476d3e09-21b3-4a96-bf92-70d403823d27'
,'8e20840d-3adf-4238-985d-9014697db1db'
,'48170d41-56be-43d4-acfd-9162f3671328'
,'e1581d3d-6cca-422c-8d71-98d3efde749d'
,'81316afb-7c18-4eaf-b91e-a0da6156532b'
,'5e20754b-fc20-4a60-afcd-a6753b1bbad3'
,'15c150dc-c47c-48b9-b571-b88e3b8c145e'
,'d29106b4-a9d3-4547-baf2-b8e6fcaf6d5c'
,'ffb280e8-a903-4fc5-be6c-c6f2db5c32bc'
,'4c93f20e-15b5-4e05-8967-dd85249b680f'
,'8b85264c-cc97-41b7-80eb-f494b100197c'
,'1cca9dd4-07d4-493a-a846-f4b588b270b9'
));       
--
--  2023-11-22  оПЯТЬ ДВАДЦАТЬ ПЯТЬ.
--
SELECT * FROM gar_tmp.adr_area WHERE (nm_fias_guid = 'efbb0998-3d73-4071-9ccb-09a86c293b86'); -- 600080556|185|'Хьарша'|'Дагестан Респ, Акушинский р-н, Нахки с, Хьарша местность'|98|10270|2|0|'82603452101'|'efbb0998-3d73-4071-9ccb-09a86c293b86'
SELECT * FROM unnsi.adr_area WHERE (nm_fias_guid = 'efbb0998-3d73-4071-9ccb-09a86c293b86');   -- 600080556|185|'Хьарша'|'Дагестан Респ, Акушинский р-н, Нахки с, Хьарша местность'|98|10270|2|0|'82603452101'|'efbb0998-3d73-4071-9ccb-09a86c293b86'
--
-- Дома
--
SELECT * FROM unnsi.adr_house WHERE (id_area = 600080556);
SELECT * FROM gar_tmp.adr_house WHERE (id_area = 600080556);
--
SELECT * FROM gar_tmp.adr_area WHERE (nm_fias_guid = 'f2f1d515-8536-4442-b44d-2544c5c39e95'); -- 600080584|185|'Привольный'|'Дагестан Респ, Тарумовский р-н, Юрковка с, Привольный п.'|34|11374|2|0|'82649488101'|'f2f1d515-8536-4442-b44d-2544c5c39e95'
SELECT * FROM unnsi.adr_area WHERE (nm_fias_guid = 'f2f1d515-8536-4442-b44d-2544c5c39e95');   -- 600080584|185|'Привольный'|'Дагестан Респ, Тарумовский р-н, Юрковка с, Привольный п.'|34|11374|2|0|'82649488101'|'f2f1d515-8536-4442-b44d-2544c5c39e95'

 --         