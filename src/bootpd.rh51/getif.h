/*
 * Copyright (C) 2015  Stanford University
 *
 * You may distribute under the terms of either the GNU General Public
 * License or the Apache License, as specified in the README file.
 *
 * For more information, see the README file.
 */
/* getif.h */

#ifdef	__STDC__
extern struct ifreq *getif(int, struct in_addr *);
#else
extern struct ifreq *getif();
#endif
