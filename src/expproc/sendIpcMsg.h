/*
 * Copyright (C) 2015  Stanford University
 *
 * You may distribute under the terms of either the GNU General Public
 * License or the Apache License, as specified in the README file.
 *
 * For more information, see the README file.
 */

#ifndef INCsendipcmsgh
#define INCsendipcmsgh
#include "ipcKeyDbm.h"

/* ------------- Make C header file C++ compliant ------------------- */
#ifdef __cplusplus
extern "C" {
#endif


/* --------- ANSI/C++ compliant function prototypes --------------- */

#if defined(__STDC__) || defined(__cplusplus)                          

int sendMsg(IPC_KEY_DBM_ID dbmId,int process, char* message, int priority, int waitflg);

#else                                  
/* --------- NON-ANSI/C++ prototypes ------------  */
 
int sendMsg();
 
#endif
 

#ifdef __cplusplus
}
#endif                   

#endif 
