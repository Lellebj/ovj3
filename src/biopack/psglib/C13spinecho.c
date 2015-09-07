#ifndef LINT
static char SCCSid[] = "@(#)s2pul.c 18.1 06/25/04 Copyright (c) 1991-1996 Agilent Technologies All Rights Reserved";
#endif

/*  C13spinecho   */

#include <standard.h>

pulsesequence()
{
  double pwClvl,gzlvl1,gt1;
  gzlvl1=getval("gzlvl1"); gt1=getval("gt1");
  pwClvl=getval("pwClvl");
    add(oph,one,v1);
   /* equilibrium period */
   status(A);
   obspower(pwClvl);
   hsdelay(d1);

   /* --- tau delay --- */
   status(B);
   rgpulse(pw, oph,rof1,0.0);
   txphase(zero);
   zgradpulse(gzlvl1,gt1);
   delay(d2-gt1);
   rgpulse(p1,v1,0.0,0.0);
   zgradpulse(gzlvl1,gt1);
   delay(d2-gt1);
  status(C);
}
