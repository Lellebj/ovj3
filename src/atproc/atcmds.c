/*
 * Copyright (C) 2015  Stanford University
 *
 * You may distribute under the terms of either the GNU General Public
 * License or the Apache License, as specified in the README file.
 *
 * For more information, see the README file.
 */

#include <stdio.h>
#include "parser.h"

/* ------------- Make C header file C++ compliant ------------------- */
#ifdef __cplusplus
extern "C" {
#endif

/* Commands MUST be alphabetized */
extern int debugLevel();
extern int atcmd();
extern int listCmds();
extern int terminate();
 
cmd table[] = { 
    {"term"     , terminate,    "Terminate Sendproc" },
    {"debug"    , debugLevel,   "Changed Debug Level" },
    {"atcmd"	, atcmd,        "Check for atcmd events" },
    {"?"        , listCmds,     "List Known Commands" },
    {NULL       , NULL,         NULL }
};

/************************************************************************
 *
 * sizeOfCmdTable - return size of Cmd Table 
 *
 * RETURNS:
 * size of cmd table
 *
 * Author Greg Brissey 10/5/94
 *
 ************************************************************************/
int sizeOfCmdTable(void)
{
    return(sizeof(table));
}

/************************************************************************
 *
 * addrOfCmdTable - returns address of Cmd Table 
 *
 * RETURNS:
 * address of cmd table
 *
 * Author Greg Brissey 10/5/94
 *
 ************************************************************************/
cmd *addrOfCmdTable(void)
{
    return(table);
}

#ifdef __cplusplus
}
#endif
