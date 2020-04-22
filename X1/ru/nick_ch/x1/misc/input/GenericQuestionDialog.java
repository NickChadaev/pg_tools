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
 *  CLASS GenericQuestionDialog @version 1.0  
 *    This class is responsible for displaying windows confirmation before
 *    events that require confirmation. The options are always boolean type.
 *    Objects of this type are created from the class XPG. 
 *  History:
 *           
 */

package ru.nick_ch.x1.misc.input;

import javax.swing.JOptionPane;
import javax.swing.JDialog;
import javax.swing.JFrame;
import javax.swing.JLabel;
import java.awt.event.*;
import java.beans.*;

public class GenericQuestionDialog extends JDialog {

 private JOptionPane optionPane;
 boolean exit;
 
 /**
  * METODO CONSTRUCTOR
  *   Nick 2009-06-16, I have saw.
  */
 public GenericQuestionDialog ( JFrame parent, String button1, String button2, String title, 
		                        String message)  {        
   super( parent, true );        
   
   setTitle ( title );                            
   
   final String btnString1 = button1;                                
   final String btnString2 = button2;                                 
   
   Object[] options = { btnString1, btnString2 };                    
   // String line = message; Nick 2009-07-10    
   JLabel msg = new JLabel ( message, JLabel.CENTER );
   Object[] array = { msg };                                     
   optionPane = new JOptionPane ( array,                        
                                  JOptionPane.PLAIN_MESSAGE,     
                                  JOptionPane.YES_NO_OPTION,     
                                  null,                          
                                  options,                       
                                  options [0]
   );                                                                            
   setContentPane ( optionPane );                                
   setDefaultCloseOperation ( DO_NOTHING_ON_CLOSE ); 
   
   addWindowListener ( new WindowAdapter () {
      public void windowClosing ( WindowEvent we ) {
          optionPane.setValue ( new Integer ( JOptionPane.CLOSED_OPTION ) ); 
       }                                                        
      }
   ); // addWindowListener       

   optionPane.addPropertyChangeListener ( new PropertyChangeListener () {
     
	 public void propertyChange(PropertyChangeEvent e) 
      {
       String prop = e.getPropertyName ();
                                  
       if ( isVisible() && ( e.getSource() == optionPane ) && 
    	       ( prop.equals ( JOptionPane.VALUE_PROPERTY ) ||
                 prop.equals ( JOptionPane.INPUT_VALUE_PROPERTY )
                )
          )
         {                                         
           Object value = optionPane.getValue ();
           if ( value == JOptionPane.UNINITIALIZED_VALUE ) return;
           if ( value.equals ( btnString1 ) ) {
	            setVisible ( false );
	            exit = true;
	       }
            else {
	              setVisible ( false );
	              exit = false;
	             }
         }               
      }
    } // addPropertyChangeListener
   );

   pack ();
   setLocationRelativeTo ( parent );
   setVisible ( true );

 } // GenericQuestionDialog
 
 /**
  * METODO getSelecction
  * MÈtodo que retorna la respuesta del usuario
  */
 public boolean getSelecction () {
   return exit;
  }

} //Fin de la Clase    
