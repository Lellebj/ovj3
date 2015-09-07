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


#include <stdio.h>


main(argc, argv)
int	argc;
char    **argv;
{
	int   pipe;
	char  mess[256];

	if (argc < 3)
	     exit(0);
	pipe = atoi(argv[1]);
	sprintf(mess, "%s $  %s\n", argv[2], argv[3]);
	if (pipe >= 0)
	     write(pipe, mess, strlen(mess));
}

