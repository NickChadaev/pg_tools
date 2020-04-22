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
 *
 * CLASS InputOutput @version 0.1                                                   
 *       Basic I/O operation on file system.
 * Created: Nick 2013-06-04                
 */
package ru.nick_ch.x1.misc.input;

import java.io.*;
import java.util.*;
import ru.nick_ch.x1.db.TableHeader;

public class PrintOuput {

	public PrintOuput() {
		// TODO Auto-generated constructor stub
	}
	 public static void printFile(PrintStream xfile,Vector registers,Vector FieldNames,String Separator,TableHeader theader) {

		    Vector types = new Vector();

		    try {
		          int TableWidth = FieldNames.size();

		          for (int p=0;p<TableWidth;p++) {

		               String column = (String) FieldNames.elementAt(p);
		               types.addElement(theader.getType(column));
		               xfile.print(column);

		               if (p<TableWidth-1)
		                   xfile.print(Separator);
		           }

		          xfile.print("\n");

		          for (int p=0;p<registers.size();p++) {

		               Vector rData = (Vector) registers.elementAt(p);

		               for (int i=0;i<TableWidth;i++) {

		                    Object o = rData.elementAt(i);
		                    String Stype = (String) types.elementAt(i);
		                    String field = "null";

		                    if (o != null) {

		                        if (Stype.startsWith("varchar") || Stype.startsWith("name") || Stype.startsWith("text"))
		                            field = o.toString();

		                        if (Stype.startsWith("int")) {
		                            Integer ipr = (Integer) o;
		                            field = "" + ipr;
		                         }

		                        if (Stype.startsWith("float") || Stype.startsWith("decimal")) {
		                            Integer ipr = (Integer) o;
		                            field = "" + ipr;
		                         }

		                        if (Stype.startsWith("bool")) {
		                            Boolean bx = (Boolean) o;
		                            field = "" + bx;
		                         }

		                      }

		                    xfile.print(field);

		                    if (i<TableWidth-1)
		                        xfile.print(Separator);

		                 } // fin for

		                xfile.print("\n");
		            } // fin for

		          xfile.close();
		        }
		       catch(Exception e) { 
		             System.out.println("Error: " + e); 
		             e.printStackTrace();
		        }
		 }
}
