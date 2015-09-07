: '@(#)robocmd_768AS.sh 22.1 03/24/08 2003-2004 '
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

PATH=${PATH}:/usr/ucb
export PATH

LD_LIBRARY_PATH=/vnmr/java:$vnmruser/psg:/vnmr/lib
export LD_LIBRARY_PATH

$vnmrsystem/jre/bin/java -mx128m -classpath $vnmrsystem/java/RoboCmd768AS.jar -Dsysdir=$vnmrsystem -Duserdir=$vnmruser RoboCmd >>/dev/null &
