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
 *
 * CLASS Queries v 1.0
 * This class is responsible for handling the query eyelash includes 
 * performing query, save, export a results of query.        
 *          
 * History:  2012-11-11: Nick Chadaev - nick_ch58@list.ru, Russia.
 *           Start modification of the SQL-interpreter
 *           2013-06-30: Rebuild this package. Nick
 *                     
 * The God with us.          
 */
package ru.nick_ch.x1.queries;

import java.awt.BorderLayout;
import java.awt.CardLayout;
import java.awt.Color;
import java.awt.Component;
import java.awt.Cursor;
import java.awt.Dimension;
import java.awt.FlowLayout;
import java.awt.GridLayout;
import java.awt.Toolkit;
import java.awt.event.ActionListener;
import java.awt.event.FocusEvent;
import java.awt.event.FocusListener;
import java.awt.event.KeyEvent;
import java.awt.event.KeyListener;
import java.awt.event.MouseAdapter;
import java.awt.event.MouseEvent;
import java.awt.event.MouseListener;
import java.io.File;
import java.io.FileOutputStream;
import java.io.PrintStream;
import java.net.URL;
import java.util.Vector;

import javax.swing.BorderFactory;
import javax.swing.BoxLayout;
import javax.swing.ImageIcon;
import javax.swing.JButton;
import javax.swing.JDialog;
import javax.swing.JFileChooser;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JMenu;
import javax.swing.JMenuBar;
import javax.swing.JMenuItem;
import javax.swing.JOptionPane;
import javax.swing.JPanel;
import javax.swing.JPopupMenu;
import javax.swing.JRadioButton;
import javax.swing.JScrollPane;
import javax.swing.JSplitPane;
import javax.swing.JTable;
import javax.swing.JTextArea;
import javax.swing.JTextField;
import javax.swing.JToolBar;
import javax.swing.SwingConstants;
import javax.swing.SwingUtilities;
import javax.swing.border.BevelBorder;
import javax.swing.border.Border;
import javax.swing.border.TitledBorder;
import javax.swing.table.AbstractTableModel;

import ru.nick_ch.x1.db.PGConnection;
import ru.nick_ch.x1.idiom.Language;
import ru.nick_ch.x1.misc.file.ExtensionFilter;
import ru.nick_ch.x1.misc.input.ErrorDialog;
import ru.nick_ch.x1.misc.input.ExportSeparatorField;
import ru.nick_ch.x1.misc.input.GenericQuestionDialog;
import ru.nick_ch.x1.report.ReportDesigner;

public class Queries extends JPanel implements ActionListener, SwingConstants, FocusListener, KeyListener {

 JToolBar    QueryBar;
 JSplitPane  splitQueries;  //Panel redimensionable para consultas
 JMenuBar    menuQry;	
 JPanel      upBlock;
 JTextField  title;
 
 public JTextArea queryX;
 JTextArea LogWin;
 
 public JButton newQuery;
 public JButton runQuery;
 public JButton functions;
 public JButton loadQuery;
 public JButton hqQuery;
 public JButton saveQuery;
 
 JButton exportResult;
 
 final JPopupMenu popup = new JPopupMenu();
 final JPopupMenu popup1 = new JPopupMenu();
 
 JTable  table;
 JPanel  downComponent;
 JScrollPane  windowX;
 JRadioButton toFile,toReport;
 JButton      queryB,queryL,queryR,queryF;
 
 JTextField infoText;

 TitledBorder title1, title2;

 public PGConnection pgConn;
 Vector resultGlobal;
 Vector columnNamesG;
 
 Object[]   columnNames;
 Object[][] data;
 
 int    exportTo = -1;
 Color  currentColor;

 Vector columnGlobal = new Vector (); // Nick 20130707
 Vector dataGlobal   = new Vector (); // Nick 20130707

 String select = "";
 JFrame app;
 
 Language idiom;
 String  ghostText = "";
 boolean copy    = false;
 boolean control = false;
 
 SQLFunctionDataStruc[] funcList;
 SQLFuncBasic[] funcBasicSQL;
 
 JLabel queryRight,queryLeft;
 Vector queryBag = new Vector();
 
 int indexR = 0;
 int indexL = 0;

 int currentPage = 1;
 int nPages = 0;
 int indexMin = 1;
 int indexMax = 50;
 int start    = 0;
 int limit    = 50;
 int totalRec = 0;

 boolean localRequest = false;

 /**
  * The CONSTRUCTOR 
  *
  */
  public Queries ( JFrame frame, Language glossary, JTextArea monitor, SQLFunctionDataStruc[] fList, 
		          SQLFuncBasic[] fbasic) {

   app          = frame;
   idiom        = glossary;
   LogWin       = monitor;
   funcList     = fList;
   funcBasicSQL = fbasic;

   setLayout( new BorderLayout() );

   QueryBar = new JToolBar ( SwingConstants.VERTICAL );
   menuQry = new JMenuBar ();    
   CreateToolBar ();

   title = new JTextField ( idiom.getWord ("QUERYS" ) );  
   title.setHorizontalAlignment ( JTextField.CENTER ); 
   title.setEditable ( false );

   upBlock = new JPanel ();
   upBlock.setLayout ( new BorderLayout () );  

   JPanel auxBar = new JPanel();        // Panel donde va el toolbar de querys y el menu de funciones
   auxBar.setLayout ( new BorderLayout () );
   Border margin = BorderFactory.createBevelBorder ( BevelBorder.LOWERED );
   auxBar.setBorder ( margin );

   QueryBar.setFloatable ( false );
   JPanel Space = new JPanel ();
   Space.setLayout ( new FlowLayout () );
   Space.add ( QueryBar );

   auxBar.add(Space,BorderLayout.NORTH);
   exportResult = new JButton ( idiom.getWord ("OK") );
   exportResult.setActionCommand ( "ButtonExport" );
   exportResult.addActionListener ( this );
   exportResult.setEnabled ( false );
   
   JPanel tmp = new JPanel();
   tmp.setLayout ( new CardLayout () );

   toFile = new JRadioButton ( idiom.getWord ("FILE") );
   toFile.setMnemonic ( idiom.getNemo ( "NEMO-FILE" ) ); 
   toFile.setActionCommand ( "ExportToFile" );
   toFile.addActionListener ( this );

   toReport = new JRadioButton(idiom.getWord("REP"));
   toReport.setMnemonic(idiom.getNemo("NEMO-REP")); 
   toReport.setActionCommand("ExportToReport");
   toReport.addActionListener(this);

   JPanel tmp2 = new JPanel();
   tmp2.setLayout(new BoxLayout(tmp2, BoxLayout.Y_AXIS));

   tmp2.add(toFile);
   tmp2.add(toReport);

   tmp.add("Check1",exportResult); 

   JPanel altern = new JPanel();
   altern.setLayout(new BorderLayout());
   altern.add(tmp2,BorderLayout.CENTER);
   altern.add(tmp,BorderLayout.SOUTH);

   Border etched1 = BorderFactory.createEtchedBorder();
   title1 = BorderFactory.createTitledBorder(etched1,idiom.getWord("EXPTO"));
   currentColor = title1.getTitleColor();
   altern.setBorder(title1);

   auxBar.add(altern,BorderLayout.SOUTH);

   URL imgURLeft = getClass().getResource("/icons/queryLeft.png");
   queryLeft = new JLabel(new ImageIcon(Toolkit.getDefaultToolkit().getImage(imgURLeft)));
   queryLeft.setEnabled(false);
   queryLeft.setToolTipText(idiom.getWord("QHIST"));

   URL imgURight = getClass().getResource("/icons/queryRight.png");
   queryRight = new JLabel(new ImageIcon(Toolkit.getDefaultToolkit().getImage(imgURight)));
   queryRight.setEnabled(false);
   queryRight.setToolTipText(idiom.getWord("QHIST"));

   JPanel buttonsQ = new JPanel();
   buttonsQ.setLayout(new GridLayout(0,2));
   buttonsQ.add(queryLeft);
   buttonsQ.add(queryRight);

   MouseListener mouseListener = new MouseAdapter() {

       public void mousePressed(MouseEvent e) {

          if (queryLeft.isEnabled()) {

              if ( indexL==0 ) queryLeft.setEnabled ( false );

              String sql = (String) queryBag.elementAt ( indexL );

              if ( indexL !=0 ) indexL--;

              indexR = indexL + 1;

              if ( !newQuery.isEnabled () ) {

                  newQuery.setEnabled ( true );
                  saveQuery.setEnabled( true );
                  runQuery.setEnabled ( true );
               }

              queryX.setText ( sql );            

              if ( !queryRight.isEnabled () && (queryBag.size () > 1 ) && ( indexR < queryBag.size () ))
                   queryRight.setEnabled ( true );

           }
        }
     };

   MouseListener mouseListener2 = new MouseAdapter() {

       public void mousePressed(MouseEvent e) {

          if ( queryRight.isEnabled () ) {

              if (indexR == 1)
                  if (!queryLeft.isEnabled () ) queryLeft.setEnabled(true);

              String sql = (String) queryBag.elementAt(indexR);
              queryX.setText(sql);

              if ( saveQuery.isEnabled () ) {

                  saveQuery.setEnabled (true);
                  runQuery.setEnabled  (true);
               }

              if ( indexR == queryBag.size ()-1 ) queryRight.setEnabled ( false );

              indexL = indexR - 1;
              indexR++;
           }
        }
     };

   queryLeft.addMouseListener ( mouseListener );
   queryRight.addMouseListener ( mouseListener2 );

   JPanel frameButton = new JPanel();
   frameButton.add ( buttonsQ );

   upBlock.add ( frameButton, BorderLayout.WEST );
   upBlock.add ( title, BorderLayout.CENTER);

   JPanel northPanel = new JPanel ();
   northPanel.setLayout ( new BorderLayout () );
   northPanel.add ( upBlock );
   title1 = BorderFactory.createTitledBorder(etched1);
   northPanel.setBorder(title1);

   SplitQuery();
   add ( northPanel, BorderLayout.NORTH );
   add ( auxBar, BorderLayout.EAST );

   infoText = new JTextField("");
   infoText.setHorizontalAlignment ( JTextField.CENTER );
   infoText.setEditable ( false );

 }  // End of Constructor 

