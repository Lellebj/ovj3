#!/bin/csh
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
if (!($?NMRBASE)) then
   set ostype=`uname -s`
   if ( x$ostype == "xLinux" ) then
      source /vnmr/nmrpipe/com/vj_nmrInit.linux9.com
   else if ( x$ostype == "xDarwin" ) then
      source /vnmr/nmrpipe/com/vj_nmrInit.mac.com
   else # Interix
      source /vnmr/nmrpipe/com/vj_nmrInit.winxp.com
   endif
   source /vnmr/nmrpipe/dynamo/com/dynInit.com
endif

if ($# == 1) then
   $1
else
   $1 $argv[2-]
endif
