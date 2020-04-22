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
 *  CLASS Structures @version 1.0 
 *      This class is responsible for showing the structure of table.
 * --------------------------------------------------------------------
 * Folder ¹1 in the main user interface. 
 * It shows the description of the table(view) structure. 
 * Necessary to do the some extension of functionality: 
 * 		 1) the full-function visual editor of the table structure
 *           ( instead of class InsertTableField ) 
 *        2) to DROP the class Properties Table. |It is depricated. 
 *        3) to create the new class displaying structure of the table 
 *           in the correct form of the CREATE TABLE clause, with 
 *           possibility of its export to a CSV-file. 
 * --------------------------------------------------------------------
 *  History:
 *           
 */

package ru.nick_ch.x1.structure;

import java.awt.BorderLayout;
import java.awt.Color;
import java.awt.Component;
import java.awt.Dimension;
import java.awt.FlowLayout;
// import java.awt.Font;
import java.awt.Toolkit;
import java.awt.event.ActionListener;
import java.awt.event.FocusEvent;
import java.awt.event.FocusListener;
import java.awt.event.KeyEvent;
import java.awt.event.KeyListener;
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
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JList;
import javax.swing.JOptionPane;
import javax.swing.JPanel;
import javax.swing.JScrollPane;
import javax.swing.JTable;
import javax.swing.JTextArea;
import javax.swing.JTextField;
import javax.swing.JToolBar;
import javax.swing.ListSelectionModel;
import javax.swing.SwingConstants;
import javax.swing.border.Border;
import javax.swing.border.TitledBorder;
import javax.swing.table.AbstractTableModel;
import javax.swing.table.TableColumn;

import ru.nick_ch.x1.db.ForeignKey;
import ru.nick_ch.x1.db.PGConnection;
import ru.nick_ch.x1.db.Table;
import ru.nick_ch.x1.db.TableFieldRecord;
import ru.nick_ch.x1.db.TableHeader;
import ru.nick_ch.x1.idiom.Language;
import ru.nick_ch.x1.utilities.*;
import ru.nick_ch.x1.menu.TablesGrant;
//import ru.nick_ch.x1.xsd.*;

public class Structures extends JPanel implements ActionListener, SwingConstants, FocusListener, KeyListener {

 PGConnection current_conn;
 Language     idiom;
 
 Object [][] data = {{ "", "", "", "", "" }}; // Nick, previous sequence is {"" * 4}     
 String [] columnNames = new String [ 5 ];    // 4
 int columnQty = 5;                           // Nick, it is parameter, old value is 4, new - 5
 
 private boolean DEBUG = true;
 
 JFrame     frameFather;
 JTextField title;
 JTextArea  LogWin;
 JTable     table;
 
 JScrollPane tableSpace2;
 JToolBar    StructureBar;
 JButton     addField, editField, properties, details;
 
 JList      indexList; 
 JTextField fieldJText;
 
 JLabel indexLabel, propertiesLabel;
 JLabel uniqueLabel, primaryLabel, treeLabel; 
 
 TitledBorder title1, title2;
 
 Color currentColor;
 JPanel indexPanel;
 
 MouseListener mouseListener;

 Table   currTable ;  // Nick 2009-10-07
 String  currentTable;
//Nick 2009/10/06
 boolean currentTable_is_Xrd ;        
 String  currentTable_schema ;    
 boolean currentTable_userSchema ; 	 
 
 int DBComponentType = 41; // Nick 2009-07-07. It has to be: 41 - any table, 42 - any view 
 //                  See setDBComponentType ( int ) method on bottom.  
 
 boolean isEmpty = true;
 int numIndex = 0;
 
 Vector indexN = new Vector();
 Vector fk = new Vector();
 
 Hashtable hashFk = new Hashtable();
 Border    etched;
 
