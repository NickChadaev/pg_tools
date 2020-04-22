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
 *  CLASS ReportMaker @version 1.0  
 *    Class responsible for handling the dialog that displays,
 *    save and print a report. 
 *  History:
 *           
 */

package ru.nick_ch.x1.report;

import java.io.FileOutputStream;
import java.io.PrintStream;
import java.util.Vector;

import javax.swing.JTextArea;

import ru.nick_ch.x1.idiom.Language;

public class ReportMaker {

 String pageData = "";
 HtmlProperties html;
 JTextArea LogWin; 
 Language idiom;
 Vector namesFVector;
 boolean noBrowsers = false;

 public ReportMaker(String path,String pattern,String numPerPage,Language leng,Vector names,Vector data,int[] posic,Vector combox,HtmlProperties properties,JTextArea lw)
  {
   html = properties;
   LogWin = lw;
   idiom = leng;
   namesFVector = (Vector) names.clone();
   Vector pages = new Vector();
   Double doub = new Double(numPerPage); 
   double p = Math.ceil(data.size()/doub.doubleValue());
   int cycles = (int)p * 1;
   int npages  = new Integer(numPerPage).intValue();

   int bottom = 0;
   int top = npages;
   String fileName="";

   for(int j=0;j<cycles;j++)
    {
     String fileN = "";;

     if(j!=0)
        fileN = path + pattern + "-" + j + ".html";
     else
      {
       fileN = path + pattern + ".html";
       fileName = fileN;
      }

     try {
          addTextLogMonitor(idiom.getWord("REPCR") + fileN);

          PrintStream fileLog = new PrintStream(new FileOutputStream(fileN));
          fileLog.print("<!-- " + idiom.getWord("HCRE") + " -->\n");
          fileLog.print(formatter(cycles,j,pattern,bottom,top,names,data,posic,combox,html));
          fileLog.close();
         }
       catch(Exception ex)
        {
         System.out.println("Error: " + ex);
         ex.printStackTrace();
        }

       bottom = top;
       top = npages * (j + 2);

       if(top > data.size())
          top = data.size(); 
    }

   String OS = System.getProperty("os.name");

   try {
        addTextLogMonitor(idiom.getWord("OBR"));

        if (OS.equals("Linux") || OS.equals("Solaris") || OS.equals("FreeBSD"))
            try {
                  Runtime.getRuntime().exec("mozilla file://" + fileName);
                  addTextLogMonitor(idiom.getWord("TRYING") + " mozilla...");
             }
            catch(Exception xp) {
                  try {
                      Runtime.getRuntime().exec("konqueror file://" + fileName);
                      addTextLogMonitor(idiom.getWord("TRYING") + " konqueror...");
                    }
                   catch(Exception xp2) {
                         try {
                              Runtime.getRuntime().exec("opera file://" + fileName);
                              addTextLogMonitor(idiom.getWord("TRYING") + " opera...");
                            }
                           catch(Exception xp3) {

                                 try {
                                       Runtime.getRuntime().exec("nautilus file://" + fileName);
                                       addTextLogMonitor(idiom.getWord("TRYING") + " nautilus...");
                                  }
                                 catch(Exception xp4) {
                                       noBrowsers = true;
                                       addTextLogMonitor("Error: " + idiom.getWord("NBFOUND"));
                                                      }
                                                }
                                        }
                              }

        if (OS.startsWith("Windows"))
            try {
                 Runtime.getRuntime().exec("start netscape " + fileName);
                 addTextLogMonitor(idiom.getWord("TRYING") + " netscape...");
             }
            catch (Exception xp) {
                   try {
                        Runtime.getRuntime().exec("start iexplore " + fileName);
                        addTextLogMonitor(idiom.getWord("TRYING") + " explorer..."); 
                    }
                   catch (Exception xp2) {
                          noBrowsers = true;
                          addTextLogMonitor("Error: " + idiom.getWord("NBFOUND"));
                                         }
                                }
      }
    catch(Exception ex) {
                          System.out.println("Error: " + ex);
                          ex.printStackTrace();
                         } 
 }


