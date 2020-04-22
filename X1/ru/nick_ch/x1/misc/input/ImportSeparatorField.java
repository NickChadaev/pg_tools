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
 *  CLASS ImportSeparatorField @version 1.0                                                  
 *            This class is instantiated from the class Queries. 
 * ----------------------------------------------------------------------------          
 * History:       
 *                           
 */

package ru.nick_ch.x1.misc.input;

import java.awt.BorderLayout;
import java.awt.FlowLayout;
import java.awt.Frame;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.event.WindowAdapter;
import java.awt.event.WindowEvent;
import java.beans.PropertyChangeEvent;
import java.beans.PropertyChangeListener;

import javax.swing.JDialog;
import javax.swing.JLabel;
import javax.swing.JOptionPane;
import javax.swing.JPanel;
import javax.swing.JTextField;

import ru.nick_ch.x1.idiom.Language;

public class ImportSeparatorField extends JDialog {

 private String typedText = null;
 private JOptionPane optionPane;
 Language idiom;
 boolean wasDone = false;
 String answer=" ";
 final JTextField textField;

 /**
  * METODO Constructor ImportSeparatorField
  *
  */
 public ImportSeparatorField(Frame aFrame, Language lang) {

   super(aFrame, true);
   idiom = lang;
   setTitle(idiom.getWord("SEPA"));

   JPanel block = new JPanel();
   block.setLayout(new FlowLayout());

   JLabel label = new JLabel(idiom.getWord("IFSEP"),JLabel.CENTER);
   JPanel upPanel = new JPanel();
   upPanel.add(label);

   JPanel central = new JPanel();
   JLabel pre = new JLabel(idiom.getWord("SEPA") + ": ",JLabel.LEFT);
   central.add(pre);

   JPanel side = new JPanel();
   textField = new JTextField(5);
   side.add(textField);

   block.add(central,BorderLayout.CENTER);
   block.add(side,BorderLayout.EAST);

   Object[] array = {upPanel,block};

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

   addWindowListener(new WindowAdapter() 
     {
     public void windowClosing(WindowEvent we) 
      {
       optionPane.setValue(new Integer(JOptionPane.CLOSED_OPTION));
      }
     });

   textField.addActionListener(new ActionListener() 
    {
     public void actionPerformed(ActionEvent e) 
      {
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
             wasDone = true;
             typedText = textField.getText();

             if (typedText.length()>0)
                 answer = typedText;
             else
                 answer = " ";             
          } 

         setVisible(false);
       }
     }
   });

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

} //Fin de la Clase

