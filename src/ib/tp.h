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
 * Varian, Inc. All Rights Reserved.
 * This software contains proprietary and confidential
 * information of Varian, Inc. and its contributors.
 * Use, disclosure and reproduction is prohibited without
 * prior consent.
 */

static char *help_msg[] = {
   "",
   "?  display command summary",
   "q  quit",
   "i  name for input parameter file",
   "l  load parameter file",
   "e  existence of parameter",
   "b  basic type of parameter",
   "s  get parameter sub-type",
   "S  set parameter sub-type",
   "v  get parameter value",
   "V  set parameter value",
   "B  get all parameter values",
   "E  get all parameter enumerated values",
   "a  get parameter activity state",
   "A  set parameter activity state",
   "p  get parameter protection bits",
   "P  set parameter protection bits",
   "g  get parameter groups",
   "G  set parameter groups",
   "x  get parameter min/max/step",
   "X  set parameter min/max/step",
   "n  get number of parameter values",
   "N  get number of parameter enumerated values",
   "d  delete parameter",
   "o  name for output parameter file ",
   "w  write parameter file",
   "c  clear parameter set",
   "r  release parameter set",
#ifdef DEBUG_ALLOC
   "m  memory used",
#endif
   ""
};

static int help_size = sizeof (help_msg) / sizeof (help_msg[0]);
