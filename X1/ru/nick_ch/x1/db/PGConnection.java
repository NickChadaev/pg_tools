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
 *  CLASS PGConnection @version 2.0  
 * This class has the following functions: loading the driver
 * Jdbc, perform conection with Postgres, submit SQL queries
 * and structures of DB objects.
 *          
 * History: 2009-07-08. The method getSpecStrucTable was
 *           modified, new SQL, it returned 5 columns.
 *           
 *       2011-10-30.  getSpecStrucTable getTablesStructure. 
 *                    were modified, the second parametr "Schema name" added.
 *                    The method getSchemaName was removed from class, because
 *                    one table may has one or more schema names .            
 *       2012-06-29-  The method getSCHVector was added. 
 *       2012-07-04   The method getStrFromVector was removed.
 *         Nick       The method getTblNamesVector was added.
 *                    The method getViewNamesVector was added.
 *                    The method getDbNamesVector was added.
 *                    The method getProductConnected was added.   
 *                    The method getDbProdName was added.   
 */
package ru.nick_ch.x1.db;

import java.sql.*;
import java.util.*;

import ru.nick_ch.x1.idiom.*;
import ru.nick_ch.x1.db.Sql_db;
import ru.nick_ch.x1.utilities.*;

public class PGConnection implements Sql_db {

 //Variables de la Base de Datos  
 private Connection       db;	 // La conexion a la base de datos              
 private Statement        st;    // El estamento para ejecutar consultas           
 private DatabaseMetaData dbmd;  // La definicion de la estructura de la base de datos 
 private String           url;                                                            
 // String           query;  // 2012-07-01 Nick                                                        
 
 protected ConnectionInfo DBdata;                                          
 
 private int    answer  = 0;                                                          
 
 public Vector TableHeader = new Vector();                                     
 public String problem     = cEMPdb;                                                    
 
 private String   ProductVersion; 
 private String   ProductName;      // 2012-07-04 Nick
 private String   ProductConnected; // 2012-07-04 Nick
 private boolean  wasFail;                                                
 private Language glossary;
 
 public String SQL = cEMPdb; 

 private int DBComponentType = 41; // Nick 2009-07-07. It has to be: 41 - any table, 42 - any view 
 //                           See setDBComponentType ( int ) method on bottom.  
 
 /** 
  * METODO CONSTRUCTOR
  * Este mï¿½todo se encarga de cargar el driver y conectarse con Postgres 
  */
 public PGConnection ( ConnectionInfo User_Entry, Language idiom ) {

   glossary    = idiom;
   DBdata      = User_Entry;        
   String port = cEMPdb;           

   if ( DBdata.getPort() != 5432 ) port = ":" + DBdata.getPort ();    
    
   if ( DBdata.requireSSL () ) 
           url = "jdbc:postgresql://" + DBdata.getHost() + port + "/" + DBdata.getDatabase() + "?ssl";
	  //   url = "jdbc:postgresql-9.2-1002.jdbc4://" + DBdata.getHost() + port + "/" + DBdata.getDatabase() + "?ssl";
   else
	   url = "jdbc:postgresql://" + DBdata.getHost() + port + "/" + DBdata.getDatabase();
       // url = "jdbc:postgresql-9.2-1002.jdbc4://" + DBdata.getHost() + port + "/" + DBdata.getDatabase();
    
   /*1. Cargar el driver*/                                                                               
   try {                                                                                                                               
         String Driver = "Driver";
         String path   = "org.postgresql"; 
         if ( path != null ) Driver = path + "." + Driver; 
         Class.forName (Driver);                               
    }                                                                          
   catch ( ClassNotFoundException ex ) {
          problem = glossary.getWord("NODRIVER");                                                         
          answer=-1;                                                           	 
          System.out.println ("Error: " + ex);
          ex.printStackTrace ();
    }                                          	 
    
   /*2. Conectar a Postgres */                                                                
   try {
         db = DriverManager.getConnection ( url, DBdata.getUser(), DBdata.getPassword () );
         dbmd = db.getMetaData ();
         st = db.createStatement ();
         answer = 1;
    }
   catch ( SQLException ex ) {
         problem = ex.getMessage ();
         answer=-2; 
    }          
  }

