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
 *  CLASS ExportToReport v 0.1  @version 1.0
 *     Class responsible for managing the dialogue through which
 *     Define the number of registers to be used in a report.
 *  
 *  History:
 *           
 */
 
package ru.nick_ch.x1.report;

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

public class ExportToReport extends JDialog implements ActionListener {

 JRadioButton currentScreen;
 JRadioButton onMemory;
 JRadioButton onTotal;

 Language idiom;
 boolean wellDone = false;
 int option = -1;
 int regs;

 public ExportToReport (JFrame aFrame,Language lang) {

  super(aFrame, true);
  idiom = lang;

  setTitle(idiom.getWord("RDATA"));

  JPanel global = new JPanel();
  global.setLayout(new BoxLayout(global,BoxLayout.Y_AXIS));

  /*** Construcción componentes de la ventana ***/
  //Creacion radio Button

  currentScreen = new JRadioButton(idiom.getWord("ROD"));
  currentScreen.setMnemonic('R'); 
  currentScreen.setSelected(true);

  onMemory = new JRadioButton(idiom.getWord("ROM"));
  onMemory.setMnemonic('M'); 

  onTotal = new JRadioButton(idiom.getWord("ET"));
  onTotal.setMnemonic('a');

  ButtonGroup group = new ButtonGroup();
  group.add(currentScreen);
  group.add(onMemory);
  group.add(onTotal);
  
  JPanel rightTop = new JPanel();
  rightTop.setLayout(new BoxLayout(rightTop,BoxLayout.Y_AXIS));
  rightTop.add(currentScreen);
  rightTop.add(onMemory);
  rightTop.add(onTotal);

  Border etched = BorderFactory.createEtchedBorder();
  TitledBorder title = BorderFactory.createTitledBorder(etched,idiom.getWord("CRDATA"));
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

     if (currentScreen.isSelected()) 
         option = 1;

     if(onMemory.isSelected())
        option = 2;

     if(onTotal.isSelected())
        option = 3;

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
