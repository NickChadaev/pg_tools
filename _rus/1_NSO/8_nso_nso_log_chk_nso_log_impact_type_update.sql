﻿/* ==================================================================== */
/* DBMS name:      PostgreSQL 8                                         */
/* Created on:     10.02.2015 18:25:11                                  */
/* -------------------------------------------------------------------- */
/*  2015-03-19     Дополнения                                           */ 
/* -------------------------------------------------------------------- */
/*  2015-05-29     Переношу в COM  nso_domain_column                    */
/*                 Добавляю краткий код в заголовок НСО                 */
/*  2015_06_16 Модификация nso_blob                                     */
/*  2015_07_04 Index: ak1_nso_column_head   Убрал Nick.                 */
/*  2015-07-27 Убрал всё, что относится к обмену данными.               */ 
/*  2015-09-24 Новое событие, создание данных                           */
/*  2015-10-06 nso_ref.ref_rec_id  null  Nick                           */
/*  2016-05-16 Nick добавлены события экспорта и импорта НСО.           */
/*  ------------------------------------------------------------------  */
/*  2016-07-19 Nick Добавлены события  включения контроля уникальности, */ 
/*                  выключения контроля уникальности.                   */
/* -------------------------------------------------------------------- */
/*  2018-06-28 Nick Добавлено события "создание представления",         */
/*                  "создание материализованного представления".        */
/* -------------------------------------------------------------------- */
/*  2019-07-11 Nick   Создание, удаление, обновление  nso_section       */
/* ==================================================================== */

SET search_path=nso,com,public,pg_catalog;

ALTER TABLE nso.nso_log DROP CONSTRAINT IF EXISTS chk_nso_log_impact_type; 
ALTER TABLE nso.nso_log 
  ADD  CONSTRAINT chk_nso_log_impact_type 
      CHECK ( impact_type = '0'  --  создание НСО                                                                                                                       
           OR impact_type = '1'  --  активация НСО.                                                                                                                    
           OR impact_type = '2'  --  выключение (деактивация) НСО                                                                                          
           OR impact_type = '3'  --  физическое удаление НСО, влечёт за собой событие '5'                                                                                                  
           OR impact_type = '4'  --  обновление данных, запись и ячейки                                                                                                              
           OR impact_type = '5'  --  удаление данных, запись и ячейки
           OR impact_type = 'X'  --  создание новых данных, запись и ячейки. 
              --                                                                                                                 
           OR impact_type = '8'  --  Создание строки в NSO_SECTION
              --                                     
           OR impact_type = '9'  --  создание  элемента заголовка                                                                                         
           OR impact_type = 'A'  --  обновление элемента заголовка (заменили один на другой) КОНТРОЛЬ ТИПОВ.           
           OR impact_type = 'B'  --  удаление элемента   заголовка.  ДАННЫЕ ПРОПАЛИ.                                                         
              --
           OR impact_type = 'C'  --  создание заголовка  ключа                                                                                               
           OR impact_type = 'D'  --  обновление заголовка ключа ЧТО ?                                                                                   
           OR impact_type = 'E'  --  удаление заголовка ключа, при этом УДАЛЯЮТСЯ элементы ключа и выполняется обновление соответсвующих полей в NSO_AS.
              --                               
           OR impact_type = 'F'  --  создание элемента ключа                                                                                                  
           OR impact_type = 'G'  --  обновление элемента ключа МЕНЯЕМ ОДИН НА ДРУГОЙ.                                                     
           OR impact_type = 'H'  --  удаление элемента ключа   
              --
              --  2016-05-16 Nick 
              --
           OR impact_type = 'Y'  --  Экспорт объекта НСО                                                       
           OR impact_type = 'Z'  --  Импорт объекта НСО   
              --
              --  2016-05-16 Nick 
              --
           OR impact_type = 'I'  --  Включение контроля уникальности                                                       
           OR impact_type = 'J'  --  Выключение контроля уникальности   
           --
           OR impact_type = '!'  --  Запись сообщений об ошибках 2016-11-22 Gregory
           --
           OR impact_type = '6'  --  Создание простого представления.                                                                                            
           OR impact_type = '7'  --  Создание материализованного представления                                                                                           
);                    


