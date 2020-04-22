/**
 * This software is free according GNU GENERAL PUBLIC LICENSE and
 * based on the XPg project, developed by KAZAK Solutions. 
 * Research and Development Group of Free Software, 
 * Santiago de Cali Republic of Colombia 2001.
 * Author:
 *          Gustavo GonzÀlez <xtingray@kazak.com.co>.                   
 * ----------------------------------------------------------------------------
 * Now this software is developing for modern version of PostgreSQL.
 * Author: 
 *          Nick Chadaev <nick_ch58@list.ru>. Moscow, Russia. Single developer.
 *          New stage of developing had been started at 2009-06-16. 
 * ----------------------------------------------------------------------------
 *  CLASS CreateUser @version 1.0   
 *     The dialog for creating of DB user.
 *  History:
 *           
 */
package ru.nick_ch.x1.menu;

import java.awt.BorderLayout;
import java.awt.FlowLayout;
import java.awt.GridLayout;
import java.awt.event.ActionListener;

import javax.swing.BorderFactory;
import javax.swing.BoxLayout;
import javax.swing.JButton;
import javax.swing.JCheckBox;
import javax.swing.JComboBox;
import javax.swing.JDialog;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JOptionPane;
import javax.swing.JPanel;
import javax.swing.JPasswordField;
import javax.swing.JTextArea;
import javax.swing.JTextField;
import javax.swing.border.Border;
import javax.swing.border.TitledBorder;

import ru.nick_ch.x1.db.PGConnection;
import ru.nick_ch.x1.idiom.Language;

public class CreateUser extends JDialog implements ActionListener {

 JComboBox groups;
 final JTextField textFieldUser,textFieldValidez,uidT;
 JPasswordField textFieldPassw,textFieldVePassw;
 JCheckBox createDBButton,createUserButton;
 boolean wellDone = false;
 Language idiom;
 PGConnection conn;
 JTextArea LogWin;

 public CreateUser (JFrame aFrame, Language lang, PGConnection pg, JTextArea area) {

   super(aFrame);
 
   idiom = lang;
   conn = pg;
   LogWin = area;
   setTitle(idiom.getWord("CREATE") + idiom.getWord("USER"));
   JPanel emptyPanel = new JPanel();

   /*** Construción parte izquierda de la ventana ***/

   //Captura del campo user  

   JPanel rowUser = new JPanel();
   JLabel msgUser = new JLabel(idiom.getWord("USER") + ": ");
   textFieldUser = new JTextField(10); 
   rowUser.setLayout(new GridLayout(0,2));
   rowUser.add(msgUser);
   rowUser.add(textFieldUser); 

   // Captura del campo Password
   JPanel rowPassw = new JPanel();
   JLabel msgPassw = new JLabel(idiom.getWord("PASSWD") + ": ");
   textFieldPassw = new JPasswordField(10);
   textFieldPassw.setEchoChar('*');         
   rowPassw.setLayout(new GridLayout(0,2));
   rowPassw.add(msgPassw);
   rowPassw.add(textFieldPassw);

   // Captura del campo Verificar Password
   JPanel rowVePassw = new JPanel();
   JLabel msgVePassw = new JLabel(idiom.getWord("VRF") + " " + idiom.getWord("PASSWD") + ": ");
   textFieldVePassw = new JPasswordField(10);
   textFieldVePassw.setEchoChar('*');         
   rowVePassw.setLayout(new GridLayout(0,2));
   rowVePassw.add(msgVePassw);
   rowVePassw.add(textFieldVePassw);

   // Captura el grupo

   JPanel rowGroup = new JPanel();
   JLabel msgGroup = new JLabel(idiom.getWord("GROUP") + ": ");
   String[] values = conn.getGroups();

   boolean disable = false;

   if (values.length < 1) {

       values = new String[1];
       values[0] = idiom.getWord("NOGRP");
       disable = true;
    }

   groups = new JComboBox(values);

   if (disable)
       groups.setEnabled(false);

   rowGroup.setLayout(new GridLayout(0,2));
   rowGroup.add(msgGroup);
   rowGroup.add(groups);

   // Captura del campo fecha de validez
   JPanel rowValidez = new JPanel();
   JLabel msgValidez = new JLabel(idiom.getWord("VLD") + " (" +idiom.getWord("DATE") + "): ");
   textFieldValidez = new JTextField(10); 
   rowValidez.setLayout(new GridLayout(0,2));
   rowValidez.add(msgValidez);
   rowValidez.add(textFieldValidez);

   JPanel leftPanel = new JPanel();
   leftPanel.setLayout(new BoxLayout(leftPanel,BoxLayout.Y_AXIS));
   leftPanel.add(rowUser);
   leftPanel.add(rowPassw);
   leftPanel.add(rowVePassw);
   leftPanel.add(rowGroup);
   leftPanel.add(rowValidez);

 /*** Construcción parte derecha de la ventana ***/

   //Creacion radio Button

   createDBButton = new JCheckBox(idiom.getWord("CREATE") + " " + idiom.getWord("DB"));
   createDBButton.setMnemonic('p'); 
   createDBButton.setActionCommand("Create DataBase"); 
   createUserButton = new JCheckBox(idiom.getWord("CREATE") + " " + idiom.getWord("USER"));
   createUserButton.setMnemonic('p'); 
   createUserButton.setActionCommand("Create User"); 
  
   JPanel uid = new JPanel();
   uid.setLayout(new GridLayout(0,2));
   JLabel uidLabel = new JLabel(idiom.getWord("UID") + ": ");
   uidT = new JTextField(5);
   uid.add(uidLabel);
   uid.add(uidT);

   JPanel rightPanel = new JPanel();
   rightPanel.setLayout(new BoxLayout(rightPanel,BoxLayout.Y_AXIS));
   rightPanel.add(createDBButton);
   rightPanel.add(createUserButton);
   Border etched = BorderFactory.createEtchedBorder();
   TitledBorder title = BorderFactory.createTitledBorder(etched,idiom.getWord("PERM"));
   title.setTitleJustification(TitledBorder.LEFT);
   rightPanel.setBorder(title);

   JPanel todo = new JPanel();
   todo.setLayout(new BorderLayout());
   todo.add(uid,BorderLayout.NORTH);
   todo.add(rightPanel,BorderLayout.CENTER);

 /** Unión de todos los paneles de la ventana ***/

   JPanel ppalPanel = new JPanel();
   ppalPanel.setLayout(new BorderLayout());
   ppalPanel.add(leftPanel,BorderLayout.WEST);
   ppalPanel.add(emptyPanel,BorderLayout.CENTER);
   ppalPanel.add(todo,BorderLayout.EAST);

   JButton okButton = new JButton(idiom.getWord("CREATE"));
   okButton.setActionCommand("ACEPTAR");
   okButton.addActionListener(this);
   okButton.setMnemonic('A');
   okButton.setAlignmentX(CENTER_ALIGNMENT);

   JButton cancelButton = new JButton(idiom.getWord("CANCEL"));
   cancelButton.setActionCommand("CANCEL");
   cancelButton.addActionListener(this);
   cancelButton.setMnemonic('A');
   cancelButton.setAlignmentX(CENTER_ALIGNMENT);

   JPanel horizontalButton = new JPanel();
   horizontalButton.setLayout(new FlowLayout());
   horizontalButton.add(okButton);
   horizontalButton.add(cancelButton);
  
   JPanel groupPanel = new JPanel();
   groupPanel.setLayout(new BoxLayout(groupPanel,BoxLayout.Y_AXIS));
   groupPanel.add(ppalPanel);
   groupPanel.add(horizontalButton);

   JPanel groupTotal = new JPanel();
   groupTotal.add(groupPanel);

   title = BorderFactory.createTitledBorder(etched);
   groupTotal.setBorder(title);

   getContentPane().add(groupTotal);
   pack();
   setLocationRelativeTo(aFrame);
   setVisible(true);
 }