 /**
  * The method SplitQuery 
  * Making Split Consultation Panel 
  */
 public void SplitQuery () {

   queryX = new JTextArea ( "" );
   queryX.setEditable ( true );
   queryX.addFocusListener ( this ); 

   MouseListener mouseListener = new MouseAdapter() {

    public void mousePressed ( MouseEvent e ) {

       if (e.getClickCount() == 1 && SwingUtilities.isRightMouseButton(e)) {

           HotQueries hotQ = new HotQueries ( app, idiom, pgConn.getDBname ()); // Nick 2013_01_27

           if ( hotQ.isWellDone() ) loadSQL ( hotQ.getSQL(), hotQ.isReady () );
        }
       else {
              if (e.getClickCount() == 1 && !SwingUtilities.isLeftMouseButton (e) ) {

                  if (!newQuery.isEnabled()) {

                      newQuery.setEnabled ( true );
                      saveQuery.setEnabled( true );
                      runQuery.setEnabled ( true );
                   }
               } 
        }
      }
    };

   queryX.addMouseListener ( mouseListener );

   JScrollPane component = new JScrollPane ( queryX );
   splitQueries = new JSplitPane ( JSplitPane.VERTICAL_SPLIT );
   splitQueries.setTopComponent ( component );
   showQueryResult ( new Vector(), new Vector() );   

   splitQueries.setBottomComponent ( downComponent );
   splitQueries.setOneTouchExpandable ( true ); //el SplitPane muestra controles que permiten al 					   
   add ( splitQueries,BorderLayout.CENTER );

   splitQueries.setDividerLocation ( 160 ); //Selecciona u obtiene la posiciÛn actual del divisor. 
   splitQueries.setPreferredSize ( new Dimension ( 400, 200 ));
 } // The end of SplitQuery

