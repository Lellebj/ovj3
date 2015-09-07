/*
 * Copyright (C) 2015  Stanford University
 *
 * You may distribute under the terms of either the GNU General Public
 * License or the Apache License, as specified in the README file.
 *
 * For more information, see the README file.
 */
/* 
* Varian Assoc.,Inc. All Rights Reserved.
* This software contains proprietary and confidential
* information of Varian Assoc., Inc. and its contributors.
* Use, disclosure and reproduction is prohibited without
* prior consent.
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
