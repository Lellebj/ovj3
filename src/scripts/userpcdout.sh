: '@(#)userpcdout.sh 22.1 03/24/08 1999-2000 '
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

#  userpcdout.sh
#  This script is created for version 6.1C of the Source Code Kit only
#  it contains definitions specific to this release
#  Need to be modified for future releases

sget() {
     sccs -d"$userp_sccsdir"/$1 get $2
}

makeguidirs() {
    if (test ! -d ow_src) then
        mkdir ow_src
        chmod 755 ow_src
    fi
    if (test ! -d motif_src) then
        mkdir motif_src
        chmod 755 motif_src
    fi
}

default_bin=" \
                convertbru.c    \
                cpos_cvt.c      \
                dps_ps_gen.c    \
                expfit.c        \
                fitspec.c       \
                gconfig.c       \
                portrait.c      \
                pulsetool.c     \
                pulsetool.h     \
                pulsetool_sv.c  \
                pulsetool_ow.c  \
                pulsetool_mf.c  \
                pulsechild.c    \
                pulsechild.h    \
                pulsechild_sv.c \
                pulsechild_ow.c \
                pulsechild_mf.c \
                showconsole.c   \
                spins.c         \
                tape.c          \
                interface.h     \
                vconfig.h       \
                vconfig.c       \
                vconfig_console.c       \
                system_panel.h  \
                system_panel.c  \
                rf_panel.h      \
                rf_panel.c      \
                grad_panel.c    \
                grad_panel.h    \
                special_stuff.c \
                basic_stuff.c   \
                vnmr_confirmer.c \
                vnmr_dummy.c"
 
#The vconfig program needs these Acqproc files...
 
acqproc_bin=" \
                console_data.c  \
                console_data.h  \
                config.h        \
                sram.h"
 
#The dps_ps_gen program needs this VNMR file...
 
vnmr_bin=" \
                dpsdef.h"
 
#The vconfig program needs these xracq files...
 
xracq_bin=" \
                SUN_HAL.h"
 
xview_bin=" \
                vconfig_win.h   \
                vconfig_win.c"

xwin_bin=" \
                gconfig_win.c"

default_vnmr=" \
                acqerrmsges.h   \
                acquisition.h   \
                allocate.h      \
                asm.h           \
                data.h          \
                disp.h          \
                dpsdef.h        \
                element.h       \
                errorcodes.h    \
                ftpar.h         \
                graphics.h      \
                group.h         \
                init.h          \
                init2d.h        \
                locksys.h       \
                node.h          \
                params.h        \
                process.h       \
                shims.h         \
                stack.h         \
                symtab.h        \
                tools.h         \
                variables.h     \
                vfilesys.h      \
                vglide.h        \
                vnmrsys.h       \
                whenmask.h      \
                dps_menu.icon   \
                acqfuncs.c      \
                acqhdl.c        \
                acqhwcmd.c      \
                addsub.c        \
                ai.c            \
                allocate.c      \
                asm.c           \
                asmfuncs.c      \
                assign.c        \
                bgvars.c        \
                bootup.c        \
                builtin.c       \
                builtin1.c      \
                buttons.c       \
                data.c          \
                dcon.c          \
                dconi.c         \
                ddf.c           \
                ddif.c          \
                ddph.c          \
                debug.c         \
                df2d.c          \
                dfid.c          \
                dfww.c          \
                dg.c            \
                displayops.c    \
                dll.c           \
                dosyfit.c       \
                dpcon.c         \
                dpf.c           \
                dps.c           \
                ds.c            \
                dscale.c        \
                dsn.c           \
                dsp.c           \
                dsww.c          \
                element.c       \
                emouse.c        \
                exec.c          \
                fiddle.c        \
                files.c         \
                foldj.c         \
                flashc.c        \
                ft.c            \
                ft2d.c          \
                ftinit.c        \
                full.c          \
                gdevsw.c        \
                glide.c         \
                go.c            \
                graphics.c      \
                gzfit.c         \
                handler.c       \
                help.c          \
                history.c       \
                hpa.c           \
                init2d.c        \
                init_display.c  \
                init_proc.c     \
                integ.c         \
                io.c            \
                jexp.c          \
                ll2d.c          \
                lockfreqfunc.c  \
                locksys.c       \
                lookup.c        \
                lstring.c       \
                macro.c         \
                magnetom.c      \
                main.c          \
                master.c        \
                mfdata.c        \
                ops.c           \
                pcmap.c         \
                plot_handlers.c \
                proc2d.c        \
                pvars.c         \
                readlk.c        \
                revdate.c       \
                rtvarcmds.c     \
                savretphf.c     \
                set3dproc.c     \
                shellcmds.c     \
                shims.c         \
                sky.c           \
                smagic.c        \
                specfreq.c      \
                sread.c         \
                swrite.c        \
                symtab.c        \
                table.c         \
                tempstuff.c     \
                terminal.c      \
                text.c          \
                tools.c         \
                variables1.c    \
                vcolor.c        \
                vdialog.c       \
                vfilesys.c      \
                weight.c        \
                wjunk.c         \
                wti.c"

