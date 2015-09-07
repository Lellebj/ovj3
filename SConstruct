import os
import sys
import string
import subprocess

platform = sys.platform        # sys.platform -> 'linux2' linux, 'interix6' win7 SUA
print "Platform: ", platform


#
# top level build file
#

# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
# WHEN ADDING NEW FILES TO THIS BUILD, BE SURE YOU TEST
# THE BUILD BY INVOKING:
#
#   scons -c && scons -j3
#
# All builds MUST be thread-safe so that parallel builds
# function properly.  Parallel building is a simple way
# to cut down on compilation time.
#
# "-j3" tells scons to run 3 build threads.  A good rule
# of thumb for choosing the -j option is to count the
# the number of CPU cores and add 1.  Remember you must
# be running and SMP kernel to take advantage of multi-
# core CPUs.
# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

SetOption('warn', ['no-duplicate-environment'] + GetOption('warn'))

# we need to specify an absolute path so this SConstruct file
# can be called from any other SConstruct file
cwd = os.getcwd()

# Needed for rpath used in some SConstructs
if not os.path.exists(os.path.join(os.pardir, 'lib')):
   Execute('cd ..;ln -s git-repo/src/ncomm lib')

# non-java builds
buildList = string.split("""
                         3D
                         app-defaults
                         autotest
                         acq
                         adm
                         bin
                         BIR
                         biopack
                         biosolidspack
                         dicom_djsm
                         dicom_store
                         Diffusion
                         DOSY
                         execpars
                         fidlib
                         fiddle
                         fonts
                         Gxyz_i
                         Gmap
                         Gilson
                         IMAGE
                         IMAGE_patent
                         lcpeaks
                         LCNMR
                         license
                         Pbox
                         personalib
                         pipe
                         proshimmethods
                         psglib
                         probes
                         PFG
                         ncomm
                         nuctables
                         maclib
                         manual
                         menujlib
                         misc 
                         modules 
                         mollib
                         msg
                         nvpsg
                         protune
                         roboproc
                         satellites
                         scripts
                         shapelib
                         shuffler
                         shims
                         shimmethods
                         solidspack
                         stars
                         studylib
                         sudo.lnx
                         tablib
                         templates
                         upar
                         user_templates
                         veripulse
                         vnmrbg
                         vnmrbg_iconlib
                         xml
                         xmllayout
                         xrecon
                         """);

buildList = string.split("""
                         3D
                         ncomm
                         nvpsg
                         roboproc
                         vnmrbg
                         """);

acqBuildList = string.split("""
                         768AS
                         ampfit
                         aslmirtime
                         atproc
                         backproj
                         bootpd.rh51
                         cgl
                         craft
                         Cryo2
                         CSI2
                         ddl
                         dicom
                         expproc
                         fdm
                         FDM2
                         ib
                         inova
                         infoproc
                         kermit
                         kpsg
                         kpsglib
                         mercury
                         nautoproc
                         nvacq
                         nvacqkernel
                         nvexpproc
                         nvinfoproc 
                         nvdsp
                         nvrecvproc
                         nvsendproc
                         procproc
                         psg
                         masproc
                         recvproc
                         sendproc
                         servicetools
                         stat
                         tcl
                         web
                         """);

acqBuildList = string.split("""
                         atproc
                         ddl
                         expproc
                         infoproc
                         kpsg
                         nautoproc
                         nvexpproc
                         nvinfoproc 
                         nvrecvproc
                         nvsendproc
                         procproc
                         psg
                         masproc
                         recvproc
                         sendproc
                         stat
                         """);


# N.B. probeid was being built by apt, and vjclient by probeid.
#      SCons shortcomings have forced the use of hardlinks.
#
javaBuildList = string.split("""
                             admin
                             jplot
                             managedb
                             vjmol
                             vnmrj
                             """);

winJavaBuildList = string.split("""
                             admin
                             jplot
                             vnmrj
                             """);

javaAcqBuildList = string.split("""
                             apt
                             cryo
			     cryomon
                             hermes
                             jaccount
                             probeid
                             """);

# not used but listed here for reference
ndds3xTargetList = string.split("""
                                nvacq 
                                nvdsp
                                nvexpproc
                                nvinfoproc 
                                nvflash
                                nvrecvproc
                                nvsendproc
                                nvacqkernel
                                """);

