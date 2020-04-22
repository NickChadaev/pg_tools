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
 *  CLASS DumpDb @version 1.0 
 *     Class responsible for managing the dialogue through which
 *     Performs the dump of one or more databases. 
 *  History:
 *           
 */

package ru.nick_ch.x1.menu;

import java.awt.BorderLayout;
import java.awt.FlowLayout;
import java.awt.event.ActionListener;
import java.io.File;
import java.io.FileOutputStream;
import java.io.PrintStream;
import java.util.Vector;

import javax.swing.BorderFactory;
import javax.swing.BoxLayout;
import javax.swing.JButton;
import javax.swing.JComboBox;
import javax.swing.JDialog;
import javax.swing.JFileChooser;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JList;
import javax.swing.JOptionPane;
import javax.swing.JPanel;
import javax.swing.JRadioButton;
import javax.swing.JTextField;
import javax.swing.border.Border;
import javax.swing.border.TitledBorder;

import ru.nick_ch.x1.db.PGConnection;
import ru.nick_ch.x1.db.Table;
import ru.nick_ch.x1.db.TableFieldRecord;
import ru.nick_ch.x1.db.TableHeader;
import ru.nick_ch.x1.idiom.Language;
import ru.nick_ch.x1.misc.file.ExtensionFilter;
import ru.nick_ch.x1.misc.input.GenericQuestionDialog;

public class DumpDb extends JDialog implements ActionListener {

 boolean offline = false;
 boolean ready = false;
 private String typedText = null;
 JList tablesList;
 JComboBox combo1;
 Vector TableList;
 JFrame frame;
 JTextField textField2;
 JRadioButton strOnlyButton;
 JRadioButton strDataButton;
 Language idiom;
 Vector vecConn;
 Vector dbNames;
 PGConnection dbDump;
 String tablesString = "";
 String DBWinner = "";
 String destiny = "";
 public boolean wellDone = false;
 String[] tables;

 public DumpDb (JFrame aFrame,String dbname,PGConnection dbConn,Language lang)
  {
  super(aFrame, true);
  idiom = lang;
  frame = aFrame;
  dbDump = dbConn;

  setTitle(idiom.getWord("DUMP") + " " + idiom.getWord("DB") + " " + dbname);

  JPanel global = new JPanel();
  global.setLayout(new BoxLayout(global,BoxLayout.Y_AXIS));

  TableList = dbDump.TableQuery("SELECT tablename FROM pg_tables WHERE tablename !~ '^pg_' AND tablename  !~ '^pga_' ORDER BY tablename");

  /*** ConstrucciÔøΩn componentes de la ventana ***/
  //Creacion radio Button

  strOnlyButton = new JRadioButton(idiom.getWord("SDG"));
  strOnlyButton.setSelected(true);
  strOnlyButton.setMnemonic('s'); 
  strOnlyButton.setActionCommand("SOnly"); 

  strDataButton = new JRadioButton(idiom.getWord("RECS"));
  strDataButton.setMnemonic('r'); 
  strDataButton.setActionCommand("ROnly"); 
  
  JPanel rightTop = new JPanel();
  rightTop.setLayout(new BoxLayout(rightTop,BoxLayout.Y_AXIS));
  rightTop.add(strOnlyButton);
  rightTop.add(strDataButton);
  Border etched = BorderFactory.createEtchedBorder();
  TitledBorder title = BorderFactory.createTitledBorder(etched,idiom.getWord("DUMP"));
  title.setTitleJustification(TitledBorder.LEFT);
  rightTop.setBorder(title);
  
  JPanel rightDown = new JPanel();
  JLabel msgString2 = new JLabel(idiom.getWord("FN"));
  textField2 = new JTextField(15); 
  JButton buttonOpen = new JButton(idiom.getWord("BROWSE"));
  buttonOpen.setActionCommand("OPEN");
  buttonOpen.addActionListener(this);

  rightDown.setLayout(new BorderLayout());
  rightDown.add(msgString2,BorderLayout.NORTH);
  rightDown.add(textField2,BorderLayout.WEST);
  rightDown.add(buttonOpen,BorderLayout.EAST);  
 
  JPanel intern = new JPanel();
  intern.setLayout(new FlowLayout(FlowLayout.CENTER));
  intern.add(rightDown);

  JPanel rightPanel = new JPanel();
  rightPanel.setLayout(new BoxLayout(rightPanel,BoxLayout.Y_AXIS));
  rightPanel.add(rightTop);
  rightPanel.add(intern);
  
  /*** UniÔøΩn de todos los componentes de la ventana ***/
  
  JPanel downPanel = new JPanel();
  downPanel.setLayout(new FlowLayout(FlowLayout.CENTER));
  downPanel.add(rightPanel);

  title = BorderFactory.createTitledBorder(etched);
  downPanel.setBorder(title);

  JButton ok = new JButton(idiom.getWord("OK"));
  ok.setActionCommand("ButtonOk");
  ok.addActionListener(this);

  JButton cancel = new JButton(idiom.getWord("CANCEL"));
  cancel.setActionCommand("ButtonCancel");
  cancel.addActionListener(this);

  JPanel botons = new JPanel();
  botons.setLayout(new FlowLayout(FlowLayout.CENTER));
  botons.add(ok);
  botons.add(cancel);

  global.add(downPanel); 
  global.add(botons);

  getContentPane().add(global);

  pack();
  setLocationRelativeTo(frame);
  setVisible(true);

 }

