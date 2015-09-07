/*
 * Copyright (C) 2015  Stanford University
 *
 * You may distribute under the terms of either the GNU General Public
 * License or the Apache License, as specified in the README file.
 *
 * For more information, see the README file.
 */
/* Copyright (c) Varian Assoc., Inc.  All Rights Reserved. */

/* 
 * Varian Assoc.,Inc. All Rights Reserved.
 * This software contains proprietary and confidential
 * information of Varian Assoc., Inc. and its contributors.
 * Use, disclosure and reproduction is prohibited without
 * prior consent.
 */

#ifndef MAGICFUNCS_H
#define MAGICFUNCS_H

extern "C" {
    int loadAndExec(char *name);
    void magical_register_user_func_finder(int (*(*pfunc)(char *))(int , char **, int , char **));
    void magical_set_macro_search_path(char **dirs);
    void magical_set_error_print(void (*pfunc)(char *));
    void magical_set_info_print(void (*pfunc)(char *));
}

#endif /* MAGICFUNCS_H */


