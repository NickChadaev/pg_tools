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
 *  CLASS DropTable @version 1.0   
 *  History:
 *           
 */
package ru.nick_ch.x1.menu;

import ru.nick_ch.x1.idiom.*;
import ru.nick_ch.x1.db.*;
import java.awt.*;
import java.awt.event.*;
import java.util.*;
import javax.swing.*;
import javax.swing.border.Border;
import javax.swing.border.TitledBorder;
import java.net.URL;

public class DropTable extends JDialog implements ActionListener {

  JList tablesList;
  JList deathTables; 
  JComboBox dbCombo;

  Vector  TableList;
  Vector  blackVector;
  Vector  deleted = new Vector();
  Vector  vecConn;
  Vector  dbNames;
  JFrame  frame;
  JButton dropButton;
  
  boolean isWell = false;
  public String dbx = "";
  
  PGConnection current;
  JTextArea    LogWin;
  Language     idiom;

 public DropTable( JFrame aFrame, Vector dbnm, Vector VecC, Language lang, JTextArea monitor ) {

  super(aFrame, true);
  idiom = lang;
  setTitle ( idiom.getWord ( "DROPT" ));
  frame   = aFrame;
  vecConn = VecC;
  dbNames = dbnm;
  LogWin  = monitor;

  getContentPane().setLayout(new BorderLayout());
  JPanel vacio = new JPanel();
  String[] dataBases = new String[dbNames.size()];

  for ( int i = 0; i < dbNames.size(); i++ ) {

       Object o = dbNames.elementAt(i);
       String db = o.toString();
       dataBases[i] = db;
  }
  
  int index = dbNames.indexOf ( dataBases [0] );
  current = (PGConnection) vecConn.elementAt ( index ); 
  
  TableList = current.TableQuery ( "SELECT tablename FROM pg_tables WHERE tablename !~ '^pg_' AND tablename  !~ '^pga_' ORDER BY tablename" );
  String[] tables = new String [TableList.size()];

  for ( int i = 0; i < TableList.size (); i++ ) {
       Vector o = (Vector) TableList.elementAt (i);
       tables[i] = (String) o.elementAt (0);
  }

  JPanel leftTop = new JPanel ();
  JLabel msgString1 = new JLabel ( idiom.getWord ("SDT"), JLabel.CENTER );
  dbCombo = new JComboBox ( dataBases );
  dbCombo.setActionCommand ( "COMBO" );
  dbCombo.addActionListener ( this );

  JPanel central = new JPanel ();
  central.setLayout ( new FlowLayout (FlowLayout.CENTER));
  central.add(dbCombo);

  tablesList = new JList(tables);
  tablesList.setSelectionMode(ListSelectionModel.SINGLE_SELECTION);

  Border etched = BorderFactory.createEtchedBorder();
  TitledBorder title = BorderFactory.createTitledBorder(etched);

  JScrollPane leftScroll = new JScrollPane(tablesList);
  leftScroll.setPreferredSize(new Dimension(100, 120));

  blackVector = new Vector();
  deathTables = new JList(blackVector);
  deathTables.setSelectionMode(ListSelectionModel.SINGLE_SELECTION);
  JScrollPane rightScroll = new JScrollPane(deathTables);
  rightScroll.setPreferredSize(new Dimension(100, 120));

  URL imgURL = getClass().getResource("/icons/16_Right.png");

  JButton in = new JButton(new ImageIcon(Toolkit.getDefaultToolkit().getImage(imgURL)));
  in.setVerticalTextPosition(0);
  in.setActionCommand("RIGHT");
  in.addActionListener(this);
  imgURL = getClass().getResource("/icons/16_Left.png");

  JButton out = new JButton(new ImageIcon(Toolkit.getDefaultToolkit().getImage(imgURL)));
  out.setVerticalTextPosition(0);
  out.setActionCommand("LEFT");
  out.addActionListener(this);

  JPanel arrows = new JPanel();
  arrows.setLayout(new BoxLayout(arrows, 1));
  arrows.add(Box.createVerticalGlue());
  arrows.add(in);
  arrows.add(out);
  arrows.add(Box.createVerticalGlue());
  arrows.setAlignmentY(0.5F);

  JPanel altern = new JPanel();
  altern.setLayout(new BorderLayout());
  altern.add(leftScroll, "West");
  altern.add(arrows, "Center");
  altern.add(rightScroll, "East");
  
  leftTop.setLayout(new BorderLayout());

  JPanel medium = new JPanel();
  medium.setLayout(new BorderLayout()); 
  medium.add(msgString1,BorderLayout.NORTH);
  medium.add(central,BorderLayout.CENTER);
  medium.add(altern,BorderLayout.SOUTH);
  medium.setBorder(title);

  leftTop.add(medium,BorderLayout.CENTER);
  leftTop.setBorder(title);

  dropButton = new JButton(idiom.getWord("DROP"));
  dropButton.setEnabled(false);
  dropButton.setVerticalTextPosition(AbstractButton.CENTER);
  dropButton.setMnemonic('T');
  dropButton.setActionCommand("DROPT");
  dropButton.addActionListener(this);
  
  JButton buttonNone = new JButton(idiom.getWord("CANCEL"));
  buttonNone.setVerticalTextPosition(AbstractButton.CENTER);
  buttonNone.setMnemonic('C');
  buttonNone.setActionCommand("CANCEL");
  buttonNone.addActionListener(this);

  JPanel buttonPanel = new JPanel();
  buttonPanel.setLayout(new FlowLayout(FlowLayout.CENTER));
  buttonPanel.add(dropButton); 
  buttonPanel.add(buttonNone);  

  JPanel leftPanel = new JPanel();
  leftPanel.setLayout(new BorderLayout());
  leftPanel.add(leftTop,BorderLayout.CENTER);
  leftPanel.add(buttonPanel,BorderLayout.SOUTH);

  getContentPane().add(leftPanel,BorderLayout.CENTER);
  pack();
  setLocationRelativeTo(frame);
  setVisible(true);

 }

