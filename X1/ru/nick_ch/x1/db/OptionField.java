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
 *  CLASS OptionField @version 1.0   
 *  History:
 *          2012-07-06 Nick - Type category was added. 
 */        
package ru.nick_ch.x1.db;

import ru.nick_ch.x1.utilities.*;

public class OptionField {

 private String dataType;
 private int categType ;
 
 private int    fieldLong;
 private int    fieldPrec;
 
 private boolean isNull;
 
 private boolean PrimaryKey;
 private boolean UnicKey;
 private boolean ForeingKey;
 
 private String DefaultValue = null;
 
 private String TableRef;
 private String FieldRef;
 private String Check="";

 public OptionField ( String TypeF, int pcategType, int pFieldLen, int pPrecLen, 
		              boolean isN, boolean pK, boolean uK, 
		              boolean fK, String dV ) 
  {
   dataType  = TypeF.toLowerCase().trim();
   categType = pcategType;

   fieldLong = pFieldLen;
   fieldPrec = pPrecLen; // Nick 2012-07-07
   
   isNull     = isN;
   PrimaryKey = pK;
   UnicKey    = uK;  
   ForeingKey = fK;
   
   DefaultValue = dV.trim(); // Nick 2012-07-06
 }
 
 public void setRefVal ( String TableR, String FieldR )
  {
   TableRef = TableR;
   FieldRef = FieldR;
  }

 public int getFieldLong()
  {
    return fieldLong;
  }

 public int getFieldPrec ()
 {
   return fieldPrec;
 }
 
 public boolean isNullField()
  {
    return isNull;
  }

 public boolean isPrimaryKey()
  {
    return PrimaryKey;
  }

 public boolean isUnicKey()
  {
    return UnicKey;
  }

 public boolean isForeingKey()
  {
    return ForeingKey;
  }

 public String getDefaultValue()
  {
   return DefaultValue;
  }

 public String getTableR()
  {
   return TableRef;
  }

 public String getFieldR()
  {
   return FieldRef;
  }
/**
 *  @author Nick 2012-07-09
 *  set CHECH clause for field
 * @return void
 */
 public void setCheck ( String pCheck ){
	 this.Check = pCheck;
 }
 
 public String getCheck()
  {
   return Check;
  }
/**
 *  @author Chadaev Nick
 *  @version 2012-07-06
 *  This method returns category of type
 */
 public int getCategType () {
	 return this.categType;
 }
 /**
  *  @author Chadaev Nick
  *  @version 2012-07-06
  *  This method returns the DB type
  */
  public String getDbType () {
 	 return this.dataType;
  }
 } // Fin de la clase
