/*
 * Copyright (C) 2015  Stanford University
 *
 * You may distribute under the terms of either the GNU General Public
 * License or the Apache License, as specified in the README file.
 *
 * For more information, see the README file.
 */
/*
 * Varian,Inc. All Rights Reserved.
 * This software contains proprietary and confidential
 * information of Varian, Inc. and its contributors.
 * Use, disclosure and reproduction is prohibited without
 * prior consent.
 */

/* ------------- Make C header file C++ compliant ------------------- */
#ifdef __cplusplus
extern "C" {
#endif


#if defined(__STDC__) || defined(__cplusplus)
void liquidsSpinner(int *, int *, int);
void setBearingAir(int);
void setBearingLevel(int);
int bumpSample(void);
int detectSample(void);
int ejectSample(void);
int insertSample(void);
void masSpinner(int *, int *, int);
void pneuTest(void);
void walkFlowLEDs(void);
void displayPneuStatus(void);
void readWriteDac(int);
void rampPneuDac(int);


#else                                                   
/* --------- NON-ANSI/C++ prototypes ------------  */
void liquidsSpinner();
void setBearingAir();
void setBearingLevel();
int bumpSample();
int detectSample();
int ejectSample();
int insertSample();
void masSpinner();
void pneuTest();
void walkFlowLEDs();
void displayPneuStatus();
void readWriteDac();
void rampPneuDac();

#endif

extern int  spinnerType;

#define	NO_SPINNER		0
#define LIQUIDS_SPINNER		1
#define SOLIDS_SPINNER		2
#define MAS_SPINNER     	3
#define NANO_SPINNER		4


#ifdef __cplusplus
}
#endif

