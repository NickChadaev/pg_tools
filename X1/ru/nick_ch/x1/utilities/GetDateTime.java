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
 *  CLASS getDateTime  @version 1.0 
 *       Operations with data of Date-time type. 
 *       Are used for creation and  filling the LOG-file.
 *  History:
 *         Created: 2009/12/09 Nikolay Chadaev
 *           
 */

package ru.nick_ch.x1.utilities;

// import java.util.Vector;
import java.util.Calendar;

public class GetDateTime {

	private static String dformat;	
	private static String[] val = new String [5];
	
    public GetDateTime () {
		
		super ();
    } // End of constructor

    /**
     * METODO getTime
     * Retorna la hora
     */
    private static String[] getTime() {

      Calendar today = Calendar.getInstance ();
            
      int monthInt  = today.get ( Calendar.MONTH ) + 1;
      int minuteInt = today.get ( Calendar.MINUTE );
      
      String zero = "";
      String min  = "";

      if ( monthInt < 10 ) zero = "0";
      if ( minuteInt < 10 ) min = "0";

      val[0] = ""   + today.get(Calendar.DAY_OF_MONTH);
      val[1] = zero + monthInt;
      val[2] = ""   + today.get(Calendar.YEAR);
      val[3] = ""   + today.get(Calendar.HOUR_OF_DAY);
      val[4] = min  + today.get(Calendar.MINUTE);

      return val;
    }

    /**
     * METODO DateLogName
     * Crea el nombre del archivo de logs segun la fecha
     */
     public static String DateLogName() {

      val = getTime ();	 
      dformat = val[0] + "-" + val[1] + "-" + val[2] + "_" + val[3] + "-" + val[4];
      
      return dformat;
     }

     /****
      * 17:53 19/11/2009
      */
     public static String DateClassic () {

        // String dformat = val[3] + ":" + val[4] + " " + val[0] + "/" + val[1] + "/" + val[2]; // 17:53 19/11/2009
    	val = getTime ();
    	dformat = val[2] + "-" + val[1] + "-" + val[0] + " " + val[3] + ":" + val[4] ; // 17:53 19/11/2009

        return dformat;
       }
}

		
