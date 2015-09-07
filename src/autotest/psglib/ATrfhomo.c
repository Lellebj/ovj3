/* 
 * Agilent Technologies All Rights Reserved.
 * This software contains proprietary and confidential
 * information of Agilent Technologies and its contributors.
 * Use, disclosure and reproduction is prohibited without
 * prior consent.
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
