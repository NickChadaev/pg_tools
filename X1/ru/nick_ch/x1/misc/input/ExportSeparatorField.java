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
 *  CLASS ExportSeparatorField @version 1.0  
 *    Class that is responsible for managing the dialogue through the
 *    which defines the separator for fields in a query that will be stored
 *    in a file. This class is instantiated from the class Queries.
 *  History:
 *           
 */

package ru.nick_ch.x1.misc.input;

import ru.nick_ch.x1.idiom.*;
import javax.swing.JOptionPane;
import javax.swing.JDialog;
import javax.swing.JPanel;
import javax.swing.JTextField;
import javax.swing.JComboBox;
import javax.swing.*;
import java.beans.*; 
import java.awt.*;
import java.awt.event.*;

public class ExportSeparatorField extends JDialog implements ActionListener {

 private String typedText = null;
 private JOptionPane optionPane;
 Language idiom;
 boolean wasDone = false;
 JComboBox limiter;
 String answer=" ";
 final JTextField textField;

 /**
  * METODO Constructor ExportSeparatorField
  *
  */
 public ExportSeparatorField(Frame aFrame, Language lang) {

   super(aFrame, true);
   idiom = lang;
   setTitle(idiom.getWord("SEPA"));

   JPanel block = new JPanel();
   block.setLayout(new BorderLayout());
   JLabel label = new JLabel(idiom.getWord("SFS"),JLabel.CENTER);
   block.add(label,BorderLayout.NORTH);
   JPanel central = new JPanel();
   central.setLayout(new GridLayout(0,1));
   JLabel pre = new JLabel(idiom.getWord("PD"),JLabel.LEFT);
   central.add(pre);
   pre = new JLabel(idiom.getWord("CZ"),JLabel.LEFT);
   central.add(pre);
   JPanel side = new JPanel();
   side.setLayout(new GridLayout(0,1));
   String[] limiters = {idiom.getWord("SB"),idiom.getWord("REPCSV"),idiom.getWord("TAB"),idiom.getWord("COMMA"),
   idiom.getWord("DOT"),idiom.getWord("COLON"),idiom.getWord("SCOLON")};

   limiter = new JComboBox(limiters);
   limiter.addActionListener(this); 
   side.add(limiter);
   textField = new JTextField();
   side.add(textField);
   block.add(central,BorderLayout.CENTER);
   block.add(side,BorderLayout.EAST);

   Object[] array = {block};

   final String btnString1 = idiom.getWord("OK");
   final String btnString2 = idiom.getWord("CANCEL");
   Object[] options = {btnString1, btnString2};

   optionPane = new JOptionPane(array, 
                                JOptionPane.PLAIN_MESSAGE,
                                JOptionPane.YES_NO_OPTION,
                                null,
                                options,
                                options[0]);
   setContentPane(optionPane);

   addWindowListener(new WindowAdapter() {

     public void windowClosing(WindowEvent we) {
       optionPane.setValue(new Integer(JOptionPane.CLOSED_OPTION));
      }
   });

   textField.addActionListener(new ActionListener() {
     public void actionPerformed(ActionEvent e) {
       optionPane.setValue(btnString1);
      }
   });

   optionPane.addPropertyChangeListener(new PropertyChangeListener() {

     public void propertyChange(PropertyChangeEvent e) {

       String prop = e.getPropertyName();
       if (isVisible() && (e.getSource() == optionPane)
           && (prop.equals(JOptionPane.VALUE_PROPERTY) ||
           prop.equals(JOptionPane.INPUT_VALUE_PROPERTY))) {
   
         Object value = optionPane.getValue();
         if (value == JOptionPane.UNINITIALIZED_VALUE) 
           return;

         if (value.equals(btnString1)) {

             setVisible(false);
             wasDone = true;
             typedText = textField.getText();

             if (typedText.length()>0)
                 answer = typedText;
          } 
         else 
            setVisible(false);
        }
     }
   });

   setSize(260,150);
   pack();
   setLocationRelativeTo(aFrame);
   show();
 }

 public boolean isDone() {
   return wasDone;
  }

 public String getLimiter() {
   return answer; 
  }

 public void actionPerformed(ActionEvent e) {

    JComboBox cb = (JComboBox)e.getSource();
    int index = cb.getSelectedIndex();

    switch(index) {

           case 0: answer = " "; break;
           case 1: answer = "csv"; break;
           case 2: answer = "	"; break;
           case 3: answer = ","; break;
           case 4: answer = "."; break;
	   case 5: answer = ":"; break;
           case 6: answer = ";"; break;
        }

    textField.setText("");
  }

} //Fin de la Clase