 /**
  *  METODO CONSTRUCTOR
  */
 public Structures ( JFrame parent, Language glossary, JTextArea monitor ) {
   
   frameFather = parent;
   idiom       = glossary;
   LogWin      = monitor;
   setLayout ( new BorderLayout () ); //Divide el panel como BorderLayout

   StructureBar = new JToolBar ( SwingConstants.VERTICAL );
   StructureBar.setFloatable ( false );
   CreateToolBar ();
   activeToolBar ( false );
   
   title = new JTextField ( idiom.getWord ( "NOSELECT" ));
   title.setHorizontalAlignment ( JTextField.CENTER );
   title.setEditable ( false );

   JPanel upSide = new JPanel();
   upSide.setLayout ( new BorderLayout () );
   upSide.add ( title );

   etched = BorderFactory.createEtchedBorder ();
   title1 = BorderFactory.createTitledBorder ( etched );

   upSide.setBorder ( title1 );

   formatTable ();
   table.setEnabled ( false );
   tableSpace2.setEnabled ( false );
   
   add ( upSide, BorderLayout.NORTH );       //Aï¿½adir Tï¿½tulo al norte
   add ( StructureBar, BorderLayout.WEST );  //Aï¿½adir Barra de iconos a la izquierda
 
   // Creaciï¿½n de panel de index izquierdo
   indexLabel = new JLabel ( idiom.getWord ( "INDEX" ), JLabel.CENTER ); 
   indexList  = new JList ( new Vector () ); 

   indexList.setSelectionMode ( ListSelectionModel.SINGLE_SELECTION );
   indexList.setVisibleRowCount ( 4 );  // la lista es de tamaï¿½o 4
   indexList.addFocusListener ( this );

   mouseListener = new MouseAdapter() {

       public void mousePressed ( MouseEvent e) {

         int index = indexList.locationToIndex(e.getPoint());

         if (index != -1) {
             String indexName = (String) indexList.getSelectedValue();
             settingIndex(indexName);
          }
      }
   };
  indexList.addMouseListener ( mouseListener );


   JScrollPane indexScroll = new JScrollPane ( indexList );
   indexScroll.setPreferredSize ( new Dimension ( 290, 70 )); // 200,65 Nick 2009-07-10 

   JPanel bloke = new JPanel ();
   bloke.add ( indexScroll );
   
   JPanel indexLeft = new JPanel (); 
   indexLeft.setLayout ( new BorderLayout () );
   indexLeft.add ( indexLabel, BorderLayout.NORTH );
   indexLeft.add ( bloke, BorderLayout.CENTER );

   JPanel todo = new JPanel();
   todo.setLayout ( new FlowLayout () );
   todo.add ( indexLeft );

   // Create the radio buttons.
   URL imgURL = getClass().getResource("/icons/dot.png");
   uniqueLabel  = new JLabel(idiom.getWord("UKEY"),
		 new ImageIcon(Toolkit.getDefaultToolkit().getImage(imgURL)),SwingConstants.LEFT);
   
   primaryLabel = new JLabel ( idiom.getWord ( "PKEY" ),
			      new ImageIcon ( Toolkit.getDefaultToolkit ().getImage ( imgURL ) ),
			      SwingConstants.LEFT
	); 
   treeLabel    = new JLabel ( idiom.getWord ( "FK" ),  
		          new ImageIcon ( Toolkit.getDefaultToolkit ().getImage ( imgURL )), 
		          SwingConstants.LEFT
   ); 

   JPanel radioPanel = new JPanel();
   radioPanel.setLayout(new BorderLayout());
   
   radioPanel.add ( primaryLabel, BorderLayout.NORTH  );
   radioPanel.add ( uniqueLabel,  BorderLayout.CENTER );
   radioPanel.add ( treeLabel,    BorderLayout.SOUTH  );       

   JPanel radioBig = new JPanel();
   radioBig.setLayout ( new FlowLayout ( FlowLayout.CENTER ) ); 
   radioBig.add ( radioPanel );

   propertiesLabel = new JLabel ( idiom.getWord ("FIELD") + ": ", JLabel.CENTER ); 
   JPanel titleI = new JPanel ();
   titleI.setLayout ( new BorderLayout () );
   titleI.add ( propertiesLabel );
   
   fieldJText = new JTextField ( 20 );  // 15 Nick 2010-03-24
   fieldJText.setBackground ( Color.white );
   fieldJText.setEditable ( false );
    
   JPanel fieldT = new JPanel ();
   fieldT.add ( fieldJText ) ;
   
   details = new JButton ( idiom.getWord ( "DETAILS" ) 	);
   
   details.setActionCommand ( "Details" );
   details.addActionListener ( this );
   details.setEnabled ( false );
   
   JPanel button = new JPanel ();
   button.add ( details );
   button.setPreferredSize ( new Dimension ( 150, 45 ) );
   
   JPanel indexColumns = new JPanel ();
   indexColumns.setLayout ( new BoxLayout ( indexColumns, BoxLayout.Y_AXIS ) );
   indexColumns.add ( titleI );
   indexColumns.add ( fieldT ); // fieldJText  Nick 2010-03-24
   indexColumns.add ( button );

   JPanel glob = new JPanel ();
   glob.setLayout ( new FlowLayout ( FlowLayout.CENTER ) );
   glob.add ( indexColumns );

   JPanel indexProp = new JPanel (); 
   indexProp.setLayout ( new BoxLayout ( indexProp, BoxLayout.X_AXIS ) );
   indexProp.add ( radioBig );
   indexProp.add ( glob );

   title1 = BorderFactory.createTitledBorder ( etched, idiom.getWord ( "INDEXPR" ));
   currentColor = title1.getTitleColor ();
   indexProp.setBorder ( title1 );

   indexPanel = new JPanel ();
   indexPanel.setLayout ( new BoxLayout ( indexPanel, BoxLayout.X_AXIS ));
   indexPanel.add ( todo );
   indexPanel.add ( indexProp );

   title2 = BorderFactory.createTitledBorder ( etched, idiom.getWord ( "TITINDEX" ) );
   indexPanel.setBorder ( title2 );
   indexPanel.setPreferredSize ( new Dimension ( 100, 125 ));

   add ( indexPanel, BorderLayout.SOUTH );
   activeIndexPanel ( false );  
 }

