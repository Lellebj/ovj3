: '@(#)mancdout.sh 21.2 03/24/08 1991-1994 '
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

#scripts to make a Vnmr manual CD ROM.


ostype=`uname -s`
#---------------------------------------------------------------------------
nnl_echo() {
    if [ x$ostype = "x" ]
    then
        echo "error in echo-no-new-line: ostype not defined"
        exit 1
    fi

    if [ x$ostype = "xSOLARIS" ]
    then
        if [ $# -lt 1 ]
        then
            echo
        else
            echo "$*\c"
        fi
    else
        if [ $# -lt 1 ]
        then
            echo
        else
            echo $*
            #echo -n $*
        fi
    fi
}

#---------------------------------------------------------------------------
setperms()
{
   if [ $# -lt 4 ]
   then
     echo 'Usage - setperms "directory name" "dir permissions" "file permissions" "executable permissions"'
     echo ' E.g. "setperms /sw2/cdimage/code/tmp/wavelib 775 655 755" or "setperms /common/wavelib g+rx g+r g+x" '
     exit 0
   fi
   dirperm=$2
   fileperm=$3
   execperm=$4
 
   if [ $# -lt 5 ]
   then
     echo ""
     indent=0
   else
     indent=$5
   fi
 
   pars=`(cd $1; ls)`
   for setpermfile in $pars
   do
#  indent to proper place
      spaces=$indent
      pp=""
      while [ $spaces -gt 0 ]
      do 
        pp='.'$pp
        spaces=`expr $spaces - 1`
      done
 
# test for director, file, executable file
     if [ -d $1/$setpermfile ]
     then
       echo "${pp}chmod $dirperm $setpermfile/"
       chmod $dirperm $1/$setpermfile
       indent=`expr $indent + 4`
       setperms $1/$setpermfile $dirperm $fileperm $execperm $indent
       indent=`expr $indent - 4`
     elif [ -f $1/$setpermfile ]
     then
       if [ -x $1/$setpermfile ]
       then
         echo "${pp}chmod $execperm $setpermfile*"
         chmod $execperm $1/$setpermfile
       else
         echo "${pp}chmod $fileperm $setpermfile"
         chmod $fileperm $1/$setpermfile
       fi
     else
      echo file:  $1/$setpermfile not modified
     fi
   done
}

getOS() {
 
   if [ x$ostype = "xAIX" ]
   then
       this_acrobat="acrobat_aix"
   else
      if [ x$ostype = "xIRIX" ]
      then
          this_acrobat="acrobat_irix"
      else
          if [ x$ostype = "xSunOS" ]
          then
              osver=`uname -r`
              if [ $osver -ge 5.0 ]
              then
                  this_acrobat="acrobat_sol"
              else
                  echo "\nThe Vnmr manual viewer does not support $ostype\n"
                  exit
              fi
          else
              echo "\nThe Vnmr manual viewer does not support $ostype\n"
              exit
          fi
      fi
   fi
}

#---------------------------------------------------------------------------
#                MAIN  Main  main                                
#---------------------------------------------------------------------------
VCOMMON_DIR=/vcommon
VNMRJHELP=$VCOMMON_DIR/VnmrJHelp
#this_acrobat=""
#getOS

acro_list="acrobat_lnx"

SOL_ACRO_SCR_DIR=$VCOMMON_DIR/acrobat_sol
AIX_ACRO_SCR_DIR=$VCOMMON_DIR/acrobat_aix
IRIX_ACRO_SCR_DIR=$VCOMMON_DIR/acrobat_irix
ONLINE_SCR_DIR=$VCOMMON_DIR/online

MAN_DEFAULT_DIR=/vnmrcd/cdman

#MAN_FINAL_DIR=`date '+/usr25/chin/.cdrom%m.%d'`
MAN_FINAL_DIR=`date '+/rdvnmr/.cdromMan%m.%d'`
#MAN_LOG_FILE=/usr25/chin/jloadnmr.edit/mancdoutlog
MAN_LOG_FILE="/vnmrcd/cdoutlog"

nnl_echo "\n Enter manual destination directory [$MAN_DEFAULT_DIR]:"
read answer
if [ x$answer = "x" ]
then
   dest_dir=$MAN_DEFAULT_DIR
else
   dest_dir=$answer
fi

if  [ ! -d $dest_dir ]
then
   nnl_echo "\"$dest_dir\" does not exist, create? [y]:"
   read answer
   if [ x$answer = "x" ]
   then
      answer="y"
   fi 
   if [ x$answer != "xy" ]
   then
      exit
   else 
      #rm -rf $dest_dir/*
      echo
   fi 
else
   mkdir -p $dest_dir
fi
echo ""

MAN_DEST_DIR=$dest_dir/

ONLINE_DEST_DIR=$MAN_DEST_DIR/online


if [ -d  $MAN_DEST_DIR ]
then
    echo " $MAN_DEST_DIR directory exists."
    echo "\n Removing old  Vnmr manuals (content of destination directory)."
    rm -rf $MAN_DEST_DIR
fi
mkdir -p $MAN_DEST_DIR

cd $VCOMMON_DIR
for acro in $acro_list 
do
    echo "\n Tarring $acro from $VCOMMON_DIR ."
    tar -cf - $acro | (cd $MAN_DEST_DIR; tar xfBp - ; mv $acro .$acro; chmod -R g+w .$acro )
done

echo "\n Making $ONLINE_DEST_DIR directory."
mkdir -p  $ONLINE_DEST_DIR

echo "\nCopying Vnmr  online manuals from $ONLINE_SCR_DIR ."
cd $VCOMMON_DIR
cd online/..	#yes I really want to do this. 
		# it ensures that if online is a link i follow the link
ls online
tar -cf - online    | (cd $MAN_DEST_DIR;       \
                       tar xfBp - ;            \
                       mv online pdfs; mkdir .online; mv pdfs .online; \
                       chmod -R g+w .online )
#cd $VCOMMON_DIR
#cd VnmrJHelp/..	#see above
#echo "Copying VnmrJ online manuals from ${VNMRJHELP} to jhelp"
#tar -cf - VnmrJHelp | ( cd $MAN_DEST_DIR;      \
#                       tar xfBp -;             \
#                       setperms VnmrJHelp 755 644 755; \
#                       mv VnmrJHelp .jhelp )
#

echo "\n Getting supporting scripts from SCCS. \n"
cd $MAN_DEST_DIR

/sw/vbin/Sget scripts manview.sh maninstall.sh
chmod 755 manview.sh maninstall.sh
mv  manview.sh .manview
mv maninstall.sh .maninstall
#ln -s .manview Inova
#ln -s .manview Unity+
#ln -s .manview Unity
#ln -s .manview VXR-S
#ln -s .manview Gemini
#ln -s .manview Mercury
#ln -s .manview MercuryVX
#ln -s .manview MERCURYplus
#ln -s .manview Imaging
#ln -s .manview Infinity
#ln -s .manview Infinityplus
ln -s .manview Varian_NMR_Spectrometer
#ln -s .manview 400-MR
ln -s .maninstall install

echo "\n  ------- D O N E ------- "
