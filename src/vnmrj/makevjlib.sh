#!/bin/ksh -p

PRG=`whence java` >/dev/null 2>&1

while [[ -h "$PRG" ]]; do
    ls=`/usr/bin/ls -ld "$PRG"`
    link=`/usr/bin/expr "$ls" : '^.*-> \(.*\)$'`
    if /usr/bin/expr "$link" : '^/' > /dev/null; then
        prg="$link"
    else
        prg="`/usr/bin/dirname $PRG`/$link"
    fi
    PRG=`whence "$prg"` > /dev/null 2>&1
done

jdir=`/usr/bin/dirname $PRG`
jdir2=`/usr/bin/dirname $jdir`
JDK_DIR=$jdir2
# echo $JDK_DIR
export JDK_DIR
make -f makevnmrj libvnmrj.so
