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
 *  CLASS SQLFuncBasic @version 1.0  
 * 		This class contains the data structure on the help of the instructions
 * 		Basic SQL.
 *
 *  History:
 *           
 */
 
package ru.nick_ch.x1.queries;

import ru.nick_ch.x1.idiom.Language;

public class SQLFuncBasic
 {
   int polymorph = 0; 
   Language idiom;
   String[] description = new String[3];

   public SQLFuncBasic(Language lang)
    {
     idiom = lang;
    }

   public SQLFuncBasic(Language lang, String commandName, String commandDescrip, String commandSyntax)
    {
     idiom = lang;

     description[0] = commandName; 
     description[1] = commandDescrip;
     description[2] = commandSyntax;
    }

   public String[] getFunctionDescrip()
    {
     return description;
    }

   public String getHtml()
    {
     String th = "<th align=\"center\">";
     String td = "<td align=\"center\">";
     String nctd = "<td align=\"left\">";
     String nth = "</th>";
     String ntd = "</td>";
     String ntable = "</table></html>";
     String tr = "<tr>";
     String std = "<td>";
     String ntr = "</tr>";
     String table = "<html><table border=1>" + tr;
     String nurl = "</a>";

     String header = table + th + idiom.getWord("FDNAME") + ": " + description[0] + nth + ntr;

     String data = "";
     data += header;

     data += tr + td;
     data += "<b>" + idiom.getWord("FDDESCR") + ":</b> " + description[1];
     data += ntd + ntr;

     data += tr + nctd;
     data += "<b>" + idiom.getWord("SYNT") + ":</b><br>" + description[2];
     data += ntd + ntr;

     data += ntable;

     return data;
    }

 }
