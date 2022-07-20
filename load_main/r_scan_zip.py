#!/usr/bin/env python
# -*- Mode: Python; coding: utf-8; indent-tabs-mode: t; c-basic-offset: 4; tab-width: 4 -*- 
# PROJ: DataBase, service function.
# FILE: r_scan_zip.py
# OWNR: Chadaev Nikolay
# AUTH: Nick (nick-ch58@yandex.ru)
# DESC: Implementation of zipfile 
# HIST: 2022-06-08 - created
# NOTS:

import sys
import os
import string
import zipfile

from os import stat
from os import listdir
from stat import S_ISDIR

VERSION_STR  = "  Version 0.0.0 Build 2022-06-08"

class RbScanZip:
    """
       ZIP Scanner/Exptractor.
    """

    def __init__( self ):

        self.isOK = True
        self.files = []

    def scan ( self, p_zip ):
        """
        s.scan ( p_dir ) -- build list of HEAD-files for the given zip
        """
        try:
           self.z = zipfile.ZipFile(p_zip, 'r')
                        
        except OSError, e:
            self.isOK = False
            print "Error scanning ZIP files:", e

    def z_extract ( self ):
        """
        s.z_extract -- z_extract to console list of scanned files
        """
        self.z.extractall()
        
def main():
    #                  1               
    sa = " <ZIP_file_name>"
    if not (( len( sys.argv ) - 1 ) == 1):
        print VERSION_STR 
        print "  Usage: " + str ( sys.argv [0] ) + sa
        sys.exit( 1 )
    
    sd = RbScanZip ()
    sd.scan ( string.strip ( sys.argv[1]))
    sd.z_extract()

if __name__ == '__main__':
    main()

