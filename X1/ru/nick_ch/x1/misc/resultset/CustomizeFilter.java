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
 *  CLASS CustomizeFilter @version 1.0   
 *  History:
 *           
 */
 
package ru.nick_ch.x1.misc.resultset;

import ru.nick_ch.x1.idiom.*;
import ru.nick_ch.x1.db.*;
import ru.nick_ch.x1.queries.*;
import javax.swing.JDialog;
import javax.swing.JLabel;
import javax.swing.JComboBox;
import javax.swing.*;
import javax.swing.border.Border;
import javax.swing.border.TitledBorder;
import java.awt.*;
import java.awt.event.*;

public class CustomizeFilter extends JDialog implements ActionListener {

 JComboBox postSEL;
 Table mytable;
 JTextArea SQLspace;
 boolean wellDone = false;
 String select = "";
 String text = "";
 Language idiom;

 public CustomizeFilter(Table table,JFrame frame,Language leng) {

   super(frame, true);
   idiom = leng;
   setTitle(idiom.getWord("CUF"));
   mytable = table;

   JLabel title = new JLabel("SELECT ",JLabel.CENTER);
   String[] diff = {"ALL","DISTINCT"};
   postSEL = new JComboBox(diff);

   JPanel first = new JPanel();
   first.setLayout(new FlowLayout(FlowLayout.CENTER));
   first.add(title);
   title = new JLabel(" ON " + mytable.getName(),JLabel.CENTER); 
   first.add(postSEL);
   first.add(title);

   Border etched1 = BorderFactory.createEtchedBorder();
   TitledBorder title1 = BorderFactory.createTitledBorder(etched1);
   first.setBorder(title1);
   SQLspace = new JTextArea(6,35);
   JScrollPane block = new JScrollPane(SQLspace);
   JPanel Tarea = new JPanel();
   Tarea.setLayout(new BorderLayout());
   Tarea.add(block,BorderLayout.CENTER);
   title1 = BorderFactory.createTitledBorder(etched1,"WHERE");
   Tarea.setBorder(title1);

   JButton ok = new JButton(idiom.getWord("RUN"));
   ok.setActionCommand("OK");
   ok.addActionListener(this);
   JButton clear = new JButton(idiom.getWord("CLR"));
   clear.setActionCommand("CLEAR");
   clear.addActionListener(this);
   JButton cancel = new JButton(idiom.getWord("CANCEL"));
   cancel.setActionCommand("CANCEL");
   cancel.addActionListener(this);

   Object[] array = {first,Tarea};
   Object[] options = {ok,clear,cancel};
   JOptionPane optionPane = new JOptionPane(array, JOptionPane.PLAIN_MESSAGE, JOptionPane.YES_NO_OPTION, null,
                               options, options[0]);

   setContentPane(optionPane);
   pack();
   setLocationRelativeTo(frame);
   setVisible(true);
  }

 /*** Manejo de Eventos ***/

 public void actionPerformed(java.awt.event.ActionEvent e) {

 if (e.getActionCommand().equals("OK")) {

     String condition = (String) postSEL.getSelectedItem();
     select = "SELECT " + condition + " \"oid\",* FROM \"" + mytable.getName() + "\"";
     text = SQLspace.getText();

     if (text.length()>0) {

         text = text.trim();
         text = Queries.clearSpaces(text);
         select += " WHERE " + text;
      }

     if (text.endsWith(";"))
         select = select.substring(0,select.length()-1);

     wellDone = true;
     setVisible(false);
 }

 if (e.getActionCommand().equals("CLEAR")) {

     SQLspace.setText("");
     SQLspace.requestFocus();
  }

 if (e.getActionCommand().equals("CANCEL")) {
     setVisible(false);
  }

 }

public String getOrder() {

   String where = text.toLowerCase(); 
   String order = "";

   int index = where.indexOf("order by");

   if (index != -1) {

       order = where.substring(index + 9,where.length());
       int k = text.length();

       char[] characters = order.toCharArray();

       for (int i=0;i<characters.length;i++) {
            if (characters[i] == ' ') {
                k = i;
                break;
             } 
        } 
       
       int pos = index + 9;
       k += pos;

       String tmp = text.substring(pos,k);

       if (order.indexOf(" asc") != -1 )
           tmp += " ASC";

       if (order.indexOf(" desc") != -1 )
           tmp += " DESC"; 

       order = tmp;
    }

   return order;
 }

public boolean isWellDone() {
  return wellDone;
 }

public String getSelect() {
  return select;
 }

} //Fin de la Clase
