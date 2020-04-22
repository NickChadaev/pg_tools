/**
 * This software is free according GNU GENERAL PUBLIC LICENSE and
 * based on the XPg project, developed by KAZAK Solutions. 
 * Research and Development Group of Free Software, 
 * Santiago de Cali Republic of Colombia 2001.
 * Author:
 *          Gustavo Gonz�lez <xtingray@kazak.com.co>.                   
 * ----------------------------------------------------------------------------
 * Now this software is developing for modern version of PostgreSQL.
 * Author: 
 *          Nick Chadaev <nick_ch58@list.ru>. Moscow, Russia. Single developer.
 *          New stage of developing had been started at 2009-06-16. 
 * ----------------------------------------------------------------------------
 *  CLASS TablesGrant @version 1.0   
 *    This class is responsible for managing the dialogue by
 *    modify which permits one or more tables
 *    in a database.
 *  History:
 *           
 */

package ru.nick_ch.x1.menu;

import java.awt.BorderLayout;
import java.awt.FlowLayout;
import java.awt.GridLayout;
import java.awt.event.ActionListener;
import java.util.Vector;

import javax.swing.BorderFactory;
import javax.swing.BoxLayout;
import javax.swing.ButtonGroup;
import javax.swing.JButton;
import javax.swing.JCheckBox;
import javax.swing.JComboBox;
import javax.swing.JDialog;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JOptionPane;
import javax.swing.JPanel;
import javax.swing.JRadioButton;
import javax.swing.JTextArea;
import javax.swing.border.Border;
import javax.swing.border.TitledBorder;

import ru.nick_ch.x1.db.PGConnection;
import ru.nick_ch.x1.idiom.Language;

public class TablesGrant extends JDialog implements ActionListener {

  PGConnection conn;
  JTextArea LogWin;
  Language idiom;
  JRadioButton first,second,third,all;
  JComboBox cmbDB;
  JComboBox cmbDB2;
  JComboBox cmbGrp;
  JCheckBox selectButton,updateButton,insertButton,ruleButton,deleteButton,allButton;
  String[] tables;

