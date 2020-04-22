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
 *  CLASS CreateDB @version 1.0  
 *     This class is responsible for managing the dialogue by
 *     Which creates a database.
 *  History:
 *       2009-07-29 The create comment clause was added    
 */

package ru.nick_ch.x1.menu;

import java.awt.BorderLayout;
import java.awt.FlowLayout;
import java.awt.Frame;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

import javax.swing.BoxLayout;
import javax.swing.JButton;
import javax.swing.JDialog;
import javax.swing.JLabel;
import javax.swing.JOptionPane;
import javax.swing.JPanel;
import javax.swing.JTextArea;
import javax.swing.JTextField;

import ru.nick_ch.x1.db.PGConnection;
import ru.nick_ch.x1.idiom.Language;

public class CreateDB extends JDialog implements ActionListener, Sql_menu {

 private boolean wasDone   = false;
	
 private String typedText   = null;
 private String typedText_c = null;
 
 private JOptionPane optionPane;
 
 // Nick 2009-07-28. Second text field was added.
 private JTextField  textField;     // Database name
 private JTextField  textField_c;   // Database comment
 
 private Language     idiom;
 private JTextArea    LogWin;
 private PGConnection conn;
 private Frame        fr;

 /**
  * METODO Constructor CreateDB
  *
  */
 public CreateDB ( Frame aFrame, Language lang, PGConnection currentConn, JTextArea monitor ) {

   super ( aFrame, true );
   fr     = aFrame;
   idiom  = lang;
   conn   = currentConn;
   LogWin = monitor;
   setTitle ( idiom.getWord ( "NEWDB" ) );

   final String msgString1 = idiom.getWord ( "QUESTDB" );
   
   JLabel msg = new JLabel ( msgString1, JLabel.LEFT ); // CENTER 
   
   JPanel label = new JPanel ();
   label.setLayout ( new BorderLayout () );
   
   label.add ( msg, BorderLayout.CENTER );  
   
   JPanel out = new JPanel (); 
   out.add ( label );

   textField   = new JTextField ( 7 );
   textField_c = new JTextField ( 22 ); // Nick 2009-07-28
   
   textField.addActionListener ( new ActionListener () {
      public void actionPerformed ( ActionEvent e ) { Creating (); }
    }
   );
   textField_c.addActionListener ( new ActionListener () {
	      public void actionPerformed ( ActionEvent e ) { Creating (); }
	    }
   );

   JPanel text = new JPanel();
   text.setLayout ( new BoxLayout ( text, BoxLayout.X_AXIS ) );
   text.add ( new JPanel () );
   text.add ( textField );
   text.add ( textField_c ); // Nick 2009_07_28
   
   text.add ( new JPanel () );

   JButton ok = new JButton ( idiom.getWord ( "CREATE" ) );
   ok.setActionCommand ( "OK" );
   ok.addActionListener ( this );
   
   JButton cancel = new JButton ( idiom.getWord ("CANCEL") );
   cancel.setActionCommand ( "CANCEL" );
   cancel.addActionListener ( this );

   JPanel topOne = new JPanel();
   topOne.setLayout ( new BoxLayout ( topOne, BoxLayout.Y_AXIS )); 
   topOne.add ( out );
   topOne.add ( text );

   JPanel botones = new JPanel ();
   botones.setLayout ( new FlowLayout ( FlowLayout.CENTER ));
   botones.add ( ok );
   botones.add ( cancel );

  JPanel global = new JPanel ();
  global.setLayout ( new BoxLayout ( global, BoxLayout.Y_AXIS ));
  global.add ( topOne );
  global.add ( botones );

  getContentPane().add(global);

  pack ();
  setLocationRelativeTo ( fr );
  setVisible ( true );
    
 }

 public void actionPerformed ( java.awt.event.ActionEvent e ) {

   if ( e.getActionCommand().equals ("CANCEL") ) {

       setVisible ( false );
       return;
    }

   if ( e.getActionCommand().equals ("OK") ) {

       Creating ();
       return;
    }
 }

 public boolean isDone() {
  return wasDone;
 }

 /**
  * METODO getDBname
  * Retorna en una cadena el nombre de la 
  * base de datos digitado por el usuario
  */
 public String getDBname () {
  return typedText; 
 }

 private void Creating () {

    typedText   = textField.getText();
    typedText_c = textField_c.getText();

    if ( typedText.indexOf (cSPACE) != -1 ) {

        JOptionPane.showMessageDialog ( fr, idiom.getWord ( "NOCHAR" ),
                 idiom.getWord ( "ERROR!" ), JOptionPane.ERROR_MESSAGE 
        );
        return;
     }

    if ( typedText.length () == 0 ) {

         JOptionPane.showMessageDialog ( fr, idiom.getWord ("EMPTYDB"),
                                         idiom.getWord ("ERROR!"), JOptionPane.ERROR_MESSAGE
        );
        return;
     }

    setVisible ( false );
    
    String temp_name  = cDQU + typedText + cDQU; // Nick 2012-02-20 
    String temp_instr = cCRT + cDB + temp_name;
    String result = conn.SQL_Instruction ( temp_instr );        // Nick 2009_07_29 
                                           // "CREATE DATABASE \"" + typedText + "\"" 
    addTextLogMonitor ( idiom.getWord ( "EXEC" ) + temp_instr + cDQU );
    
    if ( result.equals ( "OK" ) ) { // Nick 2009_07_29
          wasDone = true;
          addTextLogMonitor ( idiom.getWord ("RES") + result );

          // COMMENT ON DATABASE <name> IS '<comment's text>';  Nick 2009-07-29
          if ( typedText_c.length () != 0 ) { 
        	    temp_instr = cCMT + cDB + temp_name + cIS + typedText_c + cSEP;
                result = conn.SQL_Instruction ( temp_instr );
                addTextLogMonitor ( idiom.getWord ( "EXEC" ) + temp_instr + cDQU );

                if ( result.equals( "OK") ) { 
                	wasDone = true;
                    addTextLogMonitor ( idiom.getWord ("RES") + result );
                }
                else {
                    textField_c.selectAll ();
                    result = result.substring ( 7, result.length () - 1 );
                    addTextLogMonitor ( idiom.getWord ("RES") + result );

                    JOptionPane.showMessageDialog ( 
                 		   fr, idiom.getWord ( "ERRORPOS" ) + result,
                            idiom.getWord ( "ERROR!" ), JOptionPane.ERROR_MESSAGE  
                    );
                    textField_c.setText ( cEMP );
                    typedText_c = null;           
                    wasDone     = false;
                }
          } // Comment are present
    }      
    else {
           textField.selectAll ();
           result = result.substring ( 7, result.length () - 1 );
           addTextLogMonitor ( idiom.getWord ("RES") + result );

           JOptionPane.showMessageDialog ( 
        		   fr, idiom.getWord ( "ERRORPOS" ) + result,
                   idiom.getWord ( "ERROR!" ), JOptionPane.ERROR_MESSAGE  
           );
           textField.setText ( cEMP );
           typedText = null;
           wasDone   = false;
      }
    // setVisible ( false );
    return;
 } 
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
