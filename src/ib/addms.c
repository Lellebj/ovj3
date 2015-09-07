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
/* addms: add two sets of images pairwise */
/* Example ##9-12 = addms ##1-8 */
/* Result: #9  = #1 + #5 */
/*         #10 = #2 + #6  etc */

#include "imagemath.h"
#define PGM "addms"


int mathfunc() {
  float X,Y; 
  int pixel, im, pairs;
  char msg[1024];

  if (nbr_infiles<1 || input_sizes_differ || !want_output(0)){
    return FALSE;
  }

  pairs = in_vec_len[0]/2;
  if (nbr_outfiles != pairs) {
    sprintf(msg,"%s: The number of input images (%d) must match 2 x the number of output images (%d)\n",
      PGM,nbr_infiles,nbr_outfiles);
    ib_errmsg(msg);
    return FALSE;
  }
  
  create_output_files(nbr_infiles, in_object[0]);

  /* Loop through every pixel */
  for (pixel = 0; pixel < img_size; pixel++){

    /* Loop through all images in input vector */
    for (im = 0; im < pairs; im++){
      X = in_data[im][pixel];
      Y = in_data[pairs+im][pixel];
    
      if (want_output(im)){
        out_data[im][pixel] = X + Y;
      }
    
    }  /* end of image loop */
  }  /* end pixel loop */
  return TRUE;
}
