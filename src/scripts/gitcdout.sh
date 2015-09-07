#!/bin/sh
# gitcdout 2003-2007 
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
# scripts to make a directory with all the data needed for Nirvana

# Default Declarations
#

if [ x$workspacedir = "x" ]
then
   workspacedir=$HOME
fi

gitdir=$workspacedir/git-repo
vnmrdir=$gitdir/../vnmr
standardsdir=$gitdir/../options/standard
passwordeddir=$gitdir/../options/passworded
optionsdir=$gitdir/../options
consoledir=
consoledir=$gitdir/../console

ShowPermResults=-100

Code="code"
Tarfiles="tarfiles"
 
#
# determine if pbzip2 is installed and is newer than v1.0.2
# pbzip2 allows parallel bzip2 compression using all the processor cores
#
usePBZIP2() {
   usepbzip='n'
   if [ -x /usr/sbin/pbzip2 -o -x /usr/bin/pbzip2 ] ; then
      # pbzip2 v1.0.3 and above work with pipes, v1.0.2 does not 
      revminor=`pbzip2 -V 2>&1 | awk 'BEGIN { FS = "." } /v1/ { print $3 }' | awk 'BEGIN { FS = " " } { print $1 }'`
      revmajor=`pbzip2 -V 2>&1 | awk 'BEGIN { FS = "." } /v1/ { print $2 }'`
     if [ $revmajor -ge 0 -a $revminor -gt 2 ] ; then
        usepbzip='y'
     fi
   else
     usepbzip='n'
   fi
   # echo "usepbzip: $usepbzip"
}

taroption="xfBp"
cpoption="-rp"

ostype=`uname -s`
ostype="Linux"

#
# files needed for loading from cd
#
SubDirs="				\
		rht			\
		tarfiles		\
		linux		\
		tmp			\
		"

RmOptFiles="				\
		rht/vnmrs.rht		\
		rht/vnmrs.opt		\
		rht/mr400.rht		\
		rht/mr400.opt		\
		rht/propulse.opt	\
		"
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
      if [ $ShowPermResults -gt 0 ]
      then
         echo "" 
      fi
      indent=0
   else
      indent=$5
   fi
   
   pars=`(cd $1; ls)`
   for setpermfile in $pars
   do
      #indent to proper place
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
   
      #test for director, file, executable file
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
#      else
#         echo file:  $1/$setpermfile not modified
      fi
   done
}

# routine to force "Tarring xyz    for:" to same length
tarring()
{
  #echo $1
  len=`expr length "$1"`
  #echo $len
  echo " " | tee -a $log_file
  echo -n " " | tee -a $log_file
  echo -n " " | tee -a $log_file
  echo -n " " | tee -a $log_file
  str=`echo "Tarring $1"`
  ns=`expr 22 - $len`
  #echo spaces: $ns
  echo -n $str | tee -a $log_file
  while [ $ns -gt 0 ];  do
    #str=`expr "$str"" "`
    echo -n " " | tee -a $log_file
    ns=`expr $ns - 1`
  done
  #echo \'$str\'
  echo -n "for:" | tee -a $log_file

}

#
# tar bzip2 options tarfilename dir2tar or files2tar
#  tarbzip2 "--exclude=.gitignore" "$dest_dir_code/$Tarfiles${dir}.tar" "*"
#
tarbzip2() {
   if [ "x$usepbzip" = "xy" ] ; then
       # echo "tar $1 -cf $2 --use-compress-program pbzip2  $3"
       # tar $1 -cf $2 --use-compress-program pbzip2  $3    this varient does not owrk on RHEL 6.X so used the second form below  GMB.
       tar $1 -c $3 | pbzip2 -c >  $2
   else
       # echo "tar $1 -cjf $2 $3"
       tar $1 -cjf $2 $3
   fi
}

#---------------------------------------------------------------------------
#
# usage: getSize directory
#
# getSize $dest_dir/tmp
# getSize $dest_dir/jre.Linux
getSize()
{
    size_name=`du -sk $1`
    Size=`echo $size_name | awk 'BEGIN { FS = " " } { print $1 }'`
}

