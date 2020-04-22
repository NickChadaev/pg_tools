/**
 * /**
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
 *  CLASS InsertTableField @version 1.0   
 *  History:
 *    2009-10-01 Nick Chadaev ( nick_ch58@list.ru )  
 *                The comment of table's field was added.
 *    2012-02-17 Nick Chadaev Rebuild this class          
 */

package ru.nick_ch.x1.structure;

import java.awt.Color;
import java.awt.FlowLayout;
import java.awt.GridLayout;
import java.awt.event.*;

import javax.swing.BorderFactory;
import javax.swing.BoxLayout;
import javax.swing.JButton;
import javax.swing.JComboBox;
import javax.swing.JCheckBox; // Nick 2009-10-05
import javax.swing.JDialog;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JOptionPane;
import javax.swing.JPanel;
import javax.swing.JTextField;
import javax.swing.border.Border;
import javax.swing.border.TitledBorder;

import ru.nick_ch.x1.idiom.Language;
import ru.nick_ch.x1.utilities.ChkType;
//import ru.nick_ch.x1.main.XPg;
import ru.nick_ch.x1.menu.Sql_menu;
import ru.nick_ch.x1.misc.input.GenericQuestionDialog;

public class InsertTableField extends JDialog implements ActionListener, Sql_menu {

// --- Public area
 public boolean wellDone = false;
 
 public String InstructionA = "";  // ADD COLUMN
 public String InstructionB = "";  // ALTER COLUMN SET DEFAULT/DROP DEFAULT
 public String InstructionC = "";  // COMMENT ON COLUMN IS 
 public String InstructionN = "";  // ALTER COLUMN SET NOT NULL/DROP NOT NULL

 public String   NF  = "";       // Name
 public String   TF  = "";       // Type: Name of type and ( Length, Prec ) 
 public boolean  NN  = false;   // Not NULL
 public String   DV  = "";       // Default
 public String   CF  = "";       // Comment Nick 2009-10-01 
// -- Public area
 
 private boolean DVF = false ; // Nick 2012-02-24
 
 private JTextField NameField;
 
 private JComboBox  TypeField;
 private JComboBox  booleanCombo; // Nick 2012-02-22
 
 private int typeIndex ; // Nick 2012-03-06
 private int [] typesT;  // Type's category
 
 private JTextField LengthField;
 private JTextField PrecField;     // Nick   2009-10-05 
 private JCheckBox  NotNullBox, DefValueBox;    // Nick   2009-10-05
 private JTextField DefaultField;
 private JTextField CommentField;  // Nick	 2009-10-01
 
 private JFrame parent;
 
 private String schema; // Schema's name
 private String table;  // Table's name
 
 private Language idiom;

 private JPanel  four, four_1;
 private JButton ListFunc;
 