# no longer need now these use the boEnv parameter NDDS_VERSION
# to build 3x,4.1e or 4.2d
#ndds4xTargetList = string.split("""
#                                nvexpproc
#                                nvinfoproc 
#                                nvrecvproc
#                                nvsendproc
#                                nvacqkernel
#                                nvdsp
#                                """);

#                         nvdsp


ndds3xSpecial = string.split("""
                             nvflash
                             """);

# special in the since that at present 
# 3x uses the SConstruct file and 4x uses SConstruct4x file
ndds4xSpecial = string.split("""
                             nvflash
                             """);
#                             nvacq

thirdPartyList = string.split("""
                              JavaPackages
                              """);

# print "Update versions file's keyword __GITDESCRIBE__ if present"
#  copy Version to the versions file so if it has the __GITDESCRBE__ key it
#  will be replaced. For releases, the File <git-repo>/scripts/ReleaseVersion 
#  is copied to <git-repo>/Version and it does not have the __GITDESCRIBE__
#  in it. This next step then copies Version to versions.
# command = 'cp ../Version ../versions; cd ../scripts; ./updateVersions.sh'
# idproc = subprocess.Popen( command, shell=True)
# status = os.waitpid(idproc.pid, 0)

# this must come last, since it creates sha1sum for all files

# if ( 'interix' in platform):
#   SConscript(os.path.join(cwd, os.pardir, '3rdParty', 'jogl_libs','SConstruct'))

for i in buildList:
   SConscript(os.path.join('src',i, 'SConstruct'))

# if ( 'interix' in platform):
#   for i in winJavaBuildList:
#      SConscript(os.path.join(i, 'SConstruct'))
#      
# else:
# 
#   for i in javaBuildList:
#      SConscript(os.path.join(i, 'SConstruct'))

if ( ( 'darwin' not in platform) and ( 'interix' not in platform) ):
   for i in acqBuildList:
      SConscript(os.path.join('src',i, 'SConstruct'))

#    for i in javaAcqBuildList:
#       SConscript(os.path.join(i, 'SConstruct'))

#    for i in ndds3xSpecial:
#       SConscript(os.path.join(i, 'SConstruct'))

#   for i in ndds4xTargetList:
#      SConscript(os.path.join(i, 'SConstruct'))

#    for i in ndds4xSpecial:
#       SConscript(os.path.join(i, 'SConstruct4x'))

#   for i in thirdPartyList:
#      SConscript(os.path.join(cwd, os.pardir, '3rdParty', i, 'SConstruct'))

# this one is separate
# if ( 'darwin' not in platform):
#    SConscript(os.path.join(cwd, os.pardir, '3rdParty', 'SConstruct'))

# end of if platform group

# for i in thirdPartyList:
#    SConscript(os.path.join(cwd, os.pardir, '3rdParty', i, 'SConstruct'))

# this one is separate
# SConscript(os.path.join(cwd, os.pardir, '3rdParty', 'SConstruct'))

# define  absolute  path  for  acqqueue  and  tmp  directory
vnmracqueuPath    = os.path.join(cwd, os.pardir, os.pardir,'vnmr','acqqueue')
vnmrtmpPath       = os.path.join(cwd, os.pardir, os.pardir,'vnmr','tmp')

# make sure the path(s) exist
if not os.path.exists(vnmracqueuPath):
   os.makedirs(vnmracqueuPath)
if not os.path.exists(vnmrtmpPath):
   os.makedirs(vnmrtmpPath)
os.chmod(vnmracqueuPath,0777)
os.chmod(vnmrtmpPath,0777)

vnmrPath    = os.path.join(cwd, os.pardir,'vnmr')
cmd='cd common; zip -ryq tmp.zip *; mv tmp.zip '+vnmrPath+';cd '+vnmrPath+'; unzip -oq tmp.zip; rm -f tmp.zip'
print "cmd: ",cmd
os.system(cmd)

dirList = os.listdir(vnmrPath)
for i in dirList:
   sconsFile = os.path.join(vnmrPath,i,'sconsPostAction')
   if os.path.exists(sconsFile):
      cmd='cd '+os.path.join(vnmrPath,i)+';chmod +x sconsPostAction; ./sconsPostAction; rm sconsPostAction'
      print "cmd: ",cmd
      os.system(cmd)

# os.system('cd ..;rm -f lib')
