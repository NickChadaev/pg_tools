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
 *  CLASS Inherit @version 1.0  
 *     This class is responsible for selecting the tables
 *     which will use to inherit attributes.
 *  History:
 *        2009-07-20  Chadaev Nick - nick_ch58@list.ru   
 *        2012-07-26  CurrentSCH was added.                
 */

package ru.nick_ch.x1.menu;

import java.awt.BorderLayout;
import java.awt.Dimension;
import java.awt.FlowLayout;
import java.awt.Toolkit;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.net.URL;
import java.util.Vector;

import javax.swing.Box;
import javax.swing.BoxLayout;
import javax.swing.ImageIcon;
import javax.swing.JButton;
import javax.swing.JDialog;
import javax.swing.JLabel;
import javax.swing.JList;
import javax.swing.JPanel;
import javax.swing.JScrollPane;

import ru.nick_ch.x1.idiom.Language;
import ru.nick_ch.x1.main.Sz_visuals;  /* 2011-10-15 Nick */

public class Inherit extends JDialog implements ActionListener, Sz_visuals, Sql_menu {

    private JList    usrList;
    private JList    groupList;
    private Vector   tables;
    private boolean  semaforo = false;
    private Language idiom;
    private int      num = 0;
    private String   TableList = ""; 
    private String   currentSCH = "";
    private boolean  Done = false;

    public Inherit ( JDialog jframe, Language language, String pSCH, String as[], Vector ht ) {
    /* pSCH is current Schema name */
    	
        super ( jframe, true );
        idiom = language;
        setTitle ( idiom.getWord ( "INHE" ));
        num = as.length;
        tables = ht;

        currentSCH = pSCH;
        
        JPanel jpanel = new JPanel ();
        JLabel jlabel = new JLabel ( idiom.getWord ("INFT"), JLabel.CENTER );
        jpanel.setLayout ( new BorderLayout () );
        jpanel.add ( jlabel, "Center" );
        usrList = new JList ( tables );
        
        // 2011-10-16 Nick
        JScrollPane jscrollpane = new JScrollPane ( usrList );
        jscrollpane.setPreferredSize ( new Dimension ( 190, 300 )); // cUNLOAD_WIN_W 100, 120

        groupList = new JList (as);
        JScrollPane jscrollpane1 = new JScrollPane ( groupList );
        jscrollpane1.setPreferredSize ( new Dimension ( cSCROLL_PANE_W + 70, cSCROLL_PANE_H ) ); // 190, 300
        
        URL imgURL = getClass().getResource ( "/icons/16_Right.png" );
        JButton jbutton = new JButton ( new ImageIcon ( Toolkit.getDefaultToolkit().getImage(imgURL)) );
        jbutton.setVerticalTextPosition (0);
        jbutton.setActionCommand ("RIGHT");
        jbutton.addActionListener (this); 

        imgURL = getClass().getResource ( "/icons/16_Left.png" );
        JButton jbutton1 = new JButton ( new ImageIcon(Toolkit.getDefaultToolkit().getImage(imgURL)) );
        jbutton1.setVerticalTextPosition (0);
        jbutton1.setActionCommand ("LEFT");
        jbutton1.addActionListener (this);

        JPanel jpanel2 = new JPanel ();
        jpanel2.setLayout (new BoxLayout ( jpanel2, 1) );
        jpanel2.add(Box.createVerticalGlue ());
        jpanel2.add (jbutton);
        jpanel2.add (jbutton1);
        jpanel2.add (Box.createVerticalGlue());

        JButton j01 = new JButton (idiom.getWord ( "SELALL" ));
        j01.setActionCommand ("SELALL");
        j01.addActionListener (this);
        j01.setMnemonic (idiom.getNemo ("SELALL"));
        j01.setAlignmentX (0.5F);

        JButton j02 = new JButton (idiom.getWord ("CLRSEL"));
        j02.setActionCommand ("CLEAN");
        j02.addActionListener (this);
        j02.setMnemonic ( idiom.getNemo ("CLRSEL"));
        j02.setAlignmentX (0.5F);

        JPanel jpanel0 = new JPanel();
        jpanel0.setLayout (new FlowLayout() );
        jpanel0.add (j01);
        jpanel0.add (j02);

        JButton jbutton2 = new JButton (idiom.getWord ("OK"));
        jbutton2.setActionCommand ("OK");
        jbutton2.addActionListener (this);
        jbutton2.setMnemonic (idiom.getNemo ("OK"));
        jbutton2.setAlignmentX (0.5F);

        JButton jbutton3 = new JButton (idiom.getWord ("CANCEL") );
        jbutton3.setActionCommand ("CANCEL");
        jbutton3.addActionListener (this);
        jbutton3.setMnemonic ( idiom.getNemo ("CANCEL") );
        jbutton3.setAlignmentX (0.5F);

        JPanel jpanel3 = new JPanel();
        jpanel3.setLayout ( new FlowLayout ());
        jpanel3.add (jbutton2);
        jpanel3.add (jbutton3);

        JPanel jpanel4 = new JPanel();
        jpanel4.setLayout (new BoxLayout (jpanel4,BoxLayout.X_AXIS));
        jpanel4.add (jscrollpane1);
        jpanel4.add (jpanel2);
        jpanel4.add (jscrollpane);

        JPanel jpanel5 = new JPanel();
        jpanel5.setLayout (new BoxLayout (jpanel5, 1) );
        jpanel5.add (jpanel);
        jpanel5.add (Box.createRigidArea ( new Dimension ( 0, 10)));
        jpanel5.add (jpanel4);
        jpanel5.add (jpanel0);
        jpanel5.add (jpanel3);

        JPanel jpanel6 = new JPanel();
        jpanel6.add (jpanel5);
        getContentPane().add (jpanel6);

        pack ();
        setLocationRelativeTo (jframe);
        setVisible (true);
    }

