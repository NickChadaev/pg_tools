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
 *  CLASS CreateTable @version 1.0  
 *   This class is responsible for displaying a dialog to create a table.
 *   Events are handled to capture the data entered by the
 *   User. This is visual constructor.
 *  History:
 *          2009-07-20 - review. 
 *          2011-10-15 - Start of new stage of modification.  
 *          2012-07-26 - Finish of new stage of modification.   
 *          2012-10-28 - Testing and new features was added.  
 *          2013-01-08 - Small testing. List of schemas.                    
 */

package ru.nick_ch.x1.menu;

import java.awt.BorderLayout;
import java.awt.Color;
import java.awt.Dimension;
import java.awt.FlowLayout;
import java.awt.GridLayout;
import java.awt.Toolkit;
import java.awt.event.ActionListener;
import java.awt.event.MouseAdapter;
import java.awt.event.MouseEvent;
import java.awt.event.MouseListener;
import java.net.URL;
import java.util.Hashtable;
import java.util.Vector;

import javax.swing.BorderFactory;
import javax.swing.BoxLayout;
import javax.swing.ImageIcon;
import javax.swing.JButton;
import javax.swing.JCheckBox;
import javax.swing.JComboBox;
import javax.swing.JDialog;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JList;
import javax.swing.JOptionPane;
import javax.swing.JPanel;
import javax.swing.JRadioButton;
import javax.swing.JScrollPane;
import javax.swing.JTextArea;
import javax.swing.JTextField;
import javax.swing.JToolBar;
import javax.swing.SwingConstants;
import javax.swing.border.Border;
import javax.swing.border.TitledBorder;

import ru.nick_ch.x1.db.OptionField;
import ru.nick_ch.x1.db.PGConnection;
import ru.nick_ch.x1.db.Table;
import ru.nick_ch.x1.db.TableFieldRecord;
import ru.nick_ch.x1.idiom.Language;
import ru.nick_ch.x1.misc.input.GenericQuestionDialog;

import ru.nick_ch.x1.main.Sz_visuals;  /* 2011-10-15 Nick */
import ru.nick_ch.x1.db.Sql_db;
import ru.nick_ch.x1.structure.InsertTableField;
import ru.nick_ch.x1.utilities.*;

