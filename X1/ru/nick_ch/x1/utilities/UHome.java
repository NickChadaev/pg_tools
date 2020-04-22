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
 *  CLASS UHome @version 1.0  There is creating path to the user home catalog. 
 *  History:
 *         Created: 2009/12/09 Nick Chadaev  
 */

package ru.nick_ch.x1.utilities;

import ru.nick_ch.x1.misc.file.*;

public class UHome  implements File_consts {

  private static String lStr = "";
	
  public UHome () {
		
		super ();
	}

/**
  *  2009-11-20 Nick
  * @return User home catalog name
  */
  public static String getUHome ( String p_OS ) {

    if ( p_OS.equals ( cSYS_OS_LIN ) || p_OS.equals ( cSYS_OS_SOL ) || p_OS.equals ( cSYS_OS_BSD ))

        lStr = System.getProperty ( UNIX_HOME_CATALOG ) + System.getProperty ( cSYS_FILE_SEP ) +
               UNIX_PROGRAM_CATALOG + System.getProperty ( cSYS_FILE_SEP ) ;
    else
    
       if ( p_OS.startsWith ( cSYS_OS_WIN ) ) 
 	
   	    lStr = System.getProperty ( WINDOWS_PROP_NAME ) + System.getProperty ( cSYS_FILE_SEP );
	       
       else
       	 lStr = "." + System.getProperty ( cSYS_FILE_SEP );
    
	  return lStr;
  }
} // End of class