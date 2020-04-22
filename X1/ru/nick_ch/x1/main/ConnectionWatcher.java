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
 *  CLASS ConnectionWatcher @version 1.0   
 *        This is supervisor of TCP connection for Thr PostgreSQL DB.
 *  History:
 *          2009-05-31  Nick was here. 
 */  

package ru.nick_ch.x1.main;

import java.net.Socket;

public class ConnectionWatcher extends Thread {

 X1      App;
 Socket  online;
 boolean keep; 
 String  hostname;
 int     num_port;

public ConnectionWatcher(String host, int port, X1 frame) {
  App      = frame;
  hostname = host;
  num_port = port;
  online   = null;
  keep     = true;
 }

public void run() {
	
  while(keep) {

    try {
         online = new Socket ( hostname, num_port );
         online.close();
     }		   
    catch( Exception ex ){
	      App.connectionLost(hostname);
	      break;
     }

    try {
          sleep(3000);          
     } 
    catch(Exception e){  
          System.out.println("Error: " + e);
          e.printStackTrace();
	}	
   }
 }

 public void goOut() {
   keep = false;
 }

} // Fin de la Clase
