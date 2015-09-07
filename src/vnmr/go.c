
#define _FILE_OFFSET_BITS 64

#include "vnmrsys.h"
#include <unistd.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <ctype.h>

#include <sys/types.h>
#include <sys/stat.h>

#include <sys/statvfs.h>
#include <sys/file.h>
#include <time.h>
#include <sys/time.h>
#include <signal.h>
#include <errno.h>
#include <setjmp.h>

/* #ifdef JPSG */
/* for socket jpsg ?? */
#include <sys/socket.h>
#include "sockets.h"
/* #endif */

#include "data.h"
#include "CSfuncs.h"
#include "group.h"
#include "params.h"
#include "bgvars.h"
#include "symtab.h"
#include "tools.h"
#include "variables.h"
#include "REV_NUMS.h"
#include "locksys.h"
#include "STAT_DEFS.h"
#include "acquisition.h"
#include "whenmask.h"
#include "vfilesys.h"
#include "pvars.h"
#include "wjunk.h"
#include "sockinfo.h"
#include "allocate.h"

#ifdef CLOCKTIME
extern int go_timer_no;
#endif 



/*-------------------------------------------------------------------
|    GO:
| 
|   Purpose:
|  	This module reads in the user defined and set paramenters
| 	along with the selected Pulse sequence to create the
| 	command codes for the acquisition computer.
| 
|   Routines:
| 	getsysp - obtain the system configuration parameters and
| 		  set the system global flags accordingly.
| 	main  -  GO main function.
|	Author   Greg Brissey	4/25/86
|
|   Modified   Author     Purpose
|   --------   ------     -------
|   5/08/89    Greg B.     1. ra checks for ra lkfile 'acq_stopped' if not 
|			      present, ra not permitted.
|			      ra lkfile is removed for any alaises of go
|
+-------------------------------------------------------------------*/

#define CALLNAME 0
#define ARG1 1
#define EXEC_GO 0
#define EXEC_SU 1
#define EXEC_SHIM 2
#define EXEC_LOCK 3
#define EXEC_SPIN 4
#define EXEC_CHANGE 5
#define EXEC_SAMPLE 6
#define EXEC_EXPTIME 101
#define EXEC_DPS 102
#define EXEC_CHECK 103
#define EXEC_CREATEPARAMS 104
#define OK 0
#define FALSE 0
#define TRUE 1
#define ERROR 1
#define NOTFOUND -1
#define NOTREE -1
#define MAXARYS 256
#define BUFSIZE 1024
#define MAXSIZEFUDGE 256.0	/* kbytes */
#define KBYTE 1024		/* bytes per kbyte */
#define MBYTE 1048576		/* bytes per MB */
#define GBYTE 1073741824	/* bytes per GB */
#define MAXFIDSIZEFUDGE_MB (256.0/1048576.0) 	/* in MB */
#define MAXnD 4

#define USE_PSG 100
#define USE_JPSG 200

extern int mode_of_vnmr;
extern int   VnmrJViewId;
extern int   jParent;
extern void     setSilentMode(int);
extern int      is_datastation();
extern int      macroLoad(char *name, char *filepath);
extern void     purgeOneMacro(char *n);
extern int      calledFromWerr();
extern char     psgaddr[];
extern pid_t    HostPid;
#ifdef VNMRJ
extern void stop_nvlocki();
extern int  nvAcquisition();
#endif
extern int getparm(char *varname, char *vartype, int tree,
                   void *varaddr, int size);
extern int setparm(char *varname, char *vartype, int tree,
                   void *varaddr, int index);
extern int var_active(char *varname, int tree);
extern void disp_acq(char *t);
extern void currentDate(char *cstr, int len );
extern char *currentDateLocal(char *cstr, int len );
extern char *currentDateSvf(char *cstr, int len );
extern void Wturnoff_buttons();
extern int numActiveRcvrs(char *rcvrstring);
extern int read_acqi_pars();
extern int stop_acqi( int abortall );
extern int setfr(int argc, char *argv[], int retc, char *retv[]);
extern void saveGlobalPars(int sv, char *suff);
extern int WgraphicsdisplayValid(char *n);
extern int release_console();
extern int set_wait_child(int pid);
extern void set_effective_user();
extern int GetAcqStatus(int to_index, int from_index, char *host, char *user);
extern int getAcqStatusInt(int index, int *val);
extern int getAcqStatusStr(int index, char *val, int maxlen);
extern int getAcqConsoleID();
extern int expdir_to_expnum(char *expdir);
extern int is_data_present(int this_expnum );
extern int p11_saveFDAfiles_raw(char* func, char* orig, char* dest);
extern int setfrq(int argc, char *argv[], int retc, char *retv[]);
extern int verify_fnameChar(char tchar);
extern int check_ShimPowerPars();

extern int psg_pid;

/* --- child process variables */
static int child;
static int pipe1[2];
static int pipe2[2];

static char  arrayname[MAXSTR];/* array variable name at present 'array' */
static char  autodir[MAXPATH]; /* path to automation directory */
static char  callname[MAXSTR]; /* command name alias */

static double priority;   /* experiment priority */
static double  arraydim;  /* The calc # of fids obtain from the arrayed var */
static double  acqcycles;  /* Number of acode sets */
static double  arrayelemts; /* The calc # of array elements */

static int   automode;    /* 1 if system is in auto sample mode */
static int   vpmode;      /* 1 if system is in viewport mode */
static int   suflag;	  /* setup flag,0=GO,1-6=different alias's of GO */
static int   noGainTest = 0;
static int   d2Array, d3Array, d4Array, d5Array;

//  Optional params to go into accounting log file
typedef struct  {
     char name[64];
     char tree[32];
} _optpars;

static _optpars optParams[64];

static int optParamsFilled=FALSE;

#ifdef  DEBUG
extern int   Eflag,Gflag;
#define EPRINT(arg1, arg2, arg3) \
	if (Eflag) Wtimeprintf(arg1,arg2,arg3)
#define GPRINT(level, str) \
	if (Gflag >= level) Wscrprintf(str)
#define GPRINT1(level, str, arg1) \
	if (Gflag >= level) Wscrprintf(str,arg1)
#define GPRINT2(level, str, arg1, arg2) \
	if (Gflag >= level) Wscrprintf(str,arg1,arg2)
#define GPRINT3(level, str, arg1, arg2, arg3) \
	if (Gflag >= level) Wscrprintf(str,arg1,arg2,arg3)
#define GPRINT4(level, str, arg1, arg2, arg3, arg4) \
	if (Gflag >= level) Wscrprintf(str,arg1,arg2,arg3,arg4)
static int Wtimeprintf(int mode, char *control, char *time);
#else 
#define EPRINT(arg1, arg2, arg3)
#define GPRINT(level, str) 
#define GPRINT1(level, str, arg2) 
#define GPRINT2(level, str, arg1, arg2) 
#define GPRINT3(level, str, arg1, arg2, arg3) 
#define GPRINT4(level, str, arg1, arg2, arg3, arg4) 
#endif 

/* Function prototypes */

static int argtest(int, char * [], char *);
static int check_acqpar();
static int check_loc();
static int check_ra();
static int check_np_ra();
static int check_dp_ra();
static int get_number_new_fids(int);
static int validcall(int, char * [], int *, int);
static int testarrayparm(char *, char * [], int *);
static int checkparm(char *, char *, char * [], int *);
static int equalsize(char *, char *);
static int findname(char *, char * [], int);
static int removename(int, char * [], int *);
static int A_getarynames(int, char **, int *, int); 
static int getNames(symbol *, char **, int *, int , int *); 
static int dateStr(char *, char *, char **, int *);
static void getStr(char *, FILE *, char **, int *);
static void replaceSpace(char *);
static int fireUpJPSG(void);
void getVnmrInfo(int okToSet, int okToSetSpin, int overRideSpin);
void cleanup_pars();
static void runPsgPutCmd(int debugPutCmd);
int arraytests();
int initacqqueue(int argc, char *argv[]);
int makeautoname(char *cmdname, char *a_name, char *sif_name, char *dirname,
                 int createflag, int replaceSpaceFlag,
                 char *suffix, char *notsuffix);
int isJpsgReady();


void skipGainTest()
{
  noGainTest = 1;
}

double get_acq_dim() /* could run getdim macro */
{
    double rval, dval;

    if (P_getreal(CURRENT,"nD",&dval,1) == 0)
    {
      if (dval > 0.5)
        return( dval );
    }
    rval = 1.0;
    if (P_getreal(CURRENT,"ni",&dval,1) == 0)
    {
      if (dval > 1.5)
        rval++;
    }
    if (P_getreal(CURRENT,"ni2",&dval,1) == 0)
    {
      if (dval > 1.5)
        rval++;
    }
    if (P_getreal(CURRENT,"ni3",&dval,1) == 0)
    {
      if (dval > 1.5)
        rval++;
    }
    return( (double)((int)(rval+0.5)) );
}

void set_vnmrj_acq_params()
{
    char     ptmp[MAXPATH], mstr[256];
    int      ict;
    double   adim;

    ict = 0;
    strcpy(mstr,"   ");
    currentDate(ptmp, MAXPATH);
    if (P_setstring(CURRENT,"time_submitted",ptmp,1))
    {
      P_creatvar(CURRENT,"time_submitted",T_STRING);
      P_setstring(CURRENT,"time_submitted",ptmp,1);
    }
    strcat(mstr,"time_submitted ");
    ict++;
    if (P_setstring(CURRENT,"time_run",ptmp,1))
    {
      P_creatvar(CURRENT,"time_run",T_STRING);
      P_setstring(CURRENT,"time_run",ptmp,1);
    }
    strcat(mstr,"time_run ");
    ict++;
    if (P_setstring(CURRENT,"time_complete",ptmp,1))
    {
      P_creatvar(CURRENT,"time_complete",T_STRING);
      P_setgroup(CURRENT,"time_complete",G_DISPLAY);
      P_setstring(CURRENT,"time_complete",ptmp,1);
    }
    strcat(mstr,"time_complete ");
    ict++;
    currentDateLocal(ptmp, MAXPATH);
    if (P_setstring(CURRENT,"time_submitted_local",ptmp,1))
    {
      P_creatvar(CURRENT,"time_submitted_local",T_STRING);
      P_setstring(CURRENT,"time_submitted_local",ptmp,1);
    }
    strcat(mstr,"time_submitted_local ");
    ict++;
    currentDateSvf(ptmp, MAXPATH);
    if (P_setstring(CURRENT,"time_svfdate",ptmp,1))
    {
      P_creatvar(CURRENT,"time_svfdate",T_STRING);
      P_setstring(CURRENT,"time_svfdate",ptmp,1);
    }
    strcat(mstr,"time_svfdate ");
    ict++;
    if ( ! P_setstring(CURRENT,"time_processed","",1))
    {
      strcat(mstr,"time_processed ");
      ict++;
    }
    if ( ! P_setstring(CURRENT,"time_plotted","",1))
    {
      strcat(mstr,"time_plotted ");
      ict++;
    }
    if ( ! P_setstring(CURRENT,"time_saved","",1))
    {
      strcat(mstr,"time_saved ");
      ict++;
    }
    adim = get_acq_dim();
    P_setreal(CURRENT, "acqdim", adim, 1);
    if (P_setreal(CURRENT,"acqdim", adim, 1))
    {
      P_creatvar(CURRENT,"acqdim",ST_INTEGER);
      P_setreal(CURRENT, "acqdim", adim, 1);
    }
    strcat(mstr,"acqdim ");
    ict++;
    if (P_setreal(CURRENT,"procdim", 0.0, 1))
    {
      P_creatvar(CURRENT,"procdim",ST_INTEGER);
      P_setreal(CURRENT, "procdim", 0.0, 1);
    }
    P_setgroup(CURRENT,"procdim",G_PROCESSING);
    strcat(mstr,"procdim ");
    ict++;
    if (P_setstring(CURRENT,"proccmd","",1))
    {
       P_creatvar(CURRENT,"proccmd",T_STRING);
       P_setgroup(CURRENT,"proccmd", G_PROCESSING);
       P_setstring(CURRENT,"proccmd","",1);
       P_setprot(CURRENT,"proccmd",P_ARR | P_ACT | P_VAL);  /* do not allow any user change */
    }
    strcat(mstr,"proccmd ");
    ict++;
#ifdef VNMRJ
    if (ict > 0)
    {
      char nstr[6];
      size_t i;
      sprintf(nstr,"%d",ict);
      for (i=0; i<strlen(nstr); i++)
        mstr[i] = nstr[i];
      writelineToVnmrJ("pnew", mstr);
    }
#endif 
}