 public TablesGrant (JFrame aFrame,Language lang,PGConnection pg, JTextArea area,String[] tb)
  { 
   super(aFrame,true);
   idiom = lang;
   setTitle(idiom.getWord("PERDB") + pg.getDBname());
   conn = pg;
   LogWin = area;
   JPanel empty = new JPanel();
   JPanel empty1 = new JPanel();
   tables = tb;

   String[] users = conn.getUsers();
   String[] groups = conn.getGroups();

  /*** Construci�n parte izquierda de la ventana ***/

  //Captura del campo user  

   JLabel msgUser = new JLabel(idiom.getWord("USER") + ": ");
   cmbDB = new JComboBox(users);

   JLabel msgGroup = new JLabel(idiom.getWord("GROUP") + ": ");
   cmbGrp = new JComboBox(groups);
 
  // Captura del campo tabla
   JLabel msgTable = new JLabel(idiom.getWord("PBLIC"));

   JLabel msgTable2 = new JLabel(idiom.getWord("CHST"));
   cmbDB2 = new JComboBox(tables); 

   //JPanel empty = new JPanel();

   JPanel upPanel = new JPanel();
   upPanel.setLayout(new FlowLayout(FlowLayout.CENTER));
   upPanel.add(msgTable2);
   upPanel.add(cmbDB2);

   first = new JRadioButton();
   first.setSelected(true);
   second = new JRadioButton();

   if (groups.length < 1) {
       cmbGrp.setEnabled(false);
       second.setEnabled(false);
    }

   third = new JRadioButton();
   ButtonGroup group = new ButtonGroup();
   group.add(first);
   group.add(second);
   group.add(third);

   JPanel tmp0 = new JPanel();
   tmp0.setLayout(new GridLayout(3,0));
   tmp0.add(first);
   tmp0.add(second);
   tmp0.add(third);

   JPanel tmp = new JPanel();
   tmp.setLayout(new GridLayout(3,0));
   tmp.add(msgUser);
   tmp.add(msgGroup);
   tmp.add(msgTable);

   JPanel tmp2 = new JPanel();
   tmp2.setLayout(new GridLayout(3,0));
   tmp2.add(cmbDB);
   tmp2.add(cmbGrp);
   tmp2.add(empty);

   JPanel up = new JPanel();
   up.setLayout(new BorderLayout());
   up.add(tmp0,BorderLayout.WEST);
   up.add(tmp,BorderLayout.CENTER); 
   up.add(tmp2,BorderLayout.EAST);

   Border etched = BorderFactory.createEtchedBorder();
   TitledBorder title = BorderFactory.createTitledBorder(etched,idiom.getWord("APPL"));
   up.setBorder(title);

 /*** Construcci�n parte derecha de la ventana ***/

  //Creacion Check Box
  selectButton = new JCheckBox("Select");
  selectButton.setMnemonic('S'); 
  selectButton.setActionCommand("SELECT"); 

  insertButton = new JCheckBox("Insert");
  insertButton.setMnemonic('I');
  insertButton.setActionCommand("INSERT");

  updateButton = new JCheckBox("Update");
  updateButton.setMnemonic('U'); 
  updateButton.setActionCommand("UPDATE");

  deleteButton = new JCheckBox("Delete");
  deleteButton.setMnemonic('D');
  deleteButton.setActionCommand("DELETE");

  ruleButton = new JCheckBox("Rule");
  ruleButton.setMnemonic('R'); 
  ruleButton.setActionCommand("RULE"); 

  allButton = new JCheckBox("All");
  allButton.setMnemonic('A');
  allButton.setActionCommand("ALL");

  JPanel rightPanel = new JPanel();
  rightPanel.setLayout(new GridLayout(3,2));
  rightPanel.add(selectButton);
  rightPanel.add(insertButton);
  rightPanel.add(updateButton);
  rightPanel.add(deleteButton);
  rightPanel.add(ruleButton);
  rightPanel.add(allButton); 

  title = BorderFactory.createTitledBorder(etched,idiom.getWord("PERM"));
  title.setTitleJustification(TitledBorder.LEFT);
  rightPanel.setBorder(title);

  all = new JRadioButton(idiom.getWord("APAT"));
  all.setHorizontalAlignment(JRadioButton.CENTER);
  JPanel tod = new JPanel(new BorderLayout());
  tod.add(rightPanel,BorderLayout.CENTER);
  tod.add(all,BorderLayout.SOUTH);

 /** Uni�n de todos los paneles de la ventana ***/

  JPanel ppalPanel = new JPanel();
  ppalPanel.setLayout(new FlowLayout(FlowLayout.CENTER));
  ppalPanel.add(up);//,BorderLayout.CENTER);
  ppalPanel.add(empty);//,BorderLayout.CENTER);
  ppalPanel.add(tod);//,BorderLayout.EAST);

  JButton okButton = new JButton(idiom.getWord("SET"));
  okButton.setActionCommand("OK");
  okButton.addActionListener(this);
  okButton.setAlignmentX(CENTER_ALIGNMENT);

  JButton cancelButton = new JButton(idiom.getWord("CLOSE"));
  cancelButton.setActionCommand("CANCEL");
  cancelButton.addActionListener(this);
  cancelButton.setAlignmentX(CENTER_ALIGNMENT);

  JPanel horizontalButton = new JPanel();
  horizontalButton.setLayout(new FlowLayout());
  horizontalButton.add(okButton);
  horizontalButton.add(cancelButton);

  JPanel groupPanel = new JPanel();
  groupPanel.setLayout(new BoxLayout(groupPanel,BoxLayout.Y_AXIS));
  groupPanel.add(upPanel);
  groupPanel.add(ppalPanel);
  groupPanel.add(horizontalButton);

  JPanel groupTotal = new JPanel();
  groupTotal.add(groupPanel);

  getContentPane().add(groupTotal);

  pack();
  setLocationRelativeTo(aFrame);
  setVisible(true);

 }

