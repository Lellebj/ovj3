/*
 * Copyright (C) 2015  University of Oregon
 *
 * You may distribute under the terms of either the GNU General Public
 * License or the Apache License, as specified in the README file.
 *
 * For more information, see the README file.
 */

struct _dsp_params {
	int	flags;
	int	rt_oversamp;
	int	rt_extrapts;
	int	il_oversamp;
	int	il_extrapts;
	int	rt_downsamp;
};

extern struct _dsp_params	dsp_params;
