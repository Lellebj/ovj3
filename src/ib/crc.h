/*
 * Copyright (C) 2015  Stanford University
 *
 * You may distribute under the terms of either the GNU General Public
 * License or the Apache License, as specified in the README file.
 *
 * For more information, see the README file.
 */
/* Copyright (c) Varian Assoc., Inc.  All Rights Reserved. */

#ifndef CRC_H_DEFINED
#define CRC_H_DEFINED

typedef unsigned long tcrc;      /* type of crc value -- same as in brik.c */

#define INITCRC 0xFFFFFFFFL

#if defined(__STDC__) && ! defined (__cplusplus) && ! defined (c_plusplus)

extern tcrc addbfcrc (register char *buf, register int size);

#elif defined(__cplusplus) || defined(c_plusplus)

extern "C" tcrc addbfcrc (register char *buf, register int size);

#else

extern tcrc addbfcrc();

#endif

#endif