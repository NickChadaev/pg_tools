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
 *  CLASS InsertData @version 1.0  
 *    This class is responsible for managing the dialogue through the
 *    Which inserts a record into a table. 
 *  History:
 *    2010/01/10  Nick - nick_ch58@list.ru
 *    2010/02/02  Nick - The dialog form was modified. 
 *    2012/07/29  Nick - Next stage of modification. 
 *    2012/10/28  Nick - Finish of new stage.             
 */
 
package ru.nick_ch.x1.records;

import java.awt.*;
import java.awt.event.*;
import javax.swing.*;

import java.util.Hashtable;
import java.util.Enumeration;
import java.util.Vector;
import javax.swing.border.Border;
import javax.swing.border.TitledBorder;

import ru.nick_ch.x1.idiom.*;
import ru.nick_ch.x1.db.*;
import ru.nick_ch.x1.main.Sz_visuals;
import ru.nick_ch.x1.misc.resultset.TextDataInput;
import ru.nick_ch.x1.structure.InsertTableField;
import ru.nick_ch.x1.utilities.ChkType;

public class InsertData extends JDialog implements ActionListener, Sz_visuals, 
             Records_consts, Sql_db {

 private JTextField area;
 private Hashtable  hashText = new Hashtable();
 private Hashtable  dataText = new Hashtable();

 private String [] fieldName;
 private int       numFields;
 private Table     mytable;
 private String    SQLinsert = cEMPdb;

 private String values    = cEMPdb;
 private String fields    = cEMPdb;
 private String tableName = cEMPdb;

 private boolean  wellDone = false;
 private Language idiom;
 
 private String head1, head2 ; // Nick 2010-02-08
 private JPanel global ; 
 
 public InsertData ( String realTableName, Table table, JFrame frame, Language leng, 
		             String p_head1, String p_head2 ) {

    super ( frame, true );
    
    tableName = realTableName;
    idiom = leng;
    
    global = new JPanel ();
    global.setLayout ( new BoxLayout ( global, BoxLayout.Y_AXIS ) );
    
    setTitle ( idiom.getWord ( "INSFORM" ) );
    mytable = table;  // Structure of table. 2010-02-08  Nick
    
    head1 = p_head1; 
    head2 = p_head2; 
   
}
 /***
  * @author Nick 2010-02-08
  * Show form 
  * @param frame, p_swc
  */

 protected void ShowForm ( JFrame frame, boolean p_swc ) {

		String  s_comm ;    // Nick 2010-02-13
	    String  nfield ;    // Nick 2010-02-02
	    String  typeField ;
	    String  typeFieldWithLen ; // Nick 2012-07-29 Nick
        int     categType = -1;    // Nick 2012-07-30 Nick   
        int     lenDefV   = -1;    // Nick 2012-07-30 Nick
	    
        boolean isNotNull = false;
        
	    JScrollPane scroll;
	    
	    String ls = cEMPdb; // Nick 2010-02-03
	    
	    // Nick 2010-02-02 base_name and base_type were added
	    JPanel base_name = new JPanel ();
		base_name.setLayout ( new GridLayout ( 0, 1 ) );

		JPanel base_type = new JPanel ();
		base_type.setLayout ( new GridLayout ( 0, 1 ) );
		
	    JPanel data = new JPanel();
	    data.setLayout ( new GridLayout ( 0, 1 ) );

	    numFields = mytable.getTableHeader().getNumFields ();
	    Vector fields = mytable.getTableHeader ().getNameFields ();
	    fieldName = new String [ numFields ];

	    for ( int i = 0; i < numFields; i++ ) {

	    	nfield = ( String ) fields.elementAt ( i );
	        area = new JTextField ( cINP_FIELD_LEN ); 

	         typeField = mytable.getTableHeader().getType(nfield );
             typeFieldWithLen = mytable.getTableHeader().getTableFieldRecord (nfield ).getOptions().getDbType();
	         categType = ChkType.getCategType ( typeField );
             isNotNull = mytable.getTableHeader().getTableFieldRecord (nfield ).getOptions().isNullField();
             lenDefV = mytable.getTableHeader().getTableFieldRecord (nfield ).getOptions().getDefaultValue().length();
             
             /** 2012-11-12 Nick
             System.out.println ( "nfield = " + nfield );
             System.out.println ( "TypeDB = " + typeFieldWithLen );
             System.out.println ( "isNotNull = " + isNotNull );
             System.out.println ( "lenDefV = " + lenDefV );
             **/
		     if ( ( i + 1 ) < 10 ) ls = S_SPACES_2 + ( i + 1 ) ; else ls = ( i + 1 ) + cEMPdb;  
	        
		     if ( p_swc )  s_comm = mytable.getTableHeader ().getTableFieldRecord ( nfield ).getComment();
		     else
		    	 s_comm = nfield ;
		     
		     JLabel check  = new JLabel ( ls + S_DELIMITER + s_comm ); // Nick 2010-02-02 nfield
		     
		     if (comCond_0 ( isNotNull, categType, lenDefV )) ls = cSSTAR; 
		     else ls = S_SPACES_2 ;
		     
		     JLabel checkT = new JLabel ( S_DELIMITER + typeFieldWithLen + ls );  // Nick 2010-02-02 S_SPACES_2
	         
	         base_name.add ( check );
	         base_type.add ( checkT ) ; 
	         
	         JComboBox booleanCombo = new JComboBox ( ChkType.cBOOLARRAY );

	         String label = S_LABEL_C + i;
	         fieldName [i] = nfield;

	         if ( typeField.equals ( ChkType.cBOOL ) ) { // Nick 2012-07-30

	        	 hashText.put ( label, booleanCombo );
	             data.add ( booleanCombo );
	          }
	          else {
	                 if ( typeField.equals ( ChkType.cTEXT )) {

	                	 JButton text = new JButton ( idiom.getWord ( "ADDTXT" ) );
	                     text.setActionCommand ( label );
	                     text.addActionListener ( this );

	                     hashText.put ( label, text );
	                     data.add ( text );
	                  }  
	                 else
		                 if ( typeField.equals ( ChkType.cBLOB )) {

		                	 JButton blob = new JButton ( idiom.getWord ( "ADDBLOB" ) );
		                     blob.setActionCommand ( label );
		                     blob.addActionListener ( this );

		                     hashText.put ( label, blob );
		                     data.add ( blob );
		                  }  	                	 
	                      else {
	                            hashText.put ( label, area );
	                            data.add ( area );
	                            if ( categType == 12 ) { 
	                    	         area.setEnabled ( false );
	                    	         area.setEditable ( false );
	                            }
	                  }
	           }
	     }

	     Border etched1 = BorderFactory.createEtchedBorder ();
	     TitledBorder title1 = BorderFactory.createTitledBorder ( etched1 );

	     JPanel center = new JPanel();
	     center.setLayout ( new BorderLayout () );
	     
	     center.add ( base_name, BorderLayout.WEST );        // base WEST
	     center.add ( base_type, BorderLayout.CENTER );    
	     center.add ( data,      BorderLayout.EAST );        // CENTER 

	     JLabel title = new JLabel ( head1, JLabel.CENTER ); // "INSERT INTO " + tableName was replaced p_head1 
	     JPanel first = new JPanel ();

	     first.setLayout ( new FlowLayout ( FlowLayout.CENTER ) );
	     first.add ( title );
	     title1 = BorderFactory.createTitledBorder ( etched1 );
	     first.setBorder ( title1 );

	     title1 = BorderFactory.createTitledBorder ( etched1, head2 ); // "VALUES"  2010-02-02 Nick
	     center.setBorder ( title1 );

	     JButton ok = new JButton ( idiom.getWord ("OK"));
	     ok.setActionCommand ("OK");
	     ok.addActionListener (this);
	     
	     JButton clear = new JButton ( idiom.getWord ("CLR"));
	     clear.setActionCommand ("CLEAR");
	     clear.addActionListener (this);
	     
	     JButton cancel = new JButton ( idiom.getWord ("CANCEL"));
	     cancel.setActionCommand ("CANCEL");
	     cancel.addActionListener (this);

	     JPanel botons = new JPanel();
	     botons.setLayout ( new FlowLayout ( FlowLayout.CENTER ) );
	     
	     botons.add (ok);
	     botons.add (clear);
	     botons.add (cancel);

	     global.add(first);

	     if ( numFields > cNUM_FIELDS_SCRL ) {
	         scroll = new JScrollPane ( center );
	         scroll.setPreferredSize ( new Dimension ( cPREF_SIZE_W, cPREF_SIZE_H ));
	         global.add ( scroll );
	      }
	     else
	         global.add ( center );

	     global.add ( botons );

	     getContentPane().add ( global );
	     pack();
	     setLocationRelativeTo ( frame );
	     setVisible ( true );
	 
 } // End of ShowForm
 
 public boolean wasOk (){
   return wellDone;
  }

 public String getSQLString (){
   return SQLinsert;
  }

 public void actionPerformed ( java.awt.event.ActionEvent e ) {

   if ( e.getActionCommand ().startsWith ( "check" )) makeCheck ( e.getActionCommand() ) ;
   if ( e.getActionCommand ().equals     ( "OK" )   ) makeOK () ;
   if ( e.getActionCommand ().equals     ( "CANCEL")) setVisible ( false );
   if ( e.getActionCommand ().equals     ( "CLEAR" )) makeClear (); 
 
 } // actionPerformed
/**
 *   @author Nick
 *   @version 2012-07-31 
 */
 private boolean comCond_0 ( boolean pNN, int pCateg, int pLenDef ) {

   return ( pNN && ( pCateg != 12 ) && ( pLenDef == 0 ));
	 
 }
 
 private void makeCheck ( String strEvent ) {

     //   String strEvent = e.getActionCommand();
     int num = Integer.parseInt ( strEvent.substring ( strEvent.indexOf ( S_DELIM ) + 1,
  		                          strEvent.length () ) 
     );
     String preStr = ( String ) dataText.get ( strEvent );

     if ( preStr == null ) preStr = cEMPdb; 

     TextDataInput textWindow = new TextDataInput ( 
    		                       InsertData.this, idiom, fieldName[num], preStr 
     );

     if ( textWindow.isWellDone () ) {
         				String text = textWindow.getValue (); 
         				dataText.put ( strEvent, text );
      }
     return;
	 
 } // makeCheck ()
/**
 *  It realises action, what made after OK botton was pressed.
 *  Nick 2010-02-10 
 */
 private void makeOK () {
	  
      values = cEMPdb;
      fields = cEMPdb;

      for ( int i = 0; i < numFields; i++ ) {

           String label = S_LABEL_C + i;
           String data = cEMPdb;
           int typeComponent = -1;
           /** ---------------------------------------------------------------
            *  typeComponent == 0 - textField, data of simple type of DB data
            *  typeComponent == 1 - ComboBox
            *  typeComponent == 2 - Java Class for TEXT type of DB data, 
            *                       but what about The bytea type ? 
            * --------------------------------------------------------------- **/
           boolean isNotNull ; 
           int categType, lenDefV ;
           String type   = cEMPdb;
           String type_l = cEMPdb;
           
           JTextField tmp = new JTextField();

           Object obj = ( Object) hashText.get ( label );            

           if ( obj instanceof JTextField ) {
               tmp = ( JTextField ) obj;
               data = tmp.getText();
               typeComponent = 0; // 0 - textField
            }
           else {
                 if ( obj instanceof JComboBox ) 
                  {   data = getFromJComboBox ( ( JComboBox ) obj ) ;
                     typeComponent = 1; // 1 - ComboBox
                  }
                 else {
                       if ( obj instanceof JButton ) {
                           data = ( String ) dataText.get ( label );
                           typeComponent = 2; // 2 - Java Class for TEXT type of DB data
                                              //         OR         BYTEA type 
                           if ( data == null ) data = cEMPdb;
                       }
                  }
                }
           data = data.trim();
           // The list of fields must contain only fields with data.
           
           TableFieldRecord fieldData = 
           	   mytable.getTableHeader().getTableFieldRecord ( fieldName [i] );

           type = mytable.getTableHeader().getType ( fieldName [i] ); // DB type without length
           categType = ChkType.getCategType ( type );
           
           OptionField options = fieldData.getOptions ();
           type_l = options.getDbType(); // DB type with length Nick 2012-10-28
           
           isNotNull = options.isNullField();
           lenDefV   = options.getDefaultValue().length();

           if ( data.length ()!= 0 ) { // || typeComponent == 2 ) 

               if ( ChkType.validValue ( categType, data ) ) { 
              	 data = ChkType.setAddChar ( categType, (cDP2db + type_l), data );
               }
                else {  
                       JOptionPane.showMessageDialog ( InsertData.this,
                         idiom.getWord ("TNE1") + fieldName[i] + 
                                        idiom.getWord ( ChkType.getKeyOfMess(categType) ),
                         idiom.getWord ("ERROR!"), JOptionPane.ERROR_MESSAGE 
                       );
                       if ( typeComponent == 0 ) tmp.requestFocus();
                       return; // It doesn't work
               }
               values += data;
               fields += cDQUdb + fieldName[i] + cDQUdb;

               values += S_COMMA;
           	   fields += S_COMMA;
           } // data.length != 0
           else { //  data.length ()== 0 
               if ( comCond_0 ( isNotNull, categType, lenDefV )) { // ( options.isNullField () )

                   JOptionPane.showMessageDialog ( InsertData.this,
                        fieldName[i] + idiom.getWord ("FNN"),
                        idiom.getWord ("ERROR!"),JOptionPane.ERROR_MESSAGE 
                   );
                   return;
                }
          }
      } //Fin for
     
      values = values.substring( 0, values.length() - 1 );
      fields = fields.substring( 0, fields.length() - 1 );

      fields = S_L_BR + fields + S_R_BR ;
      SQLinsert = S_INSERT_01 + tableName + S_SPACES_1 + fields + S_INSERT_02 + 
                                S_L_BR + values + S_R_BR + S_INSERT_03 ;

      wellDone = true;
      setVisible ( false ); // false
      
      return ; 
 } // makeOK ()

 private String getFromJComboBox ( JComboBox obj ) { 
   
    JComboBox bool = ( JComboBox ) obj;
    return (String) bool.getSelectedItem ();
  }
  /**
   *  Nick 2010-02-10
   */
private void makeClear () {

	for ( Enumeration t = hashText.elements() ; t.hasMoreElements() ;) {

	            Object obj = ( Object ) t.nextElement ();

	            if ( obj instanceof JTextField ) {
	                JTextField tmp = ( JTextField ) obj;
	                tmp.setText(cEMPdb);
	             }
	            else {
	                   if ( obj instanceof JComboBox ) {
	                       JComboBox tmp = ( JComboBox ) obj; 
	                       tmp.setSelectedIndex (0);
	                    }
	                   else
	                       dataText.clear ();
	             }
	}
	return ;     
 } // Clear
} // Fin de la Clase
