#!/usr/bin/python
# coding=utf-8
# PROJ: DataBase, service functions. 
# FILE: s_tr.py
# AUTH: Nick (nick_ch58@list.ru)
# DESC: Encoding and decoding for text file
#       The simplest version.
#
# HIST: 2009-05-06 - Created
# NOTS: 2009-05-15 - u'xab' u'xbb' are translated to u'<' and u'>'
#       2009-05-23 - Class trans_f was added
#       2010-04-09 - utf8  was added, created new methods tr_in, tr_out
#

import string
import codecs
import sys

bDONT_OPEN = "Don't open: "
bCOULDNT_WRITE = "Can't save file: "

class Trans_f:
    """
      Encoding and decoding one text file
    """
    def __init__ ( self, p_bc, p_nc ):
        """
         Constructor:
             bc - base coding ( text file had been written )
             nc - new coding
        """
        self.bc = p_bc
        self.nc = p_nc
    #
    # Nick 2010-04-09
    #
    def tr_in ( self, p_bn, p_nn ):
        """
          Encoding and decoding one text file
          p_bn - base file name
          p_nn - temp file name
        """
        try:
            bf = codecs.open ( p_bn, "r", self.bc )
        except IOError, ex:
            print bDONT_OPEN + p_bn
            return []

        bfl_src = bf.readlines ()
        try:
            nf = codecs.open ( p_nn, "w", self.nc )
        except IOError, ex:
            print bDONT_OPEN + p_nn
            return []

        nf.writelines ( bfl_src )

        bf.close ()
        nf.close ()

        try:
            nf = codecs.open ( p_nn, "r", self.nc )
        except IOError, ex:
            print bDONT_OPEN + p_nn
            return []

        bfl_src = nf.readlines ()
        nf.close ()

        return bfl_src
    #
    # ---------------------------------------
    # Nick 2010-04-13
    #
    def tr_out ( self, p_bn, p_nn, p_text ):
        """
          Encoding and decoding one text file
          p_bn   - base file name
          p_nn   - temp file name
          p_text - text, which would written
        """
        try:
            f_temp = open ( p_nn, 'w' )  # I don't understand
            # f_temp = codecs.open ( p_nn, 'w', self.nc )
            f_temp.write ( p_text )
            f_temp.close ()
        except:
            print bCOULDNT_WRITE + p_nn

        try:
            f_temp = codecs.open ( p_nn, 'r', self.nc )
            f_out = codecs.open ( p_bn, 'w', self.bc )

            ls_l = f_temp.readlines ()
            f_out.writelines ( ls_l )

            f_out.close ()
            f_temp.close ()

        except:
            print bCOULDNT_WRITE + p_bn

        return
    #
    #-------------------------------------------------
    #
    def tr_one ( self, p_bn, p_nn ):
        """
          Encoding and decoding one text file
          p_bn - base file name
          p_nn - new file name
                 it can equal to base name
        """
        bf = codecs.open( p_bn, "r", self.bc )     
        bfl_src = bf.readlines()
        bfl_new = []

        for bfle in bfl_src:
            bfle = string.replace(bfle, u'\xab', u'<') 
            bfle = string.replace(bfle, u'\xbb', u'>')
            bfle = string.replace(bfle, u'\u2013', u'-')
            bfle = string.replace(bfle, u'\u2116', u'#')
            #
            bfl_new.append(bfle)

        try:
           nf = codecs.open( p_nn, "w", self.nc )       
           nf.writelines (bfl_new)                                  

        except UnicodeEncodeError, e:
            print e
        #
        # Need to add some exceptions
        #
        bf.close()
        nf.close()

class Note_f:
    """
        Print messages about use of codecs
    """

    def __init__ (self):
        """
           Constructor
        """

        self.sb1 = "  The <Base_codec> and <New_codec> can be:"
        self.sb2 = "        koi8_r       - Russian" 
        self.sb3 = "        cp1251       - Russian, Byelorussian, Serbian, Bulgarian, Macedonian"
        self.sb4 = "        cp866        - Russian" 
        self.sb5 = "        utf8         - Russian"
        self.sb6 = "        mac_cyrillic - Russian, Byelorussian, Serbian, Bulgarian, Macedonian"

    def print_f (self):
        """
            Print messages about use of codecs
        """
        print self.sb1 
        print self.sb2 
        print self.sb3 
        print self.sb4 
        print self.sb5 
        print self.sb6

def main ():
    """
       Main entrypoint for the class
       Encoding/Decoding the text file
    """
    #           1                  2              3           4       
    sa = " <Source_file_name> <New_file_name> <Base_codec> <New_codec>"
    if ( len( sys.argv ) - 1 ) < 4:
            print "  Usage: " + str ( sys.argv [0] ) + sa
            n_mark = Note_f ()
            n_mark.print_f()
            sys.exit( 1 )

    tr_f = Trans_f ( string.strip(sys.argv[3]), string.strip(sys.argv[4] ))
    tr_f.tr_one ( string.strip(sys.argv[1]), string.strip(sys.argv[2] )) 

    sys.exit (0)

if __name__ == '__main__':
    main()

