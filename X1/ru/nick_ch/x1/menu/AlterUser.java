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
 *  CLASS AlterUser @version 1.0  
 *   This class is responsible for managing the dialog that allows
 *   Alter the parameters of a user of the DBMS. 
 *  History:
 *           
 */

package ru.nick_ch.x1.menu;

import java.awt.BorderLayout;
import java.awt.FlowLayout;
import java.awt.GridLayout;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.sql.Timestamp;
import java.util.Vector;

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
import javax.swing.border.TitledBorder;

import ru.nick_ch.x1.db.PGConnection;
import ru.nick_ch.x1.idiom.Language;

public class AlterUser extends JDialog implements ActionListener {

 JComboBox groups;
 final JTextField textFieldUser = new JTextField(10);
 final JTextField textFieldValidez;
 final JTextField uidT = new JTextField(5);
 JPasswordField textFieldPassw;
 JPasswordField textFieldVePassw;
 JCheckBox createDBButton;
 JCheckBox createUserButton;
 boolean wellDone;
 Language idiom;
 PGConnection conn;
 JTextArea LogWin;
 JComboBox users;
 boolean superuser;
 boolean createdb;
 Timestamp datex;


 public AlterUser(JFrame jframe, Language language, PGConnection pg_konnection, JTextArea jtextarea) {

        super(jframe);
        wellDone = false;
        superuser = false;
        createdb = false;
        idiom = language;
        conn = pg_konnection;
        LogWin = jtextarea;

        setTitle(idiom.getWord("ALTER") + " " + idiom.getWord("USER"));
        JPanel jpanel = new JPanel();
        JPanel jpanel1 = new JPanel();
        JLabel jlabel = new JLabel(idiom.getWord("SELUSR") + ": ");

        String as[] = conn.getUsers();
        users = new JComboBox(as);
        users.setActionCommand("COMBO");
        users.addActionListener(this);

        Vector vector = conn.getUserInfo(as[0]);
        Boolean boolean1 = (Boolean)vector.elementAt(0);

        if (boolean1.booleanValue())
            createdb = true;

        boolean1 = (Boolean)vector.elementAt(1);

        if (boolean1.booleanValue())
            superuser = true;

        datex = (Timestamp)vector.elementAt(2);
        jpanel1.setLayout(new FlowLayout(1));
        jpanel1.add(jlabel);
        jpanel1.add(users);

        JPanel jpanel2 = new JPanel();
        JLabel jlabel1 = new JLabel(idiom.getWord("NAME") + ": ");
        jpanel2.setLayout(new GridLayout(0, 2));
        jpanel2.add(jlabel1);
        jpanel2.add(textFieldUser);

        JPanel jpanel3 = new JPanel();
        JLabel jlabel2 = new JLabel(idiom.getWord("PASSWD") + ": ");
        textFieldPassw = new JPasswordField(10);
        textFieldPassw.setEchoChar('*');
        jpanel3.setLayout(new GridLayout(0, 2));
        jpanel3.add(jlabel2);
        jpanel3.add(textFieldPassw);

        JPanel jpanel4 = new JPanel();
        JLabel jlabel3 = new JLabel(idiom.getWord("VRF") + " " + idiom.getWord("PASSWD") + ": ");
        textFieldVePassw = new JPasswordField(10);
        textFieldVePassw.setEchoChar('*');
        jpanel4.setLayout(new GridLayout(0, 2));
        jpanel4.add(jlabel3);
        jpanel4.add(textFieldVePassw);

        JPanel jpanel5 = new JPanel();
        JLabel jlabel4 = new JLabel(idiom.getWord("GROUP") + ": ");
        String as1[] = conn.getGroups();
        groups = new JComboBox(as1);
        jpanel5.setLayout(new GridLayout(0, 2));
        jpanel5.add(jlabel4);
        jpanel5.add(groups);

        JPanel jpanel6 = new JPanel();
        JLabel jlabel5 = new JLabel(idiom.getWord("VLD") + " [" + idiom.getWord("DATE") + "]: ");
        String s = "";

        if (datex != null) {
            String s1 = datex.toString();
            int i = s1.indexOf(" ");
            s = s1.substring(0, i);
         }

        textFieldValidez = new JTextField(s, 10);
        jpanel6.setLayout(new GridLayout(0, 2));
        jpanel6.add(jlabel5);
        jpanel6.add(textFieldValidez);

        JPanel jpanel7 = new JPanel();
        jpanel7.setLayout(new BoxLayout(jpanel7, 1));
        jpanel7.add(jpanel3);
        jpanel7.add(jpanel4);
        jpanel7.add(jpanel6);
        createDBButton = new JCheckBox(idiom.getWord("CREATE") + " " + idiom.getWord("DB"));

        if (createdb)
            createDBButton.setSelected(true);

        createDBButton.setMnemonic('p');
        createDBButton.setActionCommand("Create DataBase");
        createUserButton = new JCheckBox(idiom.getWord("CREATE") + " " + idiom.getWord("USER"));

        if (superuser)
            createUserButton.setSelected(true);

        createUserButton.setMnemonic('p');

        createUserButton.setActionCommand("Create User");

        JPanel jpanel8 = new JPanel();
        jpanel8.setLayout(new GridLayout(0, 2));

        JLabel jlabel6 = new JLabel("Uid:");
        jpanel8.add(jlabel6);
        jpanel8.add(uidT);

        JPanel jpanel9 = new JPanel();
        jpanel9.setLayout(new BoxLayout(jpanel9, 1));
        jpanel9.add(createDBButton);
        jpanel9.add(createUserButton);
        javax.swing.border.Border border = BorderFactory.createEtchedBorder();
        TitledBorder titledborder = BorderFactory.createTitledBorder(border, idiom.getWord("PERMI"));
        titledborder.setTitleJustification(1);
        jpanel9.setBorder(titledborder);

        JPanel jpanel10 = new JPanel();
        jpanel10.setLayout(new BorderLayout());
        jpanel10.add(jpanel9, "North");

        JPanel jpanel11 = new JPanel();
        jpanel11.setLayout(new BorderLayout());
        titledborder = BorderFactory.createTitledBorder(border, idiom.getWord("GENSETT"));
        jpanel11.add(jpanel7, "North");
        jpanel11.setBorder(titledborder);

        JPanel jpanel12 = new JPanel();
        jpanel12.setLayout(new BorderLayout());
        jpanel12.add(jpanel11, "West");
        jpanel12.add(jpanel, "Center");
        jpanel12.add(jpanel10, "East");

        JButton jbutton = new JButton(idiom.getWord("ALTER"));
        jbutton.setActionCommand("OK");
        jbutton.addActionListener(this);
        jbutton.setMnemonic('A');
        jbutton.setAlignmentX(0.5F);

        JButton jbutton1 = new JButton(idiom.getWord("CANCEL"));
        jbutton1.setActionCommand("CANCEL");
        jbutton1.addActionListener(this);
        jbutton1.setMnemonic('A');
        jbutton1.setAlignmentX(0.5F);

        JPanel jpanel13 = new JPanel();
        jpanel13.setLayout(new FlowLayout());
        jpanel13.add(jbutton);
        jpanel13.add(jbutton1);

        JPanel jpanel14 = new JPanel();
        jpanel14.setLayout(new BoxLayout(jpanel14, 1));
        jpanel14.add(jpanel1);
        jpanel14.add(jpanel12);
        jpanel14.add(jpanel13);

        JPanel jpanel15 = new JPanel();
        jpanel15.add(jpanel14);
        getContentPane().add(jpanel15);

        titledborder = BorderFactory.createTitledBorder(border);
        jpanel15.setBorder(titledborder);

        pack();
        setLocationRelativeTo(jframe);
        setVisible(true);
    }