public class CreateTable extends JDialog implements ActionListener, Sz_visuals, 
               Sql_menu { // , Sql_db

 // -- public area	
 public String CurrentTable; /* This is name of created table/  Nick 2011-10-15 */
 public String dbn;          /* This is current DB name, may be :) */
 public String CurrentSCH;   /* Nick 2011-12-10 */
 // -- public area

 // The private area Nick 2012-07-20
 private boolean NN  = false;  // The not NULL indicator
 private boolean DVF = false ; // The default value indicator
 private String  DV  = "";     // The default value Nick 2012-07-23 
 private String  TF ;          // The type of field, without additional 
                               // parameters e.g. the length and the precision of field. 
 private boolean wellDone = false;

 private JComboBox cmbDB, cmbSCH;
 private JComboBox cmbReferences;
 private JComboBox cmbFields, typeFieldCombo, booleanCombo; // 2012-07-19 Nick
 
 private int typeIndex ; // Nick 2012-03-06
 
 private Language idiom; 
 
 private Hashtable HashFields = new Hashtable();
 private Vector    TableList;

 private JPanel    rowInherit
          		  ,rowReferences
          		  ,rowFields
          		  ,combosPanel
          		  ,checkPanel;
 
 private JPanel defPanel_0 = new JPanel (); // Nick 2012-01-04
 private JPanel defPanel_1 = new JPanel (); // Nick 2012-07-20
  
 private Table cTable;
 private JCheckBox 
          //  CBIn
          //, CBCheck
           CBr3 // The Default value
          ,CBr4 // The field constraint
          ,ForeingButton
          ,isKey
          ,NotNullBox;
 
 private JRadioButton primaryButton, uniqueButton;
 
 private final JTextField 
                   textField3  // The column name
                  ,textField5  // The length of field.
                  ,textField51 // The precision of field.
                  ,textField6  // The default value. Nick 2010-01-04
                  ,textField7  // The field constraint, e.g. a CHECK command
                  ,textTable   // The table name
                  ,commTable   // The table comment
                  ,commRow;    // The field comment  Nick 20-12-18  textCheck2  
 
 private JLabel msgFields, msgReferences;
 
 private PGConnection current;
 private TitledBorder titleK;
 private TitledBorder titleFK;
 
 private Color   currentColor;
 private JList   fieldJList;             // List of fields of the new table.  Nick 2012-01-04
 private Vector  fieldsN = new Vector();
 private JButton delField, delAll;
 private Vector  tablesH = new Vector();
 
 private boolean inheritActive = false;
 // private boolean consActive    = false;
 
 private String inheritString  = "";
 private Vector vecConn;
 private Vector dbNames;
 private Vector SchNames;  // 2011-12-03  Nick
 
 private JTextArea LogWin;
 
 private int num = 0;
 
 // 2012-02-03 Nick 
 private JPanel rowDB = new JPanel ();
 
 // Vector ConstNames = new Vector();  Nick 2011-12-18
 private Vector ConstDef = new Vector();
 private Vector Xschemas = new Vector();
 
 private JFrame fmain;

 /*******************
  * Metodo Constructor
  */
  public CreateTable ( JFrame aFrame, Language lang, Vector dbNm, Vector Conn, 
		               String currentDB, String currentSCH, JTextArea log ) {

    super ( aFrame, true );
    fmain   = aFrame;
    dbNames = dbNm;
    vecConn = Conn;
    
    Vector Xschemas_1 = new Vector(); 
    
    Border etched = BorderFactory.createEtchedBorder ();
    TitledBorder title = BorderFactory.createTitledBorder ( etched );
    idiom  = lang;
    LogWin = log;
    setTitle ( idiom.getWord ( "CREATET" ) );

    // construcciÔøΩn parte superior de la ventana

    // Captura campo Database
    cmbDB = new JComboBox ( dbNames );
    cmbDB.setSelectedItem ( currentDB ); // In another location of this -> null pointer exception.
                                         //  Nick 2011-12-10
    
    cmbDB.setActionCommand ( "COMBO-DB" );
    cmbDB.addActionListener ( this );
    
    if ( currentDB != null ) {
  	
    	dbn = currentDB ;
        int index = dbNames.indexOf ( currentDB );
        current = (PGConnection) vecConn.elementAt ( index );
    
        Xschemas_1 = current.getSCHVector (); // 2012-06-29 Nick
        int len_Xschemas_1 = Xschemas_1.size ();    
        for ( int i = 0; i < len_Xschemas_1; i++ ) 
       	                    Xschemas.add ( GetStr.getStringFromVector ( Xschemas_1, i, 0 )); // -1 2013-01-08 Nick
    } ;
    
    cmbSCH = new JComboBox ( Xschemas );
    CurrentSCH = currentSCH; // from parameter
    cmbSCH.setSelectedItem ( CurrentSCH ) ;
    
    cmbSCH.setActionCommand ( "COMBO-SCH" );
    cmbSCH.addActionListener ( this );
    
    rowDB.setLayout ( new BoxLayout ( rowDB, BoxLayout.X_AXIS ) );
    rowDB.add ( new JLabel ( idiom.getWord ( "DB" ) + cDP + cSPACE ) );
    rowDB.add ( cmbDB );

    rowDB.add ( new JLabel ( cSPACE2 + idiom.getWord ("SCH") + cDP + cSPACE ) );
    rowDB.add ( cmbSCH );
    
    //Captura campo Table-Name
    JPanel rowTable = new JPanel ();
    textTable = new JTextField (12);// 14
    rowTable.setLayout ( new BoxLayout ( rowTable, BoxLayout.X_AXIS ));
    
    rowTable.add ( rowDB );
    
    rowTable.add ( new JLabel ( cSPACE2 + idiom.getWord ( "NAME" ) + cDP + cSPACE ));
    rowTable.add ( textTable );
    
    JPanel rowComm = new JPanel (); 
    commTable = new JTextField (30);
    rowComm.setLayout ( new BoxLayout ( rowComm, BoxLayout.X_AXIS));
    rowComm.add ( new JLabel ( cSPACE2 + idiom.getWord ( "COMM" ) + cDP + cSPACE ));
    rowComm.add ( commTable );

    rowTable.add ( rowComm );
    //El panel superior se divide en dos este es el panel uno
    JPanel topOne = new JPanel ();
    topOne.setLayout ( new GridLayout ( 0, 1 ));

    topOne.add ( rowTable );
    topOne.setBorder ( title );

    //Captura campo Inherit   
    rowInherit= new JPanel ();
    JButton Inherit = new JButton ( idiom.getWord ( "INHE" ) );
    Inherit.setActionCommand ( "BUT-INHE" );
    Inherit.addActionListener ( this );

    TableList = current.getTblNamesVector ( currentSCH );
    
    if ( TableList.size () > 0 ) {

        String[] tables = new String [ TableList.size () ];

        for ( int i = 0; i < TableList.size (); i++ )
        	tables[i] = GetStr.getStringFromVector ( TableList, i, 0);

        Vector listTables = new Vector ();
        listTables.addElement ( tables[0] );
        
        // 13-11-2011 Nick.   
        Vector tR = current.getTablesStructure ( listTables, CurrentSCH );
        cTable = (Table) tR.elementAt (0);

        cmbReferences = new JComboBox ( tables );
        cmbFields = new JComboBox ( cTable.getTableHeader ().getNameFields () );
     }
    else {
          String[] listNull  = { idiom.getWord ("NOTABLES") };
          String[] listNull2 = { idiom.getWord ("NOREG") };
          cmbReferences = new JComboBox ( listNull );
          cmbFields = new JComboBox ( listNull2 );
       }

     cmbReferences.setActionCommand ( "CMB-REF" );  
     cmbReferences.addActionListener ( this );

     JButton constr = new JButton ( idiom.getWord ("CONST") );
     constr.setActionCommand ( "BUT-CONST" );
     constr.addActionListener ( this );

     // textCheck2 = new JTextField ( 35 ); // Temp solution Nick 2011-12-18
    /***********************************************************************
     JPanel rowConstraint= new JPanel();
     JPanel labels = new JPanel();
     labels.setLayout ( new GridLayout ( 0, 1 ));
     labels.add ( new JLabel ( idiom.getWord ( "CHECK" ) + cDP + cSPACE ));

     textCheck2 = new JTextField ( 35 );
     textCheck2.setEditable ( false );
     textCheck2.setEnabled  ( false );

     JPanel tfields = new JPanel ();
     tfields.setLayout ( new GridLayout ( 0, 1 ));
     tfields.add ( textCheck2 );

     rowConstraint.setLayout ( new FlowLayout ( FlowLayout.CENTER ));
     ***********************************************************************/
     
     //Panel superior total 
     JPanel topPanel = new JPanel ();
     topPanel.setLayout ( new BorderLayout () );
     topPanel.add ( topOne, BorderLayout.NORTH );
     // topPanel.add ( topTwo, BorderLayout.SOUTH );
     
     commRow = new JTextField (20); // Nick 2011-12-18 
     
     //ConstruciÔøΩn parte inferior izquierda de la ventana   Right panel. Nick 2011-12-10

     JPanel leftPanel = new JPanel();
     textField3 = new JTextField (12); // Name of column Nick 2012-04-01
     final String[] fields = {cSPACE};
     fieldJList = new JList ( fields );

     final JScrollPane componente = new JScrollPane ( fieldJList );

     MouseListener mouseListener = new MouseAdapter() {

        public void mousePressed ( MouseEvent e ) {

         int index = fieldJList.locationToIndex ( e.getPoint () );

         if (( e.getClickCount () == 1 ) && ( index > -1 ) && ( fieldsN.size () > 0 )) {

             componente.requestFocus ();
             
             String fieldMod = (String) fieldsN.elementAt (index);
             TableFieldRecord field = ( TableFieldRecord ) HashFields.get ( fieldMod );
             OptionField opF = field.getOptions ();
             textField3.setText ( field.getName () );
             commRow.setText ( field.getComment () ); // Nick 2012-01-04
             
             TF = field.getType (); // typeTmp Nick 2012-07-23
             typeIndex = field.getCategType();
             typeFieldCombo.setSelectedItem ( TF );

             int longField = opF.getFieldLong ();
             if ( longField > 0 ) textField5.setText ( cEMP + longField );

             int precField = opF.getFieldPrec ();
             if ( precField > 0 ) textField51.setText ( cEMP + precField);
             
             if ( opF.getDefaultValue().length() > 0 ) {
                 DV = opF.getDefaultValue ();
                 DVF = true;
                 
                 CBr3.setSelected ( DVF );
                 
                 if ( TF.equals ( ChkType.cBOOL ) ) {
                	 booleanCombo.setEnabled ( DVF );
                	 booleanCombo.setSelectedItem ( DV );
                 }
                 else {
                	 	textField6.setEnabled ( DVF );
                	 	textField6.setEditable ( DVF );
                	 	textField6.setText ( DV );
                 }
              }
             else {
            	   DV = cEMP;
                   DVF = false;
            	   CBr3.setSelected ( DVF );
                   textField6.setText ( DV ); // Default value. Nick 2012-01-04
                   textField6.setEditable ( DVF );
                   textField6.setEnabled ( DVF );
                  }

             // Option of fields.   Nick 
             if ( opF.getCheck ().length () > 0 ) {
                 CBr4.setSelected ( true );
                 textField7.setEnabled ( true );
                 textField7.setEditable ( true );
                 textField7.setText ( opF.getCheck () );
              }
             else {
                   CBr4.setSelected ( false );
                   textField7.setText ( cEMP );
                   textField7.setEditable ( false );
                   textField7.setEnabled  ( false );
              }

             NN = opF.isNullField () ;
             NotNullBox.setSelected ( NN ); // Nick 2012-07-07

            int flag = 0;
            if ( opF.isPrimaryKey () ) {
                isKey.setSelected ( true );
                setAvalaibleKey ( true );
                primaryButton.setSelected ( true );
                uniqueButton.setSelected  ( false );
                flag = 1;
             }
            else {
                  if ( opF.isUnicKey () ) {
                     isKey.setSelected ( true );
                     setAvalaibleKey ( true );
                     uniqueButton.setSelected  ( true );
                     primaryButton.setSelected ( false );
                     flag = 2;
                   }
             }
            if ( opF.isForeingKey () ) {
                 switch ( flag ) {
                         case 0: 
                                uniqueButton.setSelected  ( false );
                                primaryButton.setSelected ( false );
                                break;
                         case 1:
                                uniqueButton.setSelected  ( false );
                                primaryButton.setSelected ( true );
                                break;
                         case 2:
                                uniqueButton.setSelected ( true );
                                primaryButton.setSelected ( false );
                                break;
                  }

                 isKey.setSelected ( true );
                 setAvalaibleKey ( true );
                 ForeingButton.setSelected ( true );
                 setAvalaibleFKey ( true );

                 cmbReferences.setSelectedItem ( opF.getTableR () );
                 cmbFields.setSelectedItem ( opF.getFieldR () );

                 flag = 1;        
              }
            else {
                  ForeingButton.setSelected ( false );
                  setAvalaibleFKey ( false );
              }

            if (flag == 0) {
                	isKey.setSelected ( false );
                	setAvalaibleKey   ( false );
                	setAvalaibleFKey  ( false );
            }
        } // e.getClickCount () == 1 ) && ( index > -1 ) && ( fieldsN.size () > 0 
      }
     }; // End of mouseListener

     fieldJList.addMouseListener ( mouseListener );

     leftPanel.setLayout ( new BorderLayout () );

     JToolBar iconBar = new JToolBar ( SwingConstants.VERTICAL );
     iconBar.setFloatable ( false );

     URL imgURL = getClass ().getResource ( "/icons/16_AddField.png" );
     JButton addField = new JButton ( new ImageIcon ( Toolkit.getDefaultToolkit ().getImage ( imgURL )));
     addField.setActionCommand  ("ADD-F");
     addField.setToolTipText    ( idiom.getWord ( "ADDF" ) );
     addField.addActionListener ( this );

     iconBar.add ( addField );

     imgURL = getClass().getResource("/icons/16_UpdateRecord.png");
     JButton updateField = new JButton ( new ImageIcon ( Toolkit.getDefaultToolkit().getImage (imgURL)));
     updateField.setActionCommand ("UP-F");
     updateField.setToolTipText ( idiom.getWord ("UPDREC") );
     updateField.addActionListener( this );
     iconBar.add ( updateField );

     imgURL = getClass().getResource ( "/icons/16_del.png" ); 
     delField = new JButton ( new ImageIcon ( Toolkit.getDefaultToolkit().getImage ( imgURL )));
     iconBar.add ( delField );
     delField.setActionCommand ( "DEL-ONE" );
     delField.setToolTipText ( idiom.getWord ( "DROPF" ));
     delField.addActionListener ( this );

     imgURL = getClass().getResource ( "/icons/16_delAll.png" );
     delAll = new JButton(new ImageIcon ( Toolkit.getDefaultToolkit ().getImage ( imgURL )));
     delAll.setActionCommand ( "DEL-ALL" );
     delAll.setToolTipText ( idiom.getWord ( "DELALL" ));
     delAll.addActionListener ( this );

     iconBar.add ( delAll );
     delField.setEnabled ( false );
     delAll.setEnabled ( false );

     JPanel downLeft = new JPanel();
     downLeft.setLayout ( new BorderLayout ());
     downLeft.add ( iconBar, BorderLayout.WEST );
     downLeft.add ( componente, BorderLayout.CENTER );

     leftPanel.add(downLeft,BorderLayout.CENTER);
  
     // ConstrucciÔøΩn parte inferior derecha de la ventana  Exactly, left side. Nick

     JPanel line1 = new JPanel();

     String[] values = ChkType.getListTypes() ;   // Nick 2012-07-20   
     TF = values [0];                               
     typeIndex = ChkType.getCategType ( TF );
     
     typeFieldCombo = new JComboBox ( values );
     typeFieldCombo.setActionCommand ( "TYPES" );
     typeFieldCombo.addActionListener ( this );

     // Nick 2012-07-19
     booleanCombo = new JComboBox  ( ChkType.cBOOLARRAY );
     booleanCombo.setBackground     ( Color.white );
     booleanCombo.setActionCommand  ( "COMBOB" );
     booleanCombo.addActionListener ( this );
     booleanCombo.setEnabled        ( false );
     
     JPanel bar = new JPanel ();
     bar.setLayout ( new GridLayout ( 1, 2 ));
     bar.add ( new JLabel ( idiom.getWord ("NAME") + cDP + cSPACE )); 
     bar.add ( textField3 );
  
     line1.setLayout ( new GridLayout( 1, 2 ));
     line1.add ( new JLabel ( idiom.getWord ( "TYPE" ) + cDP + cSPACE )); 
     line1.add ( typeFieldCombo ); 
  
     JPanel line2 = new JPanel ();
     JLabel msgString5 = new JLabel ( idiom.getWord ( "LENGHT" ) + cDP + cSPACE );
     textField5 = new JTextField (12); // Length of field
     textField5.setEditable ( false );
     textField5.setEnabled  ( false );

     line2.setLayout ( new GridLayout ( 1, 2 ));
     line2.add ( msgString5 ); 
     line2.add ( textField5 );
  
      // Nick 2012-07-05
      textField51 = new JTextField (12);
      textField51.setEditable ( false );
      textField51.setEnabled( false );
      JLabel msgString51 = new JLabel ( idiom.getWord ("PREC") + cDP + cSPACE );
      
      JPanel line21 = new JPanel ();
      line21.setLayout( new GridLayout ( 1, 2 ));
      line21.add ( msgString51 );
      line21.add( textField51 );
      
      CBr3 = new JCheckBox ();
      CBr3.setActionCommand ("CHECK-DEFV");
      CBr3.addActionListener ( this );
      
      textField6 = new JTextField (12); // default value. Nick 2010-01-04 
      textField6.setEditable ( false );
      textField6.setEnabled  ( false );

      defPanel_0.setLayout ( new GridLayout (0, 2) ); //  
     
      defPanel_1.setLayout ( new BorderLayout());
      defPanel_1.add ( CBr3, BorderLayout.WEST );                        
      defPanel_1.add ( new JLabel ( idiom.getWord ( "DEFVALUE" ) + cDP + cSPACE ), 
    		                        BorderLayout.CENTER );  
      defPanel_0.add ( defPanel_1 );   

      // Nick 2012-07-20
      if ( TF.equals(ChkType.cBOOL)) defPanel_0.add ( booleanCombo);
        else defPanel_0.add ( textField6 );

      DVF = false;
      DV = cEMP;
      
      JPanel lcomm = new JPanel();
      lcomm.setLayout ( new GridLayout ( 1, 2 ) );
      lcomm.add (new JLabel ( idiom.getWord ( "COMM" ) + cDP + cSPACE ), BorderLayout.WEST );
      lcomm.add ( commRow, BorderLayout.CENTER );
      
      JPanel line4 = new JPanel ();
      CBr4 = new JCheckBox ();
      CBr4.setActionCommand  ("CHECK-REV");
      CBr4.addActionListener ( this );

      textField7 = new JTextField ( 12 );
      textField7.setEditable ( false );
      textField7.setEnabled  ( false );

      JPanel side2 = new JPanel ();
      side2.setLayout ( new BorderLayout () );
      side2.add ( CBr4, BorderLayout.WEST );
      side2.add ( new JLabel ( idiom.getWord ("CHECK") + cDP + cSPACE ), BorderLayout.CENTER );
      
      line4.setLayout ( new GridLayout ( 0, 2 ));
      line4.add ( side2 ); 
      line4.add ( textField7 );

      rowReferences = new JPanel ();
      msgReferences = new JLabel ( idiom.getWord ( "REFER" ) + cDP + cSPACE );
      rowReferences.setLayout ( new GridLayout ( 0, 2 ) );
      rowReferences.add ( msgReferences );
      rowReferences.add ( cmbReferences );

      rowFields = new JPanel ();
      msgFields = new JLabel ( idiom.getWord ("FIELD") + cDP + cSPACE);
      rowFields.setLayout ( new GridLayout ( 0, 2 ));
      rowFields.add ( msgFields );
      rowFields.add ( cmbFields );

      //Creacion Grid de CheckBox
      primaryButton = new JRadioButton ( idiom.getWord ( "PKEY" ) );
      primaryButton.setMnemonic('p'); 
      primaryButton.setEnabled(false);
      primaryButton.setActionCommand("PB");
      primaryButton.addActionListener(this);

      uniqueButton = new JRadioButton(idiom.getWord("UKEY"));
      uniqueButton.setMnemonic('u'); 
      uniqueButton.setEnabled(false);
      uniqueButton.setActionCommand("UB");
      uniqueButton.addActionListener(this);

      ForeingButton = new JCheckBox(idiom.getWord("FOKEY"));
      ForeingButton.setMnemonic('F');
      ForeingButton.setActionCommand ("FKEY");
      ForeingButton.addActionListener (this);

      NotNullBox = new JCheckBox (idiom.getWord ("NOTNULL"));
      NotNullBox.setMnemonic ('o');
      NotNullBox.setActionCommand ( "NOTNULL" );
      NotNullBox.setSelected (false);
      NotNullBox.addActionListener (this);

      isKey = new JCheckBox (idiom.getWord ("ISKEY"));
      isKey.setMnemonic ('n'); 
      isKey.setSelected (false);
      isKey.setActionCommand ("SKEY");
      isKey.addActionListener (this);

      JPanel line5 = new JPanel();
      line5.setLayout ( new FlowLayout ( FlowLayout.CENTER ));
      line5.add ( isKey );
      line5.add ( NotNullBox );

      checkPanel = new JPanel ();
      checkPanel.setLayout ( new FlowLayout ( FlowLayout.CENTER ));
      checkPanel.add ( primaryButton );
      checkPanel.add ( uniqueButton  );
      checkPanel.add ( ForeingButton );

      titleK = BorderFactory.createTitledBorder ( etched, idiom.getWord ( "OPKEY" ) );
      currentColor = titleK.getTitleColor ();
      checkPanel.setBorder ( titleK );
    
      combosPanel = new JPanel();
      combosPanel.setLayout ( new BoxLayout (combosPanel, BoxLayout.Y_AXIS ));
      combosPanel.add ( rowReferences );
      combosPanel.add ( rowFields );

      titleFK = BorderFactory.createTitledBorder ( etched, idiom.getWord ("FORS") );
      combosPanel.setBorder (titleFK); 
      combosPanel.setPreferredSize ( new Dimension ( 100, 80 ));

      JPanel block = new JPanel();
      block.setLayout ( new BoxLayout ( block, BoxLayout.Y_AXIS ));
      block.add (bar);
      block.add (line1);
      block.add (line2);
      block.add (line21);       // Nick 2012-07-05
      block.add (lcomm);        // Nick 2011-12-18 
      block.add (defPanel_0);   // Nick 2012-01-04
      block.add (line4);
      block.add (line5);

      TitledBorder titleBlock = BorderFactory.createTitledBorder ( etched );
      block.setBorder ( titleBlock );

      JPanel rightTop = new JPanel ();
      rightTop.setLayout ( new BoxLayout ( rightTop, BoxLayout.Y_AXIS ));

      rightTop.add ( block );
      rightTop.add ( checkPanel );
      rightTop.add ( combosPanel );

      JPanel rightPanel = new JPanel();
      rightPanel.setLayout ( new BoxLayout (rightPanel, BoxLayout.Y_AXIS));
      rightPanel.add ( rightTop );

      title = BorderFactory.createTitledBorder ( etched, idiom.getWord ("PROPF"));
      title.setTitleJustification ( TitledBorder.LEFT );
      rightPanel.setBorder ( title );

      //UniÔøΩn de todos los paneles inferiores de la ventana en un GridBadLayout
      title = BorderFactory.createTitledBorder ( etched, idiom.getWord ("FLIST"));
      title.setTitleJustification ( TitledBorder.CENTER );
      leftPanel.setBorder (title);

      setAvalaibleKey  ( false );
      setAvalaibleFKey ( false );

      JPanel downPanel = new JPanel();
      downPanel.setLayout ( new BoxLayout ( downPanel, BoxLayout.X_AXIS ));
      downPanel.add ( rightPanel );
      downPanel.add ( leftPanel );

      JPanel botones = new JPanel();
      botones.setLayout (new FlowLayout ( FlowLayout.CENTER ));

      JButton ok = new JButton(idiom.getWord ("CREATE"));
      ok.setActionCommand ( "OK" );
      ok.addActionListener ( this );

      JButton cancel = new JButton (idiom.getWord ("CANCEL"));
      cancel.setActionCommand ("CANCEL");
      cancel.addActionListener (this);

      botones.add (Inherit); // Nick 2011-12-18
      botones.add (ok);
      botones.add (cancel);
      
      JPanel global = new JPanel();
      global.setLayout ( new BoxLayout ( global, BoxLayout.Y_AXIS ));
      global.add (topPanel );
      global.add (downPanel);
      global.add (botones  );

      getContentPane().add( global );
      pack();
      
      setSize ( (cDICT_ASU_W), (cDICT_ASU_H + 15) ) ; // 70 Nick 2011-12-18
   
      setLocationRelativeTo ( fmain );
      setVisible ( true );
      
 } //  End of constructor

 public void actionPerformed ( java.awt.event.ActionEvent e ) {

   if ( e.getActionCommand().equals ("OK") ) {

          String SQL      = cEMP;
          String result   = cEMP;
          Vector l_vecSQL = new Vector ();
          
          CurrentTable = textTable.getText();

          if ( CurrentTable.length () > 0 ) {
              if ( CurrentTable.indexOf ( cSPACE ) == -1 ) { 
                  if ( fieldsN.size() == 0 ) {
                		 	JOptionPane.showMessageDialog ( CreateTable.this, idiom.getWord ("NOFCR"),
                		 			idiom.getWord ("ERROR!"), JOptionPane.ERROR_MESSAGE
          	 	       );
                      return;
                  }  // Nick 2011-10-18
                  
                // Nick 2011-12-18  
                if ( CurrentSCH != cPUBLIC ) 
                	     CurrentTable = CurrentSCH + cPOINT + cDQU + CurrentTable + cDQU;
                else
                	 CurrentTable = cDQU + CurrentTable + cDQU;
                
                SQL = cCRT + cTBL + CurrentTable + S_LBR ;
                
                for ( int i = 0; i < fieldsN.size (); i++ ) {

                     TableFieldRecord tmp = ( TableFieldRecord ) HashFields.get ( fieldsN.elementAt (i) );
                     SQL += cSPACE + cDQU + tmp.getName() + cDQU + cSPACE + tmp.getOptions().getDbType(); //  getType ();

                     if ( tmp.getOptions ().isNullField () ) SQL += cSPACE + cNOT + cNULL;    
                     if ( tmp.getOptions ().isUnicKey () )   SQL += c_UNIQUE;      
                     if ( tmp.getOptions ().isPrimaryKey ()) SQL += cSPACE + cPRM + cKEY; 

                     if ( tmp.getOptions ().getDefaultValue ().length() > 0 )  
                                          SQL += c_DEFAULT + tmp.getOptions().getDefaultValue ();
                     if ( tmp.getOptions ().getCheck ().length () > 0 ) 
                    	                            SQL += c_CHECK + tmp.getOptions().getCheck();
                     if ( tmp.getOptions().isForeingKey () )
                         SQL += c_REFERENCES + cDQU + tmp.getOptions().getTableR() + 
                                cDQU + S_LBR + cDQU + tmp.getOptions().getFieldR () + cDQU + S_RBR;
                     if ( i != fieldsN.size () -1 ) SQL += cCOMMA;
		        } // end for i

                /** Nick 2011-12-18
                 if ( consActive ) {

                     String ctr = cEMP;
                     for ( int i = 0; i < ConstNames.size (); i++ )
                       ctr += cCOMMA + c_CONSTRAINT + ConstNames.elementAt(i) + 
                              cSPACE + ConstDef.elementAt (i); 
                     SQL += ctr;
                  }
                 ***/
                /**
                 if ( CBCheck.isSelected () ) {

                     String tC = textCheck2.getText ();
                     if ( tC.length () > 0 ) SQL += cCOMMA + c_CHECK + S_LBR + tC + S_RBR;    
                  }
                 **/
                
                 SQL += S_RBR;

                 if ( inheritActive ) SQL += c_INHERITS + S_LBR + inheritString + S_RBR;

                 SQL += S_SC;
                 l_vecSQL.add (SQL); // Nick 2011-12-18

                 SQL = cCMT + cTBL + CurrentTable + cSPACE + cIS + commTable.getText() + cSEP;
                 SQL += S_SC; 
                 l_vecSQL.add ( SQL);
                 
                 for ( int i = 0; i < fieldsN.size (); i++ ) {

                     TableFieldRecord tmp = ( TableFieldRecord ) HashFields.get ( fieldsN.elementAt (i) );
                     SQL = cCMT + cCOL + CurrentTable + cPOINT + tmp.getName() + cSPACE + cIS +
                     tmp.getComment() + cSEP ;
                     SQL += S_SC;
                     l_vecSQL.add ( SQL );

                 } // for i                 
                 
                 for ( int i = 0; i < l_vecSQL.size(); i++ ) {
                	 SQL = (String ) l_vecSQL.elementAt (i).toString ();

                	 addTextLogMonitor ( idiom.getWord ("EXEC") + SQL + cDQU );
                     result = current.SQL_Instruction ( SQL );
                     
                     if ( ! result.equals ( cOK )) {
                         result = result.substring ( 7, result.length () - 1 );
                         addTextLogMonitor ( idiom.getWord ("RES") + result );
                         JOptionPane.showMessageDialog ( 
                      		CreateTable.this, idiom.getWord ("ERRORPOS") + result,                       
                                        idiom.getWord("ERROR!"), JOptionPane.ERROR_MESSAGE 
                         );
                         return;
                     }
                 } // for i
                 
                 wellDone = true;
                 addTextLogMonitor ( idiom.getWord ("RES") + result + 
                		             cPOINT + cSPACE + idiom.getWord ("CRT"));
                 addTextLogMonitor ( idiom.getWord ("VCTT") );
                 //
                 setVisible ( false );
                 return;
	       }
              else {
                     JOptionPane.showMessageDialog ( 
                    	   CreateTable.this, idiom.getWord ("TNIVCH"),                       
                                     idiom.getWord ("ERROR!"), JOptionPane.ERROR_MESSAGE
                     );
                     return;
                }   
           } // CurrentTable.length ()
          else {
                 JOptionPane.showMessageDialog (CreateTable.this,                               
                 idiom.getWord("TNNCH"),                       
                 idiom.getWord("ERROR!"),JOptionPane.ERROR_MESSAGE);               
           }
          return;
      }  // e.getActionCommand().equals ("OK")

   if (e.getActionCommand().equals("CANCEL")) {

       addTextLogMonitor ( idiom.getWord ("VCTT") );
       setVisible (false);
       return;
    }  // e.getActionCommand().equals ("CANCEL")

   if ( e.getActionCommand().equals ("COMBO-DB") ) {

       dbn = (String) cmbDB.getSelectedItem ();

       int index = dbNames.indexOf ( dbn );
       current = (PGConnection) vecConn.elementAt ( index );

       rowReferences.remove ( cmbReferences );
       rowFields.remove ( cmbFields );

       Xschemas.removeAllElements();
       Vector Xschemas_1 = new Vector( current.getSCHVector () );  
       for ( int i = 0; i < Xschemas_1.size (); i++ ) 
           Xschemas.add ( GetStr.getStringFromVector ( Xschemas_1, i, -1 ));
       CurrentSCH = ( String ) Xschemas.elementAt(0).toString (); // Nick 2012-01-05
       //
       // 03-02-2012 Nick
       this.rowDB.remove ( cmbSCH ); //Nick 2012-02-03
       cmbSCH = new JComboBox ( Xschemas );
       CurrentSCH = ( String ) Xschemas.elementAt(0).toString (); // Nick 2012-01-05
       // CurrentSCH = currentSCH; // from parameter of constructor
       cmbSCH.setSelectedItem ( CurrentSCH ) ;
       
       cmbSCH.setActionCommand ( "COMBO-SCH" );
       cmbSCH.addActionListener ( this );
      
       rowDB.add (cmbSCH);
       rowDB.updateUI(); // 2012-02-03 Nick  
       
       
       getListTables ();

       cmbReferences.setActionCommand ("CMB-REF"); // 2012-01-04 Nick
       cmbReferences.addActionListener (this);

       rowReferences.add ( cmbReferences );
       rowReferences.updateUI ();
       rowFields.add ( cmbFields );
       rowFields.updateUI  ();
   } // COMBO-DB

// --------------------------------------------------
   if ( e.getActionCommand().equals ("COMBO-SCH") ) {

	   CurrentSCH = ( String ) cmbSCH.getSelectedItem();  // Nick 2012-02-03 

       rowReferences.remove ( cmbReferences );
       rowFields.remove ( cmbFields );
	   
       getListTables ();

       cmbReferences.setActionCommand ("CMB-REF"); // 2012-01-04 Nick
       cmbReferences.addActionListener (this);

       rowReferences.add ( cmbReferences );
       rowReferences.updateUI ();
       rowFields.add ( cmbFields );
       rowFields.updateUI  ();
   } // COMBO-SCH
   
   if (e.getActionCommand().equals ("COMBOB")) {
		  DV = booleanCombo.getSelectedItem().toString(); // + cDP2 + ChkType.cBOOL
		  // System.out.println ( "Event: DV = " + DV );
		  return ;
	  }
   
   if ( e.getActionCommand ().equals( "NOTNULL") )  {  // 2012-07-20 Nick
	 NN = NotNullBox.isSelected() ;  
	 if ( typeIndex == 12 ) // Serial, bigserial 
	    {
	      NN = true;
	      NotNullBox.setSelected (NN) ; 
	    } 
    } // NOTNULL command

   // --------------------------------------------------   
   if ( e.getActionCommand().equals ("BUT-INHE")) {

       TableList = current.getTblNamesVector ( CurrentSCH );
       num = TableList.size();
       String as[] = new String [ num ];
       for ( int i = 0; i < num; i++ ) {
                   as [i] = GetStr.getStringFromVector (TableList, i, -1) ;
       }

       if (num == 0) {
           JOptionPane.showMessageDialog ( 
        		   CreateTable.this, idiom.getWord ("TNTAB") + current.getDBname() + "'.",
                                 idiom.getWord("INFO"), JOptionPane.INFORMATION_MESSAGE
                   );
           return;
        }

     Inherit inDialog = new Inherit ( CreateTable.this, idiom, CurrentSCH, as, tablesH );

     if ( inDialog.isWellDone () ) { 

         inheritActive = true; 
         inheritString = inDialog.getTableList ();
         tablesH       = inDialog.getVector ();
      }                      
     else { 
           inheritActive = false;
           inheritString = "";
           tablesH = new Vector();
      }
   }

   /****
   if ( e.getActionCommand().equals ( "BUT-CONST" )) {

       Constraint winCons = new Constraint ( CreateTable.this, idiom, ConstNames, ConstDef );

       if ( winCons.isWellDone () ) {

           consActive = true;
           ConstNames = winCons.getConsN ();
           ConstDef   = winCons.getConsD (); 
        }
       else {
             consActive = false;
             ConstNames = new Vector ();
             ConstDef   = new Vector ();
        }
    }
   ***/
/***
  if ( e.getActionCommand().equals ( "CHECK-Check" ) ) {

      boolean hab = false;

      if ( CBCheck.isSelected() ) hab = true;

      // textCheck2.setEnabled (hab);
      // textCheck2.setEditable (hab);

      return;
   }
***/
  if ( e.getActionCommand ().equals ( "CMB-REF" )) {

      String tableN = (String) cmbReferences.getSelectedItem ();

      if ( !tableN.startsWith (idiom.getWord ("NOTABLES") ) ) {

          Vector listTables = new Vector();
          listTables.addElement ( tableN );
          
          // 2011-11-13 Nick
          Vector tR = current.getTablesStructure ( listTables, CurrentSCH );
          cTable = (Table) tR.elementAt(0);

          rowFields.remove ( cmbFields );
          cmbFields = new JComboBox ( cTable.getTableHeader ().getNameFields () );
          rowFields.add ( cmbFields );
          rowFields.updateUI ();
       }
      return;
   }

  /**
   *  Check default value box. Nick 2012-01-04
   */
  if ( e.getActionCommand ().equals ( "CHECK-DEFV" )) { 

    DVF = CBr3.isSelected() ;
    if ( TF.equals(ChkType.cBOOL) ) booleanCombo.setEnabled (DVF);
        else {
              if ( typeIndex == 12 ) /// Serial, bigserial 
               { 
            	 DVF = false;
                 CBr3.setSelected ( DVF );
              
                 NN = true;
                 NotNullBox.setSelected ( NN ) ; 
               }
              textField6.setEditable( DVF );
              textField6.setEnabled ( DVF );
        }
      return;
   } // The CHECK-DEFV command

   /**
    *  Check box for row constraint. Nick 2012-01-04
    */
  if ( e.getActionCommand ().equals ("CHECK-REV") ) {

      textField7.setEnabled  ( CBr4.isSelected () );
      textField7.setEditable ( CBr4.isSelected () );

      return;
   }

  if ( e.getActionCommand ().equals ("SKEY") ) {

      setAvalaibleKey ( isKey.isSelected () );
      combosPanel.updateUI ();
      return;
   }

  if ( e.getActionCommand().equals ("PB") ) {

      uniqueButton.setSelected ( !( primaryButton.isSelected () ) );
      return;
   }

  if ( e.getActionCommand ().equals ( "UB") ) {

      primaryButton.setSelected ( !( uniqueButton.isSelected () ) );
      return;
   }

  if ( e.getActionCommand ().equals ("FKEY") ) { // Nick 2012-01-04

      setAvalaibleFKey ( ForeingButton.isSelected () );
      combosPanel.updateUI();

      return;
   }

  if ( e.getActionCommand().equals ("TYPES") ) {

    TF = (String) typeFieldCombo.getSelectedItem ();
    typeIndex = ChkType.getCategType ( TF );      
    setAfterTypes ();
    
    return;
   }

  if ( e.getActionCommand().equals ( "ADD-F" )) { // Add field.  Nick 

      FieldHashOp (0);
      return;
   }

  if ( e.getActionCommand().equals ( "UP-F" )) { // Update field. Nick

      FieldHashOp (1);
      return;
   }

  if ( e.getActionCommand().equals ( "DEL-ALL" )) { // Delete all fields. Nick 2012-01-04

      fieldJList.setListData ( new Vector () );
      fieldsN = new Vector ();
      cleanCreateT ();
      
      delField.setEnabled ( false );
      delAll.setEnabled ( false );

      return;
   }

   if ( e.getActionCommand ().equals ( "DEL-ONE" ) ) {

       String del = (String) fieldJList.getSelectedValue ();

       if ( fieldsN.remove (del) ) {

           fieldJList.setListData ( fieldsN );
           HashFields.remove ( del );

           if ( fieldsN.size () == 0) { // All items were deleted Nick 2012-01-04

               delField.setEnabled (false);
               delAll.setEnabled (false);
            }
        }
     }
  } // ActionPerformer

 /**
  *  Set key's radio bottons. Nick 2012-01-04
  * @param state
  */
 private void setAvalaibleKey ( boolean state ) {

   if (!state) {

       titleK.setTitleColor ( new Color ( 153, 153, 153 ));
       uniqueButton.setSelected  ( false);
       primaryButton.setSelected ( false);
       ForeingButton.setSelected ( false);
       ForeingButton.setEnabled  ( false);
       
       // setAvalaibleFKey ( false ); Nick 2012-07-10
    }
   else {
         titleK.setTitleColor (currentColor);

         String table = (String) cmbReferences.getSelectedItem ();

         if ( table.equals ( idiom.getWord ( "NOTABLES" ))) ForeingButton.setEnabled ( false );
         else
             ForeingButton.setEnabled ( true );
    }

   checkPanel.updateUI ();
   
   primaryButton.setEnabled (state);
   uniqueButton.setEnabled (state);
 } // setAvalaibleKey
 
 /**
  * Setting parameters of foreign reference.
  * @Author  2011-12-03 Nick.  
  * @param state
  */
 private void setAvalaibleFKey ( boolean state ) {

   if ( state ) titleFK.setTitleColor ( currentColor );
   else {  
         titleFK.setTitleColor ( new Color( 153, 153, 153 ));
         cmbReferences.setSelectedIndex (0); /// Nick 2011-12-03 ??????????
         cmbFields.setSelectedIndex (0);
    }

   msgFields.setEnabled (state);
   cmbFields.setEnabled (state);
   msgReferences.setEnabled (state);
   cmbReferences.setEnabled (state);
   
  } // setAvalaibleFKey

/***
 *  Set visual attributes after the field type choice.
 *  @author Nick 2012-07-22
 */
 private void setAfterTypes () {

    defPanel_0.removeAll ();
    defPanel_0.add ( defPanel_1 );
    DVF = false;
    DV = cEMP;
    CBr3.setSelected ( DVF );          // It is from defPanel_1 

    if ( TF.equals(ChkType.cBOOL) ) {
    	      defPanel_0.add ( booleanCombo) ;
              booleanCombo.setEnabled (DVF);
      }  
        else {
	          defPanel_0.add ( textField6 );
              if ( typeIndex == 12 ) // Serial, bigserial 
               { 
            	 DVF = false;
                 CBr3.setSelected ( DVF );
              
                 NN = true;
                 NotNullBox.setSelected ( NN ) ; 
               }
              textField6.setEditable( DVF );
              textField6.setEnabled ( DVF );
              textField6.setText ( cEMP );
        }
      defPanel_0.updateUI ();
	  
      boolean flagT = ( (typeIndex == 1) || 
    	       ((typeIndex == 3) && (! TF.equals(ChkType.cTEXT))) ||
    	       (typeIndex == 11)   // decimal,number, char, varchar, bit,varbit
    	     ) ; 
      textField5.setEditable ( flagT );
      textField5.setEnabled ( flagT );
      textField5.setText ( cEMP );
      //
      boolean flagP = ( typeIndex == 1 ) ; // Decimal, number 
      textField51.setEditable ( flagP );
      textField51.setEnabled ( flagP );
      textField51.setText ( cEMP );

      return;
 }

 /**
 * Clean all fields in left panel. Nick 2012-01-04
 */
 private void cleanCreateT () {

   NotNullBox.setSelected ( false );

   typeFieldCombo.setSelectedIndex (0);
   TF = (String) typeFieldCombo.getSelectedItem ();
   typeIndex = ChkType.getCategType ( TF );      
   setAfterTypes ();

   CBr4.setSelected ( false ); 

   NN = false ;                   // Nick 2012-10-28
   NotNullBox.setSelected ( NN ); // Nick 2012-10-28
   
   DVF = false;
   DV = cEMP;
   
   textField6.setEditable ( DVF );
   textField6.setEnabled ( DVF );
   textField6.setText ( DV );

   textField3.setText (cEMP);  // Name of column. Nick 2012-01-04
   textField7.setText (cEMP);  // Check field. 
   textField7.setEditable ( false );
   textField7.setEnabled ( false );
   textField5.setText (cEMP);  // Length of field.
   textField51.setText(cEMP);  // Precision of field.
   commRow.setText    (cEMP);  // Comment of field.
   
   isKey.setSelected ( false );
   setAvalaibleKey   ( false );
   setAvalaibleFKey  ( false );
   
   defPanel_0.updateUI ();    // Nick 2012-01-04
   combosPanel.updateUI ();
   
  } // cleanCreateT

  /*********************************************************
  *  Check the table parameters. Add/Update the HashFields.  
  *  @author  Gustavo
  *  Modified 2012-01-04, 2012-07-07  Nick
  *  @param i - 0 add the field parameters to the HashFields,
  *             1 update the field parameters
  */
 
 private void FieldHashOp (int i) {  

   String nameF = textField3.getText ();
   String commF = this.commRow.getText (); // Nick 2012-01-04 
   
   boolean inside = false;

   if ( nameF.length () > 0 ) {

       if ( nameF.indexOf ( cSPACE ) != -1 ) {

           JOptionPane.showMessageDialog ( 
        		    CreateTable.this, idiom.getWord ( "FNIVCH" ),
                                      idiom.getWord ("ERROR!"), JOptionPane.ERROR_MESSAGE 
           );

           return;
        }  
    }
   else {
          JOptionPane.showMessageDialog ( 
        		  CreateTable.this, idiom.getWord ("FEMPT"),
        		  					idiom.getWord ("ERROR!"), JOptionPane.ERROR_MESSAGE
          );
          return;
        }

   if ( i == 0 ) { // Add field. Nick 2012-01-04

       if (fieldsN.contains ( nameF )) {
             JOptionPane.showMessageDialog ( 
            		 CreateTable.this, idiom.getWord ("EMPTEX"),
                                       idiom.getWord ("ERROR!"), JOptionPane.ERROR_MESSAGE
           );
           return;
        }
    }
   else {  // Update field
         if ( !fieldsN.contains ( nameF ) ) {  // Field doesn't exist. Nick 2012-01-04
             GenericQuestionDialog addNF = new GenericQuestionDialog ( fmain, 
            		 idiom.getWord ("OK"), idiom.getWord ("CANCEL"), 
            		 idiom.getWord ("NOEXISF"), idiom.getWord ("NOEXISF2"));

         if ( addNF.getSelecction() ) inside = true;
         else 
             return;
         }  // Field doesn't exist. Nick 2012-01-04
    } // Update field

   String Stype = TF;
   typeIndex = ChkType.getCategType ( this.TF ); // Nick 2012-07-23
   
   String referT = cEMP;
   String referF = cEMP;
   
   boolean fkey    = false;
   boolean key     = false;
   boolean pkey    = false;
   boolean ukey    = false;

   int lenField  = -1;
   int precField = -1;

   if ((typeIndex == 1) || ((typeIndex == 3) && ( TF != ChkType.cTEXT)) ||
	   (typeIndex == 11 ) // The DB types with length	   
	  ) {
       if ( textField5.isEnabled () ) {
    	   String longf = textField5.getText().trim();
           if ( longf.length () > 0 ) {
               if ( !ChkType.isNum (longf) ) {
                   JOptionPane.showMessageDialog ( 
                		   CreateTable.this, idiom.getWord ("INVLENGHT"),
                                             idiom.getWord ("ERROR!"), JOptionPane.ERROR_MESSAGE 
                   );
                   textField5.requestFocus();
                   return;
                } // Illegal type of length's expression

               Stype = Stype + S_L_BR + longf ;
               lenField = Integer.parseInt (longf);
           } // Len > 0

           if ( textField51.isEnabled () ) {
               String prec_str = textField51.getText().trim() ;
               if ( prec_str.length () > 0 )  {
                    if ( ! ChkType.isNum (prec_str) ) {
            	        JOptionPane.showMessageDialog ( CreateTable.this,
                                idiom.getWord ( "INVPREC" ), idiom.getWord ( "ERROR!" ), 
                                JOptionPane.ERROR_MESSAGE 
                       ); 
            	       textField51.requestFocus();
            	       return;
                    } // Illegal expression of length

            	   Stype += cCOMMA + prec_str;
                   precField = Integer.parseInt (prec_str);
               } // prec > 0 
           } // Prec is enabled
           Stype += S_R_BR;
        } // Length isEnabled
    } // The DB type with length
     
   if (DVF) {
	  if (!TF.equals(ChkType.cBOOL)) DV = textField6.getText().trim(); 
      if ( DV.length () > 0 ) { // Default value setting
            if ( ChkType.validValue ( typeIndex, DV ) ) 
                 DV = ChkType.setAddChar ( typeIndex, cDP2 + Stype, DV ); // TF
                      else {  JOptionPane.showMessageDialog ( CreateTable.this,
                                  idiom.getWord ( "INVDEFAULT" ), idiom.getWord ( "ERROR!" ), 
                                  JOptionPane.ERROR_MESSAGE
                               );
                              textField6.requestFocus();
                              return;
    	              }
                  } // ( DV.length () > 0 )
   } // DVF

   if ( isKey.isSelected () ) {
      key = true;
      if ( ForeingButton.isSelected () ) {
          fkey = true;
          referT = (String) cmbReferences.getSelectedItem ();
          referF = (String) cmbFields.getSelectedItem ();
       }
      if ( primaryButton.isSelected () ) pkey = true;
      if ( uniqueButton.isSelected () )  ukey = true;
    }

   OptionField opF = new OptionField  ( Stype, typeIndex, lenField, precField, NN, pkey, ukey, 
		                                fkey, DV 
   );

   if ( fkey ) opF.setRefVal ( referT, referF );
   if ( CBr4.isSelected () ) opF.setCheck (textField7.getText().trim());
   //
   // Very important !! Second parameter (TF/Stype ) is name of type without length and precision
   //                   N ick 2012-07-23
   //
   TableFieldRecord field = new TableFieldRecord ( nameF, TF, commF,  opF ); // Comment must be 2011-10-16
   HashFields.put ( nameF, field );

   if ( i==0 || inside ) {  // We are adding new field. Nick

       if ( fieldsN.size () == 0 ) {
           				delField.setEnabled (true);
           				delAll.setEnabled (true);
        }
       fieldsN.addElement ( nameF );
       fieldJList.setListData ( fieldsN );
    }
   
   cleanCreateT ();
  } // End of FieldHashOp. Nick 2012-01-04 

 /**
  * Metodo addTextLogMonitor
  * Imprime mensajes en el Monitor de Eventos
  */
  private void addTextLogMonitor(String msg) {

    LogWin.append ( msg + cLF );
    int longiT = LogWin.getDocument().getLength();

    if (longiT > 0) LogWin.setCaretPosition(longiT - 1);
   } 
  
  /***
   * Get list of tables from  current DB and current schema.
   * Nick 2012-01-04
   **/
   private void getListTables () {
       // 2011-10-16 Nick
       TableList = current.getTblNamesVector ( CurrentSCH );

       if ( TableList.size () > 0 ) {

           if ( isKey.isSelected ()) {
               	if ( !ForeingButton.isEnabled () ) ForeingButton.setEnabled ( true );
           }
           String[] tables = new String [ TableList.size () ];

           for ( int i = 0; i < TableList.size (); i++ ) 
                   	tables[i] = GetStr.getStringFromVector ( TableList, i, 0);

           Vector listTables = new Vector ();
           listTables.addElement ( tables[0] );
           
           // 13-11-2011 Nick.   
           Vector tR = current.getTablesStructure ( listTables, CurrentSCH );
           cTable = (Table) tR.elementAt (0);

           cmbFields = new JComboBox ( cTable.getTableHeader ().getNameFields ( ));
           cmbReferences = new JComboBox ( tables );
           
           cmbFields.setEnabled (false);
           cmbReferences.setEnabled (false);
         }
       else {
              String[] listNull = {idiom.getWord("NOTABLES")};
              String[] listNull2 = {idiom.getWord("NOREG")};
              cmbFields = new JComboBox ( listNull2 );
              cmbReferences = new JComboBox ( listNull );

              if ( isKey.isSelected () && ForeingButton.isEnabled () ) {

                 	ForeingButton.setSelected ( false );
                 	ForeingButton.setEnabled ( false );
              }
            } 
   } // getListTables
  
 /**
  * Metodo getWellDone 
  * 
  */
  public boolean getWellDone() {
     return wellDone;
   }

} //Fin de la Clase
