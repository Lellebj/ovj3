#!/bin/sh
# gitcdout 2003-2007 
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

# Default Declarations
#

if [ x$workspacedir = "x" ]
then
   workspacedir=$HOME/vjbuild
fi

gitdir=$workspacedir/git-repo
vnmrdir=$gitdir/../vnmr
optiondir=$gitdir/../options/standard
passwdoptiondir=$gitdir/../options/passworded
rm -rf $workspacedir/cdimageNVJ

if [ x$vjAppName = "x" ]
then
   vjAppName=VnmrJ.app
fi


packagedir=$workspacedir/cdimageNVJ/Package_contents
resdir=$workspacedir/cdimageNVJ/install_resources
mkdir -p $packagedir
mkdir $resdir

cd $gitdir/software/macos
cp -r VnmrJ.app $packagedir/$vjAppName
rm -f VJ
cc -m32 VJ.c -o VJ
mkdir -p $packagedir/$vjAppName/Contents/MacOS
cp VJ $packagedir/$vjAppName/Contents/MacOS/.
rm -f $vnmrdir/bin/convert
cp convert $vnmrdir/bin/.

vjdir=$packagedir/$vjAppName/Contents/Resources/$cdBuildName

mkdir -p $vjdir

preinstall=$resdir/preinstall
printf "#!/bin/sh\n" > $preinstall
printf "rm -rf /Applications/$vjAppName\n" >> $preinstall

postinstall=$resdir/postinstall
printf "#!/bin/sh\n" > $postinstall
printf "rm -rf /vnmr\n" >> $postinstall
printf "ln -s /Applications/$vjAppName/Contents/Resources/$cdBuildName /vnmr\n" >> $postinstall
printf "username=\$(/usr/bin/stat -f%%Su /dev/console)\n" >> $postinstall
printf "echo $%s > /vnmr/adm/users/userlist\n" username >> $postinstall
printf "echo \"vnmr:VNMR group:$%s\" > /vnmr/adm/users/group\n" username >> $postinstall
printf "cd /vnmr/adm/users/profiles/system; sed s/USER/$%s/g < sys_tmplt  > $%s; rm -f sys_tmplt\n" username username >> $postinstall
printf "cd /vnmr/adm/users/profiles/user;   sed s/USER/$%s/g < user_tmplt > $%s; rm -f user_tmplt\n" username username >> $postinstall
printf "chown -h $%s /vnmr\n" username >> $postinstall
printf "chown -R -L $%s /vnmr\n" username >> $postinstall
printf "/vnmr/bin/makeuser $%s y\n" username >> $postinstall
printf "/vnmr/bin/dbsetup root /vnmr \n" >> $postinstall

chmod +x $postinstall

cd $vnmrdir; tar cf - --exclude .gitignore --exclude "._*" . | (cd $vjdir; tar xpf -)
rm -rf $vjdir/vj22c
mkdir -p $vjdir/jre
cd $vjdir/jre
rm -f bin
ln -s /System/Library/Frameworks/JavaVM.framework/Commands bin
cd $workspacedir/git-extra
tar cf - --exclude .gitignore --exclude "._*" help | (cd $vjdir; tar xpf -)

optionslist=`ls $optiondir`
for file in $optionslist
do
   if [ $file != "P11" ]
   then
      cd $optiondir/$file
      tar cf - --exclude .gitignore --exclude "._*" . | (cd $vjdir; tar xpf -)
   fi
done

source $gitdir/scripts/vnmrjOptions
optionslist=`ls $passwdoptiondir`
optiondir=$vjdir/adm/options
mkdir -p $optiondir
for file in $optionslist
do
   getSubjectPassword ${file}
   cd $passwdoptiondir/${file}
   tar cf tmp.tar --exclude .gitignore --exclude "._*" *
   $gitdir/software/bin/encode $Password < ./tmp.tar > $optiondir/${file}.pwd
   rm -f tmp.tar
   printf "${file}.pwd $Subject\n" >> $optiondir/options
done

cd $gitdir/software/macos
rm -f $vjdir/bin/vnmrj
cp vnmrj.sh $vjdir/bin/vnmrj
chmod 755 $vjdir/bin/vnmrj

echo "vnmrs" >> $vjdir/vnmrrev
cd $vjdir/adm/users
cat userDefaults | sed '/^home/c\
home    yes     no      /Users/$accname\
' > userDefaults.bak
rm -f userDefaults
mv userDefaults.bak userDefaults
mkdir profiles/system profiles/user
cp $gitdir/software/macos/sys_tmplt profiles/system/.
cp $gitdir/software/macos/user_tmplt profiles/user/.