 /**
  * METODO CreateToolBar()
  * Crea Barra de Iconos
  */
 public void CreateToolBar () {  
	 
 
  URL imgURL = getClass().getResource ( "/icons/16_AddField.png" ); 
  addField = new JButton ( new ImageIcon ( Toolkit.getDefaultToolkit().getImage ( imgURL )));
  addField.setActionCommand ( "ButtonAddField" );
  addField.addActionListener ( this );
  addField.setToolTipText ( idiom.getWord ("ADDF"));
  
  StructureBar.add ( addField );

  imgURL = getClass().getResource ( "/icons/16_Grant.png" );
  editField = new JButton ( new ImageIcon ( Toolkit.getDefaultToolkit().getImage ( imgURL )));
  editField.setActionCommand ( "ItemGrant" );
  editField.addActionListener ( this );
  editField.setToolTipText ( idiom.getWord ( "PERMI" ));
  
  StructureBar.add ( editField );

  imgURL = getClass().getResource ( "/icons/16_Index.png" );
  properties = new JButton(new ImageIcon ( Toolkit.getDefaultToolkit().getImage ( imgURL )));
  properties.setActionCommand ( "ButtonXRD" ); // "ButtonProperties"
  properties.addActionListener ( this );
  properties.setToolTipText ( idiom.getWord ("XMLTCRT") );
  
  StructureBar.add ( properties );
 }

