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

/*  This program documents itself  */

#define  ESC	0x1B

main()
{
	printf( "Setting CODE parameter to TEK\n" );
	printf( "%c%%!0", ESC );
	printf( "Setting number of dialog lines to 32\n" );
	printf( "%cLLB0", ESC );
	printf( "Setting FLAGGING to IN/OUT\n" );
	printf( "%cNF3", ESC );
	printf( "Setting QUEUESIZE to 2500\n" );
	printf( "%cNQB\\4", ESC );		/* '\' is the escape char */
	printf( "Setting CODE parameter to ANSI\n" );
	printf( "%c%%!1", ESC );
}
