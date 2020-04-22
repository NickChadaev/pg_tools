/**
 * This software is free according GNU GENERAL PUBLIC LICENSE and
 * based on the XPg project, developed by KAZAK Solutions. 
 * Research and Development Group of Free Software, 
 * Santiago de Cali Republic of Colombia 2001.
 * Author:
 *          Gustavo Gonz,ez <xtingray@kazak.com.co>.                   
 * ----------------------------------------------------------------------------
 * Now this software is developing for modern version of PostgreSQL.
 * Author: 
 *          Nick Chadaev <nick_ch58@list.ru>. Moscow, Russia. Single developer.
 *          New stage of developing had been started at 2009-06-16. 
 * ----------------------------------------------------------------------------
 *  CLASS X1 @version 2.0                                                   
 *            The main class of graphical tool for PostgreSQL.
 * ----------------------------------------------------------------------------          
 * History:  2009-06-16: Nick Chadaev - nick_ch58@list.ru, Russia.
 *          I have to add two new function: batch load processor,
 *          and XML-descriptors for some tables of database with    
 *          repository of XML-descriptors. By the way, SQL-interpreter
 *          of XPg had lot of bugs. 
 *          
 *          The God with us.
 *          
 *          2011-09-25 Start of new modification. Nick
 *          2012-06-29 The killing of Sql_main is going on. Nick
 *          2012-11-11 Forward to QUERIES
 *          2013-06-08 New structure of packages: ru.nick_ch.x1
 */
package ru.nick_ch.x1.main;

import java.awt.BorderLayout;
import java.awt.Color;
import java.awt.Component;
import java.awt.Cursor;
import java.awt.Dimension;
import java.awt.Font;
// import java.awt.Frame;
import java.awt.Toolkit;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.event.FocusEvent;
import java.awt.event.FocusListener;
import java.awt.event.KeyEvent;
import java.awt.event.KeyListener;
import java.awt.event.MouseEvent;
import java.awt.event.MouseListener;
import java.awt.event.WindowAdapter;
import java.awt.event.WindowEvent;
import java.awt.event.WindowListener;
import java.io.File;
import java.io.FileOutputStream;
import java.io.PrintStream;
import java.net.URL;
//import java.util.Calendar;
import java.util.Vector;
import java.util.Hashtable;

import javax.swing.DefaultCellEditor;
import javax.swing.ImageIcon;
import javax.swing.JButton;
import javax.swing.JDialog;
import javax.swing.JFileChooser;
import javax.swing.JFrame;
// import javax.swing.JLabel;
import javax.swing.JMenu;
import javax.swing.JMenuBar;
import javax.swing.JMenuItem;
import javax.swing.JOptionPane;
import javax.swing.JPanel;
import javax.swing.JPopupMenu;
import javax.swing.JScrollPane;
import javax.swing.JSplitPane;
import javax.swing.JTabbedPane;
import javax.swing.JTextArea;
import javax.swing.JTextField;
import javax.swing.JToolBar;
import javax.swing.JTree;
// import javax.swing.JWindow;
import javax.swing.SwingConstants;
import javax.swing.SwingUtilities;
import javax.swing.event.ChangeEvent;
import javax.swing.event.ChangeListener;
import javax.swing.tree.DefaultMutableTreeNode;
import javax.swing.tree.DefaultTreeCellRenderer;
import javax.swing.tree.DefaultTreeModel;
import javax.swing.tree.MutableTreeNode;
import javax.swing.tree.TreePath;
import javax.swing.tree.TreeSelectionModel;

import ru.nick_ch.x1.db.ConnectionInfo;
import ru.nick_ch.x1.db.PGConnection;
import ru.nick_ch.x1.db.Table;
//import ru.nick_ch.x1.db.TableFieldRecord;
import ru.nick_ch.x1.db.TableHeader;
import ru.nick_ch.x1.idiom.Language;
import ru.nick_ch.x1.menu.AlterGroup;
import ru.nick_ch.x1.menu.AlterUser;
import ru.nick_ch.x1.menu.CreateDB;
import ru.nick_ch.x1.menu.CreateGroup;
import ru.nick_ch.x1.menu.CreateTable;
import ru.nick_ch.x1.menu.CreateUser;
import ru.nick_ch.x1.menu.DropDB;
import ru.nick_ch.x1.menu.DropGroup;
import ru.nick_ch.x1.menu.DropTable;
import ru.nick_ch.x1.menu.DropUser;
import ru.nick_ch.x1.menu.DumpDb;
import ru.nick_ch.x1.menu.DumpTable;
import ru.nick_ch.x1.menu.TablesGrant;
import ru.nick_ch.x1.misc.file.BuildConfigFile;
import ru.nick_ch.x1.misc.file.ConfigFileReader;
import ru.nick_ch.x1.misc.file.ExtensionFilter;
import ru.nick_ch.x1.misc.help.About;
import ru.nick_ch.x1.misc.input.ChooseIdiom;
import ru.nick_ch.x1.misc.input.ChooseIdiomButton;
import ru.nick_ch.x1.misc.input.ErrorDialog;
import ru.nick_ch.x1.misc.input.ExportSeparatorField;
import ru.nick_ch.x1.misc.input.GenericQuestionDialog;
import ru.nick_ch.x1.misc.input.PrintOuput;
import ru.nick_ch.x1.misc.input.UpdateDBTree;

// import ru.nick_ch.x1.queries.HotQueries;
// import ru.nick_ch.x1.queries.Queries;
// import ru.nick_ch.x1.queries.SQLFuncBasic;
// import ru.nick_ch.x1.queries.SQLFunctionDataStruc;
import ru.nick_ch.x1.queries.*;

import ru.nick_ch.x1.records.Records;
import ru.nick_ch.x1.report.ReportDesigner;
import ru.nick_ch.x1.structure.Structures;
import ru.nick_ch.x1.utilities.*;  // Add Path,  Nick 2009-12-09

import ru.nick_ch.x1.menu.Sql_menu;         // Nick 2012-07-02
import ru.nick_ch.x1.misc.file.File_consts; // Nick 2009-11-22