 /**
  * The method CreateToolBar
  * Create the Icon Bar
  */
 public void CreateToolBar() {

  URL imgURL = getClass().getResource ( idiom.getWord ( "ICONNEW" ));
  newQuery = new JButton ( new ImageIcon ( Toolkit.getDefaultToolkit().getImage ( imgURL )) );
  newQuery.setActionCommand ( "ButtonNewQuery" );
  newQuery.addActionListener ( this );
  newQuery.setToolTipText ( idiom.getWord ( "NEWQ" ) + " [F2]");
  QueryBar.add ( newQuery );

  imgURL = getClass().getResource ( idiom.getWord ( "ICONFUNC" ) );
  functions = new JButton ( new ImageIcon ( Toolkit.getDefaultToolkit ().getImage ( imgURL )));
  functions.setToolTipText ( idiom.getWord ("FUNC") + " [F3]");

  JMenu menuSQL = new JMenu ( idiom.getWord ( "FSQL" ) ); 

  JMenu menuSQLBasic = new JMenu ( idiom.getWord ( "FNTR" ));
  JMenu menuCREATE = new JMenu ( "CREATE");
  JMenu menuALTER  = new JMenu ( "ALTER" );
  JMenu menuDROP   = new JMenu ( "DROP"  );

  String[] funcSQL = { "DELETE", "GRANT", "REVOKE", "SELECT", "UPDATE" };

  String[] componentSQL = { "AGGREGATE", "CONSTRAINT TRIGGER", "DATABASE", "FUNCTION", "GROUP", "INDEX", 
		                    "LANGUAGE",  "OPERATOR", "RULE", "SEQUENCE", "TABLE", "TABLE AS", "TRIGGER", 
		                    "TYPE", "USER", "VIEW" 
  };

  int[] indexALTER = { 4, 10, 14 }; 

  int countSKL = 0;

  for ( int m = 0; m < 3; m++ ) {

       JMenuItem Item = new JMenuItem ( componentSQL [indexALTER [m] ]);
       String action = "SKL" + countSKL;
       countSKL++;
       Item.setActionCommand (action);
       Item.addActionListener (this);
       menuALTER.add (Item);
  }

  menuSQLBasic.add ( menuALTER );

  for ( int m = 0; m < 16; m++ ) {

       JMenuItem Item = new JMenuItem(componentSQL[m]);
       String action = "SKL" + countSKL;
       countSKL++;
       Item.setActionCommand ( action );
       Item.addActionListener ( this );
       menuCREATE.add ( Item );
   }

  menuSQLBasic.add ( menuCREATE );

  JMenuItem ItemOut = new JMenuItem ( funcSQL[0] );
  String actionOut = "SKL" + countSKL;
  countSKL++;

  ItemOut.setActionCommand ( actionOut );
  ItemOut.addActionListener ( this );
  menuSQLBasic.add ( ItemOut );

  for ( int m = 0; m < 16; m++ ) {

       if (m != 1 && m != 11) {

           JMenuItem Item = new JMenuItem ( componentSQL [ m ] );
           String action = "SKL" + countSKL;
           countSKL++;
           Item.setActionCommand ( action );
           Item.addActionListener ( this );
           menuDROP.add ( Item );
        }
   }

  menuSQLBasic.add ( menuDROP );

  for (int m = 1; m < 5; m++ ) {

       JMenuItem Item = new JMenuItem ( funcSQL [m] );
       String action = "SKL" + countSKL;
       countSKL++;
       Item.setActionCommand ( action );
       Item.addActionListener ( this );
       menuSQLBasic.add ( Item );
   }

  int counter = 0;

  JMenu menuSQLAdv = new JMenu ( idiom.getWord ( "FSTR2" ));

  String[] funcSQLAdv = { "COALESCE", "NULLIF", "CASE" };

  for (int  m = 0; m < 3; m++ ) {

       JMenuItem Item = new JMenuItem ( funcSQLAdv [m] );
       String action = "POP" + counter;
       counter++;
       Item.setActionCommand ( action ) ;
       Item.addActionListener ( this );
       menuSQLAdv.add ( Item );
   }

  menuSQL.add ( menuSQLBasic );
  menuSQL.add ( menuSQLAdv );
  popup.add ( menuSQL );

  JMenu menuMath = new JMenu(idiom.getWord("FMATH"));

  JMenu menuNoTrans = new JMenu(idiom.getWord("FNTR")); 

  String[] funcNoTrans = {"ABS", "DEGREES","EXP","LN","LOG","PI","POW","RADIANS","ROUND","SQRT","CBRT","TRUNC",
		                  "FLOAT","FLOAT4","INTEGER"};

  for ( int m = 0; m < 15; m++ ) {

       JMenuItem Item = new JMenuItem ( funcNoTrans [m] );
       String action = "POP" + counter;
       counter++;
       Item.setActionCommand ( action );
       Item.addActionListener ( this );
       menuNoTrans.add ( Item );
   }

  JMenu menuTrans = new JMenu (idiom.getWord("FTR"));

  String[] funcTrans = {"ACOS","ASIN","ATAN","ATAN2","COS","COT","SIN","TAN"};

  for (int m=0;m<8;m++) {

       JMenuItem Item = new JMenuItem(funcTrans[m]);
       String action = "POP" + counter;
       counter++;
       Item.setActionCommand(action);
       Item.addActionListener(this);
       menuTrans.add(Item);
  }

  menuMath.add(menuNoTrans);
  menuMath.add(menuTrans);
  popup.add(menuMath);

  JMenu menuString = new JMenu(idiom.getWord("FSTR"));

  JMenu menu92 = new JMenu(idiom.getWord("FSTR1"));

  String[] funcStrings = { "CHAR_LENGTH", "CHARACTER_LENGTH", "LOWER", "OCTECT_LENGTH",
		                   "POSITION", "SUBSTRING", "TRIM", "UPPER"};

  for ( int m = 0; m < 8; m++ ) {

       JMenuItem Item = new JMenuItem(funcStrings[m]);
       String action = "POP" + counter;
       counter++;
       Item.setActionCommand(action);
       Item.addActionListener(this);
       menu92.add(Item);
   }

  JMenu menuOther = new JMenu ( idiom.getWord ( "FSTR2" ));

  String[] funcOthers = { "CHAR", "INITCAP", "LPAD", "LTRIM", "TEXTPOS", "RPAD", "RTRIM", "SUBSTR",
		                  "TEXT", "TRANSLATE", "VARCHAR" };

  for ( int m = 0; m < 11; m++ ) {

       JMenuItem Item = new JMenuItem ( funcOthers [m] );
       String action = "POP" + counter;
       counter++;
       Item.setActionCommand ( action );
       Item.addActionListener ( this );
       menuOther.add ( Item );
   }

  menuString.add(menu92);
  menuString.add(menuOther);
  popup.add(menuString);

  JMenu menuDate = new JMenu(idiom.getWord("FDATE"));

  String[] funcDate =  { "ABSTIME","AGE","DATE_PART","DATE_TRUNC","INTERVAL","ISFINITE","RELTIME",
		                 "TIMESTAMP","TO_CHAR"};

  for (int m = 0; m < 9; m++ ) {

       JMenuItem Item = new JMenuItem(funcDate[m]);
       String action = "POP" + counter;
       counter++;
       Item.setActionCommand(action);
       Item.addActionListener(this);
       menuDate.add(Item);
   }

  popup.add ( menuDate );

  JMenu menuFormat = new JMenu(idiom.getWord("FDATEF"));

  String[] funcFormat = {"TO_CHAR","TO_DATE","TO_TIMESTAMP","TO_NUMBER"};

  for ( int m = 0; m < 4; m++ ) {

       JMenuItem Item = new JMenuItem(funcFormat[m]);
       String action = "POP" + counter;
       counter++;
       Item.setActionCommand(action);
       Item.addActionListener (this);
       menuFormat.add (Item);
   }

  popup.add ( menuFormat );

  JMenu menuGeo = new JMenu (idiom.getWord ("FGEO") );

  JMenu menuBasic = new JMenu (idiom.getWord("FGEO1"));

  String[] funcBasic = {"AREA","BOX","CENTER","DIAMETER","HEIGHT","ISCLOSED","ISOPEN","LENGTH",
		                "PCLOSE","NPOINT","POPEN","RADIUS","WIDTH"};

  for ( int m = 0; m < 13; m++ ) {
 
       JMenuItem Item = new JMenuItem ( funcBasic[m] );
       String action = "POP" + counter;
       counter++;
       Item.setActionCommand(action);
       Item.addActionListener(this);
       menuBasic.add(Item);
   }

  JMenu menuTC = new JMenu(idiom.getWord("FGEO2"));

  String[] funcTC = {"BOX","CIRCLE","LSEG","PATH","POINT","POLYGON"};

  for (int m = 0; m < 6; m++ ) {

       JMenuItem Item = new JMenuItem(funcTC[m]);
       String action = "POP" + counter;
       counter++;
       Item.setActionCommand(action);
       Item.addActionListener(this);
       menuTC.add(Item);
   }

  JMenu menuUpgrade = new JMenu(idiom.getWord("FGEO3"));

  String[] funcUpgrade = {"ISOLDPATH","REVERTPOLY","UPGRADEPATH","UPGRADEPOLY"};

  for ( int m = 0; m < 4; m++ ) {

       JMenuItem Item = new JMenuItem(funcUpgrade[m]);
       String action = "POP" + counter;
       counter++;
       Item.setActionCommand (action);
       Item.addActionListener (this);
       menuUpgrade.add (Item);
  }

  menuGeo.add (menuBasic);
  menuGeo.add (menuTC);
  menuGeo.add (menuUpgrade);

  popup.add (menuGeo);

  JMenu menuIP = new JMenu(idiom.getWord("FIPV4"));

  String[] funcIP = {"BROADCAST","HOST","MASKLEN","NETMASK"};

  for ( int m = 0; m < 4; m++ ) {

       JMenuItem Item = new JMenuItem(funcIP[m]);
       String action = "POP" + counter;
       counter++;
       Item.setActionCommand(action);
       Item.addActionListener(this);
       menuIP.add(Item);
  }

  popup.add(menuIP);

  MouseListener mouseListener = new MouseAdapter() {

       public void mousePressed(MouseEvent e) {

          if (!popup.isVisible())
              popup.show(e.getComponent(),68,0);
        }
  };

  functions.addMouseListener ( mouseListener );
  QueryBar.add(functions);

  imgURL = getClass().getResource (idiom.getWord ( "ICONHQ" ) );
  hqQuery = new JButton ( new ImageIcon ( Toolkit.getDefaultToolkit().getImage(imgURL)));
  hqQuery.setActionCommand ("ButtonHQuery");
  hqQuery.addActionListener (this);
  hqQuery.setToolTipText (idiom.getWord("HQ") + " [F8]");
  QueryBar.add (hqQuery);

  imgURL = getClass().getResource(idiom.getWord("ICONOPEN"));
  loadQuery = new JButton(new ImageIcon(Toolkit.getDefaultToolkit().getImage(imgURL)));
  loadQuery.setActionCommand("ButtonLoadQuery");
  loadQuery.addActionListener(this);
  loadQuery.setToolTipText(idiom.getWord("OPENQ") + " [F4]");
  QueryBar.add(loadQuery);

  imgURL = getClass().getResource(idiom.getWord("ICONSAVE"));  
  saveQuery = new JButton(new ImageIcon(Toolkit.getDefaultToolkit().getImage(imgURL)));
  saveQuery.setActionCommand("ButtonSaveQuery");
  saveQuery.addActionListener(this);
  saveQuery.setToolTipText(idiom.getWord("SAVEQ") + " [F5]");
  QueryBar.add(saveQuery);
		
  imgURL = getClass().getResource( idiom.getWord ("ICONRUN"));
  runQuery = new JButton ( new ImageIcon(Toolkit.getDefaultToolkit().getImage(imgURL)));
  runQuery.setActionCommand ("ButtonRunQuery");
  runQuery.addActionListener (this);
  runQuery.setToolTipText (idiom.getWord("RUNQ") + " [F9]");
  QueryBar.add (runQuery);
 } // End of CreateToolBar		

/**
 *  The method setNullPanel 
 *  Disable all panels.
 */

