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
 *  CLASS HotQueries @version 1.0  
 *    This class is responsible for managing the list of predefined queries
 *    by the user. This class is instantiated from the class Queries.
 *    May be the Records in the future.
 * 
 *  History:
 *          2013-01-08 The dbName property is added.
 *                     The reason of it is: each database has own queries.
 *                     There are special queries, which may perform for any database.
 *                     They must have dbName property always is equal to "*".                  
 */
package ru.nick_ch.x1.queries;

import ru.nick_ch.x1.idiom.*;
import ru.nick_ch.x1.misc.file.File_consts;
import ru.nick_ch.x1.misc.input.*;
import ru.nick_ch.x1.utilities.*;
import ru.nick_ch.x1.menu.*;

import javax.swing.*;
import java.awt.*;
import java.awt.event.*;
import javax.swing.border.Border;
import javax.swing.border.TitledBorder;
import java.util.Hashtable;
import java.util.Vector;
import java.util.StringTokenizer;
import java.io.*;

public class HotQueries extends JDialog implements ActionListener, File_consts, Sql_menu {

 protected Language   idiom;
 protected JTextField queryName;
 protected JTextArea  queryValue;
 protected Vector     queries = new Vector();
 protected JList      queryList;
 protected JCheckBox  loadCheck;
 protected Hashtable  hashQueries = new Hashtable();

 protected boolean wellDone  = false;
 protected String  sqlString = cEMP;
 protected boolean onFly     = false;
 protected int     numFiles  = 0;
 
 protected String sUHome = cEMP;
 protected JFrame app;
 
 protected final JButton updateQ;
 protected final JButton deleteQ;
 protected final JButton loadQ;

 protected String dbName ; // Nick 2013-01-08
 
