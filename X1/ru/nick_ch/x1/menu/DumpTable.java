/**
 * This software is free according GNU GENERAL PUBLIC LICENSE and
 * based on the XPg project, developed by KAZAK Solutions. 
 * Research and Development Group of Free Software, 
 * Santiago de Cali Republic of Colombia 2001.
 * Author:
 *          Gustavo GonzÀlez <xtingray@kazak.com.co>.                   
 * ----------------------------------------------------------------------------
 * Now this software is developing for modern version of PostgreSQL.
 * Author: 
 *          Nick Chadaev <nick_ch58@list.ru>. Moscow, Russia. Single developer.
 *          New stage of developing had been started at 2009-06-16. 
 * ----------------------------------------------------------------------------
 *  CLASS DumpTable @version 1.0 
 *     Class responsible for managing the dialogue through which
 *     Performs the dump of one or more tables.  
 *  History:
 *   2009-08-10 Nick was here.
 *   2010-01-29 New sizes of widget was installed.  
 *   2010-05-18 Rebuild             
 */

package ru.nick_ch.x1.menu;

import java.awt.BorderLayout;
import java.awt.Dimension;
import java.awt.FlowLayout;
import java.awt.event.ActionListener;
import java.awt.event.MouseAdapter;
import java.awt.event.MouseEvent;
import java.awt.event.MouseListener;
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
import javax.swing.JScrollPane;
import javax.swing.JTextField;
import javax.swing.ListSelectionModel;
import javax.swing.border.Border;
import javax.swing.border.TitledBorder;

import ru.nick_ch.x1.db.PGConnection;
import ru.nick_ch.x1.db.Table;
import ru.nick_ch.x1.db.TableFieldRecord;
import ru.nick_ch.x1.db.TableHeader;
import ru.nick_ch.x1.idiom.Language;
import ru.nick_ch.x1.main.Sz_visuals;
import ru.nick_ch.x1.misc.file.ExtensionFilter;
import ru.nick_ch.x1.misc.input.GenericQuestionDialog;

public class DumpTable extends JDialog implements ActionListener, Sz_visuals, Sql_menu  {

 boolean offline = false;
 boolean ready   = false;
 //private String typedText = null;
 
 JList tablesList; 
 JComboBox combo1;
 
 Vector TableList;
 
 JFrame frame;
 JTextField textField2;
 JRadioButton strOnlyButton;
 JRadioButton strDataButton;
 JButton ok;
 
 Language idiom;
 
 Vector vecConn;
 Vector dbNames;
 
 PGConnection dbDump;
 
 String tablesString = cEMP;
 String DBWinner = cEMP;
 String destiny  = cEMP;
 
 boolean listOk = false;
 boolean checkOk;
 boolean fileOk   = false;
 boolean wellDone = false;