 /**
  * METODO actionPerformed
  * Manejador de Eventos para la barra de botones y el menu desplegable
  */
 public void actionPerformed(java.awt.event.ActionEvent e) {

  if (e.getActionCommand().equals("Details")) {

   String indexName = (String) indexList.getSelectedValue();

   Object o = hashFk.get(indexName);

   if (o != null) {

       ForeignKey fkey = (ForeignKey) o;

       String phrA = idiom.getWord("FKN") + fkey.getForeignKeyName();
       String phrB = idiom.getWord("OPC") +  ": " + fkey.getOption();
       String phrC = idiom.getWord("FTAB") + fkey.getForeignTable();
       String phrD = idiom.getWord("LFI") + fkey.getLocalField(); 
       String phrE = idiom.getWord("RFI") + fkey.getForeignField();

       JOptionPane.showMessageDialog(frameFather,
       phrA + "\n" + phrB + "\n" + phrD + "\n" + phrC + "\n" + phrE,
       idiom.getWord("INFO"),JOptionPane.INFORMATION_MESSAGE);
    }

   return;
  }

  /** 2012-02-17 Nick Disabled
  // Nick 2009-10-01   Point for XRD's dialog :)
  if ( e.getActionCommand().equals ( "ButtonXRD" )) {                  
   
	currTable = current_conn.getSpecStrucTable ( currentTable, "public" ) ; // Nick 2010-05-18, need to synchronize table's properties. 
	Xsd_DisplayControl  Xsd_DC = new Xsd_DisplayControl ( frameFather, current_conn, currTable, LogWin, idiom ); 
    return;
  }
  **/
  // Nick 2009-10-01
  if ( e.getActionCommand ().equals ( "ButtonAddField" ) ) {          
    
	InsertTableField iFi = new InsertTableField ( frameFather, currentTable_schema, currentTable, idiom );
    if ( iFi.wellDone ) {
       
 	      addTextLogMonitor ( idiom.getWord ( "EXEC" ) + idiom.getWord ( "ADDF" ) + "\"" ); // Nick 2010-05-06 cDQU
 
 	      if ( makeInstructions ( iFi.InstructionA  ) ) { // Alter table  add column
        	  
              Object[][] auxData = new Object [ this.data.length + 1 ][ this.columnQty ]; // 4 Nick 2009-07-07
    
              for ( int row = 0;  row < this.data.length; row++ ) {  
                    for ( int col = 0; col < this.columnQty; col++ ) 
                    	              auxData [row] [col] = this.data [row] [col] ; // 4
              }
              auxData [ this.data.length ][0]= iFi.NF;
              auxData [ this.data.length ][1]= iFi.TF;
              //
              if ( iFi.InstructionN.length () > 0 )  // Set/Drop Not null value Nick 2009-10-05

            	  if ( makeInstructions ( iFi.InstructionN ) )
                           auxData [ this.data.length ][2]= iFi.NN; 
            	     else        
            	       	   auxData [ this.data.length ][2]= false;
              //
              if ( iFi.InstructionB.length () > 0 )  // Set/Drop default
            	  
            	  if ( makeInstructions ( iFi.InstructionB ) )   
                            auxData [ this.data.length][3] = iFi.DV; // Default value  constrain;
              //
              if ( iFi.InstructionC.length () > 0 )  // Comment on column
            	     
            	  if ( makeInstructions ( iFi.InstructionC ) )  
                               auxData [ this.data.length] [4] = iFi.CF; // Comment Nick 2009-10-01
        
              this.data = new Object [ auxData.length + 1 ][ this.columnQty ]; 
              this.data = auxData;
              
              remove ( tableSpace2 );
              formatTable ();
          
              /**** 2012-02-17 Nick
              if ( currentTable_is_Xrd ) {

            	  String s_res = "";  
            	  Vector dbNames =  new Vector ();
            	  dbNames.add ( current_conn.getDBname () );
            	  setTableStruct( current_conn.getSpecStrucTable(currentTable, "public")) ;
            	  
            	  Xsd_0 xmlTableP = new Xsd_0 ( frameFather, current_conn, dbNames, LogWin, idiom );
            	  s_res = xmlTableP.do_loadTmp () ;
            	  
              }  // currentTable_is_Xrd
              ****/
         } // makeInstructions ( iFi.InstructionA 
    } // iFi.wellDone

   return;
  } // e.getActionCommand ().equals ( "ButtonAddField" )

  if ( e.getActionCommand ().equals ( "ItemGrant" ) ) 
   {
     String[] tb =  new String [1]; // current_conn.getTablesNames ( true );  // Nick 2012-02-11

     if ( tb.length < 1 ) {
         
    	 JOptionPane.showMessageDialog ( frameFather,
               idiom.getWord ( "NOTOW") + current_conn.getDBname () + "'",
               idiom.getWord ( "INFO" ), JOptionPane.INFORMATION_MESSAGE
         );
     } 
        else {
        	  TablesGrant winUser = new TablesGrant ( frameFather, idiom, current_conn, LogWin, tb );
        } 

    return;
  }
 } 

 /**
  * Nick 2009-10-02 
  *  
  */
  boolean makeInstructions ( String p_instr ) {
  
	boolean lb = true;  
	  
    String result = current_conn.SQL_Instruction ( p_instr );
    addTextLogMonitor ( idiom.getWord ( "EXEC" ) + p_instr + "\"" );  
    String value = "OK";
 
    if ( !result.equals ( "OK" ) ) {
	  
    	   lb = false;       
           value = result.substring ( 0, result.length () - 1 );
           JOptionPane.showMessageDialog ( frameFather, value, idiom.getWord ( "ERROR!" ), 
                                           JOptionPane.ERROR_MESSAGE 
           );
    }
    addTextLogMonitor ( value );
   
    return lb ;
  }
 
