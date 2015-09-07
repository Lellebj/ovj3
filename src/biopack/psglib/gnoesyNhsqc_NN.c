/*  gnoesyNhsqc_NN.c for Heterodimer studies
    has been temporarily removed for pulse sequence revision
*/

#ifndef LINT
static char SCCSid[] = "@(#)s2pul.c 18.1 06/25/04 Copyright (c) 1991-1996 Agilent Technologies All Rights Reserved";
#endif

/*  s2pul - standard two-pulse sequence */

#include <standard.h>

pulsesequence()
{
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
