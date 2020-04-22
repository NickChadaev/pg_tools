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
 *  CLASS DropUser @version 1.0   
 *  History:
 *           
 */
package ru.nick_ch.x1.menu;

import java.awt.event.WindowAdapter;
import java.awt.event.WindowEvent;
import java.beans.PropertyChangeEvent;
import java.beans.PropertyChangeListener;

import javax.swing.JComboBox;
import javax.swing.JDialog;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JOptionPane;
import javax.swing.JTextArea;

import ru.nick_ch.x1.db.PGConnection;
import ru.nick_ch.x1.idiom.Language;

public class DropUser extends JDialog {
 
 private JOptionPane optionPane;
 PGConnection conn;
 JTextArea LogWin; 
 JComboBox cmbUser;
 Language idiom;

 public DropUser (JFrame aFrame, Language lang, PGConnection pg, JTextArea area) {

   super(aFrame, true);
   
   idiom = lang;
   conn = pg;
   LogWin = area;
   setTitle(idiom.getWord("DROP") + " " + idiom.getWord("USER"));
   String[] usuarios = conn.getUsers();
  
   JLabel msgString1 = new JLabel(idiom.getWord("SELUSR"));
   cmbUser = new JComboBox(usuarios);
   Object[] array = {msgString1, cmbUser};

   final String btnString1 = idiom.getWord("DROP");
   final String btnString2 = idiom.getWord("CANCEL");
   Object[] options = {btnString1, btnString2};

   optionPane = new JOptionPane(array, 
                                JOptionPane.QUESTION_MESSAGE,
                                JOptionPane.YES_NO_OPTION,
                                null,
                                options,
                                options[0]);
   setContentPane(optionPane);
   setDefaultCloseOperation(DO_NOTHING_ON_CLOSE);

   addWindowListener(new WindowAdapter() {

     public void windowClosing(WindowEvent we) {
          optionPane.setValue(new Integer(JOptionPane.CLOSED_OPTION));
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

             String user = (String) cmbUser.getSelectedItem();
             String SQL = "DROP USER " + user + ";";
             String result = conn.SQL_Instruction(SQL);
             addTextLogMonitor(idiom.getWord("EXEC") + SQL + "\"");
             addTextLogMonitor(idiom.getWord("RES") + result);

             if (result.equals("OK"))
                 setVisible(false);
             else {
                   JOptionPane.showMessageDialog(DropUser.this,
                   result,
                   idiom.getWord("ERROR!"),JOptionPane.ERROR_MESSAGE);
                   return;
              }
          } 
         else 
            setVisible(false);
       }
     }
   });

   pack();
   setLocationRelativeTo(aFrame);
   setVisible(true);
 }

 /**
  * Metodo addTextLogMonitor
  * Imprime mensajes en el Monitor de Eventos
  */
 public void addTextLogMonitor(String msg) {

   LogWin.append(msg + "\n");	
   int longiT = LogWin.getDocument().getLength();

   if (longiT > 0)
       LogWin.setCaretPosition(longiT - 1);
 }
 
} //Fin de la Clase

