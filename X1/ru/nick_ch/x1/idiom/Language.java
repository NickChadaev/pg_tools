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
 *  CLASS Language  @version 1.0   
 *  Choice of languages
 *  History: 2009-04-24  Nick Chadaev - nick_ch58@list.ru  Russia
 *           The Russian Glossary is added.  
 */        

package ru.nick_ch.x1.idiom;

import java.util.Hashtable;

public class Language  {
 Hashtable glossary;
 
 public Language (String word) { 

  if (word.equals("Spanish"))
   {  
      // Carga Glosario en Espaï¿½ol
       SpanishGlossary sp = new SpanishGlossary();
       glossary = sp.getGlossary();
   }
  else 
    if (word.equals("English"))
     {  
        // Carga Glosario en Ingles 
	   EnglishGlossary en = new EnglishGlossary();
	   glossary = en.getGlossary();
     }
    else
        if (word.equals("Russian"))
        {  
          // Carga Glosario en Ruso 
   	      RussianGlossary ru = new RussianGlossary();
   	      glossary = ru.getGlossary();
        }
 }

 public String getWord(String key)
 {
   return (String) glossary.get(key); 
 }

 public char getNemo(String key)
 {   
   char nemo = ((String) glossary.get(key)).charAt(0); 
   return nemo;
 }

} // Fin de la Clase