 public HotQueries ( JFrame p_parent, Language p_leng, String p_dbName ) {

   super( p_parent, true);
   app    = p_parent;
   idiom  = p_leng;
   dbName = p_dbName;
   
   setTitle(idiom.getWord("HQ"));

   String OS = System.getProperty ( cSYS_OS_NAME ); // Nick 2009-12-09
   sUHome = UHome.getUHome ( OS ) + cQR_CATALOG + System.getProperty ( cSYS_FILE_SEP ); // Nick 2010-03-24
   
   try {
	   	File queriesDir = new File ( sUHome );
	   	File fileList[] = queriesDir.listFiles();
	   	numFiles = fileList.length;
    
	   	for ( int i=0; i < numFiles; i++ )
	   	{
	   		if (!fileList[i].isDirectory()) { 
	   			RandomAccessFile queryFile = new RandomAccessFile ( cEMP + fileList[i], "r" ); 

	   			String name = queryFile.readLine ();
	   			name = name.substring(name.indexOf ( sTOKEN_1 ) + 1, name.length() );

	   			String value = queryFile.readLine();
	   			value = value.substring ( value.indexOf ( sTOKEN_1 ) + 1, value.length() );

	   			StringTokenizer st = new StringTokenizer ( value, sTOKEN_24 ); // JUMP-LINE  Nick  2012-11-18

	   			value = cEMP;
	   			while (st.hasMoreTokens()) value += st.nextToken() + cLF;

	   			String active = queryFile.readLine();
	   			active = active.substring ( active.indexOf ( sTOKEN_1 ) + 1, active.length()); 
	   			Boolean bool = new Boolean(active);
	   			boolean run = bool.booleanValue();

                // 2013-01-08 Nick. For future extentions 
	   			String DBname = queryFile.readLine();
	   			DBname = DBname.substring ( DBname.indexOf ( sTOKEN_1 ) + 1, DBname.length()); 
	   			
	   			if (( DBname.equals( this.dbName )) || ( DBname.equals ( sTOKEN_25 ))) {
		   			queries.addElement ( name ); // Nick 2012-01-27
	   				HQStructure oneQuery = new HQStructure ( cEMP + fileList[i], value, run, DBname );
	   				hashQueries.put ( name,oneQuery );
	   				queryFile.close();
	   			}
	   		}  // end if
	   	} // end for

   } catch(Exception ex) {
        System.out.println(ex);
     }
   queries = ActVector.sorting ( queries );

   JPanel general = new JPanel();

   JPanel global = new JPanel();
   global.setLayout(new BorderLayout());

   Border etched = BorderFactory.createEtchedBorder();
   TitledBorder titleBorder = BorderFactory.createTitledBorder(etched);

   JPanel listPanel = new JPanel(); 
   listPanel.setLayout(new BorderLayout());
   listPanel.setBorder(titleBorder);

   JLabel title = new JLabel(idiom.getWord("QUERYS"),JLabel.CENTER);

   queryValue = new JTextArea();
   queryName = new JTextField(15);
   loadCheck = new JCheckBox(idiom.getWord("RQOL"));

   queryList = new JList(queries);
   queryList.setSelectionMode(ListSelectionModel.SINGLE_SELECTION);

   updateQ = new JButton(idiom.getWord("UPDT"));
   updateQ.setActionCommand("ButtonUpdate");
   updateQ.addActionListener(this);
   updateQ.setEnabled(false);

   deleteQ = new JButton(idiom.getWord("DEL"));
   deleteQ.setActionCommand("ButtonDelete");
   deleteQ.addActionListener(this);
   deleteQ.setEnabled(false);

   loadQ = new JButton(idiom.getWord("LOAD"));
   loadQ.setActionCommand("ButtonLoad");
   loadQ.addActionListener(this);
   loadQ.setEnabled(false);

   MouseListener mouseListener = new MouseAdapter()
   {
    public void mousePressed(MouseEvent e)
     {
         int index = queryList.locationToIndex(e.getPoint());
         if (e.getClickCount() == 1 && index > -1)
          {
            String item = (String) queries.elementAt(index);
            queryName.setText(item); 
            HQStructure tmp = (HQStructure) hashQueries.get(item);
            sqlString = tmp.getValue();
            queryValue.setText(sqlString);

            if ( tmp.isReady () ) loadCheck.setSelected ( true );
            else loadCheck.setSelected ( false );
            
            if ( !deleteQ.isEnabled () ) 
            {
                deleteQ.setEnabled ( true );
                updateQ.setEnabled ( true );
                loadQ.setEnabled   ( true );
            }
          }
     }    	
   }; // End of Mouse listener
   queryList.addMouseListener ( mouseListener );

   JScrollPane leftScroll = new JScrollPane ( queryList );
   leftScroll.setPreferredSize ( new Dimension ( 100, 120 ) ); // Nick 2013-01-08

   listPanel.add(title,BorderLayout.NORTH);
   listPanel.add(leftScroll,BorderLayout.CENTER);
   
   JPanel editPanel = new JPanel();
   editPanel.setLayout(new BoxLayout(editPanel,BoxLayout.Y_AXIS));
   editPanel.setBorder(titleBorder);

   JPanel namePanel = new JPanel(); 
   namePanel.setLayout(new FlowLayout());
   JLabel queryLabel = new JLabel(idiom.getWord("QQN") + sTOKEN_21 );
   namePanel.add ( queryLabel );
   namePanel.add ( queryName );

   JScrollPane textScroll = new JScrollPane(queryValue);
   // textScroll.setPreferredSize(new Dimension(200, 120)); // Nick 2013-01-08

   JPanel queryPanel = new JPanel();
   queryPanel.setLayout(new BorderLayout());
   queryPanel.add(textScroll,BorderLayout.CENTER);

   titleBorder = 
		   BorderFactory.createTitledBorder ( etched, idiom.getWord ("FDDESCR" ));
   queryPanel.setBorder ( titleBorder );

   editPanel.add(namePanel);
   editPanel.add(queryPanel);

   JPanel loadPanel = new JPanel();
   loadPanel.setLayout(new FlowLayout());

   loadPanel.add(loadQ);
   loadPanel.add(loadCheck);

   JButton newQ = new JButton(idiom.getWord("NEWF"));
   newQ.setActionCommand("ButtonNew");
   newQ.addActionListener(this);

   JButton addQ = new JButton(idiom.getWord("ADD"));
   addQ.setActionCommand("ButtonAdd");
   addQ.addActionListener(this);

   JButton close = new JButton(idiom.getWord("CLOSE"));
   close.setActionCommand("ButtonClose");
   close.addActionListener(this);

   JPanel buttonPanel = new JPanel();
   buttonPanel.setLayout(new FlowLayout());
   buttonPanel.add(newQ);
   buttonPanel.add(addQ);
   buttonPanel.add(updateQ);
   buttonPanel.add(deleteQ);
   buttonPanel.add(close);

   titleBorder = BorderFactory.createTitledBorder(etched);
   buttonPanel.setBorder(titleBorder);

   JPanel downPanel = new JPanel();
   downPanel.setLayout(new BoxLayout(downPanel,BoxLayout.Y_AXIS));

   downPanel.add(loadPanel);
   downPanel.add(buttonPanel);

   global.add(listPanel,BorderLayout.WEST);
   global.add(editPanel,BorderLayout.CENTER);
   global.add(downPanel,BorderLayout.SOUTH);

   general.add(global);

   getContentPane().add(general);
   pack();
   setLocationRelativeTo( app );
   setVisible(true);
 } // End of constructor

