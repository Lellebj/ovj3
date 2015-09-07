/*
 * Copyright (C) 2015  Stanford University
 *
 * You may distribute under the terms of either the GNU General Public
 * License or the Apache License, as specified in the README file.
 *
 * For more information, see the README file.
 */
/* Copyright (c) Varian Assoc., Inc.  All Rights Reserved. */

/* 
 * Varian Assoc.,Inc. All Rights Reserved.
 * This software contains proprietary and confidential
 * information of Varian Assoc., Inc. and its contributors.
 * Use, disclosure and reproduction is prohibited without
 * prior consent.
 */

#ifndef MAGICAL_CMDS_H
#define MAGICAL_CMDS_H



/*-------------------------------------------------------------------------
|	commands.h
|
|	This include file contains the names, addresses, and other
|	information about all commands.
+-------------------------------------------------------------------------*/
#include <stdio.h>

struct _cmd {
    char   *name;
    int   (*func)();
};
typedef struct _cmd cmd;

extern int (*getBuiltinFunc())();

#endif /* MAGICAL_CMDS_H */