 public void setNullPanel() {

  title.setText ( idiom.getWord ( "DSCNNTD" ));
  newQuery.setEnabled    ( false ); 
  hqQuery.setEnabled     ( false );
  functions.setEnabled   ( false );
  loadQuery.setEnabled   ( false );
  saveQuery.setEnabled   ( false );
  runQuery.setEnabled    ( false ); 
  exportResult.setEnabled( false );

  queryX.setText("");
  queryX.setEditable   (false);
  queryLeft.setEnabled (false);
  queryRight.setEnabled(false);
  showQueryResult ( new Vector(), new Vector ());
 } // End of setNullPanele4

 /**
  *  The method showQueryResult
  *  Show result of query
  */

 public void showQueryResult(Vector rowData,Vector columnNames) {

   columnGlobal = columnNames;
   dataGlobal = rowData;

   String[] colNames = new String[columnNames.size()];
   Object[][] rowD = new Object[rowData.size()][columnNames.size()];
   String title = "";

   if ( columnNames.size () > 0 ) {

       for ( int p = 0; p < columnNames.size (); p++ ) {

            Object o = columnNames.elementAt(p);
            colNames[p] = o.toString();
        }

       for ( int p = 0; p < rowData.size (); p++ ) {

            Vector tempo = (Vector) rowData.elementAt(p);

            for (int j = 0; j < columnNames.size(); j++ ) {
                 Object o = tempo.elementAt(j);
                 rowD[p][j] = o;
             }
        }

       String regTitle = idiom.getWord("RECS"); 

       if (rowData.size() == 1) regTitle = regTitle.substring(0,regTitle.length()-1);

       title = idiom.getWord("RES2") + " [" + totalRec + " " + regTitle + "]";
   }
   else 
     title = idiom.getWord("NORES");
	 
   MyTableModel myModel = new MyTableModel(rowD,colNames);
   table = new JTable(myModel);

   JLabel titleResult = new JLabel(title,JLabel.CENTER);

   JPanel upPan = new JPanel();
   upPan.setLayout(new BorderLayout());
   upPan.add(titleResult,BorderLayout.CENTER);

   if (title.equals(idiom.getWord("NORES")) || (totalRec == 0)) {

       titleResult.setEnabled ( false );
       title1.setTitleColor ( new Color ( 153, 153, 153 ));
       toFile.setSelected  ( false );
       toReport.setSelected( false );
       toFile.setEnabled   ( false );
       toReport.setEnabled ( false );

       downComponent = new JPanel();
       downComponent.setLayout(new BorderLayout());
       downComponent.add(upPan,BorderLayout.NORTH);

       windowX = new JScrollPane(table);
       downComponent.add(windowX,BorderLayout.CENTER);

       splitQueries.setBottomComponent(downComponent);
       splitQueries.setDividerLocation(135);

       updateUI();

       return;
    }
   else {
         title1.setTitleColor(currentColor);
         titleResult.setEnabled ( true);
         toFile.setEnabled   (true);
         toReport.setEnabled (true);
    }

   updateUI();           

   JButton buttonEmpty = new JButton(); 
   buttonEmpty.setPreferredSize(new Dimension (132,2)); 
   upPan.add(buttonEmpty,BorderLayout.SOUTH); 

   downComponent = new JPanel();
   downComponent.setLayout(new BorderLayout());
   downComponent.add(upPan,BorderLayout.NORTH);
   windowX = new JScrollPane(table); 
   downComponent.add(windowX,BorderLayout.CENTER);

   if ( totalRec > 50 ) downComponent.add(setControlPanel(),BorderLayout.SOUTH);

   splitQueries.setBottomComponent(downComponent);
   splitQueries.setDividerLocation(135);

  } // End of showQueryResult

 /**
  * The events processing
  */

