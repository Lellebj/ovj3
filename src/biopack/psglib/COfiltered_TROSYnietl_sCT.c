/* COfiltered_TROSYnietl_sCT.c 

COfiltered_TROSYnietl_sCT is used to measure the 1-bond 
Jnco/Dnco by a TROSY-based 2D J-modulated experiment.
To share chem shift labeling with J-mod delay, a 
constant time or semi-constant time setup is automatically 
determined in the pulse seq, i.e., the user does not 
need to explicitly specify anything. To cancel relaxation 
effects, "Cfilter" should be arrayed (Cfilter = y,n). 
When Cfilter==y, J/D coupling is active. Otherwise it's 
refocused. The peak intesity ratio of Cfilter==y over 
Cfilter==n remove relaxation effect. "tCN" specifies the
Jmod delay. Since S/N decays as "tCN" gets bigger, a 
larger number of scans (nt) is recommended for larger tCN values.
The user can array tCN along with nt, array='(tCN,nt),Cfilter,phase' 
(I haven't tried this myself --Yizhou) or simply
open several experiments and in each specify a tCN and nt (I did this way).

About shaped pulses: 
COfiltered_TROSYnietl_sCT uses offC8, offC3 and offC6 in Biopack. 
They can be generated by loading ghn_co.

For data fitting and other details, refer to: 
Liu & Prestegard, J Magn Reson (2009), 200:109-18.    
*/

#include <standard.h>
  

	     
static int 

	     phi1[2]  = {0,2},	
             phi2[8]  = {0,0,2,2},
 		phi3[1] = {0},		
             rec[2]   = {2,0};	     