/*  For some reason the delivery of a SIGCHLD signal during a certain
    section of the GO program caused the pulse sequence program (PSG)
    to core dump or otherwise behave unacceptably.  So the SIGCHLD
    signal is blocked for a bit by calling block_sigchld.  Once this
    section completes, the original mask of signals is restored by
    calling restore_sigchld.  September 1994				*/

static sigset_t origset;

static void
block_sigchld()
{
	sigset_t	nochld;

	sigemptyset( &nochld );
	sigaddset( &nochld, SIGCHLD );
	sigprocmask( SIG_BLOCK, &nochld, &origset );
}

static void
restore_sigchld()
{
	sigprocmask( SIG_SETMASK, &origset, NULL );
}


/*  If the pulse sequence program (PSG) fails to start (the classic
    reason was a failure to find shared libraries) or failed to read
    its input pipe, the parent process, VNMR, received a SIGPIPE when
    it tried to write to its side of the pipe.  If not caught, the
    process receiving the SIGPIPE is terminated with extreme prejudice.
    So we arrange to catch SIGPIPE before we begin writing to the write
    side of the VNMR - PSG pipe.  If SIGPIPE is delivered, the signal
    handler calls longjmp which redirects control as if the associated
    setjmp returned - except this time it returns -1.  The call to
    setjmp is programmed to expect this abnormal return and skip the
    section where data is written to PSG.				*/

static jmp_buf		brokenpipe;
static struct sigaction	origpipe;

static void
sigpipe()
{
	longjmp( brokenpipe, -1 );
}

static void
catch_sigpipe()
{
	sigset_t		qmask;
	struct sigaction	newpipe;

	sigemptyset( &qmask );
	sigaddset( &qmask, SIGPIPE );
	newpipe.sa_handler = sigpipe;
	newpipe.sa_mask = qmask;
	newpipe.sa_flags = 0;
	sigaction( SIGPIPE, &newpipe, &origpipe );
}

static void
restore_sigpipe()
{
	sigaction( SIGPIPE, &origpipe, NULL );
}

int 
protectedRead(int fd)
{
   sigset_t    blockmask, savemask;
   int   ready;

   sigemptyset( &blockmask );
   sigaddset( &blockmask, SIGALRM );
   sigprocmask( SIG_BLOCK, &blockmask, &savemask );
   read(fd,&ready,sizeof(int));
   sigprocmask( SIG_SETMASK, &savemask, NULL );
   return(ready);
}

/*  End of new routines added September 1994	*/


void clearExpDir(const char *curexpdir)
{
   char cmd[3*MAXPATH+16];
   D_remove(D_PHASFILE);
   D_remove(D_DATAFILE);
   sprintf(cmd,"rm -rf %s/recon %s/datadir3d %s/shapelib",curexpdir,curexpdir,curexpdir);
   system(cmd);
}

/*------------------------------------------------------------------------------
|
|       maxminlimit(tree,name)
|
|       This function returns the max & min limit of the real variable based
|                               Author: Greg Brissey  8-18-95
+----------------------------------------------------------------------------*/
int par_maxminstep(int tree, char *name,
                   double *maxv, double *minv, double *stepv)
{
   int             ret,pindex;
   vInfo           varinfo;     /* variable information structure */
 
   if ( (ret = P_getVarInfo(tree, name, &varinfo)) )
   {
      Werrprintf("Cannot find the variable: %s", name);
      return (ERROR);
   }
   if (varinfo.basicType != ST_REAL)
   {
      Werrprintf("The variable '%s' is not a type 'REAL'", name);
      return(ERROR);
   }
   if (varinfo.prot & P_MMS)
   {
      pindex = (int) (varinfo.minVal+0.1);
      if (P_getreal( SYSTEMGLOBAL, "parmin", minv, pindex ))
         *minv = -1.0e+30;
      pindex = (int) (varinfo.maxVal+0.1);
      if (P_getreal( SYSTEMGLOBAL, "parmax", maxv, pindex ))
         *maxv = 1.0e+30;
      pindex = (int) (varinfo.step+0.1);
      if (P_getreal( SYSTEMGLOBAL, "parstep", stepv, pindex ))
            *stepv = 0.0;
   }
   else
   {   
       *maxv = varinfo.maxVal;
       *minv = varinfo.minVal;
       *stepv = varinfo.step;
   }
   return (0);
}

static int processPort = 0;
static int processPid = 0;

static int checkVpMode(char *label)
{
   double tmp;
   int numVP;
   char tmpStr[MAXPATH];

   if ( P_getreal(GLOBAL, "jviewports", &tmp, 1) >= 0 )
   {
      numVP = (int) (tmp+0.1);
      if ( P_getstring(GLOBAL, "testacquire", tmpStr, 1, MAXPATH) >= 0 )
      {
         if ( (tmpStr[0] == 'y') || (tmpStr[0] == 'Y') )
            numVP = 1;
      }
      if (numVP > 1)
      {
         int i;
         for (i=1; i <= numVP; i++)
         {
            if (i != VnmrJViewId)
            {
               P_getstring(GLOBAL, "jviewportlabel", tmpStr, i, MAXPATH);
               if ( strstr(tmpStr,"Current") || strstr(tmpStr,"current") )
               {
                  char path[MAXPATH];
                  int fd;

                  sprintf(path,"%s/persistence/.vp_%d_%d", userdir, jParent, i);
                  if ( (fd = open(path, O_RDONLY)) != -1)
                  {
                     read(fd, &processPort, sizeof(processPort));
                     read(fd, &processPid, sizeof(processPid));
                     close(fd);
                     if (label)
                        strcpy(label,tmpStr);
                     return(1);
                  }
                  return(0);
               }
            }
         }
      }
   }
   return(0);
}

static char *vpAddr(char *addr)
{
   sprintf(addr,"%s %d %d", HostName, processPort, processPid);
   return(addr);
}

/* statics added for JPSG incorperation    12/11/98 */

    /* --- child and pipe variables --- */
static    char pipe1_0[16];
static    char pipe1_1[16];
static    char pipe2_0[16];
static    char pipe2_1[16];
static    int   psg_busted;  /* added September 1994 */

int acq(int argc, char *argv[], int retc, char *retv[])
{
    int TypeOfPS;	/* JPSG or PSG type sequence */
    char    dirname[MAXPATH];
    char    dirpath[MAXPATH];  /* path to fid directory */
    char    exppath[MAXPATH];  /* temporary path parameter */
    char    goid[MAXPATHL];   /* unique ID of this GO (username.######) */
    char    method[MAXPATHL];
    char    methodpath[MAXPATH];
    char    psgpath[MAXPATH];  /* path to seqfil */
    char    tmpStr[MAXPATH];
    char    rcvrs[MAXPATHL];
    char    a_name_option[MAXPATH]; /* Optional autoname provided as argument */
    char    *tagname;
    int     calcdimflag;
    int     restartflag;
    int     overridespinflag;
    int     acqi_fid;
    int     checkSpinCad;
    int     silent_mode;
    int     datastation;
    int     this_is_ra;		/* flag to distinguish `ra' from other aliases */
    int     waitflag = 0;
    int     i,setspin;
    int     sparse;
    double  ni;
    double  ni2;
    double  ni3;
    double  c_val;
    double  saveArraydim;
    double  saveAcqCycles;

    int   ret;
    int   psg_return_val=0;

    strcpy(arrayname,"array");	/* incase array parameter changes name */
    calcdimflag = argtest(argc,argv,"calcdim");

    if (!validcall(argc,argv,&datastation,!calcdimflag))
    {
       noGainTest = 0;
       goto abortAcq;
    }
    arraydim = 1.0;	/* initialize number of fids */
    acqcycles = 1.0;	/* number of acode sets */
    arrayelemts = 0.0;	/* initialize number of array elements */
    saveArraydim = saveAcqCycles = 1.0;
    tagname = "";

    /*--------------------------------------------------------------
    |	test for proper usage of arrayed variables and variable 'array'
    |	autogaining (gain='n') cannot be used in multifid experiments
    |			(i.e., gain='n', with other arrayed parameters)
    |	test for improper interleaving (il='y') (no-no with arrayed parameters,
    |		tpc,pad,spin,nt  experiments)
    |		acqqueuei#:=ior(16*priority, acqqueuei#);
    |		if ilv[1]='y' then acqqueuei#:=ior(1,acqqueuei#); 
    |   arraydim is calculated for the arrayed parameters in array.
    |   arrayelement number is calculated for the arrayed parameters in array.
    +---------------------------------------------------------------*/
    if (calcdimflag)
    {
        if (setparm("arraydim","real",CURRENT,&arraydim,1))
            goto abortAcq;
        P_creatvar(CURRENT,"arrayelemts",ST_REAL);
        P_setgroup(CURRENT,"arrayelemts",G_ACQUISITION);
        if (setparm("arrayelemts","real",CURRENT,&arrayelemts,1))
            goto abortAcq;
        P_creatvar(CURRENT,"acqcycles",ST_REAL);
        P_setgroup(CURRENT,"acqcycles",G_ACQUISITION);
        if (setparm("acqcycles","real",CURRENT,&acqcycles,1))
            goto abortAcq;
        if (retc)
        {
           retv[ 0 ] = intString( 1 );
        }
        RETURN;
    }

abortAcq:
   disp_acq("");
Werrprintf("OpenVnmrJ disabled go");
   ABORT;
}



/*----------------------------------------------------------------------------
|	argtest(argc,argv,argname)
|	test whether argname is one of the arguments passed
+---------------------------------------------------------------------------*/
static int argtest(int argc, char *argv[], char *argname)
{
  int found = 0;

  while ((--argc) && !found)
    found = (strcmp(*++argv,argname) == 0);
  return(found);
}