 public void actionPerformed ( java.awt.event.ActionEvent e) {

 if (e.getActionCommand().equals("ExportToFile")) {

     if ( toFile.isSelected () ) {
         exportTo = 1;
         toReport.setSelected ( false );
         exportResult.setEnabled ( true );
      }
     else
         toReport.setSelected ( true );

   return;
 }

 if (e.getActionCommand().equals("ExportToReport")) {

     if (toReport.isSelected()) {
         exportTo = 2;
         toFile.setSelected(false);
         exportResult.setEnabled(true);
      }
     else 
         toFile.setSelected(true);

   return;
  }

 if (e.getActionCommand().equals("ButtonNewQuery") ) {

     NewQuery();
     return;
  }

 if (e.getActionCommand().equals("ButtonLoadQuery") ) {

     LoadQuery();
     return;
  }

 if (e.getActionCommand().equals("ButtonHQuery") ) {

     HotQueries hotQ = new HotQueries ( app, idiom, pgConn.getDBname() ); // Nick 2013_01_27

     if ( hotQ.isWellDone()) loadSQL(hotQ.getSQL(),hotQ.isReady());

     return;
  }
 
 if (e.getActionCommand().equals("ButtonSaveQuery") ) {

     SaveQuery();
     return;
 }

 if (e.getActionCommand().equals("ButtonRunQuery")) {

     RunQuery(queryX.getText());
     return;
  }

 if (e.getActionCommand().equals("ButtonExport")) {

    if (exportTo == 1) {

    ExportSeparatorField little = new ExportSeparatorField(app,idiom);

    if (little.isDone()) {

        String limiter = little.getLimiter();
          
        String s = "file:" + System.getProperty("user.dir");
        File file;
        boolean Rewrite = true;
        String FileName = "";
        JFileChooser fc = new JFileChooser(s);                 

        if (limiter.equals("csv")) {
            ExtensionFilter filter = new ExtensionFilter("csv",idiom.getWord("REPCSV")); 
            fc.addChoosableFileFilter(filter);
         }

        int returnVal = fc.showDialog(app,idiom.getWord("EXPTO"));

        if (returnVal == JFileChooser.APPROVE_OPTION) {

            file = fc.getSelectedFile();
            FileName = file.getAbsolutePath(); // Camino Absoluto

            if (file.exists()) {

               GenericQuestionDialog win = new GenericQuestionDialog (app, idiom.getWord("YES"),
            		                                 idiom.getWord("NO"),idiom.getWord("ADV"),
               idiom.getWord ("FILE") + " \"" + FileName + "\" " + idiom.getWord("SEQEXIS2") + " " + 
                             idiom.getWord ("OVWR") );
               Rewrite = win.getSelecction();
             } 

            if (Rewrite) {

               try {
                     if (limiter.equals("csv") && !FileName.endsWith(".csv"))
                         FileName += ".csv"; 

                     PrintStream exportFile = new PrintStream(new FileOutputStream(FileName));
          	     printFile(exportFile,resultGlobal,columnNamesG,limiter);
                }
               catch(Exception ex) 
                   {  
                     System.out.println("Error: " + ex);
                     ex.printStackTrace();
                   }
             }
              
          } 
          else {
                toFile.setSelected(false);
                exportTo = -1;
                exportResult.setEnabled(false);
           }
        }
       else {
             toFile.setSelected(false);
             exportTo = -1;
             exportResult.setEnabled(false);
        }
     }
    else {
           if (exportTo == 2) {

               dataGlobal = pgConn.TableQuery(select);

               ReportDesigner format = new ReportDesigner(app,columnGlobal,dataGlobal,idiom,LogWin,
                                                        getTablesN(select),pgConn);
               exportTo = -1;
               toReport.setSelected(false);
               exportResult.setEnabled(false);
            }
     }

     return;
    }

   if (e.getActionCommand().startsWith("POP")) {

       String number = e.getActionCommand().substring(3);
       int m = new Integer(number).intValue();

       setCursor(Cursor.getPredefinedCursor(Cursor.WAIT_CURSOR));
       String html = funcList[m].getHtml(); 
       SQLFunctionDisplay showHelp = new SQLFunctionDisplay(idiom,app,html);

       setCursor(Cursor.getPredefinedCursor(Cursor.DEFAULT_CURSOR));

       if ( showHelp.isUsed() ) {

           String text = queryX.getText();
           int lengthText = text.length();

           String funcName = showHelp.getFuncName();
           int pos = queryX.getCaretPosition();
           queryX.insert(funcName,pos);

           if ( lengthText < 1) newQuery.setEnabled(true);
        } 

       return;
    }

  if (e.getActionCommand().startsWith("SKL")) {

      String number = e.getActionCommand().substring(3);
      int m = new Integer(number).intValue();

      setCursor(Cursor.getPredefinedCursor(Cursor.WAIT_CURSOR));

      String html = funcBasicSQL[m].getHtml();
      // SQLFunctionDisplay showHelp = new SQLFunctionDisplay (idiom, app, html); // Nick 2009-07-14

      setCursor(Cursor.getPredefinedCursor(Cursor.DEFAULT_CURSOR));

      return;
   }

 } // End of actionPerformed. There are a lot of bugs. Nick 2013-06-30

/**
 *  Remove the Twin spaces, "\t", "\n" from string.
 *  Need to remove to utilities package.*
 *  */

 public static String clearSpaces (String inS) {

   String valid = "";

   if ((inS.indexOf("  ") != -1) || (inS.indexOf("\t") != -1) || (inS.indexOf("\n") != -1)) {

       int x = 0;

       while (x < inS.length() - 1) {

        char w = inS.charAt(x);

        if ( w == '\t'  && ( inS.charAt(x+1) != ' ') && ( inS.charAt(x+1) != '\t') && 
           ( inS.charAt(x+1) != '\n' ) && (x!=0) && ( inS.charAt(x+1) != ';') )
             valid = valid + " ";

	if ( w == '\t'  && (( inS.charAt(x+1) == ' ') || ( inS.charAt(x+1) == '\t') || 
			            ( inS.charAt(x+1) == '\n') || ( inS.charAt(x+1) == ';')))
	  valid = valid + "";

        if ( w == ' ' && ( inS.charAt(x+1) != ' ') && ( inS.charAt(x+1) != '\t') && 
        	   ( inS.charAt(x+1) != '\n') && (x!=0) && ( inS.charAt(x+1) != ';'))
          valid = valid + w;

	if ( w == ' '  && ( (x==0) || ( inS.charAt(x+1) == ' ') || ( inS.charAt(x+1) == '\t') || 
	   ( inS.charAt(x+1) != '\n') || ( inS.charAt(x+1) == ';')))
	  valid = valid + "";

	if ( w == '\n' && ( inS.charAt(x+1) != ' ') && ( inS.charAt(x+1) != '\t') && 
			          ( inS.charAt(x+1) != '\n' ) && ( inS.charAt(x+1) != ';'))
	  valid = valid + " ";

	if ( w == '\n' && (( inS.charAt(x+1) == ' ') || ( inS.charAt(x+1) == '\t') || 
			           ( inS.charAt(x+1) == '\n' ) || ( inS.charAt(x+1) == ';')))
	  valid = valid + "";

	if ( w != ' ' && w != '\t' && w != '\n')
	  valid = valid + w;

        x++;
      }

      char w = inS.charAt(inS.length()-1);

      if ((w != '\n') && (w != '\t') && (w != ' '))
          valid = valid + w;
     }
     else
       valid = inS;

    while (valid.startsWith(" "))
           valid = valid.substring(1,valid.length());

    while (valid.endsWith(" "))
           valid = valid.substring(0,valid.length()-1);
				       
    return valid; 
 } // End of clearSpaces

 /**
  * @author Nick (30.06.2013) 
  * @param mxg 
  *  Set text 
  */
 public void setTextLabel(String mxg) {

    popup.setEnabled(false);
    title.setText(mxg);
  } // setTextLabel

 /**
  *  Set label
  */

 public void setLabel(String dbName,String owner) {

   popup.setEnabled(true);
   String mesg = "";

   //if (dbName.length()>0) {
       owner = "  [ " + idiom.getWord("OWNER") + ": " + owner + " ]";
       mesg = idiom.getWord("QUERYS") + idiom.getWord("IN") + idiom.getWord("DB: "); 
   /* }
   else
       mesg = idiom.getWord("QUERYS");*/

   title.setText(mesg + dbName + owner);
  } // End of setLabel

 public void focusGained(FocusEvent e) {

    Component tmp = e.getComponent();
    tmp.addKeyListener(this);
  }

