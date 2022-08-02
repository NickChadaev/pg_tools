#!/usr/bin/env python
# -*- Mode: Python; coding: utf-8; indent-tabs-mode: t; c-basic-offset: 4; tab-width: 4 -*- 

# PROJ: NPO RUBIN, dictionary database
# FILE: r_scan_dir.py
# OWNR: Chadaev Nikolay
# AUTH: Nick (nick_ch58@list.ru)
# DESC: Implementation of RbScanDir class
# HIST: 2012-04-21 - created
# NOTS:

import sys
import os
import string

from os import stat
from os import listdir
from stat import S_ISDIR

class RbScanDir:
    """
    Recursive directory scanner. Builds list of all HEAD-files.
    """

    def __init__( self ):

        self.isOK = True
        self.files = []
        # self.t_codes = []

    def scan ( self, p_dir ):
        """
        s.scan ( p_dir ) -- build list of HEAD-files for the given dir
        """
        try:
            l_files = listdir ( p_dir )
            for file in l_files:
                fullname = os.path.join ( p_dir, file )
                st_values = stat ( fullname )
                if not (S_ISDIR ( st_values [0])):
                    # self.scan ( fullname )
                    l_fext = os.path.splitext ( file )
                    if l_fext [1] == ".XML":
                        self.files.append ( fullname )
                        # self.t_codes.append ( l_fext [0] )
                        
        except OSError, e:
            self.isOK = False
            print "Error scanning XML files:", e

    def dump ( self ):
        """
        s.dump -- dump to console list of scanned files
        """
        print ( "--------------\n")
        print ( " There is list of files ")
        for file in self.files:
            print file
        
      #  print ( "\n--------------\n")
      #  print ( " There is list of tables codes ")
      #  for t_code in self.t_codes:
      #      print t_code
        
def main():
    sd = RbScanDir ()
    sd.scan ( string.strip ( sys.argv[1]))
    sd.dump()

if __name__ == '__main__':
    main()

