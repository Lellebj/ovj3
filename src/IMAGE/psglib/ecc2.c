/* 
 * Agilent Technologies All Rights Reserved.
 * This software contains proprietary and confidential
 * information of Agilent Technologies and its contributors.
 * Use, disclosure and reproduction is prohibited without
 * prior consent.
 */

#include <standard.h>
#include "sgl.c"

pulsesequence()
{
  double sign,currentlimit,RMScurrentlimit,dutycycle;
  int calcpower;

  /* Initialize paramaters **********************************/
  init_mri();
  calcpower=(int)getval("calcpower");
  dutycycle=getval("dutycycle");
  currentlimit=getval("currentlimit");
  RMScurrentlimit=getval("RMScurrentlimit");

  if (gspoil>0.0) sign = 1.0;
  else sign = -1.0;

  init_rf(&p1_rf,p1pat,p1,flip1,rof1,rof2);
  if (calcpower) calc_rf(&p1_rf,"tpwr1","tpwr1f");

  if (tspoil>0.0) {
    gspoil = sqrt(dutycycle/100.0)*gmax*RMScurrentlimit/currentlimit;
    init_generic(&spoil_grad,"spoil",gspoil,tspoil);
    spoil_grad.rollOut=FALSE;
    calc_generic(&spoil_grad,WRITE,"gspoil","tspoil");
  }

  xgate(ticks);

  rotate();

  status(A);
  mod4(ct,oph);
  delay(d1);

  /* TTL scope trigger **********************************/       
  sp1on(); delay(4e-6); sp1off();

  if (calcpower) {
    obspower(p1_rf.powerCoarse);
    obspwrf(p1_rf.powerFine);
  } 
  else obspower(tpwr1);
  delay(4e-6);

  if (tspoil>0.0) {
    obl_shapedgradient(spoil_grad.name,spoil_grad.duration,0,0,spoil_grad.amp*sign,WAIT);
    delay(d2);
  }

  shapedpulse(p1pat,p1,ct,rof1,rof2);

  startacq(alfa);
  acquire(np,1.0/sw);
  endacq();
		
}

