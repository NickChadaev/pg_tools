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
 *  CLASS DisplayControl @version 1.0 
 *     This class is responsible for managing the dialogue by
 *     Which removes a record in a table.  
 *  History:
 *          2009-10-07 Nick - was here. 
 *          2010-02-24 Nick - modified:
 *            1 - List of name always contains protected name characters,
 *            2 - The settings for keeping visible fields always set for
 *                session.
 *            3 - List of fields contains  three columns: first -
 *                number of field, second - name of fields, third - comment.
 *            4 - OID is not presents. 
 *          Go on !            
 */
 
package ru.nick_ch.x1.records;

import java.awt.BorderLayout;
import java.awt.Dimension;
import java.awt.FlowLayout;
import java.awt.GridLayout;
import java.awt.event.ActionListener;
import java.util.Hashtable;
import java.util.StringTokenizer;
import java.util.Vector;

import javax.swing.BorderFactory;
import javax.swing.BoxLayout;
import javax.swing.JButton;
import javax.swing.JCheckBox;
import javax.swing.JDialog;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JOptionPane;
import javax.swing.JPanel;
import javax.swing.JScrollPane;
import javax.swing.border.Border;
import javax.swing.border.TitledBorder;

import ru.nick_ch.x1.db.Table;
import ru.nick_ch.x1.idiom.Language;

public class DisplayControl extends JDialog implements ActionListener, Records_consts {

 Table myTable;
 Hashtable checkFields = new Hashtable();
 
 JButton  clear;
 int      numFields;
 Language idiom;
 
 boolean selected = true;
 
 Vector fields; 
 String filter = ""; 
 
 boolean wellDone = false;

 public DisplayControl ( Table table, JFrame parent, Language leng, String nameFields ) 
  {
   super ( parent, true );

	String  s_comm ;    // Nick 2010-02-13
    String  nfield ;    // Nick 2010-02-02
    String  ls ;        // Nick 2010-02-25 
   
   idiom = leng;
   setTitle ( idiom.getWord ( "DSPLY" ) );
   myTable = table;

   Hashtable previewFields = new Hashtable (); 

   JPanel global = new JPanel ();
   global.setLayout ( new BoxLayout ( global, BoxLayout.Y_AXIS ) );

   JPanel base1 = new JPanel ();
   base1.setLayout ( new GridLayout ( 0, 1 ) );

   JPanel base2 = new JPanel ();
   base2.setLayout ( new GridLayout ( 0, 1 ) );
   
   JPanel base3 = new JPanel ();
   base3.setLayout ( new GridLayout ( 0, 1 ) );
   
   numFields = myTable.getTableHeader ().getNumFields ();
   Hashtable hashFields = myTable.getTableHeader ().getHashtable ();
   fields = myTable.getTableHeader ().getNameFields ();

   if ( !nameFields.equals ( "*" ) ) {    

       StringTokenizer st = new StringTokenizer ( nameFields, S_COMMA );

       while ( st.hasMoreTokens () ) {

              String field = st.nextToken ();
              previewFields.put ( field, field );
        }
   }
   else
	   for ( int j = 0; j < numFields; j++ ) {
		   
		   String field = ( String ) fields.elementAt ( j ).toString().trim();
		   previewFields.put ( ( PN + field + PN ), ( PN + field + PN ) );     
	   }
   
   for ( int i = 0; i < numFields; i++ ) {

        nfield = ( String ) fields.elementAt (i);
        if ( ( i + 1 ) < 10 ) ls = S_SPACES_2 + ( i + 1 ) ; else ls = ( i + 1 ) + "";  
	    JLabel nmb  = new JLabel ( ls + S_DELIMITER );
	    base1.add ( nmb ) ;
	    //
	    JCheckBox check = new JCheckBox ( nfield );
        checkFields.put ( "" + i, check );
        base2.add ( check );

	    s_comm = myTable.getTableHeader().getTableFieldRecord ( nfield ).getComment() ; // Nick 2012-07-26
	    JLabel l_comm = new JLabel ( S_DELIMITER + s_comm );
        base3.add ( l_comm );

        check.setSelected ( previewFields.containsKey ( PN + nfield + PN ) );
        
   } // fin for

   JPanel center = new JPanel ();
   center.setLayout ( new BorderLayout () );
   center.add ( base1, BorderLayout.WEST );
   center.add ( base2, BorderLayout.CENTER );
   center.add ( base3, BorderLayout.EAST );

   JPanel up = new JPanel();
   up.setLayout ( new FlowLayout ( FlowLayout.CENTER ) );
   up.add ( center );

   Border etched1 = BorderFactory.createEtchedBorder ();
   TitledBorder title1 = BorderFactory.createTitledBorder ( etched1, idiom.getWord ( "VFIELDS" ) );
   up.setBorder ( title1 );

   JButton ok = new JButton ( idiom.getWord ( "OK" ) );
   ok.setActionCommand ( "OK" );
   ok.addActionListener ( this );

   clear = new JButton ( idiom.getWord ( "SELALL" ) );
   clear.setActionCommand ( "SELECTION" );
   clear.addActionListener ( this );

   JButton cancel = new JButton ( idiom.getWord ( "CANCEL" ) );
   cancel.setActionCommand ( "CANCEL" );
   cancel.addActionListener ( this );

   JPanel botons = new JPanel ();
   botons.setLayout ( new FlowLayout ( FlowLayout.CENTER ) );
   botons.add ( ok );
   botons.add ( clear );
   botons.add ( cancel );

   if ( numFields > 15 ) {
         JScrollPane scroll = new JScrollPane ( up );
         scroll.setPreferredSize ( new Dimension ( 400, 400 ) );
         global.add ( scroll );
    }
   else
         global.add ( up );
   
   global.add ( botons );

   getContentPane().add ( global );
   pack ();
   setLocationRelativeTo ( parent );
   setVisible ( true );
 }

 public void actionPerformed ( java.awt.event.ActionEvent e ) {

  if ( e.getActionCommand().equals ( "OK" )) {

	 filter = "" ;  
     for ( int k = 0; k < numFields; k++ ) { 

       JCheckBox chTmp = ( JCheckBox ) checkFields.get ( "" + k );
       
       if ( chTmp.isSelected () ) {
       
    	   String nf = ( String ) fields.elementAt ( k );
           nf = PN + nf + PN; 
           filter += nf + S_COMMA;
       }

     } // fin for

     if ( filter.length () > 0 ) filter = filter.substring ( 0, filter.length () - 1 );
     if ( filter.length () == 0 ) {

             JOptionPane.showMessageDialog ( DisplayControl.this,
                    idiom.getWord ( "ALOF" ), idiom.getWord ( "ERROR!" ), JOptionPane.ERROR_MESSAGE
             );

             return; 
     }
     wellDone = true; 
     setVisible ( false );
     
     return; 
  }

  if ( e.getActionCommand ().equals ( "SELECTION" )) {

      for ( int k = 0; k < numFields; k++ ) {
           JCheckBox chTmp = ( JCheckBox ) checkFields.get ( "" + k );
           chTmp.setSelected ( selected );
       } // fin for

     if ( selected ){
        
    	selected = false;
        clear.setText ( idiom.getWord ( "UNSELALL" ));
      }
     else {
            selected = true;
            clear.setText ( idiom.getWord ( "SELALL" ));
      }

     return;
  }

  if ( e.getActionCommand ().equals ( "CANCEL" )) {
        
	     setVisible ( false );
         return;
  }

 } // fin del Metodo

 public String getFilter () {
   
	    return filter;
  }
 public boolean isWellDone () {
   
	   return wellDone;
  }

} //Fin de Clase
