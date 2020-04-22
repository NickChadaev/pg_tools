/**
 * This software is free according GNU GENERAL PUBLIC LICENSE and
 * based on the XPg project, developed by KAZAK Solutions. 
 * Research and Development Group of Free Software, 
 * Santiago de Cali Republic of Colombia 2001.
 * Author:
 *          Gustavo GonzАlez <xtingray@kazak.com.co>.                   
 * ----------------------------------------------------------------------------
 * Now this software is developing for modern version of PostgreSQL.
 * Author: 
 *          Nick Chadaev <nick_ch58@list.ru>. Moscow, Russia. Single developer.
 *          New stage of developing had been started at 2009-06-16. 
 * ----------------------------------------------------------------------------
 *  CLASS ChooseIdiom @version 1.0   
 *    This class shows a dialog where the user can
 *    choose the language in which his want to display this application.    
 *  History:
 *   2009-04-26  Nick Chadaev, Moscow Russia. nick_ch58@list.ru
 *   I had added third language, Russian.         
 */

package ru.nick_ch.x1.misc.input;

import java.awt.GridLayout;
import java.awt.Toolkit;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.beans.PropertyChangeEvent;
import java.beans.PropertyChangeListener;
import java.net.URL;

import javax.swing.ButtonGroup;
import javax.swing.ImageIcon;
import javax.swing.JDialog;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JOptionPane;
import javax.swing.JPanel;
import javax.swing.JRadioButton;

public class ChooseIdiom extends JDialog {
 
 String idiom = "Russian";  /* "English" */
 boolean save = false;

 /**
  * METODO CONSTRUCTOR
  */
 public ChooseIdiom (JFrame aFrame) {
  
  super(aFrame, true);  
  setTitle("Your Language");    
  
  JLabel message = new JLabel("Please, choose your language option");
  
  URL imgURL = getClass().getResource("/icons/FlagUK.png");
  JRadioButton englishButton = new JRadioButton("English", new ImageIcon(Toolkit.getDefaultToolkit().getImage(imgURL)), true);
  englishButton.setMnemonic('n');
  englishButton.setActionCommand("english");

  imgURL = getClass().getResource("/icons/FlagSpain.png");
  JRadioButton spanishButton = new JRadioButton("Espanol", new ImageIcon(Toolkit.getDefaultToolkit().getImage(imgURL)));
  spanishButton.setMnemonic('s');
  spanishButton.setActionCommand("spanish");

  /* --- Nick --- 2009-05-29 */
  imgURL = getClass().getResource("/icons/FlagRussian.png");  /* FlagSpain.png */
  JRadioButton russianButton = new JRadioButton("Русский", new ImageIcon(Toolkit.getDefaultToolkit().getImage(imgURL)));
  russianButton.setMnemonic('r');
  russianButton.setActionCommand("russian");
  
  /* ----------------------------- */
  
  ButtonGroup group = new ButtonGroup();
 
  group.add(russianButton);
  group.add(spanishButton);
  group.add(englishButton);
  
  /***
      group.add(englishButton);
      group.add(spanishButton);
      group.add(russianButton);
   **/
 
  JPanel radioPanel = new JPanel();               
  radioPanel.setLayout(new GridLayout(0, 1));
  radioPanel.add(message);     

  radioPanel.add(russianButton);
  radioPanel.add(spanishButton);
  radioPanel.add(englishButton);          
 
  RadioListener myListener = new RadioListener();
  spanishButton.addActionListener(myListener);
  englishButton.addActionListener(myListener);
  russianButton.addActionListener(myListener);
  
  final String btnString1 = "Accept";
  final String btnString2 = "Cancel";
  Object[] options = { btnString1, btnString2 };
  Object[] array = { radioPanel };

  final JOptionPane optionPane = new JOptionPane(array, 
	                       JOptionPane.PLAIN_MESSAGE,
	                       JOptionPane.YES_NO_OPTION,
	                       null,
	                       options,
	                       options[0]);
  setContentPane(optionPane);

  optionPane.addPropertyChangeListener(new PropertyChangeListener() {
   public void propertyChange(PropertyChangeEvent e) {
    String prop = e.getPropertyName();
    if (isVisible() && (e.getSource() == optionPane) && (prop.equals(JOptionPane.VALUE_PROPERTY) ||
		       prop.equals(JOptionPane.INPUT_VALUE_PROPERTY)))
     {
	    Object value = optionPane.getValue();
	    if ( value == JOptionPane.UNINITIALIZED_VALUE ) return;					
  	    if ( value.equals (btnString1) ) setVisible (false);
 	    if ( value.equals (btnString2) ) System.exit (0);
     }
   }
  });    

 }
 
 /** Clase para escuchar los botones de seleccion. */
 class RadioListener implements ActionListener 
  {
     public void actionPerformed ( ActionEvent e ) 
     {
       if ( e.getActionCommand().equals ("spanish" )) idiom = "Spanish";
       if ( e.getActionCommand().equals ("english" )) idiom = "English";
       if ( e.getActionCommand().equals ("russian" )) idiom = "Russian";
     }
  }
 
 /**
  * Mйtodo getIdiom
  */
 public String getIdiom() 
 {
  return idiom;
 } 
 
}              
