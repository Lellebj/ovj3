/*
 * Copyright (C) 2015  Stanford University
 *
 * You may distribute under the terms of either the GNU General Public
 * License or the Apache License, as specified in the README file.
 *
 * For more information, see the README file.
 */

#include "eventQueue.h"

#ifndef INCeventQueueP
#define INCeventQueueP

struct EventQueue {
	struct EventQueueEntry	*first;
	struct EventQueueEntry	*last;
	int			 queue_size;
	struct EventQueueEntry	 e_array[ 2 ];
};

#endif  /* INCeventQueueP */
