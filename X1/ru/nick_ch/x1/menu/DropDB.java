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
 *  CLASS DropDB @version 1.0  
 *    Dialog for dropping DB. 
 *  History:
 *          2009-07-30 Rebuild this class, performing SQL instructions was added.
 *          2013-01-08 - Small testing. list of schemas.                      
 */
 
package ru.nick_ch.x1.menu;

import java.awt.Frame;
import java.awt.event.WindowAdapter;
import java.awt.event.WindowEvent;
import java.beans.PropertyChangeEvent;
import java.beans.PropertyChangeListener;
import java.util.Vector;

import javax.swing.JComboBox;
import javax.swing.JDialog;
import javax.swing.JOptionPane;
import javax.swing.JTextArea;
// import javax.swing.JTextField;

import ru.nick_ch.x1.db.PGConnection;
import ru.nick_ch.x1.idiom.Language;
import ru.nick_ch.x1.main.*;
import ru.nick_ch.x1.utilities.*;

public class DropDB extends JDialog implements Sql_menu {

// public area
public  String  comboText = null;
// public area

 private boolean doIt   = false ;
 private boolean inTree = false ;  // Nick 2009-08-03

 private   JOptionPane  optionPane;
 private   Language     idiom;
 private   JTextArea    LogWin; // Was added Nick 2009-07-30
 private   PGConnection conn;
 
 private   JComboBox combo1;
 private   Vector dbnames = new Vector (); // Nick 2009-08-03
 
 /****************************
  * METODO Constructor DropDB
  *
  */
 // public DropDB ( Frame aFrame, Language lang, Vector dbnames )   Nick 2009-07-30 Nick
 // CreateDB newDB = new CreateDB ( XPg.this, idiom, pgconn, LogWin )
 // ConnectionInfo online;    //Objeto de la clase ConnectionInfo que define la estructura de datos de la conexion
 
 public DropDB ( Frame aFrame, Language lang, PGConnection currentConn, 
		          String Db_online, JTextArea monitor 
 ) 
  {
   super ( aFrame, true );
   idiom = lang;
   setTitle ( idiom.getWord ( "DROPDB" ) );

   LogWin = monitor ;
   /** Nick
   String sqlCmmd = S_DATABASES + Db_online + S_DATABASES_1 ;
   this.dbnames = currentConn.TableQuery ( sqlCmmd );
   addTextLogMonitor ( idiom.getWord ( "EXEC" ) + sqlCmmd );
   **/
   // 2012-07-03 Nick
   this.dbnames = currentConn.getDbNamesVector ( true, false );
   addTextLogMonitor ( idiom.getWord ( "EXEC" ) + currentConn.getSQL() );
   //
   //  Stop here, 2009-08-02 Nick
   //
   if ( this.dbnames.size() == 0 ) { 

       JOptionPane.showMessageDialog ( aFrame,
       		idiom.getWord ("NDBS"),
       		idiom.getWord ("INFO"), 
       		JOptionPane.INFORMATION_MESSAGE );

       return;
    }

   if ( this.dbnames.size () == 1 ) { // 

       String db = GetStr.getStringFromVector ( dbnames, 0, 0 ) ; // -1 2013-01-08 Nick 
       
       if ( db.equals ( Db_online ) ) {

           JOptionPane.showMessageDialog ( aFrame,
           		idiom.getWord ( "OIDBC" ), idiom.getWord ( "INFO" ),
           		JOptionPane.INFORMATION_MESSAGE
           );

           return;
        }
    }
   
   Vector dataB = new Vector();
   for ( int i = 0; i < this.dbnames.size (); i++ )
            dataB.addElement( GetStr.getStringFromVector (dbnames, i, 0 )); // // -1 2013-01-08 Nick  
   
   combo1 = new JComboBox ( dataB );

   final String msgString1 = idiom.getWord ("QDROPDB");
   // final JTextField textField = new JTextField (10);
   Object[] array = { msgString1, combo1 };

   final String btnString1 = idiom.getWord ( "DROP" );
   final String btnString2 = idiom.getWord ( "CANCEL" );
   Object[] options = { btnString1, btnString2 };

   optionPane = new JOptionPane ( array, 
                                  JOptionPane.QUESTION_MESSAGE,
                                  JOptionPane.YES_NO_OPTION,
                                  null, options, options [0]
   );
   setContentPane ( optionPane);
   addWindowListener ( new WindowAdapter () {

       public void windowClosing ( WindowEvent we ) 
        {
         optionPane.setValue ( new Integer ( JOptionPane.CLOSED_OPTION ));
        }
      }
   );

   optionPane.addPropertyChangeListener ( new PropertyChangeListener () {
     public void propertyChange ( PropertyChangeEvent e) 
      {
       String prop = e.getPropertyName ();
       if ( isVisible () && ( e.getSource() == optionPane ) && 
    	     ( prop.equals ( JOptionPane.VALUE_PROPERTY ) ||
               prop.equals ( JOptionPane.INPUT_VALUE_PROPERTY )
              )
           ) 
        {   
         Object value = optionPane.getValue ();
         if ( value == JOptionPane.UNINITIALIZED_VALUE ) 
           return;

         if ( value.equals ( btnString1 )) 
           {
             comboText = (String) combo1.getSelectedItem ();
             doIt = true;
             setVisible ( false );
           } 
            else 
                setVisible ( false );
        }
      }
   });

   pack ();
   setLocationRelativeTo ( aFrame );
   setVisible ( true );
 }

 public boolean confirmDropDB ()
  {
    return doIt;
  }

 public boolean get_inTree ()
 {
   return this.inTree;
 }
 
 public String actionDropDB ( PGConnection currentConn, Vector vecConn  )
 {
     int pos = 0;
     this.inTree = false;
     
     /*** Nick 2009-09-03
            This point does not work now because the current datebase 
            was excluded from the list of deleted databases.
      ***/
     if ( this.dbnames.contains ( this.comboText ) ) { 

         this.inTree = true;
         pos = this.dbnames.indexOf ( this.comboText );
     }

     //Cerrar la conexion de la base de datos a borrar si existe
     if ( this.inTree ) { 

          PGConnection pgTmp = ( PGConnection ) vecConn.remove ( pos );
          pgTmp.close ();
          this.dbnames.remove ( pos );
     }

     //Eliminando BD   Nick 2009-07-29  "DROP DATABASE " + dropDB.comboText 
     String temp_instr = cDRP + cDB + cDQU + comboText + cDQU; // Nick 2012-02-20

     String result = currentConn.SQL_Instruction ( temp_instr ); 
     addTextLogMonitor ( idiom.getWord ("EXEC") + temp_instr + cDQU );
     
     return result;
 }
 
 // Was added 2009-07-30 Nick
 /*******************************************
  * Metodo addTextLogMonitor
  * Imprime mensajes en el Monitor de Eventos
  */
 private void addTextLogMonitor ( String msg ) {

   LogWin.append ( msg + "\n" );	
   int longiT = LogWin.getDocument ().getLength ();
   if ( longiT > 0 ) LogWin.setCaretPosition ( longiT - 1 );
 }	
} //Fin de la Clase

