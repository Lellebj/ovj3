: '@(#)manview.sh 22.1 03/24/08 1991-1994 '
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
#!/usr/bin/sh

#manview - viewing Vnmr manual from CD

console=""
progname=`/bin/basename $0`
case $progname in
       "Inova") console="inova"
                ;;
       "Unity") console="unity"
                ;;
      "Unity+") console="unity"
                ;;
       "VXR-S") console="unity"
                ;;
      "Gemini") console="g2000"
                ;;
     "Mercury") console="mercury"
                ;;
   "MercuryVX") console="mercvx"
                ;;
   "MERCURYplus") console="mercplus"
                ;;
     "Imaging") console="imaging"
                ;;
    "Infinity") console="infinity"
                ;;
    "Varian_NMR_Spectrometer") console="vnmrs"
		;;
    "400-MR") console="pdf"
		;;
             *) echo "$progname not supported."
                exit
                ;;
esac
#All are now same
# So:
console="pdfs"

cur_dir=`pwd`              #This should be /cdrom/cdrom0 or /cdrom/vnmr_online

ostype=`uname -s`

if [ x$ostype = "xAIX" ]
then
    ACROREAD=$cur_dir/.acrobat_aix/bin/acroread

elif [ x$ostype = "xIRIX" ]
then
    ACROREAD=$cur_dir/.acrobat_irix/bin/acroread

elif [ x$ostype = "xLinux" ]
then
    ACROREAD=/usr/bin/acroread
    if [ ! -x $ACROREAD ]
    then
        rpm -i $cur_dir/.acrobat_lnx/acroread-*i386.rpm
    fi

elif [ x$ostype = "xSunOS" ]
then
    osver=`uname -r`
    if [ $osver -ge 5.0 ]
    then 
        ACROREAD=$cur_dir/.acrobat_sol/bin/acroread
    else
        echo ""
        echo "The Vnmr manual viewer does not support $ostype"
        echo ""
        exit
    fi
else

    echo ""
    echo "The Vnmr manual viewer does not support $ostype"
    echo ""
    exit
fi

$ACROREAD $cur_dir/.online/$console/vn_menu.pdf