 public DumpTable ( JFrame aFrame, Vector dbnm, Vector VecC, Language lang ) {

  super( aFrame, true );
  
  idiom   = lang;
  frame   = aFrame;
  vecConn = VecC;
  dbNames = dbnm;

  setTitle ( idiom.getWord ( "DUMPT" ) );
  JPanel global = new JPanel();
  global.setLayout ( new BoxLayout ( global, BoxLayout.Y_AXIS ) );

  String[] dataBases = new String [ dbNames.size() ];

  for ( int i = 0; i < dbNames.size(); i++ ) {

	  String db = (String) dbNames.elementAt(i);
      if ( i == 0 ) DBWinner = db;
      dataBases[i] = db;
  }
  
  int index = dbNames.indexOf ( dataBases[0] );
  dbDump = (PGConnection) vecConn.elementAt ( index );
  TableList = dbDump.TableQuery ( 
		"SELECT tablename FROM pg_tables WHERE tablename !~ '^pg_' AND tablename  !~ '^pga_' ORDER BY tablename" );
  String[] tables = new String[TableList.size()];

  for ( int i = 0; i < TableList.size(); i++ ) {

       Vector o = (Vector) TableList.elementAt (i);
       tables[i] = (String) o.elementAt (0);
   }

  /*** Construciï¿½n Barra de botones ***/

  JButton buttonAll = new JButton ( idiom.getWord ( "SELALL" ) );
  buttonAll.setMnemonic ('A');
  buttonAll.setActionCommand ("sALL");
  buttonAll.addActionListener ( this );
  
  JButton buttonNone = new JButton ( idiom.getWord ( "CLR" ));
  buttonNone.setMnemonic ('N');
  buttonNone.setActionCommand ("sNOE");
  buttonNone.addActionListener (this);

  JPanel buttonPanel = new JPanel();
  buttonPanel.setLayout ( new FlowLayout ( FlowLayout.CENTER ));
  buttonPanel.add ( buttonAll );
  buttonPanel.add ( buttonNone );  

  /** Construciï¿½n parte izquierda de la ventana **/

  JPanel leftTop = new JPanel();
  JLabel msgString1 = new JLabel ( idiom.getWord ("SELECTDB"), JLabel.CENTER );
  combo1 = new JComboBox ( dataBases );
  combo1.setActionCommand ( "COMBO" );
  combo1.addActionListener ( this );

  tablesList = new JList ( tables );
  tablesList.setSelectionMode ( ListSelectionModel.MULTIPLE_INTERVAL_SELECTION );

  MouseListener mouseListener = new MouseAdapter () {

     public void mousePressed ( MouseEvent e ) {

        int index = tablesList.locationToIndex ( e.getPoint () );

        if ( e.getClickCount() == 1 && index > -1 ) {

            if ( fileOk && checkOk && !ok.isEnabled () ) ok.setEnabled ( true );
         }
      }
   };

  tablesList.addMouseListener ( mouseListener );

  JScrollPane componente = new JScrollPane ( tablesList );
  componente.setPreferredSize ( new Dimension ( cSCROLL_PANE_H, cSCROLL_PANE_W ) ); // Nick 2010_01_29    

  JPanel block = new JPanel();
  block.setLayout ( new BoxLayout ( block, BoxLayout.Y_AXIS ) );
  block.add ( combo1 );
  block.add ( componente );

  leftTop.setLayout ( new BorderLayout () );
  leftTop.add ( msgString1, BorderLayout.NORTH );
  leftTop.add ( block, BorderLayout.CENTER );

  JPanel got = new JPanel();
  got.setLayout ( new FlowLayout ( FlowLayout.CENTER ) );
  got.add ( leftTop );

  JPanel leftPanel = new JPanel ();
  leftPanel.setLayout ( new BorderLayout () );
  leftPanel.add ( got, BorderLayout.NORTH );
  leftPanel.add ( buttonPanel, BorderLayout.SOUTH );
  
  /*** Construcciï¿½n parte derecha de la ventana ***/
  //Creacion radio Button

  strOnlyButton = new JRadioButton ( idiom.getWord ("SDG") );
  strOnlyButton.setSelected ( true );
  checkOk = true;
  strOnlyButton.setMnemonic ( 'u' ); 
  strOnlyButton.setActionCommand  ( "SOnly" ); 
  strOnlyButton.addActionListener ( this );

  strDataButton = new JRadioButton ( idiom.getWord ( "RECS" ) );
  strDataButton.setMnemonic ('e'); 
  strDataButton.setActionCommand ("SOnly"); 
  strDataButton.addActionListener (this);
  
  JPanel rightTop = new JPanel();
  rightTop.setLayout ( new BoxLayout ( rightTop, BoxLayout.Y_AXIS ) );
  rightTop.add ( strOnlyButton );
  rightTop.add ( strDataButton );

  Border etched = BorderFactory.createEtchedBorder ();
  TitledBorder title = BorderFactory.createTitledBorder ( etched, idiom.getWord ( "DUMP" ) );
  title.setTitleJustification ( TitledBorder.LEFT );
  rightTop.setBorder ( title );
  
  JPanel rightDown = new JPanel ();
  JLabel msgString2 = new JLabel ( idiom.getWord ("FN") );
  textField2 = new JTextField (15); 

  JButton buttonOpen = new JButton ( idiom.getWord ( "BROWSE" ) );
  buttonOpen.setActionCommand ( "OPEN" );
  buttonOpen.addActionListener ( this );

  rightDown.setLayout ( new BorderLayout() );
  rightDown.add ( msgString2, BorderLayout.NORTH );
  rightDown.add ( textField2, BorderLayout.WEST );
  rightDown.add ( buttonOpen, BorderLayout.EAST );  
 
  JPanel intern = new JPanel ();
  intern.setLayout ( new FlowLayout ( FlowLayout.CENTER ));
  intern.add ( rightDown );

  JPanel rightPanel = new JPanel();
  rightPanel.setLayout ( new BoxLayout ( rightPanel, BoxLayout.Y_AXIS ));
  rightPanel.add ( rightTop );
  rightPanel.add ( intern );
  
  /** Uniï¿½n de todos los paneles de la ventana ***/
  
  JPanel downPanel = new JPanel();
  downPanel.setLayout ( new FlowLayout ( FlowLayout.CENTER ) );
  downPanel.add ( leftPanel );
  downPanel.add ( rightPanel );

  title = BorderFactory.createTitledBorder(etched);
  downPanel.setBorder(title);

  ok = new JButton ( idiom.getWord ("OK") );
  ok.setEnabled ( false );
  ok.setActionCommand ( "OK" );
  ok.addActionListener ( this );

  JButton cancel = new JButton ( idiom.getWord ( "CANCEL" ) );
  cancel.setActionCommand ( "ButtonCancel" );
  cancel.addActionListener ( this );

  JPanel botons = new JPanel ();
  botons.setLayout ( new FlowLayout ( FlowLayout.CENTER ));
  botons.add ( ok );
  botons.add ( cancel );

  global.add ( downPanel ); 
  global.add ( botons );

  getContentPane().add ( global );
  pack ();
  
  setSize ( ( cUNLOAD_WIN_W - 25 ), cUNLOAD_WIN_H ) ; // 670, 290
  
  setLocationRelativeTo ( frame );
  setVisible ( true );

 }

