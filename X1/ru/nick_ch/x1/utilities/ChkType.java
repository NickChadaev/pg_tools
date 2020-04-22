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
 *  CLASS ChkType @version 1.0   
 *      This class has a definition and access methods to 
 *      the list of all data types supported RDBMS Postgres. 
 *  	Some methods checking correctness constants entered in GUI  
 *      and another methods supplementing entered constants by special symbols.
 *
 * Created: 2012/02/03  Nikolay Chadaev
 * History: 2012-07-06 The method getCategType was added. Nick
 *          2012-07-12 Additional constants was added. Nick
 *          2012-10-28 Additional checks for char, varchar, text types was added Nick 
 *           
 */ 

package ru.nick_ch.x1.utilities;

import ru.nick_ch.x1.menu.Sql_menu; // 2012-02-17 Nick

public class ChkType implements Sql_menu {

	// The public area
	public static final String cINT = "int";
	
	public static final String cINT2  = "smallint";  // 0 int2
	public static final String cINT4  = "integer";   // 0 int4
	public static final String cINT8  = "bigint";    // 0 int8

	public static final String cINT2a  = "int2";  // 0 int2
	public static final String cINT4a  = "int4";  // 0 int4
	public static final String cINT8a  = "int8";  // 0 int8
	
	public static final String cDECIMAL = "decimal";   // 1 
	public static final String cNUMERIC = "numeric";   // 1 

	public static final String cREAL      = "real";      // 2 The same
	public static final String cFLOAT4    = "float4";    // 2

	public static final String cFLOAT     = "float";            // 2 The same
	public static final String cFLOAT8    = "float8";           // 2
    public static final String cDPREC     = "double precision"; // 2

	public static final String cSERIAL    = "serial";     // 12
	public static final String cBIGSERIAL = "bigserial";  // 12
	
	// public static final String cMONEY     = "money";    2012-02-28 nICK
    
	public static final String cVARCHAR = "varchar";  // 3
	public static final String cCHAR    = "char";     // 3
	public static final String cCHARa   = "bpchar";   // 3
	public static final String cTEXT    = "text";     // 3
	
	public static final String cNAME = "name";    // 4 !!!
	
	public static final String cBLOB = "bytea";   // 5 2012-03-01
	
	public static final String cTIME       = "time";         // 6 
	public static final String cTIMEZ      = "timetz";       // 6
	public static final String cTIMESTAMP  = "timestamp";    // 6
	public static final String cTIMESTAMPZ = "timestamptz";  // 6
	public static final String cINTERVAL   = "interval";     // 6
	public static final String cDATE       = "date";         // 6
	
	public static final String cBOOL = "bool";          // 7 
	
	public static final String cPOINT   = "point";    // 8 
	// public static final String cLINE    = "line";    // 8
	public static final String cLSEG    = "lseg";     // 8 
	public static final String cBOX     = "box";      // 8
	public static final String cPATH    = "path";     // 8
	public static final String cPOLYGON = "polygon";  // 8
	public static final String cCIRCLE  = "circle";   // 8

	public static final String cCIDR    = "cidr";    // 9 
	public static final String cINET    = "inet";    // 9
	public static final String cMACADDR = "macaddr"; // 9
	
	public static final String cUUID = "uuid"; // 10
	
	public static final String cBIT    = "bit";    //  "11"
	public static final String cVARBIT = "varbit"; //  "11"
	
	public static final String [] cBOOLARRAY = { "true", "false" };
	
	// The public area
	
	private static String[] c_T_VALUES = {         cINT2,       cINT4,      cINT8,     cDECIMAL, cNUMERIC, 
	 cREAL, cFLOAT4, cFLOAT, cFLOAT8,  cDPREC,     cSERIAL,     cBIGSERIAL, cVARCHAR,  cCHAR,    cTEXT,
	 cNAME, cBLOB,   cTIME,  cTIMEZ,   cTIMESTAMP, cTIMESTAMPZ, cINTERVAL,  cDATE,     cBOOL,    cPOINT, 
	 cLSEG, cBOX,    cPATH,  cPOLYGON, cCIRCLE,    cCIDR,       cINET,      cMACADDR,  cUUID,    
	 cBIT,  cVARBIT
    };
	private static int [] c_T_CODES   = {           0,          0,          0,         1,        1, 
	  2,    2,      2,       2,        2,          12,          12,         3,         3,        3,   
	  4,    5,      6,       6,        6,           6,           6,         6,         7,        8,  
	  8,    8,      8,       8,        8,           9,           9,         9,        10,        
	 11,   11
    };

