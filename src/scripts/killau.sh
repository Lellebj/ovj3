: '@(#)killau.sh 22.1 03/24/08 1999-2002 '
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

str=`ps -ef | grep auditreduce | nawk '{printf(" %s %s ", $2, $3) }'`
echo kill -9 $str
kill -9 $str