 public InsertTableField ( JFrame frame, String p_Schema_Name, String TName, Language lang ) {

  super( frame, true );
  
  idiom = lang;
  
  setTitle ( idiom.getWord ( "INSRT" ) + cSPACE + idiom.getWord ( "FIELD" ));
  
  parent = frame;
  schema = p_Schema_Name ;
  table  = TName;
  idiom  = lang;
  
  JPanel global = new JPanel ();
  global.setLayout ( new BoxLayout ( global, BoxLayout.Y_AXIS ) );
  JLabel NameLabel = new JLabel ( idiom.getWord ( "NAME" ), JLabel.CENTER );
  
  NameField = new JTextField (15);
  
  JPanel first = new JPanel();
  first.setLayout ( new GridLayout ( 0, 1 ) );
  first.add ( NameLabel );
  first.add ( NameField );

  JLabel TypeLabel = new JLabel ( idiom.getWord ( "TYPE" ), JLabel.CENTER );
  String[] values = ChkType.getListTypes() ; // Nick 2012-02-14

  TF = values [0]; // Initial setting 2012-02-24 Nick
  
  TypeField = new JComboBox   ( values );
  TypeField.setBackground     ( Color.white );
  TypeField.setActionCommand  ( "COMBO" );
  TypeField.addActionListener ( this );

  typesT = ChkType.getListTTypes();  // Nick 2012-03-06
  typeIndex = typesT [0];           
  
  booleanCombo = new JComboBox  ( ChkType.cBOOLARRAY );
  booleanCombo.setBackground     ( Color.white );
  booleanCombo.setActionCommand  ( "COMBOB" );
  booleanCombo.addActionListener ( this );
  
  JPanel second = new JPanel ();
  second.setLayout ( new GridLayout ( 0, 1 ));
  second.add ( TypeLabel );
  second.add ( TypeField );

  JLabel LongLabel = new JLabel ( idiom.getWord ( "LENGHT" ), JLabel.CENTER );
  LengthField      = new JTextField (5);
  JPanel panelL    = new JPanel ();
  panelL.setLayout ( new GridLayout ( 0, 1 ));
  
  LengthField.setEditable ( false ); // Nick 2012-02-21
  LengthField.setEnabled  ( false );   
  
  panelL.add ( LongLabel );
  panelL.add ( LengthField );  

  JLabel PrecLabel = new JLabel ( idiom.getWord ( "PREC" ), JLabel.CENTER );
  PrecField        = new JTextField (2);
  JPanel panelP    = new JPanel ();
  panelP.setLayout ( new GridLayout ( 0, 1 ));

  PrecField.setEditable ( false ); // Its initial status has to correspond with first element of
  PrecField.setEnabled  ( false ); // type's list 'values'.
  
  panelP.add ( PrecLabel );
  panelP.add ( PrecField );  
  
  JLabel NotNullLabel = new JLabel ( idiom.getWord ( "NOTNULL" ), JLabel.CENTER );
  NotNullBox          = new JCheckBox ();
  NotNullBox.setActionCommand ( "NOTNULL" );
  NotNullBox.addActionListener ( this );
  
  JPanel panelNN = new JPanel ();
  panelNN.setLayout( new GridLayout ( 0, 1 )) ;
  panelNN.add ( NotNullLabel ) ;
  panelNN.add ( NotNullBox ) ;
  
  JLabel DefaultLabel = new JLabel ( idiom.getWord ( "DEFVL" ), JLabel.CENTER );
  DefaultField        = new JTextField (7); // 5, 15
  
  four = new JPanel ();  // Nick 2012-02-22
  four.setLayout ( new GridLayout ( 0, 1 ));
  
  DefValueBox = new JCheckBox ();
  DefValueBox.setActionCommand ( "DEFVAL" );
  DefValueBox.addActionListener ( this );
  DVF = false;
  
  /***/
  ListFunc = new JButton ( "..." );       // This is News 2012-02-24 Nick
  ListFunc.setSize ( 5, 3 );
  ListFunc.setActionCommand ("LISTFUNC");
  ListFunc.addActionListener (this);     //
  /***/
  
  four_1 = new JPanel (); // Nick 2012-02-22
  four_1.setLayout ( new BoxLayout ( four_1, BoxLayout.X_AXIS));
 
  four_1.add (DefValueBox);             // Nick 2012-02-26
  if ( TF.equals(ChkType.cBOOL)) {
	  booleanCombo.setEnabled( false );
	  four_1.add ( booleanCombo);
  }
  else {
     DefaultField.setEditable( false );
     DefaultField.setEnabled ( false );
     four_1.add ( DefaultField );
  }
  // four_1.add ( ListFunc ); 
  
  four.add ( DefaultLabel );
  four.add ( four_1 );
  
  // Nick 2009-10-01 ----------------------------------------------------------
  JLabel CommentLabel = new JLabel ( idiom.getWord ( "COMM" ), JLabel.CENTER );
  CommentField        = new JTextField (25);
  JPanel five         = new JPanel ();
  five.setLayout ( new GridLayout ( 0, 1 ));
  five.add ( CommentLabel );
  five.add ( CommentField );
  
  JPanel OneRow = new JPanel();
  OneRow.setLayout ( new FlowLayout ( FlowLayout.CENTER ) );
  OneRow.add ( first  );
  OneRow.add ( second );
  OneRow.add ( panelL );
  OneRow.add ( panelP ) ;
  OneRow.add ( panelNN ) ;
  OneRow.add ( four   );
  OneRow.add ( five   );

  //----------------------------------------------
  
  Border etched1 = BorderFactory.createEtchedBorder();
  TitledBorder title1 = BorderFactory.createTitledBorder(etched1);
  OneRow.setBorder(title1);

  JButton ok = new JButton ( idiom.getWord ( "OK" ) );
  ok.setActionCommand ("OK");
  ok.addActionListener (this);
  
  JButton cancel = new JButton ( idiom.getWord ( "CANCEL" ) );
  cancel.setActionCommand ("CANCEL");
  cancel.addActionListener (this);

  JPanel botons = new JPanel();
  botons.setLayout ( new FlowLayout ( FlowLayout.CENTER ) );
  botons.add (ok);
  botons.add (cancel);

  global.add (OneRow);
  global.add (botons);

  getContentPane().add ( global );
  pack ();
  setLocationRelativeTo( frame );
  setVisible ( true );
  
 }