public class X1 extends JFrame implements ActionListener, SwingConstants, FocusListener, KeyListener, 
                                          MouseListener, Sql_menu, File_consts, Sz_visuals {

 JFrame     program; 
 JMenuBar   menuX;     //Barra de menus desplegables 
 JToolBar   iconBar;   //Barra de iconos
 JPanel     Global;	   //Panel de contenido
 JSplitPane Ppal;      //Panel redimensionable grande entre el monitor de logs y la interfaz 
 JTextArea  LogWin;    //Monitor de Eventos 
 
 DefaultTreeModel treeModel;                          
 
 DefaultMutableTreeNode top, category1, globalLeaf; //  Nodos del Arbol de conexi�n
 DefaultMutableTreeNode localLeaf_1, localLeaf_2 ;  //  Was added 2009/07/02  Nick
 
 JTree       tree;		  //HostTree de la estructura de la conexi�n a PostgreSQL
 JTabbedPane tabbedPane;  //Carpetas donde se desplegar� la informaci�n de tables, datos y queries
 
 PGConnection   pgconn;    //Objeto de la clase PGConnection que maneja la conexion
 ConnectionInfo online;    //Objeto de la clase ConnectionInfo que define la estructura de datos de la conexion
 ChooseIdiom    language;
 
 boolean connected = false;
 
 JSplitPane  splitPpal; // Panel redimensionable entre el arbol de bases de datos y las carpetas
 JScrollPane treeView;
 DefaultTreeCellRenderer renderer;

 // Nick 2009-07-23 newSCH, dropSCH, newView, dropView  were added
 //      2011-09-25 All XML, XRD Items was dropped.
 JButton connect,  disconnect;                          // iconos de conexion
 JButton newDB,    dropDB ;                             // icons de bases de datos
 JButton newSCH,   dropSCH;                             // icons of schema of database
 JButton newTable, dropTable, dumpTable;                // iconos de tablas
 JButton newView,  dropView,  dumpView;                 // icons of views
 JButton changeIdiom;                                   // icons of language exchange

 // Were changed. Nick 2009-07-23 ------------------------------------------------------
 JMenu connection, structure, query, admin, help, group, sub_user; //Menues desplegables
 JMenu dataBase, schemas, tables, views; // Nick 2009-07-23 

 JMenuItem  connectItem,  disconnectItem, exitItem ; //items de los Menues connection

 JMenuItem  newDBItem,    dropDBItem ;                      // xmlDbItem , xmlTableItem, xmlUpdate, xmlImport;  //palabras para de los Menues dataBase
 JMenuItem  newSCHItem,   dropSCHItem;                      // Nick 2009-09-03
 JMenuItem  newTableItem, dropTableItem, dumpTableItem ;    
 JMenuItem  newViewItem,  dropViewItem,  dumpViewItem ;    

 JMenuItem  newQryItem, saveQryItem, openQryItem, hqItem, runQryItem ; //items de los JMenu query 
 JMenuItem  helpItem,   aboutItem ; //items de los JMenu help

 JMenuItem  newGroupItem, alterGroupItem, dropGroupItem;
 JMenuItem  newUserItem,  alterUserItem,  dropUserItem;
 JMenuItem  grantItem,    revokeItem;
 JMenuItem  sub_permi;

 JMenuItem  addFieldItem;                                         // items del JMenu tables
 JMenuItem  editFieldItem, dropFieldItem,  
            insertRecordItem, updateRecordItem, delRecordItem;    // items del JMenu tables
 
 Language idiom;
 ConnectionWatcher guard;
 
 // Active schema is added. 13/11/2011
 String   ActiveDataB = "";
 String   ActiveSchema = "";
 //
 String[] permissions;
 String   xlanguage       = "";
 String   DBComponentName = "";   
 
 Vector   vecConn     = new Vector ();
 Vector   dbNames     = new Vector ();
 // Vector   evaluatedDB = new Vector (); Nick 2009-07-10
 
 Structures structuresPanel;
 Records    recordsPanel;
 Queries    queriesPanel;
 
 int ActivedTabbed   =  0;  // had been: 2.  Nick 2009-07-06 
 int OldCompType     = -1;
 int numOldTables    =  0;
 
 int DBComponentType    = -1;  // See setDBComponents method
 int DBTreeCurrentLevel = -1 ; // was added 2009-07-06 Nick
 /**********************************************************
  *  0 - HOST, then 
  *       DBComponentName = 'hostname'
  *       DBComponentType = 0
  *  ---------------------------------
  *  1 - DATABASE, then      
  *       DBComponentName = 'database'
  *       DBComponentType = 1
  *  ---------------------------------
  *  2 - SCHEME, then      
  *       DBComponentName = 'schemename'
  *       DBComponentType = 2
  *  -------------------------------------------------------
  *  3 - SCHEME object type, then      
  *       DBComponentName = 'Tables(xx)' or 'Views(xx)'
  *       DBComponentType = 31  or 32
  *  -------------------------------------------------------
  *  4 - OBJECT NAME ( Table or View), then      
  *       DBComponentName = '<Table name>' or '<Views name>'
  *       DBComponentType = 41  or 42
  ***********************************************************/
 
 Table      currentTable;
 Vector     indices;
 JPopupMenu popup, popupDB;

 String startDate  = "";
 String OS         = "";
 String configPath = ""; // X1.cfg  2009-11-22 Nick 
 String X1Home    = "";

 // 2009-09-29 Nick, List tables ( views ) with their comments
 Vector Xtables = new Vector();
 Vector Xviews  = new Vector();

 // Nick 2012-11-11
 Vector Xfunctions  = new Vector(); 
 Vector Xdomains    = new Vector();
 Vector Xagregates  = new Vector();
 Vector Xsequences  = new Vector();
 Vector Xtypes      = new Vector();
 Vector Xcomp_types = new Vector();
 Vector Xenum_types = new Vector();
 Vector Xoperators  = new Vector();
 Vector Xtriggers   = new Vector();
 Vector Xrules      = new Vector();
  
 final String cTITLE = "X1 - The PostgreSQL workbench" ;
 boolean networkLink = false;
 
 final boolean bDEBUG = false; // Nick 2010-03-11

 // 2010-03-26 Nick, this is global record filter.
 Hashtable hashDB = new Hashtable(); // Nick 2010-02-26
 
 /**
  * METODO CONSTRUCTOR public X1()
  * Arma y ensambla los elementos de la interfaz gr�fica
  */
 public X1() {		

  super ( "X1 - The PostgreSQL workbench" );  
  
  ConfigFileReader readLang = new ConfigFileReader ();
  OS = System.getProperty ( cSYS_OS_NAME );  
  if ( OS.startsWith ( cSYS_OS_WIN ) ) System.setProperty ( WINDOWS_PROP_NAME, Path.getPathxpg() );
  X1Home = UHome.getUHome ( OS ) ;

  File file = new File ( X1Home );
  if ( !file.exists () ) file.mkdir () ;
	  
  configPath = X1Home + CFG_NAME;               // + System.getProperty ( cSYS_FILE_SEP )  
  file = new File ( configPath );
  
  if ( !file.exists () )  readLang.Create_File ( configPath );
    else readLang = new ConfigFileReader ( configPath, 1 );
  
  file = new File ( X1Home + cLOG_CATALOG );    // + System.getProperty ( cSYS_FILE_SEP ) 
  if ( !file.exists () ) file.mkdir();
  
  file = new File ( X1Home + cQR_CATALOG );     // + System.getProperty ( cSYS_FILE_SEP )
  if ( !file.exists () ) file.mkdir();
  
  file = new File ( X1Home + cREP_CATALOG );    // + System.getProperty ( cSYS_FILE_SEP ) 
  if ( !file.exists () ) file.mkdir();
  
  //Leer del archivo de configuraci�n el idioma actual
  xlanguage = readLang.getIdiom();
  
  //Si actualmente no se guarda ning�n idioma
  //mostrar ventana inicial para escoger idioma
  if ( xlanguage.equals ( sTOKEN_3 ) ) {

      language = new ChooseIdiom ( X1.this );
      language.pack ();
      language.setLocationRelativeTo ( X1.this );
      language.setVisible ( true );			
      xlanguage = language.getIdiom ();
      idiom = new Language ( xlanguage );	
      writeFile ( xlanguage );
   } 
  else
       idiom = new Language ( xlanguage );

  startDate = GetDateTime.DateClassic () ; // 2012-12-11   DateClassic ( getTime () ) ;
 
  getContentPane().setLayout ( new BorderLayout() );    // Parte el FRAME
  menuX   = new JMenuBar ();      //Se crea un nuevo objeto menu desplegable
  iconBar = new JToolBar ( SwingConstants.HORIZONTAL ); //Se crea un nuevo objeto barra de iconos
  iconBar.setFloatable ( false );  //Se hace la barra de iconos fija
  Global = new JPanel();   

  // -----------------------------------------
  Toolkit kit = Toolkit.getDefaultToolkit ();
  Dimension screenSize = kit.getScreenSize ();
  
  int xPos = 0;
  int yPos = 0;
 
  int sWidth  = 0;
  int sHeigth = 0;
  
  if ( bDEBUG ) {
	  
	  sWidth  = cWIDTH_D;   // 1024 
	  sHeigth = cHEIGTH_D;  //  768
	  xPos    = cXPOS_D;    
	  yPos    = cYPOS_D;     
  }
    else { // Nick 2010-03-11 
    	   sHeigth = ( int ) ( screenSize.height * 0.92 );
    	   sWidth  = ( int ) ( 1.33 * sHeigth ); // screenSize.width;
    	   xPos    = cXPOS_P + ( int ) ( 0.008 * sWidth);   //  150
    	   yPos    = cYPOS_P + ( int ) ( 0.008 * sHeigth ); //   90

    }
  // -----------------------------------------
  
  setJMenuBar   ( menuX );      // A�adiendo el menu desplegable al Frame
  CreateMenu    ();             // Se definen los componentes del menu desplegable		
  CreateToolBar ();             // Se definen los componentes de los iconos de la ventana principal
  HostTree      ();   	                        //Crea el HostTree a desplegar
  Folders       ( sWidth >= 1152 );	//Crea los Folders a desplegar

  //cambiar los iconos por defecto del arbol
  renderer = new DefaultTreeCellRenderer ();
  URL imgURL = getClass().getResource ("/icons/16_DB_Open.png");
  renderer.setOpenIcon ( new ImageIcon (Toolkit.getDefaultToolkit().getImage(imgURL)));
  
  imgURL = getClass().getResource ("/icons/16_DB.png");
  renderer.setClosedIcon ( new ImageIcon (Toolkit.getDefaultToolkit().getImage(imgURL)));
  
  imgURL = getClass().getResource ("/icons/16_table.png");
  renderer.setLeafIcon ( new ImageIcon (Toolkit.getDefaultToolkit().getImage(imgURL)));

  tree.setCellRenderer (renderer);
  
  //Crear un scroll pane y a�ade el arbol a este 
  treeView = new JScrollPane(tree);  

  //Crear el split pane a�adiendo a la izq. el arbol y a la derecha las pesta�as 
  splitPpal = new JSplitPane(JSplitPane.HORIZONTAL_SPLIT);
  splitPpal.setLeftComponent(treeView);
  splitPpal.setRightComponent(tabbedPane);
  splitPpal.setOneTouchExpandable(true); //el SplitPane muestra controles que permiten al
                                         //usuario ocultar uno de los componentes y asignar todo el espacio al otro
  //Dar el tama�o m�nimo para los dos componentes del split pane

  treeView.setMinimumSize ( new Dimension ( cTREE_VIEW_MIN_W, cTREE_VIEW_MIN_H )); // 100, 400
  treeView.setPreferredSize ( new Dimension ( cTREE_VIEW_PREF_W, cTREE_VIEW_PREF_H )); // 400, 600, 200, 400

  tabbedPane.setMinimumSize ( new Dimension ( cTABBED_PANE_MIN_W, cTABBED_PANE_MIN_H )); // 400, 640 
  tabbedPane.setEnabled(false); //Deshabilitar las carpetas

  splitPpal.setDividerLocation ( cSPLIT_VERT_DIV_LOC );  // 270, 135 Selecciona u obtiene la posici�n actual del divisor.   
  splitPpal.setPreferredSize ( new Dimension ( cSPLIT_PREF_W, cSPLIT_PREF_H )); // 100, 400, 200, 400 Tama�o preferido para el split pane
 
  //Armar el monitor de eventos 
  JButton upTitle = new JButton ( idiom.getWord ( "LOGMON" ) );
  upTitle.setToolTipText ( idiom.getWord ( "PRESSCL" ) );

  /*----------------------------------------------*/
  upTitle.addActionListener ( new ActionListener () {
    public void actionPerformed ( ActionEvent e ) {

      int pi = Ppal.getDividerLocation ();

      if ( pi == cSPLIT_HOR_DIV_LOC_MAX ) Ppal.setDividerLocation ( cSPLIT_HOR_DIV_LOC_MIN ); 
      else Ppal.setDividerLocation ( cSPLIT_HOR_DIV_LOC_MAX );
    }
   }
  );
  /*----------------------------------------------*/

  JPanel downP = new JPanel();
  downP.setLayout ( new BorderLayout () );

  LogWin.setEditable ( false );
  JScrollPane winCover = new JScrollPane ( LogWin );
  downP.add ( upTitle,  BorderLayout.NORTH );
  downP.add ( winCover, BorderLayout.CENTER );
 
  //A�ade al panel Global al norte la barra de iconos y en el centro el split
  Global.setLayout(new BorderLayout());
  Global.add(iconBar,BorderLayout.NORTH);

  splitPpal.setMinimumSize ( new Dimension ( cSPLIT_PANE_MIN_W, cSPLIT_PANE_MIN_H ));
  downP.setMinimumSize ( new Dimension ( cDOWN_PANE_MIN_W, cDOWN_PANE_MIN_H ));
  
  Ppal = new JSplitPane ( JSplitPane.VERTICAL_SPLIT );
  Ppal.setOneTouchExpandable ( true ); //el SplitPane muestra controles
  Ppal.setTopComponent ( splitPpal );
  Ppal.setBottomComponent ( downP );
  Ppal.setDividerLocation ( cSPLIT_HOR_DIV_LOC_MAX ); // 720, 430
  Global.add ( Ppal, BorderLayout.CENTER );

  setBackground ( Color.lightGray );//define el color de fondo para el Frame
  getContentPane().add ( "Center", Global );//A�ade al Frame ppal el panel Global
  
  pack ();

  this.setSize ( sWidth, sHeigth ) ;  // 1024,  768   680, 600 Tama�o inicial del Frame !!! Nick 2009-11-19
  this.setLocation ( xPos, yPos ) ;

  setVisible ( true ); //mostrar el Frame

 } // Fin constructor

 /************************************************************ 
  * METODO public void CreateMenu()
  * Crea Menu desplegable 
  * 
  * METODO CreateToolBar  
  * Crea Barra de Iconos 
  * 2009-06-16 I must think about new features: for example, 
  *      point database is going to have five or six subpoints:
  *         1) schema
  *         2) table
  *         3) view
  *         4) function
  *         5) trigger  
  *      each of them have to have three standard points:
  *             a) new
  *             b) edit
  *             c) delete
  * Nick            
  * --------------------------------------------
  * 2009-07-23 - expand and rebuild menu.  Nick   
  * 2009-08-05 - new items ( for meta info ) were added.     Nick           
  */
 public void CreateMenu () {

  JMenuItem Item ; 
  
  /*-------- Crea un item (palabra) de un menu -------------*/
	
  connection = new JMenu (idiom.getWord ("CONNEC"));    //Crea el menu de conexi�n
  connection.setMnemonic (idiom.getNemo ("NEMO-CONNEC"));
  menuX.add (connection);        //Adiciona el menu al menu desplegable

  structure = new JMenu (idiom.getWord ("ST"));         // Crea el menu de Estructura // 
  structure.setMnemonic (idiom.getNemo ("NEMO-ST"));    // Establece un atajo
  menuX.add (structure);          //Adiciona el menu al menu desplegable

  query = new JMenu ( idiom.getWord ("QUERY") );        // Crea un menu llamado Query
  query.setMnemonic ( idiom.getNemo ("NEMO-QUERY") );   // Establece un atajo
  menuX.add (query);                                    // Adiciona el menu al menu desplegable

  admin = new JMenu (idiom.getWord ("ADMIN"));          // Crea un menu llamado admin
  admin.setMnemonic (idiom.getNemo ("NEMO-ADMIN"));     // Establece un atajo
  menuX.add (admin);                                    // Adiciona el menu al menu desplegable

  help = new JMenu (idiom.getWord ("HELP"));         // Crea un menu llamado Help
  help.setMnemonic (idiom.getNemo ("NEMO-HELP") );   // Establece un atajo
  menuX.add (help);                                  // Adiciona el menu al menu desplegable

  /* Submenus for "Structure", Nick 2009-07-23 */
  dataBase = new JMenu (idiom.getWord ("DB"));         // Crea el menu de Basa de datos // 
  dataBase.setMnemonic (idiom.getNemo ("NEMO-DB"));    // Establece un atajo
  
  schemas = new JMenu (idiom.getWord ("SCH"));         // Crea el menu de schemas // 
  schemas.setMnemonic (idiom.getNemo ("NEMO-SCH"));    // Establece un atajo
  
  tables = new JMenu (idiom.getWord ("TABLE"));       // Crea un menu llamado Table
  tables.setMnemonic (idiom.getNemo ("NEMO-TABLE"));  // Establece un atajo

  views = new JMenu (idiom.getWord ("VIEW"));       // Crea un menu llamado la Vista
  views.setMnemonic (idiom.getNemo ("NEMO-VIEW"));  // Establece un atajo
  /* ! Menu - la basta ! */
  
  /*---------- Items of Menu connection ----------*/
  URL imgURL = getClass().getResource ("/icons/16_connect.png"); 
  connectItem = new JMenuItem ( idiom.getWord ("CONNE2"),
		                                 new ImageIcon(Toolkit.getDefaultToolkit().getImage(imgURL))); 
  connectItem.setActionCommand ("ItemConnect");
  connectItem.addActionListener (this);
  connection.add (connectItem);
  connectItem.setMnemonic (idiom.getNemo ("NEMO-CONNE2")); 

  imgURL = getClass().getResource ("/icons/16_disconnect.png");
  disconnectItem = new JMenuItem (idiom.getWord("DISCON"),
		                                 new ImageIcon(Toolkit.getDefaultToolkit().getImage(imgURL)));
  
  disconnectItem.setActionCommand ("ItemDisconnect");
  disconnectItem.addActionListener (this);
  connection.add (disconnectItem);
  disconnectItem.setMnemonic(idiom.getNemo ("NEMO-DISCON")); 
  disconnectItem.setEnabled (false);
  
  connection.addSeparator (); 
 
  imgURL = getClass().getResource ("/icons/16_exit.png");  
  exitItem = new JMenuItem (idiom.getWord("EXIT"),
		                                 new ImageIcon (Toolkit.getDefaultToolkit().getImage (imgURL))); 
  exitItem.setActionCommand ("ItemExit");
  exitItem.addActionListener ( this );
  connection.add ( exitItem );
  exitItem.setMnemonic( idiom.getNemo ( "NEMO-EXIT" )); 
  
  /*----------Items Menu of  Structure ----------*/  // Nick 2009-07-23
  // Database 
  imgURL = getClass().getResource("/icons/16_NewDB.png");
  newDBItem = new JMenuItem ( idiom.getWord ("NEWF"),
		                                 new ImageIcon (Toolkit.getDefaultToolkit().getImage (imgURL))
  ); 
  newDBItem.setActionCommand ("ItemCreateDB");
  newDBItem.addActionListener ( this );
  
  dataBase.add (newDBItem);
  newDBItem.setMnemonic ( idiom.getNemo ("NEMO-NEWF") ); 

  imgURL = getClass().getResource ("/icons/16_DropDB.png");  
  dropDBItem = new JMenuItem ( idiom.getWord ("DROP"),
		                                 new ImageIcon (Toolkit.getDefaultToolkit().getImage (imgURL))
  ); 
  dropDBItem.setActionCommand ("ItemDropDB");
  dropDBItem.addActionListener ( this );
  
  dataBase.add (dropDBItem);
  dropDBItem.setMnemonic (idiom.getNemo ("NEMO-DROP"));
  
  // ----------------------------------------------------
  // Nick 2009-08-05
  // --   XML Items was added
  //      2011-09-25 
  // --   They was dropped
  
  structure.add ( dataBase );  
  structure.addSeparator ();
 
  // Schema Nick 2009-07-23
  imgURL = getClass().getResource ("/icons/16_NewDB.png");
  newSCHItem = new JMenuItem ( idiom.getWord ("NEWF"),
		                               new ImageIcon (Toolkit.getDefaultToolkit().getImage (imgURL))
  ); 
  newSCHItem.setActionCommand ("ItemCreateSCH");
  newSCHItem.addActionListener ( this );
  schemas.add ( newSCHItem );
  newSCHItem.setMnemonic ( idiom.getNemo ("NEMO-NEWF") ); 

  imgURL = getClass().getResource ( "/icons/16_DropDB.png" );  
  dropSCHItem = new JMenuItem ( idiom.getWord ( "DROP" ),
		                                 new ImageIcon (Toolkit.getDefaultToolkit().getImage (imgURL))
  ); 
  dropSCHItem.setActionCommand ("ItemDropSCH");
  dropSCHItem.addActionListener (this);
  schemas.add (dropSCHItem);
  dropSCHItem.setMnemonic ( idiom.getNemo ("NEMO-DROP") );

  structure.add ( schemas );  
  structure.addSeparator();
  
  /*----------Items Menu Table----------*/
  imgURL = getClass().getResource ("/icons/16_NewTable.png");
  newTableItem = new JMenuItem ( idiom.getWord ("NEWF"),
		                                 new ImageIcon(Toolkit.getDefaultToolkit().getImage(imgURL))); 
  newTableItem.setActionCommand ("ItemCreateTable");
  newTableItem.addActionListener (this);
  tables.add (newTableItem);
  newTableItem.setMnemonic (idiom.getNemo ("NEMO-NEWF")); 

  imgURL = getClass().getResource ("/icons/16_DropTable.png");
  dropTableItem = new JMenuItem(idiom.getWord("DROP"),
		                                 new ImageIcon(Toolkit.getDefaultToolkit().getImage(imgURL))); 
  dropTableItem.setActionCommand ("ItemDropTable");
  dropTableItem.addActionListener (this);
  tables.add (dropTableItem);
  dropTableItem.setMnemonic (idiom.getNemo("NEMO-DROP")); 
  
  imgURL = getClass().getResource ("/icons/16_Dump.png");
  dumpTableItem = new JMenuItem (idiom.getWord ("DUMP"),
		                                 new ImageIcon(Toolkit.getDefaultToolkit().getImage(imgURL))); 
  dumpTableItem.setActionCommand ("ItemDumpTable");
  dumpTableItem.addActionListener (this);
  tables.add ( dumpTableItem );
  dumpTableItem.setMnemonic (idiom.getNemo ("NEMO-DUMP"));

  // XML - Nick 2009-07-23
  /***********************
   imgURL = getClass().getResource ("/icons/16_Dump.png");
   xmlTableItem = new JMenuItem ( idiom.getWord ("XMLT"),
		                                 new ImageIcon (Toolkit.getDefaultToolkit().getImage (imgURL))); 
   xmlTableItem.setActionCommand ( "ItemXmlTable" );
   xmlTableItem.addActionListener (this);
   tables.add ( xmlTableItem );
   xmlTableItem.setMnemonic (idiom.getNemo ("NEMO-XML"));
  **/ 
 
  structure.add ( tables );  
  structure.addSeparator();
  
  /*---------- Items Menu View ----------*/ // Nick 2009-07-23 
  imgURL = getClass().getResource ("/icons/16_NewTable.png");
  newViewItem = new JMenuItem (idiom.getWord ("NEWF"),
		                                 new ImageIcon(Toolkit.getDefaultToolkit().getImage(imgURL))); 
  newViewItem.setActionCommand ("ItemCreateView");
  newViewItem.addActionListener ( this );
  views.add ( newViewItem );
  newViewItem.setMnemonic ( idiom.getNemo ("NEMO-NEWF")); 

  imgURL = getClass().getResource ("/icons/16_DropTable.png");
  dropViewItem = new JMenuItem (idiom.getWord("DROP"),
		                                 new ImageIcon(Toolkit.getDefaultToolkit().getImage(imgURL))); 
  dropViewItem.setActionCommand ("ItemDropView");
  dropViewItem.addActionListener (this);
  views.add ( dropViewItem );
  dropViewItem.setMnemonic (idiom.getNemo("NEMO-DROP")); 
  
  imgURL = getClass().getResource ("/icons/16_Dump.png");
  dumpViewItem = new JMenuItem ( idiom.getWord ("DUMP"),
		                                 new ImageIcon (Toolkit.getDefaultToolkit().getImage(imgURL))); 
  dumpViewItem.setActionCommand ("ItemDumpTable");
  dumpViewItem.addActionListener ( this );
  views.add ( dumpViewItem );
  dumpViewItem.setMnemonic (idiom.getNemo ("NEMO-DUMP"));

  structure.add ( views );  
  structure.addSeparator();
  
  /*************************************************************************************************** 
    imgURL = getClass().getResource ("/icons/16_Grant.png");
    sub_permi = new JMenuItem (idiom.getWord ("PERMI"),
		                                 new ImageIcon(Toolkit.getDefaultToolkit().getImage(imgURL))); 
    sub_permi.setActionCommand ("ItemGrant");
    sub_permi.addActionListener(this);
    tables.add(sub_permi);
    sub_permi.setMnemonic(idiom.getNemo("NEMO-PERMI"));
  ****************************************************/

  /*----------Items Sub-Menu group----------*/
  group = new JMenu(idiom.getWord("GROUP"));

  imgURL = getClass().getResource("/icons/16_NewGroup.png");
  newGroupItem = new JMenuItem(idiom.getWord("CREATE"),
		                                 new ImageIcon(Toolkit.getDefaultToolkit().getImage(imgURL))); 
  newGroupItem.setActionCommand("ItemCreateGroup");
  newGroupItem.addActionListener(this);
  group.add(newGroupItem);
  newGroupItem.setMnemonic(idiom.getNemo("NEMO-CREATE")); 

  imgURL = getClass().getResource("/icons/16_AlterGroup.png");
  alterGroupItem = new JMenuItem(idiom.getWord("ALTER"),
		                                 new ImageIcon(Toolkit.getDefaultToolkit().getImage(imgURL))); 
  alterGroupItem.setActionCommand("ItemAlterGroup");
  alterGroupItem.addActionListener(this);
  group.add(alterGroupItem);
  alterGroupItem.setMnemonic(idiom.getNemo("NEMO-ALTER")); 

  imgURL = getClass().getResource("/icons/16_DropGroup.png");
  dropGroupItem = new JMenuItem(idiom.getWord("DROP"),
		                                 new ImageIcon(Toolkit.getDefaultToolkit().getImage(imgURL))); 
  dropGroupItem.setActionCommand("ItemDropGroup");
  dropGroupItem.addActionListener(this);
  group.add(dropGroupItem);
  dropGroupItem.setMnemonic(idiom.getNemo("NEMO-DROP")); 

  admin.add(group);
  group.setMnemonic(idiom.getNemo("NEMO-GROUP")); 
  admin.addSeparator();

  /*----------Items Sub-Menu user----------*/
  sub_user = new JMenu(idiom.getWord("USER"));

  imgURL = getClass().getResource("/icons/16_NewUser.png");
  newUserItem = new JMenuItem(idiom.getWord("CREATE"),
		                                 new ImageIcon(Toolkit.getDefaultToolkit().getImage(imgURL))); 
  newUserItem.setActionCommand("ItemCreateUser");
  newUserItem.addActionListener(this);
  sub_user.add(newUserItem);
  newUserItem.setMnemonic(idiom.getNemo("NEMO-CREATE")); 

  imgURL = getClass().getResource("/icons/16_AlterUser.png");
  alterUserItem = new JMenuItem(idiom.getWord("ALTER"),
		                                 new ImageIcon(Toolkit.getDefaultToolkit().getImage(imgURL))); 
  alterUserItem.setActionCommand("ItemAlterUser");
  alterUserItem.addActionListener(this);
  sub_user.add(alterUserItem);
  alterUserItem.setMnemonic(idiom.getNemo("NEMO-ALTER")); 

  imgURL = getClass().getResource("/icons/16_DropUser.png");
  dropUserItem = new JMenuItem(idiom.getWord("DROP"),
		                                 new ImageIcon(Toolkit.getDefaultToolkit().getImage(imgURL))); 
  dropUserItem.setActionCommand("ItemDropUser");
  dropUserItem.addActionListener(this);
  sub_user.add(dropUserItem);
  dropUserItem.setMnemonic(idiom.getNemo("NEMO-DROP")); 

  admin.add(sub_user);
  sub_user.setMnemonic(idiom.getNemo("NEMO-USER")); 

  /*----------Items Menu query----------*/
  imgURL = getClass().getResource("/icons/16_new.png");
  newQryItem = new JMenuItem(idiom.getWord("NEWF"),
		                                 new ImageIcon(Toolkit.getDefaultToolkit().getImage(imgURL))); 
  newQryItem.setActionCommand("ItemCreateQry");
  newQryItem.addActionListener(this);
  query.add(newQryItem);
  newQryItem.setMnemonic(idiom.getNemo("NEMO-NEWF")); 

  imgURL = getClass().getResource("/icons/16_Load.png");
  openQryItem = new JMenuItem(idiom.getWord("OPEN"),
		                                 new ImageIcon(Toolkit.getDefaultToolkit().getImage(imgURL))); 
  openQryItem.setActionCommand("ItemOpenQry");
  openQryItem.addActionListener(this);
  query.add(openQryItem);
  openQryItem.setMnemonic(idiom.getNemo("NEMO-OPEN")); 

  imgURL = getClass().getResource("/icons/16_HQ.png");
  hqItem = new JMenuItem(idiom.getWord("HQ"),
		                                 new ImageIcon(Toolkit.getDefaultToolkit().getImage(imgURL)));
  hqItem.setActionCommand("ItemHQ");
  hqItem.addActionListener(this);
  query.add(hqItem);
  hqItem.setMnemonic(idiom.getNemo("NEMO-HQ"));

  /*----------Items Menu help----------*/
  imgURL = getClass().getResource("/icons/16_Help.png");  
  helpItem = new JMenuItem(idiom.getWord("HELP"),
		                                 new ImageIcon(Toolkit.getDefaultToolkit().getImage(imgURL))); 
  helpItem.setActionCommand("ItemContenido");
  helpItem.addActionListener(this);
  help.add(helpItem);
  helpItem.setMnemonic(idiom.getNemo("NEMO-HELP2")); 
  
  help.addSeparator();
  
  aboutItem = new JMenuItem(idiom.getWord("ABOUT") + "..." ); 
  aboutItem.setActionCommand("ItemAbout");
  aboutItem.addActionListener(this);
  help.add(aboutItem);
  aboutItem.setMnemonic(idiom.getNemo("NEMO-ABOUT"));  
  
  switchJMenus(false);
 }   

 /**
  * METODO CreateToolBar  
  * Crea Barra de Iconos 
  * 2009-06-16 I must think about new features: for example, 
  *      point database is going to have five or six subpoints:
  *         1) schema
  *         2) table
  *         3) view
  *         4) function
  *         5) trigger  
  *      each of them have to have three standard points:
  *             a) new
  *             b) edit
  *             c) delete
  * Nick            
  * ----------------------
  * 2009-07-23 - expand toolbar.  Nick              
  */            
 public void CreateToolBar() {

  JToolBar.Separator line1 = new JToolBar.Separator();
  JToolBar.Separator line2 = new JToolBar.Separator();
  JToolBar.Separator line3 = new JToolBar.Separator();
  //
  JToolBar.Separator line4 = new JToolBar.Separator(); // Nick 2009-07-23
  JToolBar.Separator line5 = new JToolBar.Separator();
  
  /*------------ Botones Conexion ------------*/
  URL imgURL = getClass().getResource ( "/icons/16_connect.png" );
  connect = new JButton ( new ImageIcon ( Toolkit.getDefaultToolkit().getImage(imgURL)) );
  connect.setActionCommand ( "ButtonConnect" );
  connect.addActionListener ( this );
  connect.setToolTipText ( idiom.getWord ( "CONNE2" ) );
  iconBar.add ( connect );

  imgURL = getClass().getResource ( "/icons/16_disconnect.png" );
  disconnect = new JButton ( new ImageIcon (Toolkit.getDefaultToolkit().getImage(imgURL)) );
  disconnect.setActionCommand ( "ButtonDisconnect" );
  disconnect.addActionListener ( this );
  disconnect.setToolTipText ( idiom.getWord ("DISCON") );
  iconBar.add ( disconnect );
  disconnect.setEnabled ( false );

  iconBar.add ( line1 ); 
  /*------------ Botones Base de Datos ------------*/
  imgURL = getClass().getResource ("/icons/16_NewDB.png");
  newDB = new JButton ( new ImageIcon (Toolkit.getDefaultToolkit().getImage(imgURL)));
  newDB.setActionCommand ("ButtonNewDB");
  newDB.addActionListener(this);
  newDB.setToolTipText ( idiom.getWord ("NEWDB") );
  iconBar.add (newDB);
  newDB.setEnabled (false);
  
  imgURL = getClass().getResource ("/icons/16_DropDB.png");
  dropDB = new JButton ( new ImageIcon (Toolkit.getDefaultToolkit().getImage(imgURL)) );
  dropDB.setActionCommand ( "ButtonDropDB" );
  dropDB.addActionListener (this);
  dropDB.setToolTipText( idiom.getWord ( "DROPDB" ) );
  iconBar.add (dropDB);
  dropDB.setEnabled (false);

  // Nick 2009-08-06
  /*** 2011-9-25
  imgURL = getClass().getResource ( "/icons/16_Dump.png" );
  xmlDB = new JButton ( new ImageIcon ( Toolkit.getDefaultToolkit().getImage(imgURL)) );
  xmlDB.setActionCommand ( "ButtonXmlDB" );
  xmlDB.addActionListener ( this );
  xmlDB.setToolTipText( idiom.getWord ( "XMLD" ) );
  iconBar.add ( xmlDB );
  xmlDB.setEnabled ( false );
  
  // Nick 2010-04-23
  imgURL = getClass().getResource ( "/icons/16_NewDB.png" );
  xmlIM = new JButton ( new ImageIcon ( Toolkit.getDefaultToolkit().getImage(imgURL)) );
  xmlIM.setActionCommand ( "InsertXml" );
  xmlIM.addActionListener ( this );
  xmlIM.setToolTipText( idiom.getWord ( "XMLI" ) );
  iconBar.add ( xmlIM );
  xmlIM.setEnabled ( false );
  ****/
  // Nick 2010-04-23
  ///////////////////////////////////////////////////////////////////////////////
  // imgURL = getClass().getResource ( "/icons/16_NewDB.png" );  // Nick 2009-09-03
  //xmlImport = new JMenuItem ( idiom.getWord ( "XMLI" ),  
  //		                               new ImageIcon (Toolkit.getDefaultToolkit().getImage (imgURL))
  // );
  // xmlImport.setActionCommand ( "InsertXml" );
  // xmlImport.addActionListener ( this );
  // dataBase.add ( xmlImport );
  // xmlImport.setMnemonic (idiom.getNemo ("NEMO-XMLI"));
  ////////////////////////////////////
  iconBar.add ( line2 ); 

  // Nick 2009-07-23 The buttons "Schema"
  imgURL = getClass().getResource ("/icons/16_NewDB.png");
  newSCH = new JButton ( new ImageIcon ( Toolkit.getDefaultToolkit().getImage (imgURL)) );
  newSCH.setActionCommand ( "ButtonNewSCH" );
  newSCH.addActionListener ( this );
  newSCH.setToolTipText ( idiom.getWord ( "NEWSCH" ) ); 
  iconBar.add ( newSCH );
  newSCH.setEnabled ( false );
  
  imgURL = getClass().getResource ("/icons/16_DropDB.png");
  dropSCH = new JButton ( new ImageIcon ( Toolkit.getDefaultToolkit().getImage (imgURL)) );
  dropSCH.setActionCommand ("ButtonDropSCH");
  dropSCH.addActionListener ( this );
  dropSCH.setToolTipText( idiom.getWord ( "DROPSCH" ) ); 
  iconBar.add ( dropSCH );
  dropSCH.setEnabled ( false );

  iconBar.add (line3); 
  
  /*------------ Botones Tabla ------------*/
  imgURL = getClass().getResource ("/icons/16_NewTable.png");
  newTable = new JButton ( new ImageIcon ( Toolkit.getDefaultToolkit().getImage(imgURL)) );
  newTable.setActionCommand ( "ButtonNewTable" );
  newTable.addActionListener ( this );
  newTable.setToolTipText ( idiom.getWord ( "NEWT" ));
  iconBar.add ( newTable );
  newTable.setEnabled ( false );

  imgURL = getClass().getResource ("/icons/16_DropTable.png");
  dropTable = new JButton ( new ImageIcon(Toolkit.getDefaultToolkit().getImage(imgURL)) );
  dropTable.setActionCommand ( "ButtonDropTable" );
  dropTable.addActionListener ( this );
  dropTable.setToolTipText ( idiom.getWord ( "DROPT" ));
  iconBar.add ( dropTable );
  dropTable.setEnabled ( false );
  
  imgURL = getClass().getResource ("/icons/16_Dump.png");
  dumpTable = new JButton (new ImageIcon(Toolkit.getDefaultToolkit().getImage(imgURL)) );
  dumpTable.setActionCommand ("ButtonDumpTable");
  dumpTable.addActionListener (this);
  dumpTable.setToolTipText ( idiom.getWord ("DUMPT") );
  iconBar.add ( dumpTable );
  dumpTable.setEnabled ( false );
  
  // New button "XML functions" was added 2009-07-23 Nick. 
  //  2011-09-25 was dropped.
  iconBar.add (line4); 
  
  /*------------ Buttons View ------------*/
  imgURL = getClass().getResource ("/icons/16_NewTable.png");
  newView = new JButton ( new ImageIcon ( Toolkit.getDefaultToolkit().getImage(imgURL)) );
  newView.setActionCommand ( "ButtonNewView" );
  newView.addActionListener ( this );
  newView.setToolTipText ( idiom.getWord ( "NEWV" ));
  iconBar.add ( newView );
  newView.setEnabled ( false );

  imgURL = getClass().getResource ("/icons/16_DropTable.png");
  dropView = new JButton ( new ImageIcon ( Toolkit.getDefaultToolkit().getImage(imgURL)) );
  dropView.setActionCommand ( "ButtonDropView" );
  dropView.addActionListener ( this );
  dropView.setToolTipText ( idiom.getWord ( "DROPV" ));
  iconBar.add ( dropView );
  dropView.setEnabled ( false );
  
  imgURL = getClass().getResource ("/icons/16_Dump.png");
  dumpView = new JButton ( new ImageIcon ( Toolkit.getDefaultToolkit().getImage(imgURL)) );
  dumpView.setActionCommand ("ButtonDumpView");
  dumpView.addActionListener ( this );
  dumpView.setToolTipText ( idiom.getWord ("DUMPV") );
  iconBar.add ( dumpView );
  dumpView.setEnabled ( false );
  
  iconBar.add (line5); 
  
  /*------------ Botones Lenguaje ------------*/
  imgURL = getClass().getResource ( "/icons/16_Language.png" ); 
  changeIdiom = new JButton ( new ImageIcon(Toolkit.getDefaultToolkit().getImage(imgURL)) );
  changeIdiom.setActionCommand ( "ButtonChangeLanguage" );
  changeIdiom.addActionListener ( this );
  changeIdiom.setToolTipText ( idiom.getWord ("CHANGE_L") );
  iconBar.add ( changeIdiom );
 }

 /***********************************************************************
  * METODO actionPerformed
  * Manejador de Eventos para la barra de botones y el menu desplegable
  */
 public void actionPerformed ( java.awt.event.ActionEvent e ) {

  if ( e.getActionCommand().equals ( "ItemRename" )) {

      TreePath selPath = tree.getSelectionPath();
      DefaultMutableTreeNode node = ( DefaultMutableTreeNode ) selPath.getLastPathComponent();
      final String oldName = node.toString ();     
      tree.setEditable ( true );
      final JTextField rename = new JTextField ();
      tree.setCellEditor ( new DefaultCellEditor ( rename ));   
      tree.startEditingAtPath ( selPath );
      rename.requestFocus ();

      rename.addActionListener ( new ActionListener () {
        public void actionPerformed ( ActionEvent e ) {

          String newName = rename.getText ();

          if ( newName.indexOf ( " " ) != -1 ) {

              rename.setText ( oldName );
              JOptionPane.showMessageDialog ( X1.this, idiom.getWord ( "NOCHART" ), 
            		                          idiom.getWord ( "ERROR!" ), JOptionPane.ERROR_MESSAGE 
              );
              return;
          } 

          rename.setText ( newName );
          String result = "";

          if ( newName.length () == 0 ) {

              TreePath selPath = tree.getSelectionPath ();
              tree.startEditingAtPath ( selPath );             
           } 
          else {
                int index = dbNames.indexOf ( ActiveDataB );
                PGConnection konn = ( PGConnection ) vecConn.elementAt ( index );
                result = konn.SQL_Instruction ( "ALTER TABLE \"" + oldName + "\" RENAME TO \"" + 
                		 newName + "\"" );
               
                if ( result.equals ( "OK" )) { // Nick 2009-09-29 

                    String t_descr = GetStr.getDescrByName ( Xtables, DBComponentName );
                    DBComponentName = newName;
                    // Need to rename  Nick 2009-09-29 !!!                 
                    
                    // 2011-11-13 Nick, ActiveSchema added.
                    String owner = konn.getOwner ( newName, ActiveSchema );           
                    structuresPanel.setLabel ( ActiveDataB, newName, owner, t_descr ); // Nick 2009-09-29 
                    recordsPanel.setLabel ( ActiveDataB, newName, owner, t_descr );
                 } 
                else {
                      result = result.substring ( 0, result.length () -1 );
                      rename.setText ( oldName );
                 }
  	  }
          addTextLogMonitor ( idiom.getWord ( "EXEC" ) + "ALTER TABLE \"" + oldName + "\" RENAME TO \"" + 
        		              newName + "\"\"" );
          addTextLogMonitor ( idiom.getWord ( "RES" ) + result );
	}
     });

     return;
  } // e.getActionCommand().equals ( "ItemRename"

  if ( e.getActionCommand ().equals ( "ItemDelete" ) ) {

    GenericQuestionDialog killtb = new GenericQuestionDialog ( X1.this, idiom.getWord ("YES"), 
    		idiom.getWord ("NO"), idiom.getWord ("BOOLDELTB"), idiom.getWord ("MESGDELTB") + 
    		DBComponentName + "?"
    );                                           

    boolean sure = killtb.getSelecction (); 
    String result = "";

    if ( sure ) {
        int index = dbNames.indexOf ( ActiveDataB );
        PGConnection konn = ( PGConnection ) vecConn.elementAt ( index );
        result = konn.SQL_Instruction ( "DROP TABLE \"" + DBComponentName + "\"");

        if ( result.equals ("OK") ) {   

            TreePath selPath = tree.getSelectionPath();
            DefaultMutableTreeNode currentNode =( DefaultMutableTreeNode ) ( selPath.getLastPathComponent());
            DefaultMutableTreeNode NodeDB =( DefaultMutableTreeNode ) currentNode.getParent();
            treeModel.removeNodeFromParent ( currentNode );

            if ( NodeDB.getChildCount() == 0 ) {
                DefaultMutableTreeNode nLeaf = new DefaultMutableTreeNode ( idiom.getWord ( "NOTABLES" ) );
                NodeDB.add ( nLeaf );
             }
         } 
        else
            result = result.substring( 0, result.length () -1 );

        addTextLogMonitor ( idiom.getWord ("EXEC") + "DROP TABLE \"" + DBComponentName + "\";\"" );
        addTextLogMonitor ( idiom.getWord ("RES") + result );
 
        tabbedPane.setSelectedIndex (2);
        tabbedPane.setEnabledAt ( 0, false );
        tabbedPane.setEnabledAt ( 1, false );
     }

    return;
  }  // ItemDelete

  if ( e.getActionCommand ().equals ( "ItemDump" ) ) {

      String s = "file:" + System.getProperty("user.home");
      File file;
      boolean Rewrite = true;
      String FileName = "";
      JFileChooser fc = new JFileChooser (s);
      ExtensionFilter filter = new ExtensionFilter ( "sql", idiom.getWord ( "SQLF" ) );
      fc.addChoosableFileFilter ( filter );

      int returnVal = fc.showDialog ( X1.this, idiom.getWord ( "SAVE" ) );

      if ( returnVal == JFileChooser.APPROVE_OPTION ) {

          file = fc.getSelectedFile ();
          FileName = file.getAbsolutePath ();

          if ( file.exists () ) {

              GenericQuestionDialog win = new GenericQuestionDialog ( X1.this, idiom.getWord ("YES"), 
            		     idiom.getWord ("NO"), idiom.getWord ("ADV"), idiom.getWord ("FILE") +
            		     " '" + FileName + "'" + idiom.getWord ("SEQEXIS2") + " " + 
            		     idiom.getWord ("OVWR")
              );
              Rewrite = win.getSelecction();
           }

          if ( Rewrite ) {

           try {
                int index = dbNames.indexOf ( ActiveDataB );
                PGConnection konn = ( PGConnection ) vecConn.elementAt( index );
                konn.setDBComponentType ( this.DBComponentType );
                
                // ActiveSchema added 2011-11-13, 2012-06-01
                // String dataStr = createTableSQL ( konn.getSpecStrucTable ( 
                // 		this.DBComponentName, this.ActiveSchema ) // 2011-11-13
                
                String dataStr = getCreateObjSQL.createTableSQL ( konn.getSpecStrucTable ( 
                		DBComponentName, ActiveSchema ) // 2011-11-13
                );

                if ( !FileName.endsWith (".sql") ) FileName += ".sql";

                PrintStream sqlFile = new PrintStream ( new FileOutputStream ( FileName ) );
                sqlFile.print ( dataStr );
                sqlFile.close ();
            }
           catch ( Exception ex ) {
              System.out.println ( "Error: " + ex );
              ex.printStackTrace ();
            }
          }
      }
    return;
   }

  if ( e.getActionCommand ().equals ( "ItemExport" )) {

      int index = dbNames.indexOf ( ActiveDataB );
      PGConnection konn = (PGConnection) vecConn.elementAt ( index );
      int regs = konn.rCount ( DBComponentName );
      
      addTextLogMonitor ( idiom.getWord ("EXEC") + "SELECT count(*) FROM " + DBComponentName + "\"" );
      addTextLogMonitor ( idiom.getWord ("NUMR") + DBComponentName + "' : " + regs );

      if ( regs > 100 ) {

         JOptionPane.showMessageDialog ( X1.this,
        		 				idiom.getWord ("LOTREG") + DBComponentName + idiom.getWord ("LOTREG2"),
        		 				idiom.getWord ("INFO"), JOptionPane.INFORMATION_MESSAGE 
         );

         return;
       }

      Vector result = konn.TableQuery ( "SELECT * FROM " + DBComponentName );
      Vector colnames = konn.getTableHeader ();
      String res = "";

      if (!konn.queryFail())
          res = "OK";
      else {
            res = konn.problem; 
            res = res.substring ( 0, res.length ()-1 );
       }

      addTextLogMonitor ( idiom.getWord ("EXEC") + "SELECT * FROM " + DBComponentName + "\"");
      addTextLogMonitor ( idiom.getWord ("RES") + res);
      ReportDesigner format = new ReportDesigner ( X1.this, colnames, result, idiom, LogWin, 
    		                                       DBComponentName, konn 
      );

      return;
  } 

  if ( e.getActionCommand ().equals ("ItemExToFile") ) {

      ExportSeparatorField little = new ExportSeparatorField ( X1.this,idiom );

      if ( little.isDone () ) {

                 String limiter = little.getLimiter();
                 String s = "file:" + System.getProperty("user.home");
                 File file;
                 boolean Rewrite = true;
                 String FileName = "";
                 JFileChooser fc = new JFileChooser (s);
                 int returnVal = fc.showDialog ( X1.this, idiom.getWord("EXPTO") );

                 if (returnVal == JFileChooser.APPROVE_OPTION) {

                     file = fc.getSelectedFile();
                     FileName = file.getAbsolutePath();

                     if ( file.exists () ) {

                         GenericQuestionDialog win = new GenericQuestionDialog ( X1.this, 
                        	idiom.getWord ("YES"), idiom.getWord ("NO"), idiom.getWord ("ADV"),
                            idiom.getWord ("FILE") + " '" + FileName + "'" + idiom.getWord ("SEQEXIS2") + 
                            " " + idiom.getWord ("OVWR")
                         );
                         Rewrite = win.getSelecction ();
                     }

                      if ( Rewrite ) {

                           try {
                                 int index = dbNames.indexOf(ActiveDataB);
                                 PGConnection connection = (PGConnection) vecConn.elementAt(index);

                                 Vector result = 
                                	  connection.TableQuery ( "SELECT * FROM " + DBComponentName );
                                 Vector colnames = connection.getTableHeader ();
                                 String resultString = "OK";

                                 if ( connection.queryFail () ) {
                                     resultString = connection.getProblemString ();
                                     resultString = resultString.substring( 0, resultString.length () -1 );
                                  }

                                 addTextLogMonitor ( idiom.getWord ("EXEC") + "SELECT * FROM " + 
                                		                 DBComponentName + "\""
                                 );
                                 addTextLogMonitor ( idiom.getWord ("RES") + resultString );
                                 
                                 connection.setDBComponentType ( this.DBComponentType );
                                 
                                 // Active Schema added  2011-11-13 Nick
                                 Table structT = connection.getSpecStrucTable ( 
                                   		                   DBComponentName, this.ActiveSchema 
                                 );   
                                 TableHeader tableHeader = structT.getTableHeader(); 
                                 PrintStream exportFile = new PrintStream ( new FileOutputStream (FileName ));
                                 PrintOuput.printFile ( exportFile, result, colnames, limiter, tableHeader );
                               }
                            catch(Exception ex) {  
                                  System.out.println("Error: " + ex);        
                                  ex.printStackTrace();
                              }
                      }
                    }
        }

    return;
  }

  if ( e.getActionCommand().equals ( "ItemPopCloseDB" ) ) {

      if ( DBComponentName.equals ( pgconn.getDBname () ) ) {

          GenericQuestionDialog killtb = new GenericQuestionDialog ( X1.this, idiom.getWord ("YES"),
        		  idiom.getWord ("NO"), idiom.getWord ("BOOLDISC"), idiom.getWord ("WDIS") );

          boolean sure = killtb.getSelecction ();

          if ( sure ) Disconnect();

          return;
      }

      int pos = dbNames.indexOf ( DBComponentName );
      PGConnection pgTmp = ( PGConnection ) vecConn.remove ( pos );
      pgTmp.close ();
      dbNames.remove ( pos );
      addTextLogMonitor ( idiom.getWord ("CLSDB") + DBComponentName + "'" ); 
      Object raiz = treeModel.getRoot ();
      int k = treeModel.getChildCount ( raiz );

      for ( int i = 0; i < k; i++ ) {

          Object o = treeModel.getChild ( raiz, i );

          if ( DBComponentName.equals ( o.toString () ) ) {
              treeModel.removeNodeFromParent ( ( MutableTreeNode ) o );
              break;
           }
      }

      return;
  } 

  if ( e.getActionCommand ().equals ( "ItemPopDeleteDB" ) ) {

      if ( DBComponentName.equals ( pgconn.getDBname() ) ) {

          JOptionPane.showMessageDialog ( X1.this,
        		  idiom.getWord ( "INVOP" ), idiom.getWord ("INFO"),
        		  JOptionPane.ERROR_MESSAGE
          );
          return;
       }

      GenericQuestionDialog killtb = new GenericQuestionDialog ( X1.this, idiom.getWord ("YES"),
    	idiom.getWord ("NO"), idiom.getWord("BOOLDELTB"), idiom.getWord("MESGDELDB")+ DBComponentName + "?"
      );
      boolean sure = killtb.getSelecction ();

      if ( sure ) {

          int pos =  dbNames.indexOf ( DBComponentName );
          PGConnection tempo = ( PGConnection ) vecConn.remove ( pos );
          tempo.close ();
          dbNames.remove ( pos );
          
          //Eliminando BD
          String l_instr = cDRP + cDB + cDQU + DBComponentName + cDQU ;
          String result = pgconn.SQL_Instruction ( l_instr ); // Nick 2009-08-04
          addTextLogMonitor ( idiom.getWord ("EXEC")+ l_instr + ";\"" );

          if ( result.equals ( "OK" ) ) {

              TreePath selPath = tree.getSelectionPath ();
              DefaultMutableTreeNode currentNode = ( DefaultMutableTreeNode ) 
                                                                 ( selPath.getLastPathComponent ()
              );
              DefaultMutableTreeNode NodeDB = ( DefaultMutableTreeNode ) currentNode.getParent();
              treeModel.removeNodeFromParent ( currentNode );
              addTextLogMonitor ( idiom.getWord ("RES")+ result );
           }
         else { 
               String tmp = result.substring ( 0, result.length () - 1 );
               addTextLogMonitor ( idiom.getWord ("RES") + tmp );
               
               JOptionPane.showMessageDialog ( X1.this,idiom.getWord ("ERRORPOS") + tmp,
                                               idiom.getWord ("ERROR!"), JOptionPane.ERROR_MESSAGE
               );
          }

      } 

    return;
  }

  if ( e.getActionCommand().equals ( "ItemPopDumpDB" ) ) {

      int index = dbNames.indexOf ( ActiveDataB );
      PGConnection dbDump = ( PGConnection ) vecConn.elementAt ( index );

      int numTables = dbDump.getNumTables ();
 
      if ( numTables > 0 ) {

          DumpDb proto = new DumpDb ( X1.this, ActiveDataB, dbDump, idiom );
          /* proto.pack();
          proto.setLocationRelativeTo(X1.this);
          proto.setVisible(true); */

          if ( proto.wellDone )
              addTextLogMonitor ( idiom.getWord ("DUMPT1") + proto.getTables () + idiom.getWord ("DUMPT2") 
                                  + proto.getDBName() + idiom.getWord ("DUMPT3") + proto.getFile() + "'" 
              );
       } // numTables > 0 -- Nick 2009-07-20
      else {
             JOptionPane.showMessageDialog ( X1.this,idiom.getWord ("TNTAB") + ActiveDataB + "'",
                                          idiom.getWord ("INFO"), JOptionPane.INFORMATION_MESSAGE
             );
       }

    return;
  }

  /*------------ Evento Conexion --------------*/
  if ( e.getActionCommand ().equals ( "ItemConnect" ) || 
	   e.getActionCommand().equals ( "ButtonConnect" )) {    

      		NConnect();
      		return;
  }

  /*------------ Evento Desconectar --------------*/
  if ( e.getActionCommand ().equals ("ItemDisconnect") || 
	   e.getActionCommand().equals ("ButtonDisconnect")) {       

           Disconnect();
           return;
  }

  /*------------ Evento Salir --------------*/
  if (e.getActionCommand().equals("ItemExit")) {                  

      if ( connected ) {

          GenericQuestionDialog exitWin = new GenericQuestionDialog ( X1.this, idiom.getWord ("YES"),
        		  idiom.getWord ("NO"), idiom.getWord ("BOOLEXIT"), idiom.getWord ("MESGEXIT")
          );

          boolean sure = exitWin.getSelecction ();

          if ( sure ) {
               SaveLog ();
               closePGSockets (); 
               System.exit (0);
          } // sure
          return;
       }
      else 
           System.exit (0);
  }
   
  /*------------ Evento Base de Datos ------------*/
  if ( e.getActionCommand ().equals ( "ItemCreateDB" ) || 
	   e.getActionCommand ().equals ( "ButtonNewDB" )) {                  

    CreateDB newDB = new CreateDB ( X1.this, idiom, pgconn, LogWin );

    if ( newDB.isDone () ) {

        ConnectionInfo tmp = new ConnectionInfo ( online.getHost (), newDB.getDBname (), online.getUser (), 
        		online.getPassword (), online.getPort (), online.requireSSL ()
        );
        PGConnection proofConn = new PGConnection ( tmp, idiom );

        if ( !proofConn.Fail () ) {

            dbNames.add ( newDB.getDBname () );
            vecConn.add ( proofConn );

            //Insertando nueva base de datos en el arbol
            DefaultMutableTreeNode dbLeaf = new DefaultMutableTreeNode ( tmp.getDatabase() );
            DefaultMutableTreeNode noTables = new DefaultMutableTreeNode ( idiom.getWord ("NOOBJECTS") ); 
            
            dbLeaf.add ( noTables );
            DefaultMutableTreeNode parent = ( DefaultMutableTreeNode ) treeModel.getRoot();
            treeModel.insertNodeInto( dbLeaf, parent, parent.getChildCount() ); // At last place

            JOptionPane.showMessageDialog ( 
            	  X1.this, idiom.getWord ( "OKCREATEDB1" ) + tmp.getDatabase () + "\" \n" + 
            	  idiom.getWord ("OKCREATEDB2"), idiom.getWord("INFO"), JOptionPane.INFORMATION_MESSAGE
                );
         } 
        else {
               String msg = idiom.getWord ("OKCREATEDB1") + tmp.getDatabase() + "\" " + 
                            idiom.getWord ("OKCREATEDB2") + "\n" + idiom.getWord ("NNACESS") + "\n" + 
                            idiom.getWord ("NNCONTACT");
               JOptionPane.showMessageDialog ( 
            		   X1.this,msg,idiom.getWord ("INFO"),
            		   JOptionPane.INFORMATION_MESSAGE
               );
         }
    }

   return;
  }
  
  if ( e.getActionCommand ().equals ( "ItemDropDB" ) || 
	   e.getActionCommand ().equals ( "ButtonDropDB" ) ) {
    
    //Formando el vector de las bases de datos de las cuales el usuario es propietario
    
	//  Nick 2009-07-30 - Rebuild class DropDB, it has to perform drop database action. 
	//  CreateDB newDB = new CreateDB ( X1.this, idiom, pgconn, LogWin ), for example.
    //  DropDB dropDB  = new DropDB ( X1.this, idiom, DBNames ) ; // Old
    
    DropDB dropDB = new DropDB ( X1.this, idiom, pgconn, online.getDatabase(), LogWin 
    );

    //Si el usuario presiono el boton DROP 
    if ( dropDB.confirmDropDB ()) { 

       String result = dropDB.actionDropDB ( this.pgconn, this.vecConn );	
       if ( result.equals ( "OK" ) ) {

          if ( dropDB.get_inTree () ) { // Nick 2009-08-03
           /*** Nick 2009-09-03
                      This point does not work now because the current datebase 
                      was excluded from the list of deleted databases.
            ***/

            Object raiz = treeModel.getRoot();
            int k = treeModel.getChildCount ( raiz );

            for ( int i = 0; i < k; i++ ) {

                Object o = treeModel.getChild ( raiz, i );

                if ( dropDB.comboText.equals ( o.toString () )) {
                     treeModel.removeNodeFromParent (( MutableTreeNode ) o);
                     break;
                 }
             } // for i
          } // dropDB.get_inTree() == true 

          addTextLogMonitor ( idiom.getWord ("RES") + result );

          JOptionPane.showMessageDialog ( X1.this,idiom.getWord ( "OKDROPDB1" )+
                                          dropDB.comboText + idiom.getWord ( "OKDROPDB2" ),
                                          idiom.getWord ( "INFO" ),  // Nick 2012-02-10
                                          JOptionPane.INFORMATION_MESSAGE 
          );
       } // result.equals ( "OK" ) == true
       
        else { 
               String tmp = result.substring ( 0, result.length () - 1 );
               addTextLogMonitor ( idiom.getWord ("RES") + tmp );
            
               JOptionPane.showMessageDialog ( X1.this, idiom.getWord ( "ERRORPOS" ) + tmp,
                                               idiom.getWord ( "ERROR!" ),
                                               JOptionPane.ERROR_MESSAGE
            );
       }
    } // dropDB.confirmDropDB () == true

    return;
  }
  /*---------------------------------------------------------------------------------------*/

  /*------------ Evento Tabla ------------*/
  if ( e.getActionCommand ().equals ( "ItemCreateTable" ) || 
	   e.getActionCommand ().equals ( "ButtonNewTable" )) {                  

    setCursor ( Cursor.getPredefinedCursor ( Cursor.WAIT_CURSOR ));
    //
    //Nick 2011-12-10
    this.addTextLogMonitor (idiom.getWord("VCTS"));
    CreateTable winTable = new CreateTable ( X1.this, idiom, dbNames, vecConn, ActiveDataB, ActiveSchema, LogWin );
    setCursor( Cursor.getPredefinedCursor (Cursor.DEFAULT_CURSOR));

    if ( winTable.getWellDone () ) { // Show information message.       
         JOptionPane.showMessageDialog ( X1.this, 
  		   ( cSPACE + idiom.getWord ("CRT")), idiom.getWord ( "INFO" ), 
  		     JOptionPane.INFORMATION_MESSAGE 
         );

     Object raiz_0 = treeModel.getRoot ();           // The Host
     int chq_1 = treeModel.getChildCount ( raiz_0 ); // Qty of databases

     for ( int i = 0; i < chq_1; i++ ) { // List of databases

           Object raiz_1 = treeModel.getChild ( raiz_0, i );  // The DataBase
           if ( winTable.dbn.equals ( raiz_1.toString () ) ) { 

        	int chq_2 = treeModel.getChildCount ( raiz_1 );   // Qty of schemas 
        	for ( int j = 0; j < chq_2; j++ ) {               // List of schemas
        		
        		Object raiz_2 = treeModel.getChild ( raiz_1, j );        // Schema
        		if ( winTable.CurrentSCH.equals ( raiz_2.toString()) ) { 
        		
        			int chq_3 = treeModel.getChildCount ( raiz_2 );       // Qty types of object 
        			for ( int k = 0; k < chq_3; k++ ) {                   // The List types of object
        				Object raiz_3 = treeModel.getChild ( raiz_2, k ) ; // The type of object
        				if ( raiz_3.toString().startsWith(idiom.getWord ("TABLE").toString())) {
        					
        		               Object[] lista = { raiz_0, raiz_1, raiz_2, raiz_3 };  //  HostName, DataBase, Schema, Type
        		               TreePath rama = new TreePath ( lista );   

        		               DefaultMutableTreeNode parent = ( DefaultMutableTreeNode ) raiz_3;
        		               int ch_qty_3 = parent.getChildCount(); 
        		               
        		               // if ( tree.isExpanded ( rama ) || ( ch_qty_3 == 0) ) {

        		               DefaultMutableTreeNode TLeaf = new DefaultMutableTreeNode ( winTable.CurrentTable ); // New object
        		               treeModel.insertNodeInto ( TLeaf, parent, ch_qty_3 ); 
        		               tree.expandPath (rama);
        		              // }
        				}
        			}// List types of objects
        		}
        	} // List of schemas
         } // Database name is found
     } // loop for // List of databases
   } // winTable.getWellDone
    else {
    	// Show message NO
    }
    
    return;
  } // CreateTable

  if ( e.getActionCommand ().equals ("ItemDropTable") || 
	   e.getActionCommand ().equals ("ButtonDropTable") ) {                  

    DropTable dT = new DropTable( X1.this, dbNames, vecConn, idiom, LogWin);

    Vector delTables = dT.getDeletedTables();
    int size = delTables.size();
    int count = 0;

    while (!delTables.isEmpty()) {

           count++;
           String tableTarget = (String) delTables.remove(0); 
           Object root = treeModel.getRoot();
           int k = treeModel.getChildCount(root);

           for( int i = 0; i < k; i++ ) {

               Object o = treeModel.getChild(root,i);

               if ( dT.dbx.equals ( o.toString ()) ) {

                   Object[] nodeList = {root,o};
                   TreePath branch = new TreePath(nodeList);

                   if ( tree.isExpanded(branch) ) {

	               int p = treeModel.getChildCount(o);

                       for ( int j = 0; j < p; j++ ) {

                            Object t = treeModel.getChild(o,j);

                            if ( tableTarget.equals ( t.toString () )) {

                                TreePath selPath = tree.getSelectionPath(); 
                                DefaultMutableTreeNode node = (DefaultMutableTreeNode)
                                                                        selPath.getLastPathComponent();

                                if (count == size) {

                                    structuresPanel.setNullTable ();
                                    structuresPanel.setLabel ( "", "", "", "" ); // 2009-09-29	
                                    recordsPanel.setLabel ( "", "", "", "" );
                                    structuresPanel.activeToolBar ( false );
                                    structuresPanel.activeIndexPanel ( false );
                                    tabbedPane.setEnabledAt ( 0, false );
                                    tabbedPane.setEnabledAt ( 1, false );
                                    tabbedPane.setSelectedIndex ( 2 );
                                    tree.setSelectionPath( branch );
                                 }

                                treeModel.removeNodeFromParent( ( MutableTreeNode )t );
                                DefaultMutableTreeNode NodeDB =( DefaultMutableTreeNode ) 
                                                                          ( branch.getLastPathComponent());

                                if (NodeDB.getChildCount()==0) {

                                    DefaultMutableTreeNode nLeaf = new DefaultMutableTreeNode (
                                    		                             idiom.getWord("NOTABLES")
                                    );
                                    NodeDB.add(nLeaf);
                                 }
                                break;
                              }
                           }
                    }
                }
         }//fin for 
    } //fin while delTables.isEmpty() 

    return;
  }

  if ( e.getActionCommand ().equals ( "ItemDumpTable" ) || e.getActionCommand().equals ( "ButtonDumpTable" )) {

      DumpTable proto = new DumpTable ( X1.this, dbNames, vecConn, idiom );

      if ( proto.isDone () )
           addTextLogMonitor ( idiom.getWord ("DUMPT1") + proto.getTables() + 
        		               idiom.getWord ("DUMPT2") + proto.getDBName() + 
        		               idiom.getWord ("DUMPT3") + proto.getFile() + "'"
      );

      return;

   }    
  /*---------- Evento Consulta --------*/  
  if (e.getActionCommand().equals("ItemCreateQry")) {

      int carpeta = tabbedPane.getSelectedIndex();

      if ( carpeta != 2) {

          tabbedPane.setSelectedIndex(2);
          queriesPanel.NewQuery();
       }

      return;
  }

  if (e.getActionCommand().equals("ItemOpenQry")) {

      int carpeta = tabbedPane.getSelectedIndex();

      if (carpeta != 2)
            tabbedPane.setSelectedIndex(2);

      queriesPanel.LoadQuery();

      return;
   }

  if (e.getActionCommand().equals("ItemHQ")) {

      HotQueries hotQ = new HotQueries ( X1.this, idiom, pgconn.getDBname() );

      if (hotQ.isWellDone())
          queriesPanel.loadSQL ( hotQ.getSQL (), hotQ.isReady () );

      return;
   }
 
 /* ---------------Evento Admin --------------*/
  if(e.getActionCommand().equals("ItemCreateUser")) {                  

    CreateUser cUser = new CreateUser ( X1.this, idiom, pgconn, LogWin );
/*    cUser.pack();
    cUser.setLocationRelativeTo(X1.this);
    cUser.show();*/

    return;
  }

  if (e.getActionCommand().equals("ItemAlterUser")) {                  

    AlterUser aUser = new AlterUser ( X1.this, idiom, pgconn, LogWin );
/*    aUser.pack();
    aUser.setLocationRelativeTo(X1.this);
    aUser.show(); */

    return;
  }

  if(e.getActionCommand().equals("ItemDropUser")) {                  

    DropUser dUser = new DropUser ( X1.this, idiom, pgconn, LogWin );
/*    dUser.pack();
    dUser.setLocationRelativeTo(X1.this);
    dUser.show();	     */

    return;
  }
  
  if(e.getActionCommand().equals("ItemCreateGroup")) {                  

    CreateGroup cGroup = new CreateGroup ( X1.this, idiom, pgconn, LogWin );
/*    cGroup.pack();
    cGroup.setLocationRelativeTo(X1.this);
    cGroup.show();	     */

    return;
  }

  if ( e.getActionCommand ().equals ( "ItemAlterGroup" )) {                  

    String as[] = pgconn.getGroups();

    if (as.length == 0) {

        JOptionPane.showMessageDialog(X1.this,
        idiom.getWord("NGRPS"),
        idiom.getWord("INFO"),JOptionPane.INFORMATION_MESSAGE);
     }
    else {

          AlterGroup aGroup = new AlterGroup(X1.this,idiom,pgconn,LogWin);
          /* aGroup.pack();
          aGroup.setLocationRelativeTo(X1.this);
          aGroup.show();	     */
     }

    return;
  }

  if (e.getActionCommand().equals("ItemDropGroup")) {                  

      String as[] = pgconn.getGroups();

      if (as.length == 0) {

          JOptionPane.showMessageDialog(X1.this,
          idiom.getWord("NGRPS"),
          idiom.getWord("INFO"),JOptionPane.INFORMATION_MESSAGE);
       }
      else {
             DropGroup dGroup = new DropGroup(X1.this,idiom,pgconn,LogWin);
       }

      return;
  }

  if (e.getActionCommand().equals("ItemGrant")) {

      int index = dbNames.indexOf(ActiveDataB);

      if (index == -1) {

          JOptionPane.showMessageDialog(X1.this,
          idiom.getWord("PCDBF"),
          idiom.getWord("INFO"),JOptionPane.INFORMATION_MESSAGE);

          return;
       }

      PGConnection konn = (PGConnection) vecConn.elementAt(index);

      String[] tb = new String [ 1]; // Nick 2012-02-11

      if (permissions[1].equals("false")) 
          tb [1] = "";  // konn.getTablesNames(true);
      else
          tb [1] = "";  // konn.getTablesNames(false);

      if ((tb.length < 1) && (!permissions[1].equals("true"))) 

          JOptionPane.showMessageDialog(X1.this,
          idiom.getWord("NOTOW") + ActiveDataB + "'",
          idiom.getWord("INFO"),JOptionPane.INFORMATION_MESSAGE);
      else {
              if (tb.length > 0) {
                  TablesGrant perm = new TablesGrant(X1.this,idiom,konn,LogWin,tb);
               }
              else {
                     JOptionPane.showMessageDialog(X1.this,
                     idiom.getWord("NODBC") + ActiveDataB + "\"!",
                     idiom.getWord("INFO"),JOptionPane.INFORMATION_MESSAGE);

              return;
       }
      }

      return;
  }

 /*------------ Evento Ayuda ------------*/
  if ( e.getActionCommand().equals ( "ItemContenido" )) {                  

   /*
    X1Help hlp = new X1Help(X1Home); 
    hlp.pack();
    hlp.setLocationRelativeTo(X1.this);
    hlp.setVisible(true); */

    JOptionPane.showMessageDialog ( X1.this,
              idiom.getWord ( "UIMO" ),
              idiom.getWord ( "INFO" ), JOptionPane.INFORMATION_MESSAGE 
    );
    return;
  }

  if ( e.getActionCommand().equals ( "ItemAbout" ) ) {         

      About dialog = new About ( X1.this, idiom );
      dialog.setVisible ( true );

      return;
   }  
   
  /*------------ Evento Lenguaje ------------*/
  if (e.getActionCommand().equals("ButtonChangeLanguage")) {

      ChooseIdiomButton language = new ChooseIdiomButton(X1.this, idiom, LogWin);
      if (language.getSave()) {

          xlanguage = language.getIdiom();
          JOptionPane.showMessageDialog ( X1.this, idiom.getWord ("NEXT_TIME"),                                  
                         idiom.getWord("INFO"), JOptionPane.INFORMATION_MESSAGE
          );                          
          writeFile ( xlanguage );
       }

      return;
    }    
 }
 /*******************************************************************************/
 
 /**
  * METODO HostTree
  * Crea Arbol del Servidor
  * Nick 2009-06-17  I have to modify this method.
  *      2009-08-19  XMLT was added
  *      2009-08-20  XMLD was added
  */
 public void HostTree() {

  top = new DefaultMutableTreeNode ( idiom.getWord ( "DSCNNTD" ) );
  category1 = new DefaultMutableTreeNode ( idiom.getWord ( "NODB" ) );
  top.add ( category1 );

  tree = new JTree ( top );
  tree.getSelectionModel ().setSelectionMode ( TreeSelectionModel.SINGLE_TREE_SELECTION );
  tree.setCellRenderer ( renderer );
  tree.collapseRow ( 0 );

  popup = new JPopupMenu();

  JMenuItem Item = new JMenuItem ( idiom.getWord ("RNAME") ); 
  Item.setFont ( new Font ( "Helvetica", Font.PLAIN, 10 ) );
  Item.setActionCommand ("ItemRename");
  Item.addActionListener ( this );
  popup.add ( Item );

  Item = new JMenuItem ( idiom.getWord ( "DUMP" ) ); 
  Item.setFont ( new Font ( "Helvetica", Font.PLAIN, 10 ) );
  Item.setActionCommand ( "ItemDump" );
  Item.addActionListener ( this );
  popup.add ( Item );

  Item = new JMenuItem ( idiom.getWord ( "EXPORTAB" ) );
  Item.setFont ( new Font  ( "Helvetica", Font.PLAIN, 10 ) );
  Item.setActionCommand  ( "ItemExToFile" );
  Item.addActionListener ( this );
  popup.add (Item);

  Item = new JMenuItem ( idiom.getWord ( "EXPORREP" ) ); 
  Item.setFont ( new Font ( "Helvetica", Font.PLAIN, 10 ) );
  Item.setActionCommand ( "ItemExport" );
  Item.addActionListener ( this );
  popup.add (Item);

  Item = new JMenuItem  ( idiom.getWord ( "DROP" ) ); 
  Item.setFont ( new Font ( "Helvetica", Font.PLAIN, 10 ) );
  Item.setActionCommand ( "ItemDelete" );
  Item.addActionListener (this);
  popup.add (Item);

  /** Nick 2012-01-05
  // Nick 2009-08-19
  Item = new JMenuItem  ( idiom.getWord ( "XMLT" )); 
  Item.setFont ( new Font ( "Helvetica", Font.PLAIN, 10 ) );
  Item.setActionCommand ( "ItemXMLT" );
  Item.addActionListener ( this );
  popup.add ( Item );
  **/
  // ----------------------------------------------------
  
  popupDB = new JPopupMenu();

  Item = new JMenuItem ( idiom.getWord ( "DUMP" ));
  Item.setFont ( new Font ( "Helvetica", Font.PLAIN, 10 ));
  Item.setActionCommand ( "ItemPopDumpDB" );
  Item.addActionListener ( this );
  popupDB.add ( Item );

  Item = new JMenuItem ( idiom.getWord ( "CLOSE" ) );
  Item.setFont ( new Font ( "Helvetica", Font.PLAIN, 10 ));
  Item.setActionCommand ( "ItemPopCloseDB" );
  Item.addActionListener ( this );
  popupDB.add ( Item );

  Item = new JMenuItem ( idiom.getWord ( "DROP" ) );
  Item.setFont ( new Font ( "Helvetica", Font.PLAIN, 10 ) );
  Item.setActionCommand ( "ItemPopDeleteDB" );
  Item.addActionListener ( this );
  popupDB.add ( Item );

  /*** Nick 2012-01-05
  // Nick 2009-08-20
  Item = new JMenuItem ( idiom.getWord ( "XMLD" ) );
  Item.setFont ( new Font ( "Helvetica", Font.PLAIN, 10 ) );
  Item.setActionCommand ( "ItemXMLD" );
  Item.addActionListener ( this );
  popupDB.add ( Item );
  **/
 }

 /**
  * METODO Folders 
  * Crea Pesta�as
  * 2009-06-17  Here is very important method.
  *             I am going to add two new folders:
  *                 - Bath-loading processor 
  */
 public void Folders ( boolean p_sw ){
 /*** 2009-07-07.  Nick 
  *                Name of first folder was changed: "TABLE" -> "STRUC"
  **********************************************************************/
	 
  URL imgURL = getClass().getResource ("/icons/16_table.png" );
  ImageIcon iconTable = new ImageIcon ( Toolkit.getDefaultToolkit().getImage (imgURL));

  imgURL = getClass().getResource("/icons/16_Datas.png");
  ImageIcon iconRecord = new ImageIcon ( Toolkit.getDefaultToolkit().getImage(imgURL));
  
  imgURL = getClass().getResource("/icons/16_SQL.png"); 
  ImageIcon iconQuery = new ImageIcon ( Toolkit.getDefaultToolkit().getImage(imgURL));  
  
  tabbedPane = new JTabbedPane ();

  LogWin = new JTextArea ( 5, 0 );

  structuresPanel = new Structures ( X1.this, idiom, LogWin );
  tabbedPane.addTab ( idiom.getWord ("STRUC"), iconTable, structuresPanel, idiom.getWord ("STRUC") );

  recordsPanel = new Records ( X1.this, idiom, LogWin, p_sw, false, hashDB ); // Nick 2010-03-27
  tabbedPane.addTab ( idiom.getWord ( "RECS" ), iconRecord, recordsPanel, idiom.getWord ("RECS") );

  // Nick 2013-06-02 
  FuncStructs.setIdiom ( idiom );
  SQLFunctionDataStruc[] fList = FuncStructs.funcDataStruct ();
  SQLFuncBasic[] fbasic = FuncStructs.funcBasicStruct ();
  
  queriesPanel = new Queries ( X1.this, idiom, LogWin, fList, fbasic );
  tabbedPane.addTab (idiom.getWord ("QUERYS"), iconQuery, queriesPanel, idiom.getWord ("QUERYS") );
 }

 /**
  * METODO ReConfigFile 
  * Re-escribe el archivo de configuracion
  */
 public void ReConfigFile ( ConnectionInfo online,Vector ListRegs,int lastUsed ) {

   ConnectionInfo tmp = ( ConnectionInfo) ListRegs.elementAt ( lastUsed );
   boolean noNew = true;
   int pos = lastUsed;

   if ( !tmp.getHost().equals ( online.getHost() ) || 
		!tmp.getUser().equals ( online.getUser() ) || 
		!tmp.getDatabase().equals ( online.getDatabase() ) 
	  ) {

     noNew = false;

     for ( int i = 0; i < ListRegs.size() ; i++ ) {

          if (i!=lastUsed) {

              ConnectionInfo element = (ConnectionInfo) ListRegs.elementAt(i);

              if ( element.getHost().equals(online.getHost()) && 
            	   element.getUser().equals(online.getUser()) && 
            	   element.getDatabase().equals(online.getDatabase())
            	  ) {

                      noNew = true; 
                      pos = i;
	                  break;
               }
           }
     }	
   }

   if ( noNew ) {
       new BuildConfigFile ( ListRegs, pos, xlanguage );
    } 
   else {
          new BuildConfigFile ( ListRegs, online, xlanguage );
    }
 }
 
 /**
  * METODO switchJMenus
 
  */
 void switchJMenus ( boolean state ) {

  dataBase.setEnabled (state);
  tables.setEnabled   (state);
  query.setEnabled    (state); 
  admin.setEnabled    (state); 
  // Nick 2010-05-18
  schemas.setEnabled   (state);   
  views.setEnabled     (state);
  structure.setEnabled (state);
 } 

 /**
  * METODO activeToolBar
  * New button was added  2009-07-23
  */
 void activeToolBar( boolean state ) {

  disconnect.setEnabled ( state );

  if ( permissions[0].equals ( "true" ) && state ) {

      newDB.setEnabled    ( true );
      dropDB.setEnabled   ( true );
      dataBase.setEnabled ( true );
      // Nick 2009-07-23
      this.newSCH.setEnabled  ( true );
      this.dropSCH.setEnabled ( true );
  } 
  else {
         newDB.setEnabled    ( false );
         dropDB.setEnabled   ( false );
         dataBase.setEnabled ( false );
         // Nick 2009-07-23
         this.newSCH.setEnabled  ( false );
         this.dropSCH.setEnabled ( false );
  }

  newTable.setEnabled  ( state );
  dropTable.setEnabled ( state );
  dumpTable.setEnabled ( state );
  //Nick 2009-07-23
   
  //Nick 2009-07-23
  newView.setEnabled  ( state );
  dropView.setEnabled ( state );
  dumpView.setEnabled ( state );
 
  newTableItem.setEnabled  ( state );
  dropTableItem.setEnabled ( state );
  dumpTableItem.setEnabled ( state );
 }

 /**
  * Metodo addTextLogMonitor
  * Imprime mensajes en el Monitor de Eventos
  */
 void addTextLogMonitor(String msg) {

  LogWin.append ( msg + "\n" );	
  int longiT = LogWin.getDocument().getLength();
  if ( longiT > 0 ) LogWin.setCaretPosition ( longiT - 1 );
 }	
 
 /**
  * METODO connectionLost 
  * Informa que la conexion se ha perdido
  */
 public void connectionLost (String PSQLserver)  {

     // Disconnect(); // Nick 2010-01-29. Temporary solution.
     InterfaceOffLine(); 
     SaveLog ();  // Nick 2010-01-29
     
     JOptionPane.showMessageDialog ( X1.this,
         idiom.getWord ( "DOWSO" ) + PSQLserver + idiom.getWord ( "DOWSO2" ),
         idiom.getWord ( "ERROR!" ), JOptionPane.INFORMATION_MESSAGE 
     ); 
 }
 
 /**
  * METODO InterfaceOffLine
  * 
  */  
 public void InterfaceOffLine () {

   if ( networkLink ) guard.goOut ();

   HostTree ();

   treeView = new JScrollPane ( tree );

   treeView.setMinimumSize   ( new Dimension ( cTREE_VIEW_MIN_W, cTREE_VIEW_MIN_H ) );
   treeView.setPreferredSize ( new Dimension ( cTREE_VIEW_PREF_W, cTREE_VIEW_PREF_H ) );

   splitPpal.setLeftComponent ( treeView );        
   setTitle ( cTITLE ); // Nick  2009-11-22
   
   addTextLogMonitor ( idiom.getWord ( "DISSOF" ) + pgconn.getHostname() +"\n" );

   connected = false;
   
   switchJMenus              ( false );
   connect.setEnabled        ( true  );
   connectItem.setEnabled    ( true  );
   disconnectItem.setEnabled ( false );
   
   activeToolBar         ( false );
   tabbedPane.setEnabled ( false );

   // Nick 2010-02-11 
   structuresPanel.activeToolBar(false);
   structuresPanel.activeIndexPanel(false);
   structuresPanel.setNullTable();

   recordsPanel.activeInterface(false);
   queriesPanel.setNullPanel();
 }

 /** Maneja el evento de tecla presionada **/
 public void keyTyped(KeyEvent e) {
 }

 /** 
  * METODO keyPressed
  * Maneja los eventos de teclas presionadas en el teclado 
  */
 public void keyPressed ( KeyEvent e) {

   int keyCode = e.getKeyCode ();                                                           
   String keySelected = KeyEvent.getKeyText ( keyCode ); //cadena que describe la tecla f�sica presionada

   if ( keySelected.equals ( "Delete" ) ) {  //si la tecla presionada es delete 

       if ( DBComponentType == 0 ) { // Presion� sobre la raiz del arbol de conexi�n, el Servidor   

           GenericQuestionDialog killcon = new GenericQuestionDialog ( X1.this, 
        		   idiom.getWord ("YES"), idiom.getWord ("NO"), idiom.getWord("BOOLDISC"), 
        		   idiom.getWord ("MESGDISC") + " \"" + DBComponentName + "\" ?"  
            );

           if ( killcon.getSelecction () ) {

     	      Disconnect();
       }                                                                                 

       return;                                                                            
       }                                                                                   

     if ( DBComponentType == 1 ) { // DB

         if ( dbNames.size() == 1 ) {

             JOptionPane.showMessageDialog ( X1.this,
                 idiom.getWord ("INVOP"), idiom.getWord ("ERROR!"), 
                 JOptionPane.ERROR_MESSAGE
             );
             return;              
	  }                                            

         GenericQuestionDialog killdb = new GenericQuestionDialog ( X1.this, idiom.getWord("YES"), 
        		 idiom.getWord ("NO"), idiom.getWord ("BOOLDELDB"), idiom.getWord ("MESGDELDB") + 
        		 DBComponentName + "?"
         );

         boolean sure = killdb.getSelecction(); 

         if (sure) {

             int pos =  dbNames.indexOf(DBComponentName);
             PGConnection tempo = (PGConnection) vecConn.remove(pos);
             tempo.close();
             dbNames.remove(pos);
             //Eliminando BD

             String l_instr = cDRP + cDB + cDQU + DBComponentName + cDQU ;
             String result = pgconn.SQL_Instruction ( l_instr );  // Nick 2009-08-04
             addTextLogMonitor ( idiom.getWord ("EXEC") + l_instr + "\"");

             if (result.equals("OK")) {

                 TreePath selPath = tree.getSelectionPath();
                 DefaultMutableTreeNode currentNode = (DefaultMutableTreeNode) (selPath.getLastPathComponent());
                 DefaultMutableTreeNode NodeDB = (DefaultMutableTreeNode) currentNode.getParent();
                 treeModel.removeNodeFromParent (currentNode);
                 addTextLogMonitor ( idiom.getWord ("RES") + result );
              }
             else {
                   String tmp = result.substring ( 0, result.length () - 1 );
                   addTextLogMonitor ( idiom.getWord ( "RES" )+ tmp );
                   JOptionPane.showMessageDialog  ( X1.this, idiom.getWord ("ERRORPOS") + tmp,
                                        idiom.getWord ( "ERROR!" ), JOptionPane.ERROR_MESSAGE
                   );
              }
           }

          return;                                                                            
      }                                                                                   

     if ( DBComponentType == 2 && !DBComponentName.startsWith ( idiom.getWord ( "NOTABLES" ) ) ) { // Table 

         GenericQuestionDialog killtb = new GenericQuestionDialog ( X1.this, idiom.getWord ("YES"),
        		 idiom.getWord ( "NO" ), idiom.getWord ( "BOOLDELTB" ), idiom.getWord ( "MESGDELTB" ) + 
        		 DBComponentName + "?"
         );                                           

         boolean sure = killtb.getSelecction(); 

         if ( sure ) {

             int poss = dbNames.indexOf ( ActiveDataB );
             PGConnection konn = (PGConnection) vecConn.elementAt (poss);

             String result = konn.SQL_Instruction ( "DROP TABLE \"" + DBComponentName + "\"");
             String value = "";

             if ( result.equals ("OK") ) {

                 TreePath selPath = tree.getSelectionPath ();
                 TreePath lastPath = selPath.getParentPath ();
                 DefaultMutableTreeNode currentNode = ( DefaultMutableTreeNode ) (selPath.getLastPathComponent());
                 treeModel.removeNodeFromParent ( currentNode );
                 DefaultMutableTreeNode NodeDB =( DefaultMutableTreeNode ) ( lastPath.getLastPathComponent () );

                 if ( NodeDB.getChildCount() == 0) {

                     DefaultMutableTreeNode nLeaf = new DefaultMutableTreeNode ( idiom.getWord ( "NOOBJECTS" ) );
                     NodeDB.add ( nLeaf );
                  }

                 structuresPanel.setNullTable ();
                 structuresPanel.setLabel ( "", "", "", "" ); // 2009-09-29	
                 
                 recordsPanel.setLabel ( "", "", "", "" );
                 
                 structuresPanel.activeToolBar ( false );
                 structuresPanel.activeIndexPanel ( false );
                 
                 tabbedPane.setEnabledAt ( 0, false );
                 tabbedPane.setEnabledAt ( 1, false );
                 tabbedPane.setSelectedIndex (2);
                 
                 tree.setSelectionPath (lastPath);
              }
             else
                 result = result.substring(0,result.length()-1);

             addTextLogMonitor ( idiom.getWord ("EXEC") + "DROP TABLE \"" + DBComponentName + "\";\"" );
             addTextLogMonitor ( idiom.getWord ("RES") + result );
         }

        return;                                                                            
       }               
    }                                                                                      
 }

 /*
 * METODO keyReleased
 * Maneja el evento de tecla liberada.
 */
 public void keyReleased ( KeyEvent e ) {
 }

 /**
  * METODO focusGained
  * Maneja un foco para los eventos del teclado
  */
 public void focusGained ( FocusEvent e ) {
   Component tmp = e.getComponent (); 
   tmp.addKeyListener ( this );
 }

 /**
  * METODO focusLost
  */
 public void focusLost ( FocusEvent e ) {
   Component tmp = e.getComponent ();
   tmp.removeKeyListener ( this );
 }

 public void mouseClicked ( MouseEvent e ) {
 }
 
 public void mouseReleased ( MouseEvent e ) {
 }

 public void mouseEntered ( MouseEvent e ) {
 }

 public void mouseExited ( MouseEvent e ) {
 }

 /*
  * METODO mousePressed
  * Maneja los eventos cuando se hace click con el mouse 
  */
 public void mousePressed ( MouseEvent e ) {

   treeView.requestFocus ();

   if ( tree.isEditable() ) tree.setEditable ( false );

   // Eventos de un Click con Boton Derecho
   if ( e.getClickCount () == 1 && SwingUtilities.isRightMouseButton ( e ) ) {

         TreePath selPath = tree.getClosestPathForLocation ( e.getX (), e.getY () );
         DefaultMutableTreeNode node = ( DefaultMutableTreeNode ) selPath.getLastPathComponent ();

	 if ( node.isLeaf () && !node.toString ().startsWith ( idiom.getWord ( "NOOBJECTS" ) ) ) {

             if ( !popup.isVisible () ) {

                popup.show ( tree, e.getX (), e.getY () );

                if ( !DBComponentName.equals ( node.toString () ) ) {

                    DBComponentName = node.toString ();
                    tree.setSelectionPath ( selPath );
                    activeNodeTablesViews_4 ( node );
                 }
              }
           }

         if ( !node.isRoot () && !node.isLeaf () ) {

             if ( !popupDB.isVisible () ) {

                popupDB.show ( tree, e.getX (), e.getY () );

                if ( !DBComponentName.equals ( node.toString () ) ) {

                    DBComponentName = node.toString ();
                    tree.setSelectionPath ( selPath );
                    activeNodeDB_1 ( selPath );
                 }
              }
	  }
   } //  e.getClickCount () == 1 && SwingUtilities.isRightMouseButton ( e ) )

   // Eventos de un Click con Boton Izquierdo 
   // Event processing of Click on Left 
   
   if ( e.getClickCount () == 1 && SwingUtilities.isLeftMouseButton (e) ) {

       TreePath selPath = tree.getClosestPathForLocation ( e.getX (), e.getY () );
       
       DefaultMutableTreeNode node = ( DefaultMutableTreeNode ) selPath.getLastPathComponent ();
       // DefaultMutableTreeNode dbnode;    // It is was dispose by Nick 2009/07/02 

       this.setDBComponents ( node );     // Nick 2009-07-09 
       // At here, I know all about DBComponetCurrentLevel,
       //           DBComponentName DBComponentType 
       
       tree.setSelectionPath ( selPath );
       //
       switch ( DBTreeCurrentLevel ) {
         case 0 : // 0 - host ( root of tree )  // DBComponentType = 0
        	this.activeNodeHOST_0 ( selPath ) ;
        	break; // Servidor basa de datos
       
         case 1 : // 1 - databse // DBComponentType = 1
        	      // Si se selecciono una Base de Datos  
        	this.activeNodeDB_1 ( selPath );
    	    break;
    	   
         case 2 : // 2 - scheme // DBComponentType = 2; 
        	this.activeNodeSCH_2 ( selPath );
    	    break;
         
         case 3 : // 3 - table or view ( leaf of tree ) // DBComponentType = 31 or 32
             //     Si se selecciono una Tabla
        	 this.activeNodeObj_3 ( selPath );
   	         break;   	   
         
         case 4 : // 3 - table or view ( leaf of tree )  // DBComponentType = 41 or 42
        	 this.structuresPanel.setDBComponentType ( this.DBComponentType ) ;  // Nick
        	 this.recordsPanel.setDBComponentType ( this.DBComponentType ) ;     // Nick
        	   
        	 this.activeNodeTablesViews_4 ( node );

             int index = this.dbNames.indexOf ( this.ActiveDataB );
             PGConnection connection = ( PGConnection ) this.vecConn.elementAt ( index );

             this.queriesPanel.pgConn = connection;
             this.recordsPanel.setOrder (); //  ORDER BY clause in selection statment. Nick
        	 break;
       } // switch ( DBTreeCurrentLevel ) 
       
       OldCompType = DBComponentType;    
   } // (e.getClickCount() == 1 && SwingUtilities.isLeftMouseButton (e))
 } // end of  Class mousePressed

 /**
  * M�todo writeFile 
  * Sobre escribe el archivo de configuraci�n 
  * usado cuando el usuario quiere guardar un 
  * nuevo idioma
  *   2009-12-08 Some changes were built
  */
 void writeFile ( String idiomName ){

   try {
         ConfigFileReader overWrite = new ConfigFileReader ( configPath, 2 );
         Vector LoginRegisters = overWrite.CompleteList ();

         PrintStream configFile = configFile = new PrintStream(new FileOutputStream ( configPath ));
         configFile.println ( vLANGUAGE + idiomName );

         for ( int i = 0; i < LoginRegisters.size(); i++ ) {

              ConnectionInfo tmp = (ConnectionInfo) LoginRegisters.elementAt(i);
              
              configFile.println ( vSERVER   + tmp.getHost());
              configFile.println ( vDATABASE + tmp.getDatabase());
              configFile.println ( vUSERNAME + tmp.getUser());
              configFile.println ( vPORT     + tmp.getPort());
              configFile.println ( vSSL      + tmp.requireSSL());
              configFile.println ( vLAST     + tmp.getDBChoosed());
          }

         configFile.close();
     }
         catch ( Exception ex ) {

             System.out.println ( "Error: " + ex );
             ex.printStackTrace();
     }
 }

/****************************************************************************
  *   This  method  is able to create one subtree, whick containts two parts: 
  *   list tables an list views.
  *   2009-07-17 Nick Chadaev nick_ch58@list.ru
  *   2012-01-06 Nick Modified
  *   2012-11-11 Nick Another DB objects was added. 
  **/
 DefaultMutableTreeNode createDBTree_34 ( PGConnection p_conn, String p_schema_name ) {

    DefaultMutableTreeNode lLeaf_3;

   Xtables.addAll ( p_conn.getTblNamesVector ( p_schema_name )); 	
   addTextLogMonitor ( idiom.getWord ("EXEC") + p_conn.getSQL() + "\";" );
   
   Xviews.addAll ( p_conn.getViewNamesVector ( p_schema_name )); 	
   addTextLogMonitor ( idiom.getWord ("EXEC") + p_conn.getSQL() + "\";" );
   
   lLeaf_3 = new DefaultMutableTreeNode ( p_schema_name ) ;
   lLeaf_3.add ( CreateLeafList ( this.Xtables, idiom.getWord ( "TABLE" ))) ;
   lLeaf_3.add ( CreateLeafList ( this.Xviews,  idiom.getWord ( "VIEW" ))) ;

   // Nick 2012-11-11
   lLeaf_3.add ( CreateLeafList ( this.Xfunctions , idiom.getWord ( "FNC")));
   lLeaf_3.add ( CreateLeafList ( this.Xdomains   , idiom.getWord ( "DMN")));
   lLeaf_3.add ( CreateLeafList ( this.Xagregates , idiom.getWord ( "AGR")));
   lLeaf_3.add ( CreateLeafList ( this.Xsequences , idiom.getWord ( "SEQ")));
   lLeaf_3.add ( CreateLeafList ( this.Xtypes     , idiom.getWord ( "TYP")));
   lLeaf_3.add ( CreateLeafList ( this.Xcomp_types, idiom.getWord ( "CTP")));
   lLeaf_3.add ( CreateLeafList ( this.Xenum_types, idiom.getWord ( "ENM")));
   lLeaf_3.add ( CreateLeafList ( this.Xoperators , idiom.getWord ( "OPR")));
   lLeaf_3.add ( CreateLeafList ( this.Xtriggers  , idiom.getWord ( "TRG")));
   lLeaf_3.add ( CreateLeafList ( this.Xrules     , idiom.getWord ( "RUL")));

   return lLeaf_3;
 } // fin createDBTree_34
 
 /**
  * M�todo NConnect 
  * Se encarga de realizar las operaciones de conexion
  * -----------------------
  * @version 1.4 2009/07/01
  * @author Nick Chadaev
  * The schemas nodes was added after database name nodes.
  * Each schemas nodes has four child nodes:
  *    - tables
  *    - views
  *    - sequences
  *    - functions  
  */
 void NConnect() {

   LogWin.setText ("");
   boolean fail = true;
   Vector Xschemas = new Vector () ;
   
   boolean lookForOthers = false;  
   
   while ( fail ) { 
          ConnectionDialog connectionForm = new ConnectionDialog ( idiom, LogWin, X1.this, configPath );
          connectionForm.setLanguage ( xlanguage );
          connectionForm.pack();
          connectionForm.setLocationRelativeTo ( X1.this );
          connectionForm.setVisible ( true );

          if ( connectionForm.Connected ()) {

              setCursor ( Cursor.getPredefinedCursor ( Cursor.WAIT_CURSOR )); 
              lookForOthers = connectionForm.lookForOthers ();
              networkLink = connectionForm.checkLink ();
              online = connectionForm.getDataReg (); 
              pgconn = new PGConnection ( online, idiom ); 

              if ( !pgconn.Fail ()) {

                  fail = false;
                  permissions = pgconn.getUserPerm ( online.getUser () );
                  ReConfigFile ( connectionForm.getDataReg (), connectionForm.getConfigRegisters (), 
                		         connectionForm.getRegisterSelected ()
                  );
                } 
               else {
                     setCursor ( Cursor.getPredefinedCursor ( Cursor.DEFAULT_CURSOR ) );
                     ErrorDialog showError = new ErrorDialog ( new JDialog (), 
                    		                     pgconn.getErrorMessage (), idiom 
                     );
                     showError.pack ();
                     showError.setLocationRelativeTo ( X1.this );
                     showError.setVisible(true);
                } // pgconn.Fail () == true
            } // connectionForm.Connected () 
            else 
                   return;
   } // fin while
   addTextLogMonitor ( pgconn.getProductConnected() );  // Nick 2012-07-04
   connected = true;
   Vector listDB = pgconn.getDbNamesVector( false, lookForOthers ) ; // Nick 2012-07-03
   int numDbases = listDB.size();  
   
   addTextLogMonitor ( idiom.getWord ("LOOKDBS") + online.getHost() + "'" );
   addTextLogMonitor ( idiom.getWord ("EXEC") + " " + pgconn.getSQL() + ";\"" );
   addTextLogMonitor ( numDbases + " " + idiom.getWord ("DBON") + online.getHost ());

   if ( numDbases > 0 ) {
       for ( int i = 0; i < numDbases; i++ ) {

            String dbname = GetStr.getStringFromVector ( listDB, i, 0 );                	
            addTextLogMonitor ( idiom.getWord ("TRYCONN") + ": \"" + dbname + "\"... " );
            ConnectionInfo tmp = new ConnectionInfo ( online.getHost (), dbname, online.getUser (), 
            		                 online.getPassword (), online.getPort (), online.requireSSL () 
            ); 
            PGConnection proofConn = new PGConnection ( tmp, idiom ); 

            if ( !proofConn.Fail () ) {

                addTextLogMonitor ( idiom.getWord ( "OKACCESS" ) );
                dbNames.addElement ( dbname );
                vecConn.addElement ( proofConn );
                
                // Nick 2010-03-27  Setting global hash-table. 
               	hashDB.put ( dbname, new Hashtable() );
             } 
            else {
                   addTextLogMonitor ( idiom.getWord ( "NOACCESS" ) ); 
             }
         } //fin for
   } //fin if

   top = new DefaultMutableTreeNode ( online.getHost () );
   numDbases = dbNames.size();
   addTextLogMonitor ( idiom.getWord ("REPORT") + idiom.getWord ("USER ") + pgconn.getUsername() + 
		               idiom.getWord ("VALID") + numDbases + idiom.getWord ("NUMDB")
   );                           
   int index = -1; // Number of current database Nick 2009-07-09

   Xtables.clear(); // Nick 2009-09-30
   Xviews.clear();
   
   for ( int m = 0; m < numDbases; m++ ) {

        String dbname = GetStr.getStringFromVector ( dbNames, m, -1); // Nick 2012-11-11   
        addTextLogMonitor ( idiom.getWord ("DB: ") + dbname );
        
        category1 = new DefaultMutableTreeNode ( dbname );
        top.add ( category1 );

        if ( dbname.equals ( online.getDatabase () ) ) {

            // Nick 2012/06/29
        	Xschemas = pgconn.getSCHVector ();
        	// 2011-11-13 Nick
        	this.ActiveSchema = GetStr.getStringFromVector(Xschemas, 0, 0); // -1 !!! Nick 2012-11-11
        	//
            index = m; // Number of current database Nick 2009-07-09
            Vector OneSchema = Xschemas;
            int numSchema = OneSchema.size();

            // ---------  There is any schema already.  Nick   
            for ( int i = 0; i < numSchema; i++ ) 
                                  category1.add ( createDBTree_34 ( pgconn, GetStr.getStringFromVector(OneSchema, i, 0 ) )) ; // -1 !!! Nick 2012-11-11
 // --------               
        } // dbname.equals ( online.getDatabase ()  
        else {  // Schema node is closed, you will open it.
               globalLeaf = new DefaultMutableTreeNode ( idiom.getWord ( "NOOBJECTS" ) );
               category1.add ( globalLeaf );
         }
   }//fin ciclo for numDbases

   // The nodes was created. Nick 2009/07/02
   
   treeModel = new DefaultTreeModel ( top );
   tree = new JTree ( treeModel );
   tree.getSelectionModel().setSelectionMode ( TreeSelectionModel.SINGLE_TREE_SELECTION );
   tree.setCellRenderer ( renderer );
   tree.expandRow ( 0 );
   tree.expandRow ( index + 1 );
  // tree.setSelectionRow ( index + 1 ); 

   tree.expandRow ( index + 2 );        // Nick 2009-07-09
   tree.setSelectionRow ( index + 3 );  // Root of table sub list was choiced.
   this.DBComponentType = 31 ;
   
   treeView = new JScrollPane ( tree );
   treeView.addFocusListener  ( this );	    
   
   treeView.setMinimumSize   ( new Dimension ( cTREE_VIEW_MIN_W, cTREE_VIEW_MIN_H ));
   treeView.setPreferredSize ( new Dimension ( cTREE_VIEW_PREF_W, cTREE_VIEW_PREF_H )); // 200, 400

   splitPpal.setLeftComponent ( treeView );	       
   splitPpal.setDividerLocation ( cSPLIT_VERT_DIV_LOC ); // 270, 135

   tree.addMouseListener ( this );

   connect.setEnabled ( false );
   connectItem.setEnabled ( false );
   disconnectItem.setEnabled ( true );
   activeToolBar ( true );
   switchJMenus ( true ); //encender los botones requeridos cuando la conexi�n es exitosa

   if ( permissions[0].equals ( "false" ) ) dataBase.setEnabled ( false );
   if ( permissions[1].equals ( "false" ) ) admin.setEnabled ( false );

   tabbedPane.setEnabled ( true );

   tabbedPane.setEnabledAt ( 0, true );
   tabbedPane.setEnabledAt ( 1, true );
   tabbedPane.setEnabledAt ( 2, true );
   
   tabbedPane.setSelectedIndex ( this.ActivedTabbed ); //  Nick

   queriesPanel.setButtons();

   DBComponentName = online.getDatabase();
   DBComponentType = 1; 
   ActiveDataB = DBComponentName;
   
   DBTreeCurrentLevel = 1 ; /* The database */
      
   int pox = dbNames.indexOf (ActiveDataB);
   queriesPanel.pgConn = (PGConnection) vecConn.elementAt(pox);
   queriesPanel.setLabel (ActiveDataB, queriesPanel.pgConn.getOwnerDB() );
   OldCompType = 1;

   String sslEnabled = idiom.getWord ( "DISABLE" );
   if ( online.requireSSL () ) sslEnabled = idiom.getWord ( "ENABLE" );
   
   setTitle ( idiom.getWord ( "UONLINE" )    + pgconn.getUsername() + sTOKEN_20 + 
		      idiom.getWord ( "INFOSERVER" ) + pgconn.getHostname() + sTOKEN_20 + 
		      idiom.getWord ( "DB: " )       + ActiveDataB          + sTOKEN_22 +
		      pgconn.getDbProdName() + cSPACE + pgconn.getVersion() + cSPACE +
		      pgconn.getDB_description ( ActiveDataB ) +
		      sTOKEN_23
   );
   setCursor( Cursor.getPredefinedCursor (Cursor.DEFAULT_CURSOR) );

   // queriesPanel.queryX.requestFocus (); 2009-07-06
               
   String hostname = pgconn.getHostname ();
   int port = pgconn.getPort ();

   if ( networkLink ) {
       guard = new ConnectionWatcher ( hostname, port, X1.this );
       guard.start();
    }
	       
   ChangeListener l = new ChangeListener () {

     public void stateChanged ( ChangeEvent e ) {
     /** 
      *  When I come here ?? 2009-07-06
      * 
      */
       String t_descr = "" ; // 2009-09-29
       int index = 0;
    	 
       if ( DBTreeCurrentLevel <= 3 ) return ;	 
    	 
       int carpeta = tabbedPane.getSelectedIndex ();
       int pox = dbNames.indexOf ( ActiveDataB );
       PGConnection connection;

       if ( pox != -1 ) connection = ( PGConnection ) vecConn.elementAt ( pox );
       else connection = ( PGConnection ) vecConn.elementAt ( 0 );

      // connection.
       
       connection.setDBComponentType ( DBComponentType );
       currentTable = connection.getSpecStrucTable ( DBComponentName, ActiveSchema );

       switch ( carpeta ) {

         case 0 : ActivedTabbed = 0; 
		  indices = connection.getIndexTable ( DBComponentName, ActiveSchema );
          addTextLogMonitor ( idiom.getWord ("EXEC") + connection.getSQL () + "\"" ); 
		  structuresPanel.activeToolBar ( ( DBComponentType == 41 ) ); // true Nick 2009-07-07
		  structuresPanel.activeIndexPanel ( true );

          String result = connection.getOwner ( DBComponentName, ActiveSchema );
          
          if ( DBComponentType == 41 ) t_descr = GetStr.getDescrByName ( Xtables, DBComponentName ); // Table 
            else t_descr = GetStr.getDescrByName ( Xviews, DBComponentName ); // View

          structuresPanel.setLabel ( ActiveDataB, DBComponentName, result, t_descr );
		  structuresPanel.setTableStruct ( currentTable );
		  structuresPanel.setIndexTable ( indices, connection );
		  break; 

         case 1 : ActivedTabbed = 1;
        	
                  recordsPanel.putRecordFilter   ( ActiveDataB, DBComponentName, recordsPanel.getDefRecordFilter() ) ;
                  // recordsPanel.setRecordFilter ( DBComponentName, ActiveDataB ); 2010-03-27 Nick
                  
                  recordsPanel.activeInterface ( true ) ;                    // Nick 2009-07-14
	              recordsPanel.activeToolBar_1( ( DBComponentType == 41 ));  // Nick 2009-07-14
	            	   
                  if ( !recordsPanel.updateTable ( connection, DBComponentName, currentTable )) {

                      tabbedPane.setSelectedIndex (0);
                      ActivedTabbed = 0;

                      indices = connection.getIndexTable ( DBComponentName, ActiveSchema   );
                      addTextLogMonitor ( idiom.getWord ( "EXEC" ) + connection.getSQL() + "\"" );
                      structuresPanel.activeToolBar ( ( DBComponentType == 41 ) ); // Nick true 2009-07-07
                      structuresPanel.activeIndexPanel ( true );
                      String ownerName = connection.getOwner ( DBComponentName, ActiveSchema  );
                     
                      if ( DBComponentType == 41 ) t_descr = GetStr.getDescrByName ( Xtables, DBComponentName ); // Table 
                        else t_descr = GetStr.getDescrByName ( Xviews, DBComponentName ); // View

                      structuresPanel.setLabel ( ActiveDataB, DBComponentName, ownerName, t_descr );
                      structuresPanel.setTableStruct ( currentTable );
                      structuresPanel.setIndexTable  ( indices, connection );
                   }
                  break;

         case 2 : ActivedTabbed = 2;   
                  updateQueriesPanel ( connection.getOwnerDB () );
		  break; 
        }
     } // State Changed
   }; // l is StateChangeListener()

   tabbedPane.addChangeListener (l); 
 }  //End of  NConnect
  /**
   * METODO closePGConnections
   * Cierra todas las conexiones a un servidor
   */ 
   public void closePGSockets() {

      /* ciclo for para cerrar todas la pg_konn activas */
      for ( int p = 0; p < vecConn.size(); p++ ) {
           PGConnection tempo = (PGConnection) vecConn.remove (p);
           tempo.close();
       }
      
      pgconn.close();      
      dbNames = new Vector();
      vecConn = new Vector();
   }
    
 /**
  * METODO Disconnect
  * Desactiva la conexion entre el cliente y el SMBD
  *  2009-06-16
  *     I remove  JOptionPane.showMessageDialog ()
  *     Nick.
  **/ 
  public void Disconnect() {

     closePGSockets();
     InterfaceOffLine();
     SaveLog();
  }

 /**
  * METODO main : SaveLog 
  * Guarda a un archivo la informacion contenida en el Monitor de Eventos 
  * * Nick 2009-11-20: SaveLog becomes "not public"
  */
  private void SaveLog() {

     try {
           String LogName = CFG_NAME_0 + "_" + GetDateTime.DateLogName() + LOG_SUFF; 
  
           PrintStream fileLog = new PrintStream ( 
        		   new FileOutputStream ( 
        			     UHome.getUHome ( OS ) + cLOG_CATALOG + System.getProperty ( cSYS_FILE_SEP ) + LogName 
        		   )
           );
           fileLog.print ( cLOG_BEGIN + startDate + "\n" + "\n" );
           fileLog.print ( LogWin.getText ());
           fileLog.print ( cLOG_END + GetDateTime.DateClassic () );  
           fileLog.close ();
      } 
       catch ( Exception ex ) {

           System.out.println("Error: " + ex);
           ex.printStackTrace();
       }
   } // SaveLog 
  
/*****************************************
 *  Select other databases on this host.
 *  Nick 2009-07-10, 2012-01-06
 ***/
  private void activeNodeHOST_0 ( TreePath selPath ) {
     // Si se selecciono el Servidor de Base de Datos

	  tabbedPane.setSelectedIndex ( 2 ); // 0, 1 Nick 2009-07-10
      this.ActivedTabbed = 0; 

 	 if ( OldCompType != DBComponentType ) {

          structuresPanel.setNullTable    ();
          structuresPanel.setLabel        ( "", "", "", "" );
          structuresPanel.activeToolBar   ( false );
          structuresPanel.activeIndexPanel( false );

          recordsPanel.setLabel ( "", "", "", "" ) ;  // Nick 2009-07-10
          recordsPanel.activeInterface ( false ) ;   
          
          queriesPanel.setNullPanel ();
          queriesPanel.setTextLabel ( idiom.getWord ( "NODBSEL" ) );

          tabbedPane.setEnabledAt ( 0, false );
          tabbedPane.setEnabledAt ( 1, false );
          tabbedPane.setEnabledAt ( 2, false );
          
          ActiveDataB = "";
     }

      GenericQuestionDialog scanDb = 
     	 new GenericQuestionDialog ( X1.this, idiom.getWord ( "YES" ), idiom.getWord ( "NO" ), 
     			 idiom.getWord ( "DBSCAN" ), idiom.getWord ( "DYWLOOK" ) 
      );

      boolean sure = scanDb.getSelecction ();

      /**
       * The process of scanning of host's database started.
       */
      if ( !sure ) return ;

      setCursor ( Cursor.getPredefinedCursor ( Cursor.WAIT_CURSOR ) );
      query.setEnabled ( false );

      //Consultando nombres de BD en el servidor 
      Vector listDB = pgconn.getDbNamesVector ( false, true ); // Nick 2012-07-03 
      addTextLogMonitor ( idiom.getWord ( "EXEC" ) + pgconn.getSQL() + ";\"" );
      
      Vector newsDB = new Vector ();

      for ( int p = 0; p < listDB.size (); p++ ) {
              String db = GetStr.getStringFromVector ( listDB, p, 0 ); // -1 !!! Nick 2012-01-06
              if ( !dbNames.contains ( db ) ) newsDB.addElement ( db );
      }

      if ( newsDB.size () > 0 ) {

          UpdateDBTree updateDBs = new UpdateDBTree ( LogWin, idiom, pgconn, newsDB );
          Vector dbases = updateDBs.getDatabases (); // 2012-06-21

          if ( dbases.size () > 0 ) {

           Vector tmpConn = updateDBs.vecConn;
           for ( int p = 0; p < dbases.size (); p++ ) {

        	      String db = GetStr.getStringFromVector ( dbases, p, 0 ); // -1 !!! Nick 2012-01-06;

                   PGConnection tmpDB = ( PGConnection ) tmpConn.elementAt ( p );
                   vecConn.addElement ( tmpDB ); 
                   dbNames.addElement ( db );

                   DefaultMutableTreeNode dbLeaf   = new DefaultMutableTreeNode ( db );
                   DefaultMutableTreeNode noTables = new DefaultMutableTreeNode ( idiom.getWord ("NOOBJECTS") );
                   dbLeaf.add ( noTables );

                   DefaultMutableTreeNode parent = ( DefaultMutableTreeNode ) treeModel.getRoot ();
                   treeModel.insertNodeInto ( dbLeaf, parent, parent.getChildCount ());
               } // fin for
           } // fin if dbases.size
      } // fin if newsDB.size

     setCursor ( Cursor.getPredefinedCursor ( Cursor.DEFAULT_CURSOR ) );

     if ( !tree.isExpanded ( selPath ) ) tree.expandPath ( selPath );

  }
  /************************************************************
   *   The mouse left button was pressed. This method recreate
   *   the tree of DB objects.     Nick 2009-07-02, 2012-01-06 
   ************************************************************/
   private void activeNodeDB_1 ( TreePath selPath ) {

       // Nick 2009-07-09 
	   Vector Xschemas = new Vector ();
	   
	   DefaultMutableTreeNode node;	   
	   node = ( DefaultMutableTreeNode ) selPath.getLastPathComponent ();
       this.setDBComponents ( node );	   
	   
       this.DBComponentName = node.toString ();
       this.ActivedTabbed = 2; 
       tabbedPane.setSelectedIndex ( this.ActivedTabbed ); // 0, 1 Nick 2009-07-10
       
       queriesPanel.setTextAreaEditable ();
       if ( !query.isEnabled () ) query.setEnabled ( true );

       if ( OldCompType == 0 || !queriesPanel.functions.isEnabled ()) {
               // Nick 2009-07-10
    	       structuresPanel.setNullTable    ();
    	       structuresPanel.setLabel        ( "", "", "", "" );
    	       structuresPanel.activeToolBar   ( false );
    	       structuresPanel.activeIndexPanel( false );

    	       recordsPanel.setLabel ( "", "", "", "" ) ;  // Nick 2009-07-10
    	       recordsPanel.activeInterface ( false ) ;   
    	          
    	       queriesPanel.setNullPanel ();
    	       queriesPanel.setTextLabel ( idiom.getWord ( "NODBSEL" ) );

    	       // Nick 2009-07-10
    	       tabbedPane.setEnabledAt ( 0, false ); // true, false
    	       tabbedPane.setEnabledAt ( 1, false ); // true, false
    	       tabbedPane.setEnabledAt ( 2, true ); // false
    	       
               queriesPanel.queryX.setEditable   ( true );
               queriesPanel.functions.setEnabled ( true );
               queriesPanel.loadQuery.setEnabled ( true );
               queriesPanel.hqQuery.setEnabled   ( true );
       }

       ActiveDataB = DBComponentName;

       int index = dbNames.indexOf ( ActiveDataB );
       PGConnection konn = ( PGConnection ) vecConn.elementAt ( index );
 
       // Nick 2009-12-14 
       setTitle ( idiom.getWord ( "UONLINE" ) + konn.getUsername() + sTOKEN_20 + 
		  idiom.getWord ( "INFOSERVER" )  + konn.getHostname() + sTOKEN_20 + 
		  idiom.getWord ( "DB: " )        + ActiveDataB        + sTOKEN_22 +
		  konn.getDbProdName() + cSPACE + konn.getVersion() + cSPACE +
	      konn.getDB_description ( ActiveDataB ) +
	      sTOKEN_23
       );
       
       this.pgconn = konn ; // Nick 2010-05-04
       queriesPanel.pgConn = konn;
       queriesPanel.setLabel ( ActiveDataB, konn.getOwnerDB () ); // was connected. Nick

       // Consultando nombres de tablas de una BD, sin incluir tablas del sistema
       // No, my girls, we have to go different way. Nick
       Xschemas.removeAllElements();
       // Xschemas = getVector.getSCHVector ( konn ) ;
       Xschemas = konn.getSCHVector(); // 2012-06-29
       
       // First schema is active schema :) dbases
       this.ActiveSchema = GetStr.getStringFromVector(Xschemas, 0, 0); // -1 !!! Nick
       
       Vector OneSchema = Xschemas;
       int numSchema = OneSchema.size();
       node.removeAllChildren ();  
 
       Xtables.clear(); // 2009-09-30 Nick 
       Xviews.clear();
       for ( int k = 0; k < numSchema; k++ ) 
    	                            node.add ( createDBTree_34 ( konn, GetStr.getStringFromVector ( OneSchema, k, 0 ))); // -1 !!! Nick
       
       treeModel.nodeStructureChanged ( node );
       if ( !tree.isExpanded ( selPath ) )
    	      tree.expandPath ( selPath );
       else
    	   tree.collapsePath ( selPath );
       
   }  // end of activeNodeDB_1

   private void activeNodeSCH_2 ( TreePath selPath ) {
  /* **********************************************************
   *   The mouse left button was pressed. This method recreate
   *   the tree of Schema objects. Nick 2009-07-02, 2012-01-06 
   ************************************************************/
	 
	DefaultMutableTreeNode dbnode, schema_node;	   
	
	schema_node = ( DefaultMutableTreeNode ) selPath.getLastPathComponent ();
	dbnode = ( DefaultMutableTreeNode ) schema_node.getParent ();  // Schema is now, Nick

    this.setDBComponents ( schema_node ) ;
    this.ActiveDataB = dbnode.toString ();
	this.DBComponentName = schema_node.toString (); 
    this.ActiveSchema = schema_node.toString (); // Nick 2012-01-06 
	
    schema_node.removeAllChildren ();
	
	this.ActivedTabbed = 2 ;
	tabbedPane.setSelectedIndex ( this.ActivedTabbed ); // 0, 1  Nick 2009-07-17
	queriesPanel.setTextAreaEditable ();

	if ( !query.isEnabled () ) query.setEnabled ( true );

	if ( OldCompType == 0 || !queriesPanel.functions.isEnabled ()) {
           tabbedPane.setEnabledAt ( 1, true );

	       structuresPanel.setNullTable    ();
	       structuresPanel.setLabel        ( "", "", "", "" );
	       structuresPanel.activeToolBar   ( false );
	       structuresPanel.activeIndexPanel( false );

	       recordsPanel.setLabel ( "", "", "", "" ) ;  // Nick 2009-07-10
	       recordsPanel.activeInterface ( false ) ;   
	          
	       queriesPanel.setNullPanel ();
	       queriesPanel.setTextLabel ( idiom.getWord ( "NODBSEL" ) );

	       // Nick 2009-07-10
	       tabbedPane.setEnabledAt ( 0, false ); // true, false
	       tabbedPane.setEnabledAt ( 1, false ); // true, false
	       tabbedPane.setEnabledAt ( 2, true ); // false
	       
           queriesPanel.queryX.setEditable   ( true );
           queriesPanel.functions.setEnabled ( true );
           queriesPanel.loadQuery.setEnabled ( true );
           queriesPanel.hqQuery.setEnabled   ( true );
	}

	int index = dbNames.indexOf ( ActiveDataB ); 
    PGConnection konn = ( PGConnection ) vecConn.elementAt ( index );
    queriesPanel.pgConn = konn;
    queriesPanel.setLabel ( ActiveDataB, konn.getOwnerDB () );
    
    // Nick 2009-07-10
    structuresPanel.setNullTable    ();
    structuresPanel.setLabel        ( "", "", "", "" ); // Nick 2009-09-29
    structuresPanel.activeToolBar   ( false );
    structuresPanel.activeIndexPanel( false );

    recordsPanel.setLabel ( "", "", "", "" ) ;  // Nick 2009-07-10
    recordsPanel.activeInterface ( false ) ;   

    /**************************************************************************
     * I don't know about replacing tree's node which make event processing at  
     *   this moment, so I paste here code from createDBTree_34 method. Nick.
     *   2009-07-17. 
     *   2009-09-29.  Was modified, new SQL instructions.
     */
    Vector l_Xtables ;
    Vector l_Xviews ;
    //
    Vector l_Xfunctions;
    Vector l_Xdomains;
    Vector l_Xagregates;
    Vector l_Xsequences;
    Vector l_Xtypes;
    Vector l_Xcomp_types;
    Vector l_Xenum_types;
    Vector l_Xoperators;
    Vector l_Xtriggers;
    Vector l_Xrules;
    //
    // Nick 2013-06-08
    //
    l_Xtables =  konn.getTblNamesVector ( this.DBComponentName ); 	
    addTextLogMonitor ( idiom.getWord ("EXEC") + konn.getSQL() + "\";" );
    
    int numTables = l_Xtables.size ();

    l_Xviews =  konn.getViewNamesVector ( this.DBComponentName ); 	
    addTextLogMonitor ( idiom.getWord ("EXEC") + konn.getSQL() + "\";" );
    
    int numViews = l_Xviews.size ();
    // 
    // Nick 2013-06-08
    l_Xfunctions  = new Vector ();
    l_Xdomains    = new Vector ();
    l_Xagregates  = new Vector ();
    l_Xsequences  = new Vector ();
    l_Xtypes      = new Vector ();
    l_Xcomp_types = new Vector ();
    l_Xenum_types = new Vector ();
    l_Xoperators  = new Vector ();
    l_Xtriggers   = new Vector ();
    l_Xrules      = new Vector ();
    //
    schema_node.add ( CreateLeafList ( l_Xtables, idiom.getWord ( "TABLE" ))) ;
    schema_node.add ( CreateLeafList ( l_Xviews,  idiom.getWord ( "VIEW" ))) ;
    
    Xtables = ReplaceKnots ( numTables, l_Xtables, Xtables ) ;
    Xviews = ReplaceKnots ( numViews, l_Xviews, Xviews ) ;
 
    // Nick 2012-11-11
    schema_node.add ( CreateLeafList ( l_Xfunctions , idiom.getWord ( "FNC")));
    schema_node.add ( CreateLeafList ( l_Xdomains   , idiom.getWord ( "DMN")));
    schema_node.add ( CreateLeafList ( l_Xagregates , idiom.getWord ( "AGR")));
    schema_node.add ( CreateLeafList ( l_Xsequences , idiom.getWord ( "SEQ")));
    schema_node.add ( CreateLeafList ( l_Xtypes     , idiom.getWord ( "TYP")));
    schema_node.add ( CreateLeafList ( l_Xcomp_types, idiom.getWord ( "CTP")));
    schema_node.add ( CreateLeafList ( l_Xenum_types, idiom.getWord ( "ENM")));
    schema_node.add ( CreateLeafList ( l_Xoperators , idiom.getWord ( "OPR")));
    schema_node.add ( CreateLeafList ( l_Xtriggers  , idiom.getWord ( "TRG")));
    schema_node.add ( CreateLeafList ( l_Xrules     , idiom.getWord ( "RUL")));
    //
    //Nick 2013-06-08
    Xfunctions  = ReplaceKnots ( 0, l_Xfunctions,  Xfunctions );
    Xdomains    = ReplaceKnots ( 0, l_Xdomains,    Xdomains );
    Xagregates  = ReplaceKnots ( 0, l_Xagregates,  Xagregates );
    Xsequences  = ReplaceKnots ( 0, l_Xsequences,  Xsequences );
    Xtypes      = ReplaceKnots ( 0, l_Xtypes,      Xtypes );
    Xcomp_types = ReplaceKnots ( 0, l_Xcomp_types, Xcomp_types ) ;
    Xoperators  = ReplaceKnots ( 0, l_Xoperators,  Xoperators ) ;
    Xtriggers   = ReplaceKnots ( 0, l_Xtriggers,   Xtriggers ) ;
    Xrules      = ReplaceKnots ( 0, l_Xrules,      Xrules ) ;
    
    /**************************************************************************/
    
    treeModel.nodeStructureChanged ( schema_node );
    
    if ( !tree.isExpanded ( selPath ) )
 	      tree.expandPath ( selPath );
     else
	      tree.collapsePath ( selPath );
    
   }  // end of activeNodeSCH_2
   
   private void activeNodeObj_3 ( TreePath selPath ) {
   /************************************************************
    *    Was modified  2009/07/03 Nick
    *                  2012-01-06 Nick
	****/   
        DefaultMutableTreeNode dbnode, schema_node, node;
        node = ( DefaultMutableTreeNode ) selPath.getLastPathComponent ();

        this.setDBComponents ( node );
        schema_node = ( DefaultMutableTreeNode ) node.getParent ();
        String schema_name = schema_node.toString (); 
        
        dbnode = ( DefaultMutableTreeNode ) node.getParent ();  // Schema is now, Nick
        dbnode = ( DefaultMutableTreeNode ) dbnode.getParent();

        ActiveDataB = dbnode.toString ();
        ActiveSchema = schema_name ; // Nickn 2012-01-06
        
        int index = dbNames.indexOf ( ActiveDataB );
        PGConnection konn = ( PGConnection ) vecConn.elementAt ( index );

    	this.ActivedTabbed = 2 ;
    	tabbedPane.setSelectedIndex ( this.ActivedTabbed ); // 0, 1  Nick 2009-07-17
 
        // Nick 2009-07-10
	    structuresPanel.setNullTable     ();
	    structuresPanel.setLabel         ( "", "", "", "" ); // Nick 2009-09-29
	    structuresPanel.activeToolBar    ( false );
	    structuresPanel.activeIndexPanel ( false );

        recordsPanel.setLabel ( "", "", "", "" ) ;  // Nick 2009-07-10
	    recordsPanel.activeInterface ( false ) ;   
        
        queriesPanel.setNullPanel ();
	    queriesPanel.setTextLabel ( idiom.getWord ( "NODBSEL" ) );

	    // Nick 2009-07-10
	    tabbedPane.setEnabledAt ( 0, false ); // true, false
	    tabbedPane.setEnabledAt ( 1, false ); // true, false
	    tabbedPane.setEnabledAt ( 2, true ); // false
	       
        queriesPanel.queryX.setEditable   ( true );
        queriesPanel.functions.setEnabled ( true );
        queriesPanel.loadQuery.setEnabled ( true );
        queriesPanel.hqQuery.setEnabled   ( true );

        queriesPanel.setLabel ( ActiveDataB, konn.getOwnerDB () ); // was connected. Nick

	    if ( !tree.isExpanded ( selPath ) )
		      tree.expandPath ( selPath );
	    else
		      tree.collapsePath ( selPath );
    } // end of activeNodeObj_3
   
    private void activeNodeTablesViews_4 ( DefaultMutableTreeNode node ) {
	/****************************************************************
	 *    Was modified  2009/07/03  Nick
	 *                  2012-01-06  Nick
	 ***/   
            String t_descr = "";
	   
	        this.setDBComponents ( node ); // Do it twice, Nick 2009-07-10
	        DefaultMutableTreeNode dbnode, schema_node;
	        
	        schema_node = ( DefaultMutableTreeNode ) node.getParent ();
	        schema_node = ( DefaultMutableTreeNode ) schema_node.getParent ();
	        ActiveSchema = schema_node.toString (); 
	        
	        dbnode = ( DefaultMutableTreeNode ) schema_node.getParent ();   
	        ActiveDataB = dbnode.toString ();

	        tabbedPane.setSelectedIndex ( ActivedTabbed ); // 1 Nick 2009-07-10

	        // The table was selected, the database name ( ActiveDataB ) was defined,
	        //     the schema name will defined into getSpecStrucTable ().  Nick.
	        
	       // if ( OldCompType == 0 ) { // Start  ??????
           //
	       //     tabbedPane.setEnabledAt ( 1, true );
	       //     queriesPanel.functions.setEnabled ( true );
	       //     queriesPanel.loadQuery.setEnabled ( true );
	       // }

	        int index = dbNames.indexOf ( ActiveDataB );
	        PGConnection connection = ( PGConnection ) vecConn.elementAt ( index );

	        if ( !DBComponentName.startsWith ( idiom.getWord ( "NOOBJECTS" ))) { // NOTABLES Nick 2009-07-17

	            queriesPanel.setTextAreaEditable ();

	            if ( !query.isEnabled () ) query.setEnabled ( true );

	            connection.setDBComponentType ( this.DBComponentType ); // Twice 
	            
	            currentTable = connection.getSpecStrucTable ( DBComponentName, ActiveSchema );
	            indices = connection.getIndexTable (DBComponentName, ActiveSchema);
	            tabbedPane.setEnabledAt ( 0, true );
	            tabbedPane.setEnabledAt ( 1, true );
	            
	            // Adicion temporal
	            tabbedPane.setEnabledAt ( 2, true );
	            structuresPanel.updateUI ();

	            if ( ActivedTabbed == 0 ) { // The Structure Panel

	                structuresPanel.activeToolBar    ( ( DBComponentType == 41 ) ); // true Nick 2009-07-07
	                structuresPanel.activeIndexPanel ( ( DBComponentType == 41 ) ); // true Nick 2009-07-07
	                
	                String result = connection.getOwner ( DBComponentName, ActiveSchema );

	                if ( DBComponentType == 41 ) t_descr = GetStr.getDescrByName ( Xtables, DBComponentName ); // Table 
	                  else t_descr = GetStr.getDescrByName ( Xviews, DBComponentName ); // View
	                
	                structuresPanel.setLabel       ( ActiveDataB, DBComponentName, result, t_descr );
	                structuresPanel.setTableStruct ( currentTable );       // Structure was displayed
	                structuresPanel.setIndexTable  ( indices, connection );
	            }

	            if ( ActivedTabbed == 1 ) { // Records 
	            	this.recordsPanel.activeInterface ( true ) ;
	            	this.recordsPanel.activeToolBar_1( ( DBComponentType == 41 ));
                    	            	
	                recordsPanel.putRecordFilter   ( ActiveDataB, DBComponentName, recordsPanel.getDefRecordFilter() ) ;
	                // recordsPanel.setRecordFilter ( DBComponentName, ActiveDataB ); Nick 2010-03-27
	                /************************************************************************** 
	                 * if (!evaluatedDB.contains ( DBComponentName ) ) {
	                     currentTable.setSchema ( connection.getSchemaName ( DBComponentName ) );
	                     currentTable.setSchemaType ( connection.gotUserSchema ( DBComponentName));
	                     evaluatedDB.addElement ( DBComponentName );
	                 } */

	                if ( !recordsPanel.updateTable ( connection, DBComponentName, currentTable )) {

	                	// We are going to back on structure panel.
	                    tabbedPane.setSelectedIndex (0);
	                    ActivedTabbed = 0;

	                    structuresPanel.activeToolBar    ( ( DBComponentType == 41 ) ); // true Nick 2009-07-07
	                    structuresPanel.activeIndexPanel ( ( DBComponentType == 41 ) ); // true Nick 2009-07-10

	                    String result = connection.getOwner ( DBComponentName, ActiveSchema );
		                if ( DBComponentType == 41 ) t_descr = GetStr.getDescrByName ( Xtables, DBComponentName ); // Table 
		                  else t_descr = GetStr.getDescrByName ( Xviews, DBComponentName ); // View

	                    structuresPanel.setLabel ( ActiveDataB, DBComponentName, result, t_descr );
	                    structuresPanel.setTableStruct ( currentTable );
	                    structuresPanel.setIndexTable  ( indices, connection );
	                 }
	             }

	            if ( ActivedTabbed == 2 ) { // Queries
	                updateQueriesPanel ( connection.getOwnerDB () );
	            } 
	         }     // DBComponentName.startsWith ( idiom.getWord ( "NOOBJECTS" ) ) == true
	         else {
	                if ( ActivedTabbed == 0 ) ActivedTabbed = 2;  // 1 Nick
	                if ( ActivedTabbed == 1 ) ActivedTabbed = 2;  // 1 Nick
	                if ( ActivedTabbed == 2 ) queriesPanel.setLabel ( ActiveDataB,connection.getOwnerDB () );

	                tabbedPane.setSelectedIndex ( ActivedTabbed ); // Nick
	                tabbedPane.setEnabledAt ( 0, false ); 
	                tabbedPane.setEnabledAt ( 1, false );
	          }
	} // end of activeNodeTablesViews_4

  /**
   * Nick 2013-06-02
   * @return
   */
  private Language getIdiom() {

   return idiom;
  }

  public void updateQueriesPanel(String owner) {

    queriesPanel.setLabel(ActiveDataB,owner);

    queriesPanel.functions.setEnabled(true);
    queriesPanel.loadQuery.setEnabled(true);
    queriesPanel.hqQuery.setEnabled(true);
    queriesPanel.saveQuery.setEnabled(false);
    queriesPanel.runQuery.setEnabled(false);
    queriesPanel.queryX.requestFocus();

    String currString = queriesPanel.getStringQuery();

    if (currString.length() > 1) {

        queriesPanel.newQuery.setEnabled(true);

        if (currString.length() > 15) {
            queriesPanel.saveQuery.setEnabled(true);
            queriesPanel.runQuery.setEnabled(true);
         }
     }
    else {
           queriesPanel.newQuery.setEnabled(false);
     }
  }
  
  /**
   * METODO isConnected
   * Retorna verdadero si la conexion esta activa
   */
 public boolean isConnected() {
   return connected; 	
 }
/************************************************************* 
 * 2009-07-09  Nick. Define DBComponent name and type.
 *************************************************************/ 
 public void setDBComponents ( DefaultMutableTreeNode node ) {

	 String l_str = "";
	 
	 this.DBComponentName = node.toString ();
	 this.DBTreeCurrentLevel = node.getLevel();
	 /*********************************************************
	  *  0 - HOST, then 
	  *       DBComponentName = 'hostname'
	  *       DBComponentType = 0
	  *  ---------------------------------
	  *  1 - DATABASE, then      
	  *       DBComponentName = 'database'
	  *       DBComponentType = 1
	  *  ---------------------------------
	  *  2 - SCHEMA, then      
	  *       DBComponentName = 'schemename'
	  *       DBComponentType = 2
	  *  -------------------------------------------------------
	  *  3 - SCHEMA object type, then      
	  *       DBComponentName = 'Tables(xx)' or 'Views(xx)'
	  *       DBComponentType = 31  or 32
	  *  -------------------------------------------------------
	  *  4 - OBJECT NAME ( Table or View), then      
	  *       DBComponentName = '<Table name>' or '<Views name>'
	  *       DBComponentType = 41  or 42
	  ***********************************************************/
     switch ( this.DBTreeCurrentLevel ) {
       
       case 0 : //  host ( root of tree )
                this.DBComponentType = 0;
    	        break;
       
       case 1 : //  DATABASE
    	        this.DBComponentType = 1;
    	        break;
       
       case 2 : //  SCHEMA
    	        this.DBComponentType = 2;
    	        break;
       
       case 3 : // SCHEMA object type, then
             	   DBComponentType = 31; // The table's  list
    	           if (!( DBComponentName.indexOf ( idiom.getWord ( "VIEW" ) ) == -1 )) 
    	        	         DBComponentType = 32;
    	        break;
       
       case 4 : // OBJECT NAME ( Table or View)
    	           l_str = node.getParent().toString() ;
    	           DBComponentType = 41; // The table
    	           if (!( l_str.indexOf ( idiom.getWord ( "VIEW" ) ) == -1 )) 
    	        	         DBComponentType = 42 ;
    	        break;
     }  
 }

 /********************
  *  2009-09-30 Nick
  */

 private DefaultMutableTreeNode CreateLeafList ( Vector p_Objects, String pk_word1 ) 
 {
    DefaultMutableTreeNode lLeaf_4;
    int numObjects = 0;

    numObjects = p_Objects.size ();

    lLeaf_4 = new DefaultMutableTreeNode ( pk_word1 + " (" +  
                  Integer.toString ( numObjects ) + ")" );

    for ( int k = 0; k < numObjects; k++ ) 
              lLeaf_4.add ( new DefaultMutableTreeNode ( GetStr.getStringFromVector ( p_Objects, k, 0 ))); // -1 !!! Nick


    return lLeaf_4 ;

 } // CreateLeafList
 /******************
  * 2009-09-30 Nick 
  */ 
 private Vector ReplaceKnots ( int p_numObj, Vector p_locVector, Vector p_globVector ) {

    boolean ll = false ; 
    for ( int i = 0; i < p_numObj; i++ ) { 
    	    ll = p_globVector.remove( p_locVector.elementAt (i) ) ;  
    }
    p_globVector.addAll ( p_locVector ) ;

    return p_globVector ;
 }

 /**
  * METODO main : PRINCIPAL
  * Crea un nuevo objeto X1 que inicializa la aplicaci�n
  */
 public static void main ( String arg [] ) {
   // Nick 2009_06_16  Let's begin :)
   final X1 program = new X1 ();
   program.setDefaultCloseOperation ( DO_NOTHING_ON_CLOSE );

   // Cierra la aplicacion cuando se hace clic en la X del Frame
   WindowListener l = new WindowAdapter () {    					                        
     
	 public void windowClosing ( WindowEvent e ) {

      GenericQuestionDialog killX = new GenericQuestionDialog ( program, 
    		  program.getIdiom ().getWord ( "OK" ),
    		  program.getIdiom ().getWord ( "CANCEL" ), 
    		  program.getIdiom ().getWord ( "BOOLEXIT" ),
    		  program.getIdiom ().getWord ( "QUESTEXIT" )
      );

      if ( killX.getSelecction () ) { 
      	  if ( program.isConnected () ) {
                                          program.SaveLog        ();
           	                              program.closePGSockets ();
                  }
           	      System.exit (0);
       } 
        else 
             return;
      } // windowClosing
   }; 
   program.addWindowListener (l);
   program.NConnect ();
 }
}