	private static boolean l_res = false;
    private static String ls_res = "";

    // Attention ! Each sub-array must be sorted. Nick 2012-03-10
	private static final char [][] arr_fig = {
		{ '+', '-', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9' },                 //  0- Int 
		{ '+', '-', '.', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9',         
			'A', 'N', 'a', 'n'  },                                                      //  1- Decimal
		{ '+', '-', '.', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 
		  'A', 'E', 'F', 'I', 'N', 'T', 'Y', 
		  'a', 'e', 'f', 'i', 'n', 't', 'y'  },                                         //  2- Fpoint
		{},                                                                             //  3- Char,varchar
		{},                                                                             //  4- Name
		{ '\'', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9',                       //  5- Blob 
		  'A', 'B', 'C', 'D', 'E', 'F', '\\', 'a', 'b', 'c', 'd', 'e', 'f', 'x' },
		{ ' ', '\'', '+', '-', '.', '/', '0', '1', '2', '3', '4', '5', '6',             //  6- Date, Time
		  '7', '8', '9', ':', 'A', 'a', 'M', 'm' },                                    
		{},                                                                             //  7- Boolean
		{ '\'', '(', ')', '+', ',', '-', '.', '0', '1', '2', '3', '4', '5', '6', '7',   
		  '8', '9', '<', '>','E', '[', ']', 'e' },                                      //  8- Geometric
		{ '\'', '-', '.', '/', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', ':', 
		  'A', 'B', 'C', 'D', 'E', 'F', 'a', 'b', 'c', 'd', 'e', 'f' },                 //  9- Inet
		{ '\'', '-', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 
		  'A', 'B', 'C', 'D', 'E', 'F','a', 'b', 'c', 'd', 'e', 'f', '{', '}' },        // 10- UUID   
		{ '\'', '0', '1', 'B', 'b' }                                                    // 11 - Bit string              
	};
	
	public ChkType () {
		super ();
		
		// TODO Auto-generated constructor stub
	}

	/**
	  * Check alphabet string
	  * @param value
	  * @return
	  */
	 public static boolean isNum (String value) {

		 l_res = true;
		 for (int i = 0; i < value.length (); i++ ) 
	          if ( !Character.isDigit (value.charAt(i)) ) { l_res = false; break; }
	    
	   return l_res;
	 }
	 /**
	  * Check the values
	  * @param TypeField
	  * @param value
	  * @return
	  */
	 public static boolean validValue ( int TField, String value ) 
	  {
	   l_res = true;

	   if ( (value.contains (cDP2)) || (value.toUpperCase().contains (cCAST)) ) return l_res; 
		 
       /**
	   System.out.println( "uuid " + value );
	   java.util.Arrays.sort ( arr_fig [10] );
	   for ( int j = 0; j < arr_fig [10].length; j++ ) System.out.println ( "arr = " + arr_fig [10] [j] );
	   **/
	   
	   switch ( TField ) {
	   case 0 :    // The integer types
		   for ( int i = 0; i < value.length(); i++ )  
			   if ( java.util.Arrays.binarySearch ( arr_fig [0], value.charAt(i) ) < 0 ) { l_res = false; break; } 
 		   break;
		   
	   case 1 :    // The fixed point types ( decimal, numeric )
		   if ( !value.toLowerCase().contains (cNAN) )
		       for ( int i = 0; i < value.length(); i++ ) 
		    	   if ( java.util.Arrays.binarySearch ( arr_fig [1], value.charAt(i)) < 0 ) 
			               { l_res = false; break; } 
		   break;
		   
	   case 2 :    // The float point types
  		   if ( !value.toLowerCase().contains(cNAN) && !value.toLowerCase().contains(cINFINITY) &&
			    !value.toLowerCase().contains(cNINFINITY) ) 
		      for ( int i = 0; i < value.length(); i++ ) 
	                if ( java.util.Arrays.binarySearch ( arr_fig[2], value.charAt(i)) < 0 ) 
	                      { l_res = false; break; } 
		   break;
		   
	   case 3 :    // The char, varchar types
		   l_res = true;
		   break;
		   
	   case 4 :    //  The name type, internal type for the database 
		   l_res = true;
		   break;
		   
	   case 5 :    // The blob type
		   for ( int i = 0; i < value.length(); i++ ) 
			 if ( java.util.Arrays.binarySearch ( arr_fig[5], value.charAt(i)) < 0 ) { l_res = false; break; } 
		   break;
		   
	   case 6 :    // The data, datatime and interval types.
  		   if ( !value.toLowerCase().contains(cEPOCH)     && !value.toLowerCase().contains(cINFINITY) &&
  				!value.toLowerCase().contains(cNINFINITY) && !value.toLowerCase().contains(cNOW )     &&
  				!value.toLowerCase().contains(cTODAY)     && !value.toLowerCase().contains(cTOMORROW) &&
  				!value.toLowerCase().contains(cYESTERDAY) && !value.toLowerCase().contains(cALLBALLS) 
  			  ) 
    		   for ( int i = 0; i < value.length(); i++ ) 
			          if ( java.util.Arrays.binarySearch ( arr_fig[6], value.charAt(i)) < 0 ) 
			                { l_res = false; break; } 
		   break; 
		   
	   case 7 :    // The boolean type
		   break;
		   
	   case 8 :    // The geometric types
		   for ( int i = 0; i < value.length(); i++ ) 
 		     if ( java.util.Arrays.binarySearch ( arr_fig [8], value.charAt(i)) < 0 ) { l_res = false; break; } 
		   break;
		   
	   case 9 :    // The cidr, inet types
		   for ( int i = 0; i < value.length(); i++ )  
			   if ( java.util.Arrays.binarySearch ( arr_fig [9], value.charAt(i)) < 0 ) { l_res = false; break; } 
	       break;
		   
	   case 10 :   // the UUID types
		   if ( !value.toLowerCase().contains (cGEN_UUID) )
		      for ( int i = 0; i < value.length(); i++ ) 
	                 if ( java.util.Arrays.binarySearch ( arr_fig [10], value.charAt(i)) < 0 ) 
	                       { l_res = false; break; } 
		   break;
		   
	   case 11 :   // The bit, varbit types
		   for ( int i = 0; i < value.length(); i++ ) 
	 		 if ( java.util.Arrays.binarySearch ( arr_fig [11], value.charAt(i)) < 0 ) { l_res = false; break; } 
		   break;
		/**   
	   case 12 :   // The serial, bigserial types
           l_res = isNum ( value );
		   break; 
		   **/
	   };
	   return l_res;
	 }
	 
	 /**
	  *  2012-03-07  Need to set additional characters to default values. 
	  *  @return value
	  */
	 public static String setAddChar ( int TField, String plTF, String value ) {
		 
		 ls_res = value ;

		 if ( (ls_res.contains (cDP2)) || (ls_res.toUpperCase().contains (cCAST)) ) return ls_res; 
		 
		 switch ( TField ) {
		   case 0 :    // The integer types
			   break;
		   
		   case 1 :    // The fixed point types ( decimal, numeric )
			   if ( ls_res.toLowerCase().contains ( cNAN ) &&  (! (ls_res.startsWith(cSEP))) )
				      ls_res = cSEP + ls_res + cSEP;
			   break;
		   
		   case 2 :    // The float point types
			   if ( (ls_res.toLowerCase().contains(cNAN) || ls_res.toLowerCase().contains(cINFINITY) ||
					ls_res.toLowerCase().contains(cNINFINITY) ) &&  (! (ls_res.startsWith(cSEP))) )
				       ls_res = cSEP + ls_res + cSEP ;
			   break;
		   
		   case 3 :    // The char, varchar, text types   2012-10-28 Nick
			   if ( (ls_res.startsWith(cSEP)) ) ls_res = ls_res.replaceFirst(cSEP, cSPACE);
			   if ( (ls_res.endsWith(cSEP)) ) ls_res = ls_res.substring(1, ls_res.length()- 1) ;

			   ls_res = ls_res.trim();
			   if ( ls_res.contains(cSEP) ) ls_res = ls_res.replaceAll ( cSEP, cSEP2 );
			   ls_res = cSEP + ls_res + cSEP ;
			   //if (! (ls_res.startsWith(cSEP)) ) ls_res = cSEP + ls_res; // 2012-10-28
			   //if (! (ls_res.endsWith(cSEP)) ) ls_res = ls_res + cSEP ;  // Nick
			   break;
		   
		   case 4 :    //  The name type, internal type for the database 
			   if (! (ls_res.startsWith(cSEP)) ) ls_res = cSEP + ls_res + cSEP ;
			   break;

		   case 5 :    // The blob type
			   if (! (ls_res.startsWith(cESC)) ) ls_res = cESC + ls_res;
			   if (! (ls_res.endsWith(cSEP)) ) ls_res = ls_res + cSEP ;
			   break;
			   
		   case 6 :   // The data, datatime and interval types.
			   if (! (ls_res.startsWith(cSEP)) ) ls_res = cSEP + ls_res + cSEP ;
			   break;  
			   
		   case 7 :    // The boolean type
			   break;
			   
		   case 8 :    // The geometric types
			   if (! (ls_res.startsWith(cSEP)) ) ls_res = cSEP + ls_res + cSEP ; 
			   break;
			   
		   case 9 :    // The cidr, inet types
			   if (! (ls_res.startsWith(cSEP)) ) ls_res = cSEP + ls_res + cSEP ;
			   break;
			   
		   case 10 :   // the UUID types
			   if (! (ls_res.startsWith(cSEP)) ) ls_res = cSEP + ls_res + cSEP ;
			   break;
			   
		   case 11 :   // The bit, varbit types
			   if (! (ls_res.startsWith(cBST)) ) ls_res = cBST + ls_res + cSEP ;
			   break;
			   
		   case 12 :   // The serial, bigserial types
			   break;
		 };
		 
		 return ls_res += plTF;
	 }
	 /**
	  *  2012-02-02  @author Nick
	  * @return list of PostgeSQL data types
	  */
	 public static String [] getListTypes () {
		 return c_T_VALUES;
	 }
	 /**
	  * 2012-03-05 @author Nick
	  * @return list of types categories
	  * return 
	  */
	 public static int [] getListTTypes () {
		 return c_T_CODES;
	 }
	 /**
	  *  @author Nick
	  *  @version 2012-07-06 
	  *  Return value of DB type category
	  */
     public static int getCategType ( String pType)  {
    	 
    	int l_len = c_T_VALUES.length;
    	for ( int i = 0; i < l_len; i++ ) 
    		if ( c_T_VALUES[i].equals ( pType.toLowerCase()) )
    			return c_T_CODES [i];
    	return -1;
     }
     /**
      * 2012-11-04 Nick
      * @param TField
      * @return Key of Message
      */
	 public static String getKeyOfMess ( int TField ) {
		 
		 switch ( TField ) {
		   case 0 :    // The integer types
				return "TNE100";
		   case 1 :    // The fixed point types ( decimal, numeric )
				return "TNE101";
		   case 2 :    // The float point types
				return "TNE102";
		   case 3 :    // The char, varchar, text types   2012-10-28 Nick
				return "TNE103";
		   case 4 :    //  The name type, internal type for the database 
				return "TNE104";
		   case 5 :    // The blob type
				return "TNE105";
		   case 6 :   // The data, datatime and interval types.
				return "TNE106";
		   case 7 :    // The boolean type
				return "TNE107";
		   case 8 :    // The geometric types
				return "TNE108";
		   case 9 :    // The cidr, inet types
				return "TNE109";
		   case 10 :   // the UUID types
				return "TNE110";
		   case 11 :   // The bit, varbit types
				return "TNE111";
		 };
		 return "";
	 }
     
     
} // End of Class
