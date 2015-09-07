/*
 * Copyright (C) 2015  Stanford University
 *
 * You may distribute under the terms of either the GNU General Public
 * License or the Apache License, as specified in the README file.
 *
 * For more information, see the README file.
 */
/* sendcmds.c - Table of commands & function calls */
#ifndef LINT
static char SCCSid[] = "sendcmds.c Copyright (c) 1994-2000 Varian Inc. All Rights Reserved";
#endif
/* 
 * Varian Inc. All Rights Reserved.
 * This software contains proprietary and confidential
 * information of Varian Inc. and its contributors.
 * Use, disclosure and reproduction is prohibited without
 * prior consent.
 */

#include <stdio.h>
#include "parser.h"


/* ------------- Make C header file C++ compliant ------------------- */
#ifdef __cplusplus
extern "C" {
#endif

/* commands MUST be alphabetized */
extern int abortCodes();
extern int debugLevel();
extern int listCmds();
extern int mapIn();
extern int mapOut();
extern int sendCmd();
extern int sendCodes();
extern int sendTables();	
extern int sendDelTables();	
extern int sendVME();
extern int terminate();
 
cmd table[] = { 
    {"?"	, listCmds, 	"List Known Commands" },
    {"command"	, sendCmd, 	"Pass a command to another parser" },
    {"debug"	, debugLevel, 	"Changed Debug Level" },
    {"mapin"	, mapIn, 	"Map in a Shared Memory Segment" },
    {"mapout"	, mapOut, 	"Map out a Shared Memory Segment" },
    {"send"	, sendCodes, 	"Download acodes" },
    {"tables"	, sendTables, 	"Download named buffers" },
    {"tabledel"	, sendDelTables,  "Download and delete named buffers" },
    {"term"	, terminate, 	"Terminate Sendproc" },
    {"vme"	, sendVME,	"send stuff to a location on the VME" },
    {NULL	,  NULL, 	NULL    }
              };


/**************************************************************
*
*  sizeOfCmdTable - return size of Cmd Table 
*
* RETURNS:
* size of cmd table
*
*	Author Greg Brissey 10/5/94
*/
sizeOfCmdTable()
{
   return(sizeof(table));
}

/**************************************************************
*
*  addrOfCmdTable - returns address of Cmd Table 
*
* RETURNS:
* address of cmd table
*
*	Author Greg Brissey 10/5/94
*/
cmd *addrOfCmdTable()
{
   return(table);
}

#ifdef __cplusplus
}
#endif

