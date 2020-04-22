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
 *  CLASS SQLFunctionDataStruc @version 1.0 
 *   This class defines the data structure containing the
 *   Definition of a function in PostgreSQL SQL itself.
 *   This class is responsible for displaying the help concerning a
 *   PostgreSQL own SQL function.
 *  
 *  History:
 *           
 */
 
package ru.nick_ch.x1.queries;

import ru.nick_ch.x1.idiom.*;
import java.util.Vector;

public class SQLFunctionDataStruc
 {
   int polymorph = 0; 
   Vector dataStruc = new Vector();
   Language idiom;

   public SQLFunctionDataStruc(Language lang)
    {
     idiom = lang;
    }

   public SQLFunctionDataStruc(Language lang,String funcName, String funcRet, String funcDescrip, String funcExample)
    {
     idiom = lang;
     String[] description = new String[4];
     description[0] = funcName; 
     description[1] = funcRet;
     description[2] = funcDescrip;
     description[3] = funcExample;
     dataStruc.addElement(description);
     polymorph = 1;
    }

   public void addItem(String funcName2, String funcRet2, String funcDescrip2, String funcExample2)
    {
     String[] description = new String[4];
     description[0] = funcName2;
     description[1] = funcRet2;
     description[2] = funcDescrip2;
     description[3] = funcExample2;
     dataStruc.addElement(description);
     polymorph++;
    }

   public Vector getFunctionDescrip()
    {
     return dataStruc;
    }

   public String getHtml()
    {
     String th = "<th align=\"center\">";
     String td = "<td align=\"center\">";
     String nth = "</th>";
     String ntd = "</td>";
     String ntable = "</table></html>";
     String tr = "<tr>";
     String std = "<td>";
     String ntr = "</tr>";
     String table = "<html><table border=1>" + tr;
     String url1 = "<a href=\"";
     String url2 = "\">";
     String nurl = "</a>";
     String header = table + th + idiom.getWord("FDNAME") + nth + th + idiom.getWord("FDRETURN") + nth + th + idiom.getWord("FDDESCR") + nth + th + idiom.getWord("FDEXAMPLE") + nth + ntr;

     String data = "";
     data += header;

     for(int k=0;k<polymorph;k++)
      {
       String[] var = (String[]) dataStruc.elementAt(k);
      
       data += tr + td + url1;
       data += var[0];
       data += url2;
       data += var[0];
       data += nurl + ntd + td;
       data += var[1];
       data += ntd + std;
       data += var[2];
       data += ntd + td;
       data += var[3];
       data += ntd + ntr;
      }

     data += ntable;

     return data;
    }

   public String[] getSpecificDescr(int k)
    {
     
     if(k > (dataStruc.size() - 1))
      {
       String[] tmp = {}; 
       return tmp;
      }

     String[] dscrip = (String[]) dataStruc.elementAt(k); 

     return dscrip; 
    }

 }
