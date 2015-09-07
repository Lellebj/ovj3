/*
 * Copyright (C) 2015  Stanford University
 *
 * You may distribute under the terms of either the GNU General Public
 * License or the Apache License, as specified in the README file.
 *
 * For more information, see the README file.
 */
/*
 * Varian,Inc. All Rights Reserved.
 * This software contains proprietary and confidential
 * information of Varian, Inc. and its contributors.
 * Use, disclosure and reproduction is prohibited without
 * prior consent.
 */

#ifndef INCFidStatBufh
#define INCFidStatBufh

#include <pthread.h>

/* ------------- Make C header file C++ compliant ------------------- */
#ifdef __cplusplus
extern "C" {
#endif

/* HIDDEN */

/* typedefs */

#define FALSE 0
#define TRUE 1

typedef struct          /* FID Stat Block Buffer Object */
    {
       int numBuffers;
       RINGBLK_ID pBlkRng;	/* block ring buffer of addresses */
       int bufSize;        /* size of ring in elements */
       FID_STAT_BLOCK* pBuffers;
    } FIDSTAT_BLKBUF;

/* END_HIDDEN */

typedef FIDSTAT_BLKBUF  *FIDSTATBUF_ID;

/* --------- ANSI/C++ compliant function prototypes --------------- */

/* function declarations */

#if defined(__STDC__) || defined(__cplusplus)

 
extern FIDSTATBUF_ID fidStatBufCreate(int number);
extern int fidStatPut(FIDSTATBUF_ID pFidStats, FID_STAT_BLOCK* *bufAddr);
extern int fidStatGet(FIDSTATBUF_ID pFidStats, FID_STAT_BLOCK* *bufAddr);
 
#endif  /* __STDC__ */
 
#ifdef __cplusplus
}
#endif

#endif /* INCrngBlkLibh */
