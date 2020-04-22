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
 *  CLASS TableFieldRecord @version 1.0   
 *  History:
 *  Mod:   2009-07-08  Nick, new variable "Comment" was added   
 *         2012-07-06  Nick, type of visibility of class variables 
 *                     is changed.                           
 *           
*/
package ru.nick_ch.x1.db;

import ru.nick_ch.x1.utilities.ChkType;

public class TableFieldRecord {

  /*
   *  Attention, the Type was defined twice: here and in the OptionField class.	
   */
	
  private String Name;
  private String Type;
  private int    CategType; // The category of type.
  private String Comment;
 
  private OptionField options;

  public TableFieldRecord ( String NameField, String NameType, OptionField opc )
   {
    this.Name      = NameField.trim();
    this.Type      = NameType.trim();
    this.CategType = ChkType.getCategType ( Type);
    this.options = opc;
   }

  public TableFieldRecord ( String NameField, String NameType, String NameComment, OptionField opc )
  {
   this.Name = NameField.trim();
   this.Type = NameType.trim();
   this.Comment = NameComment.trim();
   this.options = opc;
  }
  
  public String getName ()
   {
    return this.Name;
   }

  public String getType ()
   {
    return this.Type;
   }

  public String getComment ()
   {
    return this.Comment;
   }
  
  public OptionField getOptions ()
   {
    return this.options;
   }
  
  /**
   *  @author Chadaev Nick
   *  @version 2012-07-06
   *  This method returns category of type
   */
  public int getCategType () {
  	 return this.CategType;
   }
} // Fin de la Clase
