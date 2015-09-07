: '@(#)kill_insvnmr.sh 22.1 03/24/08 1991-1994 '
# 
#
# Copyright (C) 2015  Stanford University
# 
# You may distribute under the terms of either the GNU General Public
# License or the Apache License, as specified in the README file.
# 
# For more information, see the README file.
# 
#
#!/bin/sh

pg_pids=`ps -ef | grep "ins_vnmr" | grep -v grep | awk '{ print $2 }'`

pid_teststrg=`echo $pg_pids | tr -d " "`

if [ x$pid_teststrg != "x" ]
then
    for pg_proc in $pg_pids
    do
       kill -9 $pg_proc 2>/dev/null
    done
fi
