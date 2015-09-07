/*
 * Copyright (C) 2015  University of Oregon
 *
 * You may distribute under the terms of either the GNU General Public
 * License or the Apache License, as specified in the README file.
 *
 * For more information, see the README file.
 */
/*-*- Mode: C++ -*-*/

#ifndef ASPARROW_H
#define ASPARROW_H

#include "AspLine.h"

class AspArrow : public AspLine
{ 

public:

    AspArrow(spAspCell_t cell, int x, int y);
    AspArrow(char words[MAXWORDNUM][MAXSTR], int nw);

private:

};

#endif /* ASPARROW_H */