xracq_vnmr=" \
                ACQ_HAL.h       \
                ACQ_SUN.h       \
                STAT_DEFS.h     \
                acodes.h        \
                lc.h"

acqproc_vnmr="ACQPROC_strucs.h"

ncomm_vnmr="mfileObj.h"

psg_vnmr=" \
                REV_NUMS.h      \
                ap_device.p     \
                ap_device.c     \
                common.p        \
                device.c        \
                device.p        \
                freq_device.c   \
                freq_device.p   \
                freqfuncs.c     \
                objerror.c      \
                objerror.h      \
                oopc.h          \
                rfconst.h"

 
gui_vnmr=" \
                banner.c        \
                graphics_win.c  \
                master.icon     \
                master_win.c    \
                ras_dump.c      \
                smagic_win.c    \
                vnmr.icon       \
                vnmr_text.icon"

default_ft3d=" \
                coef3d.h        \
                combine.c       \
                comline.c       \
                command.h       \
                compressfid.c   \
                constant.h      \
                errorlog.c      \
                fileinfo.c      \
                fileio.h        \
                fmap.c          \
                ft3d.c          \
                ft3dio.c        \
                ftutil.c        \
                lock3D.h        \
                lock3Dfiles.c   \
                plextract.c     \
                remoteIPC.c     \
                struct3d.h"

stat_ft3d=" \
                acqinfo.h       \
                acqinfo_xdr.c"

default_tcl="vnmrAppInit.c"

#######################
userp_scripts=" \
                ft3dmake.sh     \
                pmake.sh"

userp_cfile=" \
                quadra.c"

userp_bin=" \
                makeconvertbru  \
                makecpos_cvt    \
                makedps_ps_gen  \
                makeexpfit      \
                makefitspec     \
                makegconfig     \
                makeportrait    \
                makepulsetool   \
                makeshowconsole \
                makespins       \
                maketape        \
                makevconfig"

userp_tcl="makevnmrwish"
 
userp_vnmr="makevnmr"
 
userp_ft3d="make3D"
 
#--------------------------------------
#            MAIN Main main  
#--------------------------------------

case $# in
         0) frozen_src_dir=/
            if [ -d /cdrom/cdrom0/vsccs/sccs ] 
            then
                frozen_src_dir=/cdrom/cdrom0
            fi
            dest_dir=`pwd`/userp000
            ;;

         1) frozen_src_dir=$1
            if [ `echo $frozen_src_dir | awk '{ print substr( $1, 1, 1 ) }'` != "/" ]
            then
                frozen_src_dir=`pwd`/$frozen_src_dir
            fi
            dest_dir=`pwd`/userp000
            ;;

         2) frozen_src_dir=$1
            if [ `echo $frozen_src_dir | awk '{ print substr( $1, 1, 1 ) }'` != "/" ]
            then
                frozen_src_dir=`pwd`/$frozen_src_dir
            fi

            dest_dir=$2
            if [ `echo $dest_dir | awk '{ print substr( $1, 1, 1 ) }'` != "/" ]
            then
                dest_dir=`pwd`/$dest_dir
            fi
            ;;

         *) echo "\nERROR:"
            echo "$0 doesn't support more than 2 arguments\n"
            echo "Usages 1:  $0"
            echo "       2:  $0  frozen_source_dir"
            echo "       3:  $0  frozen_source_dir userp_destination_dir\n"
            exit 1
            ;;
esac

if [ ! -d $frozen_src_dir/vcommon ]
then
    echo "error: $frozen_src_dir doesn't have vcommon"
    exit 1
fi
 
if [ ! -d $frozen_src_dir/vcommon/tcl ]
then
    echo "error: $frozen_src_dir doesn't have vcommon/tcl"
    exit 1
fi

userp_sccsdir=$frozen_src_dir/vsccs/sccs 
magicgramdir=$frozen_src_dir/vobj/sol/proglib/vnmr
 
echo "\nFrozen sources mounted at: $frozen_src_dir" 
echo "Get SCCS sources from: $userp_sccsdir" 
echo "Userp will be placed in: $dest_dir" 

#A normal frozen_src_dir is in a physical CD ( /cdrom/cdrom0 )
#frozen_src_dir=/cdrom/cdrom0

echo "\nAre those above informations correct ?: \c"
read ans
if [ x$ans = "xn" -o x$ans = "xno" -o x$ans = "xN" -o x$ans = "xNO" ]
then
    echo "\nExitting $0 ......\n"
    exit
