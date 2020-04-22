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
 *  CLASS ReportHeader @version 1.0 
 *     This class is responsible for managing the dialogue by
 *     Which defines the characteristics of the  report.  
 *   History:
 *           
 */
 
package ru.nick_ch.x1.report;

import java.awt.BorderLayout;
import java.awt.Color;
import java.awt.Dimension;
import java.awt.FlowLayout;
import java.awt.GridLayout;
import java.awt.event.ActionListener;
import java.io.File;
import java.util.Calendar;

import javax.swing.BorderFactory;
import javax.swing.JButton;
import javax.swing.JColorChooser;
import javax.swing.JComboBox;
import javax.swing.JDialog;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JPanel;
import javax.swing.JScrollPane;
import javax.swing.JTextArea;
import javax.swing.JTextField;
import javax.swing.border.Border;
import javax.swing.border.TitledBorder;

import ru.nick_ch.x1.idiom.Language;

public class ReportHeader extends JDialog implements ActionListener {

 JTextArea headerText;
 JComboBox fontStyleCombo;
 JComboBox fontSizeCombo; 
 JComboBox types;

 JTextField theTitle;

 JButton browseButton;
 JButton fontColorButton;
 boolean isWell = false;
 JPanel pColor;
 File fileLogo;

 String strTitle = "";
 String headerD;
 String headerStr = "";

 String fontStyleValue = "";
 String fontColorValue = "";
 String fontSizeValue = "";

 String RGB[] = new String[256];
 Language idiom;

