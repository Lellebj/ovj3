// Copyright (C) 2015  Stanford University
// You may distribute under the terms of either the GNU General Public
// License or the Apache License, as specified in the README file.
// For more information, see the README file.
/* 
 * Varian Assoc.,Inc. All Rights Reserved.
 * information of Varian Assoc., Inc. and its contributors.
 */

/*  s2pul - standard two-pulse sequence */

#include <standard.h>

pulsesequence()
{
   double dqdfrq;

   dqdfrq = getval("dqdfrq");

   /* equilibrium period */
   status(A);
   obsoffset(tof);
   hsdelay(d1);

   /* --- tau delay --- */
   status(B);
   pulse(p1, zero);
   hsdelay(d2);

   /* --- observe period --- */
   status(C);
   pulse(pw,oph);
   obsoffset(tof+dqdfrq);
}