    public void actionPerformed ( ActionEvent actionevent ) {

        if ( actionevent.getActionCommand().equals ("SELALL")) {

            if ( !semaforo ) {

                int[] indices = new int [num];

                for ( int k = 0; k < num; k++ ) indices [k] = k;
                		groupList.setSelectedIndices ( indices );
                		semaforo = true;
              }
            else {
                  	semaforo = false;
                  	groupList.clearSelection ();
              }
         }

        if (	actionevent.getActionCommand().equals ("CLEAN")) {

            if ( tables.size () > 0 ) {
                	tables = new Vector ();
                	usrList.setListData ( tables );
            }
            return;
         }

        if (actionevent.getActionCommand().equals("RIGHT")) {

            if ( !groupList.isSelectionEmpty () ) {
                Object[] fields = groupList.getSelectedValues ();

                for ( int i = 0; i < fields.length; i++ ) {
                	if ( !tables.contains ( fields[i] ) ) tables.addElement ( fields[i] );
                }
                usrList.setListData ( tables );
             }
            return;
         }

        if ( actionevent.getActionCommand ().equals ("LEFT")) {

            String s1 = ( String ) usrList.getSelectedValue ();
            if ( tables.removeElement (s1) ) usrList.setListData ( tables );
            return;
         }

        if ( actionevent.getActionCommand ().equals ("OK")) {

            if ( tables.size() > 0 ) {

                for ( int i = 0; i < tables.size(); i++ ) {
                     String db = (String) tables.elementAt (i);
                     if ( currentSCH != cPUBLIC ) 
                    	 db = currentSCH + cPOINT + cDQU + db + cDQU;
                     else 
                    	 db = cDQU + db + cDQU;

                     TableList += db; 

                     if ( i < tables.size() - 1 ) TableList += ( cCOMMA + cSPACE );
             }

             Done = true;
            } // tables.size() > 0 

            setVisible ( false );
            return;
         }

        if ( actionevent.getActionCommand ().equals ("CANCEL") ) setVisible ( false );
    }

   public Vector getVector () {
     return tables;
   }

   public boolean isWellDone () {
     return Done;
   }

   public String getTableList () {
     return TableList;
   }

} // End of Class
