/* 
 * Agilent Technologies All Rights Reserved.
 * This software contains proprietary and confidential
 * information of Agilent Technologies and its contributors.
 * Use, disclosure and reproduction is prohibited without
 * prior consent.
 */
#include <standard.h>

pulsesequence()
{
  double oslsfrq=getval("oslsfrq");
  status(A);
    obsoffset(tof);
    hsdelay(d1);

  status(B);
    rgpulse(p1,zero,rof1,0.0);
    delay(d2);

  status(C);
    rgpulse(pw,oph,rof1,rof2);
    obsoffset(tof+oslsfrq);
}
