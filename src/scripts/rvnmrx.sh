: '@(#)rvnmrx.sh 22.1 03/24/08 1999-2000 '
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
####################################################################
#  echo without newline 
####################################################################
nnl_echo() {
if test $# -lt 1
        then
            echo
        else
            echo "$*\c"
        fi
}

####################################################################
#  Script function to get the name of the user running this script.
#  For all the systems we support, the whoami command serves.
#  The exception is Solaris, thus this script function.
####################################################################

get_username() {
    ostmp=`uname -s`
    if [ $ostmp = "SunOS" ]
    then
        case `uname -r` in
            4*) user=`whoami`
                ;;
            5*) user=`id | sed -e 's/[^(]*[(]\([^)]*\)[)].*/\1/'`
                ;;
        esac
    else
        user=`whoami`
    fi
}

####################################################################
#  Get value of vnmrsystem
#  If not defined, ask for its value
#  Use /vnmr as the default
#  make sure directory exists
####################################################################
get_vnmrsystem() {
    if test "x$vnmrsystem" = "x"
    then
        nnl_echo "Please enter location of VNMR system directory [/vnmr]: "
        read vnmrsystem
        if test "x$vnmrsystem" = "x"
        then
            vnmrsystem="/vnmr"
        fi
    fi

    if test ! -d "$vnmrsystem"
    then
        echo "$vnmrsystem does not exist, cannot proceed:"
        exit
    fi
}

####################################################################
#  Script function to extract home directory
#  use the ~username feature of the C-shell
####################################################################

get_homedir() {
csh -f 2>/dev/null << ++
echo ~$1
++
}

# MAIN main Main

get_username

if test x$user != "xroot"
then
    if test "$HOME" = "/"
    then
        echo "no home directory, cannot proceed with $0"
        exit 1
    else
        name=$user
        homedir="$HOME"
        get_vnmrsystem
        as_root="n"
    fi
    if test $# -ne 0
    then
        if test $1 != $name
        then
           echo "Only $1 or root can change or add $1's account"
           exit 1
        fi
    fi

    
else
    as_root="y"
    get_vnmrsystem

#  get the name of the user if not entered on the command line
    if test $# -eq 0
    then
        nnl_echo "Please enter user name [vnmr1]: "
        read name
        if test x$name = "x"
        then
            name="vnmr1"
        fi
    else
        name=$1
        if test $# -gt 1
        then
            default_dir=$2
        fi
    fi

    grep $name /etc/passwd  > /dev/null
    if [ $? -ne 0 ]
    then
       echo "No user $name in local /etc/passwd"
       exit 1
    fi

    homedir=`get_homedir $name`
   
fi


rm  "$homedir"/.dt/appmanager/VnmrJ/vnmrj
mv  "$homedir"/.dt/appmanager/VnmrJ "$homedir"/.dt/appmanager/VNMR

rm  "$homedir"/.dt/types/VnmrJ.dt
rm  "$homedir"/.dt/types/VnmrJ_vnmrj.dt

rm  "$homedir"/.dt/types/fp_dynamic/VnmrJ_acqstat.fp
rm  "$homedir"/.dt/types/fp_dynamic/VnmrJ_subpanel.fp
rm  "$homedir"/.dt/types/fp_dynamic/VnmrJ_vnmrj.fp

cd "$homedir"
rev=`uname -r`
case  $rev in
   5.4  | 5.5* | 5.6)
        tarfile=dtc.tar
        ;;
   5.7 | 5.8 )
        tarfile=dtc2.tar
        ;;
esac

if [ x$as_root = "xy" ]
then 
   su $name -c "tar xf /vnmr/user_templates/${tarfile}"
   cd "$homedir"/.dt
   chown -R $name appmanager types 
   nmr_group=`grep $name /etc/group | awk 'BEGIN  {FS=":"} { printf $1}'`
   chgrp -R $nmr_group appmanager types
else
   tar xf /vnmr/user_templates/${tarfile}
   echo You *MUST* logout/login now for all changes to become effective
fi