 public void focusLost(FocusEvent e) {

    Component tmp = e.getComponent();
    tmp.removeKeyListener(this);
  } 

 public void keyTyped(KeyEvent e) {
  }   

 /**
  * Key Pressing process.
  * 
  * @author Nick (30.06.2013)
  * 
  * @param e 
  */
 public void keyPressed(KeyEvent e) {

   String queryString = queryX.getText();

   int keyC = e.getKeyCode();
   String keyS = KeyEvent.getKeyText(keyC);

   if (keyS.equals("F2")) {

       if (newQuery.isEnabled()) {
           NewQuery();
        }

       return;
    }

   if (keyS.equals("F3")) {

       if (functions.isEnabled()) {

           if (!popup.isVisible())
               popup.show(functions,63,0);
        }
    }

   if (keyS.equals("F4")) {

       if (loadQuery.isEnabled()) {
           LoadQuery();
        }

       return;
    }

   if (keyS.equals("F5")) {

     if (saveQuery.isEnabled()) {
         SaveQuery();
      }

     return;
    }

   if (keyS.equals("F8")) {

       HotQueries hotQ = new HotQueries ( app, idiom, pgConn.getDBname()); // Nick 2012_01_27

       if (hotQ.isWellDone())
           loadSQL(hotQ.getSQL(),hotQ.isReady());

       return;
    }

   if (keyS.equals("F9")) {

       if (runQuery.isEnabled()) {
           RunQuery(queryString);
        }

       return;
    }
  
   int width = queryString.length(); 

   if (width > 15) {
       newQuery.setEnabled(true);
       saveQuery.setEnabled(true);
       runQuery.setEnabled(true);
    } 
   else {
         saveQuery.setEnabled(false);
         runQuery.setEnabled(false);

         if ( width > 0 ) newQuery.setEnabled ( true );
         else newQuery.setEnabled (false); 
    } 

  } // End of keyPressed

 public void keyReleased(KeyEvent e) {
  } 
 /**
  * The Internal Class
  * 
  * @author Nick (30.06.2013)
  */
 class MyTableModel extends AbstractTableModel {


  public MyTableModel(Object[][] xdata,String[] colN) {

    data = xdata;
    columnNames = colN;
   }
	     
  public String getColumnName(int col) {
    return columnNames[col].toString(); 
   }

  public int getRowCount() {
    return data.length; 
   }

  public int getColumnCount() {
    return columnNames.length; 
   }

  public Object getValueAt(int row, int col) {
    return data[row][col]; 
   }

  public boolean isCellEditable(int row, int col) {
    return false; 
   }

  public void setValueAt(Object value, int row, int col) {

    data[row][col] = value;
    fireTableCellUpdated(row, col);
   }

 } // fin clase MyTableModel

/**
 * Print the resultset of query
 * 
 * @author Nick (30.06.2013)
 * 
 * @param xfile 
 * @param registers 
 * @param FieldNames 
 * @param Separator 
 */
public void printFile ( PrintStream xfile,Vector registers,Vector FieldNames,String Separator ) {

   String limit = "";
   boolean isCSV = false; 

   try {

        int TableWidth = FieldNames.size();

        if (Separator.equals("csv")) {

            limit = ",";
            isCSV = true;
         }
        else {

               limit = Separator;

               for ( int p = 0; p < TableWidth; p++ ) {

                    String column = (String) FieldNames.elementAt(p);
                    xfile.print(column);

                    if ( p < TableWidth - 1 ) xfile.print(limit);
                }

               xfile.print("\n");
         }

        for (int p = 0; p < registers.size (); p++ ) {

             Vector rData = (Vector) registers.elementAt(p); 

             for (int i=0;i<TableWidth;i++) {

                  Object o = rData.elementAt(i);
                  String field = o.toString();

                  if (isCSV)
	              xfile.print("\"" + field + "\"");
                  else
                      xfile.print(field);

                  if (i<TableWidth-1)
                      xfile.print(limit);
              }

             xfile.print("\n");
         }

       }
       catch(Exception e) 
        { 
        }
 } // End of printFile

 /**
  * Save the rext of query.
  * Only one query, it ends by ";" 
  *  
  * @author Nick (30.06.2013)
  * 
  * @param saveFile 
  * @param instructions 
  */
 public void QuerySaver ( PrintStream saveFile,String instructions ) {

   instructions = clearSpaces(instructions); 
   int k=0;
   int i=0;
   String oneQ = "";

   while (k != -1) {

          k = instructions.indexOf(";",i);	

          if (k!=-1) {

              oneQ = instructions.substring(i,k+1);
              i = k + 1;
              oneQ = oneQ.trim();
           }
          else
              oneQ = instructions.substring(i,instructions.length());

          saveFile.println(oneQ);
    }

   try {
         saveFile.close();
    }
   catch(Exception ex) {
    }
  } // End of QuerySaver

 /**
  * the addTextLogMonitor
  * Print messages in the Event Monitor window
  */
 public void addTextLogMonitor(String msg) {

  LogWin.append(msg + "\n");	
  int longiT = LogWin.getDocument().getLength();

  if (longiT > 0)
      LogWin.setCaretPosition(longiT - 1);
 } // End of addTextLogMonitor	