 /**
  * METODO FAIL 
  * Retorna el mensaje satisfactorio de conexiï¿½n
  */
 public boolean Fail() {  
	 
    if ( answer == 1) { //Cuando pudo conectarse 
         try {
               ProductName    = dbmd.getDatabaseProductName();
        	   ProductVersion = dbmd. getDatabaseProductVersion();
        	   ProductConnected = glossary.getWord("CONNTO") + dbmd.getDatabaseProductName()+ this.cSPACE + ProductVersion;
        	   // ProductConnected = ProductConnected.substring ( 0, (ProductConnected.length() - 1));
          }
         catch ( SQLException ex ) {
               problem = ex.getMessage ();
          }

         return false;
      }
    else
         return true;
  }
 
 /**
  * Method getProductConnected
  * @return Return info of PostgreSQL connection.
  * @author Nick 2012-07-04 
  * 
  */
 public String getProductConnected () {
    return ProductConnected;
  }
  
 /**
  * Method getDbProdName
  * @return Return name of PostgreSQL engine.
  * @author Nick 2012-07-04 
  * 
  */
 public String getDbProdName () {
    return ProductName;
  }
 
 /**
  * METODO getVersion 
  * Retorna la version de Postgres utilizada
  */
 public String getVersion () {
    return ProductVersion;
  }

 /**
  * METODO getHostname 
  * Retorna el nombre o ip del servidor al que el usuario accede 
  */      
 public String getHostname () {
    return DBdata.getHost();
  }	  
  
 /**
  * METODO getUsername 
  *Retorna el login del usuario utilizado para la conexiï¿½n
  */
 public String getUsername() {
    return DBdata.getUser();
  }
  
 /**
  * METODO getDBname 
  * Retorna el nombre de la base de datos que el usuario utilizï¿½
  * para la conexiï¿½n
  */
 public String getDBname() {
    return DBdata.getDatabase();
  }
 
 /**
  * METODO getPort 
  * Retorna el puerto utilizado para la conexiï¿½n
  */
 public int getPort() {
    return DBdata.getPort();
 }

 /**
  * METODO requireSSL 
  * Retorna verdadero si la conexion requiere soporte SSL
  */
 public boolean requireSSL() {
    return DBdata.requireSSL();
 }
  
 /**
  * METODO getConnectionInfo
  * Retorna toda la estructura de datos de la conexiï¿½n
  */
 public ConnectionInfo getConnectionInfo() {
    return DBdata;
 }

 /**
  * Method getSQL
  * @return The actual SQL string.
  */
 public String getSQL () {
    return this.SQL;
 }

 /**
  * METODO getTableHeader
  * Retorna el encabezado de las columnas de una tabla 
  */

 public Vector getTableHeader() {
    return TableHeader;
 }

 /**
  * METODO getProblemString
  * Retorna el texto especifico del error 
  */

 public String getProblemString() {
    return problem;
 }

 /**
  * METODO getErrorMessage
  * Retorna un vector con el nro. tï¿½tulo y detalle 
  * de cada error de conexiï¿½n
  */  
 public String[] getErrorMessage() {

   String[] ErrorData = new String[3];
   ErrorData[0] = "1";
   ErrorData[1] = cEMPdb;	
   ErrorData[2] = problem;

   int k;
   k = problem.indexOf("ClassNotFoundException");

   if (k != -1) {

       ErrorData[0]="1";	
       ErrorData[1]=problem;
       ErrorData[2] = "CLASSPATH variable doesn't contain the path of the PostgreSQL JDBC Driver.";

       return ErrorData;
     }  
   //recordar -> indexOf retorna -1 si no se encuentra el ï¿½ndice donde empieza la cadena dada
   k = problem.indexOf(glossary.getWord("NODRIVER"));

   if (k != -1) {

       ErrorData[1] = problem;
       return ErrorData;
    }
      
   k = problem.indexOf("No pg_hba.conf entry");	 

   if (k != -1) {
       ErrorData[0]="2";
       ErrorData[1] = glossary.getWord("NOPGHBA");
       return ErrorData;
    }
 
   k = problem.indexOf("Password authentication failed");

   if (k != -1) {
       ErrorData[0]="3";
       ErrorData[1] = glossary.getWord("BADPASS");
       return ErrorData;
    }  

   k = problem.indexOf("UnknownHostException");

   if (k != -1) {
       ErrorData[0]="4";	
       ErrorData[1] = glossary.getWord("BADHOST");
       return ErrorData;
    } 

   k = problem.indexOf("Permission denied");

   if (k != -1) {
       ErrorData[0]="5";	
       ErrorData[1] = "You don't have some permissions to access this table.";
       ErrorData[2] = ErrorData[2] + "\nContact your PostreSQL Server Admin to avoid this message.";
       return ErrorData;
    }

   k = problem.indexOf("referential integrity violation");	 

   if (k != -1) {
       ErrorData[0]="6";
       ErrorData[1] = "Referential Integrity Violation";
       return ErrorData;
    }

   k = problem.indexOf("Connection refused");
                                                                                                      
   if (k != -1) {
       ErrorData[0]="7";
       ErrorData[1] = "Connection refused from PostgreSQL Server";
       return ErrorData;
    }

   k = problem.indexOf(".");
   ErrorData[0]= glossary.getWord("STRANGE");	

   if (k != -1)
       ErrorData[1]=  problem.substring (0,k); //captura titulo inicial antes de excepciones del mensaje
   else
       ErrorData[1] = problem.substring(0,problem.length()); //captura excepciones del mensaje
    
   return ErrorData;
 }