 public void actionPerformed ( ActionEvent e ) { // java.awt.event

  if ( e.getActionCommand().equals ( "OK" ) ) {
	
	String lTF = cDP2 ;  
    NF = NameField.getText ();

    if ( NF.length () == 0 ) {
    	
       JOptionPane.showMessageDialog ( InsertTableField.this,
       idiom.getWord ( "FNEMPTY" ), idiom.getWord ( "ERROR!" ), JOptionPane.ERROR_MESSAGE );
       NameField.requestFocus ();
       return ;
     } 
    else 
     {
      if ( NF.indexOf ( cSPACE ) != -1 ) {
    	  
          JOptionPane.showMessageDialog ( InsertTableField.this,
          idiom.getWord ( "NOCHAR" ), idiom.getWord ( "ERROR!" ), JOptionPane.ERROR_MESSAGE );
          NameField.requestFocus ();
          return;  
        } 
       else { // Set type's name, length and precision ( if it need ) Nick 2009-10-05
              NF = NF.toLowerCase() ;
              
              String l_table_name = schema;
              if ( l_table_name.length() == 0 ) l_table_name = cDQU + table + cDQU;
              else
                   l_table_name = schema + cDQU + table + cDQU; //  + cPOINT  ??? Nick 2012-02-21
              String l_column_name = cDQU + NF + cDQU;          // Why the point after schema name ?
              
    	      String longitud = cEMP;
              TF = ( String ) TypeField.getSelectedItem ();
              // lTF += TF;
              if ( LengthField.isEnabled () ) {
        	 
                  longitud = LengthField.getText ().trim();
                  if ( ( longitud.length () > 0 ) && ( ChkType.isNum ( longitud )) )
                        TF = TF + S_L_BR + longitud ;  // TF = TF + "(" + longitud + ")"; Nick 2009-10-05
                    else 
                    	 if ( longitud.length () > 0 )
                           {
                             JOptionPane.showMessageDialog ( InsertTableField.this,
                                idiom.getWord ( "INVLENGHT" ), idiom.getWord ( "ERROR!" ), 
                                JOptionPane.ERROR_MESSAGE 
                             ); 
	                         LengthField.requestFocus();
	                         return;
                           } 
                  if ( PrecField.isEnabled () ) {
                          String prec_str = PrecField.getText().trim() ;
                          if ( ( prec_str.length () > 0 ) && ( ChkType.isNum ( prec_str )) )
                                      TF = TF + cCOMMA + prec_str + S_R_BR;   
                            else 
                            	if ( prec_str.length() > 0 )
                                 {
                                   JOptionPane.showMessageDialog ( InsertTableField.this,
                                      idiom.getWord ( "INVPREC" ), idiom.getWord ( "ERROR!" ), 
                                      JOptionPane.ERROR_MESSAGE 
                                   ); 
                                   PrecField.requestFocus();
                                   return;
                                 } 
                  } // Prec is enabled
                  
                  if ( TF.contains(S_L_BR) && ( !TF.contains(S_R_BR)) ) TF = TF + S_R_BR;
              } // LengthField.isEnabled  - true
              lTF += TF;
              
              if ( DVF ) {
            	  if ( !TF.equals(ChkType.cBOOL) ) DV = DefaultField.getText ().trim(); 
                  if ( DV.length () > 0 ) { // Default value setting
                     if ( ChkType.validValue ( typeIndex, DV ) ) { // TF
                    	 DV = ChkType.setAddChar ( typeIndex, lTF, DV );
                    	 InstructionB = cALT + cTBL + l_table_name + 
                                    cALT + cCOL + l_column_name + cSPACE + cSET + c_DEFAULT + DV ;
                     }
                      else {  JOptionPane.showMessageDialog ( InsertTableField.this,
                                    idiom.getWord ( "INVDEFAULT" ), idiom.getWord ( "ERROR!" ), 
                                    JOptionPane.ERROR_MESSAGE
                               );
                               DefaultField.requestFocus();
                               return;
    	                    }
                  } // ( DV.length () > 0 )
                    else // DV.length () == 0 
                        if ( NN )  
                          { GenericQuestionDialog win = new GenericQuestionDialog ( parent, 
                                	idiom.getWord ("YES"), idiom.getWord ("NO"), idiom.getWord ("ADV"),
                                    idiom.getWord ("ADDDEFAULT") 
                                 );
                            if ( win.getSelecction () ) { DefValueBox.requestFocus();
                                                          return;
                            }
                          } // NN
              } // DVF == true
              else
                  if ( NN && (!(typeIndex == 12)) )  
                  { GenericQuestionDialog win = new GenericQuestionDialog ( parent, 
                        	idiom.getWord ("YES"), idiom.getWord ("NO"), idiom.getWord ("ADV"),
                            idiom.getWord ("ADDDEFAULT") 
                         );
                    if ( win.getSelecction () ) { DVF = true;
                    	                          if ( TF.equals( ChkType.cBOOL) ) booleanCombo.setEnabled (DVF);
                    	                          else {
                    	                                 DefaultField.setEnabled ( DVF);
                    	                                 DefaultField.setEditable (DVF );
                    	                    	  }  
                    	                          DefValueBox.requestFocus ();
                    	                          DefValueBox.setSelected (DVF); 
                    	                          return;
                    }
                  } // NN
        
        InstructionA = cALT + cTBL + l_table_name + cADD + cCOL + l_column_name + cSPACE + TF;
        if ( NN ) 
             InstructionN = cALT + cTBL + l_table_name + cALT + cCOL + l_column_name + 
                cSET + cNOT + cNULL ; 
        
        // Nick 2009-10-01
        CF = CommentField.getText() ;
        InstructionC = cCMT + cCOL + l_table_name + cPOINT + l_column_name + cSPACE + cIS + CF + cSEP; 

        wellDone = true;
        setVisible ( false );
       } // Set type's name, length and precision ( if it need ) Nick 2009-10-05
    } // Length ( NF ) > 0  
  } // command "OK"

  if ( e.getActionCommand ().equals ( "CANCEL" ) ) 
   {
     setVisible ( false );
   }
 
  if ( e.getActionCommand ().equals( "NOTNULL") )  {  // CheckBox
	 NN = NotNullBox.isSelected() ;  
	 if ( typeIndex == 12 ) /// Serial, bigserial 
	    {
	      NN = true;
	      NotNullBox.setSelected (NN) ; 
	    } 
  }
  
  if (e.getActionCommand().equals ("DEFVAL") ) { // Check box again
	  DVF = DefValueBox.isSelected(); 
	  if ( typeIndex == 12 ) { // serial, bigserial 
		     DVF = false;
		     DefValueBox.setSelected (DVF);
	  }
      if ( TF.equals( ChkType.cBOOL) ) booleanCombo.setEnabled (DVF);
      else {
             DefaultField.setEnabled ( DVF);
             DefaultField.setEditable (DVF );
	  }  
  }
  
  if ( e.getActionCommand ().equals ( "COMBO" ) ) {
    JComboBox cb = ( JComboBox )e.getSource ();
    TF = ( String ) cb.getSelectedItem() ;
    typeIndex = typesT [cb.getSelectedIndex()]; // Nick 20120-03-06
    
    four_1.removeAll ();
    four_1.add ( DefValueBox);
    DefValueBox.setSelected (DVF);
    if ( TF.equals(ChkType.cBOOL) ) {
    	       four_1.add ( booleanCombo) ;
               booleanCombo.setEnabled (DVF);
    	}  
        else {
    	        four_1.add ( DefaultField );
                DefaultField.setEnabled (DVF);
                DefaultField.setEditable (DVF );
        }
    if ( typeIndex == 12 ) /// Serial, bigserial 
    {
      DVF = false;
      DefValueBox.setSelected (DVF);
      DefaultField.setEditable( DVF );
      DefaultField.setEnabled ( DVF );
      
      NN = true;
      NotNullBox.setSelected (NN) ; 
    } 
      else { 
    	      DefaultField.setEditable ( DVF );
              DefaultField.setEnabled  ( DVF );
            }
    four_1.updateUI ();

    SetLenPrec ( TF ) ;
   } // combo
  
  if (e.getActionCommand().equals ("COMBOB")) {
	  DV = booleanCombo.getSelectedItem().toString() + cDP2 + ChkType.cBOOL;
  }
 } // actionPerformed

 /***
  *  Check selection of  type's combo box.
  *  2012-02-21 Nick
  */
  private void SetLenPrec ( String p_newSel ) {
	  
   // ----- typeIndex 11 3 2 1
   if ( (typeIndex == 1) || ( (typeIndex == 3) && (! p_newSel.equals(ChkType.cTEXT)) ) ||
		(typeIndex == 11)   
      ) 
    {
       LengthField.setEditable ( true );
       LengthField.setEnabled  ( true );
      
       if ( (typeIndex == 1) || (typeIndex == 2) )	   
                    {
   	   		          PrecField.setEditable ( true );
   	   	              PrecField.setEnabled  ( true );
                    }
    } 
   else
        {
         LengthField.setEditable ( false );
         LengthField.setEnabled  ( false );
         //
         PrecField.setEditable ( false );
         PrecField.setEnabled  ( false );
        }
  } // SetLenPrec
} //Final de la Classe