void getVnmrInfo(int okToSet, int okToSetSpin, int overRideSpin)
{
    int val;
    char lkStr[MAXSTR];
    char tmpStr[MAXSTR];
    int  panelCntrl;

    P_creatvar(CURRENT,"spinThresh",ST_REAL);
    P_setgroup(CURRENT,"spinThresh",G_ACQUISITION);
    P_setreal(CURRENT,"spinThresh",(double) getInfoSpinner() ,0);
    P_creatvar(CURRENT,"interLocks",ST_STRING);
    P_setgroup(CURRENT,"interLocks",G_ACQUISITION);
    if (P_getstring(CURRENT,"in",lkStr,1,4))
       strcpy(lkStr,"n");
    /* interLocks will be three characters
     * char 0 for lock interlock
     * char 1 for spin interlock
     * char 2 for temp interlock
     */
    if (lkStr[0] == '\0')
    {
       lkStr[0] = 'n';
       lkStr[1] = '\0';
    }
    panelCntrl = !getInfoSpinExpControl();
    if (panelCntrl && overRideSpin)
    {
       panelCntrl = 0;
       okToSetSpin = 0;
    }
    if ( panelCntrl )
    {
       if (okToSet)
       {
          P_setreal(CURRENT,"spin",(double) getInfoSpinSpeed() ,0);
          P_setactive(CURRENT,"spin",1);
          appendvarlist("spin");
       }
       val = getInfoSpinErrorControl();
       if (val == 0)
          lkStr[1] = 'n';
       else if (val == 1)
          lkStr[1] = 'y';
       else
          lkStr[1] = 'w';
    }
    else
    {
       if (lkStr[1] == '\0')
          lkStr[1] = lkStr[0];
       /* only update if GO/AU/GA, SPIN, or SAMPLE (okToSetSpin flag) */
       if (okToSet && var_active("spin",CURRENT) && okToSetSpin)
       {
          double tmpval;
          int ival;
          P_getreal(CURRENT,"spin", &tmpval ,1);
          ival = (int) tmpval;

          setInfoSpinOnOff((ival == 0) ? 0 : 1);
          setInfoSpinSetSpeed(ival);
       }
    }
    if (P_getstring(CURRENT,"tin",tmpStr,1,4))
       tmpStr[0] = 'n';
    if (!getInfoTempExpControl() )
    {
       if (okToSet)
       {
          P_setreal(CURRENT,"temp",(double) getInfoTempSetPoint()/10.0 ,0);
          P_setactive(CURRENT,"temp", getInfoTempOnOff());
          appendvarlist("temp");
       }
       val = getInfoTempErrorControl();
       if (val == 0)
          tmpStr[0] = 'n';
       else if (val == 1)
          tmpStr[0] = 'y';
       else
          tmpStr[0] = 'w';
    }
    else
    {
       if (okToSet)
       {
          double tmpval;
          P_getreal(CURRENT,"temp", &tmpval ,1);
          if (var_active("temp",CURRENT))
          {
             setInfoTempOnOff(1);
             setInfoTempSetPoint((int) (tmpval * 10.0));
          }
          else
          {
             setInfoTempOnOff(0);
          }
       }
    }
    lkStr[2] = tmpStr[0];
    lkStr[3] = '\0';

    /* look for pnin, pneumatic Interlock */
    if (P_getstring(CURRENT,"pin",tmpStr,1,4))
       tmpStr[0] = 'n';
    lkStr[3] = tmpStr[0];
    lkStr[4] = '\0';

    P_setstring(CURRENT,"interLocks",lkStr,0);
}
/*
 *  Delete temporary parameters which were used to pass
 *  information to PSG. Also used by DPS
 */
void cleanup_pars()
{
   P_deleteVar(CURRENT,"when_mask");
   P_deleteVar(CURRENT,"com$string");
   P_deleteVar(CURRENT,"goid");
   P_deleteVar(CURRENT,"spinThresh");
   P_deleteVar(CURRENT,"interLocks");
   P_deleteVar(CURRENT,"appdirs");
   P_deleteVar(CURRENT,"saveArraydim");
}

/*----------------------------------------------------------------------------
|
|	arraytests()
|
|	autogaining (gain='n') cannot be used in multifid experiments
|			(i.e., gain='n', with other arrayed parameters)
|	test for improper interleaving (il='y') (no-no with arrayed parameters,
|		tpc,pad,spin,nt  experiments)
|		acqqueuei#:=ior(16*priority, acqqueuei#);
|		if ilv[1]='y' then acqqueuei#:=ior(1,acqqueuei#); 
|	test for proper usage of arrayed variables and variable 'array'
+---------------------------------------------------------------------------*/
int arraytests()
{
    char  array[MAXSTR];	/* arrayed variable indexing parameter */
    char  interleav[MAXSTR];	/* interleave variable   y or n */
    char *names[MAXARYS];	/* names of arrayed variables */
    double  gain;		/* value for variable gain */
    int   numary;		/* number of arrayed variables */
    
    /*------------------------------------------------------------------
    |   A_getarynames()
    | W A R N I N G ! !  this routine gives the addresses of then names in the
    |  tree therefore never change the contents of what is pointed to
    |  by the pointers else YOU WILL TRASH the VARIBLE TREE..
    +------------------------------------------------------------------*/
    A_getarynames(CURRENT,names,&numary,MAXARYS);
    if (numary == -1)
    {
	Werrprintf("Number of arrayed variables exceeds the maximum of %d",
			MAXARYS);
	return(ERROR);
    }
#ifdef  DEBUG
    if (Gflag)
    {   int i;
	GPRINT1(1,"arraytests(): Number of arrayed variables = %d \n",numary);
	for (i=0; i < numary; i++)
	    GPRINT1(1,"arraytests(): Name: '%s' \n",names[i]);
    }
#endif 
    if (getparm("gain","real",CURRENT,&gain,1))
	return(ERROR);
    GPRINT1(1,"arraytests(): gain = %6.0lf \n",gain);
    /* ---         test il parameter    --- */
    if (getparm("il","string",CURRENT,interleav,MAXSTR))
    {
	Werrprintf("Cannot find interleaving parameter 'il'.");
	return(ERROR);
    }
    GPRINT1(1,"arraytests(): il = '%s' \n",interleav);
    if ( (interleav[0] == 'y') || (interleav[0] == 'Y') )
    {
	if (findname("vtc",names,numary) != NOTFOUND)
	{
	    Werrprintf("Cannot interleave with variable 'vtc' arrayed.");
	    return(ERROR);
	}
	if (findname("pad",names,numary) != NOTFOUND)
	{
	    Werrprintf("Cannot interleave with variable 'pad' arrayed.");
	    return(ERROR);
	}
	if (findname("spin",names,numary) != NOTFOUND)
	{
	    Werrprintf("Cannot interleave with variable 'spin' arrayed.");
	    return(ERROR);
	}
	if (findname("nt",names,numary) != NOTFOUND)
	{
	    Werrprintf("Cannot interleave with variable 'nt' arrayed.");
	    return(ERROR);
	}
    }
    /*-----------------------------------------------------------------
    |		parse the 'array' parameter and test that the variables 
    |		listed are indeed arrayed, that diaginal sets have equal
    |		dimensions, and calculate 'arraydim'
    +-----------------------------------------------------------------*/
    if (getparm("array","string",CURRENT,array,MAXSTR))
	return(ERROR);

    GPRINT1(1,"arraytests():  array: '%s' \n",array);
    
/* #ifdef  XXXX_SEE_TESTARRAYPARAM_DONE_SEPERATELY_4_JPSG_DOESNT_CHECK_ARRAY */

    if (strlen(array) > (size_t) 0)	/* does array have any thing in it */
    {
#ifdef XXX
        if ( !noGainTest && (!var_active("gain",CURRENT)) && (numary > 0) )
        {
	    Werrprintf("Autogain is not permitted in arrayed experiments.");
	    return(ERROR);
        }
#endif
        if (testarrayparm(array,names,&numary))
	    return(ERROR);
    }

/* #endif */
    return(OK);
}



/*------------------------------------------------------------------
|
|	validcall()
|
|  set suflag according to call name used. 
|  check for alias to be valid for system.
|  set autoflag  
|	return 1 of OK else returns 0;
|
| 		Author  Greg Brissey  4/21/86
+---------------------------------------------------------------------*/
static int validcall(int argc, char *argv[], int *datastation, int checkacqexpt)
{
    int    len;
    int    expno;

    *datastation = is_datastation();
    if (argtest(argc,argv,"go"))
       strcpy(callname,"go");
    else if (argtest(argc,argv,"ga"))
       strcpy(callname,"ga");
    else if (argtest(argc,argv,"au"))
       strcpy(callname,"au");
    else if (argtest(argc,argv,"su"))
       strcpy(callname,"su");
    else if (argtest(argc,argv,"change"))
       strcpy(callname,"change");
    else if (argtest(argc,argv,"sample"))
       strcpy(callname,"sample");
    else
       strcpy(callname,argv[CALLNAME]);
    len = strlen( &curexpdir[ 0 ] );
    if (len < 1)
    {
	Werrprintf( "%s:  current experiment not defined", callname);
	return( 0 );
    }

    expno = expdir_to_expnum(curexpdir);
    if ( expno == 0 )
    {
#ifdef VNMRJ
	if (argtest(argc,argv,"calcdim") == 0)
#endif 
	   Werrprintf( "%s:  no current experiment", callname);
	return( 0 );
    }
    else if (checkacqexpt)
    {
       if ( expno > MAXACQEXPS )
       {
          Werrprintf( "%s:  only experiments 1-9 are for acquisition",
			   callname );
          return( 0 );
       }
    }
    else if ( expno > MAXEXPS )
    {
       Werrprintf( "%s:  invalid experiment number", callname);
       return( 0 );
    }

    /*  check for aliases of GO */
    if (argtest(argc,argv,"go") ||
	argtest(argc,argv,"ga") ||
	argtest(argc,argv,"au") ||
	(strcmp(argv[CALLNAME],"ra") == 0))
	suflag = EXEC_GO;
    else if (strcmp(callname,"su") == 0)
	suflag = EXEC_SU;
    else if (strcmp(argv[CALLNAME],"shim") == 0) 
	suflag = EXEC_SHIM;
    else if (strcmp(argv[CALLNAME],"lock") == 0)
	suflag = EXEC_LOCK;
    else if (strcmp(argv[CALLNAME],"spin") == 0)
        suflag = EXEC_SPIN;
    else if (strcmp(callname,"change") == 0)
	suflag = EXEC_CHANGE;
    else if (strcmp(callname,"sample") == 0)
        suflag = EXEC_SAMPLE;
    else if (strcmp(callname,"exptime") == 0)
        suflag = EXEC_EXPTIME;
    else if (strcmp(callname,"dps") == 0 || strcmp(callname,"pps") == 0 )
        suflag = EXEC_DPS;
    else if (strcmp(callname,"createparams") == 0)
        suflag = EXEC_CREATEPARAMS;
    else
    {
        Werrprintf("'%s': is an invalid alias of go",callname);
	return(0);
    }
    /*if ( ((suflag > EXEC_SU) && (suflag < EXEC_SPIN)) || 
	 (suflag > EXEC_CHANGE) )
    {	Werrprintf("'%s': is an unimplemented alias of go",
                callname);
        return(0);
    } */
    automode = (mode_of_vnmr == AUTOMATION);
    if (automode) 
    {
        if (getparm("autodir","string",GLOBAL,autodir,MAXPATH))
    	{    Werrprintf("cannot find parameter: autodir");
	     return(0);
    	}
    }
    GPRINT1(1,"automode= %d\n",automode);
    return(1);
}

