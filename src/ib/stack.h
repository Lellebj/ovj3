/*
 * Copyright (C) 2015  Stanford University
 *
 * You may distribute under the terms of either the GNU General Public
 * License or the Apache License, as specified in the README file.
 *
 * For more information, see the README file.
 */
#ifdef HEADER_ID

/* Copyright (c) Varian Assoc., Inc.  All Rights Reserved. */

#else

#ifndef STACK_H_DEFINED
#define STACK_H_DEFINED

typedef void *Stack;

#ifdef __STDC__
Stack Stack_init (unsigned count, unsigned size);
Stack Stack_adjust (Stack stack, unsigned count);
int   Stack_push (Stack stack, void *entry);
int   Stack_pop (Stack stack, void *entry);
int   Stack_top (Stack stack, void *entry);
#else
Stack Stack_init( /* unsigned count, unsigned size */ );
Stack Stack_adjust( /* Stack stack, unsigned count */ );
int   Stack_push( /* Stack stack, void *entry */ );
int   Stack_pop( /* Stack stack, void *entry */ );
int   Stack_top( /* Stack stack, void *entry */ );
#endif

#endif

#endif
