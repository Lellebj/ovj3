: '@(#)lnsrc.sh 22.1 03/24/08 1991-1996 '
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
: Link Sources of a category in to present directory 
: G. M. Brissey		880826
#set -x
if test $# -lt 1
then 
	echo 'usage -- lnsrc category '
        echo  Main use is to link sources into a directory for dbxtool usage
        echo categories are:
        ls -C $sccsdir
else
   if (test -d $sourcedir/sys$1)
   then
     pdir=`pwd`
     cd $sourcedir/sys$1
     LOBJ=`ls -C *.c`
     LOBJS=`ls -C *.s` 
     LLEXOBJ=`ls -C magic.lex.l`
     LGRAMOBJ=`ls -C magic.gram.y`

     cd $pdir
     MakeFile=/vusr/bin/makelinks

    make -fe $MakeFile linksrc \
    "CAT=$1"	\
    "OBJ=$LOBJ"  \
    "OBJS=$LOBJS" \
    "LEXOBJ=$LLEXOBJ" \
    "GRAMOBJ=$LGRAMOBJ" 
   else
      echo "'$1' is not a valid sccs category"
      echo categories are:
      ls -C $sccsdir
  fi
fi
