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
 *
 * CLASS ShowResultSet v 0.0
 * This class represents the resultset of a query. The resultset is controlled by buttons
 *  or by using a filter.          
 * History:  2013-06-30: Nick Chadaev - nick_ch58@list.ru, Russia.
 *
 * The God with us.          
 */
package ru.nick_ch.x1.misc.resultset;

import java.awt.BorderLayout;
import java.awt.Color;
import java.awt.Dimension;
import java.awt.FlowLayout;
import java.awt.Toolkit;
import java.awt.event.MouseAdapter;
import java.awt.event.MouseEvent;
import java.awt.event.MouseListener;
import java.net.URL;
import java.util.Vector;

import javax.swing.BorderFactory;
import javax.swing.ImageIcon;
import javax.swing.JButton;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JPanel;
import javax.swing.JRadioButton;
import javax.swing.JScrollPane;
import javax.swing.JTable;
import javax.swing.JTextArea;
import javax.swing.JTextField;
import javax.swing.border.Border;
import javax.swing.border.TitledBorder;
import javax.swing.table.AbstractTableModel;

import ru.nick_ch.x1.db.PGConnection;
import ru.nick_ch.x1.idiom.Language;
import ru.nick_ch.x1.queries.SQLFuncBasic;
import ru.nick_ch.x1.queries.SQLFunctionDataStruc;
import ru.nick_ch.x1.utilities.GetStr;

public class ShowResultSet extends JPanel implements ConstMisc {

	private Language idiom;
	
	// Local variables for paging
	private int currentPage = 1;
	private int nPages      = 0;
	private int indexMin    = 1;
	private int indexMax    = 50;
	private int start       = 0;
	private int limit       = 50;
	private int totalRec    = 0;   // used 2013-07-07
	
	// LOcal variables for visual interface ( paging ).
	private JTable       table;             // used 2013-07-07 
	private JPanel       downComponent;
	private JScrollPane  windowX;
	private JRadioButton toFile, toReport;  // used 2013-07-07
	private JButton      queryB,queryL,queryR,queryF;
    //
	private TitledBorder title1;
	//
	private JTextField infoText;
	 
	private Vector columnGlobal = new Vector ();  
	private Vector dataGlobal   = new Vector ();  
	//
	private Color  currentColor;  // ??? Nick
	
	// For abstract Table Model
	private Object []   columnNames;
	private Object [][] data;

    private String select = cEMP;
    private PGConnection pgConn;

    private JTextArea LogWin; 

    private boolean localRequest = false;
    
	/**
	 * The constructor
	 * @author Nick
	 *
	 */
	  public ShowResultSet ( JFrame frame, Language glossary, JTextArea monitor, PGConnection pg_conn, String p_select, int p_total_rec ){
	  
	    idiom = glossary;
		totalRec = totalRec;  
	    
		LogWin = monitor;
		
		Border etched1 = BorderFactory.createEtchedBorder ();
		title1 = BorderFactory.createTitledBorder ( etched1, idiom.getWord ( "EXPTO" ) );
		currentColor = title1.getTitleColor ();
		
        pgConn = pg_conn;
        select = p_select;

		infoText = new JTextField ( cEMP );
	  }  // End of constructor
	  
