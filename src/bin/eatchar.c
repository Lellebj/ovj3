/*
 * Copyright (C) 2015  University of Oregon
 *
 * You may distribute under the terms of either the GNU General Public
 * License or the Apache License, as specified in the README file.
 *
 * For more information, see the README file.
 */
/* 
*/
/*--------------------------------------------------------------------
|   eatchar
|
|   This programs just eats stdinput chars
|
+---------------------------------------------------------------------*/
#include <stdio.h>

main()
{
	int	ival;

	while (1) {
		ival = getchar(); 
		if (ival == EOF)
		  clearerr( stdin );
	}
}
