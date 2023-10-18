          SELECT
                s.id_stead                                        
              , s.id_addr_parent                                  
              , s.fias_guid        AS nm_fias_guid                
              , s.parent_fias_guid AS nm_fias_guid_parent         
              , s.nm_parent_obj                                   
              , s.region_code                                     
              
              , s.parent_type_id                                  
              , s.parent_type_name                                
              , s.parent_type_shortname                           
              
              , s.parent_level_id                                 
              , s.parent_level_name                               
              
              , s.stead_num                                        

              , (p.type_param_value -> '8'::text)  AS stead_cadastr_num 
              , (p.type_param_value -> '7'::text)  AS kd_oktmo
              , (p.type_param_value -> '6'::text)  AS kd_okato  
              , (p.type_param_value -> '5'::text)  AS nm_zipcode   
              
              , s.oper_type_id                                     
              , s.oper_type_name                                   
              
           FROM gar_tmp.xxx_adr_stead s  
              
              INNER JOIN gar_tmp.xxx_obj_fias f ON (f.obj_guid = s.fias_guid) 
              LEFT OUTER JOIN gar_tmp.xxx_type_param_value p ON (s.id_stead = p.object_id)              
              
            WHERE (f.id_obj IS NULL) AND (f.type_object = 3) and
               (parent_level_id <> 8);
                         -------------------------------------------------------------------------
-- SELECT COUNT (1) FROM gar_tmp.xxx_adr_stead; -- 295157

--SELECT * FROM gar_tmp_pcg_trans.f_adr_street_get ('gar_tmp', '09f48df8-1dae-4a22-bbc2-944582f8f372'::UUID);            

-SELECT * FROM gar_tmp_pcg_trans.f_adr_street_get('gar_tmp', '57a60584-ca9b-4828-993a-125b215c699f'::uuid);
--   234781|  11372|Молодежная|            38|Молодежная ул.


SELECT * FROM gar_tmp_pcg_trans.f_adr_area_get ('gar_tmp', '2a1b343b-e0b5-4c27-98cc-7ae3e71f027d'::uuid);
 
-- id_area|id_country|nm_area|nm_area_full                                
-- -------+----------+-------+--------------------------------------------
--  208139|       185|Ракета |Дагестан Респ, Махачкала г., Ракета тер. СНТ
 
--------------------------------------------------------------------------
--  Артефакты.   f447f6c0-5d94-4033-b72a-4116bcc08a6b | Акъ-таш     --ПУСТО разбираться

SELECT * FROM gar_tmp_pcg_trans.f_adr_area_get ('gar_tmp', 'f447f6c0-5d94-4033-b72a-4116bcc08a6b'::uuid);
SELECT * FROM gar_tmp_pcg_trans.f_adr_street_get ('gar_tmp', 'f447f6c0-5d94-4033-b72a-4116bcc08a6b'::uuid);
 
