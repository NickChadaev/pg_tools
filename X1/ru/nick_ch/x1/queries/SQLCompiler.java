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
 *  CLASS SQLCompiler @version 1.0  
 *     This class is responsible for grouping SQL statements
 *     contained in a flat file eliminating spaces
 *     white, tabs and organizing each of the commands separately. 
 *  History:
 *           
 */
 
package ru.nick_ch.x1.queries;

import java.io.*;
import java.util.Vector;

class SQLCompiler {
 Vector Instructions = new Vector();
 String allQ = "";

 SQLCompiler(File file) 
  {
   try 
    { 
     BufferedReader in = new BufferedReader(new FileReader(file));
     int i = 0;
     int k = 0;
     
     while(true)
      { 
        String line = in.readLine();
	if (line == null)
	 break;
	allQ = allQ.concat(line); 
      }       
     while(k != -1)
       { 
         k = allQ.indexOf(";",i);	
         String oneQ = allQ.substring(i,k+1);
	 i = k + 1;
	 oneQ = clearSpaces(oneQ);
	 Instructions.addElement(oneQ);
       }  
    }
    catch(Exception ex)
      {     
      } 
  } 

 public String clearSpaces (String inS)
  {
    String valid = "";

    if((inS.indexOf("  ") != -1) || (inS.indexOf("\t") != -1) || (inS.indexOf("\n" ) != -1))
     {
       int x = 0;
       while (x < inS.length())
        {
	  char w = inS.charAt(x);
	  if (w == '\t'  && ( inS.charAt(x+1) != ' ') && ( inS.charAt(x+1) != '\t') && ( inS.charAt(x+1) != '\n' ))
            valid = valid + " ";
          if (w == '\t'  && (( inS.charAt(x+1) == ' ') || ( inS.charAt(x+1) == '\t') || ( inS.charAt(x+1) == '\n')))
            valid = valid + "";
	  if ( w == ' ' && ( inS.charAt(x+1) != ' ') && ( inS.charAt(x+1) != '\t') && ( inS.charAt(x+1) != '\n'))
            valid = valid + w;
	  if (w == ' '  && (( inS.charAt(x+1) == ' ') || ( inS.charAt(x+1) == '\t') || ( inS.charAt(x+1) != '\n')))
	    valid = valid + "";
	  if ( w == '\n' && ( inS.charAt(x+1) != ' ') && ( inS.charAt(x+1) != '\t') && ( inS.charAt(x+1) != '\n' ))
            valid = valid + " ";
	  if ( w == '\n' && (( inS.charAt(x+1) == ' ') || ( inS.charAt(x+1) == '\t') || ( inS.charAt(x+1) == '\n' )))
	    valid = valid + "";
	  if ( w != ' ' && w != '\t' && w != '\n')
	    valid = valid + w;
	  x++;
        }

    }
   else
     valid = inS;

   while(valid.startsWith(" "))
      valid = valid.substring(1,valid.length());

  return valid;
 }

 public Vector getInstructions()
  {
    return Instructions;
  }

} //Fin de la Clase

