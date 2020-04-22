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
 * CLASS ExportToFile @version 0.1:        
 * 		Class responsible for managing the dialogue through which
 * 		define the operation (import and export) to make between a table and 
 * 		its archive. 
 * History:                          
 */

package ru.nick_ch.x1.misc.input;

import java.awt.FlowLayout;
import java.awt.event.ActionListener;

import javax.swing.BorderFactory;
import javax.swing.BoxLayout;
import javax.swing.ButtonGroup;
import javax.swing.JButton;
import javax.swing.JDialog;
import javax.swing.JFrame;
import javax.swing.JPanel;
import javax.swing.JRadioButton;
import javax.swing.border.Border;
import javax.swing.border.TitledBorder;

import ru.nick_ch.x1.idiom.Language;

public class ExportToFile extends JDialog implements ActionListener {

 JRadioButton tableToFileButton;
 JRadioButton fileToTableButton;
 Language idiom;
 boolean wellDone = false;
 int option = -1;
 int regs;

 public ExportToFile (JFrame aFrame,Language lang,int numReg) {

  super(aFrame, true);
  idiom = lang;
  regs = numReg;

  setTitle(idiom.getWord("COPY") + " " + idiom.getWord("DATA"));

  JPanel global = new JPanel();
  global.setLayout(new BoxLayout(global,BoxLayout.Y_AXIS));


  /*** Construcción componentes de la ventana ***/
  //Creacion radio Button

  tableToFileButton = new JRadioButton(idiom.getWord("FTF"));
  tableToFileButton.setMnemonic('a'); 

  fileToTableButton = new JRadioButton(idiom.getWord("FFT"));
  fileToTableButton.setMnemonic('t'); 

  if (regs > 0) {
      tableToFileButton.setEnabled(true);
      tableToFileButton.setSelected(true);
   }
  else {
        tableToFileButton.setEnabled(false);
        fileToTableButton.setSelected(true);
   }

  ButtonGroup group = new ButtonGroup();
  group.add(tableToFileButton);
  group.add(fileToTableButton);
  
  JPanel rightTop = new JPanel();
  rightTop.setLayout(new BoxLayout(rightTop,BoxLayout.Y_AXIS));
  rightTop.add(tableToFileButton);
  rightTop.add(fileToTableButton);

  Border etched = BorderFactory.createEtchedBorder();
  TitledBorder title = BorderFactory.createTitledBorder(etched,idiom.getWord("COPY") + " " + idiom.getWord("DATA"));
  title.setTitleJustification(TitledBorder.LEFT);
  rightTop.setBorder(title);
  
  JPanel rightPanel = new JPanel();
  rightPanel.setLayout(new BoxLayout(rightPanel,BoxLayout.Y_AXIS));
  rightPanel.add(rightTop);
  
  /*** Unión de todos los componentes de la ventana ***/
  
  JPanel downPanel = new JPanel();
  downPanel.setLayout(new FlowLayout(FlowLayout.CENTER));
  downPanel.add(rightPanel);

  title = BorderFactory.createTitledBorder(etched);
  downPanel.setBorder(title);

  JButton ok = new JButton(idiom.getWord("OK"));
  ok.setActionCommand("OK");
  ok.addActionListener(this);

  JButton cancel = new JButton(idiom.getWord("CANCEL"));
  cancel.setActionCommand("CANCEL");
  cancel.addActionListener(this);

  JPanel botons = new JPanel();
  botons.setLayout(new FlowLayout(FlowLayout.CENTER));
  botons.add(ok);
  botons.add(cancel);

  global.add(downPanel); 
  global.add(botons);

  getContentPane().add(global);
  pack();
  setLocationRelativeTo(aFrame);
  setVisible(true);

 }

 public void actionPerformed(java.awt.event.ActionEvent e) {

  if (e.getActionCommand().equals("CANCEL")) {
      setVisible(false);
      return;
   }		

  if (e.getActionCommand().equals("OK")) {

      if (tableToFileButton.isSelected())
          option = 1;

     if (fileToTableButton.isSelected())
         option = 2;

     wellDone = true;
     setVisible(false);
     return;
   }

 }

public boolean isWellDone() {
  return wellDone;
 } 

public int getOption() {
  return option;
 }

} //Fin de la Clase
