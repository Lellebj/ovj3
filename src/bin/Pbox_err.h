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
/* Pbox_err.h - Pbox error and memory allocation handler */

static char e_str[512];

void err(fstr)
char *fstr;
{
  printf("\n Pandora in panic! Can't find the \"%s\" file.\n", fstr);
  printf("Aborting...\n");
  exit(1);
}

void flerr(fname)
char *fname;
{
  printf("\n Pbox: Can't open file \"%s\" file.\n Aborting...\n", fname);
  exit(1);
}

void pxerr(str)
char *str;
{
  printf("\n %s\n\n", str);
  exit(1);
}

void pxout(str, dev)
char *str, dev;
{
  printf("%s", str);
}

double pxscan()
{
  double dbl;

  printf("\n %s\n\n", e_str);
  scanf("%lf", &dbl);
  return dbl;
}


