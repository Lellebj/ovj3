: '  @(#)Maptape.sh 22.1 03/24/08  Copr 1988 Agilent Technologies'   
#:'@(#)Maptape.sh 22.1 03/24/08 1991-1996 '
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
#   Maptape  -  makes a tape containing the Sun mapping software
#
#   S. Farmer   10-7-92
#
: /csh
rm -rf map
mkdir map
chmod 755 map
cd map
filenames="kermit setmapping acquire.scr getdata.scr"
for file in $filenames
do
   Sget map $file.sh
   make $file
   rm -f $file.sh
done

Sget map test

mkdir maclib
chmod 755 maclib
cd maclib
filenames="runmap processmap fixdg calcpower"
for file in $filenames 
do 
   Sget map $file
done

cd ..
mkdir psglib
chmod 755 psglib
cd psglib
filenames="rri.c hscntrl.c hscalib.c"
for file in $filenames 
do 
   Sget map $file 
done

cd ..
mkdir shimcfg
chmod 755 shimcfg
cd shimcfg
filenames="shim.oxf.20 shim.oxf.23 shim.rri.39 shim.rri.info"
for file in $filenames 
do 
   Sget map $file 
done

cd ..
mkdir manual
chmod 755 manual
cd manual
filenames="kermit.doc shim.doc"
for file in $filenames  
do  
   Sget map $file  
done

cd ..
filenames="kermit3.89 kermit4.89 mag5463 mag6463"
for file in $filenames
do
   cp -r /vcommon/RRImaps/$file .
done

cd ..
tar cvf /dev/rst8 ./map
rm -rf map
