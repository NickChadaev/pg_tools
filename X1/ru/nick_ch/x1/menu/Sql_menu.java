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
 *  INTERFACE Sql_xsd @version 1.0   
 *      This is basic interface, which contains SQL-command for other 
 *      classe of ru.nick_ch.x1.menu package.
 *      Questions, Comments and Proposals: nick_ch58@list.ru
 *  History:
 *          Created:  2009/09/21
 *          Modified: 2010/05/18
 *                    2011/09/25 - For schema creating
 *                    2011/10/15 - For table creating           
 */

package ru.nick_ch.x1.menu;

public interface Sql_menu {

	// Nick 2012-02-20
	String cCRT = "CREATE ";
	String cALT = "ALTER ";
	String cDRP = "DROP ";
	String cCMT = "COMMENT ON ";
	String cIS  = "IS '";  
    String cSET = "SET ";
    String cADD = " ADD ";
    
	String cDB  = "DATABASE ";
	String cSCH = "SCHEMA ";
	String cTBL = "TABLE ";
	String cCOL = "COLUMN ";
	
	// For CreateSCH class   2011-09-25
	/***
	 String s_schema   = "CREATE SCHEMA ";
	 String s_schema_1 = "COMMENT ON SCHEMA ";
	 String s_schema_2 = " IS '";
	 String s_schema_3 = "'" ;
	***/
	// For DropDB class
	/**
	// For DropSCH class  2011-09-25
	 String S_DRP_SCH = "DROP SCHEMA ";
	**/
    // Nick 2010-05-18
     String cON  = "'ON'" ;
     String cOFF = "'OFF'" ;
     String cDEL = "'DEL'" ;
    
     String cSEP = "'";
     String cDQU = "\"" ;

     String cLF   = "\n" ;
     String cEMP  = "" ;
    
    // Nick 2011-10-16
      String S_SC  = ";";
	  String S_LBR = " ( ";
	  String S_RBR = " ) ";
	  String S_EQU = " = " ;
      String S_L_BR = "(" ;
      String S_R_BR = ")";
	  
      String cPOINT = "." ;
      
      String cDP = ":" ;
      String cDP2 = "::";
      String cSPACE = " " ;
      String cSPACE2 = "  " ;
      String cCOMMA = ",";
     
      String cOK = "OK" ;
      String cZERO = "ZERO" ;
 
      String cNOT  = "NOT ";
      String cNULL = "NULL ";
      String cKEY  = "KEY ";
     
      String cPRM = "PRIMARY ";
      String c_UNIQUE = " UNIQUE ";
     
      String c_DEFAULT    = " DEFAULT ";
      String c_CHECK      = " CHECK " ;
      String c_REFERENCES = " REFERENCES ";
    
      String  c_CONSTRAINT = " CONSTRAINT ";
      String  c_INHERITS   = " INHERITS ";
      
      String cCAST = "CAST";
      
      String cNAN       = "nan";         // 2012-03-08 Nick
      String cINFINITY  = "infinity";
      String cNINFINITY = "-infinity";
      
       String cEPOCH = "epoch";  //	    date, timestamp	        1970-01-01 00:00:00+00 (Unix system time zero)
                        //  infinity	timestamp	            later than all other time stamps
                        // -infinity	timestamp	            earlier than all other time stamps
       String cNOW       = "now";       //     date, time, timestamp	current transaction's start time
       String cTODAY     = "today";     //     date, timestamp	        midnight today
       String cTOMORROW  = "tomorrow";  //     date, timestamp	        midnight tomorrow
       String cYESTERDAY = "yesterday"; //	   date, timestamp	        midnight yesterday
       String cALLBALLS  = "allballs";  //     time  00:00:00.00 UTC

       String cGEN_UUID = "f_gen_uuid_py()"; // Temporary solution 2012-03-08 Nick
       
       String cESC = "E'\\";
       String cBST = "B'";
       //
       String cPUBLIC = "public";
       // 2012-10-18 Nick
       String cSEP2 = "''";
}
