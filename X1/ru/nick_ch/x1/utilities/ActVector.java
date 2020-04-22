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
 *  CLASS actVector  @version 1.0  
 * 			The data of type Vector are widely used in the project X1. 
 * 			For their operation this class has been created. 
 *  History:
 *   	 Created: 2013/04/06 Nikolay Chadaev
 *           
 */

package ru.nick_ch.x1.utilities;

import java.util.Vector;

public class ActVector {

	private static Vector lRes ;
			
	public ActVector () {
			super ();
	} // End of constructor

 public static Vector sorting ( Vector p_in ) {

	    lRes = p_in;
	    for ( int i = 0; i < lRes.size()-1; i++ )
		     {
		      for(int j = i + 1; j < lRes.size(); j++ )
		       {
		         String first  = (String) lRes.elementAt(i);
		         String second = (String) lRes.elementAt(j);
		         if ( second.compareTo ( first ) < 0 ) {
		        	 	lRes.setElementAt ( second, i );
		        	 	lRes.setElementAt ( first, j );
		          }
		       }
		     }
		return lRes;
 }
} // End of class 
