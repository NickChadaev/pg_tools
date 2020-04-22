{ 
  "nso_object":
  {
     "nso_code":"CL_TEST30"                             /*  Код НСО                  */
    ,"nso_name":"Тестовый классификатор, вариант 30"    /*  Наименование НСО         */
    ,"nso_uuid":"606DD9C4-34FF-4929-9038-AC813C8B39D7"  /*  UUID НСО                 */
    ,"parent_nso_code":"CL_RF"                          /*  Код родительского НСО    */
    ,"nso_type_code":"C_NSO_CLASS"                      /*  Тип НСО                  */
    ,"is_group_nso":false                               /*  Признак узлового НСО     */
    ,"date_from":"2018-08-22"                           /*  Дата начала актуальности */
    ,"date_to":"9999-12-31"                             /*  Дата конца актуальности  */
    ,"unique_control":true                              /*  Признак уникальности     */
    ,"view_create":true                                 /*  Создание технического представления */
    , "columns":
      [
        {
         "number_col":"1"             /* Номер колонки */
         ,"act_code":"test_code"      /* Код           */ 
         ,"act_name":"Код"            /* Наименование  */ 
         ,"attr_code":"FC_CODE"       /* Атрибут       */
         ,"default_value":"XXXX"      /* Величина по умолчанию     */
         ,"is_mandatory ":true        /* Обязательность заполнения */
       }
       ,
        {
          "number_col":"2"     
          ,"act_code":"test_name"       
          ,"act_name":"Наименование"       
          ,"attr_code":"FC_NAME"      
          ,"default_value":"xxxxxx"  
          ,"is_mandatory ":true 
        }
      ]
    , "marks_keys":
      [
         "key_type_code":"DEFKEY" /* Тип кода ключа */
        ,"attr_codes":          c /* Массив кодов атрибутов, образующих ключ */
            [
               "test_name"
            ]
         "key_type_code":"AKKEY1" /* Тип кода ключа */
        ,"attr_codes":            /* Массив кодов атрибутов, образующих ключ */
            [
               "test_code"
            ]
      ]
  }
}