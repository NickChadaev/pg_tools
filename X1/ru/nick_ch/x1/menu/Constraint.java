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
 *  CLASS Constraint @version 1.0  
 *    This class is responsible for defining constraints
 *    Included in the creation of a table. 
 *  History:
 *           
 */
package ru.nick_ch.x1.menu;

import ru.nick_ch.x1.idiom.*;
import java.awt.*;
import java.awt.event.*;
import java.util.Vector;
import javax.swing.*;
import javax.swing.border.Border;
import javax.swing.border.TitledBorder;
import javax.swing.border.*;

public class Constraint extends JDialog implements ActionListener,FocusListener,KeyListener {

    JList consList;
    Vector constraints;
    Vector DefCons;
    boolean semaforo = false;
    Language idiom;
    int index = 0;
    String constString = ""; 
    String descripString = "";
    boolean Done = false;
    JTextArea defArea;
    JTextField nameCons;
    JScrollPane jscrollpane;

    public Constraint(JDialog jframe, Language language, Vector names, Vector descrip) {

        super(jframe, true);
        idiom = language;
        setTitle(idiom.getWord("CONST"));
        constraints = names;
        DefCons = descrip;

        JPanel jpanel = new JPanel();
        //JLabel jlabel = new JLabel(idiom.getWord("CONSFT"),JLabel.CENTER);
        jpanel.setLayout(new BorderLayout());
        jpanel.add(new JLabel(idiom.getWord("CONSFT"),JLabel.CENTER), "Center");

        //JLabel msg = new JLabel(idiom.getWord("NAME") + ": ");
        nameCons = new JTextField(20);
        JPanel oneR = new JPanel();
        oneR.setLayout(new BorderLayout());
        oneR.add(new JLabel(idiom.getWord("NAME") + ": "),BorderLayout.WEST);
        oneR.add(nameCons,BorderLayout.CENTER);

        JPanel cop = new JPanel();
        cop.add(oneR);

        defArea = new JTextArea();
        defArea.setLineWrap(true);
        JScrollPane win = new JScrollPane(defArea);
        win.setPreferredSize(new Dimension(300,100));

        JPanel winP = new JPanel();
        winP.add(win);
        Border etched1 = BorderFactory.createEtchedBorder();
        TitledBorder title1 = BorderFactory.createTitledBorder(etched1,idiom.getWord("DEF"));
        winP.setBorder(title1);

        JPanel left = new JPanel(new BorderLayout());
        left.add(cop,BorderLayout.NORTH);
        left.add(winP,BorderLayout.CENTER);
        Border margin = BorderFactory.createBevelBorder(BevelBorder.LOWERED);
        left.setBorder(margin);

        consList = new JList(constraints);
        jscrollpane = new JScrollPane(consList);
        jscrollpane.setPreferredSize(new Dimension(100, 120));
        jscrollpane.addFocusListener(this);

        MouseListener mouseListener = new MouseAdapter() {
          public void mousePressed(MouseEvent e) {
            index = consList.locationToIndex(e.getPoint());
            if (e.getClickCount() == 1 && index > -1) {
                jscrollpane.requestFocus();
                setForm();
             }
            else
               nameCons.requestFocus();
                                                  }
                                                     };
        consList.addMouseListener(mouseListener);

        JButton j01 = new JButton(idiom.getWord("CLR"));
        j01.setActionCommand("CLR");
        j01.addActionListener(this);
        j01.setMnemonic(idiom.getNemo("CLR"));
        j01.setAlignmentX(0.5F);

        JButton j02 = new JButton(idiom.getWord("ADD"));
        j02.setActionCommand("ADD");
        j02.addActionListener(this);
        j02.setMnemonic(idiom.getNemo("ADD"));
        j02.setAlignmentX(0.5F);

        JButton j03 = new JButton(idiom.getWord("REMOVE"));
        j03.setActionCommand("REMOVE");
        j03.addActionListener(this);
        j03.setMnemonic(idiom.getNemo("REMOVE"));
        j03.setAlignmentX(0.5F);

        JPanel jpanel0 = new JPanel();
        jpanel0.setLayout(new FlowLayout());
        jpanel0.add(j01);
        jpanel0.add(j02);
        jpanel0.add(j03);

        JButton jbutton2 = new JButton(idiom.getWord("OK"));
        jbutton2.setActionCommand("OK");
        jbutton2.addActionListener(this);
        jbutton2.setMnemonic(idiom.getNemo("OK"));
        jbutton2.setAlignmentX(0.5F);

        JButton jbutton3 = new JButton(idiom.getWord("CANCEL"));
        jbutton3.setActionCommand("CANCEL");
        jbutton3.addActionListener(this);
        jbutton3.setMnemonic(idiom.getNemo("CANCEL"));
        jbutton3.setAlignmentX(0.5F);

        JPanel jpanel3 = new JPanel();
        jpanel3.setLayout(new FlowLayout());
        jpanel3.add(jbutton2);
        jpanel3.add(jbutton3);

        JPanel jpanel4 = new JPanel();
        jpanel4.setLayout(new BoxLayout(jpanel4,BoxLayout.X_AXIS));
        jpanel4.add(left);
        jpanel4.add(jscrollpane);

        JPanel jpanel5 = new JPanel();
        jpanel5.setLayout(new BoxLayout(jpanel5, 1));
        jpanel5.add(jpanel);
        jpanel5.add(Box.createRigidArea(new Dimension(0, 10)));
        jpanel5.add(jpanel4);
        jpanel5.add(jpanel0);
        jpanel5.add(jpanel3);

        JPanel jpanel6 = new JPanel();
        jpanel6.add(jpanel5);
        getContentPane().add(jpanel6);

        pack();
        setLocationRelativeTo(jframe);
        setVisible(true);

    }

