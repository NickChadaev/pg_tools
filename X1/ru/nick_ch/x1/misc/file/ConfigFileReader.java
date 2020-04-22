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
 *  CLASS ConfigFileReader @version 1.0  
 *    This class is responsible for opening the configuration file of
 *    aplicaciï¿½n and read data from it.
 *    Objects of this type are created from the class ConnectionDialog 
 *  History:
 *       2009-11-17 Nick  Interface  file_consts was added    
 *           
 */

package ru.nick_ch.x1.misc.file;

import java.io.File;
import java.io.FileOutputStream;
import java.io.PrintStream;
import java.io.RandomAccessFile;
import java.util.StringTokenizer;
import java.util.Vector;

import ru.nick_ch.x1.db.ConnectionInfo;
// import ru.nick_ch.x1.utilities.Path;

public class ConfigFileReader implements File_consts {

 boolean          thereIsLast = false;
 boolean          thereIsData = false;
 RandomAccessFile ConfigFile;

 Vector          ListRegisters = new Vector();
 ConnectionInfo  selected;
 String          election = sTOKEN_3; // Nick 2009-12-08 
 int             posChamp = 0;

 /**
  * METODO CONSTRUCTOR
  * Abre el archivo de configuraciï¿½n, si no existe lo crea.
  */
 
 public ConfigFileReader(){
  }

 public ConfigFileReader ( String fileX, int oper ) {

  File varfile = new File ( fileX );

  if ( varfile.exists () && varfile.isFile () ) {
	  
      try {
            ConfigFile = new RandomAccessFile ( fileX, "r" ); //Abrir el archivo para lectura
            String firstLine  = ConfigFile.readLine();        //Leer la primera linea
            String secondLine = ConfigFile.readLine();        //Leer la segunda linea     	      

            if ( firstLine.startsWith ( vLANGUAGE ) && secondLine.startsWith ( vSERVER )) {

     	        thereIsData = true;  //Encontrï¿½ datos en el archivo
     	        ConfigFile.seek (0); 

     	        if ( oper == 0 ) getData();	
     	        if ( oper == 1 ) getLanguage();
    	        if ( oper == 2 ) ReplyData();
             }

            ConfigFile.close();
        }
      catch ( Exception e ) {
                System.out.println ( "Error: " + e );
                e.printStackTrace ();
         }	    
    }	    
   else
      	Create_File ( fileX );
 }

 /**
  * Mï¿½todo getLanguage()
  * Lee la primera lï¿½nea del archivo de configuraciï¿½n referente al idioma
  */ 
 public void getLanguage() {

    try {
          String idiom = ConfigFile.readLine();	
          StringTokenizer st = new StringTokenizer ( idiom, sTOKEN_1 );
          idiom = st.nextToken ();
          idiom = st.nextToken ();                                                         
          election = idiom;
      }
    catch ( Exception e) {
             System.out.println ("Error: " + e);
             e.printStackTrace ();
       }
  }

 /**
  * METODO getIdiom
  * Retorna la cadena que indica el idioma leido 
  * del archivo de configuraciï¿½n
  */  
  public String getIdiom () {
       return election;
  }

