/**
 * This software is free according GNU GENERAL PUBLIC LICENSE and
 * based on the XPg project, developed by KAZAK Solutions. 
 * Research and Development Group of Free Software, 
 * Santiago de Cali Republic of Colombia 2001.
 * Author:
 *          Gustavo GonzАlez <xtingray@kazak.com.co>.                   
 * ----------------------------------------------------------------------------
 * Now this software is developing for modern version of PostgreSQL.
 * Author: 
 *          Nick Chadaev <nick_ch58@list.ru>. Moscow, Russia. Single developer.
 *          New stage of developing had been started at 2009-06-16. 
 * ----------------------------------------------------------------------------
 *  CLASS RussianGlossary @version 2.0   
 *  History: 2009/04/24 Russian glossary - Nick Chadaev - nick_ch58@list.ru
 *           2009-07-16 The item "NOOBJECTS" was added.
 *           2010-04-28 Some items was added.
 *           2012-11-11 Again
 *
 */ 
package ru.nick_ch.x1.idiom;

import java.util.Hashtable;

public class RussianGlossary {

  Hashtable glossary;

  RussianGlossary (){
      glossary = new Hashtable();

      /*** GENERALS ****/
      glossary.put ("INFO", "Информация");
      glossary.put ("NEWF", "Создать");       // Новый  
      glossary.put ("COPY", "Копировать");
      glossary.put ("PASTE","Вставить");
      glossary.put ("NEMO-NEWF","N");
      glossary.put ("NEWM","New");
      glossary.put ("NEMO-NEWM","N");
      glossary.put ("CREATE","Создать");
      glossary.put ("NEMO-CREATE","C");
      glossary.put ("ALTER","Изменить"); 
      glossary.put ("NEMO-ALTER","A");
      glossary.put ("CANCEL","Нет");
      glossary.put ("OK","Да");
      glossary.put ("DROP","Удалить");
      glossary.put ("NEMO-DROP","r");
      glossary.put ("DUMP","Выгрузить");        
      glossary.put ("NEMO-DUMP","u");
      glossary.put ("DUMPT1","Выгрузка таблиц(ы): ");
      glossary.put ("DUMPT2"," из DB '");
      glossary.put ("DUMPT3","' на файле '");
      glossary.put ("YES","Да");
      glossary.put ("NO", "Нет");
      glossary.put ("IN",  " в ");
      glossary.put ("KEY", "Ключ");
      glossary.put ("NICE","Успешная операция");  
      glossary.put ("RES", "Результат: ");
      glossary.put ("RES2","Результат");     /* Результаты */    
      
      /*** ChooseIdiom ***/
      glossary.put ("TITIDIOM", "Ваш язык");
      glossary.put ("MSGIDIOM", "Выберите Ваш язык");
      glossary.put ("CHANGE_L", "Изменить Язык");
      glossary.put ("NEXT_TIME","Ваши изменения будут действительными при повторном старте");
      glossary.put ("IDIOMSEL", "Изменить язык: ");

      /*** GenericQuestionDialog ***/
      glossary.put ("BOOLEXIT","Подтверждение выхода");
      glossary.put ("QUESTEXIT","Вы хотите закрыть программу ?");  // XPg 
      glossary.put ("MESGEXIT","Вы ещё соединены с сервером. Уверенны ?");
      glossary.put ("BOOLDISC","Подтверждение рассоединения");
      glossary.put ("MESGDISC","Вы хотите отсоединиться от сервера ");
      glossary.put ("BOOLDELDB","Подтверждение удаления базы данных");
      glossary.put ("NDBS","Невыполнимая операция. Вы не можете удалить базу данных.");
      glossary.put ("MESGDELDB","Вы хотите удалить базу данных: ");
      glossary.put ("BOOLDELTB","Подтверждение удаления базы данных");
      glossary.put ("MESGDELTB","Вы хотите удалить таблицу: ");

      /*** MENU CONNECTION ***/
      glossary.put ("TITCONNEC","Соединение с PostgreSQL");
      glossary.put ("CONNEC","Соединение");
      glossary.put ("NEMO-CONNEC","C");
      glossary.put ("CONNE2","Соединить");
      glossary.put ("NEMO-CONNE2","n");
      glossary.put ("DISCON","Отсоединить");
      glossary.put ("NEMO-DISCON","D");
      glossary.put ("EXIT","Выход");
      glossary.put ("NEMO-EXIT","E");
      glossary.put ("DISFROM","Отсоединить от"); 

      /*** CONECTION WINDOW - ConnectWin ***/
      glossary.put ("HOST","Хост");    
      glossary.put ("USER","Пользователь");
      glossary.put ("PASSWD","Пароль");
      glossary.put ("PORT","Порт");
      glossary.put ("CLR","Очистить");
      glossary.put ("ALL","Все");
      glossary.put ("EMPTY","Извините, некоторые поля не заполнены.\nЗаполните их.");
      glossary.put ("ERROR!","ОШИБКА!");
      glossary.put ("NOCHAR","Извините, \nПробел - недопустимый символ.\nПожалуста, повторите снова.");
      glossary.put ("NOCHART","Пробел не употребляется в имени таблицы.");
      glossary.put ("ISNUM","Номер порта должен быть в интервале от 1 до 65000.\nИсправьте пожалуста.");
      glossary.put ("DBRESER","Извините, база \"template1\" зарезервирована. Если Вы хотите создать новую базу,\nсделайте это командой \"createdb\" используя права администратора Postgres");
 
      /*** INFO CONNECT ***/
      glossary.put ("INFOSERVER","Соединен с сервером: ");
      glossary.put ("VERSION","PostgreSQL версии ");
      glossary.put ("WACCESS","С доступом к ");
      glossary.put ("NUMDB"," Базе/ам");

      /*** MENU STRUCTURA ***/           // Nick 2009-07-23
      glossary.put ("ST","Структура"); 
      glossary.put ("NEMO-ST","S");   

      /*** MENU DATABASES ***/       
      glossary.put ("DB","База");         
      glossary.put ("NEMO-DB","D");  

      /*** MENU SCHEMAS ***/       
      glossary.put ("SCH","Схема");         
      glossary.put ("NEMO-SCH","H");  

      /* Now, it will be submenu, Nick 2009-07-23 */
      glossary.put ("NEWDB","Новая база");
      glossary.put ("NNACESS","У Вас нет доступа к 'pg_hba.conf'.");
      glossary.put ("NNCONTACT","Соединитесь с Вашим PostgreSQL администратором.");
      glossary.put ("DROPDB","Удалить базу");
      glossary.put ("CLSDB","Операция:  Закрытия базы '");
      glossary.put ("NODB","Нет ни одной базы");
      glossary.put ("NODBSEL","База не выбрана");

      /*** MENU SCHEMAS ***/                 // Nick 2009-07-23
      glossary.put ("NEWSCH","Новая схема");
      glossary.put ("DROPSCH","Удалить схему");

      /*** CREATE DATABASE ***/
      glossary.put ("QUESTDB","Новая база, имя и комментарий:");  // "Введите имя новой базы:"  Nick 2009-07-29
      glossary.put ("OKCREATEDB1","Ваша новая база \"");
      glossary.put ("OKCREATEDB2","создана успешно.");
      glossary.put ("ERRORPOS","PostgreSQL сообщил 'следующую' ошибку:\n");
 
      /*** DROP DATABASE ***/
      glossary.put ("QDROPDB","Введите имя удаляемой базы");
      glossary.put ("OKDROPDB1","Удаление базы \"");
      glossary.put ("OKDROPDB2","\" завершилось успешно.");

      /*** CREATE SCHEMA ***/
      glossary.put ("QUESTSCH","Введите имя новой схемы:");
      glossary.put ("OKCREATESCH1","Ваша новая схема \"");
      glossary.put ("OKCREATESCH2","создана успешно.");

      /*** XML ***/
      glossary.put ("XMLT","XRD-экспорт из каталога информационных ресурсов");  // Nick 2009-07-23
      glossary.put ("NEMO-XML-T", "x");
      //
      glossary.put ("XMLD","XML-экспорт из каталога информационных ресурсов");  // Nick 2009-08-06
      glossary.put ("NEMO-XML-D", "X");
      //
      glossary.put ("XMLI", "Импорт в каталог информацонных ресурсов");         // Nick 2009-09-04
      glossary.put ("NEMO-XMLI", "y");
      //
      glossary.put ( "XMLU", "Обновление каталога информацонных ресурсов");   
      glossary.put ("NEMO-XMLU", "Y");
      // 
      glossary.put ("DUMP_XMLD", "Выгрузить каталог информационных ресурсов");
      glossary.put ("DUMP_ACT",  "Активные дескрипторы");
      glossary.put ("DUMP_UACT", "Неактивные дескрипторы");
      glossary.put ("DUMP_DEL",  "Удалённые дескрипторы");
      //
      glossary.put ("XMLF",  "XML файлы");
      glossary.put ("UXMLF", "XML дескриптор не найден");
      //
      glossary.put ("XMLTC", "Выбрать:" ) ; 
      glossary.put ("XMLTW", "Создать отсутствующие" ) ;
      //
      glossary.put ("XMLTCRT", "Создать XML дескриптор" ) ;  // Nick 2009-10-06
      glossary.put ("XMLXRD",  "XML дескриптор" ) ;          // Nick 2009-10-08
      glossary.put ("XMLPRT",  "Напечатать" ) ;              // Nick 2009-10-08
      glossary.put ("XMLACP",  "Принять" ) ;                 // Nick 2009-10-08
      glossary.put ("XMLDSP",  "Показать" ) ;                // Nick 2009-10-08
      glossary.put ("XMLSTS",  "Установить статус" ) ;       // Nick 2009-10-08
      glossary.put ("XMLSYN",  "Синхронизовать" ) ;          // Nick 2010-04-28
      //
      glossary.put ("XML_ACT",  "Активный");    // Nick 2009-10-08
      glossary.put ("XML_UACT", "Неактивный");  // Nick 2009-10-08
      glossary.put ("XML_DEL",  "Удалённый");   // Nick 2009-10-08

      glossary.put ("XMLCR", "создан" ) ; 
      glossary.put ("XMLUP", "обновлен" ) ;

      /*** Unload data ***/
      glossary.put ("UDNF","Данные не найдены");
      glossary.put ("UDSC"," дескрипторов выгружено.");
      
      // Nick 2010-04-23 
      glossary.put ( "UUID",      "UUID" );
      glossary.put ( "NEUUID",    "Не совпадают UUID" );
      glossary.put ( "NENAMET",   "Не совпадают имена таблиц" );
      glossary.put ( "NACTNAMET", "Не актуальное имя таблицы" );
      glossary.put ( "CREATED",   "Создано" );
   	  glossary.put ( "UPDATED",   "Обновлено" );
   	  glossary.put ( "SKIPED",    "Пропущено" );
      //
   	  glossary.put ( "XMLTCI", "XML дескрипторов" ) ;
      glossary.put ( "XMLTNI", "новых" ) ; 
   	  glossary.put ( "XMLTBI", "дефектных" );
   	  // Nick 2010-04-28  
   	  glossary.put ( "XMLIMPAS", "Импортировать как" );
   	  glossary.put ( "IMPOSSTD", "Невозможно обновить временный каталог" );
   	  glossary.put ( "IMPOSCTT", "Невозможно очистить временные таблицы" );
   	  glossary.put ( "IMPOSPD",  "Невозможно правильно подготовить данные" );
   	  glossary.put ( "IMPOPPD",  "Невозможно создать новые записи в каталоге ИР" );
      glossary.put ( "IMPOUPD",  "Невозможно обновить каталог ИР" );
      glossary.put ( "IMPOCSVC", "Невозможно изменить статус видимости столбца." );
      //
      glossary.put ( "XMLCLST", "Начался сбор метаданных для" );
      
      /*** TABLES ***/       
      glossary.put ("FIELDS","Поля");
      glossary.put ("VFIELDS","Видимые поля");
      glossary.put ("FIELD","Поле");      
      glossary.put ("ADDF","Добавить поле");
      glossary.put ("EDITF","Исправить поле");
      glossary.put ("DROPF","Удалить поле");
      glossary.put ("STRUC","Структура");
      glossary.put ("INSREC","Вставить строку");
      glossary.put ("DELREC","Удалить строку");
      glossary.put ("UPDREC","Обновить строку");
      glossary.put ("TABLE","Таблица");
      glossary.put ("NEMO-TABLE","T");
      
      //  Nick 2012-11
      glossary.put ("FNC", "Функция");
      glossary.put ("DMN", "Домен");
      glossary.put ("AGR", "Агрегат");
      glossary.put ("SEQ", "Последовательность");
      glossary.put ("TYP", "Тип");
      glossary.put ("CTP", "Составной тип");
      glossary.put ("ENM", "Перечисление");
      glossary.put ("OPR", "Оператор");
      glossary.put ("TRG", "Триггер");
      glossary.put ("RUL", "Правило");
      //  Nick 2012-11
      
      glossary.put ("NEWT","Новая таблица");       // For Menu
      glossary.put ("DROPT","Удалить таблицу");
      glossary.put ("DUMPT","Выгрузить таблицу");

      glossary.put ("KEYP","Первичный ключ");
      glossary.put ("KEYU","Уникальный ключ");
      glossary.put ("KEYI","Индекс");
      glossary.put ("STRTAB","Структура таблицы ");
      glossary.put ("NAME","Имя");
      glossary.put ("RNAME","Переименовать");
      glossary.put ("TYPE","Тип");
      glossary.put ("LONGTYPE","Размер");
      glossary.put ("NOTNULL","Not Null");
      glossary.put ("DEFAULT","По умолчанию");
      glossary.put ("CREATET","Создать таблицу");
      glossary.put ("CREATE","Создать");    
      glossary.put ("ADD","Добавить");
      glossary.put ("CHANGE","Изменить");
      glossary.put ("REMOVE","Переместить");
      glossary.put ("NAMET","Имя Таблицы");
      glossary.put ("PROPTABLE","Свойства таблицы"); 
      glossary.put ("PROPF","Поле - Свойства"); 
      glossary.put ("TYPE","Тип"); 
      glossary.put ("LENGHT","Длина");
      glossary.put ("PREC", "Точность");
      glossary.put ("DEFVALUE","Величина по умолчанию"); 
      glossary.put ("EXPORTAB","Экспорт в файл");
      glossary.put ("EXPORTAB1","Экспорт в каталог");  // Nick 2009-09-03
      glossary.put ("EXPORREP","Экспорт в отчёт");
      glossary.put ("SELECTDB","Выбрать Базу и Таблицу (ы):"); 
      glossary.put ("STRONLY","Структура только");  
      glossary.put ("STRDATA","Структура и Данные"); 
      glossary.put ("NAMEF","Имя поля"); 
      glossary.put ("EXPORT","Экспорт");
      glossary.put ("IMPORT","Импорт");
      glossary.put ("ITT","Импорт в таблицу");
      glossary.put ("DATA","Данные");
      glossary.put ("NTS","Таблицы не выбраны.\nВыберите хотя бы одну из списка.");
      glossary.put ("DFINS","Целевой файл не выбран.\nВыберите один.");
      glossary.put ("NTE","Нечего экспортировать.\nВыберите 'Структура' или/и 'Строки'.");
      glossary.put ("OWNER","Владелец");
      glossary.put ("FOKEY","Внешний ключ");
      glossary.put ("FK","Внешний");
      glossary.put ("FKN","Имя внешнего ключа: ");
      glossary.put ("FTAB","Внешняя таблица: ");
      glossary.put ("LFI","Локальное поле: ");
      glossary.put ("RFI","Внешнее поле: ");
      glossary.put ("ISKEY","это Ключ");
      glossary.put ("OPKEY","Опции ключа");
      glossary.put ("FORS","Выбор внешнего ключа");
      glossary.put ("FLIST","Список полей");
      glossary.put ("TNNCH","Имя таблицы опущено. Выберите хотя бы одно.");
      glossary.put ("TNIVCH","Имя таблицы содержит запрещённый символ. Исправьте пожалуста.");
      glossary.put ("FNIVCH","Имя поля содержит запрещённый символ. Исправьте пожалуста.");
      glossary.put ("FEMPT","Пустое имя поля. Исправьте пожалуста.");
      glossary.put ("EMPTEX","Такое имя поля уже есть. Выберите иное.");
      glossary.put ("NOFCR","Таблица не содержит ни одного поля. Добавьте хотя бы одно. ");
      glossary.put ("NOEXISF","Несуществующее поле.");
      glossary.put ("NOEXISF2","Обновляемое поле не существует. Вы хотите создать его?");
      
      /*** CREATE TABLE ***/
      glossary.put ("INHE","Наследование");
      glossary.put ("INFT","Наследование из Таблиц:");
      glossary.put ("CONSFT","Определить ограничения для новой таблицы:");
      glossary.put ("TNTAB","Нет ни одной таблицы в Базе '");
      glossary.put ("CHECK","Проверка");
      glossary.put ("CONST","Ограничения");
      glossary.put ("DEL","Удалить");
      glossary.put ("DELALL","Удалить ВСЁ");     
      glossary.put ("REFER","Ссылка");
      glossary.put ("NOREG","Нет реестров");
      glossary.put ("DEF","Описание");
      glossary.put ("CRT", "Таблица создана.");
      glossary.put ("VCTS", "\nВизуальный конструктор таблиц начал свою работу.\n" );
      glossary.put ("VCTT", "\nЗавершено выполнение визуального конструктора таблиц." );

      
      /*** RECORDS ***/
      glossary.put ("INSFORM","Вставка Форма");
      glossary.put ("RECS","Строки");  /* Строки */   
      glossary.put ("DIR","Каталог");
      glossary.put ("CHDIR","Выбрать Каталог");
      glossary.put ("CHDIR1","Выбрать папку с исходными данными");
      glossary.put ("INTA","в таблице");    
      glossary.put ("FILTER","Фильтр");
      glossary.put ("ERRFIL","Пустое текстовое поле в фильтре.\nЗаполните либо выключите его.");
      glossary.put ("LIMIT","Граница");
      glossary.put ("ERRLIM","Ошибка типа в параметре");
      glossary.put ("ERRLIM2","из пункта 'Граница'!\nНеобходима целая величина.");
      glossary.put ("STARTR","Начало на строке");
      glossary.put ("NUMR","Количество строк в '");
      glossary.put ("LIMUS","Оба параметра в опции 'Граница' не установлены.\nОпределите их, либо выключите фильтр.");
      glossary.put ("LIM1US","Не установлен один уровень в опции 'Граница'.\nОпределите его либо выключите фильтр.");
      glossary.put ("MORELIM","Верхняя граница больше чем нижняя. Исправьте пожалуста.");
      glossary.put ("ERRONRUN","Возникли ошибки при выполнении SQL: ");

      glossary.put ("NRE","Ошибка: Вы не имеете прав для чтения данных из ");
      glossary.put ("EFIN","В списке атрибутов есть одно пустое поле.\nПожалуста, выберите для него значение. '");
      glossary.put ("EFIW","Пустое поле в WHERE условии.\nЗаполните либо выключите его '");

      glossary.put ("E1","Все данные в таблице '");
      glossary.put ("E2","' будут удалены!. Вы согласны ?");

      glossary.put ("NFSU","Не выбрано ни одного поля для обновления.\nВыберите хотя бы одно и установите значение для него.");

      glossary.put ("U1","Все регистры в таблице '");
      glossary.put ("U2","' будут затронуты!. Вы уверены?");
      glossary.put ("FINTIV","Величина в фильтре должна быть цифровой.\nИзмените пожалуста.");
      glossary.put ("IBT","Несовместимая логическая величина в фильтре!\nТолько 'true' либо 'false' являются допустимыми значениями.");
      glossary.put ("NCNNA","Ошибка: Количество столбцов в файле отличается от\n количества столбцов в таблице.");
      glossary.put ("NEXT","Следующий");
      glossary.put ("INI","Начальный");
      glossary.put ("TOTAL","всего");  /* Общий */
      glossary.put ("AVER","Среднее");
      glossary.put ("KSDS","Хранить эти установки в течении сессии");
      glossary.put ("ALOF","Не выбрано ни одного поля. Выберите хотя бы одно.");     
      glossary.put ("NVE","Извините... Ожидалась цифровая величина!");
      glossary.put ("BVE","Извините... Ожидалась логическая величина!");
      glossary.put ("FNN"," является NOT NULL полем. Выберите величину для него.");
      glossary.put ("TFIC","Файл повреждён на строке ");

      glossary.put ("ONMEM","в памяти");
      glossary.put ("ONSCR","На экране");
      glossary.put ("FSET","Первая Страница");
      glossary.put ("PSET","Предыдущая Страница");
      glossary.put ("NSET","Следующая Страница");
      glossary.put ("LSET","Последняя Страница");
      glossary.put ("PAGE","Страница");
      glossary.put ("OF","/");
      glossary.put ("FROM","с");
      glossary.put ("TO","по");
      
      /*** QUERYS ***/    
      glossary.put ("QUERY","Запрос");
      glossary.put ("NEMO-QUERY","Q");
      glossary.put ("QUERYS","Запросы");   
      glossary.put ("FUNC","Функции");
      glossary.put ("OPEN","Открыть");
      glossary.put ("NEMO-OPEN","O");
      glossary.put ("SAVE","Сохранить");
      glossary.put ("NEMO-SAVE","S");
      glossary.put ("RUN","Выполнить");
      glossary.put ("NEMO-RUN","R");
      glossary.put ("NEWQ","Новый Запрос");
      glossary.put ("OPENQ","Открыть Запрос");
      glossary.put ("SAVEQ","Сохранить Запрос");
      glossary.put ("RUNQ","Выполнить Запрос");
      glossary.put ("EXPTO","Экспорт в");
      glossary.put ("FILE","Файл");
      glossary.put ("NEMO-FILE","F");
      glossary.put ("HQ","Любимые запросы");
      glossary.put ("NEMO-HQ","H");
      glossary.put ("REP","Отчёт");
      glossary.put ("RFP","Путь к файлам отчёта:");
      glossary.put ("FNP","Шаблон для имён файлов:");
      glossary.put ("RPP","Строк на странице:");
      glossary.put ("FEATURES","Особенности");
      glossary.put ("REPCSV","CSV формат");
      glossary.put ("SQLF","SQL файлы");
      glossary.put ("CPDNG","Величина в поле 'Cellpadding' должна быть цифровой величиной.\nИзмените её.");
      glossary.put ("CSCNG","Величина в поле 'Cellspacing' должна быть цифровой величиной.\nИзмените её.");
      //glossary.put ("HRW","The 'Width' field must be a numeric value.\nPlease, change it.");
      //glossary.put ("HRS","The 'Size' field must be a numeric value.\nPlease, change it.");
      glossary.put ("REPCR","Создание отчёта: ");
      glossary.put ("HCRE","Создано программой X1 0.1 "); // XPg 0.1 [http://www.kazak.ws]
      glossary.put ("OBR","Открытие броузера... займёт некоторое время... пожалуйста подождите...");
      glossary.put ("NFIR","Ни одного поля не включено в отчёт.\nПожалуйста выберите хотя бы одно.");
      glossary.put ("NEMO-REP","R");
      glossary.put ("NORES","Нет результатов");
      glossary.put ("ICONNEW","/icons/55_NewR.png");    // Nick 2009-07-15 
      glossary.put ("ICONFUNC","/icons/55_FuncR.png");
      glossary.put ("ICONHQ","/icons/55_HQR.png");
      glossary.put ("ICONOPEN","/icons/55_OpenR.png");
      glossary.put ("ICONSAVE","/icons/55_SaveR.png");
      glossary.put ("ICONRUN","/icons/55_RunR.png");

      glossary.put ("LOAD","Загрузка");
      glossary.put ("RQOL","Выполнить запрос после загрузки");
      glossary.put ("QQN","Имя запроса"); // Nick 2013-04-06  
      glossary.put ("EQQN","Извините, Такое имя отчёта уже определено. Выберите иное.");
      glossary.put ("CONFRM","Подтверждение");
      glossary.put ("DELIT","Вы согласны удалить это?");
      glossary.put ("DRCONF","Вы согласны удалить отмеченные строки?");

      glossary.put ("IVIC","Неправильное выражение... символ ';' опущен!");
      glossary.put ("SSQ","Вы определили несколько \"SELECTS\" в вашем запросе,\nБудет отображён только первый результат.");
      glossary.put ("DBEMPTY","Пустая база данных :(");

      /*** REPORTS ***/
      glossary.put ("REPTED","Редактор отчётов");
      glossary.put ("FIELED","Редактирование полей");
      glossary.put ("SELALL","Всё");
      glossary.put ("UNSELALL","Отменить выбор");
      glossary.put ("CLRSEL","Очистить");
      glossary.put ("NOFSEL","Не выбрано ни одного поля");
      glossary.put ("SETTIT","Заголовок: ");
      glossary.put ("INCRES","Включать результат: ");
      glossary.put ("NONE","Нет");
      glossary.put ("AVERG","Среднее");
      glossary.put ("LOOK","Внешний");
      glossary.put ("CCBC","Выберите цвет фона для ячейки ");
      glossary.put ("CCTC","Выберите цвет текста для ячейки");
      glossary.put ("CBC","Выберите цвет фона");
      glossary.put ("CTC","Выбеорите цвет текста");
      glossary.put ("IMGF","Файлы с картинками");
      glossary.put ("LIMG","Загрузить картинку");
      glossary.put ("LFILE","Загрузка файла");
      glossary.put ("FTF","Из таблицы в файл");
      glossary.put ("FFT","Из файла в таблицу");
      glossary.put ("AFDE","Образ файла не существует!");
      glossary.put ("NIWC","Образ не выбран!. Выберите правильный путь либо выключите опцию.");
      glossary.put ("PRESTY","Предопределённые стили");
      
      // here was been  glossary.put ("VIEW","Представление");   Nick 2009-07-23
      
      glossary.put ("CLOSE","Закрыть");
      glossary.put ("REPAPP","Внешний вид отчёта");
      glossary.put ("GENSETT","Общие установки");
      glossary.put ("HEADER","Заголовок");
      glossary.put ("FOOTER","Подножие");
      glossary.put ("DATSETT","Параметры таблицы");
      glossary.put ("TABDIM","Размеры таблицы");
      glossary.put ("CELLPAD","Cellpadding");
      glossary.put ("CELLSPA","Cellspacing");
      glossary.put ("UBR","Окантовка");
      glossary.put ("TABLEH","Заголовок");
      glossary.put ("STYLE","Стиль");
      glossary.put ("FCOLOR","Цвет шрифта");
      glossary.put ("FSETT","Параметры шрифта");
      glossary.put ("BACKCOLOR","Цвет фона");
      glossary.put ("CELLS","Ячейки");
      glossary.put ("REPHSETT","Параметры заголовка отчёта");
      glossary.put ("REPFSETT","Параметры подножия отчёта");
      glossary.put ("HEADERT","Текст заголовка");
      glossary.put ("FOOTT","Текст подножия");
      glossary.put ("TITTEXT","Текст заглавия");
      glossary.put ("DATE","Дата");
      glossary.put ("FORMAT","Формат");
      glossary.put ("NODATE","Нет даты");
      glossary.put ("DATE0","Час:Минута День/Месяц/Год (т.е. 14:20 - 30/12/2008)");
      glossary.put ("DATE1","День/Месяц/Год (т.е. 30/12/2008)");
      glossary.put ("DATE2","Месяц/День/Год (т.е 12/30/2008)");
      glossary.put ("DATE3","Месяц День в Году (т.е Июль 1 2008)");
      glossary.put ("WIMGLOGO","Включить логотип");
      glossary.put ("BROWSE","Обзор");
      glossary.put ("TRYING","Попытка");
      glossary.put ("NBFOUND","Броузер не найден в системе.");
      glossary.put ("SAVECH","Сохранить изменения");
      glossary.put ("RFPEMP","Поле \"Путь к файлам отчёта\" пусто. Заполните его.");
      glossary.put ("FNPEMP","Поле \"Шаблон имён файлов\" пусто. Заполните его.");
      glossary.put ("RPPEMP","Поле \"Строк на странице\" пусто. Заполните его."); 
      glossary.put ("RPPNUM","Поле \"Строк на странице\" должно быть цифровым. Исправьте это.");

      /*** ADMIN ***/    
      glossary.put ("ADMIN","Администратор");     
      glossary.put ("NEMO-ADMIN","d"); 
      glossary.put ("USER","Пользователь");
      glossary.put ("NEMO-USER","U");   
      glossary.put ("GROUP","Группа");
      glossary.put ("GROUPID","ID Группы:");
      glossary.put ("NEMO-GROUP","G");
      glossary.put ("PERMI","Права");
      glossary.put ("NEMO-PERMI","P");
      glossary.put ("GRANT","Выделить");
      glossary.put ("NEMO-GRANT","n");
      glossary.put ("REVOKE","Отменить");
      glossary.put ("NEMO-REVOKE","R");

      /*** WINDOWS MENSSAGE ***/    
      glossary.put ("UONLINE","X1 - Пользователь: "); // XPg  Nick 2009-11-12
      
      /*** HELP ***/
      glossary.put ("HELP","Помощь");
      glossary.put ("NEMO-HELP","h");  // H  Nick 2009-07-23
      glossary.put ("NEMO-HELP2","l");      
      glossary.put ("ABOUT","Об "); 
      glossary.put ("NEMO-ABOUT","A");    

      /*** LOGS ***/
      glossary.put ("LOGMON","Протокол");
      glossary.put ("USER ","Пользователь ");  
      glossary.put ("VALID"," имеет доступ к ");
      glossary.put ("REPORT","ОТЧЁТ:\n");                       
      glossary.put ("DB: ","База: ");
      glossary.put ("NUMT"," - Количество таблиц: ");
      glossary.put ("DISSOF","Отсоединён от ");
      glossary.put ("PRESSCL","Щелкните здесь для просмотра Протокола");
      
      /*** TREE ***/
      glossary.put ("DSCNNTD","Отсоединён");
      glossary.put ("NOTABLES","Нет таблиц");
      glossary.put ("NOOBJECTS" , "Нет объектов"); // Nick 2009-07-16
      glossary.put ("DBSCAN","Обзор базы");
      glossary.put ("DYWLOOK","Хотите ли искать в других базах?");
      glossary.put ("NOREG","Нет строк");
      glossary.put ("PCDBF","Выберите базу сначала!");
      glossary.put ("NODBC","Извините, в базе нет ни одной таблицы \"");
      
      /*** PROOF AND SEEK***/
      glossary.put ("LOOKDB","Поиск в Базах ...");
      glossary.put ("LOOKDBS","Поиск в Базах на сервере '");
      glossary.put ("EXEC","Выполнение: \"");      
      glossary.put ("DBON","Базы данных ");
      glossary.put ("TRYCONN","Попытка соединения с базой ");
      glossary.put ("OKACCESS","Доступ предоставлен :) \nПолучаем список таблиц\n");
      glossary.put ("EXECON","Выполнение на ");
      glossary.put ("NOACCESS","Нет доступа :( \n");

      /*** PG_CONNECTION ***/
      glossary.put ("NODRIVER","Не могу загрузить драйвер PostgreSQL");
      glossary.put ("CONNTO","Подсоединён к "); 
      glossary.put ("NOPGHBA","Не существует точки входа в pg_hba.conf для Ваших параметров");
      glossary.put ("BADPASS","Неправильный пароль");
      glossary.put ("BADHOST","Неизвестный либо недоступный Сервер");
      glossary.put ("STRANGE","5 (Непонятная ошибка)");
            
      /*** VERSION ***/
      glossary.put ("TITABOUT", "X1 - Инструментальное средство для СУБД PostgreSQL" ); // XPg
      glossary.put ("PGI",      "Инструментальное средство для СУБД PostgreSQL" );
      glossary.put ("NUMVER",   "Версия:  " );
      glossary.put ("COMP",     "Дата последней компиляции:  " );
      glossary.put ("CLTLIB",   "Тестировано на PostgreSQL 9.1/8.3/7.4.1" );
      glossary.put ("PLATF",    "Платформа:  MS Windows, Linux" );
      glossary.put ("AUTORS",   "Поддержка и разработка:  Чадаев Николай. [nick_ch58@list.ru]" );
      
      /*** STRUCTURES ***/
      glossary.put ("TABLESTRUC","Таблица: ");
      glossary.put ("VEIWSTRUC","Представление: ");
      glossary.put ("DBOFTABLE"," в БАЗЕ ");
      glossary.put ("NULL","Null"); 
      glossary.put ("DEFAULT","По умолчанию");
      glossary.put ("NOSELECT","Не выбрана таблица");      
      glossary.put ("TITINDEX","Ключи");
      glossary.put ("INDEX","Имена индексов");
      glossary.put ("INDEXED","Индексировано");
      glossary.put ("INDEXPR","Свойства индекса");
      glossary.put ("PKEY","Первичный");
      glossary.put ("UKEY","Уникальный");
      glossary.put ("SEQUENCE","Последовательности");
      glossary.put ("COMM","Комментарий");

      /*** ERROR_DIALOG ***/
      glossary.put ("NUMERROR","Номер ошибки ");
      glossary.put ("DETAILS","Детали");

      /*** GROUP ***/
      glossary.put ("MODGRP","Изменить Группу");
      glossary.put ("NAMEGRP","Имя группы: ");
      glossary.put ("NOGRP","Нет группы");
      glossary.put ("MODGR","Изменить");
      glossary.put ("CREATEGRP","Создать группу");
      glossary.put ("GRPID","GID: ");
      glossary.put ("NNGRP","Имя группы опущено. Пожалуйста заполните его");
      glossary.put ("INVGRP","Имя группы содержит направильный символ. Исправьте это.");
      glossary.put ("INVGID","GID должен быть цифровой величиной. Исправьте это.");
      glossary.put ("INVNG","Группа 'No Group' является неправильным именем.\nВыберите другое имя.");
      glossary.put ("NGRPS","Невозможная операция. Не ни одной созданной группы.");
      glossary.put ("RMGRP","Удалить группу");
      glossary.put ("SELGRP","Выбрать группу: ");
      glossary.put ("VRF","Проверка");
      glossary.put ("VLD","Действительный");
      glossary.put ("UID","ID пользователя: ");
      glossary.put ("PERM","Права");
      glossary.put ("NNUSR","Имя пользователя опущено.\nЗаполните это поле.");
      glossary.put ("INVUSR","Имя пользователя содержит неправильный символ.\nИсправьте это.");
      glossary.put ("INVUID","UID должен быть цифровой величиной.\nИсправьте это.");
      glossary.put ("INVPASS","Неправильный пароль.\nПроверьте его.");
      glossary.put ("GNE","Пустое поле имени группы.\nВыберите хотя бы одно.");
      glossary.put ("GNIV","Имя группы содержит неправильный символ.\nИсправьте это.");
      glossary.put ("GINN","GID должен быть цифровым.\nИсправьте это.");
      glossary.put ("TNE1","Величина в поле '");
      
      // glossary.put ("TNE2","' должен быть цифровым.\nИсправьте это.");
      // Nick 2012-11-04
      glossary.put ("TNE100","' должна соответствовать целому типу.\nИсправьте это.");                 // The integer types
      glossary.put ("TNE101","' должна соответствовать типу с фиксированной точкой.\nИсправьте это."); // The fixed point types ( decimal, numeric )
      glossary.put ("TNE102","' должна соответствовать типу с плавающей точкой.\nИсправьте это.");     // The float point types
      glossary.put ("TNE103","' должна соответствовать символьному типу.\nИсправьте это.");            // The char, varchar, text types
      glossary.put ("TNE104","' должна соответствовать типу NAME.\nИсправьте это.");     // The name type, internal type for the database
      glossary.put ("TNE105","' должна соответствовать типу BLOB.\nИсправьте это.");            // The blob type
      glossary.put ("TNE106","' должна соответствовать типу ВРЕМЯ.\nИсправьте это.");           // The data, datatime and interval types
      glossary.put ("TNE107","' должна соответствовать типу BOOLEAN.\nИсправьте это.");         // The boolean type
      glossary.put ("TNE108","' должна соответствовать геометрическому типу.\nИсправьте это."); // The geometric types
      glossary.put ("TNE109","' должна соответствовать CIDR, INET типам.\nИсправьте это.");     // The cidr, inet types
      glossary.put ("TNE110","' должна соответствовать UUID типу.\nИсправьте это.");            // The UUID types
      glossary.put ("TNE111","' должна соответствовать BIT, VARBIT типам.\nИсправьте это.");    // The bit, varbit types
      // Nick 2012-11-04      
      glossary.put ("SELUSR","Выберите пользователя");
      glossary.put ("OPC","Опции");

      glossary.put ("INSRT","Вставить");
      glossary.put ("UPDT","Обновить");
      glossary.put ("CCOND","Условие");
      glossary.put ("PRS","Предопределённые стили");
      glossary.put ("CHO","Выберите один");
      glossary.put ("ADF","Расширенный фильтр");
      glossary.put ("CUF","Настройка фильтра");                    
      glossary.put ("LRW","Завершение на строке: ");
      glossary.put ("DEFVL","Величина по умолчанию");
      glossary.put ("PERDB","Права для базы: ");
      glossary.put ("NOTOW","Пользователь не является владельцем таблицы в базе '");
      glossary.put ("PBLIC","Общий");
      glossary.put ("CHST","Выбрать таблицу: ");
      glossary.put ("APPL","Применить к");
      glossary.put ("SET","Установить");
      glossary.put ("APAT","Применить ко всем таблицам");
      glossary.put ("SDT","Выбрать базу и таблицы: ");
      glossary.put ("SDG","Создание структуры");
      glossary.put ("FN","Имя файла: ");
      glossary.put ("SUCSS","Успешно!");

      /*** VIEWS,  glossary.put ("VIEW","Представление"); was added 2009-07-23 Nick  ***/
      
      glossary.put ("VIEW","Представление");
      glossary.put ("VIEWS","Представления");
      glossary.put ("VEXIS","Представление '");
      glossary.put ("INVVIE","Неправильное имя представления!");

      glossary.put ("NEMO-VIEW","v");                 // Nick 2009-07-23
      glossary.put ("NEWV","Новое представление");    
      glossary.put ("DROPV","Удалить представление");
      glossary.put ("DUMPV","Выгрузить представление");
      
      /*** SEQUENCES ***/
      glossary.put ("INCR","Приращение");
      glossary.put ("MV","Минимальная Величина");
      glossary.put ("MXV","Максимальная Величина");
      glossary.put ("CACH","Кэш");
      glossary.put ("CYC","Включить цикл");
      glossary.put ("SEQEXIS","Последовательность '");
      glossary.put ("SEQEXIS2"," уже существует!");
      glossary.put ("INVSEQ","Неправильное имя последовательности!");

      /*** ExportSeparatorField ***/
      glossary.put ("SEPA","Разделитель");
      glossary.put ("SLINE","разделяющая строка");
      glossary.put ("W","Ширина");
      glossary.put ("SFS","Выберите разделитель полей");
      glossary.put ("IFSEP","Укажите разделитель полей");
      glossary.put ("SEPNF","Разделитель не найден в файле.");
      glossary.put ("PD","Предопределённый: ");
      glossary.put ("CZ","Настраиваемый: ");
      glossary.put ("SB","По умолчанию (Пробел)");
      glossary.put ("TAB","Табуляция");
      glossary.put ("COMMA","Запятая (,)");
      glossary.put ("DOT","Точка (.)");
      glossary.put ("COLON","Двоеточие (:)");
      glossary.put ("SCOLON","Точка с запятой (;)");
      glossary.put ("NNACCESS","Здесь вам доспупна новая База.\nДля получения прав, свяжитесь с DBA");

      /*** Insert Field ***/
      glossary.put ("FNEMPTY","Поле 'Имя' пустое. Необходимо заполнить.");
      glossary.put ("INVLENGHT","Неправильная длина поля. Исправьте это.");
      glossary.put ("INVDEFAULT","Неправильная величина по умолчанию. Исправьте это.");
      glossary.put ("INVPREC","Неправильное значение точности. Исправьте это.");
      glossary.put ("ADDDEFAULT", "Это NOT NULL поле, хотите ли установить значение по умолчанию ?" );

      /*** Warnings  ***/
      glossary.put ("ADV","Предупреждение!");
      glossary.put ("LOTREG","таблица '");
      glossary.put ("LOTREG2","' имеет более чем 100 регистров. Нестабильная операция.");
      glossary.put ("UIMO","Нереализованная функция ;(");
      glossary.put ("OVWR","Вы согласны переписать это?");
      glossary.put ("WDIS","Эта операция закроет ВСЕ соединения с сервером PostgreSQL. Вы согласныe?");
      glossary.put ("INVOP","Неправильная операция. Эта база соединена сейчас с сервером PostgreSQL.");
      glossary.put ("OIDBC","Невозможная операция.\nБаза данных, которую Вы хотите удалить, соединена с сервером PostgreSQL.");
      glossary.put ("DOWSO","PostgreSQL сервер на '");
      glossary.put ("DOWSO2","' остановлен. Попробуйте соединиться позднее...");
      glossary.put ("EMPTYDB","Имя базы опущено! Выберите хотя бы одно.");

      /*** SQL Functions Description ***/

      glossary.put ("FDNAME","Функция");
      glossary.put ("FDRETURN","Возвращает");
      glossary.put ("FDDESCR","Описание");
      glossary.put ("FDEXAMPLE","Пример");

      glossary.put ("FDTILE","SQL Функции");

      glossary.put ("FSQL",  "SQL");
      glossary.put ("FMATH", "Математические");
      glossary.put ("FNTR",  "Основные");
      glossary.put ("FTR",   "Тригонометрические");
      glossary.put ("FSTR",  "Строковые");
      glossary.put ("FSTR1", "SQL92");
      glossary.put ("FSTR2", "Прочие");
      glossary.put ("FDATE", "Дата/Время");
      glossary.put ("FDATEF","Форматирование даты");
      glossary.put ("FGEO",  "Геометрические");
      glossary.put ("FGEO1", "Основные");
      glossary.put ("FGEO2", "Преобразование типов");
      glossary.put ("FGEO3", "Обновления");
      glossary.put ("FIPV4", "IP V4");

      glossary.put ("FD1","возвращают первую non-NULL величину в списке");
      glossary.put ("FD2","возвращают NULL if input = value, else input");
      glossary.put ("FD3","возвращают <i>expression</i> for first <i>true</i><br>WHEN clause");
      glossary.put ("FD4","абсолютная величина");
      glossary.put ("FD5","радианы в градусы");
      glossary.put ("FD6","возводит e в указанную показатель степени");
      glossary.put ("FD7","натуральный логарифм");
      glossary.put ("FD8","десятичный логарифм");
      glossary.put ("FD9","фундаментальные константы");
      glossary.put ("FD10","возводит число в указанную показатель степени");
      glossary.put ("FD11","градусы в радианы");
      glossary.put ("FD12","округляет до ближайшего целого");
      glossary.put ("FD13","квадратный корень");
      glossary.put ("FD14","кубический корень");
      glossary.put ("FD15","усечение (к нулю)");
      glossary.put ("FD16","преобразование целого к плавающей точке");
      glossary.put ("FD17","преобразование целого к плавающей точке");
      glossary.put ("FD18","преобразование плавающей точки к целому");
      glossary.put ("FD19","арккосинус");
      glossary.put ("FD20","арксинус");
      glossary.put ("FD21","арктангенс");
      glossary.put ("FD22","арккотангенс");
      glossary.put ("FD23","косинус");
      glossary.put ("FD24","котангенс");
      glossary.put ("FD25","синус");
      glossary.put ("FD26","тангенс");
      glossary.put ("FD27","длина строки");
      glossary.put ("FD28","длина строки");
      glossary.put ("FD29","преобразовать строку в верхний регистр");
      glossary.put ("FD30","запомнить длину строки");
      glossary.put ("FD31","выделяет подстроку");
      glossary.put ("FD32","извлекает подстроку");
      glossary.put ("FD33","отсекает символы из строки");
      glossary.put ("FD34","преобразовать текст в верхний регистр");
      glossary.put ("FD35","преобразовать текст в символьный тип");
      glossary.put ("FD36","преобразовать varchar в char");
      glossary.put ("FD37","Первый символ в каждом слове в верхний регистр");
      glossary.put ("FD38","строка дополняется слева до указанной длины");
      glossary.put ("FD39","обрезает символы слева");
      glossary.put ("FD40","находит указанную подстроку");
      glossary.put ("FD41","строка дополняется справа до указанной длины");
      glossary.put ("FD42","обрезает символы справа");
      glossary.put ("FD43","извлекает указанные подстроки");
      glossary.put ("FD44","преобразовывает симольный тип в текст");
      glossary.put ("FD45","преобразовывает varchar в text");
      glossary.put ("FD46","преобразовывает символы в строку");
      glossary.put ("FD47","преобразовывает char в varchar");
      glossary.put ("FD48","преобразовывает text в varchar");
      glossary.put ("FD49","преобразовывает в  abstime");
      glossary.put ("FD50","сохраняет месяцы и года");
      glossary.put ("FD51","сохраняет месяцы и года");
      glossary.put ("FD52","части даты");
      glossary.put ("FD53","части времени");
      glossary.put ("FD54","обрезать дату");
      glossary.put ("FD55","преобразовать в интервал");
      glossary.put ("FD56","конечное время?");
      glossary.put ("FD57","конечное время?");
      glossary.put ("FD58","преобразовать в реальное время");
      glossary.put ("FD59","преобразовать в отметку");
      glossary.put ("FD60","преобразовать в отметку");
      glossary.put ("FD61","преобразовать в строку");
      glossary.put ("FD62","преобразовать отметку в строку");
      glossary.put ("FD63","преобразовать int4/int8 в строку");
      glossary.put ("FD64","преобразовать float4/float8 в строку");
      glossary.put ("FD65","преобразовать число в строку");
      glossary.put ("FD66","преобразовать строку в дату");
      glossary.put ("FD67","преобразовать строку в отметку");
      glossary.put ("FD68","преобразовать строку в число");
      glossary.put ("FD69","area of item");
      glossary.put ("FD70","квадрат с пересечением");
      glossary.put ("FD71","центр");
      glossary.put ("FD72","диаметр окружности");
      glossary.put ("FD73","вертикальный размер прямоугольника");
      glossary.put ("FD74","a closed path?");
      glossary.put ("FD75","an open path?");
      glossary.put ("FD76","длина элемента");
      glossary.put ("FD77","convert path to closed");
      glossary.put ("FD78","количество точек");
      glossary.put ("FD79","convert path to open path");
      glossary.put ("FD80","радиус окружности");
      glossary.put ("FD81","горизонтальный размер");
      glossary.put ("FD82","окружность в прямоугольник");
      glossary.put ("FD83","точки в прямоугольник");
      glossary.put ("FD84","многоугольник в прямоугольник");
      glossary.put ("FD85","в окружность");
      glossary.put ("FD86","точку в окружность");
      glossary.put ("FD87","box diagonal to lseg");
      glossary.put ("FD88","полигон в lseg");
      glossary.put ("FD89","полигон в path");
      glossary.put ("FD90","центр");
      glossary.put ("FD91","пересечение");
      glossary.put ("FD92","центр");
      glossary.put ("FD93","12 point полигон");
      glossary.put ("FD94","12-point полигон");
      glossary.put ("FD95","npts полигон");
      glossary.put ("FD96","path в полигон");
      glossary.put ("FD97","test path for pre-v6.1 form");
      glossary.put ("FD98","в pre-v6.1");
      glossary.put ("FD99","в pre-v6.1");
      glossary.put ("FD100","в pre-v6.1");
      glossary.put ("FD101","создать широковещательный адрес в виде текста");
      glossary.put ("FD102","создать широковещательный адрес в виде текста");
      glossary.put ("FD103","извлечь адрес хоста в виде текста");
      glossary.put ("FD104","вычислить длину маску сети");
      glossary.put ("FD105","вычислить длину маску сети");
      glossary.put ("FD106","создать маску сети в виде текста");

      glossary.put ("SYNT","Синтаксис");

      glossary.put ("FDB1","Добавить пользователя в группу");
      glossary.put ("FDB2","Изменить определение таблицы");
      glossary.put ("FDB3","Изменить профиль пользователя");
      glossary.put ("FDB4","Определить новую агрегатную функцию");
      glossary.put ("FDB5","Определить новый ограничивающий триггер");
      glossary.put ("FDB6","создать новую базу");
      glossary.put ("FDB7","создать новую функцию");
      glossary.put ("FDB8","определить новую группу пользователей");
      glossary.put ("FDB9","определить новый индекс");
      glossary.put ("FDB10","определить новый процедурный язык");
      glossary.put ("FDB11","определить новый оператор");
      glossary.put ("FDB12","определить новое правило переписывания");
      glossary.put ("FDB13","оперелить новую последовательность");
      glossary.put ("FDB14","определить новую таблицу");
      glossary.put ("FDB15","создать новую таблицу из результата запроса");
      glossary.put ("FDB16","определить новый триггер");
      glossary.put ("FDB17","определить новый тип данных");
      glossary.put ("FDB18","определить новый профиль пользователя");
      glossary.put ("FDB19","определить новое представление");
      glossary.put ("FDB20","удалить строку из таблицы");
      glossary.put ("FDB21","удалить агрегатную функцию определённую пользователем");
      glossary.put ("FDB22","удалить базу");
      glossary.put ("FDB23","удалить функции определённые пользователем");
      glossary.put ("FDB24","удалить группу пользователей");
      glossary.put ("FDB25","удалить индекс");
      glossary.put ("FDB26","удалить процедурный язык определённый пользователем");
      glossary.put ("FDB27","удалить оператор, определённый пользователем");
      glossary.put ("FDB28","удалить правило перезаписи");
      glossary.put ("FDB29","удалить последовательность");
      glossary.put ("FDB30","удалить таблицу");
      glossary.put ("FDB31","удалить триггер");
      glossary.put ("FDB32","удалить типы данных, определённые пользователем");
      glossary.put ("FDB33","удалить профиль пользователя");
      glossary.put ("FDB34","удалить представление");
      glossary.put ("FDB35","определить права доступа");
      glossary.put ("FDB36","удалить права доступа");
      glossary.put ("FDB37","вернуть строки из таблицы либо из представления");
      glossary.put ("FDB38","обновить строки в таблице");

      glossary.put ("WHERE","Where");
      glossary.put ("CAN","может быть:");
      glossary.put ("IS","is:");
      glossary.put ("AND","and");
      glossary.put ("QHIST","История запросов");
      glossary.put ("LOOKDB","Искать в других базах");
      glossary.put ("CHKLNK","Проверьте связь с сервером");
      glossary.put ("CHKSSL","Поддержка SSL");
      glossary.put ("ENABLE","Включено");
      glossary.put ("DISABLE","Отключено");
      glossary.put ("DSPLY","Отобразить");
      glossary.put ("ADDTXT","Добавить текст");
      glossary.put ("ADDBLOB","Добавить BLOB");   // 2012-11-04  Nick 

      /*** MONTHS ***/
      glossary.put ("JANUARY",  "Январь");
      glossary.put ("FEBRUARY", "Февраль");
      glossary.put ("MARCH",    "Март");
      glossary.put ("APRIL",    "Апрель");
      glossary.put ("MAY",      "Май");
      glossary.put ("JUNE",     "Июнь");
      glossary.put ("JULY",     "Июль");
      glossary.put ("AUGUST",   "Август");
      glossary.put ("SEPTEMBER","Сентябрь"); 
      glossary.put ("OCTOBER",  "Октябрь");
      glossary.put ("NOVEMBER", "Ноябрь");
      glossary.put ("DECEMBER", "Декабрь");

      glossary.put ("DELOK","запись удалена"); 
      glossary.put ("DELOKS","записей удалено");
      glossary.put ("CRDATA","Включено в отчёт:");
      glossary.put ("RDATA","Отчётные данные");
      glossary.put ("ROD","Записей отображено");
      glossary.put ("ROM","Записей в памяти");
      glossary.put ("ET","Целая таблица");

  }

  public Hashtable getGlossary() {
      return glossary;
   } 
}
