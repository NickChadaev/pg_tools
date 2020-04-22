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
 *  CLASS CreateSchema @version 1.0  
 *    This class is responsible for managing the dialogue by
 *    which creates a schema. 
 *  History:
 *        2009-07-25 Nick Chadaev - nick_ch58@list.ru    
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

public class CreateSchema extends JDialog implements ActionListener {

 private String      typedText = null;
 private JOptionPane optionPane;
 final   JTextField  textField;

 Language     idiom;
 JTextArea    LogWin;
 PGConnection conn;
 
 boolean wasDone = false;
 Frame   fr;

 /**********************************
  * METODO Constructor CreateSchema
  *
  */
 public CreateSchema ( Frame aFrame, Language lang, PGConnection currentConn, JTextArea monitor ) {

   super ( aFrame, true );
   fr     = aFrame;
   idiom  = lang;
   conn   = currentConn;
   LogWin = monitor;
   setTitle ( idiom.getWord ( "NEWSCH" ) );

   final String msgString1 = idiom.getWord ( "QUESTSCH" );
   JLabel msg   = new JLabel ( msgString1, JLabel.CENTER );
   
   JPanel label = new JPanel ();
   label.setLayout ( new BorderLayout () );
   label.add ( msg, BorderLayout.CENTER );
   
   JPanel out = new JPanel (); 
   out.add ( label );

   textField = new JTextField ( 20 );

   textField.addActionListener ( new ActionListener () {
      public void actionPerformed ( ActionEvent e ) { Creating (); }
    }
   );

   JPanel text = new JPanel ();
   text.setLayout ( new BoxLayout ( text, BoxLayout.X_AXIS ) );
   text.add ( new JPanel () );
   text.add ( textField );
   text.add ( new JPanel () );

   JButton ok = new JButton ( idiom.getWord ( "CREATE" ) );
   ok.setActionCommand ( "OK" );
   ok.addActionListener ( this );
   
   JButton cancel = new JButton ( idiom.getWord ("CANCEL") );
   cancel.setActionCommand ( "CANCEL" );
   cancel.addActionListener ( this );

   JPanel topOne = new JPanel ();
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
 public String getSCHname () {
  return typedText; 
 }

 public void Creating () {

    typedText = textField.getText();

    if ( typedText.indexOf (" ") != -1 ) {

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
    String result = conn.SQL_Instruction ( "CREATE DATABASE \"" + typedText + "\"" );
    addTextLogMonitor ( idiom.getWord ("EXEC") + "CREATE DATABASE "+ typedText + "\"" );

    if ( result.equals ("OK") ) wasDone = true;
    else {
           textField.selectAll ();
           result = result.substring (7, result.length () - 1);

           JOptionPane.showMessageDialog ( 
        		   fr, idiom.getWord("ERRORPOS") + result,
                   idiom.getWord("ERROR!"), JOptionPane.ERROR_MESSAGE );
           typedText = null;
           textField.setText ("");
      }

    addTextLogMonitor ( idiom.getWord ("RES") + result );

 } 

 /**
  * Metodo addTextLogMonitor
  * Imprime mensajes en el Monitor de Eventos
  */
 public void addTextLogMonitor ( String msg ) {

   LogWin.append ( msg + "\n" );	
   int longiT = LogWin.getDocument().getLength ();
   if ( longiT > 0 ) LogWin.setCaretPosition ( longiT - 1 );

 }	

} //Fin de la Clase