 /**
  * METODO getData
  * Recorre el archivo de configuraciï¿½n creando un arreglo
  * de Objetos ConnectionInfo (registros de conexiï¿½n).
  */
 public void getData () {

    String [] parameters = new String [6]; 
    ListRegisters = new Vector(); 
    // String line ;
    int j = 0;

    try {
           String idiom = ConfigFile.readLine(); // Nick 2009-12-11	
         do {
              for ( int i = 0; i < 6; i++ ) { 
                   String line = ConfigFile.readLine();
                   StringTokenizer st = new StringTokenizer ( line, sTOKEN_1 );  
                   line = st.nextToken();
                   parameters[i] =  st.nextToken();
               }
              
              boolean ssl = Boolean.getBoolean ( parameters [4] );
              
              if ( parameters[5].startsWith ( sTOKEN_2 ) ) {
                  posChamp = j;
                  thereIsLast = true;
                  selected = new ConnectionInfo ( parameters [0],parameters [1],parameters [2],
                		                  Integer.parseInt ( parameters [3]), ssl, parameters [5]
                  );
               }

              ConnectionInfo OneRegister = new ConnectionInfo ( parameters [0], parameters [1],
            		         parameters [2], Integer.parseInt (parameters [3]), ssl, parameters [5]
              );
              ListRegisters.addElement ( OneRegister );
              j++;
           } while ( ConfigFile.getFilePointer() < ConfigFile.length() ); 

         }
       catch ( Exception e) {

             System.out.println("Error: " + e);
             e.printStackTrace();
         }
 }

 /**
  * METODO Create_File
  * Cuando el archivo de configuraciï¿½n no existe se crea uno
  * preliminar.
  */
 public void Create_File ( String ConfigFile ) {

    try {
    	//Diego cambio el configFile 
         PrintStream outStream = new PrintStream ( new FileOutputStream ( ConfigFile ) );

         outStream.println ( xLANGUAGE );
         outStream.println ( xSERVER );
	     outStream.println ( xDATABASE );         
	     outStream.println ( xUSERNAME );
	     outStream.println ( xPORT );
         outStream.println ( xSSL );
	     outStream.println ( xLAST );
	     outStream.close ();
	 
	     posChamp = 0;

	     thereIsLast = true;
	     selected = new ConnectionInfo ( sSERVER, sDATABASE, sUSERNAME, sPORT, false, sTOKEN_2 );
	     ConnectionInfo OneRegister = selected;
         ListRegisters.addElement ( OneRegister );//El unico registro serï¿½ el creado actualmente
       }

      catch ( Exception e ) {
           System.out.println ( "Error: " + e );
           e.printStackTrace ();
      }
 }

 /*****
  * METODO FoundLast
  * Retorna un booleano que indica si se encontrï¿½ la bandera del
  * ï¿½ltimo registro o no.
  */
 public boolean FoundLast () {
  	return thereIsLast;
 }	

 /**
  * METODO CompleteList
  * Retorna el vector de registros que se formï¿½ con el archivo de
  * configuraciï¿½n.
  */  
 public Vector CompleteList() {
   return ListRegisters;
 }

 /**
  * METODO getChampion
  * Retorna el registro del que se eligiï¿½ como ï¿½ltima conexiï¿½n exitosa.
  */  
 public ConnectionInfo getRegisterSelected() {
   return selected; 	       
 }  	       

 /**
  * METODO getPosCham
  * Retorna la posiciï¿½n en el vector de registros del que es el 
  * ï¿½ltimo usado anteriormente.
  */   
 public int getPosCham() {
   return posChamp;
 }

 public void ReplyData () {

   String[] parameters = new String[6]; 
   ListRegisters = new Vector(); 
   int j = 0;

   try {
         String idiom = ConfigFile.readLine();	

         do {
              for ( int i = 0; i < 6; i++ ) {
                   String line = ConfigFile.readLine ();
                   StringTokenizer st = new StringTokenizer ( line, sTOKEN_1 );
                   line = st.nextToken();
                   parameters[i] =  st.nextToken();                                                         
                }
              boolean ssl = Boolean.getBoolean ( parameters[5] );
              ConnectionInfo OneRegister = 
            	  new ConnectionInfo ( parameters[0], parameters[1], parameters[2], 
            			  Integer.parseInt (parameters[3]), ssl, parameters[5] 
                      );
              ListRegisters.addElement ( OneRegister );
              j++;
            } while ( ConfigFile.getFilePointer() < ConfigFile.length() ); 
     }
   catch ( Exception e ) {
        
	     System.out.println ( "Error: " + e );
         e.printStackTrace ();
       }
 }
 
} // Fin de la Clase
