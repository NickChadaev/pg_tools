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
 *  CLASS TextDataInput @version 1.0  
 *    This class is responsible for managing the dialogue through the
 *    which is inserted a data type "text" in a table.
 * 
 *  History:
 *            
 */
 
package ru.nick_ch.x1.misc.resultset;

import ru.nick_ch.x1.idiom.*;
import java.awt.*;
import java.awt.event.*;
import javax.swing.*;

public class TextDataInput extends JDialog implements ActionListener {
 
 Language idiom;
 JTextArea data;
 String dataText = "";
 boolean wellDone = false;

 public TextDataInput(JDialog dialog, Language leng, String fieldName, String previewStr) {

    super(dialog, true);
    setTitle(fieldName);
    idiom = leng;

    JPanel global = new JPanel();
    global.setLayout(new BoxLayout(global,BoxLayout.Y_AXIS));

    data = new JTextArea(10,35);
    data.setText(previewStr);

    JScrollPane textScroll = new JScrollPane(data);

    JPanel scrollPanel = new JPanel();
    scrollPanel.add(textScroll);

    JButton ok = new JButton(idiom.getWord("OK"));
    ok.setActionCommand("OK");
    ok.addActionListener(this);
    JButton clear = new JButton(idiom.getWord("CLR"));
    clear.setActionCommand("CLEAR");
    clear.addActionListener(this);
    JButton cancel = new JButton(idiom.getWord("CANCEL"));
    cancel.setActionCommand("CANCEL");
    cancel.addActionListener(this);

    JPanel botons = new JPanel();
    botons.setLayout(new FlowLayout(FlowLayout.CENTER));
    botons.add(ok);
    botons.add(clear);
    botons.add(cancel);

    global.add(scrollPanel);
    global.add(botons);

    getContentPane().add(global);
    pack();
    setLocationRelativeTo(dialog);
    setVisible(true);
  }

 public void actionPerformed(java.awt.event.ActionEvent e) {

   if (e.getActionCommand().equals("OK")) {
       dataText = data.getText(); 
       wellDone = true;
       setVisible(false);
    }

   if (e.getActionCommand().equals("CANCEL")) {
       setVisible(false);
    }

   if (e.getActionCommand().equals("CLEAR")) {
       data.setText("");
    }
  }

 public String getValue() {
    return dataText;
  }

 public boolean isWellDone() {
    return wellDone;
  }

}
