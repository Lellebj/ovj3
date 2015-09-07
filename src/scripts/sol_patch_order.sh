: '@(#)sol_patch_order.sh 22.1 03/24/08 1999-2002 '
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
#!/usr/bin/sh

#sol_patch_order.sh
#
#This script will generate Solaris patch_order list  from /vcommon/patch
#directory based on input argument, either Solaris28 or Solaris27

#Usage: sol_patch_order sol_version
#Example: sol_patch_order 28 (will sort the /vcommon/patch/Solaris28 patches)
#         sol_patch_order 28  | tee patch_28_log (recommended)
#
#the resulting file is ./patch_order_$sol_ver
 
count_item () {

   cnt=0
   for i in $1
   do
      cnt=`expr $cnt + 1`
   done
   echo $cnt
}

doit () {

   depends_lst=$1
   depends_lst_cnt=$2
   depends_new_list=

   echo "\n\ndepends_list= $depends_list"
   echo "no_depend_list= $no_depend_list"

   for ptch in $depends_lst
   do
      count1=0
      nn1_list_cnt=

      dpe_str=`grep "Patches required with this patch:" $patch_dir/$ptch/README.$ptch`

      yy=`echo $dpe_str | awk ' BEGIN { FS = ":" } {print $2}'`

      nn1_list=

      #generating dependency list for $ptch
      for nn1 in $yy
      do
          y1=`echo $nn1 | awk '/^[0-9][0-9][0-9]/ {print}'`
          nn1_list="$nn1_list $y1"
      done

      echo "\n          Patch $ptch depends on:  $nn1_list"

      nn1_list_cnt=`count_item "$nn1_list"`

      for dd in $nn1_list
      do
         a11=
         a22=
         depend_exist="no"
         #cheching for if it's already in the no_depend_list

         for i in $no_depend_list
         do
             #echo "----------   resulting on:  $dd"
             a11=`echo $i | cut -c1-6`
             a22=`echo $dd | cut -c1-6`

             if [ x$a11 = x$a22 ]
             then
                count1=`expr $count1 + 1`
                depend_exist="yes"
                #continue
                break

             fi
          done
       done

       if [ $nn1_list_cnt -eq $count1 ]
       then 
            no_depend_list="$no_depend_list $ptch"
       else
            depends_new_list="$depends_new_list $ptch"

       fi
   done

   depends_list=$depends_new_list

   #might not be needed, incorporated in an early section in Main
   depends_lst_cnt_new=`count_item "$depends_new_list"`
   if [ $depends_lst_cnt_new -eq $depends_lst_cnt ]
   then
      echo "\n\n   Fatal: Missing patch   ************************ \n"
      exit
   fi
}


#----------------- MAIN Main main -----------------

sol_ver="local"
patch_dir="./"

if [ $# -eq 1 ]
then
   sol_ver=$1

elif [ $# -gt 1 ]
then
   echo "\n Wrong number of argument"
   echo " Usage: $0 "
   echo " The patches must be in the current directory, or "
   echo " Usage: $0 sol_version"
   echo " Example: $0 28 (will sort the /vcommon/patch/Solaris28 patches) \n"
   exit
fi

case x$sol_ver in
   "xlocal" ) patch_dir="./"
        ;;

   "x27" ) sol_ver=Solaris27
           patch_dir="/vcommon/patch/$sol_ver"
        ;;

   "x28" ) sol_ver=Solaris28
           patch_dir="/vcommon/patch/$sol_ver"
        ;;

   "x29" ) sol_ver=Solaris29
           patch_dir="/vcommon/patch/$sol_ver"
        ;;

    *)  echo "\n $0: $1 not supported --------\n"
	exit;
        ;;
esac
	
all_patch_list=`ls  $patch_dir | awk ' /^[0-9][0-9][0-9]/  {print}'`
depends_list=
no_depend_list=
depends_new_list=
dofd_list=

echo "\nSorting $patch_dir"

#Separate patches that depend on others and independent ones into two lists
for ptch in $all_patch_list
do
   dpe_str=`grep "Patches required with this patch:" $patch_dir/$ptch/README.$ptch`

   if [ x"$dpe_str" = "xPatches required with this patch: " ]
   then
      no_depend_list="$no_depend_list $ptch"
   else
      depends_list="$depends_list $ptch"

      #generating dofd_list used for checking the existance of all patches
      tmpstr=`echo $dpe_str | awk ' BEGIN { FS = ":" } {print $2}'`

      for dd in $tmpstr
      do
          d_=`echo $dd | awk '/^[0-9][0-9][0-9]/ {print}'`
          dofd_list="$dofd_list $d_"
      done
   fi

done

missing_list=
missing_cnt=0
for dd in $dofd_list
do
   d_exist="no"
   for pp in $all_patch_list
   do
      d11=`echo $dd | cut -c1-6`
      p22=`echo $pp | cut -c1-6`

      if [ x$d11 = x$p22 ]
      then
         d_exist="yes"
         break
      fi
   done

   if [ x$d_exist = "xno" ]
   then
      missing_cnt=`expr $missing_cnt + 1`
      missing_list="$missing_list $dd"
   fi
done

if [ $missing_cnt -gt 0 ]
then
   echo "\n\n   Fatal: Missing patch(s) $missing_list   ************* \n"
   exit
fi

#to generating patch order list by looping with depends_list until nothing left
depend_lst_cnt=`count_item "$depends_list"`

while [ $depend_lst_cnt -gt 0 ]
do
   doit "$depends_list" "$depend_lst_cnt"
   depend_lst_cnt=`count_item "$depends_list"`
done

echo "\n\ndepends_list= $depends_list"
echo "\npatch_order= $no_depend_list \n"

p_order=./patch_order_$sol_ver
if [ -r $p_order ]
then
    mv -f $p_order ${p_order}.orig
fi
    
touch $p_order
#echo "\n    $sol_ver patch_order \n" > $p_order

for i in $no_depend_list
do
   echo "$i" >> $p_order
done

#cat $p_order | lp