static double   d2_init=0.0;
pulsesequence()
{

/* DECLARE AND LOAD VARIABLES */

char        f1180[MAXSTR],   		      /* Flag to start t1 @ halfdwell */
             Cfilter[MAXSTR];     /*do C' Cfilter */
 
int         icosel,          			  /* used to get n and p type */
            t1_counter;  		        /* used for states tppi in t1 */

double tCN = getval("tCN"), 
		kappa, /*semi-constant time scale factor*/
		tau1,         				         /*  t1 delay */
	    lambda = 0.91/(4.0*getval("JNH")), 	   /* 1/4J H1 evolution delay */
        

   pwClvl = getval("pwClvl"), 	  	        /* coarse power for C13 pulse */
   pwC = getval("pwC"),     	      /* C13 90 degree pulse length at pwClvl */
   rf0,            	          /* maximum fine power when using pwC pulses */

	pwC3 = getval("pwC3"), /* 180 selective Ca null on C' */
	pwC8 = getval("pwC8"), /* 180 selective C' null on Ca */
	pwC6 = getval("pwC6"), /* 90 selective C' null on Ca */
	rf3,
	rf8,
	rf6,

   compH = getval("compH"),        /* adjustment for H1 amplifier compression */
   compN = getval("compN"),       /* adjustment for N15 amplifier compression */
   compC = getval("compC"),       /* adjustment for C13 amplifier compression */


  tpwrsf_n = getval("tpwrsf_n"), /* fine power adustment for first soft pulse(TROSY=y)*/
  tpwrsf_d = getval("tpwrsf_d"), /* fine power adustment for second soft pulse(TROSY=y)*/
   	pwHs = getval("pwHs"),	        /* H1 90 degree pulse length at tpwrs */
   	tpwrs,	  	              /* power for the pwHs ("H2Osinc") pulse */

	pwNlvl = getval("pwNlvl"),	              /* power for N15 pulses */
        pwN = getval("pwN"),          /* N15 90 degree pulse length at pwNlvl */

	sw1 = getval("sw1"),

	gt1 = getval("gt1"),  		       /* coherence pathway gradients */
        gzcal = getval("gzcal"),               /* dac to G/cm conversion      */
	gzlvl1 = getval("gzlvl1"),
	gzlvl2 = getval("gzlvl2"),

	gt0 = getval("gt0"),				   /* other gradients */
	gt3 = getval("gt3"),
	gt5 = getval("gt5"),
	gstab = getval("gstab"),
	gzlvl0 = getval("gzlvl0"),
	gzlvl3 = getval("gzlvl3"),
	gzlvl5 = getval("gzlvl5");

    getstr("f1180",f1180);
	getstr("Cfilter",Cfilter);

/*   LOAD PHASE TABLE    */

	settable(t1,2,phi1);
	settable(t2,4,phi2);
	settable(t3,1,phi3);
	settable(t4,2,rec);


/*   INITIALIZE VARIABLES   */

/* maximum fine power for pwC pulses */
	rf0 = 4095.0;

    /* 180 degree square pulse on Ca, null at CO 118ppm away */
    rf3 = (1/compC*compC*4095.0*pwC*2.0)/pwC3; /* no need for compC at high power level*/
	rf3 = (int) (rf3 + 0.5);

    /* 90 degree one-lobe sinc pulse on CO, null at Ca 118ppm away */
	rf6 = (compC*4095.0*pwC*1.69)/pwC6;	/* needs 1.69 times more     */
	rf6 = (int) (rf6 + 0.5);		/* power than a square pulse */

    /* 180 degree one-lobe sinc pulse on CO, null at Ca 118ppm away */
	rf8 = (compC*4095.0*pwC*2.0*1.65)/pwC8;	/* needs 1.65 times more     */
	rf8 = (int) (rf8 + 0.5);		/* power than a square pulse */
	



/* selective H20 one-lobe sinc pulse */
    tpwrs = tpwr - 20.0*log10(pwHs/(compH*pw*1.69));   /*needs 1.69 times more*/
    tpwrs = (int) (tpwrs);                   	  /*power than a square pulse */

/* CHECK VALIDITY OF PARAMETER RANGES */

  if((dm[A] == 'y' || dm[B] == 'y' || dm[C] == 'y' ))
  { text_error("incorrect dec1 decoupler flags! Should be 'nnn' "); psg_abort(1); }

  if((dm2[A] == 'y' || dm2[B] == 'y'))
  { text_error("incorrect dec2 decoupler flags! Should be 'nny' "); psg_abort(1); }

  if( dpwr2 > 50 )
  { text_error("don't fry the probe, DPWR2 too large!  ");   	    psg_abort(1); }

  if( pw > 50.0e-6 )
  { text_error("dont fry the probe, pw too high ! ");               psg_abort(1); } 
  
  if( pwN > 100.0e-6 )
  { text_error("dont fry the probe, pwN too high ! ");              psg_abort(1); }



/* PHASES AND INCREMENTED TIMES */

/*  Phase incrementation for hypercomplex 2D data, States-Haberkorn element */

	if (phase1 == 1)   	 icosel = -1;
        else 	  {  tsadd(t3,2,4);  icosel = +1;  }


/*  Set up f1180  */
   
    tau1 = d2;
    if((f1180[A] == 'y') && (ni > 1.0)) 
	{ tau1 += ( 1.0 / (2.0*sw1) ); if(tau1 < 0.2e-6) tau1 = 0.0; }
    tau1 = tau1/2.0;



/* Calculate modifications to phases for States-TPPI acquisition          */

   if( ix == 1) d2_init = d2;
   t1_counter = (int) ( (d2-d2_init)*sw1 + 0.5 );
   if(t1_counter % 2) 
	{ tsadd(t1,2,4); tsadd(t4,2,4); }

	kappa = tCN>ni/sw1? 1:tCN/(ni/sw1);
	kappa = ((double)((int)(kappa*1000)))/1000; 
       /* 3 digits after the point, may cause a small decrease in value for safe boundary */

	printf("kappa = %f\n", kappa);

/* BEGIN PULSE SEQUENCE */

status(A);

	obspower(tpwr);
	decpower(pwClvl);
	decpwrf(rf0);
 	dec2power(pwNlvl);
	txphase(zero);
        decphase(zero);
        dec2phase(zero);

	delay(d1);

 
/*  xxxxxxxxxxxxxxxxx  CONSTANT SAMPLE HEATING FROM N15 RF xxxxxxxxxxxxxxxxx  */

 

/*  xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx  */
    rcvroff();

	/*dec2rgpulse(pwN, zero, 0.0, 0.0); */  /*destroy N15 magnetization*/
	zgradpulse(gzlvl0, 0.5e-3);
	delay(1.0e-4);

	/*dec2rgpulse(pwN, one, 0.0, 0.0); */
	zgradpulse(0.7*gzlvl0, 0.5e-3);
	txphase(t1);
	delay(5.0e-4);

 
   	rgpulse(pw,zero,0.0,0.0);                 /* 1H pulse excitation */

	txphase(zero);
   	dec2phase(zero);
	zgradpulse(gzlvl0, gt0);
	delay(lambda - gt0);

   	sim3pulse(2.0*pw, 0.0, 2.0*pwN, zero,zero, zero, 0.0, 0.0);

   	txphase(one);
	zgradpulse(gzlvl0, gt0);
	delay(lambda - gt0);

 	rgpulse(pw, three, 0.0, 0.0);
	txphase(two);

         obspower(tpwrs+6.0);
           obspwrf(tpwrsf_n);
   	   shaped_pulse("H2Osinc_n", pwHs, zero, 5.0e-5, 0.0);
	 obspower(tpwr); obspwrf(4095.0);

	zgradpulse(gzlvl3, gt3);
	dec2phase(t1);
	delay(gstab);
	decpwrf(rf8);   
   	dec2rgpulse(pwN, t1, 0.0, 0.0);
	txphase(zero);
	decphase(zero);


/*  xxxxxxxxxxxxxxxxxx    OPTIONS FOR N15 EVOLUTION    xxxxxxxxxxxxxxxxxxxxx  */

	txphase(zero);
	dec2phase(zero);

/* shared CT for C' Cfilter and N15 chem shift evolution */
	delay(tCN/2.0 - kappa*tau1 - gt5 -gstab);
	zgradpulse(gzlvl5,gt5);
	delay(gstab);
	if(Cfilter[A] == 'y' && (1-kappa)*tau1 < pwC8/2) {
		sim3shaped_pulse("", "offC8", "", 0.0, pwC8, 2.0*pwN, zero, zero, zero,0.0,0.0);
		zgradpulse(gzlvl5,gt5);
	    delay(tCN/2.0 + (1-kappa)*tau1 -gt5 - pwC3 - pwC8);
	}
	else if (Cfilter[A] == 'y' && (1-kappa)*tau1 >= pwC8/2){
		dec2rgpulse(2.0*pwN,zero,(pwC8-2.0*pwN)/2.0,(pwC8-2.0*pwN)/2.0);
		if( (1-kappa)*tau1 >= gt5 +gstab + pwC8/2){
			zgradpulse(gzlvl5,gt5);
			delay((1-kappa)*tau1 -pwC8/2.0 - gt5);
			decshaped_pulse("offC8", pwC8,zero,0.0,0.0); 
			delay(tCN/2.0 - pwC3 - 1.5*pwC8);
		}
		else{
			delay((1-kappa)*tau1 -pwC8/2.0);
			decshaped_pulse("offC8", pwC8,zero,0.0,0.0);
			zgradpulse(gzlvl5,gt5); 
			delay(tCN/2.0 -gt5 - pwC3 - 1.5*pwC8);
		}			
	}
	else{
		dec2rgpulse(2.0*pwN,zero,(pwC8-2.0*pwN)/2.0,(pwC8-2.0*pwN)/2.0);
		zgradpulse(gzlvl5,gt5);
	   delay(tCN/2.0 + (1-kappa)*tau1 -gt5 - pwC3 - pwC8);
	}
	

	decpwrf(rf3);
	decshaped_pulse("offC3", pwC3, zero,0.0, 0.0);
	decpwrf(rf8);
	if(Cfilter[A] == 'y'){
		delay(pwC8);
	}
	else {
		decshaped_pulse("offC8", pwC8,zero,0.0,0.0); 
	}

	delay(tau1);
	
	/* gradient for coherence selection and H(z)N(x/y)C(x/y) destruction  */
	decpwrf(rf6);
	if(Cfilter[A] == 'y' ){
		decshaped_pulse("offC6", pwC6, zero, 0.0, 0.0);
	}
	else{
		decshaped_pulse("offC6", pwC6, zero, 0.0, 0.0); /*delay(pwC6);*/
	}
	zgradpulse(gzlvl1, gt1);   	
	dec2phase(t2);
	delay(gstab - 2.0*GRADIENT_DELAY);
	dec2rgpulse(2.0*pwN, t2, 0.0, 0.0);
	delay(gt1+gstab + pwC6);


	txphase(three);
	txphase(t4);



/*  xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx  */
	sim3pulse(pw,0.0,pwN, zero,zero, t3, 0.0, 0.0);

        if (tpwrsf_d<4095.0)
        {
         obspwrf(tpwrsf_d); obspower(tpwrs+6.0);
   	 shaped_pulse("H2Osinc_d", pwHs, zero, 5.0e-5, 0.0);
	 obspower(tpwr); obspwrf(4095.0);
        }
        else
        {   
         obspower(tpwrs);
   	 shaped_pulse("H2Osinc_d", pwHs, zero, 5.0e-5, 0.0);
	 obspower(tpwr);
        }	

	txphase(zero);
	dec2phase(zero);
	zgradpulse(gzlvl5, gt5);
	delay(lambda - 0.65*(pw + pwN) - gt5 - pwHs - 2.0*POWER_DELAY -2.0*PWRF_DELAY -50.0e-6);

	sim3pulse(2.0*pw, 0.0, 2.0*pwN, zero, zero, zero, 0.0, 0.0);

	zgradpulse(gzlvl5, gt5);
	txphase(one);
	dec2phase(zero);
	delay(lambda - 1.3*pwN - gt5);

	sim3pulse(pw, 0.0, pwN, one, zero, zero, 0.0, 0.0);

	txphase(zero);
	dec2phase(zero);
	zgradpulse(1.5*gzlvl5, gt5);
	delay(lambda - 1.3*pwN - gt5 );

	sim3pulse(2.0*pw, 0.0, 2.0*pwN, zero, zero, zero, 0.0, 0.0);

	dec2phase(one);
	zgradpulse(1.5*gzlvl5, gt5);
	delay(lambda - 1.6*pwN - gt5);

	sim3pulse(pw, 0.0, pwN, one, zero, one, 0.0, 0.0); 

	delay((gt1/10.0) + 1.0e-4 +gstab - 0.65*pw + 2.0*GRADIENT_DELAY + POWER_DELAY);

	rgpulse(2.0*pw, zero, 0.0, 0.0);

	dec2power(dpwr2);				       /* POWER_DELAY */
        
      zgradpulse(icosel*gzlvl2, 0.1*gt1);		/* 2.0*GRADIENT_DELAY */
        delay(gstab);
        rcvron();
statusdelay(C,1.0e-4);		

	setreceiver(t4);
}		 