 public void actionPerformed(java.awt.event.ActionEvent e) {

   if (e.getActionCommand().equals("CANCEL")) {

       setVisible(false);
       return;
    }

   if (e.getActionCommand().equals("DROPT")) {

       dbx = (String) dbCombo.getSelectedItem();
       int index = dbNames.indexOf(dbx);
       current = (PGConnection) vecConn.elementAt(index);

       while (!blackVector.isEmpty()) {

              String table = (String) blackVector.remove(0);

              String result = current.SQL_Instruction("DROP TABLE \"" + table + "\"");
              addTextLogMonitor(idiom.getWord("EXEC")+"DROP TABLE \"" + table + "\";\"");

              if (!result.equals("OK")) {
                  result = result.substring(0,result.length()-1);
                  JOptionPane.showMessageDialog(frame,
                  result,
                  idiom.getWord("ERROR!"),JOptionPane.ERROR_MESSAGE);
               }
              else
                  deleted.addElement(table);

       addTextLogMonitor(idiom.getWord("RES") + result);

      }

      setVisible(false);

      return;
    }

   if (e.getActionCommand().equals("COMBO")) {

       dbx = (String) dbCombo.getSelectedItem();
       int index = dbNames.indexOf(dbx);
       current = (PGConnection) vecConn.elementAt(index);
       TableList = current.TableQuery("SELECT tablename FROM pg_tables WHERE tablename !~ '^pg_' AND tablename  !~ '^pga_' ORDER BY tablename");

       if (TableList.size() == 0) {

          if (dropButton.isEnabled())
              dropButton.setEnabled(false);
        }

       String[] tables = new String[TableList.size()];
 
       for (int i=0;i<TableList.size();i++) {
            Object o = TableList.elementAt(i);
            String db = o.toString();
            tables[i] = db.substring(1,db.length()-1);
        }

       tablesList.setListData(tables);
       blackVector = new Vector();
       deathTables.setListData(blackVector);

       return;
    }

   if (e.getActionCommand().equals("RIGHT")) {

       String s = (String)tablesList.getSelectedValue();

       if (!blackVector.contains(s)) {
           blackVector.addElement(s);
          deathTables.setListData(blackVector);
        }

       if (blackVector.size() == 1) {
           if (!dropButton.isEnabled())
               dropButton.setEnabled(true);
        }

     return;
    }

   if (e.getActionCommand().equals("LEFT")) {

       String table = (String)deathTables.getSelectedValue();

       if (blackVector.removeElement(table))
           deathTables.setListData(blackVector);

       if (blackVector.isEmpty())
           dropButton.setEnabled(false);

    }

  }

 /**
  * Metodo getDeletedTables 
  * Retorna un Vector con los nombres de las tablas eliminadas satisfactoriamente 
  */
 public Vector getDeletedTables() {

     return deleted;
   }

 /**
  * Metodo addTextLogMonitor
  * Imprime mensajes en el Monitor de Eventos
  */
 public void addTextLogMonitor(String msg) {

   LogWin.append(msg + "\n");
   int longiT = LogWin.getDocument().getLength();

   if(longiT > 0)
      LogWin.setCaretPosition(longiT - 1);
  }

} //Fin de la Clase