 public void actionPerformed(java.awt.event.ActionEvent e) {

  if (e.getActionCommand().equals("ButtonClose")) {
     setVisible(false);
     return; 
   }

  if (e.getActionCommand().equals("ButtonNew")) {

	  queryList.clearSelection (); 
	  queryName.setText ( cEMP );
	  queryValue.setText( cEMP );  
	  loadCheck.setSelected ( false);
	  queryName.requestFocus();
	  updateQ.setEnabled(false);
	  deleteQ.setEnabled(false);
	  loadQ.setEnabled(false);

	  return;
   }

  if (e.getActionCommand().equals("ButtonAdd")) {
     String nameQ = queryName.getText();
     String valueQ =  queryValue.getText();

     if (nameQ.length() < 1 || valueQ.length() < 1) {
         JOptionPane.showMessageDialog(HotQueries.this,
         idiom.getWord("EMPTY"),
         idiom.getWord("ERROR!"),JOptionPane.ERROR_MESSAGE);
         return;
      }

     if (!queries.contains(nameQ)) { 

         //if (!valueQ.endsWith ( S_SC ))
         //    valueQ += S_SC;

         addQuery(nameQ,valueQ);
      }
     else 
         JOptionPane.showMessageDialog(HotQueries.this,
         idiom.getWord("EQQN"),
         idiom.getWord("ERROR!"),JOptionPane.ERROR_MESSAGE);

     return;
   }

  if (e.getActionCommand().equals("ButtonUpdate")) {
     String nameQ = queryName.getText();
     String valueQ =  queryValue.getText();

     if (nameQ.length() < 1 || valueQ.length() < 1) {
         JOptionPane.showMessageDialog(HotQueries.this,
         idiom.getWord("EMPTY"),
         idiom.getWord("ERROR!"),JOptionPane.ERROR_MESSAGE);
         return;
      }

     if (queries.contains(nameQ)) {

   valueQ = Queries.clearSpaces(valueQ);

   if (!valueQ.endsWith ( S_SC )) valueQ += S_SC;

         HQStructure old = (HQStructure) hashQueries.remove(nameQ);
         String fileName = old.getFileName();
         HQStructure oneQuery = new HQStructure ( fileName, valueQ, loadCheck.isSelected(), "*" ); // Nick 2013-01-08 Temp. solution
         hashQueries.put(nameQ,oneQuery);

         try {
               File deleter = new File(fileName);
               deleter.delete();

               PrintStream sqlFile = new PrintStream(new FileOutputStream(fileName));
               sqlFile.println ( sTOKEN_26 + sTOKEN_1 + nameQ );
               sqlFile.println ( sTOKEN_27 + sTOKEN_1 + valueQ );
               sqlFile.println ( sTOKEN_28 + sTOKEN_1 + loadCheck.isSelected());
               sqlFile.println ( sTOKEN_29 + sTOKEN_1 + dbName ) ; // OR sTOKEN_25  dbCheck.isSelected()); Nick 2013-02-19
               sqlFile.close();
             }
         catch(Exception ex) {
               System.out.println(ex);
          }

      }
     else {
         addQuery(nameQ,valueQ);
      }

     return;
   }

  if (e.getActionCommand().equals("ButtonDelete")) {

      if (!queryList.isSelectionEmpty()) {

          GenericQuestionDialog delete = new GenericQuestionDialog(app,idiom.getWord("YES"),idiom.getWord("NO"),idiom.getWord("CONFRM"),idiom.getWord("DELIT"));
          boolean sure = delete.getSelecction();

          if (sure) {
              String queryTarget = (String) queryList.getSelectedValue();
              int pos = queryList.getSelectedIndex();

              if (queryTarget != null) {
                  String newItem = cEMP;

                  if (pos < queries.size() - 1)
                      newItem = (String) queries.elementAt(pos + 1);
                  else
                      if (queries.size()>1)
                          newItem = (String) queries.elementAt(pos - 1);

                  queries.remove(queryTarget);
                  queryList.setListData(queries);

                  HQStructure next;

                  if (queries.size() != 0) {
                      queryList.setSelectedValue(newItem,true); 
                      queryName.setText(newItem);
                      next = (HQStructure) hashQueries.get(newItem);
                      queryValue.setText(next.getValue());
                      loadCheck.setSelected(next.isReady());                      
                   }
                  else {
                        queryName.setText (cEMP);
                        queryValue.setText (cEMP);
                        loadCheck.setSelected(false);
                   }

                  next = (HQStructure) hashQueries.get(queryTarget);
                  File deleter = new File(next.getFileName());
                  deleter.delete();
               }
          }
       }
      return;
   }

  if (e.getActionCommand().equals("ButtonLoad")) {
      wellDone = true;

      if (loadCheck.isSelected())
          onFly = true;

      setVisible(false);

      return;
   }

 }

