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
 * INTERFACE File_consts v 0.1
 *      Constants for DB-connection and configuration  file.
 *      Questions, Comments and Proposals: nick_ch58@list.ru
 *      2009-11-17 Nick Chadaev 
 *  History:
 *           
 */

package ru.nick_ch.x1.misc.file;

import java.io.File;

public interface File_consts {

    String xLANGUAGE = "language=Russian" ;
    String xSERVER   = "server=localhost";
    String xDATABASE = "database=postgres";         
    String xUSERNAME = "username=postgres";
    String xPORT     = "port=5432";
    String xSSL      = "ssl=false";
    String xLAST     = "last=true" ;
    
    String yLAST     = "last=false" ;
	
    String sSERVER   = "localhost"; 
    String sDATABASE = "postgres";
    String sUSERNAME = "postgres";

    String vLANGUAGE = "language=";
    String vSERVER   = "server=" ;
    String vDATABASE = "database=" ;
    String vUSERNAME = "username=" ;
    String vPORT     = "port=" ;
    String vSSL      = "ssl=";
    String vLAST     = "last=" ; 
    
    String CFG_NAME   = "x1.cfg" ;
    String CFG_NAME_0 = "x1" ;
    String CFG_NAME_1 = ".cfg" ;
    
    String LOG_SUFF = ".log" ;
    
    String UNIX_PROGRAM_CATALOG = ".x1";
    String WINDOWS_PROP_NAME    = "xpgHome" ;
    String UNIX_HOME_CATALOG    = "user.home" ;
    
    
    String cLOG_CATALOG = "x1_logs" ;
    String cQR_CATALOG  = "x1_queries" ;
    String cREP_CATALOG = "x1_reports" ;
    String CFG_NAME_T   = "x1_temp" ;    // Nick 2010-04-29 It is catalog for temporary files.

    // Nick 2010-04-29
    String cTMP_FILE_NAME = "x1_be113c00-536f-11df-b72d-005056c00108.tmp";
    
    String cSYS_FILE_SEP = "file.separator" ;
    
    String cSYS_OS_NAME = "os.name" ;
    String cSYS_OS_LIN  = "Linux" ;
    String cSYS_OS_SOL  = "Solaris" ;
    String cSYS_OS_BSD  = "FreeBSD" ;
    String cSYS_OS_WIN  = "Windows" ;

    String cLOG_BEGIN = "Begin: " ;
    String cLOG_END   = "End: " ;

    String sTOKEN_1 = "=";
    String sTOKEN_2 = "true";
    String sTOKEN_3 = "none";

    int sPORT = 5432;
    
    // For ConfigFileReader Class
    String sTOKEN_4 = "localhost - postgres (postgres)" ;
    String sTOKEN_5 = "NO_PASS" ;
    
    String sTOKEN_10 = " - " ;
    String sTOKEN_11 = " (" ;
    String sTOKEN_12 = ")" ;
    
    String sTOKEN_20 = ".  " ; // For Title
    String sTOKEN_21 = ": " ;  // Connection Dialog
    
    String sTOKEN_22 = " [" ;  // Connection Dialog
    String sTOKEN_23 = "]" ;   // Connection Dialog

    // 2010-03-01 Nick
    String FILE_CONST = "file:" ; 
    String USER_DIR   = "user.dir";

    String sCATALOG = " catalog:";  // 2010-04-15 Nick
    String sFILE    = " file:" ;       // 2010-04-30 Nick
    
    // 2013-02-18 Nick
    String sTOKEN_24 = "|";
    String sTOKEN_25 = "*";
    
	String sTOKEN_26 = "name";
	String sTOKEN_27 = "value";
	String sTOKEN_28 = "run";
	String sTOKEN_29 = "dbname";
	String sZERO  = "0";
	String sZERO2 = "00";
}