 /**
  * METODO activeToolBar
  * Activa o desactiva la barra de iconos
  */
 public void activeToolBar ( boolean value ) {
	 
	 addField.setEnabled   ( value );
	 editField.setEnabled  ( value );
	 properties.setEnabled ( value );
 }

 /**
  * METODO setLabel
  * Titulo de la tabla en la pestaï¿½a
  * Modification: 2009-07-07 Nick 
  *       2009-07-07 Nick. Some information about view was added. 
  *       2009-09-29 Nick. The comment of object was added.
  */
 public void setLabel ( String dbName, String table, String owner, String descr )  {
   
   String mesg = "";
   
   this.currentTable = table;
   
   String obj_name = "";
   if ( this.DBComponentType == 41 ) obj_name = this.idiom.getWord ( "TABLESTRUC" ) ;
   if ( this.DBComponentType == 42 ) obj_name = this.idiom.getWord ( "VEIWSTRUC" ) ;
   
   if ( dbName.length () > 0 ) 

	   mesg = obj_name + "'" + table + "'" + " [" + descr + "] " +
           this.idiom.getWord ( "DBOFTABLE" ) + "'"+ dbName + "' " +
           this.idiom.getWord ( "OWNER" ) + ": '" + owner + "'"
    ; 
   else 
        mesg = idiom.getWord ( "NOSELECT" );
   
   title.setText ( mesg );
 }

 /**
  * METODO setTableStruct
  * Con los datos recibidos construye nuevamente la tabla de estructuras
  *    Nick. 2009-07-08. I used this.columnQty instead integer constaint.
  *    Nick. 2009-10-07. Table currTable was added to class.
  *    Nick. 2012-07-19. Some useless code was removed.    
  */
 public void setTableStruct ( Table currentTable ) {
   // Nuevos datos de la tabla
   // Si, estimados senioras :) Nick	 

   // 2009-10-07
   currTable = currentTable ;
	 
   // 2009-10-06 Nick 
   currentTable_is_Xrd     = currentTable.is_Xrd;        
   currentTable_userSchema = currentTable.userSchema; 	 
	
   if ( currentTable_userSchema ) currentTable_schema = currentTable.schema + "." ;	
   else currentTable_schema = ""; 	
	
   TableHeader headT = currentTable.getTableHeader ();
   int numFields = headT.getNumFields ();
   this.data = new Object [ numFields ][ this.columnQty ]; // 4 Nick

   for ( int k = 0; k < numFields; k++ ) 
    {
      String field_name = ( String ) headT.getNameFields ().elementAt ( k ); // o.toString ();
      TableFieldRecord tmp = ( TableFieldRecord ) headT.getHashtable().get(field_name);

      this.data [k][0] = tmp.getName ();
      this.data [k][1] = tmp.getOptions().getDbType (); // Nick 2012-07-30  
      this.data [k][2] = new Boolean ( tmp.getOptions().isNullField () ); 
      this.data [k][3] = tmp.getOptions().getDefaultValue (); 
      this.data [k][4] = tmp.getComment ();
   } 
   //Destruir tabla anterior
   remove ( tableSpace2 ); 
   //Formatear la tabla
   formatTable ();
 }

 /**
  * METODO setNullTable()
  * Construye una tabla vacia
  *  2009-07-07 Nick 
  */
 public void setNullTable () {
   //Nuevos datos de la tabla
   title.setText ( idiom.getWord ( "DSCNNTD" ) );
   data = new Object [1] [ this.columnQty ]; // 4 Nick
   for ( int col = 0; col < this.columnQty; col++ ) this.data [0] [ col ] = "";  // 4 Nick 
   
   //Destruir tabla anterior
   remove ( tableSpace2 );
   //Formatear la tabla
   formatTable();
 }

 /**
  * METODO activeIndexPanel
  * Habilita o deshabilita el panel de Index
  */
 public void activeIndexPanel ( boolean state ) {

   String blanco[] = {};

   indexList.setListData (blanco);
   indexList.setEnabled  (state);
   indexLabel.setEnabled (state);

   fieldJText.setEnabled      (state);
   propertiesLabel.setEnabled (state);

   resetIndex();

   if ( state ) {
       title2.setTitleColor (currentColor);
       title1.setTitleColor (currentColor);
    } 
   else {
         title2.setTitleColor ( new Color (153,153,153) );
         title1.setTitleColor ( new Color (153,153,153) );
    }
 }