/*-----------------------------------------------------------------------
|  	testarrayparm/3
|	tests that the array parameter's  parameters are indeed
|	arrayed variables. For each parameter it finds in the list
|	of arrayed variables it removes it from the list.
|	Also if varialbe in '(' ')' do not have the same dimension
|	error is produced.
|	(e.g.  array ='sw,(pw,d1),dm' )     (pw must = d1 in dimension)
|			Author Greg Brissey  6/4/86
+------------------------------------------------------------------------*/
#define letter1(c) ((('a'<=(c))&&((c)<='z'))||(('A'<=(c))&&((c)<='Z')))
#define letter(c) ((('a'<=(c))&&((c)<='z'))||(('A'<=(c))&&((c)<='Z'))||((c)=='_')||((c)=='$')||((c)=='#'))
#define digit(c) (('0'<=(c))&&((c)<='9'))
#define NIL 0
#define COMMA 0x2C
#define RPRIN 0x29
#define LPRIN 0x28

static int testarrayparm(char *string, char *names[], int *nnames)
{
    int state;
    char *ptr;
    char preparm[MAXSTR];/* pervious parameter */
    char *varptr = NULL;	/* pointer to one variable in the 'array' string */

    state = 0;
    strcpy(preparm,"");
    ptr = string;
    GPRINT1(1,"testarray(): string: '%s' -----\n",string);
    /*
     * ---  test the variables as we parse them
     * ---  This is a 4 state parser, 0-1: separate variables
     * --- 			      2-4: diagonal set variables
     */
    while(1)
    {
    switch(state)
    {
       /* ---  start of variable name --- */
       case 0:
	    GPRINT(2,"Case 0: ");
            GPRINT1(2,"letter: '%c', ",*ptr);
	    if (letter(*ptr))	/* 1st letter go to state 1 */
	    {   varptr = ptr;
	 	state = 1;
		ptr++;
	    }
	    else
	    {   if (*ptr == LPRIN )	/* start of diagnal arrays */
		{
	    	    state = 2;
		    ptr++;
		}
		else
		{   if (*ptr == NIL)	/* done ? */
			return(OK);
		    else		/* error */
		    {
			Werrprintf("Syntax error in variable '%s'",arrayname);
			return(ERROR);
		    }
		}
	    }
	    GPRINT1(2," state = %d \n",state);
	    break;
       /* --- complete a single array variable till ',' --- */
       case 1:
	    GPRINT(2,"Case 1: ");
            GPRINT1(2,"letter: '%c', ",*ptr);
	    if (letter(*ptr) || digit(*ptr))
	    {
		ptr++;
	    }
	    else
	    {
		if ( *ptr == COMMA )
		{
		    *ptr = NIL;
		    if (checkparm(varptr,preparm,names,nnames))
			return(ERROR);
		    ptr++;
		    state=0;
		}
		else
		{
		    if (*ptr == NIL)
		    {
		    	if (checkparm(varptr,preparm,names,nnames))
			    return(ERROR);
			return(OK);
		    }
		    else
		    {
		    	Werrprintf("Syntax Error in variable '%s'",arrayname);
		    	return(ERROR);
		    }
		}
	    }
            GPRINT1(2," state = %d \n",state);
	    break;
       /* --- start of diagnal arrayed variables  'eg. (pw,d1)' --- */
       case 2:
	    GPRINT(2,"Case 2: ");
            GPRINT1(2,"letter: '%c', ",*ptr);
	    if (letter(*ptr))
	    {   varptr = ptr;
	 	state = 3;
		ptr++;
	    }
	    else
	    {
	    	Werrprintf("Syntax Error in variable '%s'",arrayname);
		return(ERROR);
	    }
            GPRINT1(2," state = %d \n",state);
	    break;
       /* --- finish a diagonal arrayed variable  name --- */
       case 3:
	    GPRINT(2,"Case 3: ");
            GPRINT1(2,"letter: '%c', ",*ptr);
	    if (letter(*ptr) || digit(*ptr))
	    {
		ptr++;
	    }
	    else
	    {
		if (*ptr == COMMA)
		{
		    *ptr = NIL;
		    if (checkparm(varptr,preparm,names,nnames))
			return(ERROR);
		    strcpy(preparm,varptr);
		    ptr++;
		    state=2;
		}
		else
		    if (*ptr == RPRIN )
		    {
		        *ptr = NIL;
		    	if (checkparm(varptr,preparm,names,nnames))
			    return(ERROR);
		    	ptr++;
		        strcpy(preparm,"");
		        state=4;
		    }
		else
		{
		    Werrprintf("Syntax Error in variable '%s'",arrayname);
		    return(ERROR);
		}
	    }
            GPRINT1(2," state = %d \n",state);
	    break;
       /* --- finish a diagonal arrayed variable  set --- */
       case 4:
	    GPRINT(2,"Case 4: ");
            GPRINT1(2,"letter: '%c', ",*ptr);
	    if ( *ptr == COMMA )
	    {
	        *ptr = NIL;
	        ptr++;
		strcpy(preparm,"");
	        state=0;
	    }
	    else
	    {
		if (*ptr == NIL)
		{
		    return(OK);
		}
		else
		{
	            Werrprintf("Syntax Error in variable '%s'",arrayname);
		    return(ERROR);
		}
	    }
            GPRINT1(2," state = %d \n",state);
	    break;
    }
    }
}
/*----------------------------------------------------------------
|	checkparm(varptr,pervar,names,nnames)
|	check to see if the variable is arrayed.
|	If arrayed then remove it from the list return(0)
|	If not arrayed return(1)
|	Test diagonal arrays for equal dimensions
|	keep a running count on fids obtain for the arrayed variables
|	keep a running count on number or array elements needed in PSG 
|	return(0) if OK else return(1)
|			Author Greg Brissey  4/6/86
+-----------------------------------------------------------------*/
static int checkparm(char *varptr, char *prevar, char *names[], int *nnames)
{
    int index;

    GPRINT2(1,"checkparm(): previous var: '%s', present var: '%s'\n",
		prevar,varptr);
    index = findname(varptr,names,*nnames);
    /*
    if (index == NOTFOUND)
    {
	Werrprintf("Variable '%s' is not arrayed. Correct '%s' or '%s'",
		varptr,arrayname,varptr);
	return(ERROR);
    }
    */
    if (index != NOTFOUND)
    {
      GPRINT3(1,"checkparm():  variable: '%s', was found at list[%d] = '%s'\n",
		varptr,index,names[index]);
      removename(index,names,nnames);
    }
       /* GPRINT3(1,"checkparm():  variable: '%s', is not arrayed. \n",varptr); */

    /*---------------------------------------------------------------
    | running calculation of # fid obtain with each new array 
    | Note: for each new variable the prevar is null, only on the 
    | second, plus  variables in a diagonal set "eg (pw,d1)" will have 
    | a previous variable set  
    +---------------------------------------------------------------*/
    if (strlen(prevar) == 0)	/* only if separate array variable */
    {   vInfo	varinfo;		/* variable information structure */
	if (P_getVarInfo(CURRENT,varptr,&varinfo) )
    	{   Werrprintf("Cannot find the variable: %s",varptr);
	    return(ERROR);
    	}
    	arraydim *=(double) varinfo.size;
    	acqcycles *= (double)varinfo.size;
	arrayelemts += 1.0;  /* increment number of array elements */
    }
    GPRINT2(1,"checkparm():  arraydim = %5lf arrayelemts = %5lf \n",
		arraydim,arrayelemts);

    /* true for second+plus variables in diagonal set*/
    if (strlen(prevar) > (size_t) 0)
    {
       if (equalsize(prevar,varptr)) /* equal dimensions ? */
       {
	   Werrprintf("diagonal arrays '%s', '%s' have unequal dimensions",
			prevar,varptr);
	   return(ERROR);
       }
    }
    return(OK);
}
/*-----------------------------------------------------------------
|	equalsize(var1,var2)
|	check to see that the two variables have equal dimensions 
|       If the variable is not arrayed, and it is one of the nD
|       incrementing variables (d2,d3,d4,d5), check the value of
|       the corresponding nD variable (ni,ni2,ni3,ni4)
|			Author Greg Brissey  6/6/86
+-----------------------------------------------------------------*/
static int equalsize(char *var1, char *var2)
{
    int nvals1;
    int nvals2;
    double val;
    vInfo	varinfo;		/* variable information structure */

    if (P_getVarInfo(CURRENT,var1,&varinfo) )
    {   Werrprintf("equalsize(): Cannot find the variable: %s",var1);
	return(ERROR);
    }
    nvals1 = varinfo.size;
    if (nvals1 == 1)
    {
       if (! strcmp(var1,"d2") )
       {
          if ( ! P_getreal(CURRENT,"ni", &val, 1) )
             if (val > 1.0)
                nvals1 = (int) (val+0.1);
       }
       else if (! strcmp(var1,"d3") )
       {
          if ( ! P_getreal(CURRENT,"ni2", &val, 1) )
             if (val > 1.0)
                nvals1 = (int) (val+0.1);
       }
       else if (! strcmp(var1,"d4") )
       {
          if ( ! P_getreal(CURRENT,"ni3", &val, 1) )
             if (val > 1.0)
                nvals1 = (int) (val+0.1);
       }
       else if (! strcmp(var1,"d5") )
       {
          if ( ! P_getreal(CURRENT,"ni4", &val, 1) )
             if (val > 1.0)
                nvals1 = (int) (val+0.1);
       }
    }
    if (P_getVarInfo(CURRENT,var2,&varinfo) )
    {   Werrprintf("equalsize(): Cannot find the variable: %s",var2);
	return(ERROR);
    }
    nvals2 = varinfo.size;
    if (nvals2 == 1)
    {
       /*
        * If second var is nD element, prevent multplying arraydim by ni, ni2, etc
        * by setting global integers d2Array, d3Array, etc.
        * Test case array='(nt,d2)' and array='(d2,nt)' should both give the
        * same arraydim.
        * If first var is nD element, arraydim will be multiplied in acq() by ni, etc
        * in section of code after call to arraytests();
        */
       if (! strcmp(var2,"d2") )
       {
          if ( ! P_getreal(CURRENT,"ni", &val, 1) )
             if (val > 1.0)
             {
                nvals2 = (int) (val+0.1);
                d2Array = 1;
             }
       }
       else if (! strcmp(var2,"d3") )
       {
          if ( ! P_getreal(CURRENT,"ni2", &val, 1) )
             if (val > 1.0)
             {
                nvals2 = (int) (val+0.1);
                d3Array = 1;
             }
       }
       else if (! strcmp(var2,"d4") )
       {
          if ( ! P_getreal(CURRENT,"ni3", &val, 1) )
             if (val > 1.0)
             {
                nvals2 = (int) (val+0.1);
                d4Array = 1;
             }
       }
       else if (! strcmp(var2,"d5") )
       {
          if ( ! P_getreal(CURRENT,"ni4", &val, 1) )
             if (val > 1.0)
             {
                nvals2 = (int) (val+0.1);
                d5Array = 1;
             }
       }
    }
    GPRINT4(1,"equalsize(): Variables: '%s', '%s' have sizes of: %d, %d\n",
		var1,var2,nvals1,nvals2);
    if (nvals1 != nvals2)
	return(ERROR);
    return(OK);
}