 public void actionPerformed(java.awt.event.ActionEvent e) {

  if (e.getActionCommand().equals("ACEPTAR")) {

      String userName = textFieldUser.getText();

      if (userName.length()<1) {

          JOptionPane.showMessageDialog(CreateUser.this,
          idiom.getWord("NNUSR"),
          idiom.getWord("ERROR!"),JOptionPane.ERROR_MESSAGE);

          return;
       } 
      else {
             if (userName.indexOf(" ")!= -1) {

                 JOptionPane.showMessageDialog(CreateUser.this,
                 idiom.getWord("INVUSR"),
                 idiom.getWord("ERROR!"),JOptionPane.ERROR_MESSAGE);

                 return;
              }
       }
 
      String next = " WITH";
      String SQL = "CREATE USER " + userName;

      String uidV = uidT.getText();

      if (!isNum(uidV)) {

          JOptionPane.showMessageDialog(CreateUser.this,
          idiom.getWord("INVUID"),
          idiom.getWord("ERROR!"),JOptionPane.ERROR_MESSAGE);

          return;
       }

      if (uidV.length()>0)
          next += " SYSID " + uidV;

      char[] typedText = textFieldPassw.getPassword();
      String pass1 = new String(typedText);
      char[] typedText2 = textFieldVePassw.getPassword();
      String pass2 = new String(typedText2);

      if (!pass1.equals(pass2)) {

          JOptionPane.showMessageDialog(CreateUser.this,
          idiom.getWord("INVPASS"),
          idiom.getWord("ERROR!"),JOptionPane.ERROR_MESSAGE);

          return; 
       }

      next += " PASSWORD '" + pass1 + "'"; 

      if (createDBButton.isSelected()) 
          next += " CREATEDB";
      else
          next += " NOCREATEDB";

      if (createUserButton.isSelected()) 
  	  next += " CREATEUSER";
      else
  	  next += " NOCREATEUSER";

     String groupS = (String) groups.getSelectedItem();

     if (!groupS.equals(idiom.getWord("NOGRP")))
         next += " IN GROUP " + groupS;

     String dateV = textFieldValidez.getText();

     if (dateV.length()>0)
         next += " VALID UNTIL '" + dateV + "'";

     SQL += next + ";";

     String result = conn.SQL_Instruction(SQL);
     addTextLogMonitor(idiom.getWord("EXEC") + SQL + "\"");
     addTextLogMonitor(idiom.getWord("RES") + result);

     if (result.equals("OK")) {
         wellDone = true; 
         setVisible(false);    
      }
     else {
            JOptionPane.showMessageDialog(CreateUser.this,
            result,
            idiom.getWord("ERROR!"),JOptionPane.ERROR_MESSAGE);
      }

     return;
    }

   if (e.getActionCommand().equals("CANCEL")) {
       setVisible(false);					    
    }

 }

 public boolean isNum(String value) {

    for (int i=0;i<value.length();i++) {

         char a = value.charAt(i);

         if (!Character.isDigit(a)) 
             return false;
     }

    return true;
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
