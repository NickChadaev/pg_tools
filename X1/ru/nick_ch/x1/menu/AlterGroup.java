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
 *  CLASS AlterGroup @version 1.0   
 *    This class is responsible for managing the dialog that allows
 *    alter the group permissions.
 *  History:
 *           
 */

package ru.nick_ch.x1.menu;

import java.awt.BorderLayout;
import java.awt.Dimension;
import java.awt.FlowLayout;
import java.awt.Toolkit;
import java.awt.event.ActionListener;
import java.net.URL;
import java.util.Vector;

import javax.swing.AbstractButton;
import javax.swing.BorderFactory;
import javax.swing.Box;
import javax.swing.BoxLayout;
import javax.swing.ImageIcon;
import javax.swing.JButton;
import javax.swing.JComboBox;
import javax.swing.JDialog;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JList;
import javax.swing.JOptionPane;
import javax.swing.JPanel;
import javax.swing.JScrollPane;
import javax.swing.JTextArea;
import javax.swing.ListSelectionModel;
import javax.swing.border.Border;
import javax.swing.border.TitledBorder;

import ru.nick_ch.x1.db.PGConnection;
import ru.nick_ch.x1.idiom.Language;

public class AlterGroup extends JDialog implements ActionListener {

 JTextArea LogWin;
 PGConnection conn;
 JList usrList,groupList;
 Vector user;
 JComboBox nameText;
 Language idiom;
 Vector newU = new Vector();
 Vector deathU = new Vector();

public AlterGroup(JFrame aFrame, Language lang,PGConnection pg, JTextArea area) {

  super(aFrame);
  idiom = lang;
  conn = pg;
  LogWin = area;

  setTitle(idiom.getWord("MODGRP"));
  String[] grupo = conn.getUsers();
  JPanel rowName = new JPanel();
  JLabel nameLabel = new JLabel(idiom.getWord("NAMEGRP"));

  String[] values = conn.getGroups();

  nameText = new JComboBox(values);
  nameText.setActionCommand("COMBO");
  nameText.addActionListener(this);

  user = conn.getGroupUser(values[0]);

  rowName.setLayout(new FlowLayout(FlowLayout.CENTER));
  rowName.add(nameLabel);
  rowName.add(nameText);

  usrList = new JList (user);
  usrList.setSelectionMode(ListSelectionModel.SINGLE_SELECTION);
  JScrollPane componente = new JScrollPane(usrList);
  componente.setPreferredSize(new Dimension(100,120));   
  
  groupList = new JList (grupo);
  groupList.setSelectionMode(ListSelectionModel.SINGLE_SELECTION);
  JScrollPane componente2 = new JScrollPane(groupList);
  componente2.setPreferredSize(new Dimension(100,120));   

  URL imgURL = getClass().getResource("/icons/16_Right.png");
  JButton addUserButton = new JButton(new ImageIcon(Toolkit.getDefaultToolkit().getImage(imgURL)));
  addUserButton.setVerticalTextPosition(AbstractButton.CENTER);
  addUserButton.setActionCommand("RIGHT");
  addUserButton.addActionListener(this);

  imgURL = getClass().getResource("/icons/16_Left.png");
  JButton dropUserButton = new JButton(new ImageIcon(Toolkit.getDefaultToolkit().getImage(imgURL)));
  dropUserButton.setVerticalTextPosition(AbstractButton.CENTER);
  dropUserButton.setActionCommand("LEFT");
  dropUserButton.addActionListener(this);

  JPanel verticalButton = new JPanel();
  verticalButton.setLayout(new BoxLayout(verticalButton,BoxLayout.Y_AXIS));
  verticalButton.add(Box.createVerticalGlue());
  verticalButton.add(addUserButton);
  verticalButton.add(dropUserButton);
  verticalButton.add(Box.createVerticalGlue());
  verticalButton.setAlignmentY(CENTER_ALIGNMENT);

  JButton okButton = new JButton(idiom.getWord("MODGR"));
  okButton.setActionCommand("OK");
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

  JPanel groupAux = new JPanel();
  groupAux.setLayout(new BorderLayout());      
  groupAux.add(componente,BorderLayout.EAST);
  groupAux.add(verticalButton,BorderLayout.CENTER);
  groupAux.add(componente2,BorderLayout.WEST);

  Border etched = BorderFactory.createEtchedBorder();
  TitledBorder title = BorderFactory.createTitledBorder(etched);
  groupAux.setBorder(title);

  JPanel groupPanel = new JPanel();
  groupPanel.setLayout(new BoxLayout(groupPanel,BoxLayout.Y_AXIS));
  groupPanel.add(rowName);
  groupPanel.add(Box.createRigidArea(new Dimension(0,10)));
  groupPanel.add(groupAux);
  groupPanel.add(horizontalButton);

  JPanel groupTotal = new JPanel();
  groupTotal.add(groupPanel);
  groupTotal.setBorder(title);

  getContentPane().add(groupTotal);
  pack();
  setLocationRelativeTo(aFrame);
  setVisible(true);
 }


 public void actionPerformed(java.awt.event.ActionEvent e) {

   if (e.getActionCommand().equals("COMBO")) {

       String groupN = (String) nameText.getSelectedItem();
       user = conn.getGroupUser(groupN);
       usrList.setListData(user);
       newU = new Vector();
       deathU = new Vector();

       return;
    }

   if (e.getActionCommand().equals("RIGHT")) {

       String userName = (String) groupList.getSelectedValue();

       if (!user.contains(userName)) {
           user.addElement(userName);
           usrList.setListData(user);
           newU.addElement(userName);
        }

       return;
    }

   if (e.getActionCommand().equals("LEFT")) {

       String userName = (String) usrList.getSelectedValue();

       if (user.removeElement(userName)) {

           usrList.setListData(user);
           deathU.addElement(userName);
        }

       return;    
    }

   if (e.getActionCommand().equals("OK")) {

       String nameG = (String) nameText.getSelectedItem();

       String SQL = "ALTER GROUP " + nameG;
       String next = "";

       if (newU.size()>0) {

           String addU = "";

           for (int m=0;m<newU.size();m++) {

                addU += (String) newU.elementAt(m);

                if (m!=newU.size()-1)
                    addU += ","; 
            }

           String result = conn.SQL_Instruction(SQL + " ADD USER " + addU + ";");

           if (!result.equals("OK")) {

               JOptionPane.showMessageDialog(AlterGroup.this,
               result,
               idiom.getWord("ERROR!"),JOptionPane.ERROR_MESSAGE);

               return; 
            }
        }

       if (deathU.size()>0) {

           String kill = "";

           for (int m=0;m<deathU.size();m++) {

                kill += (String) deathU.elementAt(m);

                if (m!=deathU.size()-1)
                    kill += ","; 
            }

           SQL += " DROP USER " + kill + ";";

           String result = conn.SQL_Instruction(SQL);
           addTextLogMonitor(idiom.getWord("EXEC") + SQL + "\"");
           addTextLogMonitor(idiom.getWord("RES") + result);

           if (!result.equals("OK")) {

               JOptionPane.showMessageDialog(AlterGroup.this,
               result,
               idiom.getWord("ERROR!"),JOptionPane.ERROR_MESSAGE);

               return; 
            }
        } 

       setVisible(false);

       return;		    
  }

 if (e.getActionCommand().equals("CANCEL")) {

     setVisible(false);					    
  }

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
