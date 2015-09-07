/*
 * Copyright (C) 2015  University of Oregon
 *
 * You may distribute under the terms of either the GNU General Public
 * License or the Apache License, as specified in the README file.
 *
 * For more information, see the README file.
 */
/* 
*/
/*-----------------------------------------------------------------------
|
|   makeprintcap
|
|   This program creates a custom /etc/printcap file for the system.
|   It first makes a copy of the base part of /etc/printcap file that
|   contains system printcap entries and basic vnmr printcap entries.
|   It then reads the devicenames file and creates an entry in the 
|   /etc/printcap corresponding to the type, port number and baud rate.
|
|   This program must be run after the file device tables (located in
|   the `sysdir` directory) has been modified.
|
+------------------------------------------------------------------------*/
#include <stdio.h>
#include <string.h>

int    Tflag = 0;
int    varian_pc;
char   varpcfile[128];

#define PRINTCAP "/etc/printcap"

main(argc,argv)  int argc;  char *argv[];
{  char         Baud[22];
   char         filepath[512];   
   char         Host[128];
   char         hostname[128];
   char         line[1024];
   char         Name[128];
   char         plotname[128];
   char         Port[22];
   char         psfilter[128];
   char        *p;
   char        *pcentry;
   char        *pport;
   char         Shared[10];
   char         Type[22];
   char         Use[22];
   char		sdir[120];
   char		cmd[140];
   int          parallel;
   extern char *findPrintcapEntry();
   FILE        *namesinfo;
   FILE        *pc;    /* printcap file */
   FILE        *temp;  /* temp printcap */

   switch (argc)
   {  case 2: Tflag = 0;
	      break;
      case 3: if (!strcmp(argv[2],"-t"))
		 Tflag = 1;
              break;
      default: printf("Usage -- makeprintcap vnmrsystemdir [-t]\n");
	       return 1;
	      break;
   }

   if(!precheck_printcap())  /* can not open PRINTCAP */
	return(1);
   system("cp /etc/printcap /etc/printcap.backup");
   if (!varian_pc)  /* it is the orignal UNIX printcap */
      sprintf(varpcfile,"%s/user_templates/printcap", argv[1]);
   else
      sprintf(varpcfile, PRINTCAP);
   sprintf(psfilter, "%s/bin/psfilter", argv[1]);
   gethostname(hostname,126);
      
   if (temp = fopen("/tmp/printcap","w"))
   {  if (Tflag)
	 fprintf(stderr,"makeprintcap: opened /tmp/printcap\n");
      if ((pc = fopen(varpcfile,"r")) == NULL)
          pc = fopen(PRINTCAP, "r");
      if (pc)
      {  if (Tflag)
	    fprintf(stderr,"makeprintcap: opened %s\n",PRINTCAP);
         /* read and copy to temp file the base part of printcap */
	 p = fgets(line,1023,pc);
	 while (p)
	 {  fputs(line,temp); /* write out to temp */
	    if (!strncmp(p,"########## END OF BASE SECTION",30))
		break;
	    p = fgets(line,1023,pc);
	 }
	 if (Tflag)
	    fprintf(stderr,"makeprintcap: finished base part of printcap\n");
	 /*  Base part is now copied over, lets work on devicenames */
	 fputs("############################################################################\n",
	       temp);
         fputs("#######   Begining of Custom Section  #######\n",temp);
 
         /* open the devicenames file */
         sprintf(filepath,"%s/devicenames",argv[1]);
         if (namesinfo=fopen(filepath,"r"))
         {  if (Tflag)
            fprintf(stderr,"makeprintcap: opened file '%s'\n",filepath);
            /* find entry in table corresponding to name */
            p = fgets(line,1023,namesinfo);
            while (p)
            {  
	       Name[0] = '\0';
	       Use[0] = '\0';
	       Type[0] = '\0';
	       Host[0] = '\0';
	       Port[0] = '\0';
	       if (!strncmp(p,"Name",4))/* check if we are at Name */
               {  sscanf(p,"%*s%s",Name); /* get name from file */
                  if (!(p = fgets(line,1023,namesinfo)))
                  {  printf("Bad devicenames file\n");
                     fclose(namesinfo);
                     exit(1);
                  }
                  sscanf(p,"%*s%s",Use); /* get Use */
                  if (!(p = fgets(line,1023,namesinfo)))
                  {  printf("Bad devicenames file\n");
                     fclose(namesinfo);
                     exit(1);
                  }
                  sscanf(p,"%*s%s",Type); /* get type */
                  if (!(p = fgets(line,1023,namesinfo)))
                  {  printf("Bad devicenames file\n");
                     fclose(namesinfo);
                     return 0;
                  }
                  sscanf(p,"%*s%s",Host);
                  if (!(p = fgets(line,1023,namesinfo)))
                  {  printf("Bad devicenames file\n");
                     fclose(namesinfo);
                     return 0;
                  }  
                  sscanf(p,"%*s%s",Port);
                  if (!(p = fgets(line,1023,namesinfo)))
                  {  printf("Bad devicenames file\n");
                     fclose(namesinfo);
                     return 0;
                  }  
                  sscanf(p,"%*s%s",Baud);
                  if (!(p = fgets(line,1023,namesinfo)))
                  {  printf("Bad devicenames file\n");
                     fclose(namesinfo);
                     return 0;
                  }  
                  sscanf(p,"%*s%s",Shared);
                  if (Tflag)
                     fprintf(stderr,"setprintcap:name=%s use=%s type=%s host=%s port=%s baud=%s and shared=%s \n",
                         Name,Use,Type,Host,Port,Baud,Shared);
		  if (Name[0] == '\0' || Use[0] == '\0' || Type[0] == '\0' || Host[0] == '\0')
			continue;
		  if (!strcmp(hostname,Host) && Port[0] == '\0')
		  {
		     fprintf(stderr,"Error: %s's port is null\n", Name);
		     continue;
		  }
                  /* Find base printcap entry for device type */
                  if (pcentry = findPrintcapEntry(Type,argv[1]))
                  {  /* Build printcap entry */
		     fprintf(temp,"\n");
		     fprintf(temp,"#######  Entry for %s\n",Name);
		     fprintf(temp,"%s| entry for %s type %s:\\\n",Name,Name,Type);
		     pport = strrchr(Port, '/');
		     if (pport)
                        sprintf(sdir,"/usr/spool/%s_%s", Host, pport+1);
		     else	
                        sprintf(sdir,"/usr/spool/%s_%s", Host, Port);
		     if (strcmp(hostname,Host))
		     {  /* remote device */
		        fprintf(temp,"     :lp=:rm=%s:\\\n",Host);
		        fprintf(temp,"     :rp=%s:\\\n",Name);
 			fprintf(temp,"     :sd=%s:\n", sdir);
		     }
		     else
		     {  /* local device */
		        fprintf(temp,"     :lp=%s:\\\n",Port);
		        if (!strcmp(Type, "PS_A") || !strcmp(Type, "PS_AR"))
		           fprintf(temp,"     :if=%s:\\\n",psfilter);
			parallel = 0;
		        if (pport)
                        {
			   pport++;
                           if (strstr(pport, "pp") != NULL) /* parallel port */
				parallel = 1;
			}
			if (parallel)
			{
 			   fprintf(temp,"     :sd=%s:\\\n", sdir);
 			   fprintf(temp,"     :sf:\\\n");
 			   fprintf(temp,"     :sh:\n");
			}
			else
			{
		           fprintf(temp,"     :br#%s:\\\n",Baud);
 			   fprintf(temp,"     :sd=%s:\\\n", sdir);
		           fprintf(temp,"     :tc=%s:\n",pcentry);
			}
		     }
      		     if (access(sdir, 0) != 0)
		     {  /* make spooling directory */
                        sprintf(cmd, "mkdir %s", sdir);
  			system(cmd);
			sprintf(cmd, "chmod 777 %s", sdir);
			system(cmd);
			sprintf(cmd, "chown daemon %s", sdir);
			system(cmd);
                        sprintf(cmd, "chgrp daemon %s", sdir);
                        system(cmd);
		     }
                  }  
		  else
		  {  fclose(temp);
		     fclose(pc);
		     fclose(namesinfo);
		     return 0;
		  }
               }     
               p = fgets(line,1023,namesinfo);
            }     
	    fclose(namesinfo);
	    fclose(pc);
	    fclose(temp);
	    /* now copy temp to printcap */
	    sprintf(line,"cp /tmp/printcap %s\n",PRINTCAP);
	    system(line);
	    if (Tflag)
	       fprintf(stderr,"makeprintcap: exec system cmd '%s'\n",line);
	    system("rm /tmp/printcap");
	    if (Tflag)
	       fprintf(stderr,"makeprintcap: removing tmp file\n");
	    printf("Created Printcap\n");
         }
	 else
         {  printf("Sorry, unable to open '%s' devicename file\n",filepath);
	    fclose(temp);
	    fclose(pc);
            return 0;
         }
      }
      else
      {  printf("Sorry, unable to open %s file\n",PRINTCAP);
	 fclose(temp);
	 system("rm /tmp/printcap");
	 return 1;
      }
   }
   else
   {   printf("Sorry, unable to open temp file /tmp/printcap\n");
       return 1;
   }
}