 /**
  * METODO close 
  * Se encarga de cerrar la conexiï¿½n
  */  
 public void close() {

     try { 
           st.close ();
           db.close ();    
     }
     catch ( SQLException ex ) {
             System.out.println ( "Error: " + ex );
             ex.printStackTrace ();
             problem = ex.getMessage ();
     }	     
  }

 /**
  * METODO Void_Instruction 
  * Metodo para ejecutar consultas de tipo INSERT, UPDATE, 
  * DELETE, DROP y CREATE
  */  
 public String SQL_Instruction ( String instruction ) {

   String result = "OK";
   this.SQL = instruction ; // Nick 2009-08-05
   
   try {
          int Void_result = st.executeUpdate ( this.SQL ); // Nick 2009-08-05
    }
   catch ( SQLException ex ) {
         problem = ex.getMessage ();
         result = problem;
    }

   return result;  
  }

 /**
  * METODO getUserPerm 
  * Metodo para capturar los permisos de un usuario 
  */ 
 public String[] getUserPerm ( String login ) {

     String [] values = new String [2];
     String permission = S_GET_USER_PERM + login + S_THE_END; // Nick 2009-08-04

     try {
          Vector resultx = TableQuery ( permission );  
          Vector row = (Vector) resultx.elementAt (0);
          
          Object o   = row.elementAt (0);
          values[0]  = o.toString ();
          o = row.elementAt (1);
          values[1] = o.toString ();
       }
     catch ( Exception ex ) {
           System.out.println ("Error: " + ex);
           ex.printStackTrace ();
      }

     return values;
  }  

 /**
  * METODO TableQuery
  * Mï¿½todo para ejecutar consultas de tipo SELECT
  */  
 public Vector TableQuery ( String instruction ) {

    this.SQL = instruction;
    Vector queryResult = new Vector (); //Vector de vectores
    Vector TableRow    = new Vector ();
    TableHeader        = new Vector ();
    ResultSet rs;

    try {
          rs = st.executeQuery ( this.SQL );	       
          ResultSetMetaData rsmd = rs.getMetaData ();
          // Extraer Nombres de Columnas
          int cols = rsmd.getColumnCount ();
          
          String columnName = new String ();
          for ( int i = 1; i <= cols; i++ ) {
                 TableHeader.addElement ( rsmd.getColumnLabel (i) );
                 columnName = rsmd.getColumnLabel (i);
          }

          while ( rs.next () ) {
                
                 //System.out.println("contenido de getFetchSize despues: "+rs.getFetchSize());
          
                 TableRow = new Vector ();
                 Object o = new Object ();  
                 for  ( int i = 1; i <= cols; i++ ) {
                 	
                 	if ( columnName.equals ( "tgargs" ) ) {
                 		byte dt[] = rs.getBytes (1);
                 		StringBuffer record = new StringBuffer ();
                 		for ( int j = 0; j < dt.length; j++ ) {
                 		     int k = dt [j];
                 		     if ( k != 0 ) record.append ( k + "-" );
                 		     else record.append (" ");
                 		 }	
                 		String data = record.toString ();
                 		//return getASCII(data);
                 		TableRow = getASCII (data);
                 	 }	
                 	else {	
                           o = rs.getObject(i);
                 	}                       
                       
                    if ( rs.wasNull () ) o = null;
                    TableRow.addElement (o);
                  }

                  queryResult.addElement ( TableRow ); 
            }
          wasFail = false;
     }
    catch ( SQLException ex ) { 
          wasFail = true;
          problem = ex.getMessage ();
          System.out.println ( "Error: " + ex );
          ex.printStackTrace ();
       }

    return queryResult;
  }

