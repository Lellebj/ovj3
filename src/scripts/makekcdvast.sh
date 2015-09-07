: '@(#)makekcdvast.sh 22.1 03/24/08 1999-2002 '
# 
#
# Copyright (C) 2015  University of Oregon
# 
# You may distribute under the terms of either the GNU General Public
# License or the Apache License, as specified in the README file.
# 
# For more information, see the README file.
# 
#
: /bin/sh

setperms()
{
   if [ $# -lt 4 ]
   then
     echo 'Usage - setperms "directory name" "dir permissions" "file permissions
" "executable permissions"'
     echo ' E.g. "setperms /sw2/cdimage/code/tmp/wavelib 775 655 755" or "setper
ms /common/wavelib g+rx g+r g+x" '
     exit 0
   fi
   dirperm=$2
   fileperm=$3
   execperm=$4


   if [ $# -lt 5 ]
   then
      if [ $ShowPermResults -gt 0 ]
      then
         echo ""
      fi
      indent=0
   else
      indent=$5
   fi

   pars=`(cd $1; ls)`
echo $pars
   for setpermfile in $pars
   do
#  indent to proper place
      if [ $ShowPermResults -gt 0 ]
      then
         spaces=$indent
         pp=""
         while [ $spaces -gt 0 ]
         do
           pp='.'$pp
           spaces=`expr $spaces - 1`
         done
      fi

# test for director, file, executable file
     if [ -d $1/$setpermfile ]
     then
       if [ $ShowPermResults -gt 0 ]
       then
          echo "${pp}chmod $dirperm $setpermfile/"
       fi
       chmod $dirperm $1/$setpermfile
       if [ $ShowPermResults -gt 0 ]
       then
          indent=`expr $indent + 4`
       fi
       setperms $1/$setpermfile $dirperm $fileperm $execperm $indent
       indent=`expr $indent - 4`
     elif [ -f $1/$setpermfile ]
     then
       if [ -x $1/$setpermfile ]
       then
         if [ $ShowPermResults -gt 0 ]
         then
           echo "${pp}chmod $execperm $setpermfile*"
         fi
         chmod $execperm $1/$setpermfile
       else
         if [ $ShowPermResults -gt 0 ]
         then
            echo "${pp}chmod $fileperm $setpermfile"
         fi
         chmod $fileperm $1/$setpermfile
       fi
     else
      echo file:  $1/$setpermfile not modified
     fi
   done
}

DefaultDestDir="/vnmrcd/kvastcdimage"
echo ""
echo "M a k i n g   V A S T   C D R O M   F i l e s"
echo ""
#
# ask for destination  directory
#
   echo "enter destination directory [$DefaultDestDir]:\c"
   read answer
   if [ x$answer = "x" ]
   then
      dest_dir=$DefaultDestDir
   else
      dest_dir=$answer
   fi
   if  test -d $dest_dir
   then
      echo "'$dest_dir' exists, overwite? [y]:\c"
      read answer
      if [ x$answer = "x" ]
      then
         answer="y"
      fi
      if [ x$answer != "xy" ]
      then
         abort
      fi
   else
      mkdir -p $dest_dir
   fi
   echo ""
   echo "Writing files to '$dest_dir'" | tee -a $log_fln
   dest_dir_code=$dest_dir/$Code

cd $dest_dir
rm -rf *
Sget scripts load.vast
chmod 777 load.vast
Sget scripts volstart.sh
make volstart
cat volstart | sed 's/load.nmr/load.vast/' > volstart.vast
rm -f volstart volstart.sh
mv volstart.vast volstart
ShowPermResults=0
echo setperms...
mkdir code
cd /tmp
cp -r  $commondir/kGilson/ /tmp
setperms kGilson 755 644 755
cd kGilson
rm -f README
tar cvf $dest_dir/code/vast.tar *
cd /tmp
rm -rf kGilson
cd  $dest_dir
cp $commondir/kGilson/README .
chmod 666 README
chmod 777 volstart

