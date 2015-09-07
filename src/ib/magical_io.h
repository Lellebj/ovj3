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

#ifndef MAGICAL_IO_H
#define MAGICAL_IO_H

#include <stdio.h>

char *magicBp;
node *magicCodeTree;
int magicColumnNumber;
extern char magicFileName[];
int magicFromFile;
int magicFromString;
int magicLineNumber;
char magicMacroBuffer[1024];
FILE *magicMacroFile;
char *magicMacroBp;
int magicInterrupt;
int magicWorking;
char **magicMacroDirList;

#endif /* MAGICAL_IO_H */
