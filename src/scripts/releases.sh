: '@(#)releases.sh 22.1 03/24/08 1991-1996 '
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
: 'save releases maps sources to then specified releases directory '
root=$sourcedir
relmdir="/vsccs"

echo ' '
echo '     This script assumes the proper release software versions are '
echo 'in their respective /common/sys..... directory '
echo ' '
echo ' Previous releases are: '
ls -C $relmdir/releases
echo ' '
echo -n 'New Release (n or y)?: '
read ans
if (test $ans != "y")
then
   exit
fi

echo -n ' Enter the New Official Release: '
read rel
if (test -d $relmdir/releases/$rel )
then
   echo "Release $rel already exist."
   exit
else
   mkdir $relmdir/releases/$rel
   mkdir $relmdir/releases/$rel/sccs
   mkdir $relmdir/releases/$rel/sccs53
   mkdir $relmdir/releases/$rel/jsccs
   reldir=$relmdir/releases/$rel
fi

echo ' '
echo ' '

SCCSDIR=$sccsdir
VNMRDIR=$sourcedir
dirnames=`ls -C $SCCSDIR` 
echo $dirnames
tdir=/tmp/reltmpf
mkdir $tdir
cd $tdir
for file in $dirnames
do
if (test $file = "halbug") || (test $file = "haltape") || (test $file = "xrbug")
then
echo " Skipping $file "
else
echo " Saving $file "
   ( /usr26/greg/projects/Script/versions $file $SCCSDIR; \
     mv ${file}_deltas_* $reldir/sccs; \
     set dir = `pwd`
     echo "   mv $dir/${NAME}_deltas_* $reldir/sccs"
     rm -f * ; \
     echo "   rm $dir/${NAME}_deltas_* "
   )
fi
done

echo ' '
echo ' '
SCCSDIR=/vsccs/sccs53
dirnames=`ls -C $SCCSDIR` 
echo $dirnames
cd $tdir
for file in $dirnames
do
if (test $file = "halbug") || (test $file = "haltape") || (test $file = "xrbug")
then
echo " Skipping $file "
else
echo " Saving $file "
   ( /usr26/greg/projects/Script/versions $file $SCCSDIR; \
     mv ${file}_deltas_* $reldir/sccs53; \
     set dir = `pwd`
     echo "   mv $dir/${NAME}_deltas_* $reldir/sccs53"
     rm -f * ; \
     echo "   rm $dir/${NAME}_deltas_* "
   )
fi
done

echo ' '
echo ' '
SCCSDIR=/vsccs/jsccs
# dirnames="jplot" 
dirnames=`ls -C $SCCSDIR` 
echo $dirnames
cd $tdir
for file in $dirnames
do
if (test $file = "halbug") || (test $file = "haltape") || (test $file = "xrbug")
then
echo " Skipping $file "
else
echo " Saving $file "
   ( /usr26/greg/projects/Script/versions $file $SCCSDIR ; \
     mv ${file}_deltas_* $reldir/jsccs; \
     set dir = `pwd`
     echo "   mv $dir/${NAME}_deltas_* $reldir/jsccs"
     rm -f * ; \
     echo "   rm $dir/${NAME}_deltas_* "
   )
fi
done

exit 0

tdir=/tmp/reltmpf
mkdir $tdir
cd $tdir
for file in help maclib manual map map2 map3  menulib psglib gpsglib shapelib yacc
do
NAME=$file
echo " Saving $NAME "
   ( sccs -d/vsccs/sccs get $NAME/SCCS
     versions $NAME all; \
     echo "   mv $tdir/${NAME}_* $reldir"
     mv ${NAME}_* $reldir; \
     rm -rf * ; \
   )
done

fi