 public Vector getASCII ( String data ) {
  Vector fk = new Vector ();
  StringTokenizer filter = new StringTokenizer ( data, " " );
    
  while ( filter.hasMoreTokens () ) {
         //String tmp = filter.nextToken();
         StringTokenizer translator = new StringTokenizer ( filter.nextToken(), "-" );
         StringBuffer word = new StringBuffer ();
         while ( translator.hasMoreTokens ()) {
                int p = new Integer ( translator.nextToken()).intValue ();
                //char m = (char) p;
                word.append ( (char) p );
          }
         String l = word.toString ();
         fk.addElement (l);
   }
  
  return fk;	
 }
  
 public boolean queryFail () {
    return wasFail;  
  }

 public String getOwnerDB () {
   Vector user = TableQuery ( S_GET_OWNER_DB + DBdata.getDatabase() + S_THE_END  );
   Vector nameU = (Vector) user.elementAt (0);
   String owner = (String) nameU.elementAt (0);

   return owner;
  }
/**
 * Get owner of table. 2011-10-30 Nick
 * @param TableName
 * @param Schema_name
 * @return
 */
 public String getOwner ( String TableName, String Schema_name ) {
   Vector user = TableQuery ( S_GET_OWNER_01 + TableName + S_GET_OWNER_02 + Schema_name + S_GET_END );
   return GetStr.getStringFromVector ( user, 0, 0 ) ;                	

//   Vector nameS = (Vector) user.elementAt (0);
//   String owner = (String) nameS.elementAt (0);
//   return owner;
  }
/***
 * Bad Method
 * @param TableName
 */
 public void getTablePermissions ( String TableName ) {

   Table x = new Table ( TableName );
   Vector Permissions = TableQuery ( S_GET_TABLE_PERM + TableName + S_THE_END );

   for ( int j = 0; j < Permissions.size (); j++ ) {

        Vector user = (Vector) Permissions.elementAt (j);

        for ( int i = 0; i < user.size (); i++ ) {
             String perm = (String) user.elementAt (i);
         }
    }
 }

