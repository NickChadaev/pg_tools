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
 *  CLASS DropGroup @version 1.0   
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

public class DropGroup extends JDialog {

    private JOptionPane optionPane;
    JTextArea LogWin;
    final JComboBox cmbUser;
    Language idiom;
    PGConnection conn;

    public DropGroup(JFrame jframe, Language language, PGConnection pg_konnection, JTextArea jtextarea) {

        super(jframe, true);
        idiom = language;
        conn = pg_konnection;
        LogWin = jtextarea;
        setTitle(idiom.getWord("RMGRP"));
        String as[] = conn.getGroups();

        JLabel jlabel = new JLabel(idiom.getWord("SELGRP"));
        cmbUser = new JComboBox(as);

        Object aobj[] = { jlabel, cmbUser };
        Object aobj1[] = { idiom.getWord("DROP"), idiom.getWord("CANCEL") };

        optionPane = new JOptionPane(((Object) (aobj)), 3, 0, null, aobj1, aobj1[0]);
        setContentPane(optionPane);
        setDefaultCloseOperation(0);
 
        addWindowListener(new WindowAdapter() {
            public void windowClosing(WindowEvent windowevent) {
                optionPane.setValue(new Integer(-1));
            }
         });

        optionPane.addPropertyChangeListener(new PropertyChangeListener() {

            public void propertyChange(PropertyChangeEvent propertychangeevent) {

                String s = propertychangeevent.getPropertyName();
                if (isVisible() && propertychangeevent.getSource() == optionPane && (s.equals("value") || s.equals("inputValue"))) {
                    Object obj = optionPane.getValue();

                    if (obj == JOptionPane.UNINITIALIZED_VALUE)
                        return;

                    if (obj.equals(idiom.getWord("DROP"))) {

                        String s1 = (String)cmbUser.getSelectedItem();
                        String s2 = "DROP GROUP " + s1 + ";";
                        String s3 = conn.SQL_Instruction(s2);

                        addTextLogMonitor(idiom.getWord("EXEC") + " \"" + s2 + "\"");
                        addTextLogMonitor(idiom.getWord("RES") + s3);

                        if (s3.equals("OK"))
                            setVisible(false);
                        else {
                              JOptionPane.showMessageDialog(DropGroup.this, s3, idiom.getWord("ERROR!"), 0);
                              return;
                         }
                      } 
                     else
                        setVisible(false);
                 }
            }

        });

      pack();
      setLocationRelativeTo(jframe);
      setVisible(true);
    }

    public void addTextLogMonitor(String s) {

        LogWin.append(s + "\n");
        int i = LogWin.getDocument().getLength();

        if (i > 0)
            LogWin.setCaretPosition(i - 1);
     }

} //Fin de la Clase