 /**
  *  Run the qeury
  * 
  * @author Nick (30.06.2013)
  * 
  * @param querys 
  */
 public void RunQuery (String querys) {

    setCursor(Cursor.getPredefinedCursor(Cursor.WAIT_CURSOR));

    String proofStr = clearSpaces(querys);
    int j;
    Vector oneI = new Vector();

    if (proofStr.endsWith(";")) {

       j = 0;
       int k = 0;

       while(true) {

             k = proofStr.indexOf(";",j);

             if ( k == -1 )
                  break;

             oneI.addElement ( proofStr.substring ( j, k+1 ));			     
             j = k + 1;
        } 
     }
    else {
           JOptionPane.showMessageDialog(Queries.this,                               
        		   idiom.getWord("IVIC"),                       
           idiom.getWord("ERROR!"),JOptionPane.ERROR_MESSAGE);               
     }

    boolean noMore = false;
    int numSelect = 0;

    for (int i=0; i < oneI.size(); i++) {

         Object o = oneI.elementAt(i);
         String sentence = o.toString().trim();
         String val = "OK";
         String queryLow = sentence.toLowerCase();

         if (sentence.equals(";")) 
             continue;

         sentence = sentence.substring(0,sentence.length()-1);

         if (queryLow.startsWith("select")) {

             totalRec = Count(pgConn,sentence);

             String sql = sentence;

             if (totalRec > 50) {

                 currentPage = indexMin = 1;
                 limit = indexMax = 50;
                 start = 0;

                 sql = "SELECT * FROM (" + sql + ") AS foo LIMIT 50 OFFSET 0";
              }

             resultGlobal = pgConn.TableQuery(sql);

             if (pgConn.queryFail()) {
                 val = pgConn.getProblemString();
                 val = val.substring(0,val.length()-1);
              }
          }
         else {
                String result = pgConn.SQL_Instruction(sentence);

                if (!result.equals("OK")) 
                    result = result.substring(0,result.length()-1);

                val = result;
          }

         addTextLogMonitor(idiom.getWord("EXEC") + sentence + ";\"");
         addTextLogMonitor(idiom.getWord("RES") + val);

         if (queryLow.startsWith("select")) {

             numSelect++;

	        if ( !noMore ) {

                 select = sentence;
                 columnNamesG = pgConn.getTableHeader ();
                 showQueryResult (resultGlobal, columnNamesG );
	             noMore = true;
	        }
          }

     } // fin for

    if ( numSelect > 1 ) {

        JOptionPane.showMessageDialog(Queries.this,
        idiom.getWord("SSQ"),
        idiom.getWord("INFO"),JOptionPane.INFORMATION_MESSAGE);
     }

    setCursor(Cursor.getPredefinedCursor(Cursor.DEFAULT_CURSOR));

  } // End of RunQuery

/**
 * New query
 * 
 * @author Nick (30.06.2013)
 */
public void NewQuery() {

     queryRight.setEnabled(false);
     String sql = queryX.getText();

     if (sql.length()>0) {

         String tmp = "";

         if (!queryBag.isEmpty())
             tmp = (String) queryBag.elementAt(queryBag.size()-1);

         if (!sql.equals(tmp)) {

             queryBag.addElement(sql);
             indexL = queryBag.size() - 1;
             indexR = indexL;
          }
      }

     queryX.setText("");
     exportResult.setEnabled(false);
     showQueryResult(new Vector(),new Vector());
     newQuery.setEnabled(false);
     saveQuery.setEnabled(false);
     runQuery.setEnabled(false);

     if (!queryLeft.isEnabled())
         queryLeft.setEnabled(true);

     queryX.requestFocus();
  }  // End of NewQuery

/**
 * Load query from user dir
 * 
 * @author Nick (30.06.2013)
 */
public void LoadQuery() {

   String xt = "file:" + System.getProperty("user.dir");
   JFileChooser fc = new JFileChooser(xt);
   int returnVal = fc.showOpenDialog(app);
   String s = "file:" + System.getProperty("user.dir") + System.getProperty("file.separator");

   if (returnVal == JFileChooser.APPROVE_OPTION) {

       File file = fc.getSelectedFile();
       SQLCompiler analitic = new SQLCompiler(file);
       Vector QueryText = analitic.getInstructions();
       queryX.setText("");

       for (int m=0;m<QueryText.size();m++) {

            String tmpQ = "";

            if (m == QueryText.size()-1)
                tmpQ = (String) QueryText.elementAt(m);
            else
                tmpQ = (String) QueryText.elementAt(m) + "\n";

            int newpos = 0;
            int k = 1;
            queryX.append(tmpQ);
        }

       newQuery.setEnabled(true);
       saveQuery.setEnabled(true);
       runQuery.setEnabled(true);
    }
 } // End of LoadQuery