 /**
  * METODO getSpecStrucTable
  * Retorna una la estructura de una tabla especï¿½fica dado su nombre
  *  2009-07-08 Nick  
  *  2011-10-30 The second parametr schema name was added.
  */
 public Table getSpecStrucTable ( String Tname, String Sname ) {

   //Se construye un vector donde cada elemento es la definiciï¿½n completa de un campo
   Vector tableStructure = TableQuery ( S_GET_TABLE_STRUCT_1 + Tname + S_GET_TABLE_STRUCT_2 +
		   Sname + S_GET_TABLE_STRUCT_02  ); 
   // se hace la consulta

   //Se crea un vector que lee y formatea los datos leidos de cada campo
   Vector fields = new Vector ();

   for ( int j = 0; j < tableStructure.size (); j++ ) {

        String AtriName   = cEMPdb;
        String Atritype   = cEMPdb;
        String Atritype_1 = cEMPdb;  // Nick 2012-07-30
        String AtriDef    = cEMPdb;
        String AtriDesc   = cEMPdb;
        
        int categType = -1;   // Nick 2012-07-12
        int fieldLen  = -1; 
        int precLen   = -1;   //
        
        int intLong  = -1;
        int charLong = -1;
        
        boolean isNull  = true;
        boolean haveDef = false;
        
        boolean pK = false;
        boolean uK = false;
        boolean fK = false;
       
        Vector row = ( Vector ) tableStructure.elementAt ( j );
      
        //capturar nombre del campo
        Object t = row.elementAt ( 0 );
        AtriName = row.elementAt ( 0 ).toString ();

        //capturar tipo del campo
        t = row.elementAt ( 1 );
        Atritype = t.toString (); //Tipo del campo

        // Nick 2012-07-13
        if ( Atritype.equals(ChkType.cINT2a) ) Atritype = ChkType.cINT2;
        if ( Atritype.equals(ChkType.cINT4a) ) Atritype = ChkType.cINT4;
        if ( Atritype.equals(ChkType.cINT8a) ) Atritype = ChkType.cINT8;
        // 
        if ( Atritype.equals(ChkType.cCHARa) ) Atritype = ChkType.cCHAR;
        
        //caturar longitud del campo
        t = row.elementAt ( 2 ); // !!!!!!!!!!
        intLong = Integer.parseInt ( t.toString () );

        //capturar si activa not null
        t = row.elementAt ( 3 );
        Boolean boolvalue = new Boolean( t.toString () );
        isNull = boolvalue.booleanValue ();

        //capturar logitud de char y varchar
        t = row.elementAt ( 4 );
        charLong = Integer.parseInt ( t.toString () );

        // Si existe valor por defecto capturarlo
        t = row.elementAt ( 5 );
        boolvalue = new Boolean ( t.toString () );
        haveDef = boolvalue.booleanValue ();

        if ( haveDef ) { // The default value   Nick
            t = row.elementAt ( 6 );
            Vector vecAtriDef  = TableQuery ( S_ATTR_DEF_1 + S_ATTR_DEF_2 + Tname + S_ATTR_DEF_3 + 
            		                          Sname + S_ATTR_DEF_4 + t.toString () + cRBRdb
            );
            AtriDef  = GetStr.getStringFromVector (vecAtriDef, 0, 0); 
            if ( Atritype.equals(ChkType.cINT4) && (AtriDef.contains (cNEXTVAL)) 
               ) Atritype = ChkType.cSERIAL;
            
            if ( Atritype.equals(ChkType.cINT8) && (AtriDef.contains (cNEXTVAL))
               ) Atritype = ChkType.cBIGSERIAL;
         }

        Atritype_1 = Atritype; // Nick 2012-07-30
        
        //capturar el comentario del campo.  :):) I start to speak Spanish. Nick 
        t = row.elementAt ( 7 );
        AtriDesc = t.toString (); 
        
        categType = ChkType.getCategType ( Atritype );
        
        // Need to attach (<len>[,<prec>] ) to the DB type definition. Nick 2012-07-12
        if (categType == 1) { // numeric
            if ( charLong != -1 ) { 
            	  charLong -= 4;
                  fieldLen = charLong / 65536;
                  precLen = charLong % 65536;
                  Atritype += cLBRdb + fieldLen ;
                  if ( precLen > 0 ) Atritype += cCOMMAdb + precLen;
                  Atritype += cRBRdb;
            }
        }
        else if (categType == 3) { // Char string
            if ( charLong != -1 ) { 
            	 		charLong -= 4; 
            	 		fieldLen = charLong;
            	 		Atritype += cLBRdb + fieldLen + cRBRdb;
            }
        }
        else if (categType == 11 ) { // Bit string
         	                 fieldLen = charLong;
                             Atritype += cLBRdb + fieldLen + cRBRdb;
             }
        else  // Another types
             fieldLen = intLong;        

        OptionField opcAtrib = new OptionField ( Atritype, categType, fieldLen, precLen, isNull, pK, uK, fK, AtriDef );
        // Very importan Atritype_1 is DB type without any length specification. nick 2012-07-30
        TableFieldRecord oneAtrib = new TableFieldRecord ( AtriName, Atritype_1, AtriDesc, opcAtrib );
        fields.addElement ( oneAtrib );
        
   } //  j < tableStructure.size (); j++ 

   TableHeader header = new TableHeader ( fields );
   Table oneT = new Table ( Tname, header );
   
   oneT.schema     = Sname ;
   oneT.userSchema = this.gotUserSchema ( Sname );
   oneT.comment    = this.getComment(Tname, Sname);
   oneT.is_Xrd     = false ; // Nick 2012-11-11 this.getXrdLink    ( Tname );
   
   return oneT;
 }

