/**
 * This software is free according GNU GENERAL PUBLIC LICENSE and
 * based on the XPg project, developed by KAZAK Solutions. 
 * Research and Development Group of Free Software, 
 * Santiago de Cali Republic of Colombia 2001.
 * Author:
 *          Gustavo GonzÀlez <xtingray@kazak.com.co>.                   
 * ----------------------------------------------------------------------------
 * Now this software is developing for modern version of PostgreSQL.
 * Author: 
 *          Nick Chadaev <nick_ch58@list.ru>. Moscow, Russia. Single developer.
 *          New stage of developing had been started at 2009-06-16. 
 * ----------------------------------------------------------------------------
 *  CLASS BuildConfigFile @version 1.0   
 *    This class is responsible for modifying the file
 *    configuration of application. In this file are saved
 *    last successful data connections with a true flag on
 *    the last connection used.
 *    Objects of this type are created from the class XPG
 *  History:
 *    2009-11-17 Nick  Interface  file_consts was added
 *           
 */

package ru.nick_ch.x1.misc.file;

import java.io.File;
import java.io.FileOutputStream;
import java.io.PrintStream;
import java.util.Vector;

import ru.nick_ch.x1.db.ConnectionInfo;
import ru.nick_ch.x1.utilities.*;

public class BuildConfigFile implements File_consts {

 PrintStream configFile;
 int pos;

 /**
  * METODO CONSTRUCTOR, 1ra. Opción
  * Escribe de nuevo el archivo de configuración cambiando la bandera 
  * que indica cual fue el registro que logró la última conexión
  */
 public BuildConfigFile ( Vector ListRegs, int num, String idiom ) {

  pos = num;
  init ();
  configFile.println ( vLANGUAGE + idiom );     
  
  for ( int i = 0; i < ListRegs.size(); i++ ) {
     boolean onlyone;
     
     ConnectionInfo tmp = ( ConnectionInfo ) ListRegs.elementAt(i); 
   
     configFile.println ( vSERVER   + tmp.getHost() );
     configFile.println ( vDATABASE + tmp.getDatabase() );
     configFile.println ( vUSERNAME + tmp.getUser() );
     configFile.println ( vPORT     + tmp.getPort() );
     configFile.println ( vSSL      + tmp.requireSSL() );
     
     if( i == pos ) onlyone = true; else onlyone = false;

     configFile.println ( vLAST + onlyone ); 
   }
     configFile.close();
 }

 /**
  * METODO CONSTRUCTOR, 2da. Opción
  * Escribe de nuevo el archivo de configuración agregando los 
  * datos de una nueva configuración exitosa.
  */
 public BuildConfigFile ( Vector ListRegs, ConnectionInfo online, String idiom ) {

    init();
    configFile.println ( vLANGUAGE + idiom );     

    for ( int i = 0; i < ListRegs.size(); i++ ) {
         
    	// boolean onlyone; Nick 2009-11-17
         
         ConnectionInfo tmp = (ConnectionInfo) ListRegs.elementAt(i);
         configFile.println ( vSERVER   + tmp.getHost());
         configFile.println ( vDATABASE + tmp.getDatabase());
         configFile.println ( vUSERNAME + tmp.getUser());
	     configFile.println ( vPORT     + tmp.getPort());
         configFile.println ( vSSL      + tmp.requireSSL());
         configFile.println ( yLAST );
       }
    
    configFile.println ( vSERVER   + online.getHost());
    configFile.println ( vDATABASE + online.getDatabase());
    configFile.println ( vUSERNAME + online.getUser());
    configFile.println ( vPORT     + online.getPort());
    configFile.println ( vSSL      + online.requireSSL());
    configFile.println ( xLAST );
    configFile.close();
 }

 /**
  *  Método init
  *  Abre el archivo de configuración para escritura
  *  2009-12-11 Nick 
  */
 public void init() {
	 
  try {
        String configPath = UHome.getUHome ( System.getProperty ( cSYS_OS_NAME ) ) + CFG_NAME;
        configFile = new PrintStream ( new FileOutputStream ( configPath ) );
      }
  catch ( Exception ex ) {
          System.out.println ( "Error: " + ex );
          ex.printStackTrace ();
      }
 } // Init
} // Class





