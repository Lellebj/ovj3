/*
 * Copyright (C) 2015  Stanford University
 *
 * You may distribute under the terms of either the GNU General Public
 * License or the Apache License, as specified in the README file.
 *
 * For more information, see the README file.
 */
/* 
 * Varian, Inc. All Rights Reserved.
 * This software contains proprietary and confidential
 * information of Varian, Inc. and its contributors.
 * Use, disclosure and reproduction is prohibited without
 * prior consent.
 */
#include "rfconst.h"

#define CTXON   16                     /* 13C tx gate line */
#define HTXON   128                    /*  1H tx gate line */
extern int	cardb;
extern int	indirect;

/* the following functions work only if they are followed by a delay */
/* they are here in HMQC					     */
decon()
{
   if (!indirect)
      gate(HTXON,TRUE);
   else
      gate(CTXON,TRUE);
}

xmtron()
{
   if (cardb)
      gate(CTXON,TRUE);
   else
      gate(HTXON,TRUE);
}

decoff()
{
   if (!indirect)
      gate(HTXON,FALSE);
   else
      gate(CTXON,FALSE);
}

xmtroff()
{
   if (cardb)
      gate(CTXON,FALSE);
   else
      gate(HTXON,FALSE);
}

