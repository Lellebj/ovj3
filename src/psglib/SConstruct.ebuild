import os
import glob
import shutil

#import variables  and environment from SConstruct
Import("*")

# we need to specify an absolute path so this SConstruct file
# can be called from any other SConstruct file
cwd = os.getcwd()

# get options settings
boFile=os.path.join(cwd,os.pardir,os.pardir,os.pardir,'buildoptions.py')
if not os.path.exists(boFile):
   boFile=os.path.join(cwd,os.pardir,os.pardir,os.pardir,'scripts','buildoptions.py')
execfile(boFile)



# define target file names
PsTargetList = glob.glob("*.c")
PsTargetList.sort()

#for sure copy it to options/standard/biopack
seqlibPath = os.path.join(cwd,os.pardir,os.pardir,'etest','seqlib')
Execute('rm -rf ' + seqlibPath)
os.makedirs(seqlibPath)

# actual builds

for file in PsTargetList:
        i,ext = os.path.splitext(file)
        nvseqLibEnv.DpsPsGen(target  =   i+'dps.c',
                             source  =   i+'.c')

        bObj = nvseqLibEnv.Program(target     =  i,
                            source     =  i+'dps.c', 
                            LIBPATH    =  [nvpsgPath,
                                           ncommPath],
                            LIBS       =  ['psglib','param', 'acqcomm', 'm'])
        nvseqLibEnv.AddPostAction(bObj,Action(Copy(os.path.join(seqlibPath,i), os.path.join(cwd,i) )))
