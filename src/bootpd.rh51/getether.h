/*
 * Copyright (C) 2015  Stanford University
 *
 * You may distribute under the terms of either the GNU General Public
 * License or the Apache License, as specified in the README file.
 *
 * For more information, see the README file.
 */
/* getether.h */

#ifdef	__STDC__
extern int getether(char *ifname, char *eaptr);
#else
extern int getether();
#endif
