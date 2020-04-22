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
 *  CLASS ExtensionFilter @version 1.0  
 *    This class is responsible for generating a filter in a list
 *    according to a file type extension. 
 *  History:
 *          2009-08-11 Nick was here  
 */

package ru.nick_ch.x1.misc.file;

import java.io.File;
import java.util.Enumeration;
import java.util.Hashtable;

import javax.swing.filechooser.FileFilter;

public class ExtensionFilter extends FileFilter {

    private static String TYPE_UNKNOWN = "Type Unknown";
    private static String HIDDEN_FILE = "Hidden File";

    private Hashtable filters = null;
    private String description = null;
    private String fullDescription = null;
    private boolean useExtensionsInDescription = true;

    public ExtensionFilter () {
    	this.filters = new Hashtable ();
    }

    public ExtensionFilter ( String extension ) {
    	this ( extension, null );
    }

    public ExtensionFilter ( String extension, String description ) {
    	this ();
    	if ( extension != null ) addExtension ( extension );
    	if ( description != null ) setDescription ( description );
    }

    public ExtensionFilter ( String [] filters ) {
    	this ( filters, null );
    }

    public ExtensionFilter( String [] filters, String description ) {
    	this ();
    	for ( int i = 0; i < filters.length; i++ ) {
	        // a�ade filtros, uno por uno
	        addExtension ( filters [i] );
	    }
 	    if ( description != null ) setDescription ( description );
    }

    public boolean accept ( File f ) {
	  
      if ( f != null ) {
	      if ( f.isDirectory ( )) {
	    	  	return true;
	      }
	      String extension = getExtension ( f );
	      if ( extension != null && filters.get ( getExtension ( f ) ) != null ) {
		       return true;
	      };
	  }
	   return false;
    }

     public String getExtension ( File f ) {
    	
    	if ( f != null ) {
    			String filename = f.getName();
    			int i = filename.lastIndexOf ('.');
    			if ( i > 0 &&  i < filename.length ()-1 ) {
		                    return filename.substring ( i + 1 ).toLowerCase ();
	            };
	    }  
	    
    	return null;
    }

    public void addExtension ( String extension ) {
    	
    	if ( filters == null ) {
    		  filters = new Hashtable (5);
    	}
    	
    	filters.put ( extension.toLowerCase (), this );
    	fullDescription = null;
    }

    public String getDescription() {
    	
    	if ( fullDescription == null ) {
    		
    		if ( description == null || isExtensionListInDescription () ) {
    			fullDescription = description==null ? "(" : description + " (";
    			// Construye la descripcion de la lista de extension
    			Enumeration extensions = filters.keys ();
    			if ( extensions != null ) {
    				fullDescription += "." + ( String ) extensions.nextElement ();
    				while ( extensions.hasMoreElements () ) {
    					fullDescription += ", " + ( String ) extensions.nextElement ();
    				}
    			}
    			fullDescription += ")";
    		} else {
    				fullDescription = description;
    		  }
		}
	  	
    	return fullDescription;
    }

   
    public void setDescription ( String description ) {
    	
    	this.description = description;
    	fullDescription = null;
    }
    
    public void setExtensionListInDescription ( boolean b ) {
    	
    	useExtensionsInDescription = b;
    	fullDescription = null;
    }
    
    public boolean isExtensionListInDescription	() {
    		return useExtensionsInDescription;
    }
}
