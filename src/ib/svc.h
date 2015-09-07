/*
 * Copyright (C) 2015  Stanford University
 *
 * You may distribute under the terms of either the GNU General Public
 * License or the Apache License, as specified in the README file.
 *
 * For more information, see the README file.
 */
/*
*                                                                       
*
   MODIFIED by CG to move out struct xv_ops from struct SVCXPRT
*/

/* Copyright (c) Varian Assoc., Inc.  All Rights Reserved. */

/*
 * svc.h, Server-side remote procedure call interface.
 *
 * Copyright (C) 1984, Sun Microsystems, Inc.
 */

#ifndef _rpc_svc_h
#define	_rpc_svc_h
#ifdef LINUX
#include <rpc/svc_auth.h>
#endif

#include "c_varieties.h"

/*
 * This interface must manage two items concerning remote procedure calling:
 *
 * 1) An arbitrary number of transport connections upon which rpc requests
 * are received.  The two most notable transports are TCP and UDP;  they are
 * created and registered by routines in svc_tcp.c and svc_udp.c, respectively;
 * they in turn call xprt_register and xprt_unregister.
 *
 * 2) An arbitrary number of locally registered services.  Services are
 * described by the following four data: program number, version number,
 * "service dispatch" function, a transport handle, and a boolean that
 * indicates whether or not the exported program should be registered with a
 * local binder service;  if true the program's number and version and the
 * port number from the transport handle are registered with the binder.
 * These data are registered with the rpc svc system via svc_register.
 *
 * A service's dispatch function is called whenever an rpc request comes in
 * on a transport.  The request's program and version numbers must match
 * those of the registered service.  The dispatch function is passed two
 * parameters, struct svc_req * and SVCXPRT *, defined below.
 */
#ifndef LINUX
enum xprt_stat {
	XPRT_DIED,
	XPRT_MOREREQS,
	XPRT_IDLE
};
#endif
struct xp_ops {
	    bool_t	(*xp_recv)(DOTDOTDOT);
					 /* receive incomming requests */
	    enum xprt_stat (*xp_stat)(DOTDOTDOT);
					 /* get transport status */
	    bool_t	(*xp_getargs)(DOTDOTDOT);
					 /* get arguments */
	    bool_t	(*xp_reply)(DOTDOTDOT);
					 /* send reply */
	    bool_t	(*xp_freeargs)(DOTDOTDOT);
					 /* free mem allocated for args */
	    void	(*xp_destroy)(DOTDOTDOT);
					 /* destroy this struct */
	} ;

/*
 * Server side transport handle
 */
typedef struct {
#ifdef KERNEL
	struct socket	*xp_sock;
#else
	int		xp_sock;
#endif
	u_short		xp_port;	 /* associated port number */
	struct xp_ops *xp_ops;
	int		xp_addrlen;	 /* length of remote address */
	struct sockaddr_in xp_raddr;	 /* remote address */
	struct opaque_auth xp_verf;	 /* raw response verifier */
	caddr_t		xp_p1;		 /* private: for use by svc ops */
	caddr_t		xp_p2;		 /* private: for use by svc ops */
	caddr_t		xp_p3;		 /* private: for use by svc lib */
} SVCXPRT;

/*
 *  Approved way of getting address of caller
 */
#define	svc_getcaller(x) (&(x)->xp_raddr)

/*
 * Operations defined on an SVCXPRT handle
 *
 * SVCXPRT		*xprt;
 * struct rpc_msg	*msg;
 * xdrproc_t		 xargs;
 * caddr_t		 argsp;
 */
#define	SVC_RECV(xprt, msg)				\
	(*(xprt)->xp_ops->xp_recv)((xprt), (msg))
#define	svc_recv(xprt, msg)				\
	(*(xprt)->xp_ops->xp_recv)((xprt), (msg))

#define	SVC_STAT(xprt)					\
	(*(xprt)->xp_ops->xp_stat)(xprt)
#define	svc_stat(xprt)					\
	(*(xprt)->xp_ops->xp_stat)(xprt)

#define	SVC_GETARGS(xprt, xargs, argsp)			\
	(*(xprt)->xp_ops->xp_getargs)((xprt), (xargs), (argsp))
#define	svc_getargs(xprt, xargs, argsp)			\
	(*(xprt)->xp_ops->xp_getargs)((xprt), (xargs), (argsp))

#define	SVC_REPLY(xprt, msg)				\
	(*(xprt)->xp_ops->xp_reply) ((xprt), (msg))
#define	svc_reply(xprt, msg)				\
	(*(xprt)->xp_ops->xp_reply) ((xprt), (msg))

#define	SVC_FREEARGS(xprt, xargs, argsp)		\
	(*(xprt)->xp_ops->xp_freeargs)((xprt), (xargs), (argsp))
#define	svc_freeargs(xprt, xargs, argsp)		\
	(*(xprt)->xp_ops->xp_freeargs)((xprt), (xargs), (argsp))

#define	SVC_DESTROY(xprt)				\
	(*(xprt)->xp_ops->xp_destroy)(xprt)
#define	svc_destroy(xprt)				\
	(*(xprt)->xp_ops->xp_destroy)(xprt)


/*
 * Service request
 */
struct svc_req {
	u_long		rq_prog;	/* service program number */
	u_long		rq_vers;	/* service protocol version */
	u_long		rq_proc;	/* the desired procedure */
	struct opaque_auth rq_cred;	/* raw creds from the wire */
	caddr_t		rq_clntcred;	/* read only cooked cred */
	SVCXPRT	*rq_xprt;		/* associated transport */
};


