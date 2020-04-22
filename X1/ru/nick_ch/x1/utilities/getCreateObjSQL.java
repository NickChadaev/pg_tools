/**
 * This software is free according GNU GENERAL PUBLIC LICENSE and
 * based on the XPg project, developed by KAZAK Solutions. 
 * Research and Development Group of Free Software, 
 * Santiago de Cali Republic of Colombia 2001.
 * Author:
 *          Gustavo Gonz�lez <xtingray@kazak.com.co>.                   
 * ----------------------------------------------------------------------------
 * Now this software is developing for modern version of PostgreSQL.
 * Author: 
 *          Nick Chadaev <nick_ch58@list.ru>. Moscow, Russia. Single developer.
 *          New stage of developing had been started at 2009-06-16. 
 * ----------------------------------------------------------------------------
 *  CLASS getCreateObjSQL @version 1.0 
 *     The single method of this class which creates the text string containing 
 *     the CREATE TABLE clause. The text string is created of internal representation 
 *     of the DB table. Internal representation is an object of class Table.
 *
 * Created: 2012/02/16 Nikolay Chadaev  
 *  History:
 *           
 */

package ru.nick_ch.x1.utilities;

import ru.nick_ch.x1.db.Table;
import ru.nick_ch.x1.db.TableFieldRecord;
import ru.nick_ch.x1.db.TableHeader;

public class getCreateObjSQL {

	private static String l_SQL;	
	
    public getCreateObjSQL () {
		
		super ();
    } // End of constructor
    
    public static String createTableSQL ( Table currentTable ) {

    	   l_SQL = "CREATE TABLE " + currentTable.getName () + " (\n";
    	   //Nuevos datos de la tabla
    	   TableHeader headT = currentTable.getTableHeader ();
    	   int numFields = headT.getNumFields ();

    	   for ( int k = 0; k < numFields; k++ ) {

    	      Object o = (String) headT.getNameFields().elementAt( k );
    	      String field_name = o.toString();
    	      TableFieldRecord tmp = (TableFieldRecord) headT.hashFields.get( field_name );
    	      l_SQL += tmp.getName() + " ";

    	      // Attention !!! Commented clause must be INSTEAD tmp.getType  Nick 2012-08-11
    	      // tmp.getOptions().getDbType()
    	      String typeF = tmp.getType();

    	      if ("char".equals(tmp.getType())  || "varchar".equals(tmp.getType())) {

    	          int longStr = tmp.getOptions().getFieldLong(); // 2014-10-23 Nick  -- getCharLong()

    	          if (longStr>0)
    	              typeF = tmp.getType() + "(" + tmp.getOptions().getFieldLong() + ")";  // 2014-10-23 Nick  -- getCharLong()
    	          else
    	              typeF = tmp.getType();
    	       }

    	      l_SQL += typeF + " ";

    	      Boolean tmpbool = new Boolean(tmp.getOptions().isNullField());

    	      if (tmpbool.booleanValue())
    	          l_SQL += "NOT NULL ";

    	      String defaultV = tmp.getOptions().getDefaultValue();

    	      if (defaultV.endsWith("::bool")) {

    	          if (defaultV.indexOf("t")!=-1)
    	              defaultV = "true";
    	          else
    	              defaultV = "false";
    	       }

    	      if ( defaultV.length() > 0 ) l_SQL += " DEFAULT " + defaultV;
    	      if ( k < numFields-1 ) l_SQL += ",\n";
    	   }

    	   l_SQL += "\n);";

    	   return l_SQL;
    	 }

} // Fin de la classe.
