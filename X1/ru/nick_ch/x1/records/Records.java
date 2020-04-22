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
 *  CLASS   @version 1.0  
 *    This class is responsible for managing the Record panel
 *    In the main interface. Through this panel,
 *    can perform operations such as input, modify and
 *    Delete records from a table. This is ugly thing.
 * 
 *  History:
 *     2009/07/01, OIDs were removed.
 *      2010/01/09, start refactoring.  
 *           
 */
 
package ru.nick_ch.x1.records;

import java.awt.BorderLayout;
import java.awt.Color;
import java.awt.Component;
import java.awt.Cursor;
import java.awt.Dimension;
import java.awt.FlowLayout;
import java.awt.Font;
import java.awt.Toolkit;
import java.awt.event.ActionListener;
import java.awt.event.FocusEvent;
import java.awt.event.FocusListener;
import java.awt.event.ItemEvent;
import java.awt.event.ItemListener;
import java.awt.event.KeyEvent;
import java.awt.event.KeyListener;
import java.awt.event.MouseAdapter;
import java.awt.event.MouseEvent;
import java.awt.event.MouseListener;
import java.io.BufferedReader;
import java.io.File;
import java.io.FileOutputStream;
import java.io.FileReader;
import java.io.PrintStream;
import java.net.URL;
import java.util.Hashtable;
import java.util.StringTokenizer;
import java.util.Vector;

import javax.swing.BorderFactory;
import javax.swing.BoxLayout;
import javax.swing.ImageIcon;
import javax.swing.JButton;
import javax.swing.JCheckBox;
import javax.swing.JComboBox;
import javax.swing.JDialog;
import javax.swing.JFileChooser;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JMenuItem;
import javax.swing.JOptionPane;
import javax.swing.JPanel;
import javax.swing.JPopupMenu;
import javax.swing.JScrollPane;
import javax.swing.JTable;
import javax.swing.JTextArea;
import javax.swing.JTextField;
import javax.swing.JToolBar;
import javax.swing.SwingConstants;
import javax.swing.SwingUtilities;
import javax.swing.border.Border;
import javax.swing.border.TitledBorder;
import javax.swing.table.AbstractTableModel;
import javax.swing.table.DefaultTableCellRenderer;
import javax.swing.table.TableColumn;

import ru.nick_ch.x1.db.PGConnection;
import ru.nick_ch.x1.db.Table;
import ru.nick_ch.x1.db.TableHeader;
import ru.nick_ch.x1.idiom.Language;
import ru.nick_ch.x1.misc.input.ErrorDialog;
import ru.nick_ch.x1.misc.input.ExportSeparatorField;
import ru.nick_ch.x1.misc.input.ExportToFile;
import ru.nick_ch.x1.misc.input.GenericQuestionDialog;
import ru.nick_ch.x1.misc.input.ImportSeparatorField;
import ru.nick_ch.x1.misc.resultset.AdvancedFilter;
import ru.nick_ch.x1.misc.resultset.CustomizeFilter;
import ru.nick_ch.x1.misc.resultset.DropTableRecord;
import ru.nick_ch.x1.misc.resultset.UpdateRecord;
import ru.nick_ch.x1.misc.resultset.UpdateTable;
import ru.nick_ch.x1.report.ExportToReport;
import ru.nick_ch.x1.report.ReportDesigner;
import ru.nick_ch.x1.misc.file.File_consts; // Nick 2009-11-22