/*
 * Service registration
 *
 * svc_register(xprt, prog, vers, dispatch, protocol)
 *	SVCXPRT *xprt;
 *	u_long prog;
 *	u_long vers;
 *	void (*dispatch)(DOTDOTDOT);
 *	int protocol;   like TCP or UDP, zero means do not register
 */
EXTERN_FUNCTION( extern bool_t	svc_register,	(SVCXPRT *, u_long, u_long,
			void (*) (DOTDOTDOT), int));

/*
 * Service un-registration
 *
 * svc_unregister(prog, vers)
 *	u_long prog;
 *	u_long vers;
 */
EXTERN_FUNCTION( extern void	svc_unregister,	(u_long, u_long));

/*
 * Transport registration.
 *
 * xprt_register(xprt)
 *	SVCXPRT *xprt;
 */
EXTERN_FUNCTION( extern void	xprt_register,	(SVCXPRT *));

#ifndef KERNEL
/*
 * Transport un-register
 *
 * xprt_unregister(xprt)
 *	SVCXPRT *xprt;
 */
EXTERN_FUNCTION( extern void	xprt_unregister,	(SVCXPRT *));


#endif !KERNEL


/*
 * When the service routine is called, it must first check to see if it
 * knows about the procedure;  if not, it should call svcerr_noproc
 * and return.  If so, it should deserialize its arguments via
 * SVC_GETARGS (defined above).  If the deserialization does not work,
 * svcerr_decode should be called followed by a return.  Successful
 * decoding of the arguments should be followed the execution of the
 * procedure's code and a call to svc_sendreply.
 *
 * Also, if the service refuses to execute the procedure due to too-
 * weak authentication parameters, svcerr_weakauth should be called.
 * Note: do not confuse access-control failure with weak authentication!
 *
 * NB: In pure implementations of rpc, the caller always waits for a reply
 * msg.  This message is sent when svc_sendreply is called.
 * Therefore pure service implementations should always call
 * svc_sendreply even if the function logically returns void;  use
 * xdr.h - xdr_void for the xdr routine.  HOWEVER, tcp based rpc allows
 * for the abuse of pure rpc via batched calling or pipelining.  In the
 * case of a batched call, svc_sendreply should NOT be called since
 * this would send a return message, which is what batching tries to avoid.
 * It is the service/protocol writer's responsibility to know which calls are
 * batched and which are not.  Warning: responding to batch calls may
 * deadlock the caller and server processes!
 */

EXTERN_FUNCTION( extern bool_t	svc_sendreply,	(SVCXPRT *, xdrproc_t, caddr_t));
EXTERN_FUNCTION( extern void	svcerr_decode,	(SVCXPRT *));
EXTERN_FUNCTION( extern void	svcerr_weakauth,	(SVCXPRT *));
EXTERN_FUNCTION( extern void	svcerr_noproc,	(SVCXPRT *));
EXTERN_FUNCTION( extern void	svcerr_progvers,	(SVCXPRT *, u_long, u_long));
EXTERN_FUNCTION( extern void	svcerr_auth,	(SVCXPRT *, enum auth_stat));
EXTERN_FUNCTION( extern void	svcerr_noprog,	(SVCXPRT *));
#ifndef KERNEL
EXTERN_FUNCTION( extern void	svcerr_systemerr,	(SVCXPRT *));
#endif

/*
 * Lowest level dispatching -OR- who owns this process anyway.
 * Somebody has to wait for incoming requests and then call the correct
 * service routine.  The routine svc_run does infinite waiting; i.e.,
 * svc_run never returns.
 * Since another (co-existant) package may wish to selectively wait for
 * incoming calls or other events outside of the rpc architecture, the
 * routine svc_getreq is provided.  It must be passed readfds, the
 * "in-place" results of a select system call (see select, section 2).
 */

#ifndef KERNEL
/*
 * Global keeper of rpc service descriptors in use
 * dynamic; must be inspected before each call to select
 */
extern fd_set svc_fdset;
#define	svc_fds svc_fdset.fds_bits[0]	/* compatibility */

/*
 * a small program implemented by the svc_rpc implementation itself;
 * also see clnt.h for protocol numbers.
 */
EXTERN_FUNCTION( extern void rpctest_service,	(DOTDOTDOT));
#endif !KERNEL

EXTERN_FUNCTION( extern void	svc_getreq,	(int));
#ifndef KERNEL
EXTERN_FUNCTION( extern void	svc_getreqset,	(DOTDOTDOT));	/* takes fdset instead of int */
#endif
EXTERN_FUNCTION( extern void	svc_run,	(DOTDOTDOT));		/* never returns */

/*
 * Socket to use on svcxxx_create call to get default socket
 */
#define	RPC_ANYSOCK	-1

/*
 * These are the existing service side transport implementations
 */

#ifndef KERNEL
/*
 * Memory based rpc for testing and timing.
 */
EXTERN_FUNCTION( extern SVCXPRT *svcraw_create,	(_VOID_));

/*
 * Udp based rpc.
 */
EXTERN_FUNCTION( extern SVCXPRT *svcudp_create,	(int));
EXTERN_FUNCTION( extern SVCXPRT *svcudp_bufcreate,	(int, u_int, u_int));

/*
 * Tcp based rpc.
 */
EXTERN_FUNCTION( extern SVCXPRT *svctcp_create,	(int, u_int, u_int));

/*
 * Like svtcp_create(), except the routine takes any *open* UNIX file
 * descriptor as its first input.
 */
EXTERN_FUNCTION( SVCXPRT *svcfd_create,	(int, u_int, u_int));
#else

/*
 * Kernel udp based rpc.
 */
EXTERN_FUNCTION( extern SVCXPRT *svckudp_create,	(struct socket *, u_short));
#endif !KERNEL


#endif /*!_rpc_svc_h*/
