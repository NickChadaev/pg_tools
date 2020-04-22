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
 *  CLASS DBStructure @version 1.0   
 *  History: 2009-05-31  Nick was here.
 *           
 */         

package ru.nick_ch.x1.db;

import java.util.Vector;
import java.util.Hashtable;

public class DBStructure {   

 String    DBname;
 Hashtable HTables = new Hashtable ();
 Vector    Tables;
 boolean   isOpen = false;
 int       numTables;
 
 PGConnection conn;

 public DBStructure () {
   DBname    = "";
   isOpen    = false;
   numTables = 0;
 }

 public DBStructure ( String db, boolean open ) {
     DBname = db;
     isOpen = open;
 }

 public DBStructure ( String db, boolean open, Vector vecTables, PGConnection link ) {
   DBname    = db;
   isOpen    = open;
   Tables    = vecTables;
   numTables = Tables.size();
   conn = link;
   for ( int k = 0; k < numTables; k++ )
     {
        try {
             Object tmp = vecTables.elementAt ( k );   
             Table oneTable = new Table ( tmp.toString () );         
             HTables.put ( tmp.toString (), tmp );       
	    }  
	catch ( Exception e )    
	    {
             System.out.println("Error: " + e);
             e.printStackTrace();
	         System.exit(0);
	    }
     }
 }

 public void setTables ( Vector vecTables ) {
  HTables   = new Hashtable ();
  Tables    = new Vector ();
  numTables = vecTables.size ();
  for ( int k = 0; k < numTables; k++ )
    {
      Table oneTable;
      try {
             oneTable = ( Table ) vecTables.elementAt( k );
             HTables.put( oneTable.Name, oneTable );
             Tables.addElement ( oneTable.Name );
           }
      catch ( Exception e )
         {
           System.out.println ("Error: " + e);
           e.printStackTrace ();
           System.exit (0);
         }
    }
 }

 public Hashtable getTableSet() {
   return HTables;
 }

 public void setNTName ( String oldname, String newName )
  {
   Table tmp = (Table) HTables.get( oldname );
   tmp.Name = newName;
   HTables.remove ( oldname );
   HTables.put ( newName, tmp );
   int pos = Tables.indexOf ( oldname );
   Tables.setElementAt ( newName, pos );
  }

 public Table getTable ( String TabName ) {
  Table tmp = null;
  try {
         tmp = (Table) HTables.get ( TabName );
      }
  catch ( Exception e )
      { 
        System.out.println ( "Error: " + e );
        e.printStackTrace ();
        System.exit (0);
      } 
  return tmp;
 }

 public int NTables () {
   return numTables;
 }

} // Fin de la Clase