 private void addQuery(String nameQ, String valueQ) {

   valueQ = Queries.clearSpaces(valueQ);

   if (!valueQ.endsWith( S_SC )) valueQ += S_SC;

   queries.addElement(nameQ);
   queries = ActVector.sorting ( queries );

   queryList.setListData(queries);
   queryList.setSelectedValue(nameQ,true);
   queryList.requestFocus();

   updateQ.setEnabled(true);
   deleteQ.setEnabled(true);
   loadQ.setEnabled(true);

   boolean load = loadCheck.isSelected();
  
   try { // Nick 2010-03-24  !!
         String fileName = sUHome;

         while (true) {

           if (numFiles < 10)
               fileName += sZERO2 + numFiles;
           else 
               fileName += sZERO + numFiles;

           File proof = new File(fileName);

           if (proof.exists()) {
               numFiles++;
               fileName = sUHome;
            }
           else
               break;
         }

         HQStructure oneQuery = new HQStructure(fileName,valueQ,load, dbName ); // Nick 2013-02-19 
         hashQueries.put(nameQ,oneQuery);

         StringTokenizer st = new StringTokenizer (valueQ, cLF );

         valueQ = cEMP;

         while (st.hasMoreTokens())
                valueQ += st.nextToken() + sTOKEN_24; // JUMP-LINE  2012-11-18


         PrintStream sqlFile = new PrintStream(new FileOutputStream(fileName));
         sqlFile.println ( sTOKEN_26 + sTOKEN_1 + nameQ );
         sqlFile.println ( sTOKEN_27 + sTOKEN_1 + valueQ );
         sqlFile.println ( sTOKEN_28 + sTOKEN_1 + load);
         sqlFile.println ( sTOKEN_29 + sTOKEN_1 + dbName ) ; // OR sTOKEN_25  dbCheck.isSelected()); Nick 2013-02-19
         sqlFile.close();
       }
      catch(Exception ex) {
            System.out.println(ex);
       }
  }

 public boolean isWellDone() {
   return wellDone;
  }

 public String getSQL() {
   return sqlString;
  }

 public boolean isReady() {
   return onFly;
  }
} // End of class
