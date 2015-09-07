/*
 * Copyright (C) 2015  Stanford University
 *
 * You may distribute under the terms of either the GNU General Public
 * License or the Apache License, as specified in the README file.
 *
 * For more information, see the README file.
 */
/* Copyright (c) Varian Assoc., Inc.  All Rights Reserved. */
#define FMAX 40
#define EXPMAXDIGS 8
#define EXPMAX 99999999
/* FMAX = max number of nonzero digits passed to atof() */
/* EXPMAX = 10^EXPMAXDIGS - 1 = largest allowed exponent absolute value */

#ifdef V10 /* Research Tenth-Edition Unix */
#include "local.h"
#endif

/* MAXFRACDIGS and MAXINTDIGS are for wrt_F -- bounds (not necessarily
   tight) on the maximum number of digits to the right and left of
 * the decimal point.
 */

#ifdef VAX
#define MAXFRACDIGS 56
#define MAXINTDIGS 38
#else
#ifdef CRAY
#define MAXFRACDIGS 9880
#define MAXINTDIGS 9864
#else
/* values that suffice for IEEE double */
#define MAXFRACDIGS 344
#define MAXINTDIGS 308
#endif
#endif