#---------------------------------------------------------------------------
#
# usage: makeTOC  <tarfile> <category>  <TOCfile TOCfile ...>
#
#   tarfile:   com.tar, jre.tar ...,    these are NMR sofware packages
#   category:  VNMR, JMol, userlib ..., Nmr package names to be selected 
#				        when loading Nmr software
#   TOCfile:   rht/vnmrs.rht rht/mr400.rht, ..., these files contain a list
#					of needed sofware for particular system
makeTOC()
{
   ( #usage: makeTOC  <tarfile>  <category>  <TOCfile TOCfile ...>
     tfile=$1
     shift
     cat=$1
     shift
     flist=$*
     dir=$Tarfiles

     for i in $flist
     do
        echo "${cat} $Size $Code/$dir/$tfile" >> $dest_dir_code/$i
        systemname=`basename $i`
        nnl_echo "  $systemname" | tee -a $log_file
     done
     rm -rf $dest_dir_code/tmp/*
   )
}

nnl_echo() {
    
    case x$ostype in

	"x")
            echo "error in echo-no-new-line: ostype not defined"
            exit 1
            ;;

        "xSOLARIS")
            echo "$*\c"
            ;;

        "xLinux")
            echo -n "$*"
            ;;

        *)
            echo -n "$*"
            ;;
    esac
}

log_this(){

   if [ ! -d $dest_dir_code/tmp ]
   then
       mkdir -p $dest_dir_code/tmp
   else
       rm -rf $dest_dir_code/tmp/*
   fi

   echo "" | tee -a $log_file
   echo "" | tee -a $log_file
   nnl_echo "$1" | tee -a $log_file
}

findcore() {
   find . -name core -exec rm {} \;
}

create_support_dirs () {

   cd $1
   nnl_echo "$Code " | tee -a $log_file
   if [ ! -d $Code ]
   then
      mkdir -p $Code
   fi
   cd $Code
   dirs=$SubDirs
   for file in $dirs
   do
      nnl_echo "$file " | tee -a $log_file
      if [ ! -d $file ]
      then
         mkdir -p $file
      fi
   done
   echo "" | tee -a $log_file
   echo "" | tee -a $log_file
   echo "Clearing *.opt files and tmp:" | tee -a $log_file
   cd $dest_dir_code
   for file in $RmOptFiles
   do
      nnl_echo "$file " | tee -a $log_file
      rm -rf $file
      touch $file
   done
   rm -rf $dest_dir_code/tmp/*
}                                                                                                 
drop_vnmrs_ () {
   vnmrs_list=`ls vnmrs_*`
   for file in $vnmrs_list 
   do
      newfln=`echo $file | cut -c7-`
      rm -f $newfln
      mv $file $newfln
   done
}


#############################################################
#              MAIN Main main
#############################################################

curr_dir=`pwd`

LoadVnmrJ="y"

# done later after proper paths have been determined....  GMB
# these should change together, extract 2.3 out of version?
#VnmrRevId=`grep REVISION_ID ${gitdir}/versions | cut -s -d\" -f2`
#RevFileName="vnmrj"`echo $VnmrRevId | awk '{print $3}'`

Vnmr="VNMR"

# determine if pbipz2 is installed
usePBZIP2
interact="no"
console="vnmrs"

if [ $# -ge 1 ]
then
   case x$1 in
	xGVJ | xgvj )

         # workspace at same level as you r git repor, if script run within git-repo/software/script
         workspacedir=$curr_dir/../../..
         gitdir=$workspacedir/git-repo
         vnmrdir=$gitdir/../vnmr
         standardsdir=$gitdir/../options/standard
         passwordeddir=$gitdir/../options/passworded
         optionsdir=$gitdir/../options

          echo " "
          echo " "
          echo " "
          echo "Please check the following directory paths, if gitcdout was run from "
          echo "your git-repo/software/script directory, the relative paths should be correct."
          echo " "
          echo "git-repo dir: $gitdir"
          echo " "
          echo "git built vnmr dir: $vnmrdir"
          echo " "
          echo "cdimage dir: $workspacedir/cdimageNVJ"
          echo " "
          nnl_echo "Directory Paths Correct? [y]: "
          read answer
          echo " "
          if [ x$answer = "x" ]
          then
             answer="y"
          fi
          if [ x$answer != "xy" ]
          then
             exit
          fi

   		 DefaultDestDir="$workspacedir/cdimageNVJ"
   		 DefaultLogDir="$workspacedir/logs"
   		 DefaultLogFile="$workspacedir/logs/gitcdoutlogVJ"
                 interact="yes"
	;;

	xVJ | xvj )

   		DefaultDestDir="$workspacedir/cdimageNVJ"
   		DefaultFiniDir=`date '+/rdvnmr/.nv_vj%m.%d'`
   		DefaultLogDir="$workspacedir/logs"
   		DefaultLogFile="$workspacedir/logs/gitcdoutlogVJ"
                interact="yes"
	;;

	xA | xa )

   		DefaultDestDir="$gitdir/../cdimageAxiom"
   		DefaultFiniDir="none"
   		DefaultLogDir="$gitdir/../logs"
   		DefaultLogFile="$gitdir/../logs/gitcdoutlogA"
   		log_file=$DefaultLogFile
   		rm -rf $log_file
   		echo "Writing log to '$log_file' file"
   		dest_dir=$DefaultDestDir
   		fini_dir="/rdvnmr/.gitcd"
   		echo ""
   		useDasho="y"
   		notifySW="n"
                console="axiom"
	;;

	* )
   		DefaultDestDir="$workspacedir/cdimageNVJ"
   		DefaultFiniDir="none"
   		DefaultLogDir="$workspacedir/logs"
   		DefaultLogFile="$workspacedir/logs/gitcdoutlog"
		log_file=$DefaultLogFile
                interact="yes"
	;;
   esac
else
   DefaultDestDir="$gitdir/../cdimageNVJ"
   DefaultFiniDir="none"
   DefaultLogDir="$gitdir/../logs"
   DefaultLogFile="$gitdir/../logs/gitcdoutlog"
   log_file=$DefaultLogFile
   rm -rf $log_file
   echo "Writing log to '$log_file' file"
   dest_dir=$DefaultDestDir
   fini_dir="/rdvnmr/.gitcd"
   echo ""
   useDasho="y"
   notifySW="n"
fi

distro=`lsb_release -is`    # RedHatEnterpriseWS; Ubuntu

# Passwords contained in vnmrjOptions file
if [ "x$distro" = "xUbuntu" ] ; then
   . $gitdir/scripts/vnmrjOptions
else
   source $gitdir/scripts/vnmrjOptions
fi

# do this after paths have been decided...
# these should change together, extract 2.3 out of version?
VnmrRevId=`grep REVISION_ID ${gitdir}/versions | cut -s -d\" -f2`
RevFileName="vnmrj"`echo $VnmrRevId | awk '{print $3}'`

# create log directory if not present
if [ ! -d $DefaultLogDir ]
then
      mkdir -p $DefaultLogDir
fi



if [ x$interact = "xyes" ]
then
# ask for log filename
   umask 2
   echo "Use an absolute path for log !!"
   echo "This script changed directory many times"
   echo "And will write the log in that directory"
   nnl_echo "Enter destination file for log   [$DefaultLogFile]: "
   read answer
   if [ x$answer = "x" ]
   then
      log_file=$DefaultLogFile
   else
      log_file=$answer
   fi
   if test -f $log_file
   then
      nnl_echo "'$log_file' exists, overwrite? [y]: "
      read answer
      if [ x$answer = "x" ]
      then
         answer="y"
      fi
      if [ x$answer != "xy" ]
      then
         exit
      fi
      rm -rf $log_file
   fi
   echo "Writing log to '$log_file' file"
   echo ""

   # ask for destination  directory
   nnl_echo "Enter destination directory [$DefaultDestDir]:"
   read answer
   if [ x$answer = "x" ]
   then
       dest_dir=$DefaultDestDir
   else
       dest_dir=$answer
   fi

   if  test -d $dest_dir
   then
       nnl_echo "'$dest_dir' exists, overwite? [y]:"
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

#   nnl_echo "enter Finial directory [$DefaultFiniDir]:"
#   read answer
#   if [ x$answer = "x" ]
#   then
#      fini_dir=$DefaultFiniDir
#   else
#      fini_dir=$answer
#   fi
#
#   if [ x$fini_dir = "xnone" ]
#   then
      echo "No Write to Finial Directory will be made. " | tee -a $log_file
      echo ""
#   else
#   
#      if  test  -d $fini_dir
#      then
#         echo "'$fini_dir' exists, overwite? [y]:"
#         read answer
#         if [ x$answer = "x" ]
#         then
#            answer="y"
#         fi
#         if [ x$answer != "xy" ]
#         then
#            abort
#         fi
#      else
#         mkdir -p $fini_dir
#         if  [ ! -d $fini_dir ]
#         then
#	    echo "Could not create Final Directory: $fini_dir, Aborting. " | tee -a $log_file
#	    exit 1
#         fi
#      fi
#      echo "Writing results to Final Directory: $fini_dir "| tee -a $log_file
#      echo ""
#   fi

   nnl_echo "Use Dasho Jars as Defaults [$DefaultDasho]:"
   read answer
   if [ x$answer = "x" ]
   then
      useDasho=$DefaultDasho
   else
      useDasho=$answer
   fi

   echo ""
   nnl_echo "Mail SW Group when CD Image for $fini_dir is complete? [$DefaultMail]:"
   read answer
   answer="n"
   if [ x$answer = "x" ]
   then
      notifySW=$DefaultMail
   else
      notifySW=$answer
   fi
fi


echo ""
dest_dir_code=$dest_dir/$Code

echo
echo "log_file	= $log_file +++++++++++++"
echo "dest_dir	= $dest_dir +++++++++++++"
echo "fini_dir	= $fini_dir +++++++++++++"
echo
echo "notifySW	= $notifySW +++++++++++++"
#echo "com_answer	= $com_answer +++++++++++++"
#echo "par_answer	= $par_answer +++++++++++++"
#echo "gnu_answer	= $gnu_answer +++++++++++++"
#echo "user_answer	= $user_answer +++++++++++++"
#echo "password_answer	= $password_answer +++++++++++++"
echo
echo

if [ ! -d $dest_dir ]
then
   mkdir -p $dest_dir
fi

if [ ! -r $log_file ]
then
   touch $log_file
fi

echo "Writing files to '$dest_dir'" | tee -a $log_file
echo "" | tee -a $log_file
echo "Creating needed subdirectories:" | tee -a $log_file

create_support_dirs $dest_dir

echo "" | tee -a $log_file
echo `date` | tee -a $log_file
echo "" | tee -a $log_file
echo "M a k i n g   V n m r J   C D R O M   I m a g e" | tee -a $log_file

echo $VnmrRevId  | tee -a $log_file
echo `date '+%B %d, %Y'` | tee -a $log_file


#============== COMMON FILES =============================================
echo "" | tee -a $log_file
log_this  "PART I -- COMMON TAR FILES -- $dest_dir_code/$Tarfiles"
# Let's copy and tar the Common files and log it.
vnmrList=`ls $vnmrdir`

if [ -d $vnmrdir/psg ]
then
   chmod 644 $vnmrdir/psg/*
fi
if [ -d $vnmrdir/psglib ]
then
   chmod 644 $vnmrdir/psglib/*
fi

for dir in  $vnmrList 
do

case x$dir in 
#---------------------------------------------------------------------------
   xacqqueue )	# acqqueue get created with 777 permissions during install
		# Below the *) case changes it to 755. Don't bother.
      ;;
#---------------------------------------------------------------------------
   xacq )
      #log_this "   Tarring acq		for : "
      tarring "acq"
      cd $vnmrdir
      tar --exclude=.gitignore -cf - ${dir} | (cd $dest_dir_code/tmp; tar $taroption -)

      cd $dest_dir_code/tmp
#      cp acq/download/nvScript acq/download/nvScript.std
#      cp acq/download/nvScript.md5 acq/download/nvScript.std.md5
      setperms ./ 755 644 755
      # tar --exclude=.gitignore -cjf $dest_dir_code/$Tarfiles/${dir}.tar *
      tarbzip2 "--exclude=.gitignore" "$dest_dir_code/$Tarfiles/${dir}.tar" "*"
      getSize $dest_dir_code/tmp
      makeTOC ${dir}.tar $Vnmr rht/vnmrs.rht	\
                               rht/mr400.rht    \
                               rht/propulse.rht
    ;;
#---------------------------------------------------------------------------
   xjre )
       #log_this "   Tarring jre	             for : "
       tarring "$dir"
       cd $vnmrdir
       tar --exclude=.gitignore -cf $dest_dir_code/$Tarfiles/jre.tar jre
       # tarbzip2 "--exclude=.gitignore" "$dest_dir_code/$Tarfiles/jre.tar" "jre"
       cd $dest_dir_code
       tar xpf $Tarfiles/jre.tar
       rm -rf jre.linux
       mv jre jre.linux
       getSize $dest_dir_code/jre.linux
       makeTOC jre.tar $Vnmr rht/vnmrs.rht	\
			     rht/mr400.rht      \
                             rht/propulse.rht
       rm $Tarfiles/jre.tar	# exception
   ;;
#---------------------------------------------------------------------------
   * )
      #log_this "   Tarring $dir		for : "
      tarring "$dir"
      cd $vnmrdir
      tar --exclude=.gitignore -cf - ${dir} | (cd $dest_dir_code/tmp; tar $taroption -)

      cd $dest_dir_code/tmp
      setperms ./ 755 644 755
      # tar --exclude=.gitignore -cjf $dest_dir_code/$Tarfiles/${dir}.tar *
      tarbzip2 "--exclude=.gitignore" "$dest_dir_code/$Tarfiles/${dir}.tar" "*"
      getSize $dest_dir_code/tmp
      makeTOC ${dir}.tar $Vnmr  rht/vnmrs.rht	\
				rht/mr400.rht   \
                                rht/propulse.rht
   ;;
esac
done

# Do manuals separately
      dir="help_pdf"
      tarring "$dir"
      cd $workspacedir/git-extra
      tar -cf - help | (cd $dest_dir_code/tmp; tar $taroption -)

      cd $dest_dir_code/tmp
      setperms ./ 755 644 755
      # tar --exclude=.gitignore -cjf $dest_dir_code/$Tarfiles/${dir}.tar *
      tarbzip2 "--exclude=.gitignore" "$dest_dir_code/$Tarfiles/${dir}.tar" "*"
      getSize $dest_dir_code/tmp
      makeTOC ${dir}.tar $Vnmr  rht/vnmrs.rht   \
                                rht/mr400.rht   \
                                rht/propulse.rht

#      dir="biopack_help"
#      tarring "$dir"
#      cd $workspacedir/git-extra
#      tar -cf - biopack | (cd $dest_dir_code/tmp; tar $taroption -)
#
#      cd $dest_dir_code/tmp
#      setperms ./ 755 644 755
#      # tar --exclude=.gitignore -cjf $dest_dir_code/$Tarfiles/${dir}.tar *
#      tarbzip2 "--exclude=.gitignore" "$dest_dir_code/$Tarfiles/${dir}.tar" "*"
#      getSize $dest_dir_code/tmp
#      makeTOC ${dir}.tar "Biopack"  rht/vnmrs.rht    \
#                                rht/propulse.rht
#

#============== CONSOLE SPECIFIC FILES ===============================
if [ x$consoledir != "x" ]
then

echo "" | tee -a $log_file
log_this  "PART IA -- CONSOLE TAR FILES -- $dest_dir_code/$Tarfiles"
  dir=propulse
      tarring "$dir"
      cd ${consoledir}/${dir}
      tar -cf - * | (cd $dest_dir_code/tmp; tar $taroption -)
      cd $dest_dir_code/tmp
      setperms ./ 755 644 755
      getSubjectPassword ${dir}
      getSize $dest_dir_code/tmp
      # tar --exclude=.gitignore -cjf $dest_dir_code/$Tarfiles/${dir}.tar *
      tarbzip2 "--exclude=.gitignore" "$dest_dir_code/$Tarfiles/${dir}.tar" "*"
      makeTOC ${dir}.tar $Vnmr  rht/propulse.rht  \
                                rht/mr400.rht
  dir=vnmrs
      tarring "$dir"
      cd ${consoledir}/${dir}
      tar -cf - * | (cd $dest_dir_code/tmp; tar $taroption -)
      cd $dest_dir_code/tmp
      setperms ./ 755 644 755
      getSubjectPassword ${dir}
      getSize $dest_dir_code/tmp
      # tar --exclude=.gitignore -cjf $dest_dir_code/$Tarfiles/${dir}.tar *
      tarbzip2 "--exclude=.gitignore" "$dest_dir_code/$Tarfiles/${dir}.tar" "*"
      makeTOC ${dir}.tar $Vnmr  rht/vnmrs.rht   \
                                rht/mr400.rht
fi

#============== STANDARD OPTIONS FILES ===============================
echo "" | tee -a $log_file
log_this  "PART II -- STANDARD OPTIONS TAR FILES -- $dest_dir_code/$Tarfiles"
# "Let's copy and tar the Standard Option files and log it."
standardList=`ls $standardsdir`
for dir in $standardList
do

case x$dir in
    xMR400FH )		# for 400-MR only
      #log_this "   Tarring $dir		for : "
      tarring "$dir"
      cd ${standardsdir}/${dir}
      tar -cf - * | (cd $dest_dir_code/tmp; tar $taroption -)

      cd $dest_dir_code/tmp
      setperms ./ 755 644 755
      getSubjectPassword ${dir}
      getSize $dest_dir_code/tmp
      # tar --exclude=.gitignore -cjf $dest_dir_code/$Tarfiles/${dir}.tar *
      tarbzip2 "--exclude=.gitignore" "$dest_dir_code/$Tarfiles/${dir}.tar" "*"
      makeTOC ${dir}.tar "$Subject"  rht/mr400.rht
    ;;

    xBiopack | xdicom | xIMAGE | xBIR )		# for VNMRS only
      #log_this "   Tarring $dir		for : "
      tarring "$dir"
      cd ${standardsdir}/${dir}
      tar -cf - * | (cd $dest_dir_code/tmp; tar $taroption -)

      cd $dest_dir_code/tmp
      setperms ./ 755 644 755
      getSubjectPassword ${dir}
      getSize $dest_dir_code/tmp
      # tar --exclude=.gitignore -cjf $dest_dir_code/$Tarfiles/${dir}.tar *
      tarbzip2 "--exclude=.gitignore" "$dest_dir_code/$Tarfiles/${dir}.tar" "*"
      makeTOC ${dir}.tar "$Subject"  rht/vnmrs.rht    \
                                     rht/propulse.rht
    ;;

    * )
      #log_this "   Tarring $dir		for : "
      tarring "$dir"
      cd ${standardsdir}/${dir}
      tar -cf - * | (cd $dest_dir_code/tmp; tar $taroption -)

      cd $dest_dir_code/tmp
      setperms ./ 755 644 755
      getSubjectPassword ${dir}
      getSize $dest_dir_code/tmp
      # tar --exclude=.gitignore --exclude=SConstruct* -cjf $dest_dir_code/$Tarfiles/${dir}.tar *
      tarbzip2 "--exclude=.gitignore --exclude=SConstruct" "$dest_dir_code/$Tarfiles/${dir}.tar" "*"
      makeTOC ${dir}.tar "$Subject"  rht/vnmrs.rht	\
				     rht/mr400.rht      \
                                     rht/propulse.rht
    ;;
esac
done
# Do userlib separately
      dir="userlib"
      tarring "$dir"
      cd $dest_dir_code/tmp
      cp $gitdir/3rdParty/${dir}.tar .
      chmod 644 ${dir}.tar
      getSubjectPassword ${dir}
      getSize $dest_dir_code/tmp
      mv ${dir}.tar $dest_dir_code/$Tarfiles/.
      makeTOC ${dir}.tar "$Subject"  rht/vnmrs.rht	\
				     rht/mr400.rht      \
                                     rht/propulse.rht
#============== PASSWORDED OPTIONS FILES ===============================
echo "" | tee -a $log_file
log_this  "PART III -- PASSWORDED TAR FILES -- $dest_dir_code/$Tarfiles"
# "Let's copy and tar the Standard Option files and log it."
passwordedList=`ls $passwordeddir`
for dir in $passwordedList
do

case x$dir in
   # options for 400-MR and Varian NMR System
   xDOSY | xP11 | xcraft )
      #log_this "   Tarring $dir		for : "
      tarring "$dir"
      cd ${optionsdir}/passworded/${dir}
      tar -cf - * | (cd $dest_dir_code/tmp; tar $taroption -)

      cd $dest_dir_code/tmp
      setperms ./ 755 644 755
      getSubjectPassword ${dir}
      getSize $dest_dir_code/tmp
      # piping to encode results in larger than normal files and appears to have garbage at the end
      # causing the tar -xjf to complain about it. 
      #tar --exclude=.gitignore -cjf - * | ${optionsdir}/bin/encode $Password > $dest_dir_code/$Tarfiles/${dir}.pwd *
      # tar --exclude=.gitignore -cjf ./tmptar.tbz2 * 
      tarbzip2 "--exclude=.gitignore" "./tmptar.tbz2" "*"
      ${optionsdir}/bin/encode $Password < ./tmptar.tbz2 > $dest_dir_code/$Tarfiles/${dir}.pwd  
      rm -f ./tmptar.tbz2
      makeTOC ${dir}.pwd "$Subject"  rht/vnmrs.opt	\
				     rht/mr400.opt      \
                                     rht/propulse.opt
      printf "${dir}.pwd $Subject\n" >> $dest_dir_code/rht/vnmrs.options
      printf "${dir}.pwd $Subject\n" >> $dest_dir_code/rht/mr400.options
      printf "${dir}.pwd $Subject\n" >> $dest_dir_code/rht/propulse.options
    ;;

   xservicetools )
      #log_this "   Tarring $dir		for : "
      # servicetools are not listed as an option
      # during installation, ins_vnmr will move this file to adm/options
      tarring "$dir"
      cd ${optionsdir}/passworded/${dir}
      tar -cf - * | (cd $dest_dir_code/tmp; tar $taroption -)

      cd $dest_dir_code/tmp
      setperms ./ 755 644 755
      getSubjectPassword ${dir}
      tarbzip2 "--exclude=.gitignore" "./tmptar.tbz2" "*"
      ${optionsdir}/bin/encode $Password < ./tmptar.tbz2 > $dest_dir_code/$Tarfiles/${dir}.pwd  
      rm -f ./tmptar.tbz2
    ;;

   # Options are for Varian NMR system ONLY !
   * )
      #log_this "   Tarring $dir		for : "
      tarring "$dir"
      cd ${optionsdir}/passworded/${dir}
      tar -cf - * | (cd $dest_dir_code/tmp; tar $taroption -)

      cd $dest_dir_code/tmp
      setperms ./ 755 644 755
      getSubjectPassword ${dir}
      getSize $dest_dir_code/tmp
      #tar --exclude=.gitignore -cjf - * | ${optionsdir}/bin/encode $Password > $dest_dir_code/$Tarfiles/${dir}.pwd *
      # tar --exclude=.gitignore -cjf ./tmptar.tbz2 * 
      tarbzip2 "--exclude=.gitignore" "./tmptar.tbz2" "*"
      ${optionsdir}/bin/encode $Password < ./tmptar.tbz2 > $dest_dir_code/$Tarfiles/${dir}.pwd  
      rm -f ./tmptar.tbz2
      makeTOC ${dir}.pwd "$Subject"  rht/vnmrs.opt   \
                                     rht/propulse.opt
      printf "${dir}.pwd $Subject\n" >> $dest_dir_code/rht/vnmrs.options
      printf "${dir}.pwd $Subject\n" >> $dest_dir_code/rht/propulse.options
    ;;
esac
done

#============== INSTALLATION FILES =========================================
echo "" | tee -a $log_file
log_this "PART IV -- INSTALLATION FILES -- $dest_dir"
# copy some of the installation programs
optionsList=`ls $optionsdir`
for dir in $optionsList
do

case x$dir in
   xbin | xpassworded | xstandard | xconsole )
   #  do nothing here
   ;;

   xcode )
      log_this " Tarring install files "
      echo "" | tee -a $log_file
       cd $optionsdir/$dir
       tar --exclude=.gitignore -cf - * .??* | (cd $dest_dir_code; tar $taroption -)
       cp $gitdir/software/scripts/ins_vnmr2.sh $dest_dir_code/ins_vnmr
       chmod 755 $dest_dir_code/ins_vnmr
       cp $gitdir/software/scripts/vjpostinstallaction.sh $dest_dir_code/vjpostinstallaction
       chmod 755 $dest_dir_code/vjpostinstallaction
       cd $dest_dir
       rm -rf load.nmr
#      setup nolonger used.
#       mv code/setup setup
       ln -s code/vnmrsetup load.nmr
       ln -s code/rpmInstruction.txt rpmInstruction.txt
   ;;

   xlicense )
      log_this " Tarring license files "
      echo "" | tee -a $log_file
      cd $optionsdir/
      tar --exclude=.gitignore -cf - $dir | (cd $dest_dir; tar $taroption -)
   ;;

   * )
      #log_this " Tarring $dir           for : "
      tarring "$dir"
      cd $optionsdir/$dir
      tar -cf - * | (cd $dest_dir_code/tmp; tar $taroption - )
      cd $dest_dir_code/tmp
      setperms ./ 755 644 755
      #tar --exclude=.gitignore -cjf  $dest_dir_code/$Tarfiles/${dir}.tar *
      tarbzip2 "--exclude=.gitignore" "$dest_dir_code/$Tarfiles/${dir}.tar" "*"
      makeTOC ${dir}.tar $Vnmr  rht/vnmrs.rht   \
                                rht/mr400.rht   \
                                rht/propulse.rht
   ;;
esac
done
       

#Nirvana CD only
touch $dest_dir_code/.nv

#
#  VJ cdrom only
#
   echo "" | tee -a $log_file
   echo " Copying icons" | tee -a $log_file
   cd $dest_dir_code
   if [ ! -d $dest_dir_code/icon ]
   then
      mkdir -p $dest_dir_code/icon
   fi
   if [ x$console = "xaxiom" ]
   then
     cp $gitdir/software/vnmrj/src/vnmr/images/vnmrsjsu.png icon/propulse.png
     cp $gitdir/software/gif/mr400.gif icon/.
     cp $gitdir/software/vnmrj/src/vnmr/images/mr400dd2.png icon/.
     cd $dest_dir_code/rht
     cp $gitdir/software/gif/installJSU install
     chmod 777 $dest_dir_code/rht
     chmod 666 install
     cp mr400.opt mr400dd2.opt
     cp mr400.options mr400dd2.options
     cp mr400.rht mr400dd2.rht
   else
     cp $gitdir/software/vnmrj/src/vnmr/images/vnmrsjsu.png icon/propulse.png
     cp $gitdir/software/gif/vnmrs.gif icon/.
     cp $gitdir/software/gif/mr400.gif icon/.
     cp $gitdir/software/vnmrj/src/vnmr/images/mr400dd2.png icon/.
     cp $gitdir/software/vnmrj/src/vnmr/images/vnmrsdd2.png icon/.
     cd $dest_dir_code/rht
     cp $gitdir/software/gif/install .
     chmod 777 $dest_dir_code/rht
     chmod 666 install
     cp mr400.opt mr400dd2.opt
     cp mr400.options mr400dd2.options
     cp mr400.rht mr400dd2.rht
     cp vnmrs.opt vnmrsdd2.opt
     cp vnmrs.options vnmrsdd2.options
     cp vnmrs.rht vnmrsdd2.rht
   fi

   cd $dest_dir_code/../
   echo " Writing Revision File '$RevFileName':"  | tee -a $log_file
   echo "$VnmrRevId" > vnmrrev
   echo "`date '+%B %d, %Y'`" >> vnmrrev
   cat vnmrrev | tee -a $log_file
   echo " "
   echo " "
   echo "CD Build ID, based on Current git sha1 "  | tee -a $log_file
   echo " "
   cat $vnmrdir/adm/sha1/CD_Build_Id.txt | tee -a $log_file
   echo " "
   rm -f  $RevFileName
   ln -s vnmrrev $RevFileName
# No longer need since the sha1 files are place into the adm/sha1 and adm is tarred
# else where in this script
# 
#   echo "Copying sha1 check list files:"  | tee -a $log_file
# create the tar of vnmr/adm/sha1
#   cd  $vnmrdir
#   tar -cjvf $dest_dir_code/$Tarfiles/sha1files.tar adm/sha1 
#   cp sha1files.tar $dest_dir_code/$Tarfiles
    cp $vnmrdir/adm/sha1/CD_Build_Id.txt $dest_dir_code/
#   cp $vnmrdir/sha1chklist.txt $dest_dir_code/../
#   cp $vnmrdir/sha1chklistOptionsStd.txt $dest_dir_code/../
#   cp $vnmrdir/sha1chklistOptionsPwd.txt $dest_dir_code/../


#Create a system checksums file to validate Part11 system
if [ x$LoadP11 = "xy" ]
then

    mkdir -p $dest_dir_code/tmp
    cd $dest_dir_code/tmp
     
    tar xvf $dest_dir_code/$Tarfiles/combin.tar
    tar xvf $dest_dir_code/$Tarfiles/vnmrj.tar
    tar xvf $dest_dir_code/$Tarfiles/vnmrjbin.tar
    tar xvf $dest_dir_code/$Tarfiles/java.tar
    tar xvf $dest_dir_code/$Tarfiles/vnmrjadmjar.tar
    tar xvf $dest_dir_code/$Tarfiles/wobbler.tar
    tar xvf $dest_dir_code/$Tarfiles/acqbin2.tar
    tar xvf $dest_dir_code/$Tarfiles/acqbin.tar
    tar xvf $dest_dir_code/$Tarfiles/bin.tar
    tar xvf $dest_dir_code/$Tarfiles/unibin.tar
    tar xvf $dest_dir_code/$Tarfiles/binx.tar

    mkdir -p adm/p11
    #bin/vnmrMD5 -l /vcommon/p11/sysList vnmrsystem > adm/p11/syschksm

    #pack checksum file together within com.tar
    #tar -rf $dest_dir_code/$Tarfiles/com.tar  adm/p11/syschksm

    cd $dest_dir_code
    rm -rf tmp
fi

#---------------------------------------------------------------------------
# Finally, all done, write out passwd file, clean up some unneeded directories
 
   cd $dest_dir/..
   echo "" | tee -a $log_file
   echo "" | tee -a $log_file
   printf "The passwords used with this install are:\n" > passwords | tee -a $log_file
   printf "\n" >> passwords
   for dir in $passwordedList
   do
      getSubjectPassword ${dir}
      printf "%-40s %s\n" $Subject $Password >> passwords
   done
   printf "\n" >> passwords

   cat passwords >> $log_file
   echo " " | tee -a $log_file
   
#   fini_dir="/rdvnmr/.gitcd"
#   if [ x$fini_dir != "xnone" ]
#   then
#     echo "Write CD Image to Destination Place: $fini_dir" | tee -a $log_file
#     if [ -d $fini_dir ]
#     then 
#        rm -rf $fini_dir/*
#     else
#        mkdir $fini_dir
#     fi
#     cd $dest_dir
#     tar -cf - . | (cd $fini_dir; tar $taroption -)
#     cp $dest_dir/../passwords $fini_dir.passwords
#
#     if [ x$LoadVnmrJ = "xy" ]
#     then
#        if [ x$winbuild != "xtrue" ]
#        then
#           rm -f /rdvnmr/.cdromVJ_latest
#           ln -s $fini_dir /rdvnmr/.cdromVJ_latest
#        else
#           rm -f /rdvnmr/.cdromVJ_latest_win
#           ln -s $fini_dir /rdvnmr/.cdromVJ_latest_win
#        fi
#     else
#        rm -f /rdvnmr/.cdrom_latest
#        ln -s $fini_dir /rdvnmr/.cdrom_latest
#     fi
#     if [ x$notifySW = "xy" ]
#     then
#	mail_list="`cat $vbin/cdout_mail_list`"
#        msg1="Subject:  $fini_dir Completed"
#        msg2="To: $mail_list"
        msg3a=`echo "FYI,\n"`
#        msg3=`echo "CD Image \"$fini_dir\" is Built.\n"`
#        msg4=`echo "No Warranty is Expressed or Implied.\n"`
#        msg="$msg1\n$msg2\n \n \n$msg3a\n\n$msg3\n$msg4\n\n"
#        echo $msg | mail  $mail_list 
#     fi
#   fi

echo "DONE == gitcdout == ` date +"%F %T"` ==" | tee -a $log_file