 /**
  * Save query to user dir
  * 
  * @author Nick (30.06.2013)
  */
 public void SaveQuery() {

    String instructions =  new String (queryX.getText());
    String s = "file:" + System.getProperty("user.dir");
    File file;
    boolean Rewrite = true;
    String FileName = "";

    JFileChooser fc = new JFileChooser(s);
    ExtensionFilter filter = new ExtensionFilter("sql",idiom.getWord("SQLF"));
    fc.addChoosableFileFilter(filter);

    int returnVal = fc.showDialog(app,idiom.getWord("SAVEQ"));

    if (returnVal == JFileChooser.APPROVE_OPTION) {

        file = fc.getSelectedFile();
        FileName = file.getAbsolutePath(); // Camino Absoluto

        if (file.exists()) {

            GenericQuestionDialog win = new GenericQuestionDialog ( app, idiom.getWord("YES"), 
            		                         idiom.getWord ("NO"),idiom.getWord("ADV"),
                                             idiom.getWord ("FILE") + " \"" + FileName + "\" " + 
                                             idiom.getWord ("SEQEXIS2") + " " + idiom.getWord("OVWR")
            );
            Rewrite = win.getSelecction();
         }

        if (Rewrite) {

            try {
                 if (!FileName.endsWith(".sql"))
                     FileName += ".sql";

                 PrintStream saveFile = new PrintStream(new FileOutputStream(FileName));
                 QuerySaver(saveFile,instructions);
             }
            catch(Exception ex) { }

         } // fin if

      } // fin if 
  } // SaveQuery

/**
 * ????????????????
 * 
 * @author Nick (30.06.2013)
 * 
 * @param sqlSel 
 * 
 * @return String 
 */
public String getTablesN ( String sqlSel ) {

     String tmp = sqlSel.substring(6);
     tmp = tmp.toLowerCase();

     if (tmp.indexOf("select") == -1) {

         int p = tmp.indexOf("from");
         int k = tmp.indexOf("where");

         if (k != -1)
             tmp = tmp.substring(p+5,k);
         else
             tmp = tmp.substring(p+5,tmp.length()-1);
      }

     tmp = tmp.trim();
     return tmp;
  } // End of getTablesN

/**
 * Set buttons visible params
 * 
 * @author Nick (30.06.2013)
 */
public void setButtons() {

   newQuery.setEnabled(false);
   functions.setEnabled(true);
   loadQuery.setEnabled(true);
   saveQuery.setEnabled(false);
   runQuery.setEnabled(false);
   queryX.setEditable(true);
  } // End of setButtons 

/**
 * Load query and rut it ( if need )
 * 
 * @author Nick (30.06.2013)
 * 
 * @param sql 
 * @param run 
 */
public void loadSQL ( String sql, boolean run ) {

   queryX.setText(sql);
   newQuery.setEnabled(true);
   saveQuery.setEnabled(true);
   runQuery.setEnabled(true);

   if (run)
       RunQuery(queryX.getText());
   else
       showQueryResult(new Vector(),new Vector());
  } // End of loadSQL


/**
 * Get text of query
 * 
 * @author Nick (30.06.2013)
 * @return String 
 */
public String getStringQuery () {
   return queryX.getText();
  } // getStringQuery

/**
 * Set editable parametr
 * 
 * @author Nick (30.06.2013)
 */
public void setTextAreaEditable () {

   if (!queryX.isEditable())
       queryX.setEditable(true);
  } // End of setTextAreaEditable

/**
 * Count rows of resultset.
 * (REMOVE IT FROM CLASS)
 * @author Nick (30.06.2013)
 * 
 * @param konn 
 * @param sql 
 * 
 * @return int 
 */
public int Count ( PGConnection konn, String sql ) {

   int val = -1;

   String counting = "SELECT count(*) FROM (" + sql + ") AS foo;";

   String answer = "OK";
   addTextLogMonitor(idiom.getWord("EXEC")+ counting + "\"");
   Vector result = new Vector();
   result = konn.TableQuery(counting);

   if (konn.queryFail()) {

       answer = konn.getProblemString().substring(0,konn.getProblemString().length()-1);
       addTextLogMonitor(idiom.getWord("RES") + answer);

       ErrorDialog showError = new ErrorDialog(new JDialog(),konn.getErrorMessage(),idiom);
       showError.pack();
       showError.setLocationRelativeTo(app);
       showError.show();
    }
   else {
          Vector value = (Vector) result.elementAt(0);

          try {
                Long entero = (Long) value.elementAt(0);
                val = entero.intValue();
           }
          catch(Exception ex){
                Integer entero = (Integer) value.elementAt(0);
                val = entero.intValue();
           }

          addTextLogMonitor(idiom.getWord("RES") + val + " " + idiom.getWord("RECS"));
    }

   return val;
  } // End of Count

/**
 * Get number of pages
 * 
 * @authorNick (30.06.2013)
 * 
 * @param rIM 
 * 
 * @return int 
 */
public int getPagesNumber ( int rIM ) {

    double fl = ((double)rIM)/50;
    String div = "" + fl;

    int nP = rIM/50;

    if ( div.indexOf (".") != -1 ) {
        String str = div.substring(div.indexOf(".")+1,div.length());
        if (!str.equals("0"))
             nP++;
     }
  return nP;
} // End of getPagesNumber

/**
 *  Set control panel. It neew for browsing of result set.
 * 
 * @author Lenovo (30.06.2013)
 * 
 * @return JPanel 
 */
public JPanel setControlPanel() {

       JPanel controls = new JPanel();
       controls.setLayout(new BorderLayout());

       nPages = getPagesNumber(totalRec);

       JPanel labelPanel = new JPanel();
       labelPanel.setLayout(new FlowLayout());
       labelPanel.add(infoText);

       URL imgURB = getClass().getResource("/icons/backup.png");
       queryB = new JButton(new ImageIcon(Toolkit.getDefaultToolkit().getImage(imgURB)));
       queryB.setToolTipText(idiom.getWord("FSET"));

       URL imgURLeft = getClass().getResource("/icons/queryLeft.png");
       queryL = new JButton(new ImageIcon(Toolkit.getDefaultToolkit().getImage(imgURLeft)));
       queryL.setToolTipText(idiom.getWord("PSET"));

       URL imgURRight = getClass().getResource("/icons/queryRight.png");
       queryR = new JButton(new ImageIcon(Toolkit.getDefaultToolkit().getImage(imgURRight)));
       queryR.setToolTipText(idiom.getWord("NSET"));

       URL imgURF = getClass().getResource("/icons/forward.png");
       queryF = new JButton(new ImageIcon(Toolkit.getDefaultToolkit().getImage(imgURF)));
       queryF.setToolTipText(idiom.getWord("LSET"));

       MouseListener mouseLB = new MouseAdapter() {

         public void mousePressed ( MouseEvent e ) {

           if ( queryB.isEnabled () ) {

               start = 0;
               limit = 50;
               currentPage = 1;

               indexMin = 1;
               indexMax = 50;

               String sql = "SELECT * FROM (" + select + ") AS foo LIMIT 50 OFFSET 0";

               Vector res = pgConn.TableQuery(sql);
               Vector col = pgConn.getTableHeader();

               addTextLogMonitor(idiom.getWord("EXEC")+ sql + ";\"");

               if (!pgConn.queryFail()) {

                   addTextLogMonitor(idiom.getWord("RES") + "OK");
                   showQueryResult(res,col);
                   updateUI();
                }
            }
         }
       };

       queryB.addMouseListener ( mouseLB );

       MouseListener mouseLQL = new MouseAdapter() {

       public void mousePressed(MouseEvent e) {

          if ( queryL.isEnabled() ) {

              currentPage--;

              if ( currentPage == 1 ) {

                  indexMin = 1;
                  indexMax = 50;
               }
              else {
                    if ( currentPage == nPages - 1)
                         indexMax = indexMin - 1;
                    else
                        indexMax -= 50;

                    indexMin -= 50;
               }

              start = indexMin - 1;
              limit = 50;

              String sql = "SELECT * FROM (" + select + ") AS foo LIMIT 50 OFFSET " + start;

              Vector res = pgConn.TableQuery ( sql );
              Vector col = pgConn.getTableHeader();

              addTextLogMonitor ( idiom.getWord ("EXEC")+ sql + ";\"");

              if (!pgConn.queryFail()) {

                  addTextLogMonitor(idiom.getWord("RES") + "OK");
                  showQueryResult(res,col);
                  updateUI();
               }
            }
         }
       };

       queryL.addMouseListener(mouseLQL);

       MouseListener mouseLQR = new MouseAdapter() {

        public void mousePressed(MouseEvent e) {

          if (queryR.isEnabled()) {

              localRequest = true;

              currentPage++;
              start = indexMax;

              int downLimit = 1;

              if (currentPage == nPages) {
                  indexMax = totalRec;
                  downLimit = (nPages-1) * 50 + 1;
               }

              int diff = (indexMax - downLimit) + 1;

              if (diff > 50)
                  diff = 50;

              limit = diff;

              String sql = "SELECT * FROM (" + select + ") AS foo LIMIT " + diff + " OFFSET " + start;

              Vector res = pgConn.TableQuery(sql);
              Vector col = pgConn.getTableHeader();

              addTextLogMonitor(idiom.getWord("EXEC")+ sql + ";\"");

              indexMin += 50;

              if (currentPage < nPages)
                  indexMax += 50;

              if (!pgConn.queryFail()) {

                  addTextLogMonitor(idiom.getWord("RES") + "OK");
                  showQueryResult(res,col);
                  updateUI();
               }
            }
          }
        };

        queryR.addMouseListener(mouseLQR);

        MouseListener mouseLF = new MouseAdapter() {

         public void mousePressed ( MouseEvent e ) {

          if ( queryF.isEnabled() ) {

              localRequest = true;

              currentPage = nPages;

              indexMin = ((nPages-1) * 50);
              indexMax = totalRec;
              start = indexMin;
              limit = totalRec - start;

              indexMin++;

              String sql = "SELECT * FROM (" + select + ") AS foo LIMIT " + limit + " OFFSET " + start;

              Vector res = pgConn.TableQuery(sql);
              Vector col = pgConn.getTableHeader();

              addTextLogMonitor(idiom.getWord("EXEC")+ sql + ";\"");

              if (!pgConn.queryFail()) {

                  addTextLogMonitor(idiom.getWord("RES") + "OK");
                  showQueryResult(res,col);
                  updateUI();
               }
            }
          }
        };

        queryF.addMouseListener(mouseLF);

        JPanel buttonsPanel = new JPanel();
        buttonsPanel.setLayout ( new FlowLayout());

        buttonsPanel.add(queryB);
        buttonsPanel.add(new JPanel());
        buttonsPanel.add(queryL);
        buttonsPanel.add(new JPanel());
        buttonsPanel.add(queryR);
        buttonsPanel.add(new JPanel());
        buttonsPanel.add(queryF);
        buttonsPanel.add(new JPanel());

        controls.add(labelPanel,BorderLayout.CENTER);
        controls.add(buttonsPanel,BorderLayout.SOUTH);

        infoText.setText(" " + idiom.getWord("PAGE") + " " + currentPage + " " + idiom.getWord("OF")
                         + " " + nPages + " [ " + idiom.getWord("RECS")
                         + " " + idiom.getWord("FROM") + " " + indexMin + " " + idiom.getWord("TO")
                         + " " + indexMax + " ] ");

        if ( currentPage == nPages ) {

             if (queryR.isEnabled()) {

                 queryR.setEnabled(false);
                 queryF.setEnabled(false);
             }
         }

        if ( currentPage > 1) {

                  if (!queryL.isEnabled()) {

                      queryL.setEnabled(true);
                      queryB.setEnabled(true);
                   }
         }         
        else {

              if (!queryR.isEnabled()) {
                 queryR.setEnabled(true);
                 queryF.setEnabled(true);
               }

              if (queryL.isEnabled()) {

                  queryL.setEnabled(false);
                  queryB.setEnabled(false);
               }
         }

        return controls;
 }  // End of setControlPanel
} //Fin de la Clase