/*------------------------------------------------------------------
|
|	findname(name,namelist,numinlist)
|
|  	tests to see if the given name is in the name list. 
|	performs a linear search
|	returns position (0-numinlist) if found
|	returns -1 if not found.
|
| 		Author  Greg Brissey  6/04/86
+---------------------------------------------------------------------*/
static int findname(char *name, char *namelist[], int numinlist)
{
    int i;

    for ( i = 0; i < numinlist; i++)
    {
	GPRINT3(1,"findname(): name: '%s', namelist[%d]: '%s' \n",
			name,i,namelist[i]);
	if (strcmp(name,namelist[i]) == 0)
	    return(i);
    }
    return(NOTFOUND);
}
/*------------------------------------------------------------------
|
|	removename(index,namelist,numinlist)
|
|  	remove the pointer at the index position. 
|	moves the rest of the pointer to fill in the gap.
|	decrements the list count
|
| 		Author  Greg Brissey  6/04/86
+---------------------------------------------------------------------*/
static int removename(int index, char *namelist[], int *numinlist)
{
    GPRINT1(1,"removename():  variable to delete from list: '%s' \n",
			namelist[index]);
#ifdef  DEBUG
    if (Gflag > 2)
    {   int i;
	for (i=0; i < *numinlist; i++)
	    GPRINT2(3,"removename(): variables  names[%d] = '%s' \n",
			i,namelist[i]);
    }
#endif 
    if ( (index < 0) || (*numinlist < index) )
    {
	Werrprintf("removename(): Item to remove from list is out of bounds");
	return(ERROR);
    }
    if (index < *numinlist)	/* if index = numinlist just dec counter */
    {   int i,j;

    	for (i=index,j=index+1; j < *numinlist; i++,j++)
    	{
	    GPRINT2(2,"removename():  name[%d] = name[%d] \n",i,j);
	    namelist[i] = namelist[j];
    	}
    }
    *numinlist -= 1;
#ifdef  DEBUG
    if (Gflag > 2)
    {   int i;
	for (i=0; i < *numinlist; i++)
	    GPRINT2(3,"removename(): variables  names[%d] = '%s' \n",
			i,namelist[i]);
    }
#endif 
    return(OK);
}
/*------------------------------------------------------------------------------
|
|	A_getnames/4
|
|	This function loads an array of pointers to character strings with
|	pointers to the names of variables in a tree.  It sets numvar to
|	the number of variables in the tree.  
|
|    W A R N I N G ! !  
|	This routine gives the addresses of the names in the
|  	tree therefore never change the contents of what is pointed to
|  	by the pointers else YOU WILL TRASH the VARIBLE TREE..
|				Author  Greg Brissey  4/6/86
|
+-----------------------------------------------------------------------------*/

static int A_getarynames(int tree, char **nameptr, int *numvar, int maxptr) 
{   int      i;
    int	   ret;
    symbol **root;
    
    i = 0;
    *numvar = 0;
    if ( (root = getTreeRoot(getRoot(tree))) )
    {	ret = getNames(*root,nameptr,numvar,maxptr,&i);
	return(ret);
    }
    else
	return(NOTREE);  /* tree doesn't exist (-1) */
}

/*----------------------------------------------------------------------------
|
|	getNames/5
|
|	This modules recursively travels down a tree, sets an array of
|	pointer to the variables name strings and keeps count of them.
|	This is only done for arrayed variable in the acquisition group!
|				Author  Greg Brissey  4/6/86
+-----------------------------------------------------------------------------*/

static int getNames(symbol *s, char **nameptr, int *numvar, int maxptr, int *i) 
{   varInfo *v;

    if (s)
    {	getNames(s->left,nameptr,numvar,maxptr,i);
        if (*i < maxptr)
	{   
	    v = (varInfo *)s->val;
	    /* only arrayed & acquisition group variables */
	    if ( (v->T.size > 1) && (v->Ggroup == G_ACQUISITION) )
	    {
	    	nameptr[*i] = s->name;
	    	*i += 1;  
		*numvar += 1;
	    }
	    GPRINT3(3,"getNames():  name: '%s', i = %d, number: %d \n",
			s->name,*i,*numvar);
	}
	else
	{   *numvar = -1;  /* mark error */
	    return(ERROR);
	}
     	getNames(s->right,nameptr,numvar,maxptr,i);
	return(OK);
    }
    return(OK);
}

/*----------------------------------------------------------------------------
|	autoname(argc,argv,retc,retv)
|	This module constructs a file name based on autoname parameter
|	and sampleinfo file
+---------------------------------------------------------------------------*/
int autoname(int argc, char **argv, int retc, char **retv)
{
char	a_name[MAXPATH];
char	sif_name[MAXPATH];
char	result[MAXPATH];
char*	suffix = ".fid"; 
char*	notsuffix;

int	bad;
int	replaceSpaceFlag = TRUE;
#ifdef __INTERIX
	replaceSpaceFlag = FALSE;
#endif

   if (strcasecmp(argv[0],"svsname")==0) {
       suffix = "";
   }
   if (strcmp(argv[0],"autoname")==0)
   {
      if (getparm("autodir","string",GLOBAL,autodir,MAXPATH))
      {  Werrprintf("cannot find parameter: autodir");
         return(1);
      }
      if (strcmp(autodir,"")==0)
         sprintf(autodir,"%s/data",userdir);
      /*  file is "sampleinfo file" */
      strcpy(sif_name,curexpdir);
      strcat(sif_name,"/sampleinfo");
   }
   else /* if (strcmp(argv[0],"Svfname")==0) */
   {
      strcpy(sif_name,"");
   }

   strcpy(result,"");
   notsuffix = suffix;

   switch (argc)
   {
      case 1:
            if (strcmp(argv[0],"autoname")==0)
            {
	       /* get autoname parameter */
               if (P_getstring(GLOBAL,"autoname",a_name,1,MAXPATH) < 0)
	          strcpy(a_name,"%SAMPLE#:%%PEAK#:%");
               if (a_name[0] == '\000')
	          strcpy(a_name,"%SAMPLE#:%%PEAK#:%");
            }
            else /* if (strcmp(argv[0],"Svfname")==0) */
            {
	       /* get svfname parameter */
               if (P_getstring(GLOBAL,"svfname",a_name,1,MAXPATH) < 0)
	          strcpy(a_name,"$seqfil$-");
               if (a_name[0] == '\000')
	          strcpy(a_name,"$seqfil$-");
            }
            break;
      case 2:
            /* use argv[1] for parameter name */
            strcpy(a_name,argv[1]);
            break;
      case 5:
	    if (strcmp(argv[4],"keepspaces") == 0)
		replaceSpaceFlag = FALSE;
	    else if (strcmp(argv[4],"replacespaces") == 0)
		replaceSpaceFlag = TRUE;
      case 4:
	    if (strcmp(argv[3],"keepspaces") == 0)
		replaceSpaceFlag = FALSE;
	    else if (strcmp(argv[3],"replacespaces") == 0)
		replaceSpaceFlag = TRUE;
	    else
		notsuffix = argv[3];
      case 3:
            /* use argv[1] for parameter name */
	    strcpy(a_name,argv[1]);
            /* use argv[2] as sample name */
            if (strcmp(argv[0],"autoname")==0)
               strcpy(sif_name,argv[2]);
            else
               suffix = argv[2];
            break;
      default:
            if (strcmp(argv[0],"autoname")==0)
	       Winfoprintf("Usage: %s<(parametername<,filename<,not suffixes><,'keepspaces'|'replacespaces'>>)><:$path>",argv[0]);
            else
	       Winfoprintf("Usage: %s<(parametername<,suffix<,not suffixes><,'keepspaces'|'replacespaces'>>)><:$path>",argv[0]);
            return(1);
            break;
   }
   bad = makeautoname(argv[0],a_name,sif_name,result,FALSE,replaceSpaceFlag,suffix,notsuffix);
   if ( bad)
   {  
      if (retc)
         retv[0]=newString("");
      else
	 Winfoprintf("Unable to construct autoname");
      RETURN;
   }
   if (result[0] != '/')
   {
      if (strcmp(argv[0],"autoname")==0)
         strcpy(a_name,autodir);
      else
         sprintf(a_name,"%s/data",userdir);
      strcat(a_name,"/");
      strcat(a_name,result);
      strcpy(result,a_name);
   }
   
   switch(retc)
   {
      case 0:
	    Winfoprintf("%s%s",result,suffix);
	    break;
      case 2:
	    retv[1] = newString((strrchr(result,'/')+1));
      case 1:
            strcat(result, suffix);
	    retv[0] = newString(result);
            break;
      default:
            if (strcmp(argv[0],"autoname")==0)
	       Winfoprintf("Usage: %s<(parametername<,filename<,not suffixes><,'keepspaces'|'replacespaces'>>)><:$path>",argv[0]);
            else
	       Winfoprintf("Usage: %s<(parametername<,suffix<,not suffixes><,'keepspaces'|'replacespaces'>>)><:$path>",argv[0]);
	    return(1);
            break;
   }
   return(0);
}