fi

#Start with a fresh directory
if [ -d $dest_dir ]
then
   echo "\nRemoving  $dest_dir  directory ...."
   rm -rf $dest_dir
fi

echo "\nMaking  $dest_dir  directory ...."
mkdir $dest_dir
mkdir $dest_dir/bin $dest_dir/src 

ostype="SOLARIS IRIX AIX"
for OS in $ostype
do
   mkdir -p $dest_dir/$OS/lib
   cd $dest_dir/$OS/lib
   mkdir 3D tcl tk vnmr
done

#Get src from frozen sccs

echo "\n--- getting SCCS_SRC ---" 
cd $dest_dir/src
mkdir 3D bin tcl tk vnmr

cd bin
makeguidirs

echo "Programs from bin"
for name in $default_bin
do
    echo $name
    sget bin $name
done

echo "Programs for bin from acqproc"
for name in $acqproc_bin
do
    echo $name
    sget acqproc $name
done

echo "Programs for bin from Vnmr"
for name in $vnmr_bin
do
    echo $name
    sget vnmr $name
done

echo "Programs for bin from xracq"
for name in $xracq_bin
do
    echo $name
    sget xracq $name
done
 
#  Note:  The asm icon is common to SunView, OpenLook and Motif,
#         but is stored in SCCS category sunview
 
echo "asm.icon"
sget sunview asm.icon
cp asm.icon ow_src
 
echo "Programs for bin from xview"
cd ow_src
for name in $xview_bin
do
    echo $name
    sget xview $name
done
 
echo "Programs for bin from motif"
cd ../motif_src
for name in $xview_bin
do
    echo $name
    sget motif $name
done

echo "Programs for bin from xwin"
cd ../ow_src
for name in $xwin_bin
do
    echo $name
    sget xwin $name
done

# VNMR programs start here

cd $dest_dir/src/vnmr
makeguidirs

echo "Programs for vnmr"
for name in $default_vnmr
do
    echo $name
    sget vnmr $name
done

echo "Programs for vnmr from xracq"
for name in $xracq_vnmr
do
    echo $name
    sget xracq $name
done

echo "Programs for vnmr from acqproc"
for name in $acqproc_vnmr
do
    echo $name
    sget acqproc $name
done

echo "Programs for vnmr from ncomm"
for name in $ncomm_vnmr
do
    echo $name
    sget ncomm $name
done

echo "Programs for vnmr from psg"
for name in $psg_vnmr
do
    echo $name
    sget psg $name
done
 
#cp $basedir/vobj/sun4/proglib/vnmr/magic.gram.h .
cp $magicgramdir/magic.gram.h .
 
echo "Programs for vnmr from xwin"
cd ow_src
for name in $gui_vnmr $xwin_vnmr
do
    echo $name
    sget xwin $name
done
 
cd $dest_dir/src/3D
echo "Programs for 3D"
for name in $default_ft3d
do
    echo $name
    sget 3D $name
done
 
echo "Programs for 3D from stat"
for name in $stat_ft3d
do
    echo $name
    sget stat $name
done
 
cd $dest_dir/src/tcl
echo "Programs for TCL"
for name in $default_tcl
do
    echo $name
    sget tcl $name
done
 
echo "Files for User Programming tape complete"
echo "   end SCCS_SRC ---\n" 

  
echo "--- getting USERP ---"
echo "Getting userp contributions to the  Source Code Tape for combined"
echo "Solaris/IBM/SGI support with OpenLook and Motif GUI programs included"

echo "Scripts from userp"

cd $dest_dir/bin
for name in $userp_scripts
do
    echo $name
    sget userp $name
    pname=`basename $name .sh`
    make $pname
    rm -f $name
done
 
echo "Cfiles from userp"
cd $dest_dir/src
for name in $userp_cfile
do
    echo $name
    sget userp $name
done

echo "Scripts from userp"
cd $dest_dir/src/bin
for name in $userp_bin
do
    echo $name
    sget userp $name
done
 
echo "Programs for TCL from userp"
cd $dest_dir/src/tcl
for name in $userp_tcl
do
    echo $name
    sget userp $name
done

cd $dest_dir/src/vnmr
echo "Programs for vnmr from userp"
for name in $userp_vnmr
do
    echo $name
    sget userp $name
done

cd $dest_dir/src/3D
echo "Programs for 3D from userp"
for name in $userp_ft3d
do
    echo $name
    sget userp $name
done

echo "Files for User Programming tape complete"
echo "   end USERP ---\n"
 
echo "--- getting OBJ ---"
arch_list="sol ibm sgi"
os_list="SOLARIS:AIX:IRIX"
cnt=1

