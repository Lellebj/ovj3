/*
 * Copyright (C) 2015  University of Oregon
 *
 * You may distribute under the terms of either the GNU General Public
 * License or the Apache License, as specified in the README file.
 *
 * For more information, see the README file.
 */

#ifndef INCsendAsynch
#define INCsendAsynch

/* ------------- Make C header file C++ compliant ------------------- */
#ifdef __cplusplus
extern "C" {
#endif

/* --------- ANSI/C++ compliant function prototypes --------------- */

#if defined(__STDC__) || defined(__cplusplus)

 
extern  int	sendAsync(char *machine,int port,char *message);
 
/* --------- NON-ANSI/C++ prototypes ------------  */

#else
 
extern  int	sendAsync();
 
#endif  /* __STDC__ */
 
#ifdef __cplusplus
}
#endif

#endif /* INCsendAsynch */
