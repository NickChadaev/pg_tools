#!/usr/bin/python
# coding=utf-8
# PROJ: DataBase, service functions. 
# FILE: load_s.py
# AUTH: Nick (nick_ch58@list.ru)
# DESC: The simplest parser fot text file
# HIST: 2009-05-25 - created
# NOTS: 2010-01-25 - New feature DUMP SCHEMA ( mode 'F' ) was added   

import string
import sys

class tr_file:
    """
      Transform one text file
    """

    def f_parse_name ( self, p_path ):
        """
          It returns the table name
        """
        ls_name = ''
        ls_name = string.rsplit (p_path, "/")
        ls_name = ls_name [ len(ls_name) - 1 ]
        ls_name = string.split (ls_name, ".")

        len_ls_name = len ( ls_name ) 

        if ( ( len_ls_name == 1 ) | ( len_ls_name == 2 ) ):
            ls_res = ls_name[0]
        if ( len_ls_name >= 3 ):
            ls_res = ls_name[ len_ls_name - 3 ] + "." + ls_name[ len_ls_name - 2 ]   

        return ls_res

    def tr_one ( self, p_mode, p_file_name ):
        """
          Transform one text file
        """
        self.mode = p_mode

        ls_name = ""
        if ( self.mode == 'B' ): 
            ls_name = self.f_parse_name ( p_file_name )

        try:
            bf = open ( p_file_name, "r" )     
        except IOError, e:
            print "... Temp file not opened: '" + p_file_name + "'." 
            sys.exit (1)

        bfl_src = bf.readlines()
        bfl_new = []
        
        for bfle in bfl_src:
            li_0 = string.find( bfle, "client_encoding" )
            li_1 = string.find( bfle, "standard_conforming_strings" )
            li_2 = string.find( bfle, "check_function_bodies" )
            li_3 = string.find( bfle, "client_min_messages" )
            li_4 = string.find( bfle, "escape_string_warning" )
            li_5 = string.find( bfle, "SELECT pg_catalog.setval" )

            if ( li_0 < 0 ) & ( li_1 < 0 ) & ( li_2 < 0 ) & \
               ( li_3 < 0 ) & ( li_4 < 0 ) & ( li_5 < 0 ) :

                if ( self.mode == 'B' ): 
                    bfle = string.replace (bfle, "SET search_path = public, pg_catalog",\
                           "SET search_path = service, pg_catalog") 
                    bfle = string.replace (bfle, ("INSERT INTO " + ls_name), \
                                                 ( "INSERT INTO x_" + ls_name ))
                bfl_new.append ( bfle )

            try:
                nf = open ( p_file_name, "w" )
            except IOError, e:
                print "... Output file not opened: '" + p_file_name + "'." 
                sys.exit (1)

            nf.writelines ( bfl_new )                                  
        #
        bf.close()
        nf.close()

def main ():
    """
       Main entrypoint for the class
       Transform test file
    """
    #          1            2     
    sa = " <Mode: A/B/F> <File_name>"
    if ( len( sys.argv ) - 1 ) < 2:
            print "  Usage: " + str ( sys.argv [0] ) + sa
            sys.exit( 1 )

    tr_f = tr_file ()
    tr_f.tr_one ( string.strip(sys.argv[1]), string.strip(sys.argv[2] )) 

    sys.exit (0)

if __name__ == '__main__':
    main()

