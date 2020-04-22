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
 *  INTERFACE Sz_visuals @version 1.0   
 *    Constaints for visuals components for all classses of projects.
 *    Questions, Comments and Proposals: nick_ch58@list.ru
 *
 *    Data created: 2010/01/29
 *    History:
 *           
 */  

package ru.nick_ch.x1.main;

import java.awt.Dimension;

public interface Sz_visuals {

    /*************************
     * For XPg's constructor.
     */
	int cTREE_VIEW_MIN_W = 100;
	int cTREE_VIEW_MIN_H = 400 ;

	int cTREE_VIEW_PREF_W = 400;
	int cTREE_VIEW_PREF_H = 600 ;
	
	int cTABBED_PANE_MIN_W = 400 ;
	int cTABBED_PANE_MIN_H = 640 ;
	
	int cSPLIT_VERT_DIV_LOC = 270 ; // 270 
	
    int cSPLIT_PREF_W = 100 ; 
    int cSPLIT_PREF_H = 400 ;
    
    int cSPLIT_HOR_DIV_LOC_MIN = 0 ;
    int cSPLIT_HOR_DIV_LOC_MAX = 650 ; // 720 
    
    int cSPLIT_PANE_MIN_W = 0 ;
    int cSPLIT_PANE_MIN_H = 0 ;

    int cDOWN_PANE_MIN_W = 0 ;
    int cDOWN_PANE_MIN_H = 25 ;
    
    /**********************************************************
     *  Position and size of screen. Debug and practical modes.
     */
    
    int cXPOS_D = 90;
    int cYPOS_D = 40;

	int cWIDTH_D  = 1152; // 1024 
  	int cHEIGTH_D =  864; //  768

    //  --------------------------
    int cXPOS_P = 0;
    int cYPOS_P = 0;

	int cWIDTH_P  = 1200; // 1024 
  	int cHEIGTH_P =  960; //  768
    //  --------------------------
    
    /*****************************************
     *    End of declarations for constructor.   	
     */

  	/**
  	 *  Browsers, its sizes.
  	 */
  	int cDICT_ASU_W = 800 ; // It needs to CreateTable class 2011-10-16 Nick
  	int cDICT_ASU_H = 450 ; // 520 480
  	
  	int cDICT_DOC_TYPE_W = 800 ; 
  	int cDICT_DOC_TYPE_H = 480 ;
  	
  	int cDICT_DOCS_W = 920; 
  	int cDICT_DOCS_H = 780;
  	
	/*****************************************************
	 *  For list of tables, unloading of table's contents 
	 */
  	
	int cSCROLL_PANE_W = 120; // 300 
    int cSCROLL_PANE_H = 300; // 120

    int cUNLOAD_WIN_W = 670 ; 
    int cUNLOAD_WIN_H = 290 ;

   // 2010-02-02 For InsertData Class.
    
    int cINP_FIELD_LEN = 20 ;
    
    int cPREF_SIZE_W = 400 ;
    int cPREF_SIZE_H = 400 ;
   
    // 2010.03.01 Nick
    // Sizes of Export separator Screen
    //
    int cEX_SIZE_SEP_W = 260 ;   
    int cEX_SIZE_SEP_H = 150 ; 

}