 /**
  *  METODO formatTable()
  *  Da formato a las tablas que se crean
  *  2009-07-07 Nick, 5-th column was added ( comment )
  */
 public void formatTable () {
  //Definir un modelo

  MyTableModel myModel = new MyTableModel ( this.data );
  this.table = new JTable ( myModel );

  //Aï¿½adir scroll y seleccionar tamaï¿½o predefinido de la tabla
  this.tableSpace2 = new JScrollPane ( this.table );
  this.table.setPreferredScrollableViewportSize ( new Dimension ( 410, 70 ));

  //Personalizar anchura de columnas
  TableColumn column = null;
  column = this.table.getColumnModel ().getColumn (0);
  column.setPreferredWidth (100);
  
  column = this.table.getColumnModel ().getColumn (1);
  column.setPreferredWidth (60);
  
  column = this.table.getColumnModel ().getColumn (2);
  column.setPreferredWidth (40);
  
  column = this.table.getColumnModel ().getColumn (3);
  column.setPreferredWidth (90);
  
  column = this.table.getColumnModel ().getColumn (4); // Nick
  column.setPreferredWidth (150);
 
  //Situarla en el centro del panel 
  add ( this.tableSpace2, BorderLayout.CENTER );
 }

 /**
  * CLASE MyTableModel
  * Inicializa y controla la tabla
  *  2009-07-07  Nick
  */ 
 class MyTableModel extends AbstractTableModel {
   
	String[] columnNames = { idiom.getWord ("NAME"), 
		                    idiom.getWord ("TYPE"), 
		                    idiom.getWord ("NOTNULL"), 
		                    idiom.getWord ("DEFAULT"),
		                    idiom.getWord ("COMM")	 	                    
   };
   
   public MyTableModel ( Object [] [] xdata ) {
     data = xdata;
   }

   public void setValues ( Object xinfo [] [] ) {
     data = xinfo; 
   }

  public int getColumnCount () {
     return columnNames.length;
   }

   public int getRowCount () {
     return data.length;
   }

   public String getColumnName ( int col ) {
     return columnNames [ col ];
   }

   public Object getValueAt( int row, int col ) {    
    return data [ row ][ col ];
   }

   /***
    * JTable uses this method to determine the default renderer
    * editor for each cell. 
    */
   public Class getColumnClass ( int c ) {
      return getValueAt ( 0, c ).getClass ();
   }

   /*
    * Mï¿½todo para definir columnas editables
    */
   public boolean isCellEditable(int row, int col) {
      if (col == 0 || col == 3)  
            return true;
      else 
            return false;
   }

