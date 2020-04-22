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
 *  CLASS UpdateDBTree @version 1.0   
 *  History:
 *          Nick Chadaev - nick_ch58@list.ru
 *                         2009-07-16                    
 *          Some mistakes was corrected.           
 */
 
package ru.nick_ch.x1.misc.input;

import java.util.Vector;

import javax.swing.JTextArea;

import ru.nick_ch.x1.db.ConnectionInfo;
import ru.nick_ch.x1.db.PGConnection;
import ru.nick_ch.x1.idiom.Language;

public class UpdateDBTree {

 public Vector validDB = new Vector();
 public Vector vecConn = new Vector();

 Vector         listDB;
 PGConnection   conn;
 Language       idiom;
 ConnectionInfo user;
 boolean        killing = false;
 JTextArea      LogWin;

 public UpdateDBTree ( JTextArea log, Language lang, PGConnection pgconn, Vector DBs ) {

   LogWin = log;
   idiom  = lang;
   conn   = pgconn;
   user   = conn.getConnectionInfo ();
   listDB = DBs;
   makeSearch ();
 }

 public void makeSearch ()  {

  Vector tables;
  int numDB = listDB.size ();

  if ( numDB > 0 ) {

      for ( int i = 0; i < numDB; i++ ) {

           Object o = listDB.elementAt ( i );
           String dbname = o.toString ();
           addTextLogMonitor ( idiom.getWord ( "LOOKDB" ) + ": \"" + dbname + "\"... " );
           ConnectionInfo tmp = new ConnectionInfo ( user.getHost (), dbname, user.getUser (), 
        		                                     user.getPassword (), user.getPort (), user.requireSSL ()
           ); 
           PGConnection proofConn = new PGConnection ( tmp, idiom ); 

           if ( !proofConn.Fail () ) {

               addTextLogMonitor ( idiom.getWord ( "OKACCESS" ) );

               if ( !dbname.equals ( "template1" ) || !dbname.equals ( "template0" ) ) { 
            	                                             // !dbname.equals ( "postgres" ) Nick 2009-07-16 
                   vecConn.addElement ( proofConn );
                   validDB.addElement ( listDB.elementAt (i) );                     
                }
            }
           else
                addTextLogMonitor ( idiom.getWord ("NOACCESS") );       
        }//fin del for
   } // numDB > 0
 } // makeSearch ()

 public Vector getDatabases () {
   return validDB;
 }

 public Vector getConn () {
   return vecConn;
 }

 /**
  * Metodo addTextLogMonitor
  * Imprime mensajes en el Monitor de Eventos
  */
 public void addTextLogMonitor ( String msg ) {

   LogWin.append ( msg + "\n" );	
   int longiT = LogWin.getDocument ().getLength ();

   if ( longiT > 0 ) LogWin.setCaretPosition ( longiT - 1 );
  }

} //Fin de la Clase 
