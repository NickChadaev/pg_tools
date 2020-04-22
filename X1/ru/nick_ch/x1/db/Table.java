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
 *  CLASS Table @version 1.0   
 *  History:
 * 2009-05-31  Nick Chadaev - nick_ch58@list.ru   
 * 2009-07-21  Nick Chadaev: Two properties was added,
 *                  comment - comment of table,
 *                  is_Xsd  - true, if the table's XML descriptor was created            
 */        
package ru.nick_ch.x1.db;

import java.util.Vector;

public class Table {

 public String Name;

 int    NumRegs;
 Vector Registers;

 public TableHeader base;

 public String      schema;
 public boolean     userSchema;
 
 // Nick
 public String  comment;
 public boolean is_Xrd;

 public Table ( String TName ) {

    this.Name      = TName;
    this.NumRegs   = 0;
    this.Registers = new Vector ();
    this.base      = new TableHeader ();
    this.Registers = new Vector ();
    
    // Nick 2009-07-21
    this.comment = "";
    this.is_Xrd = false ;
  }

 public Table ( String nTable, TableHeader strucTable ) {

	 this.Name = nTable;
	 this.base = strucTable;
	    
     // Nick 2009-07-21
	 this.comment = "";
	 this.is_Xrd = false ;
 }

 public void setComment ( String p_comm ) {
	 this.comment = p_comm;
 }
 
 public String getComment () {
	 return this.comment ;
 }
 
 public void set_is_Xrd ( boolean p_x ) {
	 this.is_Xrd = p_x ;
 }
 
 public boolean get_is_Xrd () {
	 return this.is_Xrd ; 
 }
 
 public void setRegisters ( Vector data ) {
	 this.Registers = data;
  }

 public TableHeader getTableHeader () {
    return this.base;
  }

 public String getName () {
    return this.Name;
  }

 public int getNumRegs () {
    return this.NumRegs;
  }

 public void setSchema ( String schemaName ) {
	 this.schema = schemaName;
  }
                                                                                                                            
 public String getSchema () {
	 return this.schema;
  }

 public void setSchemaType ( boolean schemaType ) {
	 this.userSchema = schemaType;
  }

 public boolean isUserSchema () {
    return this.userSchema;
  }

} // Fin de la Clase