 public void actionPerformed(java.awt.event.ActionEvent e) 
  {
 
    if (e.getActionCommand().equals("OK")) {

        String target = "";
        Vector permiss = new Vector();
        Vector pain = new Vector();
        String table = (String) cmbDB2.getSelectedItem();
        boolean world = false;

        if (all.isSelected())
            world = true;

        int selected = 0;

        if (selectButton.isSelected())
            permiss.addElement("SELECT");
        else {
            pain.addElement("SELECT");
            selected++;
         }

      if (updateButton.isSelected())
          permiss.addElement("UPDATE");
      else {
             pain.addElement("UPDATE");
             selected++;
       }

      if (insertButton.isSelected())
          permiss.addElement("INSERT");
      else {
             pain.addElement("INSERT");        
             selected++;
       }

      if (deleteButton.isSelected())
          permiss.addElement("DELETE");
      else {
             pain.addElement("DELETE");
             selected++;
       }
      
      if (ruleButton.isSelected())
          permiss.addElement("RULE");
      else {
            pain.addElement("RULE");
            selected++;
       }

      if (allButton.isSelected()) {
          permiss.removeAllElements();
          permiss.addElement("ALL");
       } 

      if (selected == 5) {
          pain.removeAllElements();
          pain.addElement("ALL");
       }

      if (first.isSelected()) {
          String user = (String) cmbDB.getSelectedItem();
          target = user;
       }

      if (second.isSelected()) {
          String group = (String) cmbGrp.getSelectedItem();
          if (group.equals(idiom.getWord("NOGRP"))) {
              JOptionPane.showMessageDialog(TablesGrant.this,
              idiom.getWord("INVNG"),
              idiom.getWord("ERROR!"),JOptionPane.ERROR_MESSAGE);
              return;
           }          
          else
               target = "GROUP " + group;
       }

      if (third.isSelected()) 
          target = "PUBLIC";
                           
      if (pain.size()>0) {
          String Revoke = "REVOKE";
          String change = " ";
          for (int i=0;i<pain.size();i++) {
               change += (String) pain.elementAt(i);
               if (i<pain.size()-1) 
                   change += ",";
           } 

          if (world) {
              for (int i=0;i<tables.length;i++) {
                   String sentence = Revoke + change + " ON \"" + tables[i] + "\" FROM \"" + target + "\";";
                   String result = conn.SQL_Instruction(sentence);
                   addTextLogMonitor(idiom.getWord("EXEC") + sentence + "\"");
                   addTextLogMonitor(idiom.getWord("RES") + result);
                   if (!result.equals("OK")) {
                       JOptionPane.showMessageDialog(TablesGrant.this,
                       result,
                       idiom.getWord("ERROR!"),JOptionPane.ERROR_MESSAGE);
                       return;                 
                    }
               }
          }
        else { 
              Revoke += change + " ON \"" + table + "\" FROM \"" + target + "\";";
              String result = conn.SQL_Instruction(Revoke);
              addTextLogMonitor(idiom.getWord("EXEC") + Revoke + "\"");
              addTextLogMonitor(idiom.getWord("RES") + result);

              if (!result.equals("OK")) {
                  JOptionPane.showMessageDialog(TablesGrant.this,
                  result,
                  idiom.getWord("ERROR!"),JOptionPane.ERROR_MESSAGE);
                  return; 
               }
          }
     }

    if (permiss.size()>0) {
        String grantSQL = "GRANT";
        String change = " ";
        for (int i=0;i<permiss.size();i++) {
             change += (String) permiss.elementAt(i);
             if (i<permiss.size()-1) 
                 change += ",";
         } 

        if (world) {
            for (int i=0;i<tables.length;i++) {
                 String sentence = grantSQL + change + " ON \"" + tables[i] + "\" TO \"" + target + "\";";
                 String result = conn.SQL_Instruction(sentence);
                 addTextLogMonitor(idiom.getWord("EXEC") + sentence + "\"");
                 addTextLogMonitor(idiom.getWord("RES") + result);

                 if (!result.equals("OK")) {
                     JOptionPane.showMessageDialog(TablesGrant.this,
                     result,
                     idiom.getWord("ERROR!"),JOptionPane.ERROR_MESSAGE);
                     return;                 
                  }
            } 
          }
         else {
                grantSQL += change + " ON \"" + table + "\" TO \"" + target + "\";";
	        String result = conn.SQL_Instruction(grantSQL);
	        addTextLogMonitor(idiom.getWord("EXEC") + grantSQL + "\"");
	        addTextLogMonitor(idiom.getWord("RES") + result);

	        if (!result.equals("OK")) {
	            JOptionPane.showMessageDialog(TablesGrant.this,
	            result,
	            idiom.getWord("ERROR!"),JOptionPane.ERROR_MESSAGE);
	            return;                 
                 }
               }
           }
    }

   if (e.getActionCommand().equals("CANCEL")) {
       setVisible(false);				    
    }
 }


 public void addTextLogMonitor(String msg) {

   LogWin.append(msg + "\n");	
   int longiT = LogWin.getDocument().getLength();

   if (longiT > 0)
       LogWin.setCaretPosition(longiT - 1);
  }

} //Fin de la Clase
