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
 *  CLASS HQStructure @version 1.0 
 *    This class is responsible for storing the data structure
 *    Each predefined query by the user.
 *    This class is instantiated from the class HotQueries.
 *  
 *  History:
 *          2013-01-08 The dbName property is added.
 *                     The reason of it is: each database has own queries.
 *                     There are special queries, which may perform for any database.
 *                     They must have dbName property always is equal to "*".
 */
 
package ru.nick_ch.x1.queries;

public class HQStructure {

 protected String  fileName;
 protected String  value;
 protected String  dbName;  // Nick 2013-01-08
 protected boolean run; 

public HQStructure ( String p_file, String p_descrip, boolean p_doIt, String p_dbName ) {
   fileName = p_file;
   value    = p_descrip;
   run      = p_doIt;
   dbName   = p_dbName;
 }

public String getFileName() {
   return fileName;
 }

public String getValue() {
   return value;
 }

public boolean isReady() {
   return run;
 }

public String getdbName() {
	   return dbName;
	 }
} // End of Class