 public String formatter(int cycles,int indexPage,String pattern,int bottom,int top,Vector columns,Vector data,int[] posic,
                         Vector combox,HtmlProperties properties) {

  boolean results = false;

  for (int m=0;m<combox.size();m++) {

       String operation = (String) combox.elementAt(m);
       if (!operation.equals("0")) {
           results = true;
           break;
        }
   }

  String font = "<font face=arial,helvetica size=3>";

  pageData = "<html>\n";

  pageData += "<head>\n<style type=\"text/css\">\n";

  pageData += properties.getGlobalProperties();

  pageData += properties.getThProperties();

  pageData += "p.title {\n         text-align:center;\n         font-size:18pt;\n}\n\n";

  pageData += properties.getHeaderAttrib();

  pageData += "p.text {\n        text-align:justify;\n        font-size:8pt;\n        font-family:courier;\n}\n\n";

  pageData += properties.getDataAttrib();

  pageData += properties.getLinksAttrib();

  pageData += properties.getFooterAttrib();

  pageData += "</style>\n";

  pageData += "<title>" + properties.getTheTitle() + "</title>";

  pageData += "</head>\n";

  pageData += "<body><br>\n<blockquote><blockquote>\n";

  String links = "";

  if (cycles > 1) {
      links += getLinks(cycles,pattern,indexPage);
      pageData += links;
   }

  if(properties.getHeader().length()>0)
     pageData += "<b>" + properties.getHeader() + "</b>\n";

  pageData += "<center>\n" + "<table border=\"" + properties.getTableBorder() + "\" width=\"" + properties.getTableWidth() 
           + "\" cellspacing=\"" + properties.getSpacePadding() + "\">\n <tr>\n";

  for (int i=0;i<columns.size();i++) {
       String fieldName = (String) namesFVector.elementAt(i);
       pageData += "   <th>" + fieldName.toUpperCase() + "</th>\n";
   }

  pageData += " </tr>\n";

  int[] counters = new int[columns.size()];

  if (top > data.size())
      top = data.size(); 

  for (int i=bottom;i<top;i++) {

       Vector row = (Vector) data.elementAt(i);
       pageData += "<tr>\n";

       for (int m=0;m<columns.size();m++) {
            String value;
            String operation = (String) combox.elementAt(m);
            Object o = row.elementAt(posic[m]);

            if (o != null)
                value = o.toString();
            else
                value = "NULL";

            pageData += "  <td class=\"data\">" + value + "</td>\n";

            if (operation.equals("0"))
                counters[m] = -1;

            if (operation.equals("1") || operation.equals("2"))
                counters[m] += Integer.parseInt(value);
        }
   }

  if (results) {

      pageData += "<tr>\n";

     for (int m=0;m<combox.size();m++) {

          String operation = (String) combox.elementAt(m);

          if (operation.equals("0")) 
              pageData += "<td>" + "</td>\n";

          if (operation.equals("1")) 
              pageData += "<td>" + idiom.getWord("TOTAL") + ": " + counters[m] + "</td>\n";

          if (operation.equals("2")) 
              pageData += "<td>" + idiom.getWord("AVER") + ": " + counters[m]/data.size() + "</td>\n";

      } // fin for
    } // fin if

  pageData += "</table>\n";

  if (properties.getFooter().length()>0)
      pageData += properties.getFooter() + "\n";

  if (cycles > 1)
      pageData += links;

  pageData += "</blockquote></blockquote>\n</body></html>"; 

  return pageData;
}

public String getLinks(int cycles, String pattern, int indexPage) {

    String pageD = "<table border=0 width=30% align=\"center\">\n<tr>\n";
    String link = "";

    if (indexPage > 0) {

        int indexPre = indexPage - 1;
        String preLink = "";

        if (indexPre == 0)
            preLink = pattern;
        else
            preLink = pattern + "-" + indexPre;

        link = preLink + ".html";
        pageD += "<td class=\"links\" width=33%><a href=\"" + link + "\">" + "Previous" + "</a></td>\n";

        link = pattern + ".html";
        pageD += "<td class=\"links\" width=33%><a href=\"" + link + "\">" + idiom.getWord("INI") + "</a></td>\n";
     }

    if (indexPage < cycles-1) {
        indexPage++;
        link = pattern + "-" + indexPage + ".html";
        pageD += "<td class=\"links\" width=33%><a href=\"" + link + "\">" + idiom.getWord("NEXT") + "</a></td>\n";
     }

    pageD += "</tr></table>";

    return pageD;
}


 /**
  * Metodo isFail 
  * retorna falso si no se encuentra un navegador 
  */
 public boolean isFail() {
    return noBrowsers;
  }

 /**
  * Metodo addTextLogMonitor
  * Imprime mensajes en el Monitor de Eventos
  */
 public void addTextLogMonitor(String msg)
  {
   LogWin.append(msg + "\n");
   int longiT = LogWin.getDocument().getLength();

   if(longiT > 0)
      LogWin.setCaretPosition(longiT - 1);
  }

}