 public void actionPerformed(java.awt.event.ActionEvent e) 
 {

  if(e.getActionCommand().equals("ButtonCancel")) 
   {
     setVisible(false);
     return;
   }		

  if(e.getActionCommand().equals("OPEN"))
   {
    String s = "file:" + System.getProperty("user.home");
    File file;
    boolean Rewrite = true;
    String FileName = "";

    JFileChooser fc = new JFileChooser(s);
    ExtensionFilter filter = new ExtensionFilter("sql",idiom.getWord("SQLF"));
    fc.addChoosableFileFilter(filter);    

    int returnVal = fc.showDialog(frame,idiom.getWord("EXPORTAB"));

    if (returnVal == JFileChooser.APPROVE_OPTION) 
      {
        file = fc.getSelectedFile();
        FileName = file.getAbsolutePath();

        if(file.exists()) {
              GenericQuestionDialog win = new GenericQuestionDialog(frame,idiom.getWord("YES"),idiom.getWord("NO"),idiom.getWord("ADV"),
                        idiom.getWord("FILE") + " \"" + FileName + "\" " + idiom.getWord("SEQEXIS2") + " " + idiom.getWord("OVWR"));

              Rewrite = win.getSelecction();
            } 
         if(Rewrite)
          textField2.setText(FileName);
       } 

    return;
   }

  if(e.getActionCommand().equals("ButtonOk")) 
   {
     if(strOnlyButton.isSelected() || strDataButton.isSelected())
      {
         destiny = textField2.getText();    

         if(destiny.length()>0)
           {
             try 
              {
                if(!destiny.endsWith(".sql"))
                    destiny += ".sql";

                if((destiny.indexOf("/") == -1) && (destiny.indexOf("\\") == -1))
                    destiny = System.getProperty("user.home") + System.getProperty("file.separator") + destiny;
                PrintStream sqlFile = new PrintStream(new FileOutputStream(destiny)); 

                for(int i=0;i<TableList.size();i++)
                  {
                    Vector oneTable = (Vector) TableList.elementAt(i);
                    String nameT = (String) oneTable.elementAt(0);
                    tablesString += "'" + nameT + "'";
                    if(i<(TableList.size()-1))
                       tablesString += ",";

                    // 2011-11-13 Nick
                    Table table1 = dbDump.getSpecStrucTable(nameT, "public") ;
                    
                    if(strOnlyButton.isSelected())
                     {
                      String sql = BuildSQLStructure(nameT,table1);
                      sqlFile.print(sql);
                     }

                    if(strDataButton.isSelected())
                     {
                      TableHeader headT = table1.getTableHeader();
                      String sql = BuildSQLRecords(nameT,headT);
                      sqlFile.print(sql);
                     }
                           
                    sqlFile.print("\n");
                  }

                 sqlFile.close(); 

                } // fin try
               catch(Exception ex)
                {
                  System.out.println("Error: " + ex);
                  ex.printStackTrace();
                }

               wellDone = true;
               setVisible(false);
               return;
             }
            else
              {
               JOptionPane.showMessageDialog(DumpDb.this,idiom.getWord("DFINS"),idiom.getWord("ERROR!"),JOptionPane.ERROR_MESSAGE);
              }
           }
            else
              {
               JOptionPane.showMessageDialog(DumpDb.this,idiom.getWord("NTE"),idiom.getWord("ERROR!"),JOptionPane.ERROR_MESSAGE);
              }
        }
 }

String BuildSQLStructure(String tableName,Table table)
 {
   String sql = "CREATE TABLE " + tableName + " (\n";
   TableHeader headT = table.base;
   int numFields = headT.NumFields;

   for(int k=0;k<numFields;k++)
    {
      Object o = (String) headT.fields.elementAt(k);
      String field_name = o.toString();
      TableFieldRecord tmp = (TableFieldRecord) headT.hashFields.get(field_name);
      sql += tmp.Name + " ";

      String typeF = tmp.Type;
      if ("char".equals(tmp.Type) || "varchar".equals(tmp.Type))
       {
        int longStr = tmp.options.charLong;
        if(longStr>0)
          typeF = tmp.Type + "(" + tmp.options.charLong + ")";
        else
          typeF = tmp.Type;
       }

      sql += typeF + " ";

      Boolean tmpbool = new Boolean(tmp.options.isNull);

      if(tmpbool.booleanValue())
        sql += "NOT NULL ";

      String defaultV = tmp.options.DefaultValue;

      if(defaultV.endsWith("::bool"))
       {
        if(defaultV.indexOf("t")!=-1)
           defaultV = "true";
        else
           defaultV = "false";
       }

      if(defaultV.length()>0)
        sql += " DEFAULT " + defaultV;

      if(k < numFields-1)
        sql += ",\n";
   }
   sql += "\n);\n";
   
   return sql;
 } 

String BuildSQLRecords(String table,TableHeader headT)
 {
   Vector data = dbDump.TableQuery("select * from " + table);
   Vector col = dbDump.TableHeader;
   String sql = "";

   if(!dbDump.queryFail())
     {
      for(int p=0;p<data.size();p++)
       {
        sql += "INSERT INTO " + table + " VALUES(";
        Vector tempo = (Vector) data.elementAt(p);
        int numCol = tempo.size();
        for(int j=0;j<numCol;j++)
         {
          String colName = (String) col.elementAt(j);
          String type = headT.getType(colName);
          Object o = tempo.elementAt(j);

          if(type.startsWith("varchar") || type.startsWith("char") || type.startsWith("text") || type.startsWith("name") || type.startsWith("date") || type.startsWith("time"))
             sql += "'" + o.toString() + "'"; 
          else
             sql += o.toString();

          if(j < (numCol - 1))
            sql += ",";
         }
        sql += ");\n";
       }
     }

   return sql;
 }

public String getDBName()
 {
  return DBWinner;
 }

public String getTables()
 {
  return tablesString;
 }

public String getFile()
 {
  return destiny;
 }

} //Fin de la Clase