 /**
  * METODO getHeader 
  * Retorna el vector con el nombre de las cabeceras de la tabla de resultados
  */  
 public Vector getHeader() {
    return TableHeader;
  }

 /**
  * METODO getTablesStructure 
  * Retorna la estructura de todas las tablas de una lista de tablas
  * 2011-10-30 Only for CreateTable constructor class. Nick
  * 2012-07-19 This method was rebuilded. 
  */  
 public Vector getTablesStructure ( Vector plistTables, String pSchema_name ) {

   Vector TablesStruc = new Vector ();
   int numTables = plistTables.size ();

   if ( numTables > 0 ) {
       for ( int k = 0; k < numTables; k++ ) {
            String table_name = (String) plistTables.elementAt(k).toString();
            Table oneT = getSpecStrucTable ( table_name, pSchema_name ) ;
            TablesStruc.addElement ( oneT );
       } // loop for listTables
    } // numTables > 0 

    return TablesStruc;
 }

 /**
  * METODO getIndexTable()
  * Hace la consulta y retorna un vector con los ï¿½ndices de una tabla
  * 2011-12-03 Nick. Second parametr was added
  */
 public Vector getIndexTable (String Tname, String Sname ) {
	 
   Vector indexTable = TableQuery ( S_INDEX_TABLE_1 + Sname + S_INDEX_TABLE_2 + 
		                                              Tname + S_INDEX_TABLE_3 + S_INDEX_TABLE_4); //se hace la consulta

   Vector indexTable2 = new Vector ();
   String indexName;

   for ( int i = 0; i < indexTable.size () ; i++ ) {
	    indexName = GetStr.getStringFromVector ( indexTable, i, 0 );
	  
	    // Nick 2011-12-03  
        // Vector o = (Vector) indexTable.elementAt (i);
        // indexName = (String) o.elementAt (0);
        indexTable2.addElement ( indexName );
    }

   return indexTable2;
  }

 /**
  * METODO getIndexProp
  * Hace la consulta y retorna un vector con las propiedades de
  * un indice determinado
  */
 public Vector getIndexProp ( String Iname ) {

   Vector indexProp = TableQuery ( S_INDEX_PROP_1 + Iname + S_INDEX_PROP_2 ); //se hace la consulta
   return indexProp;
  }

 /**
  * METODO getForeignKeys 
  * Hace una consulta y retorna un vector con las llaves foraneas 
  * referentes a una tabla 
  */

 public Vector getForeignKeys ( String tname ) {
    Vector indexFK = TableQuery ( S_FOREING_KEY_1 + tname + S_FOREING_KEY_2 );
    // Vector result = new Vector (); // Nick 2012-06-29 

    return indexFK; 
  }

 /**
  * METODO getGroups
  * Hace la consulta y retorna un vector con los grupos 
  * existentes en el sistema
  */
 public String[] getGroups() {

  Vector Groups = TableQuery ( S_GET_GROUP );
  String[] Gnames = new String [ Groups.size() ];

  for ( int i = 0; i < Groups.size (); i++ ) {
       Vector dat = (Vector) Groups.elementAt (i);
       Gnames[i] = (String) dat.elementAt (0);
   }

  return Gnames;

 }

 /**
  * METODO getNumTables
  * Hace la consulta y retorna el numero de tablas 
  * existentes para esta base de datos 
  */

