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
 *  CLASS TableHeader @version 1.0   
 *  History:   Mod: 2009-07-06  Nick 
 */

package ru.nick_ch.x1.db;

import java.util.Vector;
import java.util.Hashtable;

public class TableHeader {

  public Vector fields = new Vector();
  public Hashtable hashFields = new Hashtable();
  
  public int NumFields;

  public TableHeader() {
      this.NumFields = 0;
  }

  public TableHeader ( Vector columns ) {
    
	NumFields = columns.size();    
    
	for ( int k = 0; k < NumFields; k++ )
     {
       TableFieldRecord tmp = ( TableFieldRecord )columns.elementAt (k);
       hashFields.put ( tmp.getName (), tmp );
       fields.addElement ( tmp.getName() );
     }
  }

  public String getType ( String oneColumn ) {
   
	String Type = "";
    TableFieldRecord tmp = ( TableFieldRecord ) hashFields.get ( oneColumn );
    Type = tmp.getType (); 
    
    return Type;
  }

  public TableFieldRecord getTableFieldRecord ( String nameColumn ) {
   
	TableFieldRecord tmp = ( TableFieldRecord ) hashFields.get ( nameColumn );
    
	return tmp;
  }

  public Vector getNameFields () {
    
	  return fields;
  }

  public int getNumFields () {
    
	  return NumFields;
  }

  public Hashtable getHashtable () {
    
	  return hashFields;
  }

} // Fin de la Clase
