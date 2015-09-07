: '@(#)mkuservnmrj.sh 22.1 03/24/08 1991-1994 '
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
: /bin/sh

if test $# -lt 2
then
  echo "Usage: $0 vnmrsystem username"
  exit
fi

vnmrsystem=$1
user=$2
export vnmrsystem user

#$vnmrsystem/bin/makeuser $user > /dev/null 2> /dev/null << +++

$vnmrsystem/bin/makeuser $user << +++
y
y
y
y
+++
echo "Automatic configuration of user account '$user' done."