 public int getNumTables() {

  String SQL = S_GET_NUM_TABLES;
  Vector count = TableQuery ( SQL );
  Vector value = (Vector) count.elementAt(0);

  int n;

  try {
        Long entero = (Long) value.elementAt(0);
        n = entero.intValue();
   }
  catch ( Exception ex ) {
        Integer entero = (Integer) value.elementAt(0);
        n = entero.intValue();
   }

  return n;
 }
/*** 
 *  Get Vector of DB tables names.
 *  @author Nick 2012-07-01
 *  @param p_sch_name - schema name
 *  @return - Vector of tables's names
 */
  
public Vector getTblNamesVector ( String p_sch_name ) {
	 Vector TablesNames = new Vector();
	
	 TablesNames = TableQuery ( S_TABLES_01 + S_TABLES_11 + S_TABLES_02 + 
			                    S_TABLES_03 + S_TABLES_04 + p_sch_name + 
			                    S_TABLES_05 
	 );
	 
     return TablesNames;	 
} // getTblNamesVector


/*** 
 *  Get Vector of DB views names.
 *  @author Nick 2012-07-01
 *  @param p_sch_name - schema name
 *  @return - Vector of view's names
 */
  
public Vector getViewNamesVector ( String p_sch_name ) {
	 Vector ViewsNames = new Vector();
	
	 ViewsNames = TableQuery ( S_VIEWS_01 + S_VIEWS_11 + S_VIEWS_02 + S_VIEWS_03 +
			                   S_VIEWS_04 + p_sch_name + S_VIEWS_05 
	 );
     
	 return ViewsNames;
     
} // getViewNamesVector

/**
 * @version 1.0 2012/07/03
 * @author Nick Chadaev
 * @param  p_Exclude, p_lookForOthers
 *  p_Exclude is true -> a value of p_lookForOthers must be ignored, list of dbnames 
 *                       excludes the name of current db.
 *  p_Exclude is false -> test a value of p_lookForOthers:
 *                        p_lookForOthers is true, list of dbnames includes all dbnames
 *                        of current connection,
 *                        p_lookForOthers is false, list of dbnames contains only name
 *                        of current db.     
 * @return String, it contains SELECT clause, it must returns list of dbnames
 */

public Vector getDbNamesVector ( boolean p_Exclude, boolean p_lookForOthers ) {

	Vector lVector = new Vector ();
	
    if ( p_Exclude ) // list of dbnames excludes the name of current db.
    	lVector = TableQuery ( S_DATABASES_1 + S_DATABASES_2 + 
    			S_DATABASES_4 + DBdata.getDatabase() + S_THE_END_0 + S_DATABASES_3 );
     else
        if ( p_lookForOthers ) // list of dbnames includes all dbnames of current connection
        	lVector = TableQuery ( S_DATABASES_1 + S_DATABASES_2 + S_DATABASES_3 );
    
        else // list of dbnames contains only name of current db.
        	lVector = 
        		TableQuery ( S_DATABASES_1 + S_DATABASES_5 + DBdata.getDatabase() + S_THE_END );
	
	return lVector;
	
} // getDbNamesVector

 public Vector getGroupUser ( String group ) {

  Vector Gnames = new Vector();
  Vector Size = TableQuery ( S_GET_GROUP_USER_0 + group + S_THE_END_0 );

  if ( Size.size() < 1 ) return new Vector ();

  Vector mp = (Vector) Size.elementAt (0);
  String kmp = (String) mp.elementAt (0);
  int p = kmp.indexOf (":");
  int k = kmp.indexOf ("]");
  int max = Integer.parseInt ( kmp.substring ( p + 1, k ) );

  for ( int z = 1; z <= max; z++ ) {

       Vector Groups = TableQuery ( S_GET_GROUP_USER_1 + z + S_GET_GROUP_USER_2 + 
                                    group + S_THE_END_0 
       );

       for ( int i = 0; i < Groups.size(); i++ ) {

            Vector dat = (Vector) Groups.elementAt(i);

            for ( int j = 0; j < dat.size(); j++ ) {

                 Vector Names = TableQuery ( S_GET_GROUP_USER_3 + dat.elementAt(0) + S_THE_END );
                 Vector n = (Vector) Names.elementAt (0);
                 Gnames.addElement (cEMPdb + n.elementAt(0) );
             }
        }
    }

  return Gnames;
 }

 /**
  * METODO getUsers
  * Hace la consulta y retorna un vector con los usuarios
  * existentes en el sistema
  */

 public String[] getUsers() {

   Vector users = TableQuery ( S_GET_USERS );
   String[] Unames = new String[users.size()];

   for ( int i = 0; i < users.size (); i++ ) {

        Vector dat = (Vector) users.elementAt (i);
        Unames[i] = (String) dat.elementAt (0);
    }

   return Unames;
 }

 /**
  * METODO getUserInfo
  * Hace la consulta y retorna informacion sobre un usuario
  */

