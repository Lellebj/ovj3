/*
 * Copyright (C) 2015  Stanford University
 *
 * You may distribute under the terms of either the GNU General Public
 * License or the Apache License, as specified in the README file.
 *
 * For more information, see the README file.
 */
/* Copyright (c) Varian Assoc., Inc.  All Rights Reserved. */
#include "stdio.h"
#include "f2c.h"

#ifdef KR_headers
extern VOID sig_die();

int abort_()
#else
extern void sig_die(char*,int);

int abort_(void)
#endif
{
sig_die("Fortran abort routine called", 1);
#ifdef __cplusplus
return 0;
#endif
}