   /**
    * Implementado porque los datos de la tabla pueden cambiar
    */
    public void setValueAt ( Object value, int row, int col ) {

     if (DEBUG) {
          String oldName = (String) getValueAt(row,col);

          //ALTER TABLE para cambiar nombre del campo
          if (col == 0 && !oldName.equals(value)) 
           {
            String newN = value.toString();
            if ( newN.indexOf (" ") != -1 )
             { 
               JOptionPane.showMessageDialog(frameFather,
               idiom.getWord ("NOCHAR"),
               idiom.getWord ("ERROR!"),JOptionPane.ERROR_MESSAGE);
               return;
             }

            String result = current_conn.SQL_Instruction ( 
            		"ALTER TABLE \"" + currentTable + "\" RENAME \"" + getValueAt(row,col) + 
            		"\" TO \"" + value + "\""
            );
            addTextLogMonitor ( 
            		idiom.getWord ("EXEC")+"ALTER TABLE \"" + currentTable + " RENAME COLUMN \"" + 
            		getValueAt (row, col) + "\" TO \"" + value + "\";\" "
            );
 
            if ( !result.equals ("OK") ) result = result.substring ( 0, result.length () -1);

            addTextLogMonitor ( idiom.getWord ("RES") + result );
            // 2011-11-13 Nick
            setTableStruct( current_conn.getSpecStrucTable(currentTable, "public"));
          }

          //ALTER TABLE para cambiar valor por defecto
          if (col == 3 && !oldName.equals (value)) 
           {
	    String typex = (String) getValueAt ( row, col - 2 );            
	    String val = (String) value;

            if ( typex.startsWith ( "int" ) || typex.startsWith ( "decimal" ) || typex.startsWith ( "serial" )
                || typex.startsWith("float")) {

                if (!isNum ( value.toString ()) ) {
                    JOptionPane.showMessageDialog ( frameFather, idiom.getWord ("NVE"),
                     idiom.getWord ("ERROR!"), JOptionPane.ERROR_MESSAGE 
                    );

                    return;
                 }
             }

            if (typex.startsWith("bool")) {
                if (!value.equals("true") && !value.equals("false")) {
                    JOptionPane.showMessageDialog ( frameFather, idiom.getWord ("BVE"),
                                idiom.getWord("ERROR!"), JOptionPane.ERROR_MESSAGE
                    );
                    return;
                 }
             }

            if ( ( typex.startsWith ("varchar") || typex.startsWith ("char") || typex.startsWith ("date") 
                 || typex.startsWith ("text") || typex.startsWith ("name") || typex.startsWith ("time")) 
                 && !val.startsWith ("\'"))

	         value = "'" + value + "'";

            String result = current_conn.SQL_Instruction ( 
            		   "ALTER TABLE \"" + currentTable + "\" ALTER COLUMN \"" +
                       getValueAt(row,0) + "\" DROP DEFAULT"
                    );

            addTextLogMonitor ( idiom.getWord ("EXEC") + "ALTER TABLE \"" + currentTable + 
            		            "\" ALTER COLUMN \"" + getValueAt (row, 0) + "\" DROP DEFAULT\" "
            ); 

            if ( !result.equals ("OK") ) result = result.substring ( 0, result.length () -1 );
            
            addTextLogMonitor ( idiom.getWord("RES") + result );

            if (val.length()>0) {

                result = current_conn.SQL_Instruction ( "ALTER TABLE \"" + currentTable + "\" ALTER COLUMN \"" +
                 		                   getValueAt(row,0) + "\" SET DEFAULT " + value
                 		 );
                addTextLogMonitor ( idiom.getWord("EXEC") + "ALTER TABLE \"" + currentTable + 
                		            "\" ALTER COLUMN \"" + getValueAt(row,0) + "\" SET DEFAULT "+ value +"\" "
                );

                if (!result.equals ("OK") )
                    result = result.substring ( 0, result.length() -1 );
              
                addTextLogMonitor ( idiom.getWord ("RES") + result );
             }

            setTableStruct ( current_conn.getSpecStrucTable (currentTable, "public"));
           }
      }
    }                   
 }

 /**
  * METODO setIndexTable
  * Dado el vector de indices vuelve a llenar el area
  * de informaciï¿½n sobre ï¿½ndices de la tabla 
  */
 public void setIndexTable ( Vector Indices, PGConnection conn ) {

   current_conn = conn;

   Vector fk = current_conn.getForeignKeys ( currentTable );

   if ( !fk.isEmpty () ) {

       for ( int j = 0; j < fk.size (); j++ ) {
            Vector dataFK = (Vector) fk.elementAt (j);
            String fkName = (String) dataFK.elementAt (0);
            String itemN = "";

            if ( fkName.equals ("$1") ) itemN = "foreign_key_unnamed_" + j; 
            else
                 itemN = "foreign_key_" + fkName;

            Indices.addElement (itemN );
            hashFk.put ( itemN, new ForeignKey ( fkName, 
            		                             (String) dataFK.elementAt (2), 
            		                             (String)dataFK.elementAt (3),
            		                             (String)dataFK.elementAt (4),
            		                             (String)dataFK.elementAt (5))
            );

        }
    }
   else {
          if ( details.isEnabled () ) details.setEnabled ( false );
    }

   indexList.setListData(Indices);
   if ( Indices.size() >0 ) {

       indexN = Indices;
       numIndex = Indices.size();
       indexList.requestFocus();
    }
   else
       numIndex = 0;
 }

 /**
  * METODO setIndexProp
  * Este mï¿½todo se encarga de llenar las propiedades
  * de un indice determinado
  */
 public void setIndexProp (Boolean radioActive, String fieldsIndex) {

   //Boolean primaryBool = (Boolean) radioActive.elementAt(2);
   boolean primarybool = radioActive.booleanValue(); 

   resetIndex();

   if (primarybool)
       primaryLabel.setEnabled(true);
   else
       uniqueLabel.setEnabled(true);

   fieldJText.setText(" " + fieldsIndex);
   isEmpty = false;
 }  

