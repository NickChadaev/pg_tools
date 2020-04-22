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
 *  CLASS CreateGroup @version 1.0  
 *    This class is responsible for managing the dialogue by
 *    which creates a group in the DBMS.
 *  History:
 *           
 */

package ru.nick_ch.x1.menu;

import ru.nick_ch.x1.idiom.*;
import ru.nick_ch.x1.db.*;
import java.awt.*;
import java.awt.event.*;
import javax.swing.*;
import javax.swing.border.Border;
import javax.swing.border.TitledBorder;
import java.util.Vector;
import java.net.URL;

public class CreateGroup extends JDialog implements ActionListener {

    JTextArea LogWin;
    PGConnection conn;
    JList usrList;
    JList groupList;
    Vector user;
    final JTextField nameText = new JTextField(12);
    final JTextField textID = new JTextField(5);
    Language idiom;

    public CreateGroup(JFrame jframe, Language language, PGConnection pg_konnection, JTextArea jtextarea) {

        super(jframe);
        idiom = language;
        setTitle(idiom.getWord("CREATE") + " " + idiom.getWord("GROUP"));
        conn = pg_konnection;
        LogWin = jtextarea;
        String as[] = conn.getUsers();
        user = new Vector();

        JPanel jpanel = new JPanel();
        JLabel jlabel = new JLabel(idiom.getWord("NAME") + ": ");
        jpanel.setLayout(new BorderLayout());
        jpanel.add(jlabel, "West");
        jpanel.add(nameText, "Center");

        JPanel jpanel1 = new JPanel();
        jpanel1.setLayout(new FlowLayout(1));
        JLabel jlabel1 = new JLabel(idiom.getWord("GROUPID"));
        jpanel1.add(jlabel1);
        jpanel1.add(textID);

        usrList = new JList(user);
        usrList.setSelectionMode(ListSelectionModel.SINGLE_SELECTION);
        JScrollPane jscrollpane = new JScrollPane(usrList);
        jscrollpane.setPreferredSize(new Dimension(100, 120));

        groupList = new JList(as);
        groupList.setSelectionMode(ListSelectionModel.SINGLE_SELECTION);
        JScrollPane jscrollpane1 = new JScrollPane(groupList);
        jscrollpane1.setPreferredSize(new Dimension(100, 120));

        URL imgURL = getClass().getResource("/icons/16_Right.png");
        JButton jbutton = new JButton(new ImageIcon(Toolkit.getDefaultToolkit().getImage(imgURL)));
        jbutton.setVerticalTextPosition(0);
        jbutton.setActionCommand("RIGHT");
        jbutton.addActionListener(this);
        imgURL = getClass().getResource("/icons/16_Left.png");

        JButton jbutton1 = new JButton(new ImageIcon(Toolkit.getDefaultToolkit().getImage(imgURL)));
        jbutton1.setVerticalTextPosition(0);
        jbutton1.setActionCommand("LEFT");
        jbutton1.addActionListener(this);

        JPanel jpanel2 = new JPanel();
        jpanel2.setLayout(new BoxLayout(jpanel2, 1));
        jpanel2.add(Box.createVerticalGlue());
        jpanel2.add(jbutton);
        jpanel2.add(jbutton1);
        jpanel2.add(Box.createVerticalGlue());
        jpanel2.setAlignmentY(0.5F);

        JButton jbutton2 = new JButton(idiom.getWord("CREATE"));
        jbutton2.setActionCommand("ACEPTAR");
        jbutton2.addActionListener(this);
        jbutton2.setMnemonic('A');
        jbutton2.setAlignmentX(0.5F);

        JButton jbutton3 = new JButton(idiom.getWord("CANCEL"));
        jbutton3.setActionCommand("CANCEL");
        jbutton3.addActionListener(this);
        jbutton3.setMnemonic('A');
        jbutton3.setAlignmentX(0.5F);

        JPanel jpanel3 = new JPanel();
        jpanel3.setLayout(new FlowLayout());
        jpanel3.add(jbutton2);
        jpanel3.add(jbutton3);

        JPanel jpanel4 = new JPanel();
        jpanel4.setLayout(new BorderLayout());
        jpanel4.add(jscrollpane, "East");
        jpanel4.add(jpanel2, "Center");
        jpanel4.add(jscrollpane1, "West");

        Border etched = BorderFactory.createEtchedBorder();
        TitledBorder title = BorderFactory.createTitledBorder(etched);
        jpanel4.setBorder(title);

        JPanel jpanel5 = new JPanel();
        jpanel5.setLayout(new BoxLayout(jpanel5, 1));
        jpanel5.add(jpanel);
        jpanel5.add(jpanel1);
        jpanel5.add(Box.createRigidArea(new Dimension(0, 10)));
        jpanel5.add(jpanel4);
        jpanel5.add(jpanel3);

        JPanel jpanel6 = new JPanel();
        jpanel6.add(jpanel5);

        jpanel6.setBorder(title);

        getContentPane().add(jpanel6);
        pack();
        setLocationRelativeTo(jframe);
        setVisible(true);
    }

