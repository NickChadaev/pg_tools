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
 *  CLASS ConnectionInfoss  @version 1.0   
 *  History:
 *           
 */

package ru.nick_ch.x1.db;

/**
 *
 * <b>CLASS ConnectionInfo v 0.1</b><p align="justify"> 
 * Esta clase define la estructura de datos de los registros de      
 * una conexiï¿½n.                                                         
 * Los objetos de este tipo se crean desde las clases ConfigFileReader,       
 * ConnectionDialog, PGConnection y UpdateDBTree. Las clases XPg y BuildConfigFile 
 * tambiï¿½n utilizan objetos de este tipo. 
 * </p> 
 *
 *@author      Beatriz Floriï¿½n  - bettyflor@kazak.ws 
 *@author      Gustavo Gonzalez - xtingray@kazak.ws 
 *@version     0.1 
 *@since       1.0
*/

public class ConnectionInfo {

 public String hostname;
 public String username;
 public String database;
 public String password = "";
 public int port;
 public String selectionPos = "";
 public boolean ssl = false;

 /**
  * METODO CONSTRUCTOR 1ra. Opciï¿½n
  * define la estructura de datos para leer el archivo de configuraciï¿½n
  *
  * @param host       Nombre o Direccion Ip del Servidor PostgreSQL
  * @param db         Nombre de la base de datos a conectarse
  * @param user       Nombre del usuario de la base de datos
  * @param numport    Numero del Puerto en el que escucha el Servidor PostgreSQL
  * @param sslSupport Booleano que indica si la conexion requiere de soporte SSL 
  */

 public ConnectionInfo(String host, String db, String user, int numport, boolean sslSupport) {

   hostname = host;
   database = db;
   username = user;
   port = numport;
   ssl = sslSupport;
  }

 /**
  * METODO CONSTRUCTOR 2ra. Opciï¿½n
  * define la estructura de datos para leer el archivo de configuraciï¿½n
  *
  * @param host      Nombre o Direccion Ip del Servidor PostgreSQL
  * @param db        Nombre de la base de datos a conectarse
  * @param user      Nombre del usuario de la base de datos
  * @param numport   Numero del Puerto en el que escucha el Servidor PostgreSQL
  * @param sslSupport Booleano que indica si la conexion requiere de soporte SSL
  * @param selected  Valor booleano que indica si esa conexion ha sido seleccionada 
  */
 
 public ConnectionInfo(String host, String db, String user, int numPort, boolean  sslSupport, String selected) {

   hostname = host;
   database = db;
   username = user;
   port = numPort;
   ssl = sslSupport;
   selectionPos = selected;
  }
 
 /**
  * METODO CONSTRUCTOR 3da. Opciï¿½n
  * define la estructura de datos para hacer pruebas de conexiï¿½n
  *
  * @param host      Nombre o Direccion Ip del Servidor PostgreSQL
  * @param db        Nombre de la base de datos a conectarse
  * @param user      Nombre del usuario de la base de datos
  * @param password  Clave de acceso del usuario de la base de datos
  * @param numport   Numero del Puerto en el que escucha el Servidor PostgreSQL
  * @param sslSupport Booleano que indica si la conexion requiere de soporte SSL
  */

 public ConnectionInfo(String host, String db, String user, String passwd, int numPort, boolean sslSupport) {

   hostname = host;
   database = db;
   username = user;
   password = passwd;
   port = numPort;
   ssl = sslSupport;
  }

 /**
  * Este m&eacute;todo retorna el nombre del servidor en el registro actual
  * @return hostname Nombre o Direccion Ip del Servidor PostgreSQL 
  */
 public String getHost() {
  return hostname;	
 }

 /**
  * Este m&eacute;todo retorna el nombre del usuario en el registro actual
  * @return username Nombre del usuario de la base de datos
  */
 public String getUser() {
  return username;	
 }

 /**
  * Este m&eacute;todo retorna la clave del usuario en el registro actual
  * @return password Clave de acceso del usuario de la base de datos 
  */
 public String getPassword() {
  return password;
 }

 /**
  * Este m&eacute;todo retorna el nombre de la base de datos en el registro actual
  * @return database  Nombre de la base de datos a conectarse
  */
 public String getDatabase() {
  return database;	
 }

 /**
  * Este m&eacute;todo retorna el nï¿½mero del puerto en el registro actual
  * @return port Numero del Puerto en el que escucha el Servidor PostgreSQL
  */
 public int getPort() {
  return port;	
 }

 /**
  * Este m&eacute;todo retorna el nï¿½mero del puerto en el registro actual
  * @return selectionPos Valor booleano que indica si esta conexion es la selccionada 
  */
 public String getDBChoosed() {
  return selectionPos;
 }

 /**
  * Este m&eacute;todo retorna verdadero si la conexion requiere soporte SSL 
  * @return ssl Valor booleano que indica si la conexion requiere soporte SSL
  */

 public boolean requireSSL() {
  return ssl;
 }

} //Fin de la Clase