 public void resetIndex() {

   if (!isEmpty)
       fieldJText.setText("");

   if (uniqueLabel.isEnabled())
       uniqueLabel.setEnabled(false);

   if (primaryLabel.isEnabled())
       primaryLabel.setEnabled(false);

   if (treeLabel.isEnabled())
       treeLabel.setEnabled(false);

  }

 /** Maneja el evento de tecla digitada dese el campo de texto */
  public void keyTyped(KeyEvent e) {
   }

  public void keyPressed(KeyEvent e) 
   {
    int keyCode = e.getKeyCode();

    String keySelected = KeyEvent.getKeyText(keyCode); 
    //cadena que describe la tecla presionada

    if(keySelected.equals("Down"))
      {

       int indexV = indexList.getSelectedIndex();

       if(indexV < numIndex - 1)
          indexV++;
       else
          indexV = numIndex - 1;

       String indexName = (String) indexN.elementAt(indexV);
       settingIndex(indexName);

      }
    else 
      {

       if(keySelected.equals("Up"))
        {
          int indexV = indexList.getSelectedIndex();

          if(indexV > 0 && indexV < numIndex)
             indexV--;
          else
             indexV = 0;

          String indexName = (String) indexN.elementAt(indexV);
          settingIndex(indexName);

        }
       else
            Toolkit.getDefaultToolkit().beep();

      }
   }

   /*
    * METODO keyReleased
    * Handle the key released event from the text field.
    */
    public void keyReleased(KeyEvent e)
     {
     }

 /**
   * METODO focusGained
   * Es un foco para los eventos del teclado
   */
   public void focusGained ( FocusEvent e ) {
	   
      Component tmp = e.getComponent ();
      tmp.addKeyListener ( this );

      if ( numIndex > 0 ) {
        
       JList klist = (JList) tmp;

       if ( klist.getModel().getSize() > 0 ) {
          
    	     klist.setSelectedIndex (0);

             String indexName = (String) klist.getSelectedValue();
             settingIndex ( indexName );
        }
      } // ( numIndex > 0 )
   }

 /**
 * METODO focusLost
 */
   public void focusLost(FocusEvent e) {

      Component tmp = e.getComponent();
      tmp.removeKeyListener(this);

    }

 public void settingIndex ( String indexName ) {

     if ( indexName.startsWith ( "foreign_key_" )) {

         if ( !details.isEnabled() ) details.setEnabled ( true );
         if ( !treeLabel.isEnabled()) treeLabel.setEnabled ( true );

         ForeignKey fkey = (ForeignKey) hashFk.get ( indexName );
         fieldJText.setText (" " + fkey.getLocalField () );
      }
     else {

           if (details.isEnabled()) details.setEnabled(false);

           Vector opc = current_conn.getIndexProp(indexName);
           addTextLogMonitor (idiom.getWord("EXEC") + current_conn.SQL + "\"");

           Vector row = (Vector) opc.elementAt (0);
           Object o = row.elementAt (0);
           String cod = o.toString ();

           Vector fieldsName = current_conn.getIndexFields (cod);
           addTextLogMonitor ( idiom.getWord ("EXEC") + current_conn.SQL + "\"" );

           String s_field = ""; // Nick 2010-03-24
           if ( fieldsName.size() == 1 ) 
                  	   s_field = GetStr.getStringFromVector ( fieldsName, 0, 0 );
           else {
        	       for ( int i = 0; i < fieldsName.size(); i++ )
        	    	   s_field = s_field +
        	    		   GetStr.getStringFromVector ( fieldsName, i, 0 ) + ", " ;
        	       
                   s_field = s_field.substring ( 0, ( s_field.length () -2) );
           }
           setIndexProp ( (Boolean) row.elementAt (2), s_field ); // Nick
      }
   }

 /**
  * Metodo addTextLogMonitor
  * Imprime mensajes en el Monitor de Eventos
  */
 public void addTextLogMonitor(String msg)
 {
  LogWin.append ( msg + "\n");
  int longiT = LogWin.getDocument().getLength();

  if ( longiT > 0 ) LogWin.setCaretPosition ( longiT - 1 );
 }

 public boolean isNum ( String s ) {

    for ( int i = 0; i < s.length(); i++ ) {

         char c = s.charAt(i);
         if ( !Character.isDigit(c) ) return false;
     }

    return true;
  }
 /*****
  *  Interface. Nick 2009-07-07
  */
 public void setDBComponentType ( int p_type ) {
 	this.DBComponentType = p_type ;
  }
} // Fin de la Clase

