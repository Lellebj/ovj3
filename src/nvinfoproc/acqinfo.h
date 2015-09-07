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
/*
 * Please do not edit this file.
 * It was generated using rpcgen.
 */

#ifndef _ACQINFO_H_RPCGEN
#define	_ACQINFO_H_RPCGEN

#include <rpc/rpc.h>
#ifndef _KERNEL
#ifndef LINUX
#include <synch.h>
#include <thread.h>
#endif /* !LINUX */
#endif /* !_KERNEL */

typedef char *a_string;

struct acqdata {
	int pid;
	int pid_active;
	int rdport;
	int wtport;
	int msgport;
	char *host;
};
typedef struct acqdata acqdata;

struct ft3ddata {
	char *autofilepath;
	char *procmode;
	char *username;
	char *pathenv;
};
typedef struct ft3ddata ft3ddata;

#define	ACQINFOPROG	99
#define	ACQINFOVERS	2
#define	ACQINFO_GET	1
extern  enum clnt_stat acqinfo_get_2();
extern  bool_t acqinfo_get_2_svc();
#define	ACQPID_PING	2
extern  enum clnt_stat acqpid_ping_2();
extern  bool_t acqpid_ping_2_svc();
#define	FT3D_START	3
extern  enum clnt_stat ft3d_start_2();
extern  bool_t ft3d_start_2_svc();
extern int acqinfoprog_2_freeresult();

/* the xdr functions */
extern bool_t xdr_a_string();
extern bool_t xdr_acqdata();
extern bool_t xdr_ft3ddata();

#endif /* !_ACQINFO_H_RPCGEN */