    public void actionPerformed(ActionEvent actionevent) {

        if (actionevent.getActionCommand().equals("RIGHT")) {

            String s = (String)groupList.getSelectedValue();

            if (!user.contains(s)) {
                user.addElement(s);
                usrList.setListData(user);
            }

            return;
        }

        if (actionevent.getActionCommand().equals("LEFT")) {

            String s1 = (String)usrList.getSelectedValue();

            if (user.removeElement(s1))
                usrList.setListData(user);

            return;
        }

        if (actionevent.getActionCommand().equals("ACEPTAR")) {

            String s2 = nameText.getText();

            if (s2.length() < 1) {

                JOptionPane.showMessageDialog(this,idiom.getWord("GNE"), idiom.getWord("ERROR!"), 0);
                return;
             }

            if (s2.indexOf(" ") != -1) {
                JOptionPane.showMessageDialog(this,idiom.getWord("GNIV"), idiom.getWord("ERROR!"), 0);
                return;
             }

            String s3 = "CREATE GROUP " + s2;
            String s4 = "";
            String s5 = textID.getText();
 
            if (s5.length() > 0) {

                if (!isNum(s5)) {
                    JOptionPane.showMessageDialog(this,idiom.getWord("INVGID"), idiom.getWord("ERROR!"), 0);
                    return;
                 }

                s4 = s4 + " SYSID " + s5;
             }
 
            if (user.size() > 0) {

                s4 = s4 + " USER ";

                for (int i = 0; i < user.size(); i++) {

                     String s7 = (String)user.elementAt(i);
                     s4 = s4 + s7;

                     if(i < user.size() - 1)
                        s4 = s4 + ", ";
                 }
             }

            if (s4.length() > 0)
                s3 = s3 + " WITH" + s4 + ";";

            String s6 = conn.SQL_Instruction(s3);
            addTextLogMonitor(idiom.getWord("EXEC") + s3 + "\"");
            addTextLogMonitor(idiom.getWord("RES") + s6 + "\"");

            if (s6.equals("OK"))
                setVisible(false);
            else {
                  JOptionPane.showMessageDialog(this, s6, idiom.getWord("ERROR!"), 0);
                  return;
              }

            return;
        }

        if (actionevent.getActionCommand().equals("CANCEL"))
            setVisible(false);
    }

    public void addTextLogMonitor(String s) {

        LogWin.append(s + "\n");
        int i = LogWin.getDocument().getLength();

        if (i > 0)
            LogWin.setCaretPosition(i - 1);
    }

    public boolean isNum(String s) {

        for (int i = 0; i < s.length(); i++) {

             char c = s.charAt(i);

             if (!Character.isDigit(c))
                 return false;
         }

        return true;
    }

} //Fin de la Clase