/*----------------------------------------------------------------------------
|
|	makeautoname/8
|
|	This module constructs a file name based on location number
+-----------------------------------------------------------------------------*/
int makeautoname(char *cmdname, char *a_name, char *sif_name, char *dirname,
                 int createflag, int replaceSpaceFlag,
                 char *suffix, char *notsuffix)
{
char	*ptr;
char	*aptr;
char	*sptr;
char	buffer[MAXPATH*2 + 40];
char	search_str[MAXSTR];
char	tmpStr[MAXSTR];
char	tmp[MAXPATH];
char	tmpSuffix[MAXPATH];
char	tmp2Str[MAXSTR];
char	revision[20];
double	rval;
int	filemode;
int	itemp;
int	dlen,len;
int	R_speced,R_start,R_width,rev;
int     R_offset,R_offsetTmp;
int     R_any = 0;
int	tree;
vInfo	info;
FILE	*fd;
char    recDir[MAXPATH];

    strcpy(recDir, dirname);
    fd = NULL;

/* try to get time variable */

   strcpy(tmp,"");
   currentDateLocal(tmpStr, MAXPATH);

/* init pointers */

   ptr=dirname;
   aptr = a_name;

   R_offset = -1;
   R_speced=0; R_start=1; R_width=2;
   dlen=MAXPATH;

/*---------------------------------------------------------
|  check autoname for %string%
|  search for this string (withouth %) in sampleinfo
|  then concatenate next word in sampleinfo into dirname
+--------------------------------------------------------*/

   while ( (*aptr != '\000')  && (dlen > 0) )
   {  
      if (*aptr == '%')
      {  aptr++;			/* Skip %-sign */
	 sptr = search_str;
         len=0;
         while ( (*aptr != '%') && (*aptr != '\000') && (len < MAXSTR) )
         {  *sptr++ = *aptr++;
            len++;
         }
         *sptr='\000';	
         aptr++;			/* Skip %-sign */
         if ( (search_str[0] == 'R') &&
             ((search_str[1] >= '0') && (search_str[1] <= '9'   )) &&
             ((search_str[2] == ':') || (search_str[2] == '\000')) )
         {
            if (! R_any)
            {
               R_any = 1;  /* Any %Rn% definition suppresses the automatic appending of one */
               R_width = 0;
            }
            if (search_str[1] != '0')
            {
               if (R_offset != -1)
               {
                  Werrprintf("%s: Only one Rn definition allowed",cmdname);
                  ABORT;
               }
               /* offset into string where indexing should be placed */
               R_offset = ptr - dirname;
               R_width = search_str[1] - '0';
               len = 0;
               /* Leave space in the string for the indexing */
               while (len < R_width)
               {
                  *ptr++ = '0';
                  len++;
               }
               if (search_str[2] == ':')
                  R_start = atoi(&search_str[3]);
               if (R_start == 0)
                  R_start = 1;	/* %R3:% would give zero, make at least 1 */
            }
         }
         else
         {
            itemp = 1;
            if (strcmp(tmpStr,"") != 0)
               itemp = dateStr(search_str,tmpStr,&ptr,&dlen); /* %DATE%%TIME% */
            if ((strcmp(cmdname,"autoname")==0) && (itemp==1))
            {
               if (fd == NULL)
               {
                  fd=fopen(sif_name,"r");
                  if (fd == NULL)
                  {  Werrprintf("autoname: cannot open %s",sif_name);
                     return(-1);
                  }
               }
               getStr(search_str,fd,&ptr,&dlen);
            }
            *ptr='\000';
         }
      }
      else if (*aptr == '$')
      {  aptr++;                        /* Skip $-sign */
         sptr = search_str;
         len=0;
         while ( (*aptr != '$') && (*aptr != '\000') && (len < MAXSTR) )
         {  *sptr++ = *aptr++;
            len++;
         }
         *sptr='\000';
         aptr++;                        /* Skip $-sign */
         tree = CURRENT;
	 if (P_getVarInfo(tree,search_str,&info) < 0)
         {  tree = GLOBAL;
            if (P_getVarInfo(tree,search_str,&info) < 0)
            {  tree = SYSTEMGLOBAL;
               if (P_getVarInfo(tree,search_str,&info) < 0)
               {  Werrprintf("Cannot find $%s$",search_str);
                  ABORT;
               }
            }
         }
	 if (info.basicType == T_REAL)
         {  P_getreal(tree,search_str,&rval,1);
	    sprintf(tmp2Str,"%d",(int)(rval+0.1));
	 }
	 else if (info.basicType == T_STRING)
         {  P_getstring(tree, search_str,tmp2Str,1,MAXSTR-1);
         }

         sptr = tmp2Str;
         while(*sptr != '\000')
         {
            if ((*sptr == ' ') && (replaceSpaceFlag == TRUE))
		*sptr = '_';
            *ptr++ = *sptr++;
         }
      }

/* any other text is copied (like '-', '.', etc) */

      else
      {
         if ((*aptr == ' ') && (replaceSpaceFlag == TRUE))
         {
            *ptr++ = '_';
            aptr++;
	    dlen--;
         }
         else if (verify_fnameChar( *aptr )==0)
         {
            *ptr++ = *aptr++;
	    dlen--;
         }
         else
         {
            Werrprintf("illegal character '%c' in %s",*aptr,cmdname);
            ABORT;
         }
      }
   }
   *ptr='\000';
   if (fd != NULL)
      fclose(fd);

/*---------------------------------------------------------
|  does dirname start with a '/'? If not pre-pend autodir 
+--------------------------------------------------------*/

   if ( dirname[0] !=  '/' )
   {
      if (strcmp(cmdname,"autoname")==0) 
         strcpy(tmp,autodir);
      else if(strstr(suffix,".REC") != NULL ||
	      strstr(suffix,".rec") != NULL ) strcpy(tmp,recDir);
      else sprintf(tmp,"%s/data",userdir);

      if(tmp[strlen(tmp)-1] != '/') strcat(tmp,"/");
      if (R_offset != -1)
      {
         R_offsetTmp = R_offset + strlen(tmp);
      }
      else
      {
         /* default indexing */
         R_offset = strlen(dirname);
         len = 0;
         while (len < R_width)
         {
            *ptr++ = '0';
            len++;
         }
         *ptr='\000';
         R_offsetTmp = R_offset + strlen(tmp);
      }
      strcat(tmp,dirname);
   }
   else
   {
      if (R_offset != -1)
      {
         R_offsetTmp = R_offset;
      }
      else
      {
         /* default indexing */
         R_offsetTmp = R_offset = strlen(dirname);
         len = 0;
         while (len < R_width)
         {
            *ptr++ = '0';
            len++;
         }
         *ptr='\000';
      }
      strcpy(tmp,dirname);
   }

/* append a run sequence, in case the fid-filename exists */
   if (R_width != 0)
   {
      char tmp2[MAXPATH],*ptr,*ptr1;
      int  permission = R_OK|W_OK|X_OK;
      int file_exists;
/* Check if the fid-filename exists, if so increase the %R count */
      rev = R_start;
      if (strcmp(suffix,".fid"))
         permission = F_OK;
      do
      {
         file_exists = FALSE;
         sprintf(revision,"%0*d",R_width,rev);
         len = strlen(revision);
         if (len > R_width)
         {
            int i;

            /* Revision gained an extra digit */
            /* Need to make room in the string */
            strncpy(tmp2,tmp,R_offsetTmp);
            i = 0;
            while (i < len)
            {
               *(tmp2+R_offsetTmp+i) = '0';
               i++;
            }
            *(tmp2+R_offsetTmp+i) = '\0';
            strcat(tmp2,(tmp+R_offsetTmp+R_width));
            strcpy(tmp,tmp2);

            strncpy(tmp2,dirname,R_offset);
            i = 0;
            while (i < len)
            {
               *(tmp2+R_offset+i) = '0';
               i++;
            }
            *(tmp2+R_offset+i) = '\0';
            strcat(tmp2,(dirname+R_offset+R_width));
            strcpy(dirname,tmp2);
            R_width = len;
         }
         strcpy(tmp2,tmp);
         /* overwrite the embedded zeros with the revision number */
         strncpy(tmp2+R_offsetTmp,revision,R_width);
         strcat(tmp2,suffix);
         if ( access(tmp2,permission) )
         {
	    /* check 'notsuffix'. This is a string with undesirable sufffixes
	     * separated by commas. We do not use srttok, it skips ,,
	     * thereby not allowing empty suffix. Any spaces (leading, 
	     * trailing or in the middle) are deleted.
             */
            ptr = notsuffix;
            while (*ptr != '\0') 
            {
               ptr1 = tmpSuffix;
               while ( (*ptr != '\0') && (*ptr != ',') )
               {  
                  if ( *ptr == ' ') 
                     ptr++;
                  else
                     *(ptr1++) = *(ptr++);
               }
               if (*ptr != '\0') ptr++;
               *ptr1 = '\0';
              
               strcpy(tmp2,tmp);
               strncpy(tmp2+R_offsetTmp,revision,R_width);
               strcat(tmp2,tmpSuffix);
               if (!access(tmp2,F_OK))
	       {
		  file_exists=TRUE;
		  break;
               }
            }
         }
         else
         {
	    file_exists = TRUE;
         }
         rev++;
      } while ( file_exists );

      /* overwrite the embedded zeros with the revision number */
      strncpy(tmp+R_offsetTmp,revision,R_width);
      strncpy(dirname+R_offset,revision,R_width);
   }
   if (replaceSpaceFlag == TRUE)
      replaceSpace(dirname);
   if (verify_fname(dirname))
   {  Werrprintf( "file path '%s%s' not valid", dirname, suffix );
      ABORT;
   }

   if ( ! createflag) RETURN;

/* Finally create the new fid-file */
#ifdef SIS
    filemode = 0755;
#else 
    filemode = 0777;
#endif 

   strcat(tmp,suffix);
   sprintf(buffer,"mkdir -p %s; chmod %o %s\n",tmp,filemode,tmp);
   itemp=system(buffer);
   if (itemp)
   {  printf("Cannot create directory '%s',return=%d\n",tmp,itemp);
      ABORT;
   }

   sprintf(buffer,"cp %s/sampleinfo %s/sampleinfo",curexpdir,tmp);
   system(buffer);

   RETURN;
}

void replaceSpace(char *name)
{
  int i=0;
  while ((name[i] != '\000') && (i<1000))
  {
    if (name[i] == ' ') name[i] = '_';
    i++;
  }
}

static int dateStr(char *find, char *dt, char **dptr, int *maxed)
/* add specifiers %DATE%%TIME% %YR%%MO%%DAY% %HR%%MIN%%SEC% %YR2%%MOC%%DAC%%HR12%%PM% */
{
	int i, start=0, len=0;
	if ((find[0]=='S') && (find[1]=='V') && (find[2]=='F') &&
	    (find[3]=='D') && (find[4]=='A') && (find[5]=='T') && (find[6]=='E'))
	{
	  char tmp2[MAXSTR];
/*	  if (P_getstring(CURRENT, "time_svfname", tmp2, 1, MAXSTR) == 0)
	    P_deleteVar(CURRENT, "time_svfname");
	  else */
	    currentDateSvf(tmp2, MAXPATH);
	  len = strlen(tmp2);
	  if (len > 0)
	  {
	    for (i=0; (i<len) && (*maxed>0); i++)
	    {
	      **dptr = tmp2[i];
	      (*dptr)++;
	      (*maxed)--;
	    }
	    return(0);
	  }
	}
	else if ((find[0]=='D') && (find[1]=='A') && (find[2]=='T') && (find[3]=='E'))
	{
	  start = 0; len = 8;
	}
	else if ((find[0]=='T') && (find[1]=='I') && (find[2]=='M') && (find[3]=='E'))
	{
	  start = 9; len = 6;
	}
	else if ((find[0]=='Y') && (find[1]=='R') && (find[2]=='2'))
	{
	  start = 2; len = 2;
	}
	else if ((find[0]=='Y') && (find[1]=='R'))
	{
	  start = 0; len = 4;
	}
	else if ((find[0]=='M') && (find[1]=='O') && (find[2]=='C'))
	{
/* if full month name, could continue to end of string */
	  start = 23; len = 3;
	}
	else if ((find[0]=='M') && (find[1]=='O'))
	{
	  start = 4; len = 2;
	}
	else if ((find[0]=='D') && (find[1]=='A') && (find[2]=='C'))
	{
/* if full day-of-week name, could continue to character 'y' */
	  start = 20; len = 3;
	}
	else if ((find[0]=='D') && (find[1]=='A') && (find[2]=='Y'))
	{
	  start = 6; len = 2;
	}
	else if ((find[0]=='H') && (find[1]=='R') && (find[2]=='1') && (find[3]=='2'))
	{
	  start = 16; len = 2;
	}
	else if ((find[0]=='H') && (find[1]=='R'))
	{
	  start = 9; len = 2;
	}
	else if ((find[0]=='P') && (find[1]=='M'))
	{
	  start = 18; len = 2;
	}
	else if ((find[0]=='M') && (find[1]=='I') && (find[2]=='N'))
	{
	  start = 11; len = 2;
	}
	else if ((find[0]=='S') && (find[1]=='E') && (find[2]=='C'))
	{
	  start = 13; len = 2;
	}
	if (len > 0)
	{
	  for (i=0; (i<len) && (*maxed>0); i++)
	  {
	    **dptr = dt[i+start];
	    (*dptr)++;
	    (*maxed)--;
	  }
          **dptr = '\0';
	  return(0);
	}
	return(1);
}