 public Vector getUserInfo ( String user ) {

  Vector users = TableQuery ( S_GET_USER_INFO + user + S_THE_END );
  Vector info = (Vector) users.elementAt(0);

  return info;
 }

 /**
  * METODO getIndexFields
  * Hace la consulta y retorna un vector con los nombres de los campos
  * de un indice determinado
  */
 public Vector getIndexFields (String codIndex) {

   Vector indexFields = TableQuery ( S_GET_INDEX_FIELDS + codIndex ); //se hace la consulta
   return indexFields;
  }

 /**
  * METODO gotSchema
  * Verifica si una tabla pertenece a un schema personalizado o no
    2011-10-30  Schema name is parameter.
  */
 public boolean gotUserSchema ( String Schema_name ) {
   
   if ( Schema_name.equals ( "information_schema" ) || 
		Schema_name.equals ( "public" ) || Schema_name.startsWith ( "pg_" )
    )
    return false;
      else
          return true;
  }

 /************************************************************************ 
  *   Create list of schema names. 
  *   @author Nick Chadaev nick_ch58@list.ru 2009-07-17
  **/
 public Vector getSCHVector () {

     Vector Xschemas   = new Vector();
     Vector Xschemas_1 = new Vector();
     Vector tmp        = new Vector(); // The public schema must be first in the list

     tmp.add ( cPUBLIC );
     Xschemas.add ( tmp ) ;       

     Xschemas_1 = TableQuery ( S_SCHEMAS );
     
     int len_Xschemas_1 = Xschemas_1.size ();    
     for ( int i = 0; i < len_Xschemas_1; i++ ) Xschemas.add ( Xschemas_1.elementAt ( i ) );

     return Xschemas;
 } // fin getSCHVector
 
 
 /***
  *  Get Table/View status. Nic 2009-10-02
  *  2011-11-13 Schemaname added
  */
 public String getComment ( String p_table_name, String p_schema_name ) {
	 
	 String ls_tp_rel = cEMPdb;

	 if ( this.DBComponentType == 41 ) ls_tp_rel = "r";
	 if ( this.DBComponentType == 42 ) ls_tp_rel = "v";
	 
	 Vector l_comm = TableQuery ( S_GET_DESCR_01 + S_GET_DESCR_02 + S_GET_DESCR_03 + S_GET_DESCR_04 +
			 p_table_name + S_GET_DESCR_05 + ls_tp_rel + S_GET_DESCR_15 + p_schema_name + 
			 S_GET_DESCR_06 
	  ) ;  

	 return GetStr.getStringFromVector ( l_comm, 0, -1) ; // !!! Nick 2012-11-11
 }
 
  /*******************************************
   *  Set DB component type . Nick 2009-07-07
   */
 public void setDBComponentType ( int p_type ) {
 	this.DBComponentType = p_type ;
  }

 /**
  * The method rCount. @author Nick 2013-06-02
  * Return the number Of record  of the table. 
  */
 public int rCount ( String TableN ) {

	   int val;
	   String counting = "SELECT count(*) FROM " + TableN + ";";
	   Vector result = TableQuery(counting);
	   Vector value = (Vector) result.elementAt(0);

	   try {
	        Integer entero = (Integer) value.elementAt(0);
	        val = entero.intValue();
	    }
	   catch ( Exception ex ) {
	        Long entero = (Long) value.elementAt(0);
	        val = entero.intValue(); 
	    }
	   return val;
	  }
 /**------------------------------------------------------------------
  * Get description of database. @verion: 2013-06-09
  *    PGSQL version 8.3 table PG_SHDESCRIPTION, it
  *    contatins description of DB, but the old version of PGSQL 7.4.1
  *    contains ALL DESCRIPTION into PG_DESCRIPTION table.
  *
  * @param p_DbName - Name of database
  * @return Description of database
  */
public String getDB_description ( String p_DbName ) {
  String l_str;

  if ( ProductVersion.startsWith ( "7" ) ) l_str = S_DATABASES_21 + S_DATABASES_22 ;
  else l_str = S_DATABASES_211 + S_DATABASES_221;
  
  l_str = l_str + p_DbName + S_DATABASES_23;
  Vector l_res = TableQuery (l_str);
  
  return GetStr.getStringFromVector ( l_res, 0, 0) ;
}
} //Fin de la Clase
