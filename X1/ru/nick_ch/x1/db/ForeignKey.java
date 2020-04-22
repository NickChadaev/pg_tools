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
 *  CLASS ForeignKey @version 1.0   
 *  History:
 *           
 */
package ru.nick_ch.x1.db;

public class ForeignKey {

  String foreignKeyName = "unnamed";
  String foreignTable = "";
  String opt = "UNSPECIFIED";
  String localField = "";
  String foreignField = "";

  public ForeignKey(String fkn,String tf,String option,String f,String ff) {

    if(!fkn.startsWith("$1") || !fkn.startsWith("unnamed"))
      foreignKeyName = fkn;

    if(!option.startsWith("UNSPECIFIED"))
      opt = option;

    foreignTable = tf;
    localField = f;
    foreignField = ff;
  }

 public String getForeignKeyName() {
   return foreignKeyName;
  }

 public String getForeignTable() {
   return foreignTable;
  }

 public String getOption() {
   return opt;
  }

 public String getForeignField() {
   return foreignField;
  }

 public String getLocalField() {
   return localField;
  }

}