/*----------------------------------------------------------------------
|   findPrintcapEntry
|
|   This routine reads the devicetable file and looks for the printcap
|   base entry name for the device type
|
+------------------------------------------------------------------------*/
char *findPrintcapEntry(type,dir)   char *type; char *dir;
{  char         filepath[128];
   char        *p;
   char         plotype[128];
   char         s[1024];
   FILE        *plotinfo;
   static char  printcap[128];

   /* open the devicetable file */
   sprintf(filepath,"%s/devicetable",dir);
   if (plotinfo=fopen(filepath,"r"))
   {  if (Tflag)
	 fprintf(stderr,"findPrintcapEntry: opened file '%s'\n",filepath);
      /* find entry in table corresponding to type */
      p = fgets(s,1023,plotinfo);
      while (p)
      {  if (!strncmp(p,"PrinterType",11))/* check if we are at type */
	 {  sscanf(p,"%*s%s",plotype); /* get type from file */
	    if (!strcmp(plotype,type)) /* if it is , load in parameters */
            {  if (!(p = fgets(s,1023,plotinfo)))
	       {  printf("Bad devicetable file");
		  fclose(plotinfo); return NULL;
	       }
	       sscanf(p,"%*s%s",printcap);
	       if (Tflag)
		  fprintf(stderr,"findPrintcapEntr: pc=%s\n",
		  printcap);
               fclose(plotinfo);
	       return printcap;
	    }
	 }
         p = fgets(s,1023,plotinfo);
      }
      printf("Could not find entry '%s' in devicetable\n",type);
      fclose(plotinfo);
      return NULL;
   }
   else
   {  printf("Could not open devicetable file\n");
      return NULL;
   }
}

int
precheck_printcap()
{
      FILE  *fd;
      char  *pp, line[1024];

      varian_pc = 0;
      if ((fd = fopen(PRINTCAP,"r")) == NULL)
      {  printf("Sorry, unable to open %s file\n",PRINTCAP);
	 return(0);
      }
      pp = fgets(line,1023,fd);
      while (pp)
      {
            if (strncmp(pp,"########## END OF BASE SECTION",30))
	        pp = fgets(line,1023,fd);
	    else
	    {
		varian_pc = 1;
		break;
	    }
      }
      fclose(fd);
      return(1);
}

