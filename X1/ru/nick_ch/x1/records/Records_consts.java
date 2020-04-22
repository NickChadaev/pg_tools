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
 *  Interface Records_consts @version 1.0   
 *  Sql instructions and constants for classes of ru.nick_ch.x1.records package.
 *  
 *  History:  2010/01/12 - Created
 *           
 */

package ru.nick_ch.x1.records;

public interface Records_consts {

	 int C_LIMIT     = 50;
	 int C_INDEX_MAX = 50;
	 int C_ZERO      = 0;
     
     String SQL_010 = "SELECT " ; 
     String SQL_020 = " FROM " ; 
     String SQL_030 = " ORDER BY " ;
     String SQL_071 = " WHERE " ;

     String SQL_040 = " LIMIT " ; 
	 String SQL_050 = " OFFSET ";

     String SQL_011 = "SELECT * ";
     String SQL_031 = " AS foo ORDER BY " ;
	 
     
     // 2010-02-02 For InsertData Class 
     String S_DELIMITER = "   -   " ;  // Nick 2010-02-02
     String S_DELIM = "-" ;
     
     String S_SPACES_2 = "  " ;
     String S_L_BR = "(" ;
     String S_R_BR = ")";
     String S_LABEL_C = "check-" ;
     
     int cNUM_FIELDS_SCRL = 15 ;
     
     String S_INSERT_01 = "INSERT INTO ";
     String S_INSERT_02 = " VALUES ";
     String S_INSERT_03 = ";" ;
     
    // 2010-02-24
    String PN = "\"" ;
    String PA = "'" ;
    // 2010-03-01
    String S_SPACES_1 = " " ;
    String S_COMMA    = "," ;
    String S_POINT    = "." ;
    //
    String S_CSV = "csv";
    String S_TAB = "	"; 
    String S_DP  = ":";  
    String S_SC  = ";";
    
    // Nick 2010-03-04 
    String cNULL = "NULL" ;
    String cLF = "\n" ;
    
    // Nick 2012-07-31
    String cSSTAR = " *";
}
