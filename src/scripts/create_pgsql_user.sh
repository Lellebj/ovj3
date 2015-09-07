#!/bin/sh
# '@(#)create_pgsql_user.sh 22.1 03/24/08 Copyright (c) 2000-2003 Agilent Technologies'
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
# called by VnmrAdmin.java
# usage: "create_pgsql_user user_name"
# attention! the VnmrAdmin checks for strings "invalid user" and "DONE"

/usr/bin/id $1 1> /dev/null 2> /dev/null
if [ $? != 0 ]
then 
    echo "invalid user"
    exit
fi
if [ x$vnmrsystem = "x" ]
then
   vnmrsystem="/vnmr"
fi
# Are we using the newer postgres or the old version distributed with vnmrj?
# If createuser exists in $vnmrsystem/pgsql/bin/, use it, 
# else use system version.
file="$vnmrsystem/pgsql/bin/createuser"
if [ -f "$file" ]
then
    # Old one, use appropriate path and args
    $vnmrsystem/pgsql/bin/createuser -d -a -q $1
else
    # New one, use no path and appropriate args
    createuser -d -S -R $1
fi

echo "DONE"

