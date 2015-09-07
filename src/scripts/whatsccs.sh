#! /bin/csh -f
#
# '@(#)whatsccs.sh 22.1 03/24/08 1999-2002 '
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
#  this script is passed the name of the SCCS script command being used
#  if then determine which sccs should be used (sccs, jsccs, dsccs
#  it also determine the location of the user, for FC the sccs return
#  is the appropriate auto_mounted sccs directory from enterprise rather
#  than the local mirrored copy of sccs
#
#   Greg Brissey 4/18/02
#
if ( $#argv < 1 ) then
  echo error
 exit 1
endif

#
# if the remote env sccs parameters not defined then default them
#
set pavars = $?sccsdir_pa
#echo $pavars
if ($pavars == 0) then
  set sccsdir_pa = /pa/vsccs_pa/sccs
endif
set pavars = $?sccsjdir_pa
#echo $pavars
if ($pavars == 0) then
  set sccsjdir_pa = /pa/vsccs_pa/jsccs
endif
set pavars = $?sccsddir_pa
#echo $pavars
if ($pavars == 0) then
  set sccsddir_pa = /pa/vsccs_pa/dsccs
endif

#
# if the local env sccs parameters not defined then default them
#
set pavars = $?sccsdir
#echo $pavars
if ($pavars == 0) then
  set sccsdir = /vsccs/sccs
endif
set pavars = $?sccsjdir
#echo $pavars
if ($pavars == 0) then
  set sccsjdir = /vsccs/jsccs
endif
set pavars = $?sccsddir
#echo $pavars
if ($pavars == 0) then
  set sccsddir = /vsccs/dsccs
endif

#
# are we in the delta quadrant (FC) or the alpha quadrant (PA)
#
# for the delta quadrant we mount the appropriate sccs from enterprise
# for editing,  deltaing, entering rather than the mirrored sccs
#

# check the domainname, PaloAlto is ncc1701.nmr.varinainc.com and
# Fort Collins is deltaquadrant.nmr.varianinc.com
#
set fcd=`domainname | grep deltaquadrant`
if ( $fcd != "" ) then
   set fc = "yes"
else
   set fc = "no"
endif
#echo $fc
#
# get first letter of command, J - Jenter,Jedit, Jdelta, Junedit, etc..
#	S - Sdelta, Senter, Sedit, etc... D - Denter, Dedit, Ddelta, ...
#
set flcmd = `echo $1 | awk  '{ print  substr( $0, 1, 1) } '`
set cmd=$1
# echo $flcmd
switch ($flcmd)
{
  case S:
		if ($fc == "no") then
		  set wsccsdir = $sccsdir
    		else
		  set wsccsdir = $sccsdir_pa
  		endif
   		breaksw

  case J:
		if ($fc == "no") then
		  set wsccsdir = $sccsjdir
    		else
		  set wsccsdir = $sccsjdir_pa
  		endif
   		breaksw

  case D:
		if ($fc == "no") then
		  set wsccsdir = $sccsddir
    		else
		  set wsccsdir = $sccsddir_pa
  		endif
   		breaksw
  default:
		echo " "
		echo "Unknown cmd: $cmd"
		echo " "
		exit 10
                breaksw
  endsw

#
# echo the sccs directory the script should use
#
echo $wsccsdir

