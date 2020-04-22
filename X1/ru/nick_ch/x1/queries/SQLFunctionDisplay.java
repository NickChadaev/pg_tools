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
 *  CLASS SQLFunctionDisplay @version 1.0
 *    This class is responsible for displaying the help concerning a
 *    PostgreSQL own SQL function.
 *    
 *  History:
 *           
 */
 
package ru.nick_ch.x1.queries;

import java.awt.BorderLayout;
import java.awt.Cursor;
import java.awt.FlowLayout;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

import javax.swing.AbstractButton;
import javax.swing.JButton;
import javax.swing.JDialog;
import javax.swing.JEditorPane;
import javax.swing.JFrame;
import javax.swing.JPanel;
import javax.swing.event.HyperlinkEvent;
import javax.swing.event.HyperlinkListener;

import ru.nick_ch.x1.idiom.Language;

public class SQLFunctionDisplay extends JDialog implements ActionListener {

  JButton b1;
  JEditorPane blow;
  String functionName = "";
  boolean isWellDone = false;
  Language idiom;

  public SQLFunctionDisplay(Language lang,JFrame app,String html) {

    super(app, true);
    idiom = lang;
    setTitle(idiom.getWord("FDTILE"));
    JPanel panel = new JPanel();
    panel.setLayout(new BorderLayout());

    blow = createEditorPane(html);
    blow.setEditable(false);
    blow.addHyperlinkListener(
         new HyperlinkListener() {

             public void hyperlinkUpdate(final HyperlinkEvent e) {

                if (e.getEventType() == HyperlinkEvent.EventType.ENTERED) {
                    blow.setCursor(new Cursor(Cursor.HAND_CURSOR));
                 }
                else
                   if (e.getEventType() == HyperlinkEvent.EventType.EXITED) {
                       blow.setCursor(Cursor.getDefaultCursor());
                    }
                   else
                     if (e.getEventType() == HyperlinkEvent.EventType.ACTIVATED) {
                         functionName = e.getDescription();
                         isWellDone = true;
                         setVisible(false);
                      }
              }
          }
    );

    panel.add(blow,BorderLayout.CENTER);

    b1 = new JButton(idiom.getWord("CLOSE"));
    b1.setVerticalTextPosition(AbstractButton.CENTER);
    b1.setHorizontalTextPosition(AbstractButton.CENTER);
    b1.setActionCommand("CLOSE");
    b1.addActionListener(this);

    JPanel Panel2 = new JPanel();
    Panel2.setLayout(new FlowLayout());
    Panel2.add(b1);

    JPanel control = new JPanel();
    control.add(Panel2);
    panel.add(b1,BorderLayout.SOUTH);

    setContentPane(panel);
    pack();
    setLocationRelativeTo(app);
    show();
    
   }


  public JEditorPane createEditorPane(String FileName) {

    JEditorPane editorPane = new JEditorPane("text/html",FileName);
    editorPane.setEditable(false);

    return editorPane;
   }

  public void actionPerformed(ActionEvent e) {

    if (e.getActionCommand().equals("CLOSE")) {
        setVisible(false);
        return;
     }
  }

  public boolean isUsed() {
     return isWellDone;
   }

  public String getFuncName() {
     return functionName;
   }

}