 public void actionPerformed ( java.awt.event.ActionEvent e ) {

  if ( e.getActionCommand ().equals ( "ButtonCancel" ) ) {
      setVisible ( false );
      return;
   }		

  if (e.getActionCommand().equals("SOnly")) {

      if (strOnlyButton.isSelected() || strDataButton.isSelected()) {

          checkOk = true;

          if (!tablesList.isSelectionEmpty())
              listOk = true;

          if (listOk && fileOk)
              ok.setEnabled(true);
       }
      else {
             checkOk = false;

             if (ok.isEnabled())
                 ok.setEnabled(false);
       }
   }

  if (e.getActionCommand().equals("COMBO")) {

      DBWinner = (String) combo1.getSelectedItem();

      int index = dbNames.indexOf(DBWinner);
      dbDump = (PGConnection) vecConn.elementAt(index);
      TableList = dbDump.TableQuery 
      ( "SELECT tablename FROM pg_tables where tablename !~ '^pg_' AND tablename  !~ '^pga_' ORDER BY tablename");
      
      String[] tables = new String[TableList.size()];
 
      for (int i=0;i<TableList.size();i++) {

           Vector o = (Vector) TableList.elementAt(i);
           String db = (String) o.elementAt(0);
           tables[i] = db;
       }

      tablesList.setListData(tables);

      if ((TableList.size() == 0) && ok.isEnabled())
           ok.setEnabled(false);
      
      return;
   }

 if (e.getActionCommand().equals("sALL")) {

     int[] indices = new int[ TableList.size() ];

     for ( int k = 0; k < TableList.size (); k++ ) indices [k] = k;

     tablesList.setSelectedIndices ( indices );
     listOk = true;

     if ( checkOk && fileOk ) ok.setEnabled ( true );

     return;
  }

 if (e.getActionCommand().equals("sNOE")) {

     if ( !( tablesList.isSelectionEmpty () ) ) {

         tablesList.clearSelection ();
         listOk = false;

         if ( ok.isEnabled () ) ok.setEnabled ( false );
      }

     return;
  }

 if ( e.getActionCommand ().equals ( "OPEN" )) {

     String s = "file:" + System.getProperty ( "user.home" );
     File file;
     boolean Rewrite = true;
     String FileName = "";

     JFileChooser fc = new JFileChooser ( s );
     ExtensionFilter filter = new ExtensionFilter ( "sql", idiom.getWord ( "SQLF" ) );
     fc.addChoosableFileFilter ( filter );    

     int returnVal = fc.showDialog(frame,idiom.getWord("EXPORTAB"));

     if ( returnVal == JFileChooser.APPROVE_OPTION ) {

         file = fc.getSelectedFile ();
         FileName = file.getAbsolutePath ();

         if ( file.exists() ) {

             GenericQuestionDialog win = new GenericQuestionDialog 
                          ( frame, idiom.getWord ( "YES" ), idiom.getWord ( "NO" ), idiom.getWord ( "ADV" ),
                            idiom.getWord ( "FILE" ) + " \"" + FileName + "\" " + idiom.getWord ( "SEQEXIS2" ) + 
                            " " + idiom.getWord ( "OVWR" ) 
             );
             Rewrite = win.getSelecction ();
          } 

         if ( Rewrite ) {

             textField2.setText ( FileName );
             fileOk = true;

             if ( !tablesList.isSelectionEmpty () ) listOk = true;
             if ( checkOk && listOk ) ok.setEnabled (true);
         }
       } 

    return;
  }

 if (e.getActionCommand().equals("OK")) {

     destiny = textField2.getText();    

     if (destiny.length()>0) {

         Object[] tables = tablesList.getSelectedValues();

         try {

              if (!destiny.endsWith(".sql"))
                  destiny += ".sql";

              if ((destiny.indexOf("/") == -1) && (destiny.indexOf("\\") == -1))
                   destiny = System.getProperty("user.home") + System.getProperty("file.separator") + destiny;

              PrintStream sqlFile = new PrintStream(new FileOutputStream(destiny)); 

              for (int k=0;k<tables.length;k++) {

                   String nameT = ( String ) tables [k];
                   tablesString += "'" + nameT + "'";

                   if ( k < ( tables.length -1 ) ) tablesString += ",";

                   // 2011-11-13 Nick
                   Table table = dbDump.getSpecStrucTable(nameT, "public");

                   if ( strOnlyButton.isSelected () ) {
                         String sql = BuildSQLStructure ( nameT, table );
                         sqlFile.print(sql);
                    }

                   if ( strDataButton.isSelected () ) {
                       TableHeader headT = table.base;
                       String sql = BuildSQLRecords ( nameT, headT );
                       sqlFile.print ( sql );
                    }

                   sqlFile.print("\n");
              }

             sqlFile.close(); 

            }
           catch(Exception ex)
             {
               System.out.println("Error: " + ex);
               ex.printStackTrace();
             }

           wellDone = true;
           setVisible ( false );

           return;
          }
        else
          {
            JOptionPane.showMessageDialog(DumpTable.this,idiom.getWord("DFINS"),idiom.getWord("ERROR!"),JOptionPane.ERROR_MESSAGE);
          }

        }

 }

String BuildSQLStructure(String tableName,Table table) {

   //Table table = dbDump.getSpecStrucTable(tableName);
   String sql = "CREATE TABLE " + tableName + " (\n";
   TableHeader headT = table.getTableHeader();
   int numFields = headT.getNumFields();

   for (int k=0;k<numFields;k++) {

        Object o = (String) headT.fields.elementAt(k);
        String field_name = o.toString();
        TableFieldRecord tmp = (TableFieldRecord) headT.getHashtable().get(field_name);
        sql += tmp.getName() + " ";

        String typeF = tmp.getType();

        if ("char".equals(typeF) || "varchar".equals(typeF)) {

            int longStr = tmp.getOptions().getCharLong();

            if (longStr>0)
                typeF = typeF + "(" + longStr + ")";
            //else
            //    typeF = tmp.Type;
         }

        sql += typeF + " ";

        Boolean tmpbool = new Boolean(tmp.getOptions().isNullField());

        if (tmpbool.booleanValue())
            sql += "NOT NULL ";

        String defaultV = tmp.getOptions().getDefaultValue();

        if (defaultV.endsWith("::bool")) {

            if (defaultV.indexOf("t")!=-1)
                defaultV = "true";
            else
                defaultV = "false";
         }

        if (defaultV.length()>0)
            sql += " DEFAULT " + defaultV;

        if (k < numFields-1)
            sql += ",\n";
   }

   sql += "\n);\n";
   
   return sql;
 } 

String BuildSQLRecords(String table,TableHeader headT) {

   Vector data = dbDump.TableQuery("SELECT * FROM " + table);
   Vector col = dbDump.getTableHeader();
   String sql = "";

   if (!dbDump.queryFail()) {

      for (int p=0;p<data.size();p++) {

           sql += "INSERT INTO " + table + " VALUES(";
           Vector tempo = (Vector) data.elementAt(p);
           int numCol = tempo.size();

           for (int j=0;j<numCol;j++) {

                String colName = (String) col.elementAt(j);
                String type = headT.getType(colName);
                Object o = tempo.elementAt(j);

                if (o != null) {

                    if (type.startsWith("varchar") || type.startsWith("char") || type.startsWith("text") 
                        || type.startsWith("name") || type.startsWith("date") || type.startsWith("time"))
                        sql += "'" + o.toString() + "'"; 
                    else {
                        sql += o.toString();
                     }
                 }
                else
                    sql += "NULL";

                if (j < (numCol - 1))
                   sql += ",";
            }

           sql += ");\n";
       }
     }

   return sql;
 }

public boolean isDone() {
  return wellDone;
 }

public String getDBName() {
  return DBWinner;
 }

public String getTables() {
  return tablesString;
 }

public String getFile() {
  return destiny;
 }

} //Fin de la Clase