	  public void showQueryResult ( Vector rowData,Vector columnNames  ) {

		   columnGlobal = columnNames;
		   dataGlobal   = rowData;

		   int namesSize = columnNames.size();
		   int dataSize  = rowData.size();
		   
		   String[] colNames = new String [ namesSize ];
		   Object[][] rowD   = new Object [ dataSize ] [ namesSize ];
		   String title      = cEMP;

		   if ( columnNames.size () > 0 ) {
		            colNames = GetStr.getStringsFromVector ( columnNames );

		       for ( int i = 0; i < dataSize; i++ ) {

		    	    Vector tempo = (Vector) rowData.elementAt (i);

		            for ( int j = 0; j < namesSize; j++ ) {
		                 Object o = tempo.elementAt (j);
		                 rowD [i][j] = o;
		            }
		        }
		       String regTitle = idiom.getWord("RECS"); 

		       if ( dataSize == 1) regTitle = regTitle.substring ( 0, regTitle.length() -1 );
		       title = idiom.getWord ("RES2") + cSPACE + cLSQBR + totalRec + cSPACE + regTitle + cRSQBR;
		   }
		    else 
		        title = idiom.getWord ( "NORES" );
			 
		   MyTableModel myModel = new MyTableModel ( rowD, colNames );
		   table = new JTable ( myModel );

		   JLabel titleResult = new JLabel ( title, JLabel.CENTER );

		   JPanel upPan = new JPanel();
		   upPan.setLayout ( new BorderLayout() );
		   upPan.add ( titleResult, BorderLayout.CENTER );

		   if ( title.equals(idiom.getWord("NORES") ) || ( totalRec == 0) ) { // Empty data set

		       titleResult.setEnabled ( false );
		       title1.setTitleColor ( new Color ( 153, 153, 153 ));
		       
		       toFile.setSelected  ( false );
		       toReport.setSelected( false );
		       toFile.setEnabled   ( false );
		       toReport.setEnabled ( false );

		       downComponent = new JPanel();
		       downComponent.setLayout(new BorderLayout());
		       downComponent.add(upPan,BorderLayout.NORTH);

		       windowX = new JScrollPane ( table );
		       downComponent.add ( windowX, BorderLayout.CENTER );

		       //  Tempory disabling Nick 2013-07-07
		       //  splitQueries.setBottomComponent(downComponent);
		       //  splitQueries.setDividerLocation(135);

		       updateUI();

		       return;
		    } // Empty data set
		  
		   else {
		         title1.setTitleColor ( currentColor );
		         titleResult.setEnabled ( true );
		         toFile.setEnabled      ( true );
		         toReport.setEnabled    ( true );
		    }

		   updateUI();           

		   JButton buttonEmpty = new JButton (); 
		   buttonEmpty.setPreferredSize ( new Dimension ( 132, 2) ); 
		   upPan.add ( buttonEmpty, BorderLayout.SOUTH ); 

		   downComponent = new JPanel();
		   downComponent.setLayout ( new BorderLayout () );
		   downComponent.add ( upPan, BorderLayout.NORTH );
		   windowX = new JScrollPane ( table ); 
		   downComponent.add ( windowX, BorderLayout.CENTER );

		   if ( totalRec > 50 ) downComponent.add ( setControlPanel(), BorderLayout.SOUTH );

		   // splitQueries.setBottomComponent(downComponent);
		   // splitQueries.setDividerLocation(135);

		  } // End of showQueryResult

	  /** --------------------------------------------
	   * The Internal Class
	   * @author Nick (30.06.2013)
	   */
	  class MyTableModel extends AbstractTableModel {


	   public MyTableModel ( Object[][] xdata, String[] colN ) {

	     data = xdata;
	     columnNames = colN;
	    }
	 	     
	   public String getColumnName ( int col ) {
	     return columnNames [col].toString (); 
	    }

	   public int getRowCount() { // !!!! The Count method isn't nessesary
	     return data.length; 
	    }

	   public int getColumnCount() {
	     return columnNames.length; 
	    }

	   public Object getValueAt ( int row, int col ) {
	     return data [row] [col]; 
	    }

	   public boolean isCellEditable ( int row, int col ) {
	     return false; 
	    }

	   public void setValueAt ( Object value, int row, int col ) {

	     data [row][col] = value;
	     fireTableCellUpdated ( row, col );
	    }

	  } // End of class MyTableModel

	  /** ------------------------------------------------------
	   *  Set control panel. It neew for browsing of result set.
	   * 
	   * @author Nick (30.06.2013)
	   * @return JPanel 
	   */
	  public JPanel setControlPanel () {

	         JPanel controls = new JPanel ();
	         controls.setLayout ( new BorderLayout() );

	         nPages = getPagesNumber ( totalRec );

	         JPanel labelPanel = new JPanel();
	         labelPanel.setLayout( new FlowLayout() );
	         labelPanel.add ( infoText );

	         URL imgURB = getClass().getResource("/icons/backup.png");
	         queryB = new JButton ( new ImageIcon ( Toolkit.getDefaultToolkit().getImage (imgURB)) );
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
	  
	  /** ------------------------------------
	   * Compute number of pages of result set
	   * @authorNick (30.06.2013)
	   * @param rIM 
	   * @return int 
	   */
	  private int getPagesNumber ( int rIM ) {

		    double fl = (( double ) rIM ) / 50;
		    String div = cEMP + fl;

		    int nP = rIM / 50;

		    if ( div.indexOf ( cPOINT ) != -1 ) {
		        String str = div.substring ( div.indexOf ( cPOINT ) + 1, div.length () );
		        if ( !str.equals ( cZEROs ) )
		             nP++;
		     }
		  return nP;
		} // End of getPagesNumber

         /**
           * the addTextLogMonitor
           * Print messages in the Event Monitor window
           */
          private void addTextLogMonitor ( String msg ) {
         
           LogWin.append ( msg + cEOL);	
           int longiT = LogWin.getDocument().getLength();
         
           if (longiT > 0)
               LogWin.setCaretPosition( longiT - 1);
          } // End of addTextLogMonitor	
	  
} // End of class
