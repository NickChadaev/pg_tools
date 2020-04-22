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
 *  CLASS StyleSelector  @version 1.0 
 *   This class is responsible for managing the dialogue by
 *   which you can view and choose the types of appearances
 *   preset to create a report.
 *  
 *  History:
 *           
 */

package ru.nick_ch.x1.report;

import ru.nick_ch.x1.idiom.*;
import javax.swing.*;
import java.awt.*;
import java.awt.event.*;
import javax.swing.border.Border;
import javax.swing.border.TitledBorder;
import javax.swing.event.*;

public class StyleSelector extends JDialog implements ActionListener,ListSelectionListener{

 JLabel picture;
 int indice;
 boolean wellDone = false;
 Language idiom;
 String xpgHome = "";

 public StyleSelector(JDialog dialog,Language leng)
  {
  super(dialog, true);
  xpgHome = System.getProperty("xpgHome") + System.getProperty("file.separator")
   + "styles" + System.getProperty("file.separator");
  idiom = leng;
  setTitle(idiom.getWord("PRS"));
  getContentPane().setLayout(new BorderLayout());
  JPanel Global = new JPanel();
  Global.setLayout(new BorderLayout());

  String[] values = {"Classic","Blue","Eternal","Green","Caribean","Steel","Woods","Mostaz",
                     "Century","Roman"};
  JList disenn = new JList(values);
  disenn.setSelectedIndex(0);
  disenn.addListSelectionListener(this);
  JScrollPane marco = new JScrollPane(disenn);
  JPanel panelL = new JPanel();
  panelL.setLayout(new FlowLayout(FlowLayout.CENTER));
  panelL.add(marco);

  JPanel imagen = new JPanel();
  imagen.setLayout(new BorderLayout());
  ImageIcon photo = new ImageIcon(xpgHome + "Image00.png"); 
  indice = 0;
  picture = new JLabel(photo,JLabel.CENTER);
  picture.setPreferredSize(new Dimension(photo.getIconWidth(),
                                               photo.getIconHeight()));
  JScrollPane pictureScroll = new JScrollPane(picture);
  imagen.add(pictureScroll);

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

  JPanel up = new JPanel();
  up.setLayout(new BorderLayout());
  up.add(imagen,BorderLayout.CENTER);
  up.add(marco,BorderLayout.WEST);
  Border etched1 = BorderFactory.createEtchedBorder();
  TitledBorder title1 = BorderFactory.createTitledBorder(etched1,idiom.getWord("CHO"));
  up.setBorder(title1);

  getContentPane().add(up,BorderLayout.CENTER);
  getContentPane().add(botonD,BorderLayout.SOUTH);
  pack();
  setLocationRelativeTo(dialog);
  setVisible(true);
 }

 public void valueChanged(ListSelectionEvent e) 
  {
   if (e.getValueIsAdjusting())
       return;

   JList theList = (JList)e.getSource();
   String pic = (String) theList.getSelectedValue();
   indice = theList.getSelectedIndex();
   ImageIcon newImage = new ImageIcon(xpgHome + "Image0" + indice + ".png");
            picture.setIcon(newImage);
   picture.setPreferredSize(new Dimension(newImage.getIconWidth(),
                                          newImage.getIconHeight() ));
   picture.revalidate();
  }


 public void actionPerformed(java.awt.event.ActionEvent e) 
  {

   if(e.getActionCommand().equals("CANCEL")) 
    {
     setVisible(false);
    }

   if(e.getActionCommand().equals("OK")) 
    {
     wellDone = true;
     setVisible(false);
    }
  }

} //Final de la Clase
