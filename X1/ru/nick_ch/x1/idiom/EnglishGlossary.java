/**
 * This software is free according GNU GENERAL PUBLIC LICENSE and
 * based on the XPg project, developed by KAZAK Solutions. 
 * Research and Development Group of Free Software, 
 * Santiago de Cali Republic of Colombia 2001.
 * Author:
 *          Gustavo Gonz¿lez <xtingray@kazak.com.co>.                   
 * ----------------------------------------------------------------------------
 * Now this software is developing for modern version of PostgreSQL.
 * Author: 
 *          Nick Chadaev <nick_ch58@list.ru>. Moscow, Russia. Single developer.
 *          New stage of developing had been started at 2009-06-16. 
 * ----------------------------------------------------------------------------
 *  CLASS EnglishGlossary @version 1.0   
 *  History:2002/12/11 for spelling and grammar
 *          Grant Kaufmann   - grantsec@sandpit.org
 *          Nick  - 2009-07-16 The item "NOOBJECTS" was added  
 */

package ru.nick_ch.x1.idiom;

import java.util.Hashtable;

public class EnglishGlossary {

  Hashtable glossary;

  EnglishGlossary (){
      glossary = new Hashtable();

      /*** GENERALS ****/
      glossary.put ("INFO","Information");
      glossary.put ("NEWF","New"); 
      glossary.put ("COPY","Copy");
      glossary.put ("PASTE","Paste");
      glossary.put ("NEMO-NEWF","N");
      glossary.put ("NEWM","New");
      glossary.put ("NEMO-NEWM","N");
      glossary.put ("CREATE","Create");
      glossary.put ("NEMO-CREATE","C");
      glossary.put ("ALTER","Alter"); 
      glossary.put ("NEMO-ALTER","A");
      glossary.put ("CANCEL","Cancel");
      glossary.put ("OK","OK");
      glossary.put ("DROP","Drop");
      glossary.put ("NEMO-DROP","r");
      glossary.put ("DUMP","Dump");        
      glossary.put ("NEMO-DUMP","u");
      glossary.put ("DUMPT1","Dumping table(s): ");
      glossary.put ("DUMPT2"," of DB '");
      glossary.put ("DUMPT3","' on file '");
      glossary.put ("YES","Yes");
      glossary.put ("NO","No");
      glossary.put ("IN"," in ");
      glossary.put ("KEY","Key");
      glossary.put ("NICE","Successful Operation");  
      glossary.put ("RES","Result: ");
      glossary.put ("RES2","Results");    
      
      /*** ChooseIdiom ***/
      glossary.put ("TITIDIOM","Your Language");
      glossary.put ("MSGIDIOM","Please select your language.");
      glossary.put ("CHANGE_L","Change Language");
      glossary.put ("NEXT_TIME","Your selection will take effect next time you start this application.");
      glossary.put ("IDIOMSEL","Change predefined language to: ");

      /*** GenericQuestionDialog ***/
      glossary.put ("BOOLEXIT","Exit Confirmation");
      glossary.put ("QUESTEXIT","Do you want to close X1 ?");  // XPg  Nick 2009-11-12
      glossary.put ("MESGEXIT","You are still connected. Are you sure?");
      glossary.put ("BOOLDISC","Disconnect Confirmation");
      glossary.put ("MESGDISC","Do you wish to be disconnect from server");
      glossary.put ("BOOLDELDB","Drop Database Confirmation");
      glossary.put ("NDBS","Unavailable Operation. There are no databases you can drop.");
      glossary.put ("MESGDELDB","Do you want to drop database: ");
      glossary.put ("BOOLDELTB","Drop Table Confirmation");
      glossary.put ("MESGDELTB","Do you want to drop table: ");

      /*** MENU CONNECTION ***/
      glossary.put ("TITCONNEC","Connection to PostgreSQL");
      glossary.put ("CONNEC","Connection");
      glossary.put ("NEMO-CONNEC","C");
      glossary.put ("CONNE2","Connect");
      glossary.put ("NEMO-CONNE2","n");
      glossary.put ("DISCON","Disconnect");
      glossary.put ("NEMO-DISCON","D");
      glossary.put ("EXIT","Exit");
      glossary.put ("NEMO-EXIT","E");
      glossary.put ("DISFROM","Disconnected from"); 

      /*** CONECTION WINDOW - ConnectWin ***/
      glossary.put ("HOST","Host");    
      glossary.put ("USER","User");
      glossary.put ("PASSWD","Password");
      glossary.put ("PORT","Port");
      glossary.put ("CLR","Clear");
      glossary.put ("ALL","All");
      glossary.put ("EMPTY","Sorry, There are empty fields in the form.\nPlease fill them in.");
      glossary.put ("ERROR!","ERROR!");
      glossary.put ("NOCHAR","Sorry, \nSpace is an invalid character.\nPlease, try it again.");
      glossary.put ("NOCHART","Space is not a valid character in a table name.");
      glossary.put ("ISNUM","The Port field has to be a number beetwen 1 and 65000.\nPlease fix this.");
      glossary.put ("DBRESER","Sorry, the database \"template1\" is reserved. If you need create a new database,\ndo it with the command \"createdb\" from the Postgres admin account.");
 
      /*** INFO CONNECT ***/
      glossary.put ("INFOSERVER","Connected to Server: ");
      glossary.put ("VERSION","PostgreSQL Version ");
      glossary.put ("WACCESS","With Access to ");
      glossary.put ("NUMDB"," Database(s)");

      /*** MENU STRUCTURA ***/           // Nick 2009-07-23
      glossary.put ("ST","Structure"); 
      glossary.put ("NEMO-ST","S");   

      /*** MENU DATABASES ***/       
      glossary.put ("DB","Database");         
      glossary.put ("NEMO-DB","D");  

      /*** MENU SCHEMAS ***/       
      glossary.put ("SCH","Schema");         
      glossary.put ("NEMO-SCH","H");  

      /* Now, it will be submenu, Nick 2009-07-23 */
      glossary.put ("NEWDB","New Database");
      glossary.put ("NNACESS","You have no access in 'pg_hba.conf'.");
      glossary.put ("NNCONTACT","Contact to your PostgreSQL Admin for help.");
      glossary.put ("DROPDB","Drop Database");
      glossary.put ("CLSDB","Operation:  Closing Database '");
      glossary.put ("NODB","No Databases");
      glossary.put ("NODBSEL","No Databases Selected");

      /*** MENU SCHEMAS ***/       
      glossary.put ("NEWSCH","New schema");
      glossary.put ("DROPSCH","Drop schema");
      
      /*** CREATE DATABASE ***/
      glossary.put ("QUESTDB","New database, name and comment:");  // "Please enter new database name:"  Nick 2009-07-29
      glossary.put ("OKCREATEDB1","Your new database \"");
      glossary.put ("OKCREATEDB2","has been created successful.");
      glossary.put ("ERRORPOS","PostgreSQL has reported 'next' error:\n");
 
      /*** DROP DATABASE ***/
      glossary.put ("QDROPDB","Please enter name of database to drop");
      glossary.put ("OKDROPDB1","Drop database \"");
      glossary.put ("OKDROPDB2","\" was successful.");

      /*** CREATE SCHEMA ***/
      glossary.put ("QUESTSCH","Please enter new schema name:");
      glossary.put ("OKCREATESCH1","Your new schema \"");
      glossary.put ("OKCREATESCH2","has been created successful.");

      /*** XML ***/
      //
      glossary.put ("XMLT","XRD-export from XML-descriptors catalog");  // Nick 2009-07-23
      glossary.put ("NEMO-XML-T", "x");
      //
      glossary.put ("XMLD","XML-export from XML-descriptors catalog");  // Nick 2009-08-06
      glossary.put ("NEMO-XML-D", "X");

      glossary.put ("XMLI", "Import into XML-descriptors catalog");     
      glossary.put ("NEMO-XMLI", "y");
      //
      glossary.put ( "XMLU", "Update on XML-descriptors catalog");      // Nick 2009-09-04   
      glossary.put ("NEMO-XMLU", "Y");
      // 
      glossary.put ("DUMP_XMLD", "Dump XML-descriptors catalog");
      // 
      glossary.put ("DUMP_ACT",  "Active XML descriptors");
      glossary.put ("DUMP_UACT", "Unactive XML descriptors");
      glossary.put ("DUMP_DEL",  "Deleted XML descriptors");
      //
      glossary.put ("XMLF","XML files");
      glossary.put ("UXMLF","XML descriptor not found");
      //
      glossary.put ("XMLTC", "Choose:" ) ; 
      glossary.put ("XMLTW", "Create absented" ) ;
      //
      glossary.put ("XMLTCRT", "Create XML descriptor" ) ;  // Nick 2009-10-06
      glossary.put ("XMLXRD",  "XML descriptor" ) ;         // Nick 2009-10-08
      glossary.put ("XMLPRT",  "Print" ) ;                  // Nick 2009-10-08
      glossary.put ("XMLACP",  "Accept" ) ;                 // Nick 2009-10-08
      glossary.put ("XMLDSP",  "Display" ) ;                // Nick 2009-10-08
      glossary.put ("XMLSTS",  "Set status" ) ;             // Nick 2009-10-08
      glossary.put ("XMLSYN",  "Synchronize" ) ;            // Nick 2010-04-28
      //
      glossary.put ("XML_ACT",  "Active");    // Nick 2009-10-08
      glossary.put ("XML_UACT", "Unactive");  // Nick 2009-10-08
      glossary.put ("XML_DEL",  "Deleted");   // Nick 2009-10-08

      glossary.put ("XMLCR", "created" ) ; 
      glossary.put ("XMLUP", "updated" ) ;
      
      /*** Unload data ***/
      glossary.put ("UDNF","Data not found");
      glossary.put ("UDSC"," descriptors were unloaded.");
      
      // Nick 2010-04-23 
      glossary.put ( "UUID",      "UUID" );
      glossary.put ( "NEUUID",    "UUIDs arent comparing" );
      glossary.put ( "NENAMET",   "Table names arent comparing" );
      glossary.put ( "NACTNAMET", "Table name isnt actuated" );
      glossary.put ( "CREATED",   "Were created" );
      glossary.put ( "UPDATED",   "Were updated" );
      glossary.put ( "SKIPED",    "Were skipped" );
      //
      glossary.put ( "XMLTCI", "XML descriptors" ) ;
      glossary.put ( "XMLTNI", "new" ) ; 
      glossary.put ( "XMLTBI", "bad" );

      // Nick 2010-04-28
      glossary.put ("XMLIMPAS", "Importing as");
      glossary.put ("IMPOSSTD", "Impossible to update the temporary catalogue");
      glossary.put ("IMPOSCTT", "Impossible to clear temporary tables");
      glossary.put ("IMPOSPD",  "Impossible preparing correctly data");
      glossary.put ("IMPOPPD",  "Impossible to create new records in XML-catalogue");
      glossary.put ("IMPOUPD",  "Impossible to update XML-catalogue");
      glossary.put ("IMPOCSVC", "Impossible to change the columns status of visibility");
      //
      glossary.put ("XMLCLST", "Gathering of metadata has begun") ;

      /*** TABLES ***/       
      glossary.put ("FIELDS","Fields");
      glossary.put ("VFIELDS","Visible Fields");
      glossary.put ("FIELD","Field");      
      glossary.put ("ADDF","Add Field");
      glossary.put ("EDITF","Edit Field");
      glossary.put ("DROPF","Drop Field");
      glossary.put ("STRUC","Structure");
      glossary.put ("INSREC","Insert Record");
      glossary.put ("DELREC","Delete Record");
      glossary.put ("UPDREC","Update Record");
      glossary.put ("TABLE","Table");
      glossary.put ("NEMO-TABLE","T");

      //  Nick 2012-11
      glossary.put ("FNC", "Function");
      glossary.put ("DMN", "Domain");
      glossary.put ("AGR", "Agregate");
      glossary.put ("SEQ", "Sequence");
      glossary.put ("TYP", "Type");
      glossary.put ("CTP", "Composite type");
      glossary.put ("ENM", "Enum type");
      glossary.put ("OPR", "Operator");
      glossary.put ("TRG", "Trigger");
      glossary.put ("RUL", "Rule");
      //  Nick 2012-11
      
      glossary.put ("NEWT","New Table");
      glossary.put ("DROPT","Drop Table");
      glossary.put ("DUMPT","Dump Tables");

      glossary.put ("KEYP","Primary Key");
      glossary.put ("KEYU","Unique Key");
      glossary.put ("KEYI","Index");
      glossary.put ("STRTAB","Table Structure for ");
      glossary.put ("NAME","Name");
      glossary.put ("RNAME","Rename");
      glossary.put ("TYPE","Type");
      glossary.put ("LONGTYPE","Size");
      glossary.put ("NOTNULL","Not Null");
      glossary.put ("DEFAULT","Default");
      glossary.put ("CREATET","Create Table");
      glossary.put ("CREATE","Create");    
      glossary.put ("ADD","Add");
      glossary.put ("CHANGE","Change");
      glossary.put ("REMOVE","Remove");
      glossary.put ("NAMET","Table-Name");
      glossary.put ("PROPTABLE","Table Properties"); 
      glossary.put ("PROPF","Field - Properties"); 
      glossary.put ("TYPE","Type"); 
      glossary.put ("LENGHT","Length");
      glossary.put ("PREC", "Precision");
      glossary.put ("DEFVALUE","Default Value"); 
      glossary.put ("EXPORTAB","Export to File");
      glossary.put ("EXPORTAB1","Export to Catalog");  // Nick 2009-09-03
      glossary.put ("EXPORREP","Export to Report");
      glossary.put ("SELECTDB","Select Database and Table (s):"); 
      glossary.put ("STRONLY","Struct Only");  
      glossary.put ("STRDATA","Struct and Data"); 
      glossary.put ("NAMEF","Field Name"); 
      glossary.put ("EXPORT","Export");
      glossary.put ("IMPORT","Import");
      glossary.put ("ITT","Import to Table");
      glossary.put ("DATA","Data");
      glossary.put ("NTS","No Tables have been selected.\nPlease select at least one from the list.");
      glossary.put ("DFINS","Destination File is not selected.\nPlease choose one.");
      glossary.put ("NTE","Nothing to export.\nPlease select 'Struct Design' or/and 'Records' option.");
      glossary.put ("OWNER","Owner");
      glossary.put ("FOKEY","Foreign Key");
      glossary.put ("FK","Foreign");
      glossary.put ("FKN","Foreign Key Name: ");
      glossary.put ("FTAB","Foreign Table: ");
      glossary.put ("LFI","Local Field: ");
      glossary.put ("RFI","Foreign Field: ");
      glossary.put ("ISKEY","Is Key");
      glossary.put ("OPKEY","Key Options");
      glossary.put ("FORS","Foreign Key Selection");
      glossary.put ("FLIST","Fields List");
      glossary.put ("TNNCH","The table name is missing. Please choose one.");
      glossary.put ("TNIVCH","The table name has invalid characters. Please fix it.");
      glossary.put ("FNIVCH","The field name has invalid characters. Please fix it.");
      glossary.put ("FEMPT","The field name is empty. Please fill it.");
      glossary.put ("EMPTEX","The field name already exists. Please choose another one.");
      glossary.put ("NOFCR","The table has no fields. Please add at least one field. ");
      glossary.put ("NOEXISF","Nonexistent Field");
      glossary.put ("NOEXISF2","The name of the field you want update has not been created. Do you want add it?");

      /*** CREATE TABLE ***/
      glossary.put ("INHE","Inherit");
      glossary.put ("INFT","Inherit from Tables:");
      glossary.put ("CONSFT","Define constraints for the new table:");
      glossary.put ("TNTAB","There are no tables in the Database '");
      glossary.put ("CHECK","Check");
      glossary.put ("CONST","Constraint");
      glossary.put ("DEL","Delete");
      glossary.put ("DELALL","Delete All");     
      glossary.put ("REFER","Reference");
      glossary.put ("NOREG","No Registers");
      glossary.put ("DEF","Definition");
      glossary.put ("CRT", "The table are created. ");
      glossary.put ("VCTS", "\nVisual table constructor is going on.\n" );
      glossary.put ("VCTT", "\nVisual table constructor are terminated." );


      /*** RECORDS ***/
      glossary.put ("INSFORM","Insertion Form");
      glossary.put ("RECS","Records");   
      glossary.put ("DIR","Directory");
      glossary.put ("CHDIR","Choose a Directory");
      glossary.put ("CHDIR1","Choose a directory with initial data");      
      glossary.put ("INTA","in table");    
      glossary.put ("FILTER","Filter");
      glossary.put ("ERRFIL","The text field in the filter's condition is empty.\nPlease fill it or disable it.");
      glossary.put ("LIMIT","Limit");
      glossary.put ("ERRLIM","Type mismatch on parameter");
      glossary.put ("ERRLIM2","of item 'Limit'!\nInteger value is required.");
      glossary.put ("STARTR","Start at row");
      glossary.put ("NUMR","Number of Records in '");
      glossary.put ("LIMUS","Both parameters in the option 'Limit' are unset.\nPlease set a value or disable that filter.");
      glossary.put ("LIM1US","There is one level unset on the option 'Limit'.\nPlease fill it or disable that filter.");
      glossary.put ("MORELIM","Bottom limit is higher than top limit. Please, fix the values.");
      glossary.put ("ERRONRUN","There was an error in the SQL execution: ");

      glossary.put ("NRE","Error: You have NO permission for reading data from ");
      glossary.put ("EFIN","There is at least one empty field in the attribute list.\nPlease, Choose a value for the attribute '");
      glossary.put ("EFIW","There is at least one empty field in the WHERE condition.\nFill it or disable the attribute '");

      glossary.put ("E1","All data in the table '");
      glossary.put ("E2","' will be erased!. Are you sure?");

      glossary.put ("NFSU","No field was selected for update.\nPlease, choose at least one field and set a value for it.");

      glossary.put ("U1","All registers in the table '");
      glossary.put ("U2","' will be affected!. Are you sure?");
      glossary.put ("FINTIV","The value in the filter must be numeric.\nPlease, change it.");
      glossary.put ("IBT","Incompatible boolean value in filter field!\nOnly 'true' or 'false' values are allowed.");
      glossary.put ("NCNNA","Error: The number of Columns in the file is different\n to the number of Fields in the table.");
      glossary.put ("NEXT","Next");
      glossary.put ("INI","Initial");
      glossary.put ("TOTAL","Total");
      glossary.put ("AVER","Average");
      glossary.put ("KSDS","Keep this setting during the session");
      glossary.put ("ALOF","No field selected. Please choose at least one.");     
      glossary.put ("NVE","Sorry... Numeric value expected!");
      glossary.put ("BVE","Sorry... Boolean value expected!");
      glossary.put ("FNN"," is a NOT NULL field. Please set a value for this field.");
      glossary.put ("TFIC","The file is corrupt on line ");

      glossary.put ("ONMEM","On Memory");
      glossary.put ("ONSCR","On Display");
      glossary.put ("FSET","First Page");
      glossary.put ("PSET","Preview Page");
      glossary.put ("NSET","Next Page");
      glossary.put ("LSET","Last Page");
      glossary.put ("PAGE","Page");
      glossary.put ("OF","of");
      glossary.put ("FROM","from");
      glossary.put ("TO","to");

      /*** QUERYS ***/    
      glossary.put ("QUERY","Query");
      glossary.put ("NEMO-QUERY","Q");
      glossary.put ("QUERYS","Queries");   
      glossary.put ("FUNC","Functions");
      glossary.put ("OPEN","Open");
      glossary.put ("NEMO-OPEN","O");
      glossary.put ("SAVE","Save");
      glossary.put ("NEMO-SAVE","S");
      glossary.put ("RUN","Run");
      glossary.put ("NEMO-RUN","R");
      glossary.put ("NEWQ","New Query");
      glossary.put ("OPENQ","Open Query");
      glossary.put ("SAVEQ","Save Query");
      glossary.put ("RUNQ","Run Query");
      glossary.put ("EXPTO","Export to");
      glossary.put ("FILE","File");
      glossary.put ("NEMO-FILE","F");
      glossary.put ("HQ","Hot Queries");
      glossary.put ("NEMO-HQ","H");
      glossary.put ("REP","Report");
      glossary.put ("RFP","Report Files Path:");
      glossary.put ("FNP","Files Name Pattern:");
      glossary.put ("RPP","Records per Page:");
      glossary.put ("FEATURES","Features");
      glossary.put ("REPCSV","CSV Format");
      glossary.put ("SQLF","SQL Files");
      glossary.put ("CPDNG","The 'Cellpadding' field must be a numeric value.\nPlease change it.");
      glossary.put ("CSCNG","The 'Cellspacing' field must be a numeric value.\nPlease change it.");
      //glossary.put ("HRW","The 'Width' field must be a numeric value.\nPlease, change it.");
      //glossary.put ("HRS","The 'Size' field must be a numeric value.\nPlease, change it.");
      glossary.put ("REPCR","Creating Report: ");
      glossary.put ("HCRE","Created with X1 0.1 [http://www.kazak.ws]"); // XPg Nick 2009-11-12
      glossary.put ("OBR","Opening Browser... this may take a little while... please wait...");
      glossary.put ("NFIR","No fields have been included in the report.\nPlease choose at least one.");
      glossary.put ("NEMO-REP","R");
      glossary.put ("NORES","No Results");
      glossary.put ("ICONNEW","/icons/55_New.png");
      glossary.put ("ICONFUNC","/icons/55_Func.png");
      glossary.put ("ICONHQ","/icons/55_HQ.png");
      glossary.put ("ICONOPEN","/icons/55_Open.png");
      glossary.put ("ICONSAVE","/icons/55_Save.png");
      glossary.put ("ICONRUN","/icons/55_Run.png");

      glossary.put ("LOAD","Load");
      glossary.put ("RQOL","Run query on load");
      glossary.put ("QQN","Query Quick Name");
      glossary.put ("EQQN","Sorry, The Query Quick Name is already defined. Choose another one.");
      glossary.put ("CONFRM","Confirmation");
      glossary.put ("DELIT","Are you sure you want to delete it?");
      glossary.put ("DRCONF","Are you sure you want to delete the selected records?");

      glossary.put ("IVIC","Invalid instruction... character ';' missing!");
      glossary.put ("SSQ","You submitted several \"selects\" in your query,\nOnly the first result will be displayed.");
      glossary.put ("DBEMPTY","Database is empty :(");

      /*** REPORTS ***/
      glossary.put ("REPTED","Report Editor");
      glossary.put ("FIELED","Fields Edition");
      glossary.put ("SELALL","Select All");
      glossary.put ("UNSELALL","Unselect All");
      glossary.put ("CLRSEL","Clear Selection");
      glossary.put ("NOFSEL","No Field Selected");
      glossary.put ("SETTIT","Set Title: ");
      glossary.put ("INCRES","Include Result: ");
      glossary.put ("NONE","None");
      glossary.put ("AVERG","Average");
      glossary.put ("LOOK","Appearance");
      glossary.put ("CCBC","Choose Cell Background Color");
      glossary.put ("CCTC","Choose Cell Text Color");
      glossary.put ("CBC","Choose Background Color");
      glossary.put ("CTC","Choose Text Color");
      glossary.put ("IMGF","Image Files");
      glossary.put ("LIMG","Load Image");
      glossary.put ("LFILE","Load File");
      glossary.put ("FTF","From table to file");
      glossary.put ("FFT","From file to table");
      glossary.put ("AFDE","The image file doesn't exist!");
      glossary.put ("NIWC","No image was selected!. Please choose a valid path or disable the option.");
      glossary.put ("PRESTY","Predefined Styles");

      // glossary.put ("VIEW","View"); was been here Nick 2009-07-23

      glossary.put ("CLOSE","Close");
      glossary.put ("REPAPP","Report Apperance");
      glossary.put ("GENSETT","General Settings");
      glossary.put ("HEADER","Header");
      glossary.put ("FOOTER","Footer");
      glossary.put ("DATSETT","Table Settings");
      glossary.put ("TABDIM","Table Dimensions");
      glossary.put ("CELLPAD","Cellpadding");
      glossary.put ("CELLSPA","Cellspacing");
      glossary.put ("UBR","Border");
      glossary.put ("TABLEH","Table Header");
      glossary.put ("STYLE","Style");
      glossary.put ("FCOLOR","Font Color");
      glossary.put ("FSETT","Font Settings");
      glossary.put ("BACKCOLOR","Background Color");
      glossary.put ("CELLS","Cells");
      glossary.put ("REPHSETT","Report Header Settings");
      glossary.put ("REPFSETT","Report Footer Settings");
      glossary.put ("HEADERT","Header Text");
      glossary.put ("FOOTT","Footer Text");
      glossary.put ("TITTEXT","Title Text");
      glossary.put ("DATE","Date");
      glossary.put ("FORMAT","Format");
      glossary.put ("NODATE","No date");
      glossary.put ("DATE0","hour:min day/month/year (i.e. 14:20 - 30/12/1978)");
      glossary.put ("DATE1","day/month/year (i.e. 30/12/1978)");
      glossary.put ("DATE2","month/day/year (i.e. 12/30/1978)");
      glossary.put ("DATE3","Month Day of Year (i.e. July 1 of 1970)");
      glossary.put ("WIMGLOGO","Include Image Logo");
      glossary.put ("BROWSE","Browse");
      glossary.put ("TRYING","Trying");
      glossary.put ("NBFOUND","No browsers found in the system.");
      glossary.put ("SAVECH","Save Changes");
      glossary.put ("RFPEMP","The field \"Report Files Path\" is empty. Please fill it.");
      glossary.put ("FNPEMP","The field \"Files Name Pattern\" is empty. Please fill it.");
      glossary.put ("RPPEMP","The field \"Records per Page\" is empty. Please fill it."); 
      glossary.put ("RPPNUM","The field \"Records per Page\" must be numeric. Please fix it.");

      /*** ADMIN ***/    
      glossary.put ("ADMIN","Admin");     
      glossary.put ("NEMO-ADMIN","d"); 
      glossary.put ("USER","User");
      glossary.put ("NEMO-USER","U");   
      glossary.put ("GROUP","Group");
      glossary.put ("GROUPID","Group ID:");
      glossary.put ("NEMO-GROUP","G");
      glossary.put ("PERMI","Permissions");
      glossary.put ("NEMO-PERMI","P");
      glossary.put ("GRANT","Grant");
      glossary.put ("NEMO-GRANT","n");
      glossary.put ("REVOKE","Revoke");
      glossary.put ("NEMO-REVOKE","R");

      /*** WINDOWS MENSSAGE ***/    
      glossary.put ("UONLINE","X1 - User Online: "); // XPg
      
      /*** HELP ***/
      glossary.put ("HELP","Help");
      glossary.put ("NEMO-HELP","h");    // H  Nick 2009-07-23
      glossary.put ("NEMO-HELP2","l");      
      glossary.put ("ABOUT","About"); 
      glossary.put ("NEMO-ABOUT","A");    

      /*** LOGS ***/
      glossary.put ("LOGMON","Log Monitor");
      glossary.put ("USER ","User ");  
      glossary.put ("VALID"," has valid access to ");
      glossary.put ("REPORT","REPORT:\n");                       
      glossary.put ("DB: ","Database: ");
      glossary.put ("NUMT"," - Number of Tables: ");
      glossary.put ("DISSOF","Disconnected from ");
      glossary.put ("PRESSCL","Click here to scroll the Log Monitor");
      
      /*** TREE ***/
      glossary.put ("DSCNNTD","Disconnected");
      glossary.put ("NOTABLES","No Tables");
      glossary.put ("NOOBJECTS" , "No Objects"); // Nick 2009-07-16      
      glossary.put ("DBSCAN","Database Scan");
      glossary.put ("DYWLOOK","Do you want to look for other databases?");
      glossary.put ("NOREG","No Records");
      glossary.put ("PCDBF","Please choose a database first!");
      glossary.put ("NODBC","Sorry, there are no created tables in the database \"");
      
      /*** PROOF AND SEEK***/
      glossary.put ("LOOKDB","Looking for Databases ...");
      glossary.put ("LOOKDBS","Looking for Databases on server '");
      glossary.put ("EXEC","Executing: \"");      
      glossary.put ("DBON","Databases on ");
      glossary.put ("TRYCONN","Trying to connect to database ");
      glossary.put ("OKACCESS","Access Granted :) \nGetting Tables\n");
      glossary.put ("EXECON","Executing on ");
      glossary.put ("NOACCESS","No Access :( \n");

      /*** PG_KONNECTION ***/
      glossary.put ("NODRIVER","Cannot load the PostgreSQL Driver");
      glossary.put ("CONNTO","Connected to "); 
      glossary.put ("NOPGHBA","No pg_hba.conf entry for your access parameters");
      glossary.put ("BADPASS","Password authentication failed");
      glossary.put ("BADHOST","Unknown Server or Server Unreachable");
      glossary.put ("STRANGE","5 (Strange Error)");
            
      /*** VERSION ***/
      glossary.put ("TITABOUT", "X1 - The PostgreSQL workbench " ); // XPg
      glossary.put ("PGI",      "The PostgreSQL workbench" );
      glossary.put ("NUMVER",   "Version:" );
      glossary.put ("COMP",     "Last Compilation: " );
      glossary.put ("CLTLIB",   "Tested, using a PostgreSQL Server Version 9.1/8.3/7.4.1" );
      glossary.put ("PLATF",    "Platform:  MS Windows, Linux" );
      glossary.put ("AUTORS",   "Developed by:  Chadaev Nikolay. [nick_ch58@list.ru]" );
      
      /*** STRUCTURES ***/
      glossary.put ("TABLESTRUC","Table: ");
      glossary.put ("VEIWSTRUC","View: ");
      glossary.put ("DBOFTABLE"," in DB ");
      glossary.put ("NULL","Null"); 
      glossary.put ("DEFAULT","Default");
      glossary.put ("NOSELECT","No Table Selected");      
      glossary.put ("TITINDEX","Keys");
      glossary.put ("INDEX","Indexes Names");
      glossary.put ("INDEXED","Indexed");
      glossary.put ("INDEXPR","Index Properties");
      glossary.put ("PKEY","Primary");
      glossary.put ("UKEY","Unique");
      glossary.put ("SEQUENCE","Sequences");
      glossary.put ("COMM","Comment");

      /*** ERROR_DIALOG ***/
      glossary.put ("NUMERROR","Error Number ");
      glossary.put ("DETAILS","Details");

      /*** GROUP ***/
      glossary.put ("MODGRP","Alter Group");
      glossary.put ("NAMEGRP","Group Name: ");
      glossary.put ("NOGRP","No Group");
      glossary.put ("MODGR","Alter");
      glossary.put ("CREATEGRP","Create Group");
      glossary.put ("GRPID","GID: ");
      glossary.put ("NNGRP","The group name is missing. Please fill in the name field");
      glossary.put ("INVGRP","The group name contains invalid characters. Please fix it.");
      glossary.put ("INVGID","The GID must be a numeric value. Please fix it.");
      glossary.put ("INVNG","The group 'No Group' is an invalid name for a group.\nPlease choose another one.");
      glossary.put ("NGRPS","Unavailable Operation. There are no created groups.");
      glossary.put ("RMGRP","Drop Group");
      glossary.put ("SELGRP","Select a group: ");
      glossary.put ("VRF","Verify");
      glossary.put ("VLD","Valid");
      glossary.put ("UID","User ID: ");
      glossary.put ("PERM","Permissions");
      glossary.put ("NNUSR","The username is missing.\nPlease fill in the name field.");
      glossary.put ("INVUSR","The username contains invalid characters.\nPlease fix it.");
      glossary.put ("INVUID","The UID must be numeric.\nPlease fix it.");
      glossary.put ("INVPASS","The passwords do not match.\nPlease verify them.");
      glossary.put ("GNE","The Group Name field is empty.\nPlease choose one.");
      glossary.put ("GNIV","The Group Name has invalid characters.\nPlease modify it.");
      glossary.put ("GINN","The GID must be numeric.\nPlease change it.");
      glossary.put ("TNE1","The value in field '");
      // glossary.put ("TNE2","' must be numeric.\nPlease change it.");

      // Nick 2012-11-04
      glossary.put ("TNE100","' must be INTEGER.\nPlease change it.");            // The integer types
      glossary.put ("TNE101","' must be FIXED POINT.\nPlease change it.");        // The fixed point types ( decimal, numeric )
      glossary.put ("TNE102","' must be FLOAT POINT.\nPlease change it.");        // The float point types
      glossary.put ("TNE103","' must be CHAR/VARCHAR/TEXT.\nPlease change it.");  // The char, varchar, text types
      glossary.put ("TNE104","' must be NAME.\nPlease change it.");               // The name type, internal type for the database
      glossary.put ("TNE105","' must be BLOB.\nPlease change it.");               // The blob type
      glossary.put ("TNE106","' must be TIME.\nPlease change it.");               // The data, datatime and interval types
      glossary.put ("TNE107","' must be BOOLEAN.\nPlease change it.");       // The boolean type
      glossary.put ("TNE108","' must be GEOMETRY.\nPlease change it.");           // The geometric types
      glossary.put ("TNE109","' must be CIDR, INET.\nPlease change it.");         // The cidr, inet types
      glossary.put ("TNE110","' must be UUID.\nPlease change it.");               // The UUID types
      glossary.put ("TNE111","' must be BIT, VARBIT.\nPlease change it.");        // The bit, varbit types
      // Nick 2012-11-04      
      
      glossary.put ("SELUSR","Select a user");
      glossary.put ("OPC","Options");

      glossary.put ("INSRT","Insert");
      glossary.put ("UPDT","Update");
      glossary.put ("CCOND","Condition Clause");
      glossary.put ("PRS","Predefined Styles");
      glossary.put ("CHO","Choose One");
      glossary.put ("ADF","Advanced Filter");
      glossary.put ("CUF","Customize Filter");                    
      glossary.put ("LRW","Finish at row: ");
      glossary.put ("DEFVL","Default Value");
      glossary.put ("PERDB","Permissions on DB: ");
      glossary.put ("NOTOW","User is not Table Owner in DB '");
      glossary.put ("PBLIC","Public");
      glossary.put ("CHST","Choose a Table: ");
      glossary.put ("APPL","Apply to");
      glossary.put ("SET","Set");
      glossary.put ("APAT","Apply to all tables");
      glossary.put ("SDT","Select Database and Table(s): ");
      glossary.put ("SDG","Struct Design");
      glossary.put ("FN","FileName: ");
      glossary.put ("SUCSS","Sucessfull!");

     /*** VIEWS,  glossary.put ("VIEW","View"); was added 2009-07-23 Nick  ***/
      
      glossary.put ("VIEW","View");

      glossary.put ("VIEWS","Views");
      glossary.put ("VEXIS","The view '");
      glossary.put ("INVVIE","Invalid name for view!");
      //
      glossary.put ("NEMO-VIEW","v");      // Nick 2009-07-23
      glossary.put ("NEWV","New view");    
      glossary.put ("DROPV","Drop view");
      glossary.put ("DUMPV","Dump view");

      /*** SEQUENCES ***/
      glossary.put ("INCR","Increment");
      glossary.put ("MV","Minimum Value");
      glossary.put ("MXV","Maximum Value");
      glossary.put ("CACH","Cache");
      glossary.put ("CYC","Enable Cycle");
      glossary.put ("SEQEXIS","The sequence '");
      glossary.put ("SEQEXIS2"," already exists!");
      glossary.put ("INVSEQ","Invalid name for sequence!");

      /*** ExportSeparatorField ***/
      glossary.put ("SEPA","Delimiter");
      glossary.put ("SLINE","Delimiter Line");
      glossary.put ("W","Width");
      glossary.put ("SFS","Select the field delimiter");
      glossary.put ("IFSEP","Indicate the field delimiter");
      glossary.put ("SEPNF","Delimiter not found in file.");
      glossary.put ("PD","Predefined: ");
      glossary.put ("CZ","Customize: ");
      glossary.put ("SB","Default (Space Bar)");
      glossary.put ("TAB","Tab");
      glossary.put ("COMMA","Comma (,)");
      glossary.put ("DOT","Dot (.)");
      glossary.put ("COLON","Colon (:)");
      glossary.put ("SCOLON","Semicolon (;)");
      glossary.put ("NNACCESS","You have no access to the new Database from here.\nTo get access, contact your Database Administrator");

      /*** Insert Field ***/
      glossary.put ("FNEMPTY", "The name field value is empty. Please choose one.");
      glossary.put ("INVLENGHT", "The length field value is invalid. Please fix it.");
      glossary.put ("INVDEFAULT", "The default field value is invalid. Please fix it.");
      glossary.put ("INVPREC", "The precision value is invalid. Please fix it.");
      glossary.put ("ADDDEFAULT", "This is NOT NULL field, do you want to set DEFAULT value ?" );

      /*** Warnings  ***/
      glossary.put ("ADV","Warning!");
      glossary.put ("LOTREG","The table '");
      glossary.put ("LOTREG2","' has more than 100 registers. Unstable Operation.");
      glossary.put ("UIMO","Function Nonimplemented Even ;(");
      glossary.put ("OVWR","Do you want to overwrite it?");
      glossary.put ("WDIS","This operation will close ALL the connections to the PostgreSQL server. Are you sure?");
      glossary.put ("INVOP","Invalid Operation. This Database is the main link with the PostgreSQL server.");
      glossary.put ("OIDBC","Unavailable Operation.\nThe only Database that you can drop is the main link with the PostgreSQL server.");
      glossary.put ("DOWSO","PostgreSQL server on '");
      glossary.put ("DOWSO2","' is down. Try to connect later...");
      glossary.put ("EMPTYDB","The database name is missing! Please choose one.");

      /*** SQL Functions Description ***/

      glossary.put ("FDNAME","Function");
      glossary.put ("FDRETURN","Returns");
      glossary.put ("FDDESCR","Description");
      glossary.put ("FDEXAMPLE","Example");

      glossary.put ("FDTILE","SQL Functions");

      glossary.put ("FSQL","SQL");
      glossary.put ("FMATH","Mathematics");
      glossary.put ("FNTR","Basic");
      glossary.put ("FTR","Trigonometry");
      glossary.put ("FSTR","String");
      glossary.put ("FSTR1","SQL92");
      glossary.put ("FSTR2","Others");
      glossary.put ("FDATE","Date/Time");
      glossary.put ("FDATEF","Date Formatting");
      glossary.put ("FGEO","Geometry");
      glossary.put ("FGEO1","Basic");
      glossary.put ("FGEO2","Type Conversion");
      glossary.put ("FGEO3","Upgrade");
      glossary.put ("FIPV4","IP V4");

      glossary.put ("FD1","return first non-NULL value in list");
      glossary.put ("FD2","return NULL if input = value, else input");
      glossary.put ("FD3","return <i>expression</i> for first <i>true</i><br>WHEN clause");
      glossary.put ("FD4","absolute value");
      glossary.put ("FD5","radians to degrees");
      glossary.put ("FD6","raise e to the specified exponent");
      glossary.put ("FD7","natural logarithm");
      glossary.put ("FD8","base 10 logarithm");
      glossary.put ("FD9","fundamental constant");
      glossary.put ("FD10","raise a number to the specified exponent");
      glossary.put ("FD11","degrees to radians");
      glossary.put ("FD12","round to nearest integer");
      glossary.put ("FD13","square root");
      glossary.put ("FD14","cube root");
      glossary.put ("FD15","truncate (towards zero)");
      glossary.put ("FD16","convert integer to floating point");
      glossary.put ("FD17","convert integer to floating point");
      glossary.put ("FD18","convert floating point to integer");
      glossary.put ("FD19","arccosine");
      glossary.put ("FD20","arcsine");
      glossary.put ("FD21","arctangent");
      glossary.put ("FD22","arctangent");
      glossary.put ("FD23","cosine");
      glossary.put ("FD24","cotangent");
      glossary.put ("FD25","sine");
      glossary.put ("FD26","tangent");
      glossary.put ("FD27","length of string");
      glossary.put ("FD28","length of string");
      glossary.put ("FD29","convert string to lower case");
      glossary.put ("FD30","storage length of string");
      glossary.put ("FD31","location of specified substring");
      glossary.put ("FD32","extract specified substring");
      glossary.put ("FD33","trim characters from string");
      glossary.put ("FD34","convert text to uppercase");
      glossary.put ("FD35","convert text to char type");
      glossary.put ("FD36","convert varchar to char type");
      glossary.put ("FD37","first letter of each word to uppercase");
      glossary.put ("FD38","left pad string to specified length");
      glossary.put ("FD39","left trim characters from text");
      glossary.put ("FD40","locate specified substring");
      glossary.put ("FD41","right pad string to specified length");
      glossary.put ("FD42","right trim characters from text");
      glossary.put ("FD43","extract specified substring");
      glossary.put ("FD44","convert char to text type");
      glossary.put ("FD45","convert varchar to text type");
      glossary.put ("FD46","convert character in string");
      glossary.put ("FD47","convert char to varchar type");
      glossary.put ("FD48","convert text to varchar type");
      glossary.put ("FD49","convert to abstime");
      glossary.put ("FD50","preserve months and years");
      glossary.put ("FD51","preserve months and years");
      glossary.put ("FD52","portion of date");
      glossary.put ("FD53","portion of time");
      glossary.put ("FD54","truncate date");
      glossary.put ("FD55","convert to interval");
      glossary.put ("FD56","a finite time?");
      glossary.put ("FD57","a finite time?");
      glossary.put ("FD58","convert to reltime");
      glossary.put ("FD59","convert to timestamp");
      glossary.put ("FD60","convert to timestamp");
      glossary.put ("FD61","convert to string");
      glossary.put ("FD62","convert timestamp to string");
      glossary.put ("FD63","convert int4/int8 to string");
      glossary.put ("FD64","convert float4/float8 to string");
      glossary.put ("FD65","convert numeric to string");
      glossary.put ("FD66","convert string to date");
      glossary.put ("FD67","convert string to timestamp");
      glossary.put ("FD68","convert string to numeric");
      glossary.put ("FD69","area of item");
      glossary.put ("FD70","intersection box");
      glossary.put ("FD71","center of item");
      glossary.put ("FD72","diameter of circle");
      glossary.put ("FD73","vertical size of box");
      glossary.put ("FD74","a closed path?");
      glossary.put ("FD75","an open path?");
      glossary.put ("FD76","length of item");
      glossary.put ("FD77","convert path to closed");
      glossary.put ("FD78","number of points");
      glossary.put ("FD79","convert path to open path");
      glossary.put ("FD80","radius of circle");
      glossary.put ("FD81","horizontal size");
      glossary.put ("FD82","circle to box");
      glossary.put ("FD83","points to box");
      glossary.put ("FD84","polygon to box");
      glossary.put ("FD85","to circle");
      glossary.put ("FD86","point to circle");
      glossary.put ("FD87","box diagonal to lseg");
      glossary.put ("FD88","points to lseg");
      glossary.put ("FD89","polygon to path");
      glossary.put ("FD90","center");
      glossary.put ("FD91","intersection");
      glossary.put ("FD92","center");
      glossary.put ("FD93","12 point polygon");
      glossary.put ("FD94","12-point polygon");
      glossary.put ("FD95","npts polygon");
      glossary.put ("FD96","path to polygon");
      glossary.put ("FD97","test path for pre-v6.1 form");
      glossary.put ("FD98","to pre-v6.1");
      glossary.put ("FD99","to pre-v6.1");
      glossary.put ("FD100","to pre-v6.1");
      glossary.put ("FD101","construct broadcast address as text");
      glossary.put ("FD102","construct broadcast address as text");
      glossary.put ("FD103","extract host address as text");
      glossary.put ("FD104","calculate netmask length");
      glossary.put ("FD105","calculate netmask length");
      glossary.put ("FD106","construct netmask as text");

      glossary.put ("SYNT","Syntax");

      glossary.put ("FDB1","add users to a group or remove users from a group");
      glossary.put ("FDB2","change the definition of a table");
      glossary.put ("FDB3","change a database user account");
      glossary.put ("FDB4","define a new aggregate function");
      glossary.put ("FDB5","define a new constraint trigger");
      glossary.put ("FDB6","create a new database");
      glossary.put ("FDB7","define a new function");
      glossary.put ("FDB8","define a new user group");
      glossary.put ("FDB9","define a new index");
      glossary.put ("FDB10","define a new procedural language");
      glossary.put ("FDB11","define a new operator");
      glossary.put ("FDB12","define a new rewrite rule");
      glossary.put ("FDB13","define a new sequence generator");
      glossary.put ("FDB14","define a new table");
      glossary.put ("FDB15","create a new table from the results of a query");
      glossary.put ("FDB16","define a new trigger");
      glossary.put ("FDB17","define a new data type");
      glossary.put ("FDB18","define a new database user account");
      glossary.put ("FDB19","define a new view");
      glossary.put ("FDB20","delete rows of a table");
      glossary.put ("FDB21","remove a user-defined aggregate function");
      glossary.put ("FDB22","remove a database");
      glossary.put ("FDB23","remove a user-defined function");
      glossary.put ("FDB24","remove a user group");
      glossary.put ("FDB25","remove an index");
      glossary.put ("FDB26","remove a user-defined procedural language");
      glossary.put ("FDB27","remove a user-defined operator");
      glossary.put ("FDB28","remove a rewrite rule");
      glossary.put ("FDB29","remove a sequence");
      glossary.put ("FDB30","remove a table");
      glossary.put ("FDB31","remove a trigger");
      glossary.put ("FDB32","remove a user-defined data type");
      glossary.put ("FDB33","remove a database user account");
      glossary.put ("FDB34","remove a view");
      glossary.put ("FDB35","define access privileges");
      glossary.put ("FDB36","remove access privileges");
      glossary.put ("FDB37","retrieve rows from a table or view");
      glossary.put ("FDB38","update rows of a table");

      glossary.put ("WHERE","Where");
      glossary.put ("CAN","can be:");
      glossary.put ("IS","is:");
      glossary.put ("AND","and");
      glossary.put ("QHIST","Queries History");
      glossary.put ("LOOKDB","Look for others databases");
      glossary.put ("CHKLNK","Check link to Server");
      glossary.put ("CHKSSL","SSL Support");
      glossary.put ("ENABLE","Enabled");
      glossary.put ("DISABLE","Disabled");
      glossary.put ("DSPLY","Display");
      glossary.put ("ADDTXT","Add Text");
      glossary.put ("ADDBLOB","Add BLOB");   // 2012-11-04  Nick 


      /*** MONTHS ***/
      glossary.put ("JANUARY","January");
      glossary.put ("FEBRUARY","February");
      glossary.put ("MARCH","March");
      glossary.put ("APRIL","April");
      glossary.put ("MAY","May");
      glossary.put ("JUNE","June");
      glossary.put ("JULY","July");
      glossary.put ("AUGUST","August");
      glossary.put ("SEPTEMBER","September"); 
      glossary.put ("OCTOBER","October");
      glossary.put ("NOVEMBER","November");
      glossary.put ("DECEMBER","December");

      glossary.put ("DELOK","record deleted"); 
      glossary.put ("DELOKS","records deleted");
      glossary.put ("CRDATA","Include in report:");
      glossary.put ("RDATA","Report Data");
      glossary.put ("ROD","Records on Display");
      glossary.put ("ROM","Records on Memory");
      glossary.put ("ET","Entire Table");

  }

  public Hashtable getGlossary() {
      return glossary;
   } 
}