static void getStr(char *find, FILE *fd, char **dptr, int *maxed)
{
char	buffer[1000];
char	*ptr1;
char	*result=(char *)1;
int	isamp,done = 0;
   rewind(fd);

   ptr1 = NULL;
   while ( result && !done)
   {  
      result = fgets(buffer,300,fd); /* reads n or to/incl end-of-line */
      if ( (ptr1 = strstr(buffer,find)) ) done=1;
   }
   if (done)
   {  
      ptr1 += strlen(find);
      while ( (*ptr1 == ' ') || (*ptr1 == '\t') ) 
      {  
          ptr1++;
      }
      if (!strcmp(find,"SAMPLE#:") || !strcmp(find,"PEAK#:"))
      {   isamp = strlen(ptr1);
          if ( verify_fnameChar(*(ptr1+1)) )
             if ( (*ptr1 >= '0') && (*ptr1 <= '9') )
	     {  isamp = *ptr1; /* save char */
                *ptr1 = '0';
		*(ptr1+1) = isamp;
		*(ptr1+2) = ' ';
             }
      }
      while ( (verify_fnameChar(*ptr1) == 0) && (*maxed > 0) )
      { **dptr = *ptr1;
        (*dptr)++;
        ptr1++;
        (*maxed)--;
      }
   }
}

/* Return value is length of parameter name. Return 0 if not a parameter */
/* parName is returned parameter name. parValue is returned parameter value */
static int isParFeature(char *ptr, char *parName, char *parValue, int len)
{
   char *sptr;
   int  slen = 1;
   symbol **root;
   varInfo *v;

   sptr = parName;
   slen=0;
   strcpy(parValue,"");
   if (*ptr == '$')
   {
      *sptr++ = *ptr++;
      slen++;
   }
   while ( (*ptr != '$') && (*ptr != '\000') && (slen < len) )
   {  *sptr++ = *ptr++;
      slen++;
   }
   *sptr='\000';
   v = NULL;
   if (*parName == '$') /* Temporary $par */
   {
      if ( ( root = selectVarTree(parName) ) )
         v = rfindVar(parName,root);
   }
   else
   {
      root = getTreeRootByIndex(CURRENT);
      if ( (v = rfindVar(parName,root)) == NULL)
      {
         root = getTreeRootByIndex(GLOBAL);
         if ( (v = rfindVar(parName,root)) == NULL)
         {
            root = getTreeRootByIndex(SYSTEMGLOBAL);
            if ( (v = rfindVar(parName,root)) == NULL)
            {
               return(0);
            }
         }
      }
   }
   if (v == NULL)
   {
      return(0);
   }
   if (v->T.basicType == T_REAL)
   { 
      Rval *r;
      r = v->R;
      sprintf(parValue,"%d",(int)(r->v.r+0.1));
   }
   else if (v->T.basicType == T_STRING)
   {
      Rval *r;
      r = v->R;
      strcpy(parValue,r->v.s);
   }
   return(slen);
}

static int isTemplateFeature(char *ptr, char *dateChar, char *val, int len)
{
   char *tmpPtr;
   char tmp[MAXSTR];
   int  tlen = MAXSTR;
   
   tmpPtr = tmp;
   if ( ! strncmp(ptr,"DATE%",5) || ! strncmp(ptr,"TIME%",5) || ! strncmp(ptr,"HR12%",5) )
   {
      dateStr(ptr, dateChar, &tmpPtr, &tlen);
      strcpy(val,tmp);
      return(4);
   }
   if ( ! strncmp(ptr,"DAY%",4) || ! strncmp(ptr,"MIN%",4) || ! strncmp(ptr,"SEC%",4) ||
        ! strncmp(ptr,"DAC%",4) || ! strncmp(ptr,"MOC%",4) || ! strncmp(ptr,"YR2%",4) )
   {
      dateStr(ptr, dateChar, &tmpPtr, &tlen);
      strcpy(val,tmp);
      return(3);
   }
   if ( ! strncmp(ptr,"YR%",3) || ! strncmp(ptr,"MO%",3) || ! strncmp(ptr,"HR%",3) ||
        ! strncmp(ptr,"PM%",3) )
   {
      dateStr(ptr, dateChar, &tmpPtr, &tlen);
      strcpy(val,tmp);
      return(2);
   }
   if ( (*ptr == 'R') && ( *(ptr+1) >= '0') && ( *(ptr+1) <= '9' ) )
   {
      if ( *(ptr+2) == '%' )
         return(-2);
      if ( *(ptr+2) == ':' )
      {
         if (  ( *(ptr+3) >= '1') && ( *(ptr+3) <= '9' ) )
         {
            if ( *(ptr+4) == '%' )
               return(-4);
            if (  ( *(ptr+4) >= '0') && ( *(ptr+4) <= '9' ) )
            {
               if ( *(ptr+5) == '%' )
                  return(-5);
               if (  ( *(ptr+5) >= '0') && ( *(ptr+5) <= '9' ) )
                  if ( *(ptr+6) == '%' )
                     return(-6);
            }
         }
      }
   }
   return(0);
}

static int checkChar( register int ptr, int charType, register char *defChars, int replaceChar )
{
   register int i;

   switch (charType)
   {
      case 1:   {
                   int numChars;
                   if (isalnum(ptr))
                      return(ptr);
                   numChars = strlen(defChars);
                   for (i=0; i < numChars; i++)
                   {
                      if (ptr == *(defChars+i) )
                         return(ptr);
                   }
                   return(replaceChar);
                }
                break;
      case 2:   return(ptr);
                break;
      case 3:   {
                   int numChars = strlen(defChars);
                   for (i=0; i < numChars; i++)
                   {
                      if (ptr == *(defChars+i) )
                         return(replaceChar);
                   }

                }
                break;
      default:  return(0);
                break;
   }
   return(ptr);
}

/*------------------------------------------------------------------------------|
|       chkname(template, 'chars','keyword','replacementChar')
|
|       chkname does "% pair" and "$ pair" substitutions on the template.
|       It also will check the resulting string for allowed or disallowed characters.
|       The third keyword argument (tmpl, str, par) controls have the $ and %
|       characters are interpreted. The fourth argument is the replacement
|       character for disallowed characters (default _)
+-----------------------------------------------------------------------------*/

