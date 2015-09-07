/*
 * Copyright (C) 2015  Stanford University
 *
 * You may distribute under the terms of either the GNU General Public
 * License or the Apache License, as specified in the README file.
 *
 * For more information, see the README file.
 */
/*-*- Mode: C++ -*-*/

#ifndef AIPWRITEDATA_H
#define AIPWRITEDATA_H

#include  "aipImgInfo.h"

class WriteData
{
public:
    /* Vnmr command */
    static int writeData(int argc, char *argv[], int retc, char *retv[]);

    static string writeFdfData(spImgInfo_t img, const char *path);
    static string writePortableData(spImgInfo_t img, const char *path);

private:
    static const char *getScript(const char *infile, const char *outfile,
                                 char *newOutfile);

};

#endif /* AIPWRITEDATA_H */
