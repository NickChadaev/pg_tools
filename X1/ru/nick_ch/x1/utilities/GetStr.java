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
 *  CLASS   @version 2.0 
 *  	The item of type Vector will be transformed to the string type. 
 *  	Data of type Vector are widely used in the project X1. Very often 
 * 		in the code of methods there are fragments transforming a vector 
 * 		element to character string. For their replacement this class has 
 * 		been created.  
 *  History:
 *       Created 2009/12/09 Nikolay Chadaev
 *               2011/12/09 getStringFromVector() was modified.
 *               2013-07-07 getStringsFromVector () was modified/
 *           
 */

package ru.nick_ch.x1.utilities;

import java.util.Vector;

public class GetStr {

 private static String l_res = "";
 private static Vector lRes ;
		
    public GetStr () {
			
		super ();
    } // End of constructor
	  
/**
 *  GetStringFromVectorB. Nick 2011-12-09    
 * @param pList
 * @param p_ind1
 * @param p_ind2
 * @return
 */
   
 /**----------------------------------------
  *  GetStringFromVector. Nick 2011-12-09
  *  
  * @param pList
  * @param p_ind1
  * @param p_ind2
  * Nick 2012-11-11
  * p_ind2 is string index of subVector, it means:
  *    -1  [<String1>, <String2>...<StringN>]                      
  *     0 [[<String1>], [<String2>]...[<StringN>]]
  *   >=0 [[<String11>, <String12> ..<String13>], [], [], ...]
  * @return
  */
  public static String getStringFromVector ( Vector pList, int p_ind1, int p_ind2 )  {                	
 		
		 if ( p_ind2 < 0 ) l_res = ( String ) pList.elementAt ( p_ind1 ).toString (); 
		 else { 
			    Vector l_table =  (Vector )(pList.elementAt ( p_ind1 ));
			    l_res = ( String ) l_table.elementAt ( p_ind2 ).toString ();
		 }
		 return l_res;         
  } // getStringFromVector
 
 /**
 *  GetStringsFromVector. Nick 2011-12-09, 2013-07-07
 * @param pList
 * @return
 */
   public static String [] getStringsFromVector ( Vector pList ) {
	   
      int lList_s = pList.size() ;
      String[] colNames = new String [ lList_s ];

      for ( int i = 0; i < lList_s; i++ ) 
            colNames [ i ] = ( String ) getStringFromVector ( pList, i, -1 );
      
      return colNames;
   } // End of getStringsFromVector
   
 /** ---------------------- 
 public static Vector getStringsFromVector ( Vector pList )  { 
	    
	    int lenVec = pList.size() ;
	    lRes = new Vector ( 0 ) ;
	    String ls ;
	    
	    for ( int i = 0; i < lenVec; i++ ) {
	    
	      	ls = ( String ) getStringFromVector ( pList, i, 0 ) ; 
	        lRes.add ( ls );	
	    }
	    
	    return lRes;         

} // getStringFromVector
 **/
/**
 *  Get description by name. Nick 2011-12-09
 * @param pList
 * @param p_arg
 * @return
 */
public static String getDescrByName ( Vector pList, String p_arg )  {                	
	    
		Vector l_vect ;
		String l_str = "" ;
		
		for ( int i = 0; i < pList.size(); i++ ) {

			l_vect = ( Vector ) pList.get ( i ); 
			l_str  = ( String ) l_vect.elementAt ( 0 );
			if ( l_str.equals( p_arg ) ) {
			    l_res = ( String ) l_vect.elementAt ( 1 );
			    break;
			}
		}
		return l_res;                
	  }  // getDescrByName
 
 
} // End of Class
