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
 *  CLASS Path @version 2.0  Created path to X1 work files.
 *  History:
 *          2009/11/20 - Nick rebuild it. There was the hard bug.
 */

package ru.nick_ch.x1.utilities;

import java.io.File;
import ru.nick_ch.x1.misc.file.*;

public class Path implements File_consts {
	
	private static String pathxpg = "";
	/**
	 * 
	 */
	public Path () {
		super ();
		// TODO Auto-generated constructor stub
	}

	/**
	 * @return
	 */
	public static String getPathxpg() {
		try {
			File tmp = File.createTempFile ( CFG_NAME_T, CFG_NAME_1 );
			pathxpg = tmp.getParent ();
			tmp.delete (); // Need to do  :) else much of rubbish
			
			return pathxpg;
			
		} catch ( Exception e ) {
			e.printStackTrace ();
		}
		return pathxpg;
	}
}
