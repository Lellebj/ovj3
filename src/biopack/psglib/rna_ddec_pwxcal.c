#ifndef LINT
static char SCCSid[] = "@(#)pwxcal.c 10.1 2/15/95 Copyright (c) 1991-1993 Agilent Technologies All Rights Reserved";
#endif
/* 
 * Agilent Technologies All Rights Reserved.
 * This software contains proprietary and confidential
 * information of Agilent Technologies and its contributors.
 * Use, disclosure and reproduction is prohibited without
 * prior consent.
 */

/*
  Parameters:

        pw = 90 degree excitation pulse on the observe transmitter
        pwx1 = 90 degree excitation pulse on first decoupler
        pwx2 = 90 degree excitation pulse on second decoupler
        pwx3 = 90 degree exc        pulse    third  dec
      jC13 = J(C13-H1) coupling constant
      jN15 = J(N15-H1) coupling constant
      jP31 = J(P31-H1) coupling constant
      jname identifies the nucleus of interest

 */
#include <standard.h>

pulsesequence()
{
   double pwx1;
   double pwx2;
   double pwx3;
   double jtau;
   char   jname[MAXSTR];
   char   jval[MAXSTR];

 
   pwx1 = getval("pwx1");
   pwx2 = getval("pwx2");
   pwx3 = getval("pwx3");
   getstr("jname",jname);
   strcpy(jval,"j");
   strcat(jval,jname);
   jtau = 1.0 / (2.0 * getval(jval) );

   mod4(ct, v1);		/*  v1 = 0 1 2 3 */
   dbl(v1, v10);		/* v10 = 0 2 0 2 */
   hlv(ct, v2);
   hlv(v2, v2);
   mod4(v2, v2);		/* v2 = 0 0 0 0 1 1 1 1 2 2 2 2 3 3 3 3 */
   add(v2, v1, v1);
   assign(v2, oph);
   add(v10, oph, oph);

   status(A);
   hsdelay(d1);

   status(B);
   rgpulse(pw, v2, rof1, rof1);
   jtau -= pw + rof2;
   delay(jtau - rof1);
   sim4pulse(0.0, pwx1, pwx2, pwx3,   v1, zero, zero, zero,  rof1, rof2);

   status(C);
}