for arch in $arch_list
do
    echo "   Copying $arch static libraries"
    os=`echo $os_list | cut -d: -f$cnt`
    obj_dir=$frozen_src_dir/vobj/$arch
    obj_dest_dir=$dest_dir/$os

    if [ ! -d $obj_dir/proglib ]
    then
         echo "error: $obj_dir doesn't have proglib"
         exit 1
    fi
    if [ ! -d $obj_dir/proglib/3D ]
    then
         echo "error: $obj_dir doesn't have proglib/3D"
         exit 1
    fi
    if [ ! -d $obj_dir/proglib/vnmr ]
    then
         echo "error: $obj_dir doesn't have proglib/vnmr"
         exit 1
    fi

  
    #use the tar program because some libraries are actually symbolic links
    #to other libraries.
  
    cd $obj_dest_dir/lib
    (cd $obj_dir/proglib; tar cf - 3D/unmr3Dl*.a vnmr/unmrl*.a vnmr/magicl*.a) | tar xvpf -
  
    #eliminate alternate names for the libraries.
    #leave just magiclib.a and unmrlib.a in the VNMR library subdirectory
  
    cd vnmr
    for libname in magiclib unmrlib
    do
        #use expr to eliminate the leading white-space characters
        #in the output from wc
  
        count=`ls -1 ${libname}* | wc -l`
        count=`expr $count`
  
        #keep going, regardless of any errors encountered
     
        echo "count= $count"  
        case $count in
            0)
                echo "error: no libraries named $libname in $PWD"
                ;;
  
            1)
                filename=`echo ${libname}*`
                if [ $filename != ${libname}.a ]
                then
                    mv $filename ${libname}.a
                fi
                ;;
  
            2)
                if [ -h ${libname}.a ]
                then
                    rm ${libname}.a
                    mv ${libname}* ${libname}.a
                elif [ -f ${libname}.a ]
                then
                    rm ${libname}?*.a
                else
                    echo "error: no library named $libname in $PWD"
                fi
                ;;
  
            *)
                echo "Too many libraries named $libname in $PWD"
                ;;
        esac
    done
    cnt=`expr $cnt + 1`
done
echo "   end OBJ ---\n"


echo "--- getting TCL ---"

#TK/TCL include files
cd $dest_dir/src/tk
rm -f *.h license.terms
cp $frozen_src_dir/vcommon/tcl/srcTk/*.h .
cp $frozen_src_dir/vcommon/tcl/tklibrary/license.terms license.terms

cd $dest_dir/src/tcl
rm -f *.h license.terms
cp $frozen_src_dir/vcommon/tcl/srcTcl/*.h .
cp $frozen_src_dir/vcommon/tcl/tcllibrary/license.terms license.terms

suffix=""
tclver="8.3"
tkver="8.3"

#  Solaris library has version, no suffix
#  AIX, IRIX have no version, suffix

for OS in $ostype
do
        case $OS in
           "SOLARIS" )  suffix=""
                        tclver="8.3"
                        tkver="8.3"
                        exten=".so"
                        ;;

              "IRIX" )  suffix="_SGI"
                        tclver=""
                        tkver=""
                        exten=".a"
                        ;;

               "IBM" )  suffix="_IBM"
                        tclver=""
                        tkver=""
                        exten=".a"
                        ;;

                   * )  echo ""
                        ;;
        esac
 
        echo "    OS= $OS"
        echo $frozen_src_dir/vcommon/tcl/srcTk/libtk${tkver}${suffix}${exten}
        echo $frozen_src_dir/vcommon/tcl/srcTcl/libtcl${tclver}${suffix}${exten}

        cd $dest_dir/$OS/lib/tk
        cp $frozen_src_dir/vcommon/tcl/srcTk/libtk${tkver}${suffix}${exten} .

        cd $dest_dir/$OS/lib/tcl
        cp $frozen_src_dir/vcommon/tcl/srcTcl/libtcl${tclver}${suffix}${exten} .
done
echo "   end TCL ---\n"
 

if [ -r /vcommon/src_code.pdf ]
then
    cp /vcommon/src_code.pdf $dest_dir
    echo ".pdf manual copied from /vcommon"
else

    echo "Enter location of on-line manual for the Source Code Kit: \c"
    read userp_online_man
    if [ x$userp_online_man != "x" ]
    then
        if [ `echo $userp_online_man | awk '{ print substr( $dest_dir, 1, 1 ) }'` != "/" ]
        then
            userp_online_man=`pwd`/$userp_online_man
        fi
        cp $userp_online_man/src_code.pdf $dest_dir
        echo ".pdf manual copied from $userp_online_man"
    else
        echo "Caution:  No on-line manual for the version 6.1 Source Code Kit !!"
    fi
fi
touch SourceCodeKit_6.1C

echo "\n          >>>>>>>>>>>> D O N E <<<<<<<<<<<\n"