 public ReportHeader(JDialog diag,JFrame parent, Language lang) {

   super(diag,true);
   idiom = lang;
   setTitle(idiom.getWord("REPHSETT"));
   getContentPane().setLayout(new BorderLayout()); 
   headerText = new JTextArea(5,5);

   String[] hex = {"0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "A", "B", "C", "D", "E", "F"};
   int k=0;                        

   for (int i = 0; i < 16; i++) {
        for (int j = 0; j < 16; j++) {
             RGB[k] = hex[i] + hex[j];
             k++;
         }
   }

   JScrollPane holdHeader = new JScrollPane(headerText);
   JPanel header = new JPanel();
   header.setLayout(new BorderLayout());

   Border etched1 = BorderFactory.createEtchedBorder();
   TitledBorder title1 = BorderFactory.createTitledBorder(etched1,idiom.getWord("HEADER"));

   JPanel nH = new JPanel();
   nH.setLayout(new GridLayout(1,0));

   JPanel cH = new JPanel();
   cH.setLayout(new BorderLayout());
   title1 = BorderFactory.createTitledBorder(etched1,idiom.getWord("HEADERT"));
   cH.setBorder(title1);

   JPanel bloke = new JPanel();
   bloke.setLayout(new BorderLayout());
   theTitle = new JTextField();
   title1 = BorderFactory.createTitledBorder(etched1,idiom.getWord("TITTEXT"));
   bloke.setBorder(title1);
   bloke.add(theTitle,BorderLayout.CENTER);
 
   JPanel fontPanel = new JPanel();
   fontPanel.setLayout(new FlowLayout(FlowLayout.CENTER));
 
   String[] values = {"Arial","Arial Black","Arial Narrow","Book Antiqua","Bookman Old Style","Calixto MT","Century Gothic","Comic Sans MS","Copperplate Gothic Bold","Copperplate Gothic Light","Courier New","Garamond","Helvetica","Impact","Lucida Console","Lucida Handwriting","Lucida Sans","Lucida Sans Unicode","Map Symbols","Marlett","Matisse ITC","Monotype Sorts","MS Outlook","MT Extra","News Gothic MT","OCR A Extended","Symbol","Tahoma","Tempus Sans ITC","Times New Roman","Verdana","Webdings","Westminster","Wingdings"};

   fontStyleCombo = new JComboBox(values);

   String[] values1 = {"8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24"};
   fontSizeCombo = new JComboBox(values1);
   fontSizeCombo.setSelectedIndex(4);
   fontColorButton = new JButton(idiom.getWord("FCOLOR"));
   fontColorButton.setActionCommand("COLOR");
   fontColorButton.addActionListener(this);

   pColor = new JPanel();
   pColor.setPreferredSize(new Dimension(15,15));
   title1 = BorderFactory.createTitledBorder(etched1);
   pColor.setBorder(title1);
   title1 = BorderFactory.createTitledBorder(etched1,idiom.getWord("HEADER")+idiom.getWord("FSETT"));

   fontPanel.setBorder(title1);
   pColor.setBackground(Color.black);
 
   fontPanel.add(new JLabel(idiom.getWord("STYLE")+":"));
   fontPanel.add(fontStyleCombo);
   fontPanel.add(new JPanel());
   fontPanel.add(new JLabel(" "+idiom.getWord("LONGTYPE")+":"));
   fontPanel.add(fontSizeCombo);
   fontPanel.add(new JLabel("pt"));
   fontPanel.add(new JPanel());
   fontPanel.add(fontColorButton); 
   fontPanel.add(pColor);

   JPanel pDate = new JPanel();
   pDate.setLayout(new GridLayout(0,1));
   title1 = BorderFactory.createTitledBorder(etched1,idiom.getWord("DATE"));
   pDate.setBorder(title1);

   String[] dates = {idiom.getWord("NODATE"),idiom.getWord("DATE0"),idiom.getWord("DATE1"),idiom.getWord("DATE2"),idiom.getWord("DATE3")};
   types = new JComboBox(dates);

   JPanel level = new JPanel();
   level.setLayout(new FlowLayout(FlowLayout.CENTER));
   level.add(new JLabel(idiom.getWord("FORMAT")+":"));
   level.add(types);
   level.setBorder(title1);
 
   browseButton = new JButton(idiom.getWord("BROWSE"));
   browseButton.setActionCommand("BROWSE");
   browseButton.addActionListener(this);

   JPanel sH = new JPanel();
   sH.setLayout(new GridLayout(0,1));
   sH.add(level); 

   nH.add(fontPanel);
   cH.add(holdHeader,BorderLayout.CENTER);

   JPanel pri = new JPanel();
   pri.setLayout(new BorderLayout());
   pri.add(nH,BorderLayout.NORTH);
   pri.add(cH,BorderLayout.CENTER);

   header.add(bloke,BorderLayout.NORTH);
   header.add(sH,BorderLayout.CENTER);
   header.add(pri,BorderLayout.SOUTH); 

   JButton ok = new JButton(idiom.getWord("OK"));
   ok.setActionCommand("OK");
   ok.addActionListener(this);

   JButton cancel = new JButton(idiom.getWord("CANCEL"));
   cancel.setActionCommand("CANCEL");
   cancel.addActionListener(this); 

   JPanel botonD = new JPanel();
   botonD.setLayout(new FlowLayout(FlowLayout.CENTER));
   botonD.add(ok);
   botonD.add(cancel);

   getContentPane().add(header,BorderLayout.CENTER);
   getContentPane().add(botonD,BorderLayout.SOUTH); 
   pack();
   setLocationRelativeTo(parent);
   setVisible(true); 

 }

 public void actionPerformed(java.awt.event.ActionEvent e) {

 if (e.getActionCommand().equals("CANCEL")) {
      setVisible(false);
  }

 if (e.getActionCommand().equals("COLOR")) {

     Color newColor = JColorChooser.showDialog(ReportHeader.this,
                                               idiom.getWord("CTC"),
                                               Color.white);
     if (newColor != null) {
         pColor.setBackground(newColor);
         fontColorValue = setColor(newColor.getRed(),newColor.getGreen(),newColor.getBlue());
       }
  }

 if (e.getActionCommand().equals("OK")) {

     String headerTextString = "";
     String mainTitle = "";
     String tStrDate = "";
     String logo = "";
     String strDate = (String) types.getSelectedItem();

     int typeDate = types.getSelectedIndex();
     headerD = headerText.getText();
     strTitle = theTitle.getText();

     if (headerD.length()>0) {
         fontStyleValue = (String) fontStyleCombo.getSelectedItem();
         fontSizeValue = (String) fontSizeCombo.getSelectedItem();
         headerTextString = "<p class=\"header\">" + headerD + "</p>\n";
     }

    if (strTitle.length()>0) 
         mainTitle = "<b><u>" + strTitle + "</u></b>\n";

    if (!strDate.equals(idiom.getWord("NODATE"))) {

        switch(typeDate) {
               case 1 : tStrDate = getFormatZero(getTime());
                        break;
               case 2 : tStrDate = getFormatOne(getTime()); 
                        break;
               case 3 : tStrDate = getFormatTwo(getTime()); 
                        break;
               case 4 : tStrDate = getFormatThree(getTime());
        }
     }

    headerStr += "<center>\n" + mainTitle + "&nbsp;&nbsp;&nbsp;" + tStrDate + "\n<br clear=all>\n</center>\n" + headerTextString;
    headerStr += "\n<center><hr width=100% size=1></center>\n";

    isWell = true;
    setVisible(false);
   }
 }

 public boolean isWellDone() {

   return isWell;
  }

 public String getHeader() {

   return headerStr;
  }

 public String getTheTitle() {

   return strTitle;
  }

 public String getFontStyle() {

   return fontStyleValue;
  }

 public String getFontSize() {

   return fontSizeValue;
  }

 public String getFontColor() {

   return fontColorValue;
  }

 public String setColor(int red,int green,int blue) {

   return "#" + RGB[red] + RGB[green] + RGB[blue];
  }

 /**
  * METODO getTime
  * Retorna la hora
  */
 public String[] getTime() {

   Calendar today = Calendar.getInstance();
   String[] val = new String[5];
   int dayInt = today.get(Calendar.DAY_OF_MONTH);
   int monthInt = today.get(Calendar.MONTH) + 1;
   int minuteInt = today.get(Calendar.MINUTE);
   String day = "";
   String zero = "";
   String min = "";

   if(dayInt < 10)
       day = "0";
   if(monthInt < 10)
       zero = "0";
   if(minuteInt < 10)
       min = "0";

   val[0] = day + today.get(Calendar.DAY_OF_MONTH);
   val[1] = zero + monthInt;
   val[2] = "" + today.get(Calendar.YEAR);
   val[3] = "" + today.get(Calendar.HOUR_OF_DAY);
   val[4] = min + today.get(Calendar.MINUTE);
   return val;
 }

 public String getFormatZero(String[] val) {

   String date = val[3] + ":" + val[4] + " - " + val[0] + "/" + val[1] + "/" + val[2];
   return date;
 }

 public String getFormatOne(String[] val) {

   String date = val[0] + "/" + val[1] + "/" + val[2];
   return date;
 }

 public String getFormatTwo(String[] val) {

   String date = val[1] + "/" + val[0] + "/" + val[2];
   return date;
 }

 public String getFormatThree(String[] val) {

   String months[] = {idiom.getWord("JANUARY"),idiom.getWord("FEBRUARY"),idiom.getWord("MARCH"),idiom.getWord("APRIL"),idiom.getWord("MAY"),idiom.getWord("JUNE"),idiom.getWord("JULY"),idiom.getWord("AUGUST"),idiom.getWord("SEPTEMBER"),idiom.getWord("OCTOBER"),idiom.getWord("NOVEMBER"),idiom.getWord("DECEMBER")};

   int month = Integer.parseInt(val[1]) - 1;
   String date = months[month] + " " + val[0] + " of " + val[2];
   return date;
 }

} //Fin de la Clase