    public void actionPerformed(ActionEvent actionevent) {

        if (actionevent.getActionCommand().equals("OK")) {

            String s = (String)users.getSelectedItem();
            String s2 = "ALTER USER " + s;
            String s3 = " WITH";
            char ac[] = textFieldPassw.getPassword();
            String s5 = new String(ac);
            char ac1[] = textFieldVePassw.getPassword();
            String s6 = new String(ac1);

            if (!s5.equals(s6)){
                JOptionPane.showMessageDialog(this, idiom.getWord("INVPASS"), idiom.getWord("ERROR!"), 0);
                return;
             }

            s3 = s3 + " PASSWORD '" + s5 + "'";

            if (createDBButton.isSelected())
                s3 = s3 + " CREATEDB";
            else
                s3 = s3 + " NOCREATEDB";

            if (createUserButton.isSelected())
                s3 = s3 + " CREATEUSER";
            else
                s3 = s3 + " NOCREATEUSER";

            String s7 = textFieldValidez.getText();

            if (s7.length() > 0)
                s3 = s3 + " VALID UNTIL '" + s7 + "'";

            s2 = s2 + s3 + ";";

            String s8 = conn.SQL_Instruction(s2);
            addTextLogMonitor(idiom.getWord("EXEC") + " \"" + s2 + "\"");
            addTextLogMonitor(idiom.getWord("RES") + " " + s8);

            if (s8.equals("OK")) {

                wellDone = true;
                setVisible(false);
             } 
            else
                JOptionPane.showMessageDialog(this, s8, idiom.getWord("ERROR!"), 0);

            return;
        }

        if (actionevent.getActionCommand().equals("COMBO")) {

            createdb = false;
            superuser = false;
            String s1 = (String)users.getSelectedItem();
            Vector vector = conn.getUserInfo(s1);
            Boolean boolean1 = (Boolean)vector.elementAt(0);

            if (boolean1.booleanValue())
                createdb = true;

            createDBButton.setSelected(createdb);
            boolean1 = (Boolean)vector.elementAt(1);

            if (boolean1.booleanValue())
                superuser = true;

            createUserButton.setSelected(superuser);
            datex = (Timestamp)vector.elementAt(2);

            if (datex != null) {

                String s4 = datex.toString();
                int i = s4.indexOf(" ");
                textFieldValidez.setText(s4.substring(0, i));
             } 
            else {
                  textFieldValidez.setText("");
             }

            return;
        }
 
        if (actionevent.getActionCommand().equals("CANCEL"))
            setVisible(false);
    }

    public boolean isNum(String s) {

        for (int i = 0; i < s.length(); i++) {

             char c = s.charAt(i);

             if (!Character.isDigit(c))
                 return false;
         }

        return true;
     }

    public void addTextLogMonitor(String s) {

        LogWin.append(s + "\n");
        int i = LogWin.getDocument().getLength();

        if (i > 0)
            LogWin.setCaretPosition(i - 1);
     }

} //Fin de la Clase
