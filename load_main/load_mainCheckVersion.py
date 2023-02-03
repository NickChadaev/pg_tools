#!/usr/bin/python
# coding=utf-8
# PROJ: DataBase, service function.
# FILE: load_mainCheckVersion.py
# AUTH: Nick (nick-ch58@yandex.ru))
# DESC: Create script template.
# HIST: 2023-02-03 - created.

import load_mainAdrUpload   as p0
##import load_mainCrtFscripts as p1
import load_mainCrtScripts  as p2
import load_mainCrtYaml     as p3
import load_mainGar         as p4
import load_mainGar_2       as p5
import load_mainGar_4       as p6
import load_mainStage3      as p7
import load_mainStage4      as p8
import load_mainStage6      as p9

from MainProcess import fd_0    as p10
from MainProcess import fd_log  as p11

from GarProcess import stage_3_proc as p20
from GarProcess import stage_3_yaml as p21
from GarProcess import stage_4_proc as p22
from GarProcess import stage_4_yaml as p23
from GarProcess import stage_6_proc as p24
from GarProcess import stage_6_yaml as p25

from GarFias  import load_gar_add_house_type     as p301
from GarFias  import load_gar_addr_obj           as p302
from GarFias  import load_gar_addr_obj_division  as p303
from GarFias  import load_gar_addr_obj_params    as p304
from GarFias  import load_gar_addr_obj_type      as p305
from GarFias  import load_gar_adm_hierarchy      as p306
from GarFias  import load_gar_apartment_type     as p307
from GarFias  import load_gar_apartments         as p308
from GarFias  import load_gar_apartments_params  as p309
from GarFias  import load_gar_carplaces          as p310
from GarFias  import load_gar_carplaces_params   as p311
from GarFias  import load_gar_change_history     as p312
from GarFias  import load_gar_house_type         as p313
from GarFias  import load_gar_houses             as p314
from GarFias  import load_gar_houses_params      as p315
from GarFias  import load_gar_mun_hierarchy      as p316
from GarFias  import load_gar_norm_docs_kinds    as p317
from GarFias  import load_gar_norm_docs_types    as p318
from GarFias  import load_gar_normative_docs     as p319
from GarFias  import load_gar_object_level       as p320
from GarFias  import load_gar_operation_type     as p321
from GarFias  import load_gar_param_type         as p322
from GarFias  import load_gar_reestr_objects     as p323
from GarFias  import load_gar_room_type          as p324
from GarFias  import load_gar_rooms              as p325
from GarFias  import load_gar_rooms_params       as p326
from GarFias  import load_gar_steads             as p327
from GarFias  import load_gar_steads_params      as p328  
                                                       

class ScriptTemplate:

    def __init__ (self):

        self.list_vers = []
        #
        self.list_vers.append ("load_mainAdrUpload                 " + p0.VERSION_STR)
        ##self.list_vers.append ("load_mainCrtFscripts" + p1.VERSION_STR)
        self.list_vers.append ("load_mainCrtScripts                " + p2.VERSION_STR_0)
        self.list_vers.append ("load_mainCrtYaml                   " + p3.VERSION_STR_0)
        self.list_vers.append ("load_mainGar                       " + p4.VERSION_STR)
        self.list_vers.append ("load_mainGar_2                     " + p5.VERSION_STR)
        self.list_vers.append ("load_mainGar_4                     " + p6.VERSION_STR)
        self.list_vers.append ("load_mainStage3                    " + p7.VERSION_STR)
        self.list_vers.append ("load_mainStage4                    " + p8.VERSION_STR)
        self.list_vers.append ("load_mainStage6                    " + p9.VERSION_STR)
        #                                                          
        self.list_vers.append ("MainProcess/fd_0                   " + p10.VERSION_STR)
        self.list_vers.append ("MainProcess/fd_log                 " + p11.VERSION_STR)
        # 
        self.list_vers.append ("GarProcess/stage_3_proc            " + p20.VERSION_STR)
        self.list_vers.append ("GarProcess/stage_3_yaml            " + p21.VERSION_STR)
        self.list_vers.append ("GarProcess/stage_4_proc            " + p22.VERSION_STR)
        self.list_vers.append ("GarProcess/stage_4_yaml            " + p23.VERSION_STR)
        self.list_vers.append ("GarProcess/stage_6_proc            " + p24.VERSION_STR)
        self.list_vers.append ("GarProcess/stage_6_yaml            " + p25.VERSION_STR)
        #
        self.list_vers.append ("GarFias/load_gar_add_house_type    " + p301.VERSION_STR)
        self.list_vers.append ("GarFias/load_gar_addr_obj          " + p302.VERSION_STR)
        self.list_vers.append ("GarFias/load_gar_addr_obj_division " + p303.VERSION_STR)
        self.list_vers.append ("GarFias/load_gar_addr_obj_params   " + p304.VERSION_STR)
        self.list_vers.append ("GarFias/load_gar_addr_obj_type     " + p305.VERSION_STR)
        self.list_vers.append ("GarFias/load_gar_adm_hierarchy     " + p306.VERSION_STR)
        self.list_vers.append ("GarFias/load_gar_apartment_type    " + p307.VERSION_STR)
        self.list_vers.append ("GarFias/load_gar_apartments        " + p308.VERSION_STR)
        self.list_vers.append ("GarFias/load_gar_apartments_params " + p309.VERSION_STR)
        self.list_vers.append ("GarFias/load_gar_carplaces         " + p310.VERSION_STR)
        self.list_vers.append ("GarFias/load_gar_carplaces_params  " + p311.VERSION_STR)
        self.list_vers.append ("GarFias/load_gar_change_history    " + p312.VERSION_STR)
        self.list_vers.append ("GarFias/load_gar_house_type        " + p313.VERSION_STR)
        self.list_vers.append ("GarFias/load_gar_houses            " + p314.VERSION_STR)
        self.list_vers.append ("GarFias/load_gar_houses_params     " + p315.VERSION_STR)
        self.list_vers.append ("GarFias/load_gar_mun_hierarchy     " + p316.VERSION_STR)
        self.list_vers.append ("GarFias/load_gar_norm_docs_kinds   " + p317.VERSION_STR)
        self.list_vers.append ("GarFias/load_gar_norm_docs_types   " + p318.VERSION_STR)
        self.list_vers.append ("GarFias/load_gar_normative_docs    " + p319.VERSION_STR)
        self.list_vers.append ("GarFias/load_gar_object_level      " + p320.VERSION_STR)
        self.list_vers.append ("GarFias/load_gar_operation_type    " + p321.VERSION_STR)
        self.list_vers.append ("GarFias/load_gar_param_type        " + p322.VERSION_STR)
        self.list_vers.append ("GarFias/load_gar_reestr_objects    " + p323.VERSION_STR)
        self.list_vers.append ("GarFias/load_gar_room_type         " + p324.VERSION_STR)
        self.list_vers.append ("GarFias/load_gar_rooms             " + p325.VERSION_STR)
        self.list_vers.append ("GarFias/load_gar_rooms_params      " + p326.VERSION_STR)
        self.list_vers.append ("GarFias/load_gar_steads            " + p327.VERSION_STR)
        self.list_vers.append ("GarFias/load_gar_steads_params     " + p328.VERSION_STR) 

    def get_list ( self ):

        return self.list_vers

if __name__ == '__main__':
    
    for l in ScriptTemplate().get_list():
           print l
           