    public void setForm() {

      constString = (String) constraints.elementAt(index);
      nameCons.setText(constString);
      String constText = (String) DefCons.elementAt(index);
      defArea.setText(constText);
    }

    public void actionPerformed(ActionEvent actionevent) {

        if (actionevent.getActionCommand().equals("ADD")) {

            constString = nameCons.getText();
            descripString = defArea.getText();

            if (descripString.length()==0) {

                JOptionPane.showMessageDialog(Constraint.this,
                idiom.getWord("EMPTY"),
                idiom.getWord("ERROR!"),JOptionPane.ERROR_MESSAGE);

                return;
             }

        if (constString.length()==0 || constString.indexOf(" ")!=-1) {

            JOptionPane.showMessageDialog(Constraint.this,
            idiom.getWord("EMPTY"),
            idiom.getWord("ERROR!"),JOptionPane.ERROR_MESSAGE);

            return;
         }

        if (!constraints.contains(constString)) {

            constraints.addElement(constString);
            DefCons.addElement(descripString);
            consList.setListData(constraints);
            consList.setSelectedValue(constString,true);
         }

        return;
      }

     if (actionevent.getActionCommand().equals("REMOVE")) {

         if (!consList.isSelectionEmpty()) {
             constraints.remove(index);
             consList.setListData(constraints);
             DefCons.remove(index);
             nameCons.setText("");
             defArea.setText("");
             nameCons.requestFocus();
          }
      }

     if (actionevent.getActionCommand().equals("CLR")) {

         nameCons.setText("");
         defArea.setText("");
         consList.clearSelection();
         nameCons.requestFocus();

         return;
      }

     if (actionevent.getActionCommand().equals("OK")) {

         if (constraints.size() > 0)
             Done = true;
         setVisible(false);

         return;
      }

     if (actionevent.getActionCommand().equals("CANCEL"))
         setVisible(false);
 }

 /**
   * METODO focusGained
   * Es un foco para los eventos del teclado
   */
   public void focusGained(FocusEvent e) {
      Component tmp = e.getComponent();
      tmp.addKeyListener(this);
    }

 /**
 * METODO focusLost
 */
    public void focusLost(FocusEvent e) {
       Component tmp = e.getComponent();
       tmp.removeKeyListener(this);
     }

   /** Handle the key typed event from the text field. */
    public void keyTyped(KeyEvent e) {
     }

    public void keyPressed(KeyEvent e) {
     }

   /*
    * METODO keyReleased
    * Handle the key released event from the text field.
    */
    public void keyReleased(KeyEvent e) {
     }

    public Vector getConsN() {
       return constraints;
     }

    public Vector getConsD() {
       return DefCons;
     }

    public boolean isWellDone() { 
       return Done;
     }

    public boolean isNum(String s) {

       for(int i = 0; i < s.length(); i++) {
           char c = s.charAt(i);
           if(!Character.isDigit(c))
              return false;
        }

       return true;
    }

}
