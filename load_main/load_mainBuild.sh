#!/bin/bash
# --------------------------------------------------------
# 2022-07-22 The package build.  Nick  
# file: load_mainBuild.sh
# --------------------------------------------------------
if [ $# -ne 7 ]
  then
     echo '  ' Version 0.0.1 Build 2022-10-14
     echo '  ' Usage: load_mainBuild.sh \<Host_IP\> \<Port\> \<DB_name\> \<User_name\> \<Batch_file_name\> \<Path\> \<Package_Name\>
     exit 1   
fi
#
echo START. The package build.

ERR=$7.err
SQL=$7.sql
LOG=$7.log

load_mainGar.py $1 $2 $3 $4 $5 $6 ''

if [ $? -ne 0 ] 
  then
    echo ERROR. The package build.
    exit 1
fi

if [ -f $ERR ]
  then
        mv $ERR $ERR.bak 
fi

if [ -f $SQL ]
  then
        mv $SQL $SQL.bak 
fi

if [ -f $LOG ]
  then
        mv $LOG $LOG.bak 
fi

mv process.err $ERR 
mv process.sql $SQL
mv process.log $LOG
rm process.out

echo DONE. The package build.
echo

exit 0