public class Records extends JPanel implements ActionListener, SwingConstants, KeyListener, 
                                               FocusListener, Records_consts, File_consts  {

 JToolBar    StructureBar;
 JPanel      General;

 Language    idiom;
 
 JTextField  title;
 JScrollPane windowX;
 JPanel      firstPanel;
 JPanel      base;
 JButton     insertRecord, delRecord, updateRecord, exportFile, reportBut;
 JCheckBox   rectangle, rectangle2;
 JComboBox   combo1, combo2;
 JTextField  combo3, numRegTextField, limitText; 
 JLabel      men1, men2;
 JButton     button, advanced;
 JTable      table;
 JPanel      up;
 JFrame      frame;

 final JButton queryB;
 final JButton queryLeft;
 final JButton queryRight;
 final JButton queryF;

 JTextField onScreen = new JTextField ();
 JTextField onTable  = new JTextField ();
 JTextField onMem    = new JTextField ();
 
 JTextField currentStatistic = new JTextField ();

 boolean firstBool = true;

 String currentTable = "";
 String oldTable     = "";
 String operator     = "";
 String field        = "";
 
 Table tableStruct;
 
 PGConnection connReg;
 
 final JPopupMenu popup = new JPopupMenu ();

 String  sentence  = "";
 String  where     = "";

 boolean refreshOn = false;

 int numReg      =  0;
 int totalReg    =  0;
 int recIM       =  0; 
 int nPages      =  0;
 int indexMin    =  1;
 int indexMax    =  C_INDEX_MAX;   // 50      // Nick 2010/01/12
 int currentPage =  1;
 int oldPage     =  0;
 int oldMem      =  0;
 int start       =  0;
 int limit       =  C_LIMIT;       // 50      // Nick 2010/01/12

 String firstField;
 
/* Very important Nick 2009-07-02 */
// String recordFilter = "\"oid\"," + "*";
// String orderBy = "oid";
 
 String recordFilter = "*";
 String orderBy = "1";
 
 // Hashtable hashRecordFilter = new Hashtable();
 Hashtable hashDB ; // = new Hashtable();
 
 MyTableModel myModel;

 Vector columnNamesVector = new Vector();

 Object[]   columnNames;
 Object[][] data;

 JTextArea LogWin;

 boolean firstTime = true;
 boolean connected = true;

 String realTableName;
 int DBComponentType = 41; // Nick 2009-07-07. It has to be: 41 - any table, 42 - any view 
                           //                  See setDBComponentType ( int ) method on bottom.  

 InsertData insert ; // Nick 2010-02-02

 String head1 ; 
 String head2 ; 

 boolean swc ; // Nick 2010-02-13  Field's Comments instead field's names. 
 
 /******************** METODO CONSTRUCTOR ********************/
 public Records ( JFrame xframe, Language glossary, JTextArea log, boolean p_sw, boolean p_swc,
		          Hashtable p_hashDB ) {

  frame  = xframe;
  idiom  = glossary;
  LogWin = log;

  swc    = p_swc ;    // Nick 2010-02-13 
  hashDB = p_hashDB ; // Nick 2010-02-26  
  
  setLayout ( new BorderLayout () );
  StructureBar = new JToolBar ( SwingConstants.VERTICAL );
  StructureBar.setFloatable ( false );
  CreateToolBar ();

  Border etched1 = BorderFactory.createEtchedBorder ();

  title = new JTextField ( "" );
  title.setHorizontalAlignment ( JTextField.CENTER );
  title.setEditable ( false );

  JPanel top = new JPanel ();
  top.setLayout ( new BorderLayout () );
  top.setLayout ( new BoxLayout ( top, BoxLayout.Y_AXIS ) );
  top.add ( title );

  // ----------- 2010/01/09 Nick

  JPanel recordsButtons = new JPanel ();
  recordsButtons.setLayout ( new FlowLayout () );

  URL imgURB = getClass().getResource ( "/icons/backup.png" );
  queryB = new JButton ( new ImageIcon ( Toolkit.getDefaultToolkit().getImage ( imgURB )) );
  queryB.setEnabled ( false );
  queryB.setToolTipText ( idiom.getWord ("FSET") );

  URL imgURLeft = getClass().getResource ( "/icons/queryLeft.png");
  queryLeft = new JButton ( new ImageIcon(Toolkit.getDefaultToolkit().getImage ( imgURLeft )));
  queryLeft.setEnabled ( false );
  queryLeft.setToolTipText ( idiom.getWord("PSET") );

  URL imgURRight = getClass().getResource ( "/icons/queryRight.png");
  queryRight = new JButton ( new ImageIcon ( Toolkit.getDefaultToolkit().getImage ( imgURRight)));
  queryRight.setEnabled ( false );
  queryRight.setToolTipText ( idiom.getWord("NSET") );

  URL imgURF = getClass().getResource ( "/icons/forward.png");
  queryF = new JButton ( new ImageIcon(Toolkit.getDefaultToolkit().getImage(imgURF)));
  queryF.setEnabled ( false );
  queryF.setToolTipText ( idiom.getWord ( "LSET") );

  // --------------------------------------------
  MouseListener mouseLB = new MouseAdapter() {

       public void mousePressed ( MouseEvent e ) {

          if( queryB.isEnabled () ) {

              start = 0; 
              limit = C_LIMIT;
              currentPage = 1;
              queryB.setEnabled    ( false );
              queryLeft.setEnabled ( false );

              if ( !queryRight.isEnabled () ) {

                       queryRight.setEnabled ( true );
                       queryF.setEnabled ( true );
               }

              indexMin = 1;
              indexMax = C_INDEX_MAX;

              String sql = sql_BrowserCreate ( C_LIMIT, C_ZERO );	  

              Vector res = connReg.TableQuery ( sql );
              Vector col = connReg.getTableHeader ();

              addTextLogMonitor ( idiom.getWord ( "EXEC" ) + sql + ";\"" );

              if ( !connReg.queryFail () ) {

                  addTextLogMonitor ( idiom.getWord ( "RES" ) + "OK" );
                  showQueryResult ( res, col );
                  updateUI ();
               }
           }
        } // mousePressed ( MouseEvent e )
  }; // MouseListener mouseLB = new MouseAdapter()

  queryB.addMouseListener ( mouseLB );
  //------------------------------------------------
  
  MouseListener mouseLQL = new MouseAdapter () {

       public void mousePressed ( MouseEvent e ) {

          if ( queryLeft.isEnabled () ) {

              currentPage--;

              if ( currentPage == 1 ) {

                  queryLeft.setEnabled ( false );
                  queryB.setEnabled ( false );

                  indexMin = 1;
                  indexMax = C_INDEX_MAX ; // 50
               }
              else {
                     if ( currentPage == ( nPages - 1 ) ) indexMax = indexMin - 1;
                     else
                          indexMax -= C_INDEX_MAX; // 50

                     indexMin -= C_INDEX_MAX ; // 50
               }

              if ( !queryRight.isEnabled () ) {
            	  
                          queryRight.setEnabled ( true );
                          queryF.setEnabled ( true );
               }

              start = indexMin - 1;
              limit = C_LIMIT ; // 50

              String sql = sql_BrowserCreate ( C_LIMIT, start );

              Vector res = connReg.TableQuery ( sql );
              Vector col = connReg.getTableHeader ();

              addTextLogMonitor ( idiom.getWord ( "EXEC" )+ sql + ";\"" );
              
              if ( !connReg.queryFail () ) {

                  addTextLogMonitor ( idiom.getWord ("RES") + "OK" );
                  showQueryResult ( res, col );
                  updateUI ();
               }
           } // queryLeft.isEnabled ()
        } // mousePressed ( MouseEvent e )
  }; // MouseListener mouseLQL = new MouseAdapter()

  queryLeft.addMouseListener ( mouseLQL );

  // --------------------------------------
  
  MouseListener mouseLQR = new MouseAdapter () {

       public void mousePressed ( MouseEvent e ) {

          if ( queryRight.isEnabled () ) {

              currentPage++;
              start = indexMax;

              if ( currentPage > 1 ) {

                  if ( !queryLeft.isEnabled () ) {

                      queryLeft.setEnabled ( true );
                      queryB.setEnabled ( true );
                   }
               }

              int downLimit = 1;

              if ( currentPage == nPages ) {
                  
            	   indexMax = recIM;
                   downLimit = ( nPages - 1 ) * C_LIMIT + 1; // 50
                   queryRight.setEnabled ( false );
                   queryF.setEnabled ( false );
               }

              int diff = ( indexMax - downLimit ) + 1;

              if ( diff > C_LIMIT ) diff = C_LIMIT; // 50
              limit = diff;

              String sql = sql_BrowserCreate ( limit, start );
              
              Vector res = connReg.TableQuery     ( sql );
              Vector col = connReg.getTableHeader ();

              addTextLogMonitor ( idiom.getWord ( "EXEC" )+ sql + ";\"" );
              
              indexMin += C_INDEX_MAX ; // 50 
              indexMax += C_INDEX_MAX ; // 50

              if ( !connReg.queryFail () ) {

                  addTextLogMonitor ( idiom.getWord ("RES") + "OK" );
                  showQueryResult ( res, col );
                  updateUI ();
                  
               } // not Fail
           } // queryRight.isEnabled ()
        } // mousePressed ( MouseEvent e )
  }; // MouseListener mouseLQR = new MouseAdapter ()
  
  // --------------------------------------------

  queryRight.addMouseListener ( mouseLQR );

  MouseListener mouseLF = new MouseAdapter() {

       public void mousePressed(MouseEvent e) {

          if ( queryF.isEnabled () ) {

              currentPage = nPages;
              queryRight.setEnabled ( false );
              queryF.setEnabled ( false );

              if ( !queryLeft.isEnabled () ) {

                  queryLeft.setEnabled ( true );
                  queryB.setEnabled ( true );
               }

              indexMin = ( ( nPages - 1 ) * C_INDEX_MAX ) ; 
              start = indexMin;
              limit = C_LIMIT ;

              indexMin++;

              String sql = sql_BrowserCreate ( limit, start );

              Vector res = connReg.TableQuery ( sql );
              Vector col = connReg.getTableHeader ();

              addTextLogMonitor ( idiom.getWord ("EXEC") + sql + ";\"" ); 

              if ( !connReg.queryFail () ) {

                  addTextLogMonitor ( idiom.getWord ("RES") + "OK" );
                  showQueryResult ( res, col );
                  updateUI ();
               } // not Fail
           } // queryF.isEnabled
        } // mousePressed
  }; // MouseListener mouseLF = new MouseAdapter()

  queryF.addMouseListener ( mouseLF );

  // ----------------------------------------
  recordsButtons.add ( queryB );
  recordsButtons.add ( new JPanel () );
  
  recordsButtons.add ( queryLeft );
  recordsButtons.add ( new JPanel () );
  
  recordsButtons.add ( queryRight );
  recordsButtons.add ( new JPanel () );
  
  recordsButtons.add ( queryF );
  recordsButtons.add ( new JPanel () );

  //-----------------------------------------------------------
  JPanel recordsControl = new JPanel ();
  recordsControl.setLayout ( new FlowLayout () );

  onTable.setText ( " " + idiom.getWord ("TOTAL") + " : 0 " );
  onTable.setEditable ( false );

  onMem.setText ( " " + idiom.getWord ("ONMEM") + " : 0 ");
  onMem.setEditable ( false );

  onScreen.setText ( " " + idiom.getWord ("ONSCR") + " : 0 ");
  onScreen.setEditable ( false );

  recordsControl.add ( onScreen );
  recordsControl.add ( onMem );
  recordsControl.add ( onTable );
 // ------------------------------------------------------------
 //      Nick 2010-01-09 
  
  currentStatistic.setHorizontalAlignment ( JTextField.CENTER );
  currentStatistic.setEditable ( false );

  JPanel dataStat = new JPanel ();
  dataStat.setLayout ( new BorderLayout () );

  if ( p_sw ) { // Horisont resolution >= 1152
	  
      dataStat.add ( recordsControl,   BorderLayout.WEST );     // NORTH
      dataStat.add ( currentStatistic, BorderLayout.EAST );     // CENTER 
      dataStat.add ( recordsButtons,   BorderLayout.CENTER );   // SOUTH
  }
  else {
	  
         dataStat.add ( recordsControl,   BorderLayout.NORTH ) ;      
         dataStat.add ( currentStatistic, BorderLayout.CENTER ) ;      
         dataStat.add ( recordsButtons,   BorderLayout.SOUTH );    
  }
	  
  // -----------------------------------------------------------
  
  TitledBorder title1 = BorderFactory.createTitledBorder ( etched1 );
  dataStat.setBorder ( title1 );

  top.add ( new JPanel (), BorderLayout.CENTER ); 
  top.add ( dataStat );
  top.setBorder ( title1 );

  add ( top, BorderLayout.NORTH ); 

  setLabel ( "", "", "", "" );
  
  showQueryResult ( new Vector (), new Vector () );
  
  add ( StructureBar, BorderLayout.WEST );
  pieDatos ();
  add ( firstPanel,   BorderLayout.SOUTH );
  
  setSize ( 500, 500 ); 
  
} // End 0f constructor
 
/**
 * 2010-01-12  Nick
 * @param p_limit
 * @param p_offset
 * @return sql for get data from table to browser
 */
String sql_BrowserCreate ( int p_limit, int p_offset ) {

    // 2009-07-08  Nick  The protected table names raises some problem. 
    //
    // String sql = "SELECT " + recordFilter + " FROM \"" + currentTable + "\" ORDER BY " + 
    // orderBy + " LIMIT 50 OFFSET 0";

    //  Nick 2010-01-12  The currentTable has to containt the schema name and 
    //                   the protected table name.                     
    
    
    String sql = "";	  

    if ( where.length () != 0 )
    
        sql = SQL_011 + "( " +
              SQL_010 + recordFilter + SQL_020 + currentTable + where + " ) " + SQL_031 +  
              orderBy + SQL_040 + p_limit + SQL_050 + p_offset ;
    
      else
          sql = SQL_010 + recordFilter + SQL_020 + currentTable + SQL_030 + orderBy + 
                       SQL_040 + p_limit + SQL_050 + p_offset ;
	
	return sql ;
}
 
/******************** METODO Filter() : Panel Filtro de Inf. ********************/

public void Filter() {

  base = new JPanel ();
  base.setLayout ( new BoxLayout ( base, BoxLayout.Y_AXIS ) );
  
  JPanel row1 = new JPanel ();
  row1.setLayout ( new FlowLayout ( FlowLayout.LEFT ) );
  
  JPanel row2 = new JPanel ();
  row2.setLayout ( new FlowLayout ( FlowLayout.LEFT ) );
  
  CheckBoxListener myListener = new CheckBoxListener ();
  String[] datmp = {""};

  rectangle = new JCheckBox ( idiom.getWord ( "FILTER" ) + ":" );
  rectangle.setMnemonic( 'F' ); 
  rectangle.addItemListener ( myListener );

  rectangle2 = new JCheckBox ( idiom.getWord ( "LIMIT" )+":" );
  rectangle2.setMnemonic ( 'L' ); 
  rectangle2.addItemListener ( myListener );

  combo1 = new JComboBox ( datmp );
  combo2 = new JComboBox ( datmp );
  combo3 = new JTextField ( 10 );

  combo1.setActionCommand  ( "COMBO1" );
  combo1.addActionListener ( this );

  combo2.setActionCommand  ( "COMBO2" );
  combo2.addActionListener ( this );

  JPanel space = new JPanel ();

  advanced = new JButton ( idiom.getWord ("OPC") );
  advanced.setActionCommand ("Options");
  advanced.addActionListener ( this );

  JMenuItem Item = new JMenuItem ( idiom.getWord ("DSPLY") );
  Item.setActionCommand ( "DISPLAY" );
  Item.addActionListener ( this );
  popup.add ( Item );

  Item = new JMenuItem ( idiom.getWord ("ADF" ) ); 
  Item.setActionCommand ( "ADVANCED" );
  Item.addActionListener ( this );
  popup.add ( Item );

  Item = new JMenuItem ( idiom.getWord ("CUF") ); 
  Item.setActionCommand ( "CUSTOMIZE" );
  Item.addActionListener ( this );
  popup.add ( Item );

  MouseListener mouseListener = new MouseAdapter() {
	public void mousePressed ( MouseEvent e ) {
         if (!popup.isVisible () && advanced.isEnabled ())
               popup.show ( advanced, 90, 0 );
          }
  };
  advanced.addMouseListener ( mouseListener );

  button = new JButton ( idiom.getWord ("UPDT") );
  button.setActionCommand ( "REFRESH" );
  button.addActionListener ( this );

  JPanel row0 = new JPanel ();
  row0.setLayout (new FlowLayout ( FlowLayout.CENTER ) );
  row0.add ( button );
  row0.add ( advanced );

  row1.add ( rectangle ); 
  row1.add ( combo1 );
  row1.add ( combo2 );
  row1.add ( combo3 );
  row1.add ( space );

  numRegTextField = new JTextField (7);
  men1 = new JLabel ( idiom.getWord ( "STARTR" ) + ":" ); 
  limitText = new JTextField (7);
  men2 = new JLabel ( idiom.getWord ("LRW") );

  row2.add ( rectangle2 );
  row2.add ( men1 );
  row2.add ( numRegTextField );
  row2.add ( men2 );
  row2.add ( limitText );

  setRow1 ( false );
  setRow2 ( false );

  JPanel right = new JPanel ();
  right.setLayout ( new BorderLayout () );
  right.add ( row2, BorderLayout.WEST );

  JPanel groupPanel = new JPanel ();
  groupPanel.setLayout ( new BoxLayout ( groupPanel, BoxLayout.Y_AXIS ) );
  groupPanel.add ( row1 );
  groupPanel.add ( right );

  Border etched1 = BorderFactory.createEtchedBorder ();
  TitledBorder title1 = BorderFactory.createTitledBorder ( etched1 );

  groupPanel.setBorder ( title1 );

  base.add ( row0 );
  base.add ( groupPanel ); 
}

/******************** METODO pieDatos() : Texto de Operacion ********************/
public void pieDatos() {

   firstPanel = new JPanel();
   firstPanel.setLayout ( new BorderLayout () );
   Filter ();
   firstPanel.add ( base, BorderLayout.CENTER );
}

/******************** METODO CreateToolBar() : Crea Barra de Iconos ******************
 *  2010.01.09 Nick
 * **/
 void CreateToolBar() {
 
  URL imgURL = getClass().getResource ( "/icons/16_InsertRecord.png" ); 
  insertRecord = new JButton ( new ImageIcon ( Toolkit.getDefaultToolkit().getImage (imgURL) ) );
  insertRecord.setActionCommand ( "INSERT-RECORD" );
  insertRecord.addActionListener ( this );
  insertRecord.setToolTipText ( idiom.getWord ( "INSREC" ) );
  insertRecord.setEnabled ( false );  // Nick 2010-01-26
  StructureBar.add ( insertRecord );

  imgURL = getClass().getResource ( "/icons/16_DelRecord.png" );
  delRecord = new JButton(new ImageIcon ( Toolkit.getDefaultToolkit().getImage(imgURL) ) );
  delRecord.setActionCommand ( "DELETE-RECORD" );
  delRecord.addActionListener ( this );
  delRecord.setToolTipText ( idiom.getWord ( "DELREC" ) );
  delRecord.setEnabled ( false );
  StructureBar.add ( delRecord );

  imgURL = getClass().getResource ( "/icons/16_UpdateRecord.png" );
  updateRecord = new JButton ( new ImageIcon ( Toolkit.getDefaultToolkit().getImage(imgURL ) ));
  updateRecord.setActionCommand ( "UPDATE-RECORD" );
  updateRecord.addActionListener (this);
  updateRecord.setToolTipText ( idiom.getWord ("UPDREC") );
  updateRecord.setEnabled ( false );
  StructureBar.add ( updateRecord );

  imgURL = getClass().getResource ( "/icons/16_ExportFile.png" );
  exportFile = new JButton ( new ImageIcon ( Toolkit.getDefaultToolkit().getImage(imgURL) ) );
  exportFile.setActionCommand ( "EXPORT-TO-FILE" );
  exportFile.addActionListener (this);
  exportFile.setToolTipText ( idiom.getWord ( "EXPORTAB") + "/" + idiom.getWord("ITT") );
  exportFile.setEnabled ( false );
  StructureBar.add ( exportFile );

  imgURL = getClass().getResource ( "/icons/16_NewTable.png" );
  reportBut = new JButton ( new ImageIcon ( Toolkit.getDefaultToolkit().getImage(imgURL) ) );
  reportBut.setActionCommand ("EXPORT-REPORT");
  reportBut.addActionListener ( this );
  reportBut.setToolTipText ( idiom.getWord ( "EXPORREP" ) );
  reportBut.setEnabled ( false );
  StructureBar.add ( reportBut );
    
}

/******************** METODO actionPerformed() : Manejador de Eventos ********************/
public void actionPerformed ( java.awt.event.ActionEvent e ) {


if ( e.getActionCommand ().equals ( "UPDATE-POP" )) {

    updatingRecords ();
    return;
 }

if ( e.getActionCommand ().equals ( "DELETE-POP" )) {

    dropRecords();
    return;
 }

if ( e.getActionCommand ().equals ( "INSERT-RECORD" )) {

    insertRecords();
    return;
 }
    
 if ( e.getActionCommand ().equals ( "DELETE-RECORD" ) ) {

    table.clearSelection();
    setCursor(Cursor.getPredefinedCursor ( Cursor.WAIT_CURSOR ) );

    DropTableRecord Eraser = new DropTableRecord ( realTableName, tableStruct, frame, idiom );
    Eraser.setLocationRelativeTo ( frame );
    Eraser.setVisible ( true );

    setCursor ( Cursor.getPredefinedCursor ( Cursor.DEFAULT_CURSOR ) );

    if ( Eraser.isWellDone () ) {

        addTextLogMonitor ( idiom.getWord ("EXEC") + Eraser.getSQL () + "\"" );
        String result = connReg.SQL_Instruction ( Eraser.getSQL () );

        if ( result.equals ( "OK" ) ) {
            result = refreshAfterDrop ( result );
        }
       else {
              result = result.substring ( 0, result.length () - 1 );
              ErrorDialog showError = new ErrorDialog ( new JDialog (), connReg.getErrorMessage (), idiom );
              showError.pack ();
              showError.setLocationRelativeTo ( frame );

              showError.show();
        }

       addTextLogMonitor ( idiom.getWord ("RES") + result );
    }

   return;
 }

 if ( e.getActionCommand ().equals ( "UPDATE-RECORD" ) ) {

     table.clearSelection ();
     setCursor ( Cursor.getPredefinedCursor ( Cursor.WAIT_CURSOR ) );

     UpdateTable upper = new UpdateTable ( realTableName, tableStruct, frame,idiom );
     setCursor ( Cursor.getPredefinedCursor ( Cursor.DEFAULT_CURSOR ) );

     if ( upper.getResult () ) {

         addTextLogMonitor ( idiom.getWord ( "EXEC" )+ upper.getUpdate () + "\"" );
         String result = connReg.SQL_Instruction ( upper.getUpdate () );

         if ( result.equals ( "OK" )) {

             String sql = "SELECT " + recordFilter + " FROM " + realTableName + " ORDER BY " + orderBy ;

             if ( where.length ()!= 0 )
                 sql = "SELECT " + recordFilter + " FROM " + realTableName + where;

             recIM = Count ( realTableName, connReg, sql, true );

             if ( recIM > 50 ) 
                 sql = "SELECT * FROM (" + sql + ") AS foo ORDER BY " + orderBy + " LIMIT " + 
                         limit + " OFFSET " + start;

             Vector res = connReg.TableQuery ( sql );
             Vector col = connReg.getTableHeader ();

             if ( !connReg.queryFail () ) {
            	 
                      showQueryResult ( res, col );
                      updateUI ();
                     
              }    
          }
         else {
                result = result.substring ( 0, result.length () - 1 );
                ErrorDialog showError = 
                	           new ErrorDialog ( new JDialog (), connReg.getErrorMessage (), idiom );
                showError.pack ();
                showError.setLocationRelativeTo ( frame );

                showError.setVisible( true );
          }

         addTextLogMonitor(idiom.getWord("RES") + result);
     }

    return;
 }

 if ( e.getActionCommand().equals ( "EXPORT-TO-FILE" ) ) {

     ExportToFile dialog = new ExportToFile ( frame, idiom, numReg );

     int option = 0;

     if (  dialog.isWellDone () ) {

         option = dialog.getOption ();
         String s = FILE_CONST + System.getProperty ( USER_DIR );
         File file;
         boolean Rewrite = true;
         String FileName = "";
         int returnVal;
         JFileChooser fc;

         switch ( option ) {
            case 1:  // From table to file, modified 2010-03-10 Nick 
              fc = new JFileChooser ( s );
              returnVal = fc.showDialog ( frame, idiom.getWord ( "EXPORTAB" ) );

              if ( returnVal == JFileChooser.APPROVE_OPTION ) {

                file = fc.getSelectedFile ();
                FileName = file.getAbsolutePath (); // Camino Absoluto

                if ( file.exists () ) {

                   GenericQuestionDialog win = 
                	   new GenericQuestionDialog ( frame, idiom.getWord ( "YES" ),
                                  idiom.getWord ( "NO" ), idiom.getWord ( "ADV" ),
                                  idiom.getWord ( "FILE" ) + " \"" + FileName 
                                  + "\" " + idiom.getWord ( "SEQEXIS2" ) + " " 
                                  + idiom.getWord ( "OVWR" )
                   );
                   Rewrite = win.getSelecction();
                }

                if ( Rewrite ) {

                  try {
                        ExportSeparatorField little = new ExportSeparatorField ( frame, idiom );
      
                    if ( little.isDone () ) {

                        String limiter = little.getLimiter ();
                        PrintStream saveFile = new PrintStream ( new FileOutputStream ( FileName ) );
                        
                        String sentence = SQL_010 + this.recordFilter + SQL_020 + this.realTableName + 
                        	              this.where + SQL_030 + orderBy;
                        Vector resultGlobal = connReg.TableQuery ( sentence );
                        Vector columnNamesG = connReg.getTableHeader ();
                        String val = "OK";

                        if ( connReg.queryFail () ) {
                              val = connReg.problem;
                              val = val.substring ( 0, val.length () - 1 );
                        }

                        addTextLogMonitor ( idiom.getWord ( "EXEC" ) + sentence + PN );
                        addTextLogMonitor ( idiom.getWord ( "RES" ) + val );
                        printFile ( saveFile, resultGlobal, columnNamesG, limiter );
                        
    		            JOptionPane.showMessageDialog ( frame, ( idiom.getWord ( "NICE" ) + S_POINT ), 
    		            		 idiom.getWord ( "INFO" ), JOptionPane.INFORMATION_MESSAGE 
    		            );                        
                        
                    } // little.isDone ()

                  } // fin try
                     catch ( Exception ex ) { System.out.println ( "Error: " + ex ); }
                } // fin if -- little.isDone ()
              } // fin if -- returnVal == JFileChooser.APPROVE_OPTION   
              return;

            case 2: // From file to table 
             fc = new JFileChooser(s);

             returnVal = fc.showDialog ( frame, idiom.getWord ( "LFILE" ) );

             if ( returnVal == JFileChooser.APPROVE_OPTION ) {

               file = fc.getSelectedFile ();
               FileName = file.getAbsolutePath (); // Camino Absoluto

               ImportSeparatorField little = new ImportSeparatorField ( frame, idiom );

               if ( little.isDone () ) {

                 String limiter = little.getLimiter();

                  try {
                     BufferedReader in = new BufferedReader ( new FileReader ( file ) );
                     String firstReg = in.readLine (); 
                     Vector data = new Vector ();
                     int index = firstReg.indexOf ( limiter );

                     if ( index != -1 ) {
                        StringTokenizer filter = new StringTokenizer ( firstReg, limiter );
                        int i = 0;
                        Vector tuple = new Vector ();

                        while ( filter.hasMoreTokens () ) {
                           i++;
                           String tmp = filter.nextToken ();
                           tuple.addElement ( tmp );
                        } 

                        int k = tableStruct.getTableHeader().getNumFields();

                        if ( i == k ) {
                          data.addElement ( tuple ); 

                          while ( true ) {
                              String line = in.readLine ();

                              if ( line == null ) break;

                              StringTokenizer filterFile = new StringTokenizer ( line, limiter );
                              int counter = 0;
                              tuple = new Vector();

                              while ( filterFile.hasMoreTokens () ) {

                                   counter += 1;
                                   String tmp = filterFile.nextToken ();
                                   tuple.addElement ( tmp );
                              } // filterFile.hasMoreTokens ()

                              data.addElement(tuple);
                          } // while ( true )
             
                          BuildSQLRecords ( currentTable, tableStruct.getTableHeader (), data );
                        }
                           else {
                                  JOptionPane.showMessageDialog ( new JDialog (),
                                     idiom.getWord ("NCNNA"), idiom.getWord ("ERROR!"), 
                                     JOptionPane.ERROR_MESSAGE
                                 );
                           return;
                          } //  ( i == k ) 
                     } // ( index != -1 )
                      else {
                                       JOptionPane.showMessageDialog(new JDialog(),
                                       idiom.getWord("SEPNF"),
                                       idiom.getWord("ERROR!"),JOptionPane.ERROR_MESSAGE);
                                       return;
                               }
                  } // try
                     catch ( Exception ex ) {
                              System.out.println ( "Error" + ex );
                            }
               } // little.isDone ()
             } //  returnVal == JFileChooser.APPROVE_OPTION
             return;
             default:
         } // switch 
    } // Dialog is well done

   return;
  }

 if ( e.getActionCommand ().equals ( "EXPORT-REPORT" )) {

     Vector dataRecords = new Vector();
     Vector columns = new Vector();

     if ( totalReg <= 50 ) {

         addTextLogMonitor ( idiom.getWord ( "EXEC" ) + "SELECT " + recordFilter + " FROM " +
        		             realTableName + ";\""
         );
         dataRecords = connReg.TableQuery ( "SELECT " + recordFilter + " FROM " + realTableName );
         columns = connReg.getTableHeader ();

         String str = "OK";

         if ( !connReg.queryFail () ) {

             addTextLogMonitor ( idiom.getWord ("RES") + str ); 
             ReportDesigner format = new ReportDesigner ( frame, columns, dataRecords, idiom, LogWin,
            		 currentTable, connReg );
          }
         else {
                str = connReg.getProblemString ().substring ( 0, connReg.getProblemString().length()- 1 );
                addTextLogMonitor ( idiom.getWord ("RES") + str );
          }
         return;
      }

     ExportToReport dialog = new ExportToReport ( frame, idiom );
     int option = 0;

     if ( dialog.isWellDone () ) {

         option = dialog.getOption ();

         String sql = "SELECT " + recordFilter + " FROM " + realTableName;

         switch ( option ) {

            case 1: 
              if ( where.length () > 0 ) sql += where;  
              sql = "SELECT * FROM (" + sql + ") AS foo ORDER BY " + orderBy + " LIMIT " + 
                     limit + " OFFSET " + start; 
              break;

            case 2: sql += where;
              break;

            case 3: sql += " ORDER BY " + orderBy;
          }

         addTextLogMonitor ( idiom.getWord ( "EXEC" ) + sql + ";\"" );

         dataRecords = connReg.TableQuery ( sql );
         columns = connReg.getTableHeader ();

         String str = "OK";

         if ( !connReg.queryFail ()) {
             addTextLogMonitor ( idiom.getWord("RES") + str);
             ReportDesigner format = new ReportDesigner ( 
            		 frame, columns, dataRecords, idiom, LogWin, currentTable, connReg
             );
          }
         else {
               str = connReg.getProblemString().substring ( 0, connReg.getProblemString().length() - 1 );
               addTextLogMonitor ( idiom.getWord ("RES") + str);

               ErrorDialog showError = new ErrorDialog ( new JDialog (),connReg.getErrorMessage (),
            		                       idiom
               );
               showError.pack ();
               showError.setLocationRelativeTo ( frame );

               showError.setVisible(true);
          }
      }

     return;
  }

 if ( e.getActionCommand ().equals ( "COMBO1" ) ) {

     JComboBox cb = ( JComboBox )e.getSource();
     int pos = cb.getSelectedIndex();

     if ( pos < 0 ) pos = 0;
 
     field = (String) columnNamesVector.elementAt(pos);

    if ( field == null || field.length() == 0 ) {

        field = firstField; 
        pos = columnNamesVector.indexOf ( firstField );
        cb.setSelectedIndex ( pos );
     }

    if ( !field.equals ( "oid" ) ) {

        String type = tableStruct.getTableHeader ().getType ( field );

        String[] varcharOpc = {"=","!=","<",">","<=",">=","like","not like","~","~*","!~","!~*"};
        String[] boolOpc = {"=","!="};
        String[] intOpc = {"=","!=","<",">","<=",">="};

        combo2.removeAllItems();

        if (type.startsWith("bool")) {

            for ( int i = 0; i < boolOpc.length; i++ ) combo2.addItem ( boolOpc[i] );
            return;
         }

        if ( type.startsWith ("int") || type.startsWith ("serial") || type.startsWith ("smallint") ||
             type.startsWith ("real") || type.startsWith ("double") || type.startsWith ("float")) {

            for ( int i = 0; i < intOpc.length; i++ ) combo2.addItem ( intOpc [i] );
            return;
         }

        for ( int i = 0; i < varcharOpc.length; i++ )
             combo2.addItem ( varcharOpc [i] );

     }
    else {
           combo2.removeAllItems ();
           String [] ig = {"=", "!=", "<", ">", "<=", ">=" };
           for ( int i = 0; i < ig.length; i++ ) combo2.addItem ( ig[i] );
     }

   return;
  } 

 if (e.getActionCommand().equals("COMBO2")) {

     JComboBox cb = (JComboBox)e.getSource();
     operator = (String) cb.getSelectedItem();

     return;
  }

 if ( e.getActionCommand().equals ( "DISPLAY" ) ) {

     recordFilter = getRecordFilter ( ( connReg.getDBname ()), currentTable ) ;
     
     if ( rectangle2.isSelected () ) rectangle2.setSelected ( false );
     if ( rectangle.isSelected () ) rectangle.setSelected ( false );

     DisplayControl regListPanel = new DisplayControl ( tableStruct, frame, idiom, recordFilter );

     if ( regListPanel.isWellDone () ) {

         recordFilter = regListPanel.getFilter ();
         putRecordFilter ( connReg.getDBname (), currentTable, recordFilter ) ;
         refreshTable();

     } // ( regListPanel.isWellDone () )
     
    return;
  } // ( e.getActionCommand().equals ( "DISPLAY" ) ) 

 if ( e.getActionCommand ().equals ( "ADVANCED" )) {

     if ( rectangle2.isSelected () ) rectangle2.setSelected ( false );

     if ( rectangle.isSelected () ) rectangle.setSelected ( false );

     setCursor ( Cursor.getPredefinedCursor ( Cursor.WAIT_CURSOR ) );

     AdvancedFilter button = new AdvancedFilter ( tableStruct, frame, idiom );
     setCursor ( Cursor.getPredefinedCursor ( Cursor.DEFAULT_CURSOR ) );

     if ( button.isWellDone () ) {

         sentence = button.getSelect ();
 
         if ( button.isThereOrder () ) orderBy = button.getOrder();

         recIM = Count ( currentTable, connReg, sentence, true );

         if ( recIM > 50 )
              sentence = "SELECT * FROM (" + sentence + ") AS foo ORDER BY " + orderBy + 
              " LIMIT 50 OFFSET " + start;

         Vector res = connReg.TableQuery ( sentence );
         Vector col = connReg.getTableHeader ();

         addTextLogMonitor ( idiom.getWord ("EXEC") + sentence + ";\"" );
         String str = "OK";

         if ( !connReg.queryFail () ) {

             showQueryResult ( res, col );
             updateUI (); 
          }
         else {
               str = connReg.getProblemString().substring ( 0, 
            		                                connReg.getProblemString ().length( ) -1 
               );
               ErrorDialog showError = new ErrorDialog ( new JDialog (), connReg.getErrorMessage(),
            		   idiom
               );
               showError.pack ();
               showError.setLocationRelativeTo ( frame );

               showError.show ();
          }     

         addTextLogMonitor ( idiom.getWord ("RES") + str );
      }

      return;
 } 

 if ( e.getActionCommand().equals ( "CUSTOMIZE" )) {

     if ( rectangle2.isSelected () ) rectangle2.setSelected ( false );
     if ( rectangle.isSelected () ) rectangle.setSelected ( false );

     CustomizeFilter custim = new CustomizeFilter ( tableStruct, frame, idiom );

     if ( custim.isWellDone ()) {

         sentence = custim.getSelect ();
         String order = custim.getOrder ();

         if (order.length() > 0)orderBy = order;

         recIM = Count ( currentTable, connReg, sentence, true );

         if ( recIM > 50 )
             sentence = "SELECT * FROM (" + sentence + ") AS foo ORDER BY " + orderBy + 
             " LIMIT 50 OFFSET " + start;

         Vector res = connReg.TableQuery ( sentence );
         Vector col = connReg.getTableHeader ();
         String str = "OK";
         addTextLogMonitor ( idiom.getWord ("EXEC") + sentence + ";\"" );

         if ( !connReg.queryFail () )  {

             showQueryResult ( res, col );
             updateUI (); 
          }    
         else {
               str = connReg.problem.substring ( 0, connReg.problem.length() -1 );
               ErrorDialog showError = new ErrorDialog ( new JDialog(), connReg.getErrorMessage(), 
            		   idiom
               );
               showError.pack ();
               showError.setLocationRelativeTo ( Records.this );
               showError.show ();
          }

         addTextLogMonitor ( idiom.getWord ("RES") + str );
     }

    return;
  }

 if ( e.getActionCommand().equals ( "REFRESH" ) ) {

     refreshOn = true;

     // sentence = "SELECT " + recordFilter + " FROM \"" + currentTable + "\"";
     // Nick 2009-08-09
     // sentence = "SELECT " + recordFilter + " FROM \"" + currentTable + "\"";
     
     sentence = SQL_010 + recordFilter + SQL_020 + currentTable;
     where = "";

     if ( rectangle.isSelected() ) {

         String var = combo3.getText();

         if ( var.length () ==0 ) {
             JOptionPane.showMessageDialog ( frame,                               
                    idiom.getWord ( "ERRFIL" ), idiom.getWord ( "ERROR!" ), JOptionPane.ERROR_MESSAGE
             );
             return;
          }
        else 
          {
             String type = "int";

             if ( !field.equals ( "oid" ) )
                 type = tableStruct.getTableHeader().getType ( field );

             int code = getTypeCode ( type );

             switch ( code ) {
               case 1:
                 if ( !var.startsWith (PA) ) var = PA + var;
                 if (!var.endsWith (PA) ) var = var + PA;
                 combo3.setText ( var );
                 break;

               case 2:
                 if ( !isNum ( var ) ) {
                     JOptionPane.showMessageDialog ( frame, idiom.getWord ( "FINTIV" ),
                           idiom.getWord ("ERROR!" ), JOptionPane.ERROR_MESSAGE );
                    combo3.setText ("");
                    combo3.requestFocus ();
                    return;
                 }
                break;

               case 3:
                 var = var.toLowerCase ();
                 if ( !var.equals ( "true" ) && !var.equals ( "false" )) {
                     JOptionPane.showMessageDialog ( frame, idiom.getWord ( "IBT" ),
                           idiom.getWord ("ERROR!"), JOptionPane.ERROR_MESSAGE );
                     combo3.setText ("");
                     combo3.requestFocus ();
                    return;
                 }
             } // fin switch

            sentence += SQL_071 + PN + field + PN + S_SPACES_1 + operator + S_SPACES_1 + var;
            where += SQL_071 + PN + field + PN + S_SPACES_1 + operator + S_SPACES_1 + var;

          } // fin else
     }

    sentence += SQL_030 + orderBy;
    // where += " ORDER BY " + orderBy;  Nick 2010-03-02

    if ( rectangle2.isSelected () ) {

        int fail = 0;
        
        boolean firstvalid  = false;
        boolean secondvalid = false;
        
        String num   = numRegTextField.getText ();
        String limit = limitText.getText ();

        if ( num.length () > 0 ) {

          if ( isNum ( num ) ) firstvalid = true;
            else {
                  JOptionPane.showMessageDialog ( frame, idiom.getWord ( "ERRLIM" ) + " 1 " +
                	   idiom.getWord ( "ERRLIM2" ), idiom.getWord ( "ERROR!" ), JOptionPane.ERROR_MESSAGE
                  );
                  return;
          }
         }
           else
                 fail += 1;

        if ( limit.length () > 0 ) {
            if ( isNum ( limit ) ) secondvalid = true;
            else { 
            	  JOptionPane.showMessageDialog ( frame, idiom.getWord ( "ERRLIM" ) + " 2 " + 
            			  idiom.getWord ( "ERRLIM2" ), idiom.getWord ( "ERROR!" ), JOptionPane.ERROR_MESSAGE
                  );
                  return;
             }
         }
        else
          fail += 1;

        if ( fail == 2 ) {
            JOptionPane.showMessageDialog ( frame, idiom.getWord ( "LIMUS" ),                       
                     idiom.getWord ( "ERROR!" ), JOptionPane.ERROR_MESSAGE
            );
            return;
      	 }
        else {
              if ( fail == 1 ) {
                  JOptionPane.showMessageDialog ( frame, idiom.getWord ( "LIM1US" ),                       
                         idiom.getWord ( "ERROR!" ), JOptionPane.ERROR_MESSAGE
                  );
                  return;
               }
              else
                 if ( firstvalid && secondvalid ) {
                     int a = Integer.parseInt ( num );
                     int b = Integer.parseInt ( limit );

                     if ( a <= b ) {
                         int numrows = (b - a) + 1;
                         sentence += SQL_040 + numrows + SQL_050 + num;
                         // where += " LIMIT " + numrows + " OFFSET " + num; Nick 2010-03-02
                      }
                     else {
                           JOptionPane.showMessageDialog ( frame, idiom.getWord ( "MORELIM" ),                       
                                    idiom.getWord ( "ERROR!" ), JOptionPane.ERROR_MESSAGE
                           );
                           return;
                      } // fin else
                 } // fin if
           } // fin else
     }
    recIM = Count ( currentTable, connReg, sentence, true );

    if ( recIM > C_INDEX_MAX ) 
    	    sentence = SQL_011 + SQL_020 + S_L_BR + sentence + S_R_BR + SQL_031 + orderBy + SQL_040 + C_LIMIT;  
    sentence += ";";

    Vector res = connReg.TableQuery ( sentence );
    addTextLogMonitor( idiom.getWord ("EXEC") + sentence + "\"" );
    Vector col = connReg.getTableHeader ();

    if ( !connReg.queryFail () ) {

         showQueryResult ( res, col );
         updateUI (); 
     }
    else {
           String resStr = connReg.getProblemString ();
           addTextLogMonitor ( idiom.getWord ( "ERRONRUN" ) + resStr.substring ( 0, resStr.length ()-1 )
          );
    }
  }
}
/***
 *  set ON, OFF "INSERT", "UPDATE", "DELETE"  bottons.
 *  Nick 2009-07-10
 */
public void activeToolBar_1 ( boolean value ) {

	   this.insertRecord.setEnabled ( value );
	   this.updateRecord.setEnabled ( value );
	   this.delRecord.setEnabled    ( value );  // Nick 2009-07-10 
}

/***
 *  set ON, OFF "ExportFile", "ReportBut"  bottons.
 *  Nick 2009-07-10
 */
public void activeToolBar_2 ( boolean value ) {

	   this.exportFile.setEnabled   ( value );
	   this.reportBut.setEnabled    ( value );  // Nick 2009-07-10
}

 /**
  * METODO activeInterface()  
  * Activa o desactiva los Botones
  *  
  */ 
 public void activeInterface ( boolean value ) {
 /**
  * delRecord and reportBut were lost. Nick 2009-10-07
  *  The second condition into "if ( ! value )" was rebuilded
  *      Nick 2010-02-12  
  */
	 
   this.insertRecord.setEnabled ( value );
   this.updateRecord.setEnabled ( value );
   this.delRecord.setEnabled    ( value );  // Nick 2009-07-10 
   this.rectangle.setEnabled    ( value );
   this.rectangle2.setEnabled   ( value );
   this.button.setEnabled       ( value );
   this.exportFile.setEnabled   ( value );
   this.reportBut.setEnabled    ( value );  // Nick 2009-07-10

   if ( !value ) {
	   
       connected = false;
       title.setText ( idiom.getWord ( "DSCNNTD" ) );
       showQueryResult ( new Vector(), new Vector () );
       hashDB.clear ();
       advanced.setEnabled ( false );

       onMem.setText            ( " " + idiom.getWord ("ONMEM")   + " : 0 " ); 
       onScreen.setText         ( " " + idiom.getWord ("ONSCR")   + " : 0 " );
       onTable.setText          ( " " + idiom.getWord ("TOTAL")   + " : 0 " );
       currentStatistic.setText ( " " + idiom.getWord ("DSCNNTD") + " "     ); 
 
       if ( queryB.isEnabled ()) {
    	   			queryB.setEnabled ( false );
    	   			queryLeft.setEnabled ( false );
       }

       if ( queryF.isEnabled () ) {
                        		queryRight.setEnabled ( false );
           		                queryF.setEnabled ( false );
       }
    }
   else {  // was added 2010-02-12 Nick
          currentStatistic.setText (" " + idiom.getWord ("PAGE") + " " + currentPage + " " + 
    		   idiom.getWord ("OF") + " " + nPages + " [ " + idiom.getWord ("RECS")+ " " + 
    		   idiom.getWord ("FROM") + " " + indexMin + " " + idiom.getWord ("TO") + " " + 
    		   indexMax + " " + idiom.getWord ("ONMEM") + " ] " 
          );
          connected = true;
   }    
 }                                                                              
/**
 *   2009-07-07 Nick. Some information about view was added. 
 *   2009-01-10 Nick. The comment of object was added.
 */
 
 public void setLabel ( String dbName, String table, String owner, String descr ) {
	 
  // this.currentTable = table; Nick 2009-07-09
   
   String mesg = "";
   String obj_name = "";
   
   if ( this.DBComponentType == 41 ) obj_name = this.idiom.getWord ( "TABLE" ) ;
   if ( this.DBComponentType == 42 ) {
	   obj_name = this.idiom.getWord ( "VEXIS" ) ;
       obj_name = obj_name.substring(0, ( obj_name.indexOf(" ")));	   
   }
   if ( dbName.length () > 0 ) 

	   mesg = obj_name + PA + table + PA + " [" + descr + "] " +
           this.idiom.getWord ( "DBOFTABLE" ) + PA+ dbName + "' " +
           this.idiom.getWord ( "OWNER" ) + ": '" + owner + PA
       ; 
      else 
             mesg = this.idiom.getWord ( "NOSELECT" );

   this.title.setText ( mesg );
  }

 public void activeBox ( boolean state ) {

   rectangle.setEnabled  ( state );
   rectangle2.setEnabled ( state );
   advanced.setEnabled   ( state );
  }
 /***
  * 2010-02-24  Nick
  *  
  * @param DBName
  * @param TableN
  * @return
  */
 public String getDefRecordFilter () {

 	return this.recordFilter ;
 }
 /***
 * 2010-02-24  Nick
 *  
 * @param DBName
 * @param TableN
 * @return
 */
public String getRecordFilter ( String DBName, String TableN ) {

    Hashtable hashTmp = new Hashtable ();	
    String l_recordFilter = "*" ;
    
    if ( hashDB.containsKey ( DBName ) ) {

        hashTmp = ( Hashtable ) hashDB.get( DBName );
        if ( hashTmp.containsKey ( TableN ) ) l_recordFilter = ( String ) hashTmp.get ( TableN ); 
    } 	
	return l_recordFilter ;
}
/**
 * 2010-02-25 Nick
 * @param DBName
 * @param TableN
 */
public void putRecordFilter ( String DBName, String TableN, String RecordFilter ) {

    Hashtable hashTmp = new Hashtable ();	

    if ( hashDB.containsKey ( DBName ) ) {

    	hashTmp = ( Hashtable ) hashDB.get( DBName );

    	if ( hashTmp.containsKey ( TableN ) ) hashTmp.remove ( TableN );
    	hashTmp.put ( TableN, RecordFilter ) ;
    }
}

/**
  *   One of general methods, it was called from XPG and Records classes
  * @param conn
  * @param TableN
  * @param structT
  * @return
  */
 public boolean updateTable ( PGConnection conn, String TableN, Table structT ) {

     //  realTableName = "\"" + TableN + "\"";
	 
	if ( structT.userSchema ) realTableName = structT.schema + "." + TableN;
	  else
	    realTableName = TableN;
	 
    // orderBy = "oid";
    orderBy = "1";

    if ( queryB.isEnabled () ) {

        queryB.setEnabled ( false );
        queryLeft.setEnabled ( false );
     }

    recordFilter = getRecordFilter ( conn.getDBname (), realTableName ) ;
    // 2010-02-27
    
    where = "";

    String sentence = "SELECT " + recordFilter + " FROM " + realTableName + " ORDER BY " + orderBy + ";";

    recIM = Count ( realTableName, conn, "", false );

    if (recIM == -1) return false;

    if (recIM > 50) {

        sentence = "SELECT " + recordFilter + " FROM " + realTableName + " ORDER BY " + 
                    orderBy + " LIMIT 50;";
        indexMax = 50;
        indexMin = 1;
     }

    currentPage = 1;

    connReg = conn;

    tableStruct = structT;
    
    //currentTable = TableN;  Nick 2009-07-09
    currentTable = realTableName;
    
    rectangle.setSelected   ( false );
    rectangle2.setSelected  ( false );
    combo3.setText          ( "" );
    numRegTextField.setText ( "" );
    limitText.setText       ( "" );

    String answer = "OK";
    Vector result = connReg.TableQuery ( sentence );
    columnNamesVector = connReg.getTableHeader ();

    if ( !connReg.queryFail () ) {

    	// 2011-11-13 Nick
        String owner = connReg.getOwner ( TableN, structT.schema );
        setLabel ( connReg.getDBname (), TableN, owner, tableStruct.comment ); // Nick 2010-01-10

        if ( result.size ()== 0 ) activeBox ( false );
        else { 
              activeBox ( true );
              button.setEnabled ( true );
          }

        combo1.removeAllItems();
        firstField = "";

        for (  int t = 0; t < columnNamesVector.size (); t++ ) {
             String element = ( String ) columnNamesVector.elementAt (t);

             if ( element.length () > 25 ) element = element.substring ( 0, 25 ) + "...";

             combo1.insertItemAt ( element, t ); 

             if ( t == 0 && element != null && element.length () > 0 ) firstField = element; 
             if ( ( firstField == null ) || ( element.length () == 0 )) firstField = element;
         }

        combo1.setSelectedIndex(0);

        showQueryResult ( result, columnNamesVector );
        
        // insertRecord.setEnabled ( true ); // Nick 2009-07-14
        
        exportFile.setEnabled ( true );
       }
      else {
            rectangle.setEnabled    ( false );
            rectangle2.setEnabled   ( false );
            insertRecord.setEnabled ( false );
            combo1.removeAllItems ();
            combo1.insertItemAt ( "", 0 );
            
            showQueryResult ( new Vector (),new Vector ());
            title.setText ( idiom.getWord ( "NRE" ));

            answer = connReg.getProblemString().substring (0, connReg.getProblemString ().length () - 1);

            ErrorDialog showError = new ErrorDialog ( new JDialog(), conn.getErrorMessage (), idiom );
            showError.pack ();
            showError.setLocationRelativeTo ( frame );
            showError.setVisible(true) ;
        }

   addTextLogMonitor ( idiom.getWord ("EXEC")+ sentence + "\"" );
   addTextLogMonitor ( idiom.getWord ("RES") + answer );
   updateUI();

   return true;
 } // fin method updateTable


public void showQueryResult ( Vector rowData, Vector columnNames ) {

   int resultSize = rowData.size ();

   boolean flag = false;

   if ( oldMem != recIM ) {

       onMem.setText ( " " + idiom.getWord ( "ONMEM" ) + " : " + recIM + " " );
       oldMem = recIM;
       flag = true;
    }

   if ( recIM == 0 ) { 

       nPages   = 1;
       indexMin = 0;
       indexMax = 0;

       if ( queryRight.isEnabled () ) {
              queryRight.setEnabled ( false );
              queryF.setEnabled ( false );
        }

       if ( queryLeft.isEnabled () ) {
                queryLeft.setEnabled ( false );
                queryB.setEnabled ( false );
        }
    }
   else {
         if ( recIM <= 50 ) {
                    nPages = 1;
                    indexMin = 1; 
                    indexMax = recIM;

             if ( queryRight.isEnabled () ) {
                           queryRight.setEnabled ( false );
                           queryF.setEnabled ( false );
              }

             if ( queryLeft.isEnabled() ) {
                       queryLeft.setEnabled (false);
                       queryB.setEnabled (false);
              }
          }
         else {
               nPages = getPagesNumber ( recIM );

               if ( nPages == 1 && recIM != 0 ) indexMax = recIM;
               if ( nPages == currentPage ) {
                       indexMax = recIM;
                       
                       if ( queryRight.isEnabled ()) {
                               queryRight.setEnabled ( false );
                               queryF.setEnabled ( false );
                       }
                }
               else {
                      if ( nPages > currentPage ) {
                          if ( nPages > 1 ) {
                              if ( !queryRight.isEnabled () ) {
                                         queryRight.setEnabled ( true );
                                         queryF.setEnabled ( true );
                               }

                              if ( indexMax < 50 ) indexMax = 50;
                           }
                          else {
                                 if ( queryRight.isEnabled ()) {
                                         queryRight.setEnabled ( false );
                                        queryF.setEnabled ( false );
                                  }
                           }
                       }
                }
         }
   }

   if ( oldPage != currentPage || !oldTable.equals ( currentTable ) || flag || refreshOn ) {

       if ( refreshOn ) { 
              refreshOn = false;
              currentPage = 1;

            if ( recIM > 50 ) {
               indexMax = 50;
               indexMin = 1;

               if ( !queryRight.isEnabled () ) {
                           queryRight.setEnabled ( true );
                           queryF.setEnabled ( true );
               }
            }
           else {
                  if ( queryRight.isEnabled () ) {
                          queryRight.setEnabled ( false );
                          queryF.setEnabled ( false );
                   }

                  if ( recIM == 0 ) {
                      indexMax = indexMin = 0;
                   }
                  else {
                         indexMin = 1;
                         indexMax = recIM;
                   }
           }

           if (queryLeft.isEnabled()) {

               queryLeft.setEnabled(false);
               queryB.setEnabled(false);
            }
       }

       flag = false;

       if ( !oldTable.equals ( currentTable )) {
           oldTable = currentTable;
           where = "";

           if ( recIM > 0 ) {
               indexMin = 1;

               if ( recIM <= 50 ) {
                   indexMax = recIM;
                   nPages = 1;
                }
               else {
                      indexMax = 50;
                }
           }
            else {
                 indexMin = 0;
                 indexMax = 0;
                 nPages = 1;
            }

           currentPage = 1;
        }

       currentStatistic.setText (" " + idiom.getWord ("PAGE") + " " + currentPage + " " + 
    		   idiom.getWord ("OF") + " " + nPages + " [ " + idiom.getWord ("RECS")+ " " + 
    		   idiom.getWord ("FROM") + " " + indexMin + " " + idiom.getWord ("TO") + " " + 
    		   indexMax + " " + idiom.getWord ("ONMEM") + " ] " 
       );
       oldPage = currentPage;
    } // oldPage != currentPage || !oldTable.equals ( currentTable ) || flag || refreshOn )

   if ( !firstTime && connected ) {

       int tuples = Count ( currentTable, connReg, "", true );

       if ( totalReg != tuples ) {
           onTable.setText ( " " + idiom.getWord ( "TOTAL" ) + " : " + tuples + " " );
           totalReg = tuples;
       }
   }
    else 
         firstTime = false;

   if ( resultSize != numReg ) {

       onScreen.setText ( " " + idiom.getWord ("ONSCR") + " : " + resultSize + " " );
       numReg = resultSize;
   }

   String[] colNames = new String [ columnNames.size() ];
   Object[][] rowD = new Object [ rowData.size() ] [ columnNames.size() ];

   if ( columnNames.size () > 0 ) {

       for ( int p = 0; p < columnNames.size(); p++ ) {
            Object o = columnNames.elementAt (p);
            colNames[p] = o.toString ();
        }

       for ( int p = 0; p < rowData.size(); p++ ) {

            Vector tempo = (Vector) rowData.elementAt(p);

            for ( int j = 0; j < columnNames.size (); j++ ) {

                 Object o = tempo.elementAt (j);
                 rowD [p] [j] = o;
             }
       } // ( int p = 0; p < rowData.size(); p++ )
    } // columnNames.size () > 0

   if ( resultSize > 0 ) {

       int tableWidth = table.getWidth();
 
       myModel = new MyTableModel ( rowD, colNames );
       table = new JTable ( myModel );

       table.setPreferredScrollableViewportSize ( new Dimension ( tableWidth, 70 )); // Nick I don't understand
       table.addFocusListener(this);
       addFocusListener(this);

       // Integer v = (Integer) rowD[0][0];  2009-07-07. Nick 
       Object v = (Object) rowD[0][0]; 

       String val = v.toString();
       int longStr = val.length();

       longStr = longStr*10;

       DefaultTableCellRenderer renderer = new ColoredTableCellRenderer ();
       renderer.setHorizontalAlignment ( JLabel.CENTER );

       //Personalizar ancho de columnas   Nick 2009-06-09 was deleted
         TableColumn column = table.getColumnModel().getColumn (0);
      
      // column.setPreferredWidth ( longStr );
      // column.setMaxWidth ( longStr );
      // column.setCellRenderer ( renderer );

       int width = ( tableWidth - longStr ) / columnNames.size() - 1; 

       for ( int p = 1; p < columnNames.size (); p++ ) {
            column = table.getColumnModel().getColumn ( p );
            column.setPreferredWidth ( width );

            String type = tableStruct.getTableHeader().getType( ( String ) columnNames.elementAt (p) );
            int code = getTypeCode ( type );
            DefaultTableCellRenderer r = new DefaultTableCellRenderer ();
           
            switch ( code ) {
                   case 2:  
                          r.setHorizontalAlignment ( JLabel.RIGHT );
                          break;
                   case 3:  
                          r.setHorizontalAlignment ( JLabel.CENTER ); 
                          break;
                   default: 
                          r.setHorizontalAlignment ( JLabel.LEFT );
             }

           column.setCellRenderer ( r );
      }

     final JPopupMenu popup = new JPopupMenu();

     JMenuItem Item = new JMenuItem ( "Update" );
     Item.setFont ( new Font ( "Helvetica", Font.PLAIN, 10 ) );
     Item.setActionCommand ( "UPDATE-POP" );
     Item.addActionListener ( this );
     popup.add ( Item );

     Item = new JMenuItem ( "Delete" );
     Item.setFont ( new Font ( "Helvetica", Font.PLAIN, 10 ) );
     Item.setActionCommand ( "DELETE-POP" );
     Item.addActionListener ( this );
     popup.add ( Item );

     table.addMouseListener ( new MouseAdapter () {

           public void mouseClicked ( MouseEvent e ) {

                  int[] row = table.getSelectedRows ();

                  if ( row.length > 0 ) {

                      if ( e.getClickCount() == 1 && SwingUtilities.isRightMouseButton ( e ) 
                          && row[0] != -1 ) {

                          if ( !popup.isVisible () ) popup.show ( table, e.getX (), e.getY () );
                       }
                   }

                  if  ( e.getClickCount () == 2 ) { 
                           updatingRecords ();
                  }
           } // mouseClicked
       }
     );

      // delRecord.setEnabled    ( true );  Nick 2009-07-14
      // updateRecord.setEnabled ( true );  Nick 2009-07-14
      exportFile.setEnabled   ( true ); 
      reportBut.setEnabled    ( true );
   }
   else {
           delRecord.setEnabled ( false );
           updateRecord.setEnabled ( false );
	       reportBut.setEnabled ( false );
           table = new JTable ( rowData, columnNames );
    }

   if ( !firstBool ) remove ( windowX );
    else
        firstBool = false;

   windowX = new JScrollPane ( table );
   add ( windowX, BorderLayout.CENTER );
} // End of showQueryResult 

 class MyTableModel extends AbstractTableModel {

  public MyTableModel ( Object[][] xdata, String[] colN ) {
       data = xdata;
       columnNames = colN;
      }
 
  public String getColumnName (int col ) {
        return columnNames [col].toString ();
      }

  public int getRowCount () {
        return data.length; 
      }

  public int getColumnCount () {
        return columnNames.length; 
      }

  public Object getValueAt ( int row, int col ) {
        return data [ row ][ col ];
      }

  public boolean isCellEditable(int row, int col) {
        return false;
      }

  public void setValueAt ( Object value, int row, int col ) {
        data [row] [col] = value;
        fireTableCellUpdated ( row, col ); 
      }

 } // End of MyTableModel

 public void setRow1( boolean state) {
     combo1.setEnabled ( state );  
     combo2.setEnabled ( state );
     combo3.setEnabled ( state );
   }

 public void setRow2 ( boolean state ) {
     numRegTextField.setEnabled ( state );
     men1.setEnabled            ( state );
     limitText.setEnabled       ( state );
     men2.setEnabled            ( state );
   }
  /**
   *  
   *
   */
  class CheckBoxListener implements ItemListener {

     public void itemStateChanged ( ItemEvent e ) {
        Object source = e.getItemSelectable ();

        if ( source == rectangle ) {
            if ( rectangle.isSelected () ) {
                setRow1 ( true );
                combo1.setSelectedIndex (1);
            }
          else
                setRow1 ( false );

          combo2.setSelectedIndex ( 0 );
        } 

        if ( source == rectangle2 ) {

            if ( rectangle2.isSelected () ) {
                setRow2 ( true );
             }
            else {
                  setRow2 ( false );
                  numRegTextField.setText ( "" );
                  limitText.setText ( "" );
             }

        }
    }
 } // class CheckBoxListener

 public boolean isNum ( String word ) {

   for ( int i = 0; i < word.length (); i++ ) {
        char c = word.charAt (i);
        if ( !Character.isDigit (c) ) return false;
    }
   return true;
 }

 public int Count ( String TableN, PGConnection konn, String sql, boolean log ) {

   int val = -1;
 //
 // Nick 2009-07-06
 //  
 //  if ( TableN.indexOf ("\"") == -1 && konn.gotUserSchema ( TableN ) ) {
 //      String schema = konn.getSchemaName(TableN); 
 //      TableN = schema + ".\"" + TableN + "\"";
 //   }

  // if ( TableN.indexOf (".") == -1 ) {
  //   	   String schema = konn.getSchemaName ( TableN, DBComponentType );
  //	       TableN = schema + "." + TableN ;
  // }
   
   String counting = "SELECT count(*) FROM " + TableN + ";";
   
   if ( sql.length () > 0 ) {

       if ( sql.endsWith ( ";" ) )
           sql = sql.substring( 0, sql.length () - 1 ) ;

       counting = "SELECT count(*) FROM (" + sql + ") AS foo;";
    }

   String answer = "OK";

   if ( log ) addTextLogMonitor ( idiom.getWord ( "EXEC" ) + counting + "\"" );

   Vector result = new Vector ();
   result = konn.TableQuery ( counting );

   if ( konn.queryFail () ) {

       if ( log ) {
           answer = konn.getProblemString ().substring ( 0, konn.getProblemString ().length() - 1 );
           addTextLogMonitor ( idiom.getWord ( "RES" ) + answer );
        }

       ErrorDialog showError = new ErrorDialog ( new JDialog (), konn.getErrorMessage (), idiom );
       showError.pack ();
       showError.setLocationRelativeTo ( frame );
       showError.setVisible(true);
    }
   else {
          Vector value = (Vector) result.elementAt(0);

          try {
                Long entero = (Long) value.elementAt(0);   
                val = entero.intValue();
           }
          catch( Exception ex){
                 Integer entero = (Integer) value.elementAt(0);
                 val = entero.intValue();
           }

          if ( log ) addTextLogMonitor(idiom.getWord ("RES") + val + " " + idiom.getWord ("RECS") );
    }

   return val;
  }


 public int getTypeCode ( String typeStr ) {

   if ( typeStr.startsWith ( "varchar" ) || typeStr.startsWith ( "char" ) || 
		typeStr.startsWith ( "text" )    || typeStr.startsWith ( "name" ) || 
		typeStr.startsWith ( "date" )    || typeStr.startsWith ( "time" )
   )
       return 1;

   if ( typeStr.startsWith ( "int" )   || typeStr.equals ( "serial" ) || 
		typeStr.equals ( "smallint " ) || typeStr.equals ( "real" ) || 
		typeStr.equals ( "double" )
   )

       return 2;

   if ( typeStr.startsWith ( "bool" ))

       return 3;
   else
       return 4;
 }

 /**
  * Metodo addTextLogMonitor
  * Imprime mensajes en el Monitor de Eventos
  */
  public void addTextLogMonitor ( String msg ) {

    LogWin.append ( msg + "\n" );
    int longiT = LogWin.getDocument ().getLength ();
    if ( longiT > 0 ) LogWin.setCaretPosition ( longiT - 1 );
  }

 /**
  * Metodo getNumRegs
  * Retorna el numero de registros de la tabla
  */
  public int getNumRegs() {
     return numReg;
  }
/**
 *  Nick 2010-03-04
 * @param xfile
 * @param registers
 * @param FieldNames
 * @param Separator
 */
public void printFile ( PrintStream xfile, Vector registers, Vector FieldNames, String Separator ) {

   String limit = "";
   boolean isCSV = false;

   try {
        int TableWidth = FieldNames.size ();

        if ( Separator.equals ( S_CSV ) ) {
            limit = S_COMMA;
            isCSV = true;
         }
        else
            limit = Separator;

        for ( int  p = 0; p < registers.size (); p++ ) {

          Vector rData = (Vector) registers.elementAt(p);

          for ( int i = 0; i < TableWidth; i++ ) {

             Object o = rData.elementAt (i);
             String field = cNULL;

             if ( o != null ) field = o.toString ();
             if ( isCSV ) xfile.print ( PN + field + PN );   
                  else
                      xfile.print ( field );

             if ( i < TableWidth - 1 ) xfile.print ( limit );
          }
          xfile.print ( cLF );
        }

       try {
             xfile.close();
        }
       catch ( Exception ex ) { ex.printStackTrace();  }
     }
     catch ( Exception e ) { e.printStackTrace(); }
 }

void BuildSQLRecords ( String table, TableHeader headT, Vector data ) {

   Vector col  = headT.getNameFields (); 
   String sql  = "";
   int numCol = col.size ();

   try {
        for ( int p = 0; p < data.size (); p++ ) {

             // sql = "INSERT INTO \"" + table + "\" VALUES("; Nick 2009-07-09
             sql = "INSERT INTO " + table + " VALUES(";
             Vector tempo = (Vector) data.elementAt ( p );

             if (tempo.size() != numCol) {

                 if ( p > 0 ) refreshTable ();

                 int k = p + 1;

                 JOptionPane.showMessageDialog ( Records.this,
                    idiom.getWord("TFIC") + k, idiom.getWord ("ERROR!"), JOptionPane.ERROR_MESSAGE
                  );
                 return;
              }          

             for ( int j = 0; j < numCol; j++ ) {

                  String colName = (String) col.elementAt(j);
                  String type = headT.getType(colName);
                  Object o = tempo.elementAt(j);

                  if (type.startsWith("varchar") || type.startsWith("char") || type.startsWith("text") 
                      || type.startsWith("name") || type.startsWith("date") || type.startsWith("time"))
                      sql += PA + o.toString() + PA;
                  else
                      sql += o.toString();

                  if (j < (numCol - 1))
                      sql += ",";
              }

             sql += ");";
     
             addTextLogMonitor ( idiom.getWord ( "EXEC" ) + sql + "\"");
             String result = connReg.SQL_Instruction ( sql );

             if (result.equals("OK")) {
                 addTextLogMonitor(idiom.getWord("RES") + result);
              }
             else {
                   result = result.substring(0,result.length()-1);
                   addTextLogMonitor(idiom.getWord("RES") + result);

                   ErrorDialog showError = new ErrorDialog ( 
                	           new JDialog (), connReg.getErrorMessage (), idiom );
                   showError.pack();
                   showError.setLocationRelativeTo(frame);
                   showError.show();
                   return;
              }

           }

          refreshTable();

        }
      catch (Exception ex) {
             System.out.println("Error: " + ex);
             ex.printStackTrace(); 
       }

 }

public void refreshTable () {

  //  String sql = "SELECT " + recordFilter + " FROM \"" + currentTable + "\" ORDER BY " + orderBy;
  //   Nick 2009-07-09 The protected Names !!!	
	
	  String sql = "SELECT " + recordFilter + " FROM " + currentTable + " ORDER BY " + orderBy;
	
   if ( where.length () != 0 ) sql = "SELECT " + recordFilter + " FROM " + currentTable + where; 

   // sql = "SELECT " + recordFilter + " FROM \"" + currentTable + "\"" + where; 

   recIM = Count ( currentTable, connReg, sql, true );

   currentPage = 1;

   if ( recIM > 50 ) {

       sql = "SELECT * FROM (" + sql + ") AS foo ORDER BY " + orderBy + " LIMIT 50";

       indexMin = 1;
       indexMax = 50;

    }
   else {
          nPages = 1;

          if ( recIM == 0 ) {
              indexMin = indexMax = 0;
           } 
          else {
                indexMin = 1;
                indexMax = recIM;
           }
    }

   Vector res = connReg.TableQuery ( sql );
   Vector colNames = connReg.getTableHeader ();

   // 2010-02-25  Nick  Temporary solution 
   String RealTableName = currentTable ;
   if ( currentTable.indexOf( S_POINT ) > 0 ) 
	   RealTableName = currentTable.substring( currentTable.indexOf( S_POINT ) + 1 ) ;

   // 2011-11-13 Nick
   String owner = connReg.getOwner ( RealTableName, "public" ); // currentTable 
   // End temporary  Nick 
   
   setLabel ( connReg.getDBname(), RealTableName, owner, tableStruct.comment ); // 2009-10-01 Nick 
   showQueryResult ( res, colNames );
   updateUI ();
 }

 /** METODO keyTyped */

public void keyTyped(KeyEvent e) {
 }

public void keyPressed(KeyEvent e) {

    int keyCode = e.getKeyCode();
    String keySelected = KeyEvent.getKeyText(keyCode); 

    if (keySelected.equals("Delete")) {

        dropRecords();
        return;
     }

    if (keySelected.equals("Insert")) {

        updatingRecords();
        return;
     } 
 }

 /*
  * METODO keyReleased
  * Handle the key released event from the text field.
  */

public void keyReleased(KeyEvent e) {
 }

 /**
  * METODO focusGained
  * Es un foco para los eventos del teclado
  */

public void focusGained(FocusEvent e) {

    Component jTable = e.getComponent();
    jTable.addKeyListener(this);
 }

 /**
 * METODO focusLost
 */

public void focusLost(FocusEvent e) {

    Component jTable = e.getComponent();
    jTable.removeKeyListener(this);
 }
 /***
  * Auxilary method  Nick 2010-02-02
  * @param p_head1
  * @param p_head2
  * @return result
  */
 boolean makeInserRecord () {

	boolean l_res = false;

	head1 = ( S_INSERT_01 + realTableName ); 
	head2 = S_INSERT_02 ; 
	
	setCursor ( Cursor.getPredefinedCursor ( Cursor.WAIT_CURSOR ) );
	   
	insert = new InsertData ( realTableName, tableStruct, frame, idiom, head1, head2 );
	insert.ShowForm ( frame, this.swc  ) ; // Nick 2010-02-13
	
	setCursor ( Cursor.getPredefinedCursor ( Cursor.DEFAULT_CURSOR ) );
	l_res = insert.wasOk () ;
	
	return l_res ;
}

/**
 *  Auxilary method
 * @return INSERT String
 */
 
 private String m_getSQLString () {

   return insert.getSQLString() ;	 
 }
 
 /**
 * Auxilary method  Nick 2010-02-02
 * METODO insertRecords
 */
 void insertRecords () {

   if ( makeInserRecord () ) {

	    addTextLogMonitor ( idiom.getWord ( "EXEC" ) + m_getSQLString () + "\"");
	    String result = connReg.SQL_Instruction ( m_getSQLString () ); // String result   Nick 2010/01/10

	    if ( result.equals ( "OK" ) ) refreshAfterInsert () ;
	    else {
	          result = result.substring ( 0, result.length ()-1 );

	          ErrorDialog showError = new ErrorDialog ( new JDialog(), 
	        		                                    connReg.getErrorMessage(), idiom 
	          );
	          showError.pack ();
	          showError.setLocationRelativeTo ( frame );
	          showError.setVisible ( true );
	    }

	    addTextLogMonitor ( idiom.getWord ( "RES" ) + result );

   } // insert.wasOk () 
} // End of insertRecords ()
/**
 * Special method, it updates GUI after inserting new record
 *  2010-02-02 Nick 
 */
void refreshAfterInsert () {
	
        totalReg++;

        String sql = "SELECT " + recordFilter + " FROM " + realTableName + 
                     " ORDER BY " + orderBy ;

        if ( where.length () > 0 )
                  sql = "SELECT " + recordFilter + " FROM " + realTableName + " " + where;         

        oldMem = recIM;
        recIM = Count ( realTableName, connReg, sql, true );

        int oldNPages = nPages;
        nPages = getPagesNumber ( recIM );

        onTable.setText ( " " + idiom.getWord("TOTAL") + " : " + totalReg + " " );

        if ( recIM > 50 ) {

            if ((oldNPages == nPages - 1) && (currentPage == nPages - 1)) {

                if (!queryLeft.isEnabled()) {

                    queryLeft.setEnabled(true);
                    queryB.setEnabled(true);
                 }

                currentPage++;
                limit = 1;
                indexMin = indexMax = recIM;
                start = indexMin - 1;

                // sql = "SELECT " + recordFilter + " FROM " + realTableName + "\" ORDER BY " + orderBy + " LIMIT " + limit + " OFFSET " + start;
                //  2009-07-09  Nick 
                
                sql = "SELECT " + recordFilter + " FROM " + realTableName + " ORDER BY " + 
                       orderBy + " LIMIT " + limit + " OFFSET " + start;

                if ( where.length () != 0 )

                    sql = "SELECT * FROM ("
                           + "SELECT " + recordFilter + " FROM " + realTableName + " " + where + 
                             ") AS foo ORDER BY " + orderBy + " LIMIT " + limit
                           + " OFFSET " + start;

                Vector res = connReg.TableQuery ( sql );
                Vector col = connReg.getTableHeader ();

                addTextLogMonitor ( idiom.getWord ( "EXEC" )+ sql + ";\"" );

                if ( !connReg.queryFail () ) {

                    addTextLogMonitor ( idiom.getWord ("RES") + "OK" );
                    showQueryResult ( res, col );
                    updateUI ();
                 }
             }
           else {
                  if ( currentPage == nPages ) {

                      if ( limit < 50 ) limit++;

                      sql = "SELECT " + recordFilter + " FROM " + realTableName + 
                            " ORDER BY " + orderBy + " LIMIT " + limit + " OFFSET " + start;

                      if ( where.length () != 0 )

                          sql = "SELECT * FROM ("
                                 + "SELECT " + recordFilter + " FROM " + realTableName + " " + 
                                 where + ") AS foo ORDER BY " + orderBy + " LIMIT " + limit + 
                                 " OFFSET " + start;

                      Vector res = connReg.TableQuery(sql);
                      Vector col = connReg.getTableHeader();

                      addTextLogMonitor(idiom.getWord("EXEC")+ sql + ";\"");

                      if (!connReg.queryFail()) {

                          addTextLogMonitor(idiom.getWord("RES") + "OK");
                          showQueryResult(res,col);
                          updateUI();
                       }
                  }

                 if (currentPage < nPages) {

                     setStatistics(currentPage,nPages,indexMin,indexMax);

                     if (oldMem != recIM) {

                         onMem.setText(" " + idiom.getWord("ONMEM") + " : " + recIM + " ");
                         oldMem = recIM;
                      }


                     if (!queryRight.isEnabled()) {

                         queryRight.setEnabled(true);
                         queryF.setEnabled(true);
                      } 
                 } 
           } 

         }
        else {
               nPages = 1;

               Vector res = connReg.TableQuery(sql);
               Vector col = connReg.getTableHeader();
               int oldNum = numReg;

               if (!connReg.queryFail()) {

                   String owner = connReg.getOwner(currentTable, "public"); // 2011-11-13 Nick
                   setLabel ( connReg.getDBname(), currentTable, owner, tableStruct.comment ); // Nick 2009-10-01
                   showQueryResult(res,col);

                   if (oldNum==0) {
                       rectangle.setEnabled(true);
                       rectangle2.setEnabled(true);
                       advanced.setEnabled(true);
                    }
                   updateUI();
                }
         } 
} // refreshAfterInsert ()

 /**
 * METODO dropRecords 
 */

public void dropRecords () {

    GenericQuestionDialog dropRecs = 
    	new GenericQuestionDialog ( 
    	    	frame, idiom.getWord ("YES"), idiom.getWord ("NO"),
                idiom.getWord ( "CONFRM" ), idiom.getWord ( "DRCONF" )
    );

    boolean sure = dropRecs.getSelecction ();

    if ( sure ) {

        String [] oid = getRecordOid ();
        String result = "";

        for ( int i = 0; i < oid.length; i++ ) {

            String sqlStr = "DELETE FROM " + realTableName + " WHERE oid=" + oid [i];
            addTextLogMonitor ( idiom.getWord ("EXEC") + sqlStr + ";\"" );
            result = connReg.SQL_Instruction ( sqlStr );

            if ( !result.equals ( "OK" ) ) 
                result = result.substring ( 0, result.length() -1 );

            addTextLogMonitor(idiom.getWord ( "RES" ) + result );
        } // for

        result = refreshAfterDrop ( result );
        addTextLogMonitor ( "Deletion Report: " + result );
     }
 }

 /**
 * METODO getRecordOid 
 */

public String[] getRecordOid () {

    int[] rows = table.getSelectedRows ();
    String[] oid = new String [ rows.length ] ;

    for ( int i = 0; i < rows.length; i++ ) {
         Object proof = myModel.getValueAt ( rows[i], 0 );
         oid[i] = proof.toString ();
     }
    return oid;
 }

 /**
 * METODO updatingRecords 
 */

public void updatingRecords() {

    String[] oid = getRecordOid ();

    UpdateRecord upper = new UpdateRecord ( realTableName, tableStruct, frame, idiom );

    if ( upper.getResult () ) {

        String SQL = upper.getUpdate() + " WHERE ";
        for ( int  i = 0; i < oid.length; i++ ) {
              SQL += "oid=" + oid [i];
              if ( i < oid.length - 1 ) SQL += " OR ";
         }

        addTextLogMonitor ( idiom.getWord ( "EXEC" ) + SQL + ";\"" );
        String result = connReg.SQL_Instruction ( SQL );

        if ( result.equals ( "OK" ) ) {

          String sql = "SELECT " + recordFilter + " FROM " + realTableName + " ORDER BY " + orderBy;

          if ( where.length()!=0 ) sql = "SELECT " + recordFilter + " FROM " + realTableName + where;

          recIM = Count ( currentTable, connReg, sql, true );

          if ( recIM > 50 )
             sql = "SELECT * FROM (" + sql + ") AS foo ORDER BY " + orderBy + " LIMIT " + limit + 
                   " OFFSET " + start;

            Vector res = connReg.TableQuery ( sql );
            Vector col = connReg.getTableHeader ();

            if ( !connReg.queryFail () ) {

            	showQueryResult ( res, col );
                updateUI ();
             }
          }
         else {
                result = result.substring ( 0, result.length () - 1 );
                ErrorDialog showError = new ErrorDialog ( new JDialog (), connReg.getErrorMessage (),
                		                idiom
                );
                showError.pack ();
                showError.setLocationRelativeTo ( frame );

                showError.setVisible ( true );
          }
        addTextLogMonitor ( idiom.getWord ("RES") + result );
    }
 }

 /**
 * METODO getPagesNumber
 */

public int getPagesNumber (int rIM) {

    double fl = ( ( double ) rIM) / 50;
    String div = "" + fl;       

    int nP = rIM / 50;

    if ( div.indexOf (".") != -1 ) {
        String str = div.substring ( div.indexOf( ".") + 1, div.length () );
        if ( !str.equals ("0") ) nP++;
     }
    return nP;
}

 /**
 * METODO setStatistics
 */

public void setStatistics ( int cPage, int nP, int iMin, int iMax ) {

    currentStatistic.setText ( " " + idiom.getWord ( "PAGE" ) + " " + cPage + " " + 
    		                  idiom.getWord ( "OF" ) + " " + nP + " [ " + idiom.getWord ("RECS") + 
    		                  " " + idiom.getWord ("FROM") + " " + iMin + " " + idiom.getWord ("TO") + 
    		                  " " + iMax + " " + idiom.getWord ("ONMEM") + " ] ");
 }

 /**
 * METODO refreshAfterDrop 
 */

String refreshAfterDrop ( String result) {

   String sql = "SELECT " + recordFilter + " FROM " + realTableName + " ORDER BY " + orderBy;

   if ( where.length () !=0 )
       sql = "SELECT " + recordFilter + " FROM " + realTableName + " " + where;

   int oldR = recIM;
   recIM = Count ( realTableName, connReg, sql, true );

   int newTotalReg = Count ( realTableName, connReg, "", true );
   int diff = totalReg - newTotalReg;

   String mesg = idiom.getWord ( "DELOKS" );

   if ( diff == numReg ) {
       if ( diff == 1 ) mesg = idiom.getWord ("DELOK");
       if ( currentPage == nPages && currentPage > 1 ) {
           		currentPage--;
           		start -= 50;
           		limit = 50;
           		indexMin = start + 1;
         }
    }

   result += " [ " + diff + " " + mesg + " ]";

   if ( oldR > recIM ) {
       if ( recIM > 50 ) {
           sql = "SELECT * FROM (" + sql + ") AS foo ORDER BY " + orderBy + " LIMIT " + limit + " OFFSET " + start;
        }
       else {
              currentPage = 1;
              if ( recIM < 0 ) {
            	  			indexMin = 1;
            	  			indexMax = recIM;
               }
        }

   Vector res = connReg.TableQuery ( sql );
   Vector col = connReg.getTableHeader ();

   if ( !connReg.queryFail () ) {

	   // 2011-11-13 Nick 
       String owner = connReg.getOwner ( currentTable, "public" );
       setLabel ( connReg.getDBname (), currentTable, owner, tableStruct.comment ); // Nick 2009-10-01
       showQueryResult ( res, col );

       if ( numReg == 0 ) {
    	   		rectangle.setEnabled  ( false );
    	   		rectangle2.setEnabled ( false );
    	   		advanced.setEnabled   ( false );
        }
       updateUI ();
    }
  }

  return result;
 } // RefreshAfterDrop  

public void setOrder () {
    orderBy = "1";
    // orderBy = "oid";
 }
/*****
 *  Interface. Nick 2009-07-07
 */
public void setDBComponentType ( int p_type ) {
	this.DBComponentType = p_type ;
 }

} // Fin de la Clase

class ColoredTableCellRenderer extends DefaultTableCellRenderer {

 public void setValue ( Object value ) {
            setForeground ( Color.red );
            setText ( value.toString () );
 }
}
