: '@(#)isjpsgup.sh 22.1 03/24/08 1999-2002 '
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
#
#
# isjpsgup script to check if a jpsg is running and communicating to Vnmr

if [ ! -f /vnmr/acqqueue/jinfo1.$USER ] ; then

  echo "Jpsg is not running or communicating to Vnmr"

else

  jpsgPID=` cat /vnmr/acqqueue/jinfo1.$USER | awk '{ print $2 }' `

  jpsgProc=`  ps -ef | grep $jpsgPID | grep -v grep `

  if [   "x$jpsgProc" != "x" ]; then
    echo "Jpsg process is running"
    ps -ef | grep $jpsgPID | grep -v grep | awk '{ print "owner= " $1 "  PID= " $2 "  " $10 }'
  else
    echo "Jpsg is not running or communicating to Vnmr"
  fi

fi

# end
