// Copyright (C) 2015  University of Oregon
// You may distribute under the terms of either the GNU General Public
// License or the Apache License, as specified in the README file.
// For more information, see the README file.
/* 
 */
/* Xrfhomo: X channel nutation experiment */
#include <standard.h>

pulsesequence()
{
   double pwx,pwxlvl,j;
   pwx=getval("pwx"); pwxlvl=getval("pwxlvl");  j=getval("j");
      hsdelay(d1);  
      pulse(pw,zero); 
      decpower(pwxlvl);
      delay(1.0/(2.0*j)-pwx/2);  
      decpulse(pwx,zero);
      decpower(dpwr);
}
