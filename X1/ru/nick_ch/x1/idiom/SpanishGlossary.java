/**
 * This software is free according GNU GENERAL PUBLIC LICENSE and
 * based on the XPg project, developed by KAZAK Solutions. 
 * Research and Development Group of Free Software, 
 * Santiago de Cali Republic of Colombia 2001.
 * Author:
 *          Gustavo GonzÀlez <xtingray@kazak.com.co>.                   
 * ----------------------------------------------------------------------------
 * Now this software is developing for modern version of PostgreSQL.
 * Author: 
 *          Nick Chadaev <nick_ch58@list.ru>. Moscow, Russia. Single developer.
 *          New stage of developing had been started at 2009-06-16. 
 * ----------------------------------------------------------------------------
 *  CLASS SpanishGlossary @version 1.0   
 *  History: 2009-07-16 The item "NOOBJECTS" was added.
 *  	                    Chadaev Nick - nick_ch58@list.ru  
 */
 
package ru.nick_ch.x1.idiom;

import java.util.Hashtable;

public class SpanishGlossary {

  Hashtable glossary;

  SpanishGlossary (){
      glossary = new Hashtable();

      /*** GENERALS ****/
      glossary.put ("INFO","Informaciï¿½n");
      glossary.put ("NEWF","Nueva"); 
      glossary.put ("COPY","Copiar");
      glossary.put ("PASTE","Pegar");
      glossary.put ("NEMO-NEWF","N");      
      glossary.put ("NEWM","Nuevo");
      glossary.put ("NEMO-NEWM","N");       
      glossary.put ("CREATE","Crear");
      glossary.put ("NEMO-CREATE","C"); 
      glossary.put ("ALTER","Modificar"); 
      glossary.put ("NEMO-ALTER","M");
      glossary.put ("CANCEL","Cancelar");
      glossary.put ("OK","Aceptar");
      glossary.put ("DROP","Eliminar");
      glossary.put ("NEMO-DROP","r"); // E Nick 2009-07-23
      glossary.put ("DUMP","Guardar Estructura");       
      glossary.put ("NEMO-DUMP","x");
      glossary.put ("DUMPT1","Guardando tabla(s): ");
      glossary.put ("DUMPT2"," de la Base de Datos '");
      glossary.put ("DUMPT3","' en el archivo '");
      glossary.put ("YES","Si");
      glossary.put ("NO","No");   
      glossary.put ("IN"," en ");
      glossary.put ("KEY","Llave");
      glossary.put ("NICE","Operaciï¿½n Exitosa");
      glossary.put ("RES","Resultado: ");
      glossary.put ("RES2","Resultados");

      /*** ChooseIdiom ***/
      glossary.put ("TITIDIOM","Su Idioma");
      glossary.put ("MSGIDIOM","Por favor escoja el idioma que desea.");
      glossary.put ("CHANGE_L","Cambiar Idioma");
      glossary.put ("NEXT_TIME","Su elecciï¿½n ha sido registrada.\nLos cambios tendrï¿½n efecto la prï¿½xima vez que reinicie la aplicaciï¿½n.");
      glossary.put ("IDIOMSEL","Cambio de Idioma predeterminado a: ");

      /*** GenericQuestionDialog ***/
      glossary.put ("BOOLEXIT","Confirmaciï¿½n de Salida");
      glossary.put ("QUESTEXIT","Desea cerrar X1 ?");  // XPg
      glossary.put ("MESGEXIT","Usted aï¿½n estï¿½ conectado. ï¿½Estï¿½ seguro?");
      glossary.put ("BOOLDISC","Confirmaciï¿½n de Desconexiï¿½n");
      glossary.put ("MESGDISC","ï¿½Desea desconectarse del servidor ");         
      glossary.put ("BOOLDELDB","Confirmaciï¿½n para Eliminar Base de Datos");
      glossary.put ("NDBS","Operaciï¿½n Invï¿½lida . No existen bases de datos que usted pueda eliminar.");
      glossary.put ("MESGDELDB","ï¿½Desea eliminar la base de datos: ");
      glossary.put ("BOOLDELTB","Confirmaciï¿½n Destruir Tabla");
      glossary.put ("MESGDELTB","ï¿½Desea eliminar la tabla: ");

      /*** MENU CONNECTION ***/
      glossary.put ("TITCONNEC","Conectando a PostgreSQL");
      glossary.put ("CONNEC","Conexiï¿½n");
      glossary.put ("NEMO-CONNEC","C");      
      glossary.put ("CONNE2","Conectar");
      glossary.put ("NEMO-CONNE2","n");      
      glossary.put ("DISCON","Desconectar");
      glossary.put ("NEMO-DISCON","D");
      glossary.put ("EXIT","Salir");
      glossary.put ("NEMO-EXIT","E");  // S - Nick      
      glossary.put ("DISFROM","Desconectar de:"); 

      /*** CONECTION WINDOW ***/
      glossary.put ("HOST","Servidor");
      glossary.put ("USER","Usuario");
      glossary.put ("PASSWD","Clave");
      glossary.put ("PORT","Puerto");
      glossary.put ("CLR","Limpiar");
      glossary.put ("ALL","Todo");
      glossary.put ("EMPTY","Hay campos vacï¿½os en la forma.\nPor favor, llï¿½nelos.");
      glossary.put ("ERROR!","ERROR!");
      glossary.put ("NOCHAR","El caracter espacio es invï¿½lido dentro de los campos.\nPor favor, intï¿½ntelo de nuevo.");
      glossary.put ("NOCHART","El caracter espacio es invï¿½lido como parte del nombre de una tabla.");
      glossary.put ("ISNUM","El campo Port debe ser un nï¿½mero entre 1 y 65000.\nPor favor, modifique el valor.");
      glossary.put ("DBRESER","La base de datos \"template1\" es reservada. Si requiere crear una nueva base de datos,\npuede hacerlo ejecutando el comando \"createdb\" desde la cuenta del usuario postgres.");
  
      /*** INFO CONNECT ***/
      glossary.put ("INFOSERVER","Conectado al Servidor: ");
      glossary.put ("VERSION","PostgreSQL Versiï¿½n ");
      glossary.put ("WACCESS","Con Acceso a ");
      glossary.put ("NUMDB"," Base(s) de Datos");

      /*** MENU STRUCTURA ***/           // Nick 2009-07-23
      glossary.put ("ST","Estructura"); 
      glossary.put ("NEMO-ST","S");   

      /*** MENU DATABASES ***/       
      glossary.put ("DB","Basa de datos");         
      glossary.put ("NEMO-DB","D");  

      /*** MENU SCHEMAS ***/       
      glossary.put ("SCH","Esquema");         
      glossary.put ("NEMO-SCH","H");  

      /* Now, it will be submenu, Nick 2009-07-23 */
      glossary.put ("NEWDB","Nueva BD");
      glossary.put ("NNACESS","Pero no hay acceso para ella en el archivo 'pg_hba.conf'.");
      glossary.put ("NNCONTACT","Para ayuda, contacte a su Administrador Postgres.");
      glossary.put ("DROPDB","Eliminar BD");
      glossary.put ("CLSDB","Operaciï¿½n:  Cerrando Base de Datos '");
      glossary.put ("NODB","Sin Bases de Datos");
      glossary.put ("NODBSEL","Base de Datos No Seleccionada");

      /*** MENU SCHEMAS ***/       
      glossary.put ("NEWSCH","Nueva esquema");
      glossary.put ("DROPSCH","Eliminar esquema");
      
      /*** CREATE DATABASE ***/
      glossary.put ("QUESTDB","Digite el nombre de la base de datos:");
      glossary.put ("QUESTDB","La base de datos, el nombre y el comentario:");  
      // "Digite el nombre de la base de datos:"  Nick 2009-07-29
      
      glossary.put ("OKCREATEDB1","La base de datos \"");       
      glossary.put ("OKCREATEDB2","ha sido creada satisfactoriamente.");
      glossary.put ("ERRORPOS","Postgres ha reportado el siguiente error:\n");
      
      /*** DROP DATABASE ***/
      glossary.put ("QDROPDB","Seleccione la base de datos:");
      glossary.put ("OKDROPDB1","La eliminaciï¿½n de la base de datos \"");   
      glossary.put ("OKDROPDB2","\" fue exitosa.");

      /*** CREATE SCHEMA ***/
      glossary.put ("QUESTSCH","Digite el nombre de el esquema:");
      glossary.put ("OKCREATESCH1","El esquema \"");
      glossary.put ("OKCREATESCH2","ha sido creada satisfactoriamente.");

      /*** XML ***/
      //
      glossary.put ("XMLT","XRD-exportacion el catalogo de los XML descriptors");  // Nick 2009-07-23
      glossary.put ("NEMO-XML-T", "x");
      //
      glossary.put ("XMLD","XML-exportacion el catalogo de los XML descriptors");  // Nick 2009-08-06
      glossary.put ("NEMO-XML-D", "X");

      glossary.put ("XMLI", "Importacion el catalogo de los XML descriptors");     
      glossary.put ("NEMO-XMLI", "y");
      //
      glossary.put ( "XMLU", "Renovacion el catalogo de los XML descriptors");      // Nick 2009-09-04   
      glossary.put ("NEMO-XMLU", "Y");
      // 
      glossary.put ("DUMP_XMLD", "Exportar el catalogo de los XML descriptors");
      // 
      glossary.put ("DUMP_ACT", "Los XML objectos activo");
      glossary.put ("DUMP_UACT", "Los XML objectos inactivo");
      glossary.put ("DUMP_DEL", "Los XML objectos quitado");
      //
      glossary.put ("XMLF","XML archivos ");
      glossary.put ("UXMLF","Crear que faltan");
      // 
      glossary.put ("XMLTC", "Escoger:" ) ; 
      glossary.put ("XMLTW", "las tablas que falta en el XML-catalogo" ) ;
      //
      glossary.put ("XMLCR", "Es creado" ) ;  
      glossary.put ("XMLUP", "Es renovado" ) ;
      //
      glossary.put ("XMLTCRT", "Crear XML descriptor" ) ;  // Nick 2009-10-06
      glossary.put ("XMLXRD",  "XML descriptor" ) ;        // Nick 2009-10-08
      glossary.put ("XMLPRT",  "Imprimir" ) ;              // Nick 2009-10-08
      glossary.put ("XMLACP",  "Aceptar" ) ;               // Nick 2009-10-08
      glossary.put ("XMLDSP",  "Mostrar" ) ;               // Nick 2009-10-08
      glossary.put ("XMLSTS",  "Establecer el status" ) ;  // Nick 2009-10-08
      glossary.put ("XMLSYN",  "Sincronico" ) ;            // Nick 2010-04-28      
      //
      glossary.put ("XML_ACT",  "Activo");    // Nick 2009-10-08
      glossary.put ("XML_UACT", "Inactivo");  // Nick 2009-10-08
      glossary.put ("XML_DEL",  "Quitado");   // Nick 2009-10-08

      /*** Unload data ***/
      glossary.put ("UDNF","No hay datos");
      glossary.put ("UDSC"," descriptores es descargado.");
      
      // Nick 2010-04-23 
      glossary.put ("UUID", "UUID");
      glossary.put ("NEUUID", "no coinciden UUID");
      glossary.put ("NENAMET", "no coinciden los nombres de las tablas");
      glossary.put ("NACTNAMET", "No el nombre actual de la tabla");
      glossary.put ("CREATED", "es creado");
      glossary.put ("UPDATED", "es renovado");
      glossary.put ("SKIPED", "es dejado pasar");
      //         	 
      glossary.put ("XMLTCI", "XML descriptores");
      glossary.put ("XMLTNI", "nuevo"); 
      glossary.put ("XMLTBI", "defectuoso");
      
       // Nick 2010-04-28
      glossary.put ("XMLIMPAS", "Importar como");
      glossary.put ("IMPOSSTD", "Es imposible renovar el catalogo temporal");
      glossary.put ("IMPOSCTT", "Es imposible limpiar las tablas temporales");
      glossary.put ("IMPOSPD",  "Es imposible correctamente preparar los datos");
      glossary.put ("IMPOPPD",  "Es imposible crear las nuevas inscripciones en el XML-catalogo");
      glossary.put ("IMPOUPD",  "Es imposible renovar el XML-catalogo");
      glossary.put ("IMPOCSVC", "Es imposible cambiar el status de la visibilidad de la columna.");
      //
      glossary.put ("XMLCLST", "Ha comenzado la recogida de los metadatos");
      
      /*** MENU TABLE AND STRUCTURE ***/       
      glossary.put ("FIELDS","Campos");
      glossary.put ("VFIELDS","Campos Visibles"); 
      glossary.put ("FIELD","Campo");   
      glossary.put ("ADDF","Aï¿½adir Campo");   
      glossary.put ("EDITF","Editar Campo");
      glossary.put ("DROPF","Eliminar Campo");
      glossary.put ("STRUC","Estructura");
      glossary.put ("INSREC","Insertar Registro");
      glossary.put ("DELREC","Eliminar Registro");
      glossary.put ("UPDREC","Actualizar Registro");
      glossary.put ("TABLE","Tabla");
      glossary.put ("NEMO-TABLE","T"); //Caracter de atajo para la palabra "Tabla"     

      //  Nick 2012-11
      glossary.put ("FNC", "Functione");
      glossary.put ("DMN", "Domino");
      glossary.put ("AGR", "Agregato");
      glossary.put ("SEQ", "Sequencia");
      glossary.put ("TYP", "Tipo");
      glossary.put ("CTP", "Component tipo");
      glossary.put ("ENM", "Enumeracione");
      glossary.put ("OPR", "Operador");
      glossary.put ("TRG", "Trigger");
      glossary.put ("RUL", "Rula");
      //  Nick 2012-11
      
      glossary.put ("NEWT","Nueva Tabla");
      glossary.put ("DROPT","Eliminar Tabla");
      glossary.put ("DUMPT","Exportar Tabla");

      glossary.put ("KEYP","Clave Primaria");
      glossary.put ("KEYU","Clave Unica");
      glossary.put ("KEYI","Clave Indexada");
      glossary.put ("STRTAB","Estructura de Tabla para:");
      glossary.put ("NAME","Nombre");
      glossary.put ("RNAME","Renombrar");
      glossary.put ("TYPE","Tipo");
      glossary.put ("LONGTYPE","Tamaï¿½o");
      glossary.put ("NOTNULL","No Nulo");
      glossary.put ("DEFAULT","Valor por Defecto");
      glossary.put ("CREATET","Crear Tabla");
      glossary.put ("CREATE","Crear");    
      glossary.put ("ADD","Adicionar");
      glossary.put ("CHANGE","Cambiar");
      glossary.put ("REMOVE","Eliminar");
      glossary.put ("NAMET","Nombre - Tabla"); 
      glossary.put ("PROPTABLE","Propiedades de la Tabla");
      glossary.put ("PROPF","Propiedades del Campo"); 
      glossary.put ("TYPE","Tipo"); 
      glossary.put ("LENGHT","Longitud"); 
      glossary.put ("PREC", "Exactitud");
      glossary.put ("DEFVALUE","Valor por Defecto"); 
      glossary.put ("EXPORTAB","Exportar a Archivo");
      glossary.put ("EXPORTAB1","Exportar a Carpeta");  // Nick 2009-09-03
      glossary.put ("EXPORREP","Exportar a Reporte");
      glossary.put ("SELECTDB","Seleccione Base de Datos y Tabla (s):"); 
      glossary.put ("STRONLY","Estructura");  
      glossary.put ("STRDATA","Estructura y Datos"); 
      glossary.put ("NAMEF","Archivo"); 
      glossary.put ("EXPORT","Exportar"); 
      glossary.put ("IMPORT","Importar");
      glossary.put ("ITT","Importar a Tabla");
      glossary.put ("DATA","Datos");
      glossary.put ("NTS","Ninguna tabla fue seleccionada.\nPor favor, seleccione al menos una de la lista.");
      glossary.put ("DFINS","El archivo destino no ha sido seleccionado.\nPor favor, escoja uno.");
      glossary.put ("NTE","Nada para exportar. Por favor, seleccione la opciï¿½n 'Estructura' y/o 'Registros'.");
      glossary.put ("OWNER","Propietario");
      glossary.put ("FOKEY","Llave Forï¿½nea");
      glossary.put ("FK","Forï¿½nea");
      glossary.put ("FKN","Nombre de la Llave Forï¿½nea: ");
      glossary.put ("FTAB","Tabla Forï¿½nea: ");
      glossary.put ("LFI","Campo Local: ");
      glossary.put ("RFI","Campo Forï¿½neo: ");
      glossary.put ("ISKEY","Es Llave");
      glossary.put ("OPKEY","Opciones de Llave");
      glossary.put ("FORS","Selecciï¿½n de Llave Forï¿½nea");
      glossary.put ("FLIST","Lista de Campos");
      glossary.put ("TNNCH","El nombre de la tabla no ha sido ingresado. Por favor, adicionelo.");
      glossary.put ("TNIVCH","El nombre de la tabla posee caracteres invï¿½lidos. Por favor, modifiquelo.");
      glossary.put ("FNIVCH","El nombre del campo posee caracteres invï¿½lidos. Por favor, modifiquelo.");
      glossary.put ("FEMPT","El nombre del campo no ha sido ingresado. Por favor, escriba uno.");
      glossary.put ("EMPTEX","El nombre del campo ya existe. Por favor, escoja otro.");
      glossary.put ("NOFCR","La tabla no posee campos. Por favor, adicione al menos uno. ");
      glossary.put ("NOEXISF","Campo Inexistente");
      glossary.put ("NOEXISF2","El campo que desea actualizar no ha sido creado. Desea adicionarlo?"); 

      /*** CREATE TABLE ***/
      glossary.put ("INHE","Herencia"); 
      glossary.put ("INFT","Tablas a Heredar:");
      glossary.put ("CONSFT","Defina las restricciones para la nueva tabla:");
      glossary.put ("TNTAB","No hay tablas en la Base de Datos '");
      glossary.put ("CHECK","Revisar");
      glossary.put ("CONST","Restricciï¿½n"); 
      glossary.put ("DEL","Borrar");
      glossary.put ("DELALL","Borrar Todos");    
      glossary.put ("REFER","Referencia");
      glossary.put ("NOREG","Sin Registros");
      glossary.put ("DEF","Definiciï¿½n");
      glossary.put ("CRT", "La nueva tabla es creada. ");  // 2012-02-06 Nick
      glossary.put ("VCTS", "\nEl constructor visual ha comenzado el trabajo.\n" );
      glossary.put ("VCTT", "El constructor visual ha acabado el trabajo.\n" );

      /*** RECORDS ***/       
      glossary.put ("INSFORM","Insertar Registro");
      glossary.put ("RECS","Registros"); 
      glossary.put ("DIR","Directorio");
      glossary.put ("CHDIR","Escoja un Directorio");
      glossary.put ("CHDIR1","Escoja un directorio con los datos iniciales");      
      glossary.put ("INTA","en tabla");
      glossary.put ("FILTER","Filtro");
      glossary.put ("ERRFIL","El area de texto en la condiciï¿½n del filtro se encuentra vacia.\nPor favor, llenela o deshabilite el filtro.");
      glossary.put ("LIMIT","Limite");
      glossary.put ("ERRLIM","Tipo incorrecto en parametro");
      glossary.put ("ERRLIM2","del item 'Limite'!\nValor entero es requerido.");
      glossary.put ("STARTR","Empezar en fila");
      glossary.put ("NUMR","Nï¿½mero de Registros en '");
      glossary.put ("LIMUS","Ninguna de las areas en la opciï¿½n 'Limite' ha sido utilizada.\nPor favor, llenelas o deshabilite dicho filtro.");
      glossary.put ("LIM1US","Una de las cotas en la opciï¿½n 'Limite' se encuentra vacia.\nPor favor, llenela o deshabilite dicho filtro.");
      glossary.put ("MORELIM","La fila inicial es superior a la fila final en la opciï¿½n de Lï¿½mite.\nPor favor, modifique las cotas.");
      glossary.put ("ERRONRUN","Ocurrio un error durante la ejecuciï¿½n de la instrucciï¿½n: ");

      glossary.put ("NRE","Error: Usted no posee permisos para leer datos de la tabla ");
      glossary.put ("EFIN","Hay al menos un campo vacio en la lista de atributos.\nPor favor, adicione el valor a propiado para el atributo '");
      glossary.put ("EFIW","Hay al menos un campo vacio en la condiciï¿½n del WHERE.\nCompletela o deshabilite el atributo '"); 

      glossary.put ("E1","Todos los datos en la tabla '");
      glossary.put ("E2","' serï¿½n eliminados!. Estï¿½ seguro?");

      glossary.put ("NFSU","No fue seleccionado ningï¿½n campo para actualizar.\nPor favor, seleccione al menos uno de los campos y asignele un valor.");

      glossary.put ("U1","Todos los registros en la tabla '"); 
      glossary.put ("U2","' serï¿½n modificados!.\nEstï¿½ seguro?");
      glossary.put ("FINTIV","El valor en el filtro debe ser de tipo numerico.\nPor favor, modifiquelo.");
      glossary.put ("IBT","El valor en el campo del filtro debe ser de tipo booleano.\nUnicamente los valores 'true' o 'false' son permitidos.");

      glossary.put ("NCNNA","Error: El nï¿½mero de Columnas en el archivo no coincide\ncon el nï¿½mero de Atributos en la tabla");
      glossary.put ("NEXT","Siguiente");
      glossary.put ("INI","Inicio");
      glossary.put ("TOTAL","Total");
      glossary.put ("AVER","Promedio");
      glossary.put ("KSDS","Conservar selecciï¿½n durante la sesiï¿½n");
      glossary.put ("ALOF","Ningï¿½n campo ha sido seleccionado.\nPor favor, escoja al menos uno.");
      glossary.put ("NVE","El valor por defecto para este campo debe ser numï¿½rico.");
      glossary.put ("BVE","El valor por defecto para este campo debe ser booleano.");
      glossary.put ("FNN"," es un campo de tipo NO NULO. Por favor asigne un valor para este campo.");
      glossary.put ("TFIC","El archivo esta corrupto en la lï¿½nea ");

      glossary.put ("ONMEM","en Memoria");
      glossary.put ("ONSCR","en Pantalla");
      glossary.put ("FSET","Primera Pï¿½gina");
      glossary.put ("PSET","Pï¿½gina Anterior");
      glossary.put ("NSET","Siguiente Pï¿½gina");
      glossary.put ("LSET","Ultima Pï¿½gina");
      glossary.put ("PAGE","Pï¿½gina");
      glossary.put ("OF","de");
      glossary.put ("FROM","desde");
      glossary.put ("TO","hasta");

      /*** QUERIES ***/    
      glossary.put ("QUERY","Consulta");
      glossary.put ("NEMO-QUERY","Q");  // C   Nick 2009-07-28
      glossary.put ("QUERYS","Consultas");   
      glossary.put ("FUNC","Funciones");
      glossary.put ("OPEN","Abrir");
      glossary.put ("NEMO-OPEN","A");
      glossary.put ("SAVE","Guardar");
      glossary.put ("NEMO-SAVE","G");
      glossary.put ("RUN","Ejecutar");
      glossary.put ("NEMO-RUN","j");
      glossary.put ("NEWQ","Nueva Consulta");
      glossary.put ("OPENQ","Abrir Consulta");
      glossary.put ("SAVEQ","Guardar Consulta");
      glossary.put ("RUNQ","Ejecutar Consulta");
      glossary.put ("EXPTO","Exportar a");
      glossary.put ("FILE","Archivo");
      glossary.put ("NEMO-FILE","A");
      glossary.put ("HQ","Consultas Predefinidas");
      glossary.put ("NEMO-HQ","C");
      glossary.put ("REP","Reporte");
      glossary.put ("RFP","Ruta de Reportes:");
      glossary.put ("FNP","Patrï¿½n de Nombres:");
      glossary.put ("RPP","Registros por Pï¿½gina:");
      glossary.put ("FEATURES","Features");
      glossary.put ("REPCSV","Formato CSV");
      glossary.put ("SQLF","Archivos SQL");
      glossary.put ("CPDNG","El campo Cellpading debe ser de tipo numerico.\nPor favor, modifiquelo.");
      glossary.put ("CSCNG","El campo Cellspacing debe ser de tipo numerico.\nPor favor, modifiquelo.");
      //glossary.put ("HRW","El campo 'Ancho' debe ser de tipo numerico.\nPor favor, modifiquelo.");
      //glossary.put ("HRS","El campo 'Tamaï¿½o' debe ser de tipo numerico.\nPor favor, modifiquelo.");
      glossary.put ("REPCR","Creando reporte: ");
      glossary.put ("HCRE","Creado con X1 0.1 [http://www.kazak.ws]"); // XPg
      glossary.put ("OBR","Abriendo navegador... esto puede tomar un momento... por favor, espere...");
      glossary.put ("NFIR","Ningï¿½n campo a sido incluido en el reporte.\nPor favor, adicione al menos uno.");
      glossary.put ("NEMO-REP","R");
      glossary.put ("NORES","Sin Resultados");
      glossary.put ("ICONNEW","/icons/55_Nueva.png");
      glossary.put ("ICONFUNC","/icons/55_Func2.png");
      glossary.put ("ICONHQ","/icons/55_CP.png");
      glossary.put ("ICONOPEN","/icons/55_Abrir.png");
      glossary.put ("ICONSAVE","/icons/55_Guardar.png");
      glossary.put ("ICONRUN","/icons/55_Correr.png");

      glossary.put ("LOAD","Cargar");
      glossary.put ("RQOL","Ejecutar consulta directamente");
      glossary.put ("QQN","Nombre corto de la consulta");
      glossary.put ("EQQN","Lo siento, el nombre de la consulta ya existe. Por favor, escoja otro.");
      glossary.put ("CONFRM","Confirmaciï¿½n");
      glossary.put ("DELIT","Estï¿½ seguro que desea borrarlo?");
      glossary.put ("DRCONF","Estï¿½ seguro que desea borrar los registros seleccionados?");

      glossary.put ("IVIC","ï¿½ltima instrucciï¿½n invï¿½lida... caracter ';' ausente!");
      glossary.put ("SSQ","Utilizï¿½ varios select en su consulta,\nSï¿½lo podrï¿½ visualizar el primero.");
      glossary.put ("DBEMPTY","Base de Datos vacï¿½a :(");

      /*** REPORTS ***/
      glossary.put ("REPTED","Editor de Reportes");
      glossary.put ("FIELED","Ediciï¿½n de Campos");
      glossary.put ("SELALL","Seleccionar Todo");
      glossary.put ("UNSELALL","Deshacer Selecciï¿½n");
      glossary.put ("CLRSEL","Deshacer Selecciï¿½n");
      glossary.put ("NOFSEL","No hay campo seleccionado");
      glossary.put ("SETTIT","Tï¿½tulo: ");
      glossary.put ("INCRES","Incluir Resultado: ");
      glossary.put ("NONE","Ninguno");
      glossary.put ("AVERG","Promedio");
      glossary.put ("LOOK","Apariencia");
      glossary.put ("CCBC","Seleccione el Color de Fondo de la Celda");
      glossary.put ("CCTC","Seleccione el Color de Texto de la Celda");
      glossary.put ("CBC","Seleccione el Color de Fondo");
      glossary.put ("CTC","Seleccione el Color de Texto");
      glossary.put ("IMGF","Archivos de Imagenes");
      glossary.put ("LIMG","Cargar Imagen");
      glossary.put ("LFILE","Cargar Archivo");
      glossary.put ("FTF","De una tabla a un archivo");
      glossary.put ("FFT","De un archivo a una tabla");

      glossary.put ("AFDE","El archivo asociado al nombre seleccionado no existe!");
      glossary.put ("NIWC","Ninguna imagen fue escogida!. Por favor, seleccione una ruta vï¿½lida o deshabilite la opciï¿½n.");
      glossary.put ("PRESTY","Estilos Predefinidos");

      // glossary.put ("VIEW","Ver"); was been here Nick 2009-07-23

      glossary.put ("CLOSE","Cerrar");
      glossary.put ("REPAPP","Apariencia");
      glossary.put ("GENSETT","Caracterï¿½sticas Generales");
      glossary.put ("HEADER","Cabecera");
      glossary.put ("FOOTER","Pie de Pï¿½gina");
      glossary.put ("DATSETT","Caracterï¿½sticas de Tabla");
      glossary.put ("TABDIM","Dimensiones de Tabla");
      glossary.put ("CELLPAD","Cellpading");
      glossary.put ("CELLSPA","Cellspacing");
      glossary.put ("UBR","Borde");
      glossary.put ("TABLEH","Cabecera de la Tabla");
      glossary.put ("STYLE","Estilo");
      glossary.put ("FCOLOR","Color de Fuente");
      glossary.put ("FSETT","Caracterï¿½sticas de Fuente");
      glossary.put ("BACKCOLOR","Color de Fondo");
      glossary.put ("CELLS","Celdas");
      glossary.put ("REPHSETT","Caracterï¿½sticas Cabecera del Reporte");
      glossary.put ("REPFSETT","Caracterï¿½sticas Pie de Pï¿½gina del Reporte");
      glossary.put ("HEADERT","Texto de la Cabecera");
      glossary.put ("FOOTT","Texto de Pie de Pï¿½gina");
      glossary.put ("TITTEXT","Texto del Tï¿½tulo");
      glossary.put ("DATE","Fecha");
      glossary.put ("FORMAT","Formato");
      glossary.put ("NODATE","Sin Fecha");
      glossary.put ("DATE0","hour:min dï¿½a/mes/aï¿½o (p.e. 14:20 - 30/12/1978)");
      glossary.put ("DATE1","dï¿½a/mes/aï¿½o (p.e. 30/12/1978)");
      glossary.put ("DATE2","mes/dï¿½a/aï¿½o (p.e. 12/30/1978)");
      glossary.put ("DATE3","Mes Dï¿½a de Aï¿½o (p.e. Julio 1 de 1970)");
      glossary.put ("WIMGLOGO","Incluir Logo (Imagen)");
      glossary.put ("BROWSE","Explorador");
      glossary.put ("TRYING","Abriendo");
      glossary.put ("NBFOUND","No fuï¿½ encontrado ningï¿½n navegador en el sistema.");
      glossary.put ("SAVECH","Guardar Cambios");
      glossary.put ("RFPEMP","El campo referente a la ruta de los archivos esta vacï¿½o. Por favor, llï¿½nelo.");
      glossary.put ("FNPEMP","El campo referente a los nombres de los archivos esta vacï¿½o. Por favor, llï¿½nelo.");
      glossary.put ("RPPEMP","El campo referente al nï¿½mero de pï¿½ginas estï¿½ vacï¿½o. Por favor, llï¿½nelo.");
      glossary.put ("RPPNUM","El nï¿½mero de pï¿½ginas debe ser un valor numï¿½rico. Por favor, corrï¿½jalo..");

      /*** ADMIN ***/    
      glossary.put ("ADMIN","Admin");            
      glossary.put ("NEMO-ADMIN","d");       
      glossary.put ("USER","Usuario");
      glossary.put ("NEMO-USER","U");   
      glossary.put ("GROUP","Grupo");    
      glossary.put ("GROUPID","ID Grupo:");
      glossary.put ("NEMO-GROUP","G");
      glossary.put ("PERMI","Permisos");
      glossary.put ("NEMO-PERMI","P");
      glossary.put ("GRANT","Conceder");
      glossary.put ("NEMO-GRANT","n");
      glossary.put ("REVOKE","Quitar");
      glossary.put ("NEMO-REVOKE","Q");

      /*** WINDOWS MENSSAGE ***/    
      glossary.put ("UONLINE","X1 - Usuario en Lï¿½nea: "); // XPg Nick 2009-11-12
     
       /** Help  **/
      glossary.put ("HELP","Ayuda");
      glossary.put ("NEMO-HELP","h");    // A  Nick 2009-07-23
      glossary.put ("NEMO-HELP2","y");
      glossary.put ("ABOUT","Acerca de");
      glossary.put ("NEMO-ABOUT","c");
      
      /*** LOGS ***/
      glossary.put ("LOGMON" , "Monitor de Eventos");
      glossary.put ("USER "  , "Usuario ");  
      glossary.put ("VALID"  , " con acceso vï¿½lido a ");
      glossary.put ("REPORT" , "REPORTE:\n");      
      glossary.put ("DB: "   , "Base de Datos: ");
      glossary.put ("NUMT"   , " - Nï¿½mero de Tablas: "); 
      glossary.put ("DISSOF" , "Desconectado de ");
      glossary.put ("PRESSCL","Presione aquï¿½ para expandir el Monitor de Eventos");
      
      /*** TREE ***/
      glossary.put ("DSCNNTD"  , "Desconectado");
      glossary.put ("NOTABLES" , "Sin Tablas");
      glossary.put ("NOOBJECTS" , "Sin Objetos"); // Nick 2009-07-16
      glossary.put ("DBSCAN","Busqueda");
      glossary.put ("DYWLOOK","Desea buscar otras bases de datos en el servidor?");
      glossary.put ("NOREG","Sin Registros");
      glossary.put ("PCDBF","Por favor, seleccione una base de datos primero!");
      glossary.put ("NODBC","Lo siento, no hay tablas creadas en la base de datos \"");
      
      /*** PROOF AND SEEK***/
      glossary.put ("LOOKDB","Buscando Bases de datos...");
      glossary.put ("LOOKDBS","Buscando Bases de Datos en el Servidor: '");
      glossary.put ("EXEC","Ejecutando: \"");
      glossary.put ("DBON","Bases de Datos en ");
      glossary.put ("TRYCONN","Tratando de conectar a la base de datos ");   
      glossary.put ("OKACCESS","Acceso vï¿½lido :)");
      glossary.put ("EXECON","Ejecutando en ");
      glossary.put ("NOACCESS","Acceso Denegado :(");
      
      /*** PG_KONNECTION ***/
      glossary.put ("NODRIVER","No se puede cargar el driver de PostgreSQL");
      glossary.put ("CONNTO","Conectado a "); 
      glossary.put ("NOPGHBA","No hay un registro en el pg_hba.conf para estos parï¿½metros");
      glossary.put ("BADPASS","Clave de acceso Incorrecta");
      glossary.put ("BADHOST","Servidor desconocido o inalcanzable");
      glossary.put ("STRANGE","5 (Error Desconocido)");
      
      /*** VERSION ***/
      glossary.put ("TITABOUT", "Acerca de X1 - Interfaz Grï¿½fica para PostgreSQL" );  //XPg
      glossary.put ("PGI",      "Interfaz Grï¿½fica para PostgreSQL" );
      glossary.put ("NUMVER",   "Versiï¿½n:" );
      glossary.put ("COMP",     "Ultima Compilaciï¿½n: " );
      glossary.put ("CLTLIB",   "Versiï¿½n Servidor Postgres de Prueba: 9.1/8.3/7.4.1" );
      glossary.put ("PLATF",    "Plataforma: MS Windows, Linux" );
      glossary.put ("AUTORS",   "Desarrollado por:  Chadaev Nikolay. [nick_ch58@list.ru]" ); 

      /*** STRUCTURES ***/
      glossary.put ("TABLESTRUC","La tabla: ");
      glossary.put ("VEIWSTRUC","La vista: ");
      glossary.put ("DBOFTABLE"," en BD ");
      glossary.put ("NULL","Nulo"); 
      glossary.put ("DEFAULT","Valor por Defecto");    
      glossary.put ("NOSELECT","No hay tabla seleccionada");
      glossary.put ("TITINDEX","Llaves");
      glossary.put ("INDEX","Nombres de los Indices");
      glossary.put ("INDEXED","Indexada");
      glossary.put ("INDEXPR","Propiedades");
      glossary.put ("PKEY","Primaria");
      glossary.put ("UKEY","ï¿½nica");
      glossary.put ("SEQUENCE","Secuencias");
      glossary.put ("COMM","Comentario");

      /*** ERROR_DIALOG ***/
      glossary.put ("NUMERROR","Error No. ");
      glossary.put ("DETAILS","Detalles");
    
      /*** GROUP ***/
      glossary.put ("MODGRP","Modificar Grupo");
      glossary.put ("NAMEGRP","Nombre del Grupo: ");
      glossary.put ("NOGRP","Sin Grupo");
      glossary.put ("MODGR","Modificar");
      glossary.put ("CREATEGRP","Crear Grupo");
      glossary.put ("GRPID","ID Grupo: ");
      glossary.put ("NNGRP","El nombre del grupo no ha sido ingresado. Por favor llene el campo");
      glossary.put ("INVGRP","El nombre del grupo posee caracteres invï¿½lidos. Por favor modifï¿½quelos");
      glossary.put ("INVGID","El GID debe ser un valor numï¿½rico. Por favor modifï¿½quelo");
      glossary.put ("INVNG","El grupo 'Sin Grupo' es un nombre invalido para un grupo.\nPor favor, escoja uno de los disponibles"); 
      glossary.put ("NGRPS","Operaciï¿½n No disponible. No hay grupos creados.");
      glossary.put ("RMGRP","Eliminar Grupo");
      glossary.put ("SELGRP","Seleccione un grupo: ");
      glossary.put ("VRF","Verificar");
      glossary.put ("VLD","Validez");
      glossary.put ("UID","ID Usuario: ");
      glossary.put ("PERM","Permisos");
      glossary.put ("NNUSR","El nombre del usuario no ha sido ingresado.\nPor favor, llene el campo.");
      glossary.put ("INVUSR","El nombre del usuario posee caracteres invï¿½lidos.\nPor favor, modifï¿½quelo.");
      glossary.put ("INVUID","El UID debe ser un valor numï¿½rico.\nPor favor, modifï¿½quelo.");
      glossary.put ("INVPASS","La clave digitada no coincide en los dos campos.\nPor favor, modifï¿½quela.");
      glossary.put ("GNE","El nombre del grupo no ha sido ingresado.\nPor favor, llene el campo.");
      glossary.put ("GNIV","El nombre del grupo posee caracteres invï¿½lidos.\nPor favor, modifiquelo.");
      glossary.put ("GINN","El GID debe ser un identificador numerico.\nPor favor, cambielo.");
      glossary.put ("TNE1","El valor del campo '");
      // glossary.put ("TNE2","' debe ser de tipo numerico.\nPor favor, cambielo.");
      // Nick 2012-11-04
      glossary.put ("TNE100","' debe ser de tipo INTEGER.\nPor favor, cambielo.");            // The integer types
      glossary.put ("TNE101","' debe ser de tipo FIXED POINT.\nPor favor, cambielo.");        // The fixed point types ( decimal, numeric )
      glossary.put ("TNE102","' debe ser de tipo FLOAT POINT.\nPor favor, cambielo.");        // The float point types
      glossary.put ("TNE103","' debe ser de tipo CHAR/VARCHAR/TEXT.\nPor favor, cambielo.");  // The char, varchar, text types
      glossary.put ("TNE104","' debe ser de tipo NAME.\nPor favor, cambielo.");               // The name type, internal type for the database
      glossary.put ("TNE105","' debe ser de tipo BLOB.\nPor favor, cambielo.");               // The blob type
      glossary.put ("TNE106","' debe ser de tipo TIME.\nPor favor, cambielo.");               // The data, datatime and interval types
      glossary.put ("TNE107","' debe ser de tipo BOOLEAN.\nPor favor, cambielo.");       // The boolean type
      glossary.put ("TNE108","' debe ser de tipo GEOMETRY.\nPor favor, cambielo.");           // The geometric types
      glossary.put ("TNE109","' debe ser de tipo CIDR, INET.\nPor favor, cambielo.");         // The cidr, inet types
      glossary.put ("TNE110","' debe ser de tipo UUID.\nPor favor, cambielo.");               // The UUID types
      glossary.put ("TNE111","' debe ser de tipo BIT, VARBIT.\nPor favor, cambielo.");        // The bit, varbit types
      // Nick 2012-11-04      
     
      glossary.put ("SELUSR","Seleccione un usuario");
      glossary.put ("OPC","Opciones");

      glossary.put ("INSRT","Insertar");
      glossary.put ("UPDT","Actualizar");
      glossary.put ("CCOND","Clausula de Condiciones");
      glossary.put ("PRS","Estilos Predefinidos");
      glossary.put ("CHO","Seleccione uno");
      glossary.put ("ADF","Filtro Avanzado");
      glossary.put ("CUF","Filtro Personalizado");
      glossary.put ("LRW","Fila Lï¿½mite: ");
      glossary.put ("DEFVL","Valor por Defecto");
      glossary.put ("PERDB","Permisos en DB: ");
      glossary.put ("NOTOW","El Usuario no es Propietario de Tablas en DB '");
      glossary.put ("PBLIC","Publico");
      glossary.put ("CHST","Seleccione una Tabla: ");
      glossary.put ("APPL","Aplicar a");
      glossary.put ("SET","Aplicar");
      glossary.put ("APAT","Aplique a todas las tablas");   
      glossary.put ("SDT","Seleccione DB y Tabla(s): "); 
      glossary.put ("SDG","Estructura");
      glossary.put ("FN","Archivo: ");       
      glossary.put ("SUCSS","Ok");

     /*** VIEWS,  glossary.put ("VIEW","Vista"); was added 2009-07-23 Nick  ***/
      
      glossary.put ("VIEW","Vista");
      glossary.put ("VIEWS","Vistas");
      glossary.put ("VEXIS","La vista '");
      glossary.put ("INVVIE","Nombre invï¿½lido para la vista!");
      //
      glossary.put ("NEMO-VIEW","v");         // Nick 2009-07-23
      glossary.put ("NEWV","Nueva vista");    
      glossary.put ("DROPV","Eliminar vista");
      glossary.put ("DUMPV","Exportar vista");

      /*** SEQUENCES ***/
      glossary.put ("INCR","Incremento");
      glossary.put ("MV","Valor Mï¿½nimo");
      glossary.put ("MXV","Valor Mï¿½ximo");
      glossary.put ("CACH","Cache");
      glossary.put ("CYC","Habilitar Ciclo");
      glossary.put ("SEQEXIS","La secuencia '");
      glossary.put ("SEQEXIS2"," ya existe!");
      glossary.put ("INVSEQ","Nombre invï¿½lido para la secuencia!");

      /***  ExportSeparatorField (Hook) ***/
      glossary.put ("SEPA","Separador");
      glossary.put ("SLINE","Linea de Separaciï¿½n");
      glossary.put ("W","Ancho");
      glossary.put ("SFS","Seleccione el Separador de Campos");
      glossary.put ("IFSEP","Indique el Separador de Campos");
      glossary.put ("SEPNF","Separador no encontrado en el archivo.");
      glossary.put ("PD","Predefinido: ");
      glossary.put ("CZ","Personalizado: ");
      glossary.put ("SB","Por Defecto (Barra Espaciadora)");
      glossary.put ("TAB","Tabulador");
      glossary.put ("COMMA","Coma (,)");
      glossary.put ("DOT","Punto (.)");
      glossary.put ("COLON","Dos Puntos (:)");
      glossary.put ("SCOLON","Punto y Coma (;)");
      glossary.put ("NNACCESS","La base de datos no es accequible desde esta ubicaciï¿½n.\nPara adquirir acceso contacte a su Administrador.");

      /*** Insert Field ***/
      glossary.put ("FNEMPTY","El campo nombre esta vacï¿½o. Por favor, seleccione uno.");
      glossary.put ("INVLENGHT","El valor en el campo 'Longitud' es invï¿½lido.");
      glossary.put ("INVDEFAULT","El valor por defecto no corresponde al tipo!.");
      glossary.put ("INVPREC", "El valor por defecto. Por favor, seleccione uno");
      glossary.put ("ADDDEFAULT", "Esto NOT NULL el campo, si quereis el significado ?" );

      /*** Warnings  ***/
      glossary.put ("ADV","Advertencia!");
      glossary.put ("LOTREG","La tabla '");
      glossary.put ("LOTREG2","' posee mas de 100 registros. Operaciï¿½n Inestable.");
      glossary.put ("UIMO","Operaciï¿½n No Implementada Aï¿½n ;(");
      glossary.put ("OVWR","Desea sobre-escribirlo?");
      glossary.put ("WDIS","Esta operaciï¿½n cerrarï¿½ todas las conexiones con el servidor PostgreSQL. Estï¿½ seguro?");
      glossary.put ("INVOP","Operaciï¿½n Invï¿½lida. La base de datos es el vï¿½nculo principal con el servidor PostgreSQL.");
      glossary.put ("OIDBC","Operaciï¿½n No Disponible.\nLa ï¿½nica base de datos que usted puede borrar es el vï¿½nculo principal con el servidor PostgreSQL.");
      glossary.put ("DOWSO","La conexiï¿½n al servidor PostgreSQL en '");
      glossary.put ("DOWSO2","' no es posible. Intente mï¿½s tarde...");
      glossary.put ("EMPTYDB","El nombre de la Base de Datos no ha sido ingresado.\nPor favor, escoja uno.");

      /*** SQL Functions Description ***/

      glossary.put ("FDNAME","Funciï¿½n");
      glossary.put ("FDRETURN","Retorna");
      glossary.put ("FDDESCR","Descripciï¿½n");
      glossary.put ("FDEXAMPLE","Ejemplo");

      glossary.put ("FDTILE","Funciones SQL");

      glossary.put ("FSQL","SQL");
      glossary.put ("FMATH","Matemï¿½ticas");
      glossary.put ("FNTR","Funciones Bï¿½sicas");
      glossary.put ("FTR","Funciones Trigonomï¿½tricas");
      glossary.put ("FSTR","Cadenas");
      glossary.put ("FSTR1","Funciones SQL92");
      glossary.put ("FSTR2","Otras Funciones");
      glossary.put ("FDATE","Fecha/Tiempo");
      glossary.put ("FDATEF","Formato de Fechas");
      glossary.put ("FGEO","Geometrï¿½a");
      glossary.put ("FGEO1","Funciones Bï¿½sicas");
      glossary.put ("FGEO2","Funciones de Conversiï¿½n de Tipos");
      glossary.put ("FGEO3","Funciones de Actualizaciï¿½n");
      glossary.put ("FIPV4","IP V4");

      glossary.put ("FD1","Retorna el primer valor NO nulo de la lista");
      glossary.put ("FD2","return NULL if input = value, else input");
      glossary.put ("FD3","retorna <i>expression</i> para el primer <i>true</i><br>cuando la clausula se cumple");
      glossary.put ("FD4","valor absoluto");
      glossary.put ("FD5","radianes a grados");
      glossary.put ("FD6","eleva <i>e</i> al exponente especificado");
      glossary.put ("FD7","logaritmo natural");
      glossary.put ("FD8","logaritmo en base 10");
      glossary.put ("FD9","constante fundamental");
      glossary.put ("FD10","eleva un n&uacute;mero al exponente especificado");
      glossary.put ("FD11","grados a radianes");
      glossary.put ("FD12","redondea al entero m&aacute;s cercano");
      glossary.put ("FD13","raiz cuadrada");
      glossary.put ("FD14","raiz c&uacute;bica");
      glossary.put ("FD15","trunca (hacia cero)");
      glossary.put ("FD16","convierte entero a punto flotante");
      glossary.put ("FD17","convierte entero a punto flotante");
      glossary.put ("FD18","convierte punto flotante a entero");
      glossary.put ("FD19","arcocoseno");
      glossary.put ("FD20","arcoseno");
      glossary.put ("FD21","arcotangente");
      glossary.put ("FD22","arcotangente");
      glossary.put ("FD23","coseno");
      glossary.put ("FD24","cotangente");
      glossary.put ("FD25","seno");
      glossary.put ("FD26","tangente");
      glossary.put ("FD27","longitud de una cadena");
      glossary.put ("FD28","longitud de una cadena");
      glossary.put ("FD29","convierte una cadea a min&uacute;sculas");
      glossary.put ("FD30","almacena la longitud de una cadena");
      glossary.put ("FD31","ubica una subcadena espec&iacute;fica");
      glossary.put ("FD32","extrae una subcadena espec&iacute;fica");
      glossary.put ("FD33","corta (trim) caracteres de una cadena");
      glossary.put ("FD34","convierte tipo text a may&uacute;sculas");
      glossary.put ("FD35","convierte tipo text a tipo char");
      glossary.put ("FD36","convierte tipo varchar a tipo char");
      glossary.put ("FD37","primera letra de cada palabra a may&uacute;sculas");
      glossary.put ("FD38","extiende por izquierda una cadena a una longitud espec&iacute;fica");
      glossary.put ("FD39","corte (trim) por derecha de caracteres de un texto");
      glossary.put ("FD40","ubica una subcadena espec&iacute;fica");
      glossary.put ("FD41","extiende por derecha una cadena a una longitud espec&iacute;fica");
      glossary.put ("FD42","corte (trim) por derecha de caracteres de un texto");
      glossary.put ("FD43","extrae una subcadena especifica");
      glossary.put ("FD44","convierte tipo char a tipo text");
      glossary.put ("FD45","convierte tipo varchar a tipo text");
      glossary.put ("FD46","convierte tipo caracter a tipo cadena");
      glossary.put ("FD47","convierte tipo char a tipo varchar");
      glossary.put ("FD48","convierte tipo text a tipo varchar");
      glossary.put ("FD49","convierte a tipo abstime");
      glossary.put ("FD50","preserva meses y a&ntilde;os");
      glossary.put ("FD51","preserva meses y a&ntilde;os");
      glossary.put ("FD52","porci&oacute;n de fecha");
      glossary.put ("FD53","porci&oacute;n de tiempo");
      glossary.put ("FD54","trunca una fecha");
      glossary.put ("FD55","convierte a intervalo");
      glossary.put ("FD56","es un tiempo finito?");
      glossary.put ("FD57","es un tiempo finito?");
      glossary.put ("FD58","convierte a tipo reltime");
      glossary.put ("FD59","convierte a tipo timestamp");
      glossary.put ("FD60","convierte a tipo timestamp");
      glossary.put ("FD61","convierte a tipo cadena");
      glossary.put ("FD62","convierte tipo timestamp a cadena");
      glossary.put ("FD63","convierte int4/int8 a tipo cadena");
      glossary.put ("FD64","convierte float4/float8 a tipo cadena");
      glossary.put ("FD65","convierte valor numerico a tipo cadena");
      glossary.put ("FD66","convierte cadena a fecha");
      glossary.put ("FD67","convierte cadena a tipo timestamp");
      glossary.put ("FD68","convierte cadena a valor numerico");
      glossary.put ("FD69","&aacute;rea de item");
      glossary.put ("FD70","cubo (box) de intersecci&oacute;n");
      glossary.put ("FD71","centro de item");
      glossary.put ("FD72","di&aacute;metro de un c&iacute;rculo");
      glossary.put ("FD73","tama&ntilde;o vertical de un cubo (box)");
      glossary.put ("FD74","una ruta (path) cerrada?");
      glossary.put ("FD75","una ruta (path) abierta?");
      glossary.put ("FD76","longitude del item");
      glossary.put ("FD77","convierte ruta (path) a ruta cerrada");
      glossary.put ("FD78","n&uacute;mero de puntos");
      glossary.put ("FD79","convierte ruta a ruta (path) abierta");
      glossary.put ("FD80","radio del c&iacute;rculo");
      glossary.put ("FD81","tama&ntilde;o horizontal");
      glossary.put ("FD82","c&iacute;rculo a cubo (box)");
      glossary.put ("FD83","puntos a cubo (box)");
      glossary.put ("FD84","pol&iacute;gono a cubo (box)");
      glossary.put ("FD85","a c&iacute;rculo");
      glossary.put ("FD86","point to circle");
      glossary.put ("FD87","diagonal de cubo (box) a lseg");
      glossary.put ("FD88","points to lseg");
      glossary.put ("FD89","pol&iacute;gono a ruta (path)");
      glossary.put ("FD90","centro");
      glossary.put ("FD91","intersecci&oacute;n");
      glossary.put ("FD92","centro");
      glossary.put ("FD93","pol&iacute;gono de 12 puntos");
      glossary.put ("FD94","pol&iacute;gono de 12-puntos");
      glossary.put ("FD95","pol&iacute;gono de <i>npts</i> puntos");
      glossary.put ("FD96","ruta (path) para el pol&iacute;gono");
      glossary.put ("FD97","prueba la ruta (path) para la forma pre-v6.1");
      glossary.put ("FD98","para pre-v6.1");
      glossary.put ("FD99","para pre-v6.1");
      glossary.put ("FD100","para pre-v6.1");
      glossary.put ("FD101","construye una direccion broadcast como texto");
      glossary.put ("FD102","construye una direccion broadcast como texto");
      glossary.put ("FD103","extrae la direccion de un servidor como texto");
      glossary.put ("FD104","calcula la longitud de una mascara de red");
      glossary.put ("FD105","calcula la longitud de una mascara de red");
      glossary.put ("FD106","construye una mascara de red como texto");

      glossary.put ("SYNT","Sintaxis");

      glossary.put ("FDB1","adiciona usuarios a un grupo o remueve usuarios de un grupo");
      glossary.put ("FDB2","modifica la definicion de una tabla");
      glossary.put ("FDB3","modifica la cuenta de un usuario de base de datos");
      glossary.put ("FDB4","define una nueva funciï¿½n agregada");
      glossary.put ("FDB5","define una nueva restriccion (trigger)");
      glossary.put ("FDB6","crea una nueva base de datos");
      glossary.put ("FDB7","define una nueva funciï¿½n");
      glossary.put ("FDB8","define un nuevo grupo de usuarios");
      glossary.put ("FDB9","define un nuevo indice");
      glossary.put ("FDB10","define un nuevo lenguage de procedimientos");
      glossary.put ("FDB11","define un nuevo operador");
      glossary.put ("FDB12","define una nueva regla re-escrita");
      glossary.put ("FDB13","define un nuevo generador de secuencia");
      glossary.put ("FDB14","define una nueva tabla");
      glossary.put ("FDB15","crea una nueva tabla a partir de los resultados de una consulta");
      glossary.put ("FDB16","define un nuevo trigger");
      glossary.put ("FDB17","define un nuevo tipo de datos");
      glossary.put ("FDB18","define una nueva cuenta de usuario de base de datos");
      glossary.put ("FDB19","define una nueva vista");
      glossary.put ("FDB20","elemina registros de una tabla");
      glossary.put ("FDB21","elimina una funcion agregada definida por el usuario");
      glossary.put ("FDB22","elimina una base de datos");
      glossary.put ("FDB23","elimina una funcion definida por el usuario");
      glossary.put ("FDB24","elimina un grupo de usuario");
      glossary.put ("FDB25","elimina un indice");
      glossary.put ("FDB26","elimina un lenguaje de procedimiento definido por el usuario");
      glossary.put ("FDB27","elimina un operador definido por el usuario");
      glossary.put ("FDB28","elimina una regla re-escrita");
      glossary.put ("FDB29","elimina una secuencia");
      glossary.put ("FDB30","elimina una tabla");
      glossary.put ("FDB31","elimina un trigger");
      glossary.put ("FDB32","elimina un tipo de dato definido por el usuario");
      glossary.put ("FDB33","elimina una cuenta de usuario de la base de datos");
      glossary.put ("FDB34","elimina una vista");
      glossary.put ("FDB35","define privilegios de acceso");
      glossary.put ("FDB36","elimina privilegios de acceso");
      glossary.put ("FDB37","retorna registros de una tabla o una vista");
      glossary.put ("FDB38","actualiza registros de una tabla");

      glossary.put ("WHERE","Donde");
      glossary.put ("CAN","puede ser:");
      glossary.put ("IS","es:");
      glossary.put ("AND","y");
      glossary.put ("QHIST","Historial de Consultas");
      glossary.put ("LOOKDB","Buscar otras Bases de Datos");
      glossary.put ("CHKLNK","Monitorear Conexiï¿½n");
      glossary.put ("CHKSSL","Soporte SSL");
      glossary.put ("ENABLE","Habilitado");
      glossary.put ("DISABLE","Deshabilitado");
      glossary.put ("DSPLY","Visualizaciï¿½n");
      glossary.put ("ADDTXT","Aï¿½adir Texto");
      glossary.put ("ADDBLOB","Aï¿½adir BLOB");   // 2012-11-04  Nick 


      /*** MONTHS ***/
      glossary.put ("JANUARY","Enero");
      glossary.put ("FEBRUARY","Febrero");
      glossary.put ("MARCH","Marzo");
      glossary.put ("APRIL","Abril");
      glossary.put ("MAY","Mayo");
      glossary.put ("JUNE","Junio");
      glossary.put ("JULY","Julio");
      glossary.put ("AUGUST","Agosto");
      glossary.put ("SEPTEMBER","Septiembre");
      glossary.put ("OCTOBER","Octubre");
      glossary.put ("NOVEMBER","Noviembre");
      glossary.put ("DECEMBER","Diciembre");

      glossary.put ("DELOK","registro eliminado");
      glossary.put ("DELOKS","registros eliminados");
      glossary.put ("CRDATA","Incluir en reporte:");
      glossary.put ("RDATA","Datos");
      glossary.put ("ROD","Registros en Pantalla");
      glossary.put ("ROM","Registros en Memoria");
      glossary.put ("ET","Tabla Completa");
  }

  public Hashtable getGlossary() {
      return glossary;
   }
}
