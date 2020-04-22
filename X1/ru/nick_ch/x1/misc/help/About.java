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
 *  CLASS About @version 1.0   
 *  History:
 *           2009/11/12  Nick 
 */                                                                  

package ru.nick_ch.x1.misc.help;

import java.awt.FlowLayout;
import java.awt.Toolkit;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.net.URL;

import javax.swing.BoxLayout;
import javax.swing.ImageIcon;
import javax.swing.JButton;
import javax.swing.JDialog;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JPanel;
import javax.swing.SwingConstants;

import ru.nick_ch.x1.idiom.Language;

public class About extends JDialog {

public About(JFrame aFrame, Language idiom) {

   super ( aFrame, true );
   setTitle ( idiom.getWord ( "TITABOUT" ) );
   
 /**
    URL imgURL = getClass().getResource("/icons/about.png");
    JLabel image = new JLabel(new ImageIcon(Toolkit.getDefaultToolkit().getImage(imgURL)),JLabel.CENTER);
  **/
   
   JButton ok = new JButton ( idiom.getWord ( "CLOSE" ) );
   ok.setHorizontalAlignment ( SwingConstants.CENTER );

   ok.addActionListener( new ActionListener () {
    
	   public void actionPerformed ( ActionEvent e ) {
        setVisible ( false );
       }
     }
   );

   JPanel up = new JPanel ();
   up.setLayout ( new FlowLayout () );
   
   // up.add(image);
   JPanel up1 = new JPanel ();
   up1.setLayout ( new BoxLayout ( up1, BoxLayout.Y_AXIS ) );
   
   JLabel msgString1 = new JLabel ( idiom.getWord ( "PGI" ), JLabel.LEFT ); 
   JLabel msgString2 = new JLabel ( idiom.getWord ( "NUMVER" ) + "0.7r", JLabel.LEFT );
   JLabel msgString3 = new JLabel ( idiom.getWord ( "COMP" ) + "2014-10-23", JLabel.LEFT );
   JLabel msgString4 = new JLabel ( idiom.getWord ( "CLTLIB" ), JLabel.LEFT );  
   JLabel msgString5 = new JLabel ( idiom.getWord ( "PLATF" ),  JLabel.LEFT );  
   JLabel msgString6 = new JLabel ( idiom.getWord ( "AUTORS" ), JLabel.LEFT ); 
   
   up1.add ( msgString1 );
   up1.add ( msgString2 );   
   up1.add ( msgString3 );
   up1.add ( msgString4 );   
   up1.add ( msgString5 );
   up1.add ( msgString6 );   
   
   up.add ( up1 ) ;
   
   JPanel down = new JPanel ();
   down.setLayout ( new FlowLayout ());
   down.add ( ok );

   JPanel global = new JPanel();
   global.setLayout ( new BoxLayout ( global, BoxLayout.Y_AXIS ));
   global.add ( up );
   global.add ( down );
   getContentPane().add ( global );

   pack ();
   setLocationRelativeTo ( aFrame );
   this.setSize ( 450, 180 );  

}

}