int chkname(int argc, char *argv[], int retc, char *retv[])
{
   char *ptr;
   char parlist[MAXSTR];
   char reqlist[MAXSTR];
   char parstr[MAXSTR];
   char reqstr[MAXSTR];
   char search_str[MAXSTR];
   char tmp2Str[MAXSTR];
   char dateChar[MAXSTR];
   static char fileChars[MAXSTR] = "_.-";
   static char extraChars[MAXSTR];
   char *defChars = NULL;
   int  charType = 1;
   char replaceChar = '_';
   int  replaceTemplate = 1;
   int  replacePair = 0;     /* This selects default of par for third argument */
   char *pptr;
   char *rptr;
   char *sptr;
   int plen;
   int rlen;
   int  slen;

   if (argc == 1)
   {
      Werrprintf("Usage: %s(template,'characters','par tmpl or str','replacement character')",
                      argv[ 0 ]);
      ABORT;
   }
   if ( ! strcmp(argv[1],"fileChars") )
   {
      if (retc)
         retv[0] = newString(fileChars);
      if (argc == 3)
         strcpy(fileChars,argv[2]);
      RETURN;
   }
   strcpy(dateChar,"");
   ptr = argv[1];
      charType = 1;
      if (argc > 2)
      {
         if ( ! strcmp(argv[2],"file") )
         {
            charType = 1;
            defChars = fileChars;
         }
         else if ( ! strcmp(argv[2],"dir") )
         {
            charType = 1;
            strcpy(extraChars,fileChars);
            strcat(extraChars,"/");
            defChars = extraChars;
         }
         else if ( ! strncmp(argv[2],"alnum",5) )
         {
            charType = 1;
            if (strlen(argv[2]) > 5)
            {
               defChars = argv[2];
               strcpy(extraChars,defChars+5);
            }
            else
            {
               strcpy(extraChars,"");
            }
            defChars = extraChars;
         }
         else if ( ! strcmp(argv[2],"none") )
         {
            charType = 2;
         }
         else
         {
            charType = 3;
            defChars = argv[2];
         }
         if (argc > 3)
         {
            replaceTemplate = (argv[3][0] == 't') || (argv[3][0] == 'p');
            replacePair = (argv[3][0] == 't');
            if (argc > 4)
            {
                replaceChar = argv[4][0];
            }
         }
      }
      else
      {
         /* default is "dir" case */
         strcpy(extraChars,fileChars);
         strcat(extraChars,"/");
         defChars = extraChars;
      }
      if (replaceTemplate)
         currentDateLocal(dateChar, MAXPATH);
      strcpy(parlist,"");
      strcpy(reqlist,"");
      pptr = parstr;
      rptr = reqstr;
      plen = rlen = 1;  /* Set to 1 to save room for EOL */
      while (*ptr != '\000')
      {
         if ( replaceTemplate &&
              ( ((*ptr == '$') && strstr(ptr+2,"$")) ||
                ((*ptr == '$') && (*(ptr+1) == '$') &&  strstr(ptr+3,"$")) )  &&
              (slen = isParFeature(ptr+1, search_str, tmp2Str, MAXSTR)) )
         {
            ptr += slen + 2;  /* Skip two $-signs and length of parameter name */
  
            if (strlen(parlist))
               strcat(parlist," ");
            strcat(parlist,search_str);
            if ( ! strlen(tmp2Str) )
            {
               int rchar;
               if (strlen(reqlist))
                  strcat(reqlist," ");
               strcat(reqlist,search_str);
               if (replacePair)
                  rchar = '#';
               else
                  rchar = '$';
               sptr = search_str;
               if (rlen < MAXSTR)
                  *rptr++ = rchar;
               rlen++;
               while(*sptr != '\000')
               {
                  if (rlen < MAXSTR)
                     *rptr++ = *sptr;
                  sptr++;
                  rlen++;
               }
               if (rlen < MAXSTR)
                  *rptr++ = rchar;
               rlen++;
               *rptr='\000';
            }
            else
            {
               sptr = tmp2Str;
               while(*sptr != '\000')
               {
                  int newChar;

                  newChar = checkChar( *sptr, charType, defChars, replaceChar );
                  if ( (plen < MAXSTR) && newChar &&
                       ( (plen == 1) || (*(pptr-1) != newChar) || (newChar != replaceChar) ) )
                  {
                     *pptr++ = newChar;
                     plen++;
                     *pptr='\000';
                  }
                  if ( replacePair && (rlen < MAXSTR) && newChar &&
                       ( (rlen == 1) || (*(rptr-1) != newChar) || (newChar != replaceChar) ) )
                  {
                     *rptr++ = newChar;
                     rlen++;
                  }
                  sptr++;
               }
               if ( ! replacePair)
               {
                  sptr = search_str;
                  if (rlen < MAXSTR)
                     *rptr++ = '$';
                  rlen++;
                  while(*sptr != '\000')
                  {
                     if (rlen < MAXSTR)
                        *rptr++ = *sptr;
                     sptr++;
                     rlen++;
                  }
                  if (rlen < MAXSTR)
                     *rptr++ = '$';
                  rlen++;
                  *rptr='\000';
               }
            }
         }
         else if ( replaceTemplate && (*ptr == '%') &&
                   (slen = isTemplateFeature(ptr+1,dateChar,tmp2Str,MAXSTR)) )
         {
            if (slen > 0)  /* Not the %Rn% case */
            {
               sptr = tmp2Str;
               while(*sptr != '\000')
               {
                  int newChar;

                  newChar = checkChar( *sptr, charType, defChars, replaceChar );
                  if ( (plen < MAXSTR) && newChar &&
                       ( (plen == 1) || (*(pptr-1) != newChar) || (newChar != replaceChar) ) )
                  {
                     *pptr++ = newChar;
                     plen++;
                     *pptr='\000';
                  }
                  if ( replacePair && (rlen < MAXSTR) && newChar &&
                       ( (rlen == 1) || (*(rptr-1) != newChar) || (newChar != replaceChar) ) )
                  {
                     *rptr++ = newChar;
                     rlen++;
                  }
                  sptr++;
               }
               if ( ! replacePair )
               {
                  int tmp;

                  for (tmp=0; tmp < slen+2; tmp++)
                  {
                     if (rlen < MAXSTR)
                        *rptr++ = *(ptr+tmp);
                     rlen++;
                  }
                  *rptr='\000';
               }
               ptr += slen + 2;  /* Skip two %-signs and length of keyword name */
            }
            else /* The %Rn% case; slen is negative */
            {
               int tmp;

               for (tmp=0; tmp < 2-slen; tmp++)
               {
                  if (plen < MAXSTR)
                     *pptr++ = *(ptr+tmp);
                  plen++;
                  if (rlen < MAXSTR)
                     *rptr++ = *(ptr+tmp);
                  rlen++;
               }
               *rptr='\000';
               *pptr='\000';
               ptr += 2 - slen;  /* Skip two %-signs and length of keyword name */
            }
         }
         else
         {
            int newChar;

            newChar = checkChar( *ptr, charType, defChars, replaceChar );
            if ( (plen < MAXSTR) && newChar &&
                 ( (plen == 1) || (*(pptr-1) != newChar) || (newChar != replaceChar) ) )
            {
               *pptr++ = newChar;
               plen++;
               *pptr='\000';
            }
            if ( (rlen < MAXSTR) && newChar &&
                 ( (rlen == 1) || (*(rptr-1) != newChar) || (newChar != replaceChar) ) )
            {
               *rptr++ = newChar;
               rlen++;
            }
            ptr++;
         }
      }
      *pptr='\000';
      *rptr='\000';
   if (retc < 1)
      Winfoprintf( "%s substituted template: %s",argv[0],parstr );
   else
   {
      retv[0] = newString(parstr);
      if (retc > 1)
      {
         retv[1] = newString(reqstr);
         if (retc > 2)
         {
            retv[2] = newString(parlist);
            if (retc > 3)
            {
               retv[3] = newString(reqlist);
            }
         }
      }
   }
   RETURN;
}

/* Save au arguments for use by the au command when called from automation
 * If called with arguments, it saves the arguments. If called without arguments
 * it removed pre-exixting argments (save as no arguments)
 */
int auargs(int argc, char *argv[], int retc, char *retv[])
{
   char path[MAXPATH];
   char autodir[MAXPATH];

   if (mode_of_vnmr != AUTOMATION)
      RETURN;
   if (getparm("autodir","string",GLOBAL,autodir,MAXPATH))
      RETURN;
   strcpy(path,autodir);
   strcat(path,"/auargs");
   if (argc == 1)
   {
      unlink(path);
   }
   else
   {
      FILE *fd;
      int index = 1;

      fd = fopen(path,"a");
      while (index < argc)
      {
         fprintf(fd,"%s\n",argv[index]);
         index++;
      }
      fclose(fd);
   }
   RETURN;
}


#ifdef  DEBUG
/***********************************/
static int Wtimeprintf(int mode, char *control, char *time)
/***********************************/
{
  struct tm      *tmtime;
  struct timeval  clock;
  time_t          timedate;
  char           *chrptr;
  char            datetim[26];
  static time_t   savetime = 0;

  gettimeofday(&clock, NULL);
  timedate = clock.tv_sec;
  if (mode == 0)
    savetime = timedate;
  else if (mode < 0)
  {
    timedate -= savetime;
    sprintf(datetim,"%ld",timedate);
  }
  else
  {
    tmtime = localtime(&(timedate));
    chrptr = asctime(tmtime);
    strcpy(datetim,chrptr);
    datetim[24] = '\0';
    if (time)
      strcpy(time,datetim);
  }
  if (control && mode)
    Wscrprintf(control,datetim);
  return(timedate);
}
#endif 

int
is_psg4acqi()
{
	return( 0 );	/* if called from VNMR, the PSG program is NOT being run for ACQI */
}

static int fireUpJPSG()
{
/*
    int result;
 */
    int trys = 30;  /* 30 seconds for Java VM to up and running Jpsg */

    /* printf("Reading Jpsg Port # ---  "); */
    if ( ! isJpsgReady() )
    {
        char cmd[256];
        int RevID = 5;
        int ret;

       /*
        sprintf(cmd,"/usr25/greg/projects/NewPSG/java/code/jpsg/Jpsg %d %d &",
                RevID,HostPid);
        */
        sprintf(cmd,"%s/jpsg/Jpsg %d %ld &",
                systemdir,RevID,(long) HostPid);
        /* printf("fireUpJPSG: No file, Starting Jpsg\n"); */
        /* system("/vnmr/jpsg/Jpsg 5 8195 1 &"); */
        /*printf("fireUpJPSG: system('%s')\n",cmd); */

        /* result = system(cmd); */

        child = fork(); 

        if (child < 0)
        {   Werrprintf("GO: could not create a Java PSG process!");
            /* if (!acqi_fid) */
              release_console();
	    ABORT;
        }

        psg_pid = child;  /* set global psg pid value */


        if (child)	/* if parent set signal handler to reap process */
            set_wait_child(child);

        if (child == 0)
        {	
           char cmd[256];
           char RevIdStr[256];
           char pidstr[256];
           char Arg1[256];
           char Arg2[256];
           mode_t oldMask;

           sprintf(cmd,"%s/jpsg/Jpsg",systemdir);
           oldMask = umask(0);
           sprintf(Arg1,"-Duser.umask=%d",oldMask);
           umask(oldMask);
           sprintf(Arg2,"-Duser.hostname=%s",HostName);
           sprintf(RevIdStr,"%d",RevID);
           sprintf(pidstr,"%ld", (long) HostPid);
           /* set_effective_user(); */
    
            ret = execlp("java","java",Arg1,Arg2,"Jpsg",RevIdStr,pidstr,NULL);
            /* ret = execlp(cmd,"Jpsg",RevIdStr,pidstr,NULL); */
            /* execlp("/vnmr/jpsg/Jpsg","Jpsg",RevIdStr,pidstr,NULL); */
	    Werrprintf("java could not execute");
        }


	/*
        if (result == -1)
        {
	    perror("fireUpJPSG: system(): ");
	    ABORT;
        }
	*/
        sleep(1);
        while(trys)
        {
           if (isJpsgReady())
              break;
           trys--;
           sleep(1);
        }

        return(0);
    }
    else
    {
        /* printf("fireUpJPSG: file found\n"); */
        return(0);
    }
}    

int isJpsgReady()
{
    FILE *sd;
    int numconv;
    char portstr[50];
    char pidstr[50];
    char hostname[50];
    char readymsge[50];
    char jpsgPIDFileName[MAXSTR];
    int isReady = 0;
    int alive,pid;

    strcpy(jpsgPIDFileName,"/vnmr/acqqueue/jinfo1.");
    strcat(jpsgPIDFileName,UserName);

    if (access(jpsgPIDFileName,R_OK) == 0)
    {
       sd = fopen(jpsgPIDFileName,"r");
       numconv = fscanf(sd,"%s %s %s %s",portstr,pidstr,hostname,readymsge);
       fclose(sd);
       if (numconv == 4)
       { 
	 /*
         printf("conv: %d, port: '%s', pid: '%s', host: '%s', rdymsge: '%s'\n",
                        numconv, portstr,pidstr,hostname,readymsge);
         */
         if (strcmp(readymsge,"ready") == 0)
         {
            pid = atoi(pidstr);
            alive = kill(pid,0);
            isReady = ((alive == -1) && (errno == ESRCH)) ? 0 : 1;
            /* printf("isJpsgReady() pid: %d, alive: %d\n",pid,isReady); */
         }
         else
             isReady = 0;
       } 
       else
         isReady = 0;
   }
   return(isReady);
}
 

Socket* connect2Jpsg(int port, char *host)
{
   int      ival;
   Socket  *tSocket;
   int trys;
 
   tSocket = createSocket( SOCK_STREAM );
   if (tSocket == NULL) {
       printf( "Cannot create local socket\n" );
       return( NULL );
   }
 
   ival = openSocket( tSocket );
   if (ival != 0) {
      printf( "Cannot open socket\n" );
      free(tSocket);
      return( NULL );
   }    
        
   trys = 7;
   while(trys--)
   {    
     /* printf("Try to Connect: '%s' port: %d trys left#: %d\n",host, port, trys); */
     ival = connectSocket( tSocket, host, port );
     if (ival == 0)
        break;
     sleep(1);
   }
 
   if (ival != 0)
   {
       closeSocket(tSocket);
       free(tSocket);
       return(NULL);
   }
   return(tSocket);
}
int initacqqueue(int argc, char *argv[])
{
   return(-1);
}
