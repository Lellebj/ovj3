// Copyright (C) 2015  Stanford University
// You may distribute under the terms of either the GNU General Public
// License or the Apache License, as specified in the README file.
// For more information, see the README file.
/* 
 * Varian, Inc. All Rights Reserved.
 * information of Varian, Inc. and its contributors.
 */
/*  HOMODEC - standard two-pulse sequence for
		homonuclear decoupling
		Forces the value of dmm and homo parameters 

*/

#include <standard.h>

pulsesequence()
{
   char homo[MAXSTR];

   strcpy(dmm, "ccc");
   strcpy(homo, "y");

   /* equilibrium period */
   status(A);
   hsdelay(d1);

   /* --- tau delay --- */
   status(B);
   pulse(p1, zero);
   hsdelay(d2);

   /* --- observe period --- */
   status(C);
   pulse(pw,oph);
}
