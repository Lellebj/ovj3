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
#include <string.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <sys/vfs.h>
#ifdef MOTIF
#include <sys/statfs.h>
#endif
#include <sys/signal.h>
#include <X11/Intrinsic.h>
#include <X11/StringDefs.h>

#ifdef OLIT
#include <Xol/OpenLook.h>
#include <Xol/BulletinBo.h>
#include <Xol/CheckBox.h>
#include <Xol/ControlAre.h>
#include <Xol/DrawArea.h>
#include <Xol/Exclusives.h>
#include <Xol/Form.h>
#include <Xol/RectButton.h>
#include <Xol/OblongButt.h>
#include <Xol/PopupWindo.h>
#include <Xol/Scrollbar.h>
#include <Xol/ScrolledWi.h>
#include <Xol/StaticText.h>
#include <Xol/TextEdit.h>
#include <Xol/TextField.h>

#else
#include <Xm/Xm.h>
#include <X11/Xatom.h>
#include <Xm/Label.h>
#include <Xm/Form.h>
#include <Xm/DrawingAP.h>
#include <Xm/Protocols.h>

#endif


/***
#include "logo.xicon"
#include "inova.xicon"
#include "g2000.xicon"
#include "uplus.xicon"
#include "unity.xicon"
#include "mercury.xicon"
#include "ibm.xicon"
#include "sgi.xicon"
***/
#include "cdrom.xicon"
#include "disk.xicon"
#include "smile.xicon"


#define OPTFILES	4
#define INOVA		1
#define GEMINI		2
#define UPLUS		3

#define ICONGAP		30
#define VGAP		8
#define SET		1
#define UNSET		0

#define RETURN		10
#define PASSWD		12

#define ICONWIDTH	64

#ifdef MOTIF
#define XtNexposeCallback	XmNexposeCallback
#define drawAreaWidgetClass	xmDrawingAreaWidgetClass
#define TextEditWidget  	Widget
#define XtNset	    		XmNset
#define XtNmodifyVerification 	XmNmodifyVerifyCallback

static Atom         deleteAtom;
XmString	    xmstr;
XmTextPosition	    text_pos;

#endif

static Widget       topShell;
static Widget       mainFrame;
static Widget       mainWin, infoWin, execWin;
static Widget       optWin = NULL;
static Widget       optWin2 = NULL;
static Widget       sysWin, sizeWin;
static Widget       installBut, quitBut, helpBut;
static Widget       dirWidget = NULL;
static Display      *dpy;
static Widget	    installShell = NULL;
static Widget	    installFrame;
static Widget 	    installGraf, scrolledWindow;
static Widget	    confirmShell = NULL;
static Widget	    confirmFrame;
static Widget 	    sepWin;
static Widget 	    disWin, disBut;
static Widget	    helpShell = NULL;
static Widget	    wLabel, wLabel2;
static Widget	    yesBut, noBut, okBut;
static Widget	    vlink[2], olink[2], kbut[2];
static Window 	    grafWin = NULL;
static Window 	    topShellId;
static Window 	    sysId, optId;
static Window 	    sizeId;
static TextEditWidget installText;
static TextEditWidget *password;


static Arg          args[20];
static char         tmpstr[256];

char  RevID[]= REVISION_ID;
char  RevDate[] = REVISION_DATE;
char  CDNT[] = COMPDATE;
char  *prog_dir;
char  *help_dir;
char  machine[16];
char  location[32];
char  *dest_label = "Destination directory:";
char  *acq_label    = "Stop acquisition?                    ";
char  *online_label = "Create online manuals as link to CD? ";
char  *vnmr_label   = "Create /vnmr link when done?         ";
char  *nargv[64];
char  fontv[32];
char  fontrv[32];

static int   n;
static int   main_opt_num;
static int   acq_pid = -1;
static int   online_link;
static int   vnmr_link;
static int   delete_acq;
static int   winDepth;
static int   charWidth, charHeight;
static int   sysWinWidth, sysWinRows;
static int   optWinWidth, optWinRows;
static int   sizeInstalled, totalSize;
static int   installWidth, installHeight;
static int   ch_ascent;
static int   ch_descent;
static int   install_pid = -1;
static int   pipe_1[2];
static int   screenHeight, screenWidth;
static int   row_gap, rowHeight;
static int   info_x;
static int   markWidth, mark_x;
static int   password_len;
static int   cdrom_y, disk_x;
static int   draw_forward;
static int   ratio_x, ratio_y;
static int   messLen, messLen2;
static int   debug = 0;
static int   show_location = 1;

static Pixel winFg, winBg;
static Pixel xblack, xwhite;
static Pixel textPix, barBg, barLight;
static Pixel lightPix, darkPix, grayPix;
static Colormap    cmap;
static XColor	   xcolor;
static GC	   gc;
static Pixmap markMap0, markMap1, markMap2, markMap3;
static Pixmap cdromMap, diskMap, grafMap;

static XFontStruct  *labelFontInfo;

typedef struct  _choice {
	int	id;
	int	online_item;
	int	selected;
	char    *info;
	char    *message;
	char    *passwd;
	int	p_len;
	TextEditWidget  pwidget;
	int	size;
	int	mess_len;
	struct  _choice *next;
	} VCHOICE;

typedef struct  _voption {
	int	id;
	char    *base_name;
	char    *opt_name;
	int	num;
	int	count;
	int	max_count;
	int	max_len;
	VCHOICE *choices;
	struct  _voption *next;
	}  VOPTION;
static VOPTION  *sys_node_start = NULL;
static VOPTION  *opt_node_start = NULL;
static VOPTION  *cur_sys_node = NULL;
static VOPTION  *cur_opt_node = NULL;

struct map_info {
	int	width, height;
	int	colors;
	char	*colorChs;
	Pixel   *pixelVals;
	char    **data;
	};

typedef struct  _xiconInfo {
	int   id;
	int   set;
	struct map_info  pix_data;
	Pixmap butMap;
	Pixmap butMap2;
	Window window;
	VOPTION *opt;
	struct _xiconInfo  *next;
 } ICONINFO;

ICONINFO *but_info_start = NULL;
ICONINFO *but_info_selected = NULL;

struct map_info   cdrom_info, disk_info;

static XtInputId  install_input;

Widget create_separator();
void   main_win_expose();

#define BGAP      6
#define BWIDTH    4
#define BSPACE    4
#define BARPIX    7


static unsigned char check15[] = {
   0x00, 0x00, 0x00, 0x00, 0x00, 0x80, 0x00, 0x40, 0x00, 0x20, 0x00, 0x10,
   0x00, 0x18, 0x00, 0x0c, 0x0e, 0x0e, 0x1e, 0x07, 0xbe, 0x03, 0xfc, 0x03,
   0xf8, 0x01, 0xf0, 0x00, 0xe0, 0x00, 0x00, 0x00};

static unsigned char check12[] = {
   0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x08, 0x00, 0x04,
   0x00, 0x02, 0x00, 0x02, 0x00, 0x03, 0x80, 0x01, 0x8e, 0x01, 0xde, 0x00,
   0xfe, 0x00, 0x7c, 0x00, 0x38, 0x00, 0x00, 0x00};

XPoint  check_pnts[60];


char *get_text_widget(lwidget)
Widget  lwidget;
{
	static  char  data[256];
	static  char  *ptr, *ptr2;

#ifdef OLIT
        XtSetArg (args[0], XtNstring, &ptr);
	XtGetValues(lwidget, args, 1);
#else
	ptr = (char *) XmTextGetString(lwidget);
#endif
	if (ptr != NULL)
	{
	    ptr2 = ptr;
	    while (*ptr2 == ' ')
		ptr2++;
	    strcpy(data, ptr2);
/*
	    XtFree(ptr);
*/
	    if ((int) strlen(data) <= 0)
		ptr = NULL;
	}
	if (ptr == NULL)
	    return(ptr);
	ptr2 = data + (int) strlen(data) - 1;
	while (ptr2 >= data && (*ptr2 == ' ' || *ptr2 == '\n'))
	{
	    *ptr2 = '\0';
	    ptr2--;
	}
	return(data);
}

#ifdef OLIT

set_text_widget(lwidget, resize, label)
Widget  lwidget;
int	resize;
char    *label;
{
	int	len;

        XtSetArg (args[0], XtNstring, label);
	XtSetValues(lwidget, args, 1);
	if (resize)
	{
	   len = XTextWidth(labelFontInfo, label, strlen(label));
	   if (lwidget == wLabel)
		messLen = len;
	   else if (lwidget == wLabel2)
		messLen2 = len;
	}
}


void
win_exit_proc( w, client_data, event )
Widget w;
char *client_data;
void *event;
{
        OlWMProtocolVerify      *olwmpv;

        olwmpv = (OlWMProtocolVerify *) event;
        if (olwmpv->msgtype == OL_WM_DELETE_WINDOW) {
	   if (install_pid > 0)
	   {
	       popup_confirmer();
	       set_text_widget(wLabel, 1, "Installation is not complete,");
	       set_text_widget(wLabel2, 1, " do you still want to quit?");
	       adjust_confirm_window(1);
	       XtUnmapWidget(okBut);
	       XtMapWidget(yesBut);
	       XtMapWidget(noBut);
	   }
        }
}

get_font_info()
{
	Widget   tmpwidget;

	n = 0;
	XtSetArg (args[n], XtNx, 4);  n++;
	XtSetArg (args[n], XtNy, 4);  n++;
	XtSetArg (args[n], XtNmappedWhenManaged, FALSE);  n++;
	tmpwidget = XtCreateWidget("label", staticTextWidgetClass,
                                    mainFrame, args, n);
	n = 0;
	XtSetArg(args[n], XtNfont, &labelFontInfo);  n++;
	XtSetArg(args[n], XtNbackground, &winBg);  n++;
	XtSetArg(args[n], XtNforeground, &winFg);  n++;
	XtGetValues(tmpwidget, args, n);
	ch_ascent = labelFontInfo->max_bounds.ascent;
	ch_descent = labelFontInfo->max_bounds.descent;
	charHeight = ch_ascent + labelFontInfo->max_bounds.descent;
	charWidth = labelFontInfo->max_bounds.width;
	if (labelFontInfo && labelFontInfo->fid)
	     XSetFont(dpy, gc, labelFontInfo->fid);
}

#else

set_text_widget(lwidget, resize, label)
Widget  lwidget;
char    *label;
int	resize;
{
	int	len;

        xmstr = XmStringLtoRCreate(label, XmSTRING_DEFAULT_CHARSET);
        XtSetArg (args[0], XmNlabelString, xmstr);
	XtSetValues(lwidget, args, 1);
/*
	XtFree(xmstr);
*/
        XmStringFree(xmstr);
	if (resize)
	{
	   len = XTextWidth(labelFontInfo, label, strlen(label));
	   if (lwidget == wLabel)
		messLen = len;
	   else if (lwidget == wLabel2)
		messLen2 = len;
	}
}

win_exit_proc()
{
	if (install_pid > 0)
	{
	       popup_confirmer();
	       set_text_widget(wLabel, 1, "Installation is not complete,");
	       set_text_widget(wLabel2, 1, " do you still want to quit?");
	       adjust_confirm_window(1);
	       XtUnmapWidget(okBut);
	       XtMapWidget(yesBut);
	       XtMapWidget(noBut);
	}
}

get_font_info()
{
	char   *font_name;

	labelFontInfo = XLoadQueryFont (dpy, fontv);
	if (labelFontInfo == NULL)
	{
     	    if (charHeight > 16)
		labelFontInfo = XLoadQueryFont (dpy, "9x15");
	    else if (charHeight >= 12)
		labelFontInfo = XLoadQueryFont (dpy, "8x13");
	    else
		labelFontInfo = XLoadQueryFont (dpy, "6x13");
	}
	if (labelFontInfo == NULL)
	    return;
	
	ch_ascent = labelFontInfo->max_bounds.ascent;
	ch_descent = labelFontInfo->max_bounds.descent;
	charHeight = ch_ascent + labelFontInfo->max_bounds.descent;
	charWidth = labelFontInfo->max_bounds.width;
	XSetFont(dpy, gc, labelFontInfo->fid);

	n = 0;
	XtSetArg(args[n], XtNbackground, &winBg);  n++;
	XtSetArg(args[n], XtNforeground, &winFg);  n++;
	XtGetValues(mainFrame, args, n);
}

#endif


void
resize_main_frame()
{
	static int firstTime = 1;
	Dimension  hh, ww, w2;
	Position   posy;

	if (firstTime)
	{
#ifdef MOTIF
	    XtSetArg (args[0], XtNwidth, &ww); 
	    XtSetArg (args[1], XtNheight, &hh); 
	    XtSetArg (args[2], XtNy, &posy); 
	    XtGetValues(execWin, args, 3);
	    w2 = ww;
	    XtGetValues(mainFrame, args, 1);
	    if (ww > w2)
		w2 = ww;
	    if (optWin)
	    {
	        XtGetValues(optWin, args, 1);
	        if (ww > w2)
		    w2 = ww;
	    }
	    XtGetValues(infoWin, args, 1);
	    if (ww > w2)
		w2 = ww;
	    if ((int)w2 < sysWinWidth)
		w2 = sysWinWidth;
	    hh = hh + posy;
	    XtSetArg (args[0], XtNheight, hh); 
	    XtSetArg (args[1], XtNwidth, w2); 
	    XtSetValues(topShell, args, 2);
#endif
	    main_win_expose();
	    firstTime = 0;
	}
}


int
cal_opt_lines(snode)
 VOPTION  *snode;
{
	int	 max_count;
	VOPTION  *cur_opt;

	if (snode == NULL)
	   return(0);
	max_count = 0;
	cur_opt = snode;
	while (cur_opt != NULL)
	{
	    if (cur_opt->count > max_count)
		max_count = cur_opt->count;
	    cur_opt = cur_opt->next;
	}
	cur_opt = snode;
	while (cur_opt != NULL)
	{
	    cur_opt->max_count = max_count;
	    cur_opt = cur_opt->next;
	}
	return(max_count);
}



int
cal_opt_width(snode)
 VOPTION  *snode;
{
	int	 max_len, len;
	VCHOICE  *c_node;
	VOPTION  *cur_opt;

	if (snode == NULL)
	   return(1);
	max_len = 0;
	cur_opt = snode;
	while (cur_opt != NULL)
	{
	    c_node = cur_opt->choices;
	    while (c_node != NULL)
	    {
		len = XTextWidth(labelFontInfo,c_node->message,c_node->mess_len);
		if (len > max_len)
			max_len = len;
		c_node = c_node->next;
	    }
	    cur_opt = cur_opt->next;
	}
	cur_opt = snode;
	while (cur_opt != NULL)
	{
	    cur_opt->max_len = max_len + charWidth;
	    cur_opt = cur_opt->next;
	}
	password_len = XTextWidth(labelFontInfo,"Password:", 9);
	return(max_len);
}


void
disp_sys_choice(option)
VCHOICE *option;
{
	int	x, y, mark_y;
	int	k;

        XSetForeground (dpy, gc, winFg);
	x = info_x;
	y = rowHeight - ch_descent;
	mark_y = y - markWidth + 2;
	while (option != NULL)
	{
	    if (online_link && option->online_item)
		k = 0;
	    else
	    {
	        if (option->selected)
		   k = 1;
		else
		   k = 2;
	    }
	    if (k == 1)
	         XCopyArea(dpy, markMap1, sysId, gc, 0, 0, markWidth, markWidth,
			mark_x, mark_y);
	    if (k == 2)
	         XCopyArea(dpy, markMap0, sysId, gc, 0, 0, markWidth, markWidth,
			mark_x, mark_y);
	    XDrawString (dpy,sysId,gc, x, y, option->message,option->mess_len);
	    y += rowHeight;
	    mark_y += rowHeight;
	    option = option->next;
	}
}

void
expose_sys_win()
{
	if (cur_sys_node)
	    disp_sys_choice(cur_sys_node->choices);
}


void
disp_opt_choice(option, expose)
VCHOICE *option;
int	expose;
{
	int	x, y, mark_y;

        XSetForeground (dpy, gc, winFg);
	x = info_x;
	y = rowHeight - ch_descent;
	mark_y = y - markWidth + 2;
	while (option != NULL)
	{
	     if (option->selected)
	         XCopyArea(dpy, markMap1, optId, gc, 0, 0, markWidth, markWidth,
			mark_x, mark_y);
	     else
	         XCopyArea(dpy, markMap0, optId, gc, 0, 0, markWidth, markWidth,
			mark_x, mark_y);
	     XDrawString (dpy,optId,gc, x, y, option->message,option->mess_len);
	     set_password_option(option, expose);
	     y += rowHeight;
	     mark_y += rowHeight;
	     option = option->next;
	}
}

void
expose_opt_win()
{
	if (cur_opt_node)
	      disp_opt_choice(cur_opt_node->choices, 1);

}

cal_selected_size()
{
	VCHOICE *choice;

	totalSize = 0;
	if (cur_sys_node != NULL)
	{
	    choice = cur_sys_node->choices;
	    while (choice != NULL)
	    {
		if (choice->selected)
		{
		    if (online_link)
		    {
			if (!choice->online_item)
		    	    totalSize = totalSize + choice->size;
		    }
		    else
		    	totalSize = totalSize + choice->size;
		}
		choice = choice->next;
	    }
	}
	if (cur_opt_node != NULL)
	{
	    choice = cur_opt_node->choices;
	    while (choice != NULL)
	    {
		if (choice->selected)
		    totalSize = totalSize + choice->size;
		choice = choice->next;
	    }
	}
}

disp_size_selected()
{
	int	y;
	VCHOICE *choice;
	static int  tx = 0;

	cal_selected_size();
	sprintf(tmpstr, "Total selected: ");
	if (tx == 0)
	    tx = XTextWidth(labelFontInfo,tmpstr, 16) + info_x + charWidth;
        XSetForeground (dpy, gc, winFg);
	y = rowHeight - ch_descent;
	XDrawString(dpy, sizeId, gc, info_x + charWidth, y, tmpstr, 16);
	XClearArea(dpy, sizeId, tx, 0, charWidth * 12, rowHeight + 4, FALSE);
        XSetForeground (dpy, gc, textPix);
	sprintf(tmpstr, "%d KB", totalSize);
	XDrawString(dpy, sizeId, gc, tx, y,tmpstr,strlen(tmpstr));
}



void
expose_size_win()
{
	disp_size_selected();
}

void
choice_select_proc(w, c_data, x_event)
Widget  w;
XtPointer c_data;
XEvent  *x_event;
{
	int	     row;
	static int   which = 0;
	static int   my;
	static int   picked = -1;
	static  VOPTION  *opt = NULL;
	static  VCHOICE  *option = NULL;
	Window       xwin;
	XButtonEvent butev;
	XMotionEvent motev;

	if (install_pid > 0) /* it is installing something */
		return;
	
	which = (int) c_data;
	if (which == 1)
	{
		xwin = sysId;
		opt = cur_sys_node;
	}
	else
	{
		xwin = optId;
		opt = cur_opt_node;
	}
	if (opt == NULL)
		return;
        switch (x_event->type)  {
          case ButtonRelease:
                if (picked < 0 || option == NULL)
                    return;
		if (option->selected)
		{
	            XCopyArea(dpy, markMap0, xwin, gc, 0, 0, markWidth, markWidth, mark_x, my);
		    option->selected = 0;
		}
		else
		{
	            XCopyArea(dpy, markMap1, xwin, gc, 0, 0, markWidth, markWidth, mark_x, my);
		    option->selected = 1;
		}
		disp_size_selected();
		if (which != 1)
		    set_password_option(option, 0);
                picked = -1;
		break;
          case MotionNotify:
                if (picked < 0)
                    return;
		motev = x_event->xmotion;
		if (motev.x < mark_x || motev.x > mark_x + markWidth)
		    picked = -1;
		if (motev.y < my || motev.y > my + markWidth)
		    picked = -1;
		if (picked < 0)
		{
		    if (option->selected)
	                XCopyArea(dpy, markMap1, xwin, gc, 0, 0, markWidth,
				 markWidth, mark_x, my);
		    else
			XCopyArea(dpy, markMap0, xwin, gc, 0, 0, markWidth,
				 markWidth, mark_x, my);
		}
		break;
          case ButtonPress:
                picked = -1;
		butev = x_event->xbutton;
		if (butev.button != 1)
		    return;
		if (butev.x < mark_x || butev.x > mark_x + markWidth)
		    return;
		row = butev.y / rowHeight + 1;
		if (row > opt->count)
		    return;
		my = rowHeight * row - ch_descent - markWidth + 2;
		if (butev.y >= my && butev.y <= my + markWidth)
		    picked = row - 1;
		else
		    return;
		option = opt->choices;
		while (option != NULL)
		{
		    if (option->id == picked)
			break;
		    option = option->next;
		}
		if (option == NULL)
		{
		    picked = -1;
		    return;
		}
	        if (online_link)
		{
		    if (option->online_item)
		    {
			picked = -1;
			return;
		    }
		}
		if (option->selected)
	            XCopyArea(dpy, markMap2, xwin, gc, 0, 0, markWidth,
				 markWidth, mark_x, my);
		else
	            XCopyArea(dpy, markMap3, xwin, gc, 0, 0, markWidth,
				 markWidth, mark_x, my);
		break;
	 }
}


show_online_choice()
{
	int	 y;
	VCHOICE  *option = NULL;

	if (cur_sys_node == NULL)
	    return;
	option = cur_sys_node->choices;
	while (option != NULL)
	{
	    if (option->online_item)
		break;
	    option = option->next;
	}
	if (option == NULL)
	    return;
	y = rowHeight * (option->id + 1) - ch_descent - markWidth + 2;
	if (online_link)
	{
	    XClearArea(dpy, sysId, mark_x, y, markWidth, markWidth, FALSE);
	}
	else
	{
	    if (option->selected)
	        XCopyArea(dpy, markMap1, sysId, gc, 0, 0, markWidth,
				 markWidth, mark_x, y);
	    else
	        XCopyArea(dpy, markMap0, sysId, gc, 0, 0, markWidth,
				 markWidth, mark_x, y);
	}
}


main(argc, argv)
int     argc;
char    **argv;
{
	int    k, found, m, j;
	char   *dstr;
	EventMask  emask;
	VOPTION  *new_node;
	VOPTION  *cur_opt;

	if (argc < 3)
	{
	    fprintf(stderr, "Install: argument missing\n");
	    exit(0);
	}
	j = 1;
	if (strcmp(argv[1], "0") == 0)
	{
	    show_location = 0;
	    j = 2;
	}
	else if (strcmp(argv[1], "1") == 0)
	{
	    show_location = 1;
	    j = 2;
	}
	
	n = strlen(argv[0]);
	dstr = argv[0];
	while (n > 0)
	{
	    n--;
	    if (*(dstr + n) == '/')
		break;
	}
	prog_dir = (char *) malloc(n + 4);
	help_dir = (char *) malloc(n + 4);
	if (n <= 0)
	{
	    strcpy(prog_dir, "./");
	    strcpy(help_dir, "./");
	}
	else
	{
	    strncpy(prog_dir, argv[0], n+1);
	    prog_dir[n+1] = '\0';
	    strcpy(help_dir, prog_dir);
	    dstr = help_dir;
	    while (n > 0)
	    {
		n--;
		if (*(dstr + n) == '/')
		{
		    *(dstr + n + 1) = '\0';
		    break;
		}
	    }
	    if (n <= 0)
	        strcpy(help_dir, "./");
	}
	n = strlen(argv[0]);
	dstr = argv[0] + n - 1;
	while (n > 1)
	{
	    n--;
	    if (*dstr == '.')
		break;
	    dstr--;
	}
	if (*dstr == '.')
	    strcpy(machine, dstr+1);
	else
	    strcpy(machine, "sol"); /* this situation won't happen */

	for(n = j; n < argc; n++)
	{
	    dstr = argv[n];
	    if (strcmp(dstr, "-debug") == 0)
	    {
		debug = 1;
		continue;
	    }
	    if (*dstr == '-')
	    {
		n++;
		continue;
	    }
	    k = 0;
	    found = 0;
	    while (*dstr != '\0')
	    {
		if (*dstr == '.')
		{
		    found = 1;
		    dstr++;
		    break;
		}
	        dstr++;
		k++;
	    }
	    if ( !found  || k <= 1)
		continue;
	    m = 1;
	    if (strcmp(dstr, "opt") == 0)
	    {
		m = 2;
	    }
	    
	    new_node = (VOPTION *) malloc(sizeof(VOPTION));
	    new_node->base_name = (char *) malloc(k + 2);
	    strncpy(new_node->base_name, argv[n], k);
	    new_node->base_name[k] = '\0';
	    new_node->opt_name = (char *) malloc((int)strlen(argv[n]) + 2);
	    strcpy(new_node->opt_name, argv[n]);
	    new_node->next = NULL;
	    if (m == 1)  /*  system choices */
	    {
		if ( sys_node_start == NULL)
		    sys_node_start = new_node;
		else
		{
		    cur_opt = sys_node_start;
		    while (cur_opt->next != NULL)
			cur_opt = cur_opt->next;
		    cur_opt->next = new_node;
		}
	    }
	    else   /* option choices */
	    {
		if ( opt_node_start == NULL)
		    opt_node_start = new_node;
		else
		{
		    cur_opt = opt_node_start;
		    while (cur_opt->next != NULL)
			cur_opt = cur_opt->next;
		    cur_opt->next = new_node;
		}
	    }
	}
	main_opt_num = 0;
	cur_opt = sys_node_start;
	while (cur_opt != NULL)
	{
	     main_opt_num++;
	     get_option_data(cur_opt);
	     cur_opt = cur_opt->next;
	}
	if (main_opt_num <= 0)
	{
		fprintf(stderr, "Install: no opt file exist\n");
		exit(0);
	}
	main_opt_num++;
	cur_opt = opt_node_start;
	while (cur_opt != NULL)
	{
	     get_option_data(cur_opt);
	     cur_opt = cur_opt->next;
	}
	sysWinRows = cal_opt_lines(sys_node_start);
	optWinRows = cal_opt_lines(opt_node_start);
	if (sysWinRows <= 0)
	{
		fprintf(stderr, "Install: all files are empty.\n");
		exit(0);
	}

	find_acqproc();
	create_main_frame(argc, argv);
	sysWinWidth = cal_opt_width(sys_node_start);
	optWinWidth = cal_opt_width(opt_node_start) + (PASSWD + 10) * charWidth;
	if (sysWinWidth < charWidth * 50)
           sysWinWidth = charWidth * 50;

	if (sysWinWidth > optWinWidth)
	   optWinWidth = sysWinWidth;
	else
	   sysWinWidth = optWinWidth;
	create_icon_window();
	sepWin = create_separator(mainWin);
	create_sys_window(sepWin);
	if (sysWin)
	   sepWin = create_separator(sysWin);
	if (opt_node_start != NULL && optWinRows > 0)
	   create_option_window(sepWin);
	if (optWin)
	   sepWin = create_separator(optWin);
	create_size_window(sepWin);
	sepWin = create_separator(sizeWin);
	create_info_window(sepWin);
	sepWin = create_separator(infoWin);
	create_exec_window(sepWin);

	XtRealizeWidget(topShell);
	topShellId = XtWindow(topShell);
	sysId = XtWindow(sysWin);
	sizeId = XtWindow(sizeWin);

	create_mark_map();
	cdromMap = XCreatePixmap (dpy,topShellId,ICONWIDTH,ICONWIDTH,winDepth);
	set_pix_info(&cdrom_info, cdrom_data, cdrom_num, cdrom_colors, cdrom_chs);
	draw_pixmap(cdromMap, cdrom_info, 0);

	XtAddCallback(sysWin, XtNexposeCallback, expose_sys_win,
                	(XtPointer)0);
	emask = ButtonPressMask | ButtonReleaseMask | Button1MotionMask;
	XtAddEventHandler(sysWin, emask, False, choice_select_proc, (XtPointer) 1);
	if (optWin2 != NULL)
	{
	    optId = XtWindow(optWin2);
	    XtAddEventHandler(optWin2, emask, False, choice_select_proc, (XtPointer) 2);
	    XtAddCallback(optWin2, XtNexposeCallback, expose_opt_win,
                		(XtPointer)0);
	}
	XtAddCallback(sizeWin, XtNexposeCallback, expose_size_win,
                	(XtPointer)0);
#ifdef OLIT
	OlAddCallback(topShell, XtNwmProtocol, win_exit_proc, NULL);
#else
        deleteAtom = XmInternAtom(dpy, "WM_DELETE_WINDOW", FALSE);
        XmAddProtocolCallback(topShell, XM_WM_PROTOCOL_ATOM(topShell),
                        deleteAtom, win_exit_proc, 0);
	if (opt_node_start != NULL)
	{
	  for(k = 0; k < opt_node_start->max_count; k++)
	    XtUnmapWidget(password[k]);
	}
#endif

	XtAddEventHandler(topShell,StructureNotifyMask, False, resize_main_frame, (XtPointer)NULL);
	XtMainLoop();
}


find_acqproc()
{
        char    field2[ 12 ], field3[ 12 ], field4[ 122 ];
        char    *cptr, *proc_name, *ptr;
        int     proc_id, ival, len;
        FILE    *fpipe;


        fpipe = popen( "ps -e", "r" );
	if (fpipe == NULL)
                return;
	proc_name = field4;
	while ((cptr = fgets(tmpstr, 120, fpipe )) != NULL)
	{
            ival = sscanf( tmpstr, "%d%s%s%s",
                        &proc_id,
                        &field2[ 0 ],
                        &field3[ 0 ],
                        &field4[ 0 ]);
            if (ival != 4) continue;
	    len = strlen(proc_name);
	    if (len >= 7)
	    {
		if (strstr(proc_name, "Expproc") != (char *) 0)
		{
			acq_pid = proc_id;
			if (debug)
			  fprintf(stderr, " Expproc id: %d\n", proc_id);
		}
		else if (strstr(proc_name, "Acqproc") != (char *) 0)
		{
			acq_pid = proc_id;
			if (debug)
			  fprintf(stderr, " Acqproc id: %d\n", proc_id);
		}
/*
		ptr = proc_name + (len - 7);
	        if (strcmp(ptr, "Acqproc") == 0)
	        {
			acq_pid = proc_id;
		}
	        if (strcmp(ptr, "Expproc") == 0)
	        {
			acq_pid = proc_id;
		}
*/
		
	    }
	}
	pclose(fpipe);
}


int
find_vnmr3()
{
        char    field2[ 12 ], field3[ 12 ], field4[ 122 ];
        char    *cptr, *proc_name, *ptr;
        int     proc_id, ival, len, ret;
        FILE    *fpipe;


        fpipe = popen( "ps -e", "r" );
	if (fpipe == NULL)
                return(-1);
	proc_name = field4;
	ret = -1;
	while ((cptr = fgets(tmpstr, 120, fpipe )) != NULL)
	{
            ival = sscanf( tmpstr, "%d%s%s%s",
                        &proc_id,
                        &field2[ 0 ],
                        &field3[ 0 ],
                        &field4[ 0 ]);
            if (ival != 4) continue;
	    len = strlen(proc_name);
	    if (len >= 8)
	    {
		ptr = proc_name + (len - 8);
	        if (strcmp(ptr, "i_vnmr.3") == 0)
		{
			ret = proc_id;
		}
	    }
	}
	pclose(fpipe);
	return(ret);
}


char  *prgName = "Install";
char  *bgp = "-bg";
char  *bgv = "LightGray";
char  *fgp = "-fg";
char  *fgv = "black";
char  *geomp = "-geometry";
char  *fontp = "-fn";
char  *fontrm = "-xrm";
int   nargc;

create_main_frame(argc, argv)
int	argc;
char    **argv;
{
     int     x,  rows, hh, diff, screen;
     int     shell_x, shell_y;
     Dimension  xw;
     char    *display;


     display = NULL;
     for (x = 1; x < argc - 1; x++)
     {
	if (argv[x][0] == '-')
	{
	   if (strcmp(argv[x], "-display") == 0)
	   {
	      if (argv[x+1] != NULL)
		  display = argv[x+1];
	      x++;
	   }
	   if (strcmp(argv[x], "-bg") == 0)
	   {
	      if (argv[x+1] != NULL)
		  bgv = argv[x+1];
	      x++;
	   }
	   else if (strcmp(argv[x], "-fg") == 0)
	   {
	      if (argv[x+1] != NULL)
		  fgv = argv[x+1];
	      x++;
	   }
	}
     }
     dpy = XOpenDisplay(display);
     if (dpy == NULL)
     {
	fprintf(stderr, "Could not open window\n");
	exit(0);
     }
	     
     screen = XDefaultScreen(dpy);
     screenHeight = DisplayHeight (dpy, screen);
     screenWidth = DisplayWidth (dpy, screen);
     XCloseDisplay (dpy);

     shell_y = 10;
     shell_x = 300;
     if (screenWidth < 700)
	shell_x = 30;
     else if (screenWidth < 900)
	shell_x = 100;
     sprintf(location, "+%d+%d", shell_x, shell_y);
     charHeight = 20;
     rows = sysWinRows + optWinRows + 1;
     if (rows < 10)
        row_gap = 20;
     else
        row_gap = 10;
     hh = screenHeight - VGAP *2 - 66 - 250;
#ifdef IRIX
     sprintf(fontv, "9x15");
#else
     sprintf(fontv, "courb18");
#endif
     while (1)
     {
         rowHeight = charHeight + row_gap;
	 diff = hh - rows * rowHeight;
	 if (diff <= 0)
	 {
	      if (row_gap > 6)
		row_gap -= 2;
	      else
	      {
		if (charHeight == 20)
		   charHeight = 16;
		else if (charHeight == 16)
		   charHeight = 14;
		else
	           break;
		row_gap = 10;
	      }
	 }
	 else
	      break;
     }
     if (charHeight == 16)
#ifdef IRIX
        sprintf(fontv, "8x13");
#else
	sprintf(fontv, "courb14");
#endif
     else if (charHeight == 14)
#ifdef IRIX
        sprintf(fontv, "6x13");
#else
	sprintf(fontv, "courb12");
#endif
     sprintf(fontrv, "*fontList:%s", fontv);

     nargv[0] = prgName;
     nargv[1] = fontp;
     nargv[2] = fontv;
     nargv[3] = bgp;
     nargv[4] = bgv;
     nargv[5] = geomp;
     nargv[6] = location;
     nargv[7] = fontrm;
     nargv[8] = fontrv;
     nargv[9] = fgp;
     nargv[10] = fgv;
     nargc = 11;
     nargv[nargc] = NULL;

     topShell = XtInitialize("Install","Install",
                        NULL, 0, (Cardinal *)&nargc, nargv);

     dpy = XtDisplay(topShell);

     screen = XDefaultScreen(dpy);
     sprintf(tmpstr, "INSTALLATION OF VNMR %s", REVISION_ID);
     n = 0;
     XtSetArg (args[n], XtNtitle, tmpstr); n++;
     XtSetValues (topShell, args, n);

     gc = DefaultGC(dpy, screen);
     xw = main_opt_num * (66 + ICONGAP) + ICONGAP;
#ifdef MOTIF
     if (xw < 400)
	xw = 400;
#endif
     n = 0;
     XtSetArg (args[n], XtNwidth, xw);  n++;
     XtSetArg (args[n], XtNheight, 300);  n++;
#ifdef OLIT
     mainFrame = XtCreateManagedWidget("",
                        formWidgetClass, topShell, args, n);
#else
     mainFrame = (Widget)XmCreateForm(topShell, "", args, n);
     XtManageChild(mainFrame);
#endif
     get_font_info();
     rowHeight = charHeight + row_gap;
     winDepth = DefaultDepth(dpy, screen);
     xblack = XBlackPixel(dpy, screen);
     xwhite = XWhitePixel(dpy, screen);
     cmap = XDefaultColormap(dpy, screen);
     get_light_color();
}


#ifdef OLIT

Widget 
create_draw_window(parent, topWidget, width, height, x, y, from_form)
 Widget parent, topWidget;
 int	width, height, x, y, from_form;
{
	Widget  nwidget;

        n = 0;
	if (from_form)
	{
	    XtSetArg(args[n], XtNxAddWidth, TRUE); n++;
            XtSetArg(args[n], XtNyAddHeight, TRUE); n++;
	    XtSetArg(args[n], XtNborderWidth, 0);  n++;
            XtSetArg(args[n], XtNxResizable, TRUE);  n++;
	    XtSetArg(args[n], XtNxAttachRight, TRUE); n++;
            XtSetArg(args[n], XtNyResizable, FALSE);  n++;
	    if (topWidget != NULL)
	    {
	    	XtSetArg(args[n], XtNyRefWidget, topWidget); n++;
	    }
	}
	if (x >= 0)
	{
	    XtSetArg(args[n], XtNx, x); n++;
	}
	if (y >= 0)
	{
	    XtSetArg(args[n], XtNy, y); n++;
	}

        XtSetArg (args[n], XtNwidth, (Dimension)width);  n++;
        XtSetArg (args[n], XtNheight, (Dimension)height);  n++;
	nwidget = XtCreateManagedWidget("", drawAreaWidgetClass,
                         parent, args, n);
	return(nwidget);
}

Widget
create_control_win(parent, topWidget, vertical, from_form)
Widget  parent, topWidget;
int	vertical, from_form;
{
	Widget  twidget;

        n = 0;
	if (from_form) /* PARENT IS FORMwIDGET */
	{
	    XtSetArg(args[n], XtNxAddWidth, TRUE); n++;
            XtSetArg(args[n], XtNyAddHeight, TRUE); n++;
            XtSetArg(args[n], XtNxResizable, TRUE);  n++;
	    XtSetArg(args[n], XtNxAttachRight, TRUE); n++;
	    if (topWidget != NULL)
	    {
	       XtSetArg(args[n], XtNyRefWidget, topWidget); n++;
	    }
	}
	if (vertical)
	{
            XtSetArg (args[n], XtNlayoutType, OL_FIXEDCOLS);  n++;
	}
	else
	{
            XtSetArg (args[n], XtNlayoutType, OL_FIXEDROWS);  n++;
	}
        XtSetArg (args[n], XtNmeasure, 1);  n++;
        twidget = XtCreateManagedWidget("",
                        controlAreaWidgetClass, parent, args, n);
	return(twidget);
}


Widget 
create_label_widget(parent, label)
Widget  parent;
char    *label;
{
	Widget  lwidget;

        n = 0;
        XtSetArg (args[n], XtNstring, label);  n++;
        XtSetArg (args[n], XtNgravity, WestGravity);  n++;
        XtSetArg (args[n], XtNstrip, FALSE);  n++;
	XtSetArg (args[n], XtNalignment, OL_LEFT);  n++;
        lwidget = XtCreateManagedWidget("label", staticTextWidgetClass,
                        parent, args, n);
	return(lwidget);
}

TextEditWidget
create_text_widget(parent, x, y, line, len, visible)
Widget  parent;
int      x, y, line, len, visible;
{
	TextEditWidget   twidget;

	n = 0;
	XtSetArg(args[n], XtNx, x); n++;
	XtSetArg(args[n], XtNy, y); n++;
	XtSetArg(args[n], XtNbottomMargin, 0); n++;
	XtSetArg(args[n], XtNtopMargin, 0); n++;
	XtSetArg(args[n], XtNinsertTab, FALSE); n++;
	if (visible == 0)
	{
	   XtSetArg(args[n], XtNmappedWhenManaged, FALSE); n++;
	}
	XtSetArg(args[n], XtNlinesVisible, line); n++;
	XtSetArg(args[n], XtNcharsVisible, len); n++;
        XtSetArg(args[n], XtNborderWidth, 1);  n++;
	twidget = (TextEditWidget) XtCreateManagedWidget("",
                 	textEditWidgetClass, parent, args, n);
	return(twidget);
}

void
text_verify(w, client_data, call_data)
  Widget          w;
  XtPointer       client_data;
  XtPointer       call_data;
{
	OlTextModifyCallData   *vf;

	vf = (OlTextModifyCallData *) call_data;
	if (*vf->text == RETURN)
	   vf->ok = 0;
}


Widget
create_button(parent, label, func, val, show)
Widget  parent;
char    *label;
void    (*func)();
int	val, show;
{
        Widget  button;

	n = 0;
        XtSetArg (args[n], XtNlabel, label);  n++;
	if (!show)
	{
	    XtSetArg (args[n], XtNmappedWhenManaged, FALSE);  n++;
	}
        button = XtCreateManagedWidget("",
                        oblongButtonWidgetClass, parent, args, n);
        XtAddCallback(button, XtNselect, func, (XtPointer)val);
	return(button);
}


#else
 /*   Motif */

Widget 
create_draw_window(parent, topWidget, width, height, x, y, from_form)
 Widget parent, topWidget;
 int	width, height, x, y, from_form;
{
	Widget  nwidget;

        n = 0;
	if (from_form)
	{
	    if (topWidget != NULL)
	    {
	    	XtSetArg(args[n], XmNtopAttachment, XmATTACH_WIDGET); n++;
	    	XtSetArg (args[n], XmNtopWidget, topWidget); n++;
	    }
            XtSetArg(args[n], XmNleftAttachment, XmATTACH_FORM);  n++;
            XtSetArg(args[n], XmNrightAttachment, XmATTACH_FORM); n++;
	}
	if (x >= 0)
	{
	    XtSetArg(args[n], XmNx, x); n++;
	}
	if (y >= 0)
	{
	    XtSetArg(args[n], XmNy, y); n++;
	}

        XtSetArg (args[n], XtNwidth, (Dimension)width);  n++;
        XtSetArg (args[n], XtNheight, (Dimension)height);  n++;
        XtSetArg (args[n], XmNmarginHeight, 0);  n++;
	nwidget = XtCreateManagedWidget("", xmDrawingAreaWidgetClass,
                         parent, args, n);
	return(nwidget);
}

Widget
create_control_win(parent, topWidget, vertical, from_form)
Widget  parent, topWidget;
int	vertical, from_form;
{
	Widget  twidget;

        n = 0;
	if (from_form) /* PARENT IS FORMwIDGET */
	{
	    XtSetArg (args[n], XmNleftAttachment, XmATTACH_FORM); n++;
            XtSetArg (args[n], XmNrightAttachment, XmATTACH_FORM); n++;
            XtSetArg(args[n], XmNborderWidth, 0);  n++;
            if (topWidget != NULL)
            {
            	XtSetArg (args[n], XmNtopAttachment, XmATTACH_WIDGET); n++;
            	XtSetArg (args[n], XmNtopWidget, topWidget); n++;
            }
	}
	if (vertical)
	{
	    if (from_form)
	    {
		if (row_gap > 4)
		{
		    XtSetArg (args[n], XmNmarginHeight, row_gap - 4); n++;
		}
	    }
	    XtSetArg(args[n], XmNorientation, XmVERTICAL); n++;
        }
	else
	{
	    XtSetArg (args[n], XmNorientation, XmHORIZONTAL); n++;
	}
        XtSetArg(args[n], XmNpacking, XmPACK_TIGHT);  n++;
	twidget = (Widget) XmCreateRowColumn(parent, "", args, n);
        XtManageChild (twidget);
        return(twidget);
}

Widget 
create_label_widget(parent, label)
Widget  parent;
char    *label;
{
	Widget  lwidget;
	XmString mstring;

	n =0;
        mstring = XmStringLtoRCreate(label, XmSTRING_DEFAULT_CHARSET);
        XtSetArg (args[n], XmNlabelString, mstring);  n++;
	XtSetArg (args[n], XmNalignment, XmALIGNMENT_BEGINNING);  n++;
        lwidget = (Widget)XmCreateLabel(parent, "", args, n);
        XtManageChild (lwidget);
/*
        XtFree(mstring);
*/
        XmStringFree(xmstr);
	return(lwidget);
}

Widget
create_text_widget(parent, x, y, line, len, visible)
Widget  parent;
int      x, y, line, len, visible;
{
	Widget   twidget;

	n = 0;
	if (x >= 0)
	{
	   XtSetArg(args[n], XtNx, x); n++;
	}
	if (y >= 0)
	{
	   XtSetArg(args[n], XtNy, y); n++;
	}
	XtSetArg (args[n], XmNmarginHeight, 1); n++;
	XtSetArg (args[n], XmNcolumns, len); n++;
	XtSetArg (args[n], XmNrows, line); n++;
	XtSetArg (args[n], XmNhighlightThickness, 1); n++;
	XtSetArg (args[n], XmNborderWidth, 1); n++;
	twidget = (Widget)XmCreateText(parent, "", args, n);
        XtManageChild (twidget);
	return(twidget);
}


void
text_verify(w, client_data, call_data)
  Widget          w;
  XtPointer       client_data;
  XtPointer       call_data;
{
	XmTextVerifyCallbackStruct   *vf;

	vf = (XmTextVerifyCallbackStruct *) call_data;
	if (vf->reason == XmCR_ACTIVATE)
	   vf->doit = FALSE;
}


Widget
create_button(parent, label, func, val, show)
Widget  parent;
char    *label;
void    (*func)();
int	val, show;
{
        Widget  button;

	n = 0;
	xmstr = XmStringLtoRCreate(label, XmSTRING_DEFAULT_CHARSET);
        XtSetArg (args[n], XmNlabelString, xmstr);  n++;
        XtSetArg (args[n], XmNtraversalOn, FALSE);  n++;
	if (!show)
	{
	    XtSetArg(args[n], XmNmappedWhenManaged, FALSE); n++;
	}
        button = (Widget) XmCreatePushButton(parent, "", args, n);
        XtManageChild (button);
        XtAddCallback(button, XmNactivateCallback, func, (XtPointer)val);
/*
        XtFree(xmstr);
*/
        XmStringFree(xmstr);
	return(button);
}


#endif


void
main_win_expose()
{
	static int  first_time = 1;
	Dimension  ww, hh;
	int	  gap, y, x, num;
	VOPTION   *vnode;

	if (first_time)
	{
	    first_time = 0;
            n = 0;
            XtSetArg(args[n], XtNwidth, &ww);  n++;
            XtSetArg(args[n], XtNheight, &hh);  n++;
	    XtGetValues(mainWin, args, n);
	    gap = ((int) ww - main_opt_num * 66 ) / (main_opt_num + 1);
	    x = gap;
	    y = ((int) hh - 66 ) / 2;
	    vnode = (VOPTION *) malloc(sizeof(VOPTION));
	    vnode->base_name = (char *) malloc(6);
	    strcpy(vnode->base_name, "logo");
	    read_xpm_data(vnode, 0, x, y);
	    vnode = sys_node_start;
	    x = gap * 2 + 66;
	    num = 0;
	    while (vnode != NULL)
	    {
		num++;
		read_xpm_data(vnode, num, x, y);
		x = x + gap + 66;
		vnode = vnode->next;
	    }
	    if (num <= 1)
	        but_info_selected = but_info_start->next;
	    set_option(but_info_selected);
	}
}



set_option(iconInfo)
ICONINFO  *iconInfo;
{
	XClearWindow(dpy, sysId);
	if (optWin)
	{
	     if (cur_opt_node != NULL)
	         clear_password(cur_opt_node);
	     XClearWindow(dpy, optId);
	}
	if (iconInfo == NULL)
	     return;
	cur_sys_node = iconInfo->opt;
	if (cur_sys_node)
	     disp_sys_choice(cur_sys_node->choices);
	else
	     return;
	cur_opt_node = opt_node_start;
	while (cur_opt_node != NULL)
	{
	     if (strcmp(cur_opt_node->base_name, cur_sys_node->base_name) == 0)
		 break;
	     cur_opt_node = cur_opt_node->next;
	}
	if (cur_opt_node)
	      disp_opt_choice(cur_opt_node->choices, 0);
	disp_size_selected();
}
	     

void
delete_acq_proc(w, client_data, call_data)
  Widget          w;
  XtPointer       client_data;
  XtPointer       call_data;
{
	delete_acq = (int) client_data;
}


void
online_lk_proc(w, client_data, call_data)
  Widget          w;
  XtPointer       client_data;
  XtPointer       call_data;
{
	online_link = (int) client_data;
	show_online_choice();
	disp_size_selected();
}

void
vnmr_lk_proc(w, client_data, call_data)
  Widget          w;
  XtPointer       client_data;
  XtPointer       call_data;
{
	vnmr_link = (int) client_data;
}



Widget
create_yes_no(parent, label, func, set_item, but)
Widget  parent;
char    *label;
void    (*func)();
int     set_item;
Widget  *but;
{
	Widget pwidget, exwidget;

	pwidget = create_control_win(parent, NULL, 0, 0);
	create_label_widget(pwidget, label);
	n = 0;
#ifdef OLIT
	exwidget = XtCreateManagedWidget("", exclusivesWidgetClass, 
			pwidget, args, n);
	n = 0;
	XtSetArg (args[n], XtNlabel, "Yes"); n++;
	but[0] = XtCreateManagedWidget ("", rectButtonWidgetClass,
			 exwidget, args, n);
        XtAddCallback(but[0], XtNselect,(XtPointer) func, 1);
	n = 0;
	XtSetArg (args[n], XtNlabel, "No"); n++;
	if (set_item != 0)
	{
	    XtSetArg (args[n], XtNset, TRUE); n++;
	}

	but[1] = XtCreateManagedWidget ("", rectButtonWidgetClass,
			 exwidget, args, n);
        XtAddCallback(but[1], XtNselect, (XtPointer) func, 0);
#else
	XtSetArg(args[n], XmNorientation, XmHORIZONTAL); n++;
	XtSetArg (args[n], XmNpacking, XmPACK_TIGHT);  n++;
	exwidget = (Widget) XmCreateRadioBox(pwidget, "", args, n);
        XtManageChild (exwidget);
	n =0;
	if (set_item == 0)
	     XtSetArg (args[n], XtNset, TRUE);
	else
	     XtSetArg (args[n], XtNset, FALSE);
	n++;
        but[0] = (Widget) XmCreateToggleButtonGadget(exwidget, "Yes", args, n);
        XtManageChild (but[0]);
        XtAddCallback(but[0], XmNvalueChangedCallback, func, (XtPointer) 1);
	if (set_item)
	     XtSetArg (args[n], XtNset, TRUE);
	else
	     XtSetArg (args[n], XtNset, FALSE);
	n++;
        but[1] = (Widget) XmCreateToggleButtonGadget(exwidget, "No", args, n);
        XtManageChild (but[1]);
        XtAddCallback(but[1], XmNvalueChangedCallback, func, (XtPointer) 0);
#endif
	return(exwidget);
}



create_info_window(topWidget)
Widget  topWidget;
{
	Widget   tmpWidget;

	infoWin = create_control_win(mainFrame, topWidget, 1, 1);
	tmpWidget = create_control_win(infoWin, NULL, 0, 0);
	if (show_location)
	{
	   create_label_widget(tmpWidget, dest_label);

           n = 0;
#ifdef OLIT
           XtSetArg (args[n], XtNstring, "/export/home/vnmr");  n++;
           XtSetArg(args[n], XtNcharsVisible, 22);  n++;
           dirWidget = XtCreateManagedWidget("", textFieldWidgetClass,
                        tmpWidget, args, n);
#else
	   dirWidget = create_text_widget(tmpWidget, -1, -1, 1, 22, 1);
#ifdef AIX
	   XtSetArg (args[0], XmNvalue, "/home/vnmr");
#else
	   XtSetArg (args[0], XmNvalue, "/usr/people/vnmr");
#endif
	   XtSetValues(dirWidget, args, 1);
#endif
	}

	delete_acq = 1;
	kbut[0] = NULL;
	kbut[1] = NULL;
	if (acq_pid > 0)
	   create_yes_no(infoWin, acq_label, delete_acq_proc, 0, kbut);

	vnmr_link = 1;
	if (show_location)
	   create_yes_no(infoWin, vnmr_label, vnmr_lk_proc, 0, vlink);

	online_link = 0;
	olink[0] = NULL;
	olink[1] = NULL;
#ifndef AIX
        /*Commented out due to manuals has its own CD.*/
        /*need to clean up later*/
	/*create_yes_no(infoWin, online_label, online_lk_proc, 1, olink);*/
#endif
}


void
install_proc()
{
	char   *dest_dir;
	double  ratio;
	int	free_space, len;
	char    dir_str[256];
	VCHOICE *tchoice;
#ifdef SOLARIS
	struct statvfs sbuf;
#else
	struct statfs  sbuf;
#endif

	if (cur_sys_node == NULL)
	    return;
	if (show_location)
	{
	    dest_dir = get_text_widget(dirWidget);
	    if (dest_dir == NULL || (int) strlen(dest_dir) <= 0)
	    {
     	       if (confirmShell == NULL)
	          popup_confirmer();
	       set_text_widget(wLabel, 1, "Don't know the destination directory.");
	       set_text_widget(wLabel2, 1, " ");
	       adjust_confirm_window(0);
	       XtMapWidget(okBut);
	       XtUnmapWidget(yesBut);
	       XtUnmapWidget(noBut);
	       return;
	    }
	    strcpy(dir_str, dest_dir);
	}
	else
	    strcpy(dir_str, "/vnmr");
	cal_selected_size();
	while (1)
	{
#ifdef SOLARIS
	   if (statvfs(dir_str, &sbuf) >= 0)
#else
#ifdef IRIX
	   if (statfs(dir_str, &sbuf, sizeof (struct statfs), 0) >= 0)
#else
	   if (statfs(dir_str, &sbuf) >= 0)
#endif
#endif
	   {
#ifdef SOLARIS
	      free_space = sbuf.f_bavail;
#else
	      ratio = (float)sbuf.f_bsize / 1024.0;
	      free_space = (int)(sbuf.f_bfree * ratio);
#endif
	      if (free_space < totalSize + 10)
	      {
	       	popup_confirmer();
		sprintf(tmpstr, "There is only %d KB free space in the directory", free_space);
	       	set_text_widget(wLabel, 1, tmpstr);
		sprintf(tmpstr, "%s. Please make more space or select fewer options.", dir_str);
	       	set_text_widget(wLabel2, 1, tmpstr);
	       	adjust_confirm_window(0);
	       	XtMapWidget(okBut);
	       	XtUnmapWidget(yesBut);
	       	XtUnmapWidget(noBut);
	       	return;
	      }
	      break;
	   }
	   else
	   {
	        len = strlen(dir_str) - 1;
		dest_dir = dir_str + len - 1;
	        while (len > 0)
	        {
		     if (*dest_dir == '/')
		     {
			*(dest_dir+1) = '\0';
			break;
		     }
		     len--;
		     dest_dir--;
		}
		if (len <= 0)
		     break;
	   }
	}
	if (!debug)
	   create_install_win();
	n = 0;
	if (!debug)
	{
#ifdef OLIT
          XtSetArg (args[n], XtNbusy, TRUE);  n++;
#else
          XtSetArg (args[n], XmNsensitive, FALSE);  n++;
#endif
	  XtSetValues(installBut, args, n);
	}
	exec_install();
}

void
help_proc()
{
	create_help_window();
}


void
quit_proc()
{
	if (install_pid > 0)
	{
	     popup_confirmer();
	     set_text_widget(wLabel, 1,"Installation is not complete,");
	     set_text_widget(wLabel2, 1, " do you still want to quit?");
	     adjust_confirm_window(1);
	     XtUnmapWidget(okBut);
	     XtMapWidget(yesBut);
	     XtMapWidget(noBut);
	}
	else
	{
             XCloseDisplay(dpy);
             exit(0);
	}
}


create_exec_window(topWidget)
Widget  topWidget;
{
	execWin = create_control_win(mainFrame, topWidget, 0, 1);
	n = 0;
#ifdef OLIT
	XtSetArg (args[n], XtNvPad, 10);  n++;
	XtSetArg (args[n], XtNhPad, charWidth * 8);  n++;
        XtSetArg (args[n], XtNhSpace, charWidth * 5);  n++;
#else
        XtSetArg (args[n], XmNspacing, charWidth * 6);  n++;
        XtSetArg (args[n], XmNmarginWidth, charWidth * 9);  n++;
#endif
	XtSetValues(execWin, args, n);

	installBut = create_button (execWin, "Install", install_proc,1, 1);
	quitBut = create_button (execWin, "Quit", quit_proc, 3, 1);
	helpBut = create_button (execWin, "Help", help_proc, 2, 1);
}



void
draw_separator(w, client_data, call_data)
  Widget          w;
  XtPointer       client_data;
  XtPointer       call_data;
{
	Dimension width, height;
        Window    win;

        win = XtWindow(w);
        n = 0;
        XtSetArg(args[n], XtNwidth, &width);  n++;
        XtSetArg(args[n], XtNheight, &height);  n++;
	XtGetValues(w, args, n);
        XSetForeground (dpy, gc, lightPix);
        XDrawLine (dpy, win, gc, 0, 0, (int)width, 0);
        XDrawLine (dpy, win, gc, 0, 2, (int)width, 2);
        XSetForeground (dpy, gc, xblack);
        XDrawLine (dpy, win, gc, 0, 1, (int)width, 1);
}


Widget
create_separator(topWidget)
Widget  topWidget;
{
	Widget		tmpwidget;

	tmpwidget = create_draw_window(mainFrame, topWidget, 100, 3, -1, -1, 1);
#ifdef MOTIF
        XtSetArg(args[0], XmNrightAttachment, XmATTACH_FORM);
	XtSetValues(tmpwidget, args, 1);
#endif
        XtAddEventHandler(tmpwidget,StructureNotifyMask, False, draw_separator,
			 (XtPointer)NULL);
	XtAddCallback(tmpwidget, XtNexposeCallback, draw_separator,
                	 (XtPointer)0);
	return(tmpwidget);
}


get_light_color()
{
        int      red, green, blue;
	int	 red2, green2, blue2;
	XColor	 bcolor;

        bcolor.pixel = winBg;
        bcolor.flags = DoRed | DoGreen | DoBlue;
        XQueryColor(dpy, cmap, &bcolor);
        bcolor.red = bcolor.red >> 8;
        bcolor.green = bcolor.green >> 8;
        bcolor.blue = bcolor.blue >> 8;
        red = bcolor.red + 40;
        green = bcolor.green + 40;
        blue = bcolor.blue + 40;
	if (red > 240)
	    red = 240;
	if (green > 240)
	    green = 240;
	if (blue > 240)
	    blue = 240;
	xcolor.red = red << 8;
        xcolor.green = green << 8;
        xcolor.blue = blue << 8;
        XAllocColor(dpy, cmap, &xcolor);
	lightPix = xcolor.pixel;
        red2 = red - 150;
        green2 = green -150;
        blue2 = blue - 150;
	if (red2 < 0)
	    red2 = 0;
	if (green2 < 0)
	    green2 = 0;
	if (blue2 < 0)
	    blue2 = 0;
	xcolor.red = red2 << 8;
        xcolor.green = green2 << 8;
        xcolor.blue = blue2 << 8;
        XAllocColor(dpy, cmap, &xcolor);
	darkPix = xcolor.pixel;

        red = bcolor.red -20;
        green = bcolor.green -20;
        blue = bcolor.blue - 20;
	if (red < 0)
	    red = 0;
	if (green < 0)
	    green = 0;
	if (blue < 0)
	    blue = 0;
	xcolor.red = red << 8;
        xcolor.green = green << 8;
        xcolor.blue = blue << 8;
        XAllocColor(dpy, cmap, &xcolor);
	grayPix = xcolor.pixel;

	xcolor.red = 240 << 8;
        xcolor.green = 210 << 8;
        xcolor.blue = 180 << 8;
        XAllocColor(dpy, cmap, &xcolor);
	barBg = xcolor.pixel;

	xcolor.red = 250 << 8 ;
        xcolor.green = 240 << 8;
        xcolor.blue = 210 << 8;
        XAllocColor(dpy, cmap, &xcolor);
	barLight = xcolor.pixel;

	xcolor.red = 250 << 8;
        xcolor.green = 30 << 8;
        xcolor.blue = 30 << 8;
        XAllocColor(dpy, cmap, &xcolor);
	textPix = xcolor.pixel;
}


draw_icon(iconInfo, set)
ICONINFO  *iconInfo;
int	   set;
{
	int	x, y, width, height;
	Window	xwin;

	if (iconInfo == NULL)
	    return;
     	xwin = iconInfo->window;
	width = iconInfo->pix_data.width;
	height = iconInfo->pix_data.height;
	if (set)
	   XCopyArea(dpy, iconInfo->butMap2, xwin, gc, 0, 0,
                width, height, 1, 1);
	else
	   XCopyArea(dpy, iconInfo->butMap, xwin, gc, 0, 0,
                width, height, 1, 1);
	if (iconInfo->id == 0)
	    return;
	iconInfo->set = set;
	x = width + 1;
	y = height + 1;
	if (set)
            XSetForeground (dpy, gc, darkPix);
	else
            XSetForeground (dpy, gc, lightPix);
        XDrawLine (dpy, xwin, gc, 0, 0, x, 0);
        XDrawLine (dpy, xwin, gc, 0, 0, 0, y);
	if (set)
            XSetForeground (dpy, gc, lightPix);
	else
            XSetForeground (dpy, gc, darkPix);
        XDrawLine (dpy, xwin, gc, x, 0, x, y);
        XDrawLine (dpy, xwin, gc, 0, y, x, y);
}


main_but_expose(w, client_data, call_data)
  Widget          w;
  XtPointer       client_data;
  XtPointer       call_data;
{
     	Window    xwin;
        ICONINFO  *iconInfo;
	int	  y;

	iconInfo = (ICONINFO *) client_data;
     	xwin = XtWindow(w);
	iconInfo->window = xwin;
	if (iconInfo->butMap == NULL)
	{
	   iconInfo->butMap = XCreatePixmap (dpy, topShellId, ICONWIDTH,
                         ICONWIDTH, winDepth);
	   if (iconInfo->pix_data.data != NULL)
	       draw_pixmap(iconInfo->butMap, iconInfo->pix_data, 0);
	   else
	   {
	       y = (ICONWIDTH - charHeight) / 2 + ch_ascent;
	       if (y < 6)
		   y = 6;
               XSetForeground (dpy, gc, winBg);
	       XFillRectangle(dpy, iconInfo->butMap, gc, 0, 0,
		  ICONWIDTH, ICONWIDTH );
               XSetForeground (dpy, gc, textPix);
	       XDrawString(dpy, iconInfo->butMap, gc, 0, y,
		  iconInfo->opt->base_name, strlen(iconInfo->opt->base_name));
	   }
	   iconInfo->butMap2 = XCreatePixmap (dpy, topShellId, ICONWIDTH,
                         ICONWIDTH, winDepth);
	   if (iconInfo->pix_data.data)
	       draw_pixmap(iconInfo->butMap2, iconInfo->pix_data, 1);
	   else
	   {
               XSetForeground (dpy, gc, grayPix);
	       XFillRectangle(dpy, iconInfo->butMap2, gc, 0, 0,
		  ICONWIDTH, ICONWIDTH );
               XSetForeground (dpy, gc, textPix);
	       XDrawString(dpy, iconInfo->butMap2, gc, 0, y, 
		  iconInfo->opt->base_name, strlen(iconInfo->opt->base_name));
	   }
	}
	if (iconInfo != but_info_selected)
	   draw_icon(iconInfo, UNSET);
	else
	   draw_icon(iconInfo, SET);
}

void
main_but_proc(w, c_data, x_event)
Widget  w;
XtPointer c_data;
XEvent  *x_event;
{
        ICONINFO  *iconInfo;
	static int   enter = 0;

	if (install_pid >= 0) /* it is installing something */
		return;
	iconInfo = (ICONINFO *) c_data;
        switch (x_event->type)  {
          case ButtonRelease:
          case LeaveNotify:
                if (!enter)
                    return;
                enter = 0;
                if (x_event->type == ButtonRelease)
		{
		     if (iconInfo != but_info_selected)
			set_option(iconInfo);
		     but_info_selected = iconInfo;
		}	
		else
	        {
		     if (iconInfo != but_info_selected)
		     {
		         draw_icon(iconInfo, UNSET);
		         draw_icon(but_info_selected, SET);
		     }
		}
                break;
          case ButtonPress:
                enter = 1;
		if (iconInfo != but_info_selected)
		{
		     draw_icon(but_info_selected, UNSET);
		     draw_icon(iconInfo, SET);
		}
                break;
        }
}


draw_pixmap(map, pix_info, focus)
 Pixmap  	  map;
 struct map_info  pix_info;
 int		  focus;
{
	int    color;
	int	x, y;
	Pixel   pix, bg;
	char   *data, pdata;

	if (focus)
	   bg = grayPix;
	else
	   bg = winBg;
	for (color = 0; color < pix_info.colors; color++)
	{
	   pdata = pix_info.colorChs[color];
	   if (pdata == ' ')
		pix = bg;
	   else
		pix = pix_info.pixelVals[color];
           XSetForeground (dpy, gc, pix);
	   for(y = 0; y < pix_info.height; y++)
	   {
		data = pix_info.data[y];
		for(x = 0; x < pix_info.width; x++)
		{
		    if (*data == pdata)
			XDrawPoint(dpy, map, gc, x, y);
		    data++;
		}
	   }
	}
}


set_pix_info(p_info, pdata, cname, colors, colorChs)
 struct map_info *p_info;
 char   **pdata;
 char	**cname;
 int	colors;
 char	*colorChs;
{
        int     k;
        Pixel   *pixelVals;

        p_info->width = ICONWIDTH;
        p_info->height = ICONWIDTH;
        p_info->data = pdata;
        p_info->colors = colors;
        p_info->colorChs = colorChs;
	pixelVals = (Pixel *) XtCalloc(colors+2, sizeof(Pixel));
        p_info->pixelVals = pixelVals;
        for (k = 0; k < colors; k++)
        {
           XParseColor(dpy, cmap, cname[k], &xcolor);
           XAllocColor(dpy, cmap, &xcolor);
           pixelVals[k] = xcolor.pixel;
	   if (colorChs[k] == ' ')  /* it is background */
		pixelVals[k] = winBg;
	}
	pixelVals[colors] = winBg;
}


create_graph_icon(fdata, butNum, colors, cname, colorChs, x, y, vopt)
 char  **fdata;
 int    butNum;
 int	colors;
 char	**cname;
 char	*colorChs;
 int	x, y;
 VOPTION   *vopt;
{
        ICONINFO  *newIcon, *oldIcon;
	EventMask  emask;
	Widget     but_widget;

        newIcon = (ICONINFO *) XtCalloc (1, sizeof (ICONINFO));
        if (newIcon == NULL)
            return;
	if (but_info_start == NULL)
	    but_info_start = newIcon;
	else
	{
	    oldIcon = but_info_start;
	    while (oldIcon->next != NULL)
		oldIcon = oldIcon->next;
	    oldIcon->next = newIcon;
	}
	newIcon->next = NULL;
	newIcon->set = 0;
	set_pix_info(&newIcon->pix_data, fdata, cname,colors, colorChs);
        newIcon->id = butNum;
	newIcon->butMap = (Pixmap) NULL;
	newIcon->butMap2 = (Pixmap) NULL;
	newIcon->opt = vopt;
	emask = ButtonPressMask | ButtonReleaseMask | LeaveWindowMask;
	but_widget = create_draw_window(mainWin,NULL, ICONWIDTH+2, ICONWIDTH+2, x, y, 0);
     	XtAddCallback(but_widget, XtNexposeCallback,
                main_but_expose, (XtPointer)newIcon);
	if (butNum > 0)
	    XtAddEventHandler(but_widget, emask, False,
                 main_but_proc, (XtPointer)newIcon);
}



get_option_data(opt_node)
 VOPTION *opt_node;
{
        FILE    *fin;
	char    name[32];
	char    *strs;
	int	size, ret, len;
	int	found, count;
	VCHOICE *tchoice, *nchoice, *pchoice;

	sprintf(tmpstr, "%s%s/%s", prog_dir, machine, opt_node->opt_name);
	count = 0;
	tchoice = NULL;
        if ((fin = fopen(tmpstr, "r")) != NULL)
        {
           while ((strs = fgets(tmpstr, 250, fin)) != NULL)
           {
                ret = sscanf(tmpstr, "%s%d", name, &size);
		if (ret < 2)
			continue;
		found = 0;
	        if (tchoice != NULL)
		{
		    nchoice = tchoice;
		    while (nchoice != NULL)
		    {
			if (strcmp(nchoice->info, name) == 0)
			{
			    found = 1;
			    nchoice->size = nchoice->size + size;
			    break;
			}
			nchoice = nchoice->next;
		    }
		}
		if ( !found )
		{
		    nchoice = (VCHOICE *) malloc(sizeof(VCHOICE));
		    nchoice->next = NULL;
		    nchoice->passwd = NULL;
		    nchoice->pwidget = NULL;
		    nchoice->p_len = 0;
		    nchoice->selected = 0;
	            nchoice->online_item = 0;
		    len = strlen(name);
		    nchoice->info = (char *) malloc(len + 2);
		    strcpy(nchoice->info, name);
		    nchoice->size = size;
		    nchoice->id = count;
		    if (tchoice == NULL)
			tchoice = nchoice;
		    else
			pchoice->next = nchoice;
		    pchoice = nchoice;
		    count++;
		}
	     }
	     fclose(fin);
	}
	else
	{
	     if (debug)
		fprintf(stderr, "Install: could not open file %s.\n", tmpstr);
	}
	opt_node->choices = tchoice;
	opt_node->count = count;
	nchoice = tchoice;
	while (nchoice != NULL)
	{
	     sprintf(tmpstr, "%s at %d KB", nchoice->info, nchoice->size);
	     nchoice->mess_len = strlen(tmpstr);
	     nchoice->message = (char *) malloc(nchoice->mess_len + 2);
	     strcpy(nchoice->message, tmpstr);
	     if (strncmp(nchoice->info, "Online_", 7) == 0) /* Online_Manuals */
	         nchoice->online_item = 1;
	     nchoice = nchoice->next;
	}
}


disp_install_ratio()
{
	int	k;
	float   ratio;
	char    info[20];

	if (totalSize <= 0)
                totalSize = 1;
	ratio = (float)sizeInstalled / (float)totalSize;
        if (ratio > 1.0)
             ratio = 1.0;
        XSetForeground (dpy, gc, winBg);
	XFillRectangle(dpy, grafMap, gc, ratio_x, ratio_y, charWidth * 16, charHeight );
	XFillRectangle(dpy, grafWin, gc, ratio_x, ratio_y, charWidth * 16, charHeight );
        XSetForeground (dpy, gc, textPix);
	k = 100 * ratio;
	if (k >= 99)
	    k = 100;
	sprintf(info, "%d%% Completed", k);
	XDrawString(dpy, grafWin, gc, ratio_x, ratio_y + ch_ascent, info, strlen(info));
	XDrawString(dpy, grafMap, gc, ratio_x, ratio_y + ch_ascent, info, strlen(info));
}


void
inc_install_bar()
{
        draw_install_bar();
}



draw_install_bar()
{
        int        gw, x, y;
	static int xwidth = 0;

	gw = disk_x - ICONWIDTH - BSPACE + 4;
	if (draw_forward)
	{
	     if (xwidth >= gw)
	     {
		disp_install_ratio();
		xwidth = 0;
		return;
	     }
	}
	else
	{
	     if (xwidth >= gw)
	     {
        	XSetForeground (dpy, gc, winBg);
		XFillRectangle(dpy, grafMap, gc,  disk_x, cdrom_y, ICONWIDTH, ICONWIDTH);
	        XCopyArea(dpy, grafMap, grafWin, gc, 0, 0, installWidth,
			installHeight, 0, 0);
		return;
	     }
	}
	xwidth += 5;
	if (xwidth > gw)
	     xwidth = gw;
	y = cdrom_y + (ICONWIDTH + BSPACE) / 2;
	if (draw_forward)
	{
	     x = ICONWIDTH + BSPACE - 4;
             XSetForeground (dpy, gc, textPix);
	}
	else
	{
	     x = disk_x - xwidth;
             XSetForeground (dpy, gc, winBg);
	}
	XFillRectangle(dpy, grafMap, gc, x, y, xwidth, BSPACE);
	XFillRectangle(dpy, grafWin, gc, x, y, xwidth, BSPACE);
	XtAddTimeOut(30, inc_install_bar, NULL);
}
	

void
expose_graf_win(w)
Widget  w;
{
	Dimension	width, height;
	static  int	first_time = 1;

	if (first_time)
	{
	    grafWin = XtWindow(installGraf);
	    n = 0;
	    XtSetArg(args[n], XtNwidth, &width);  n++;
	    XtSetArg(args[n], XtNheight, &height);  n++;
	    XtGetValues(w, args, n);
	    installWidth = width;
	    installHeight = height;
	    cdrom_y = installHeight - ICONWIDTH - BSPACE;
	    disk_x = installWidth - ICONWIDTH - BSPACE;
	    diskMap = XCreatePixmap (dpy,topShellId,ICONWIDTH,ICONWIDTH,winDepth);
	    set_pix_info(&disk_info, disk_data, disk_num, disk_colors, disk_chs);
	    draw_pixmap(diskMap, disk_info, 0);
	    grafMap = XCreatePixmap (dpy,topShellId,installWidth,installHeight,winDepth);
            XSetForeground (dpy, gc, winBg);
	    XFillRectangle(dpy, grafMap, gc, 0, 0, installWidth, installHeight);
	    XCopyArea(dpy, cdromMap, grafMap, gc, 0, 0, ICONWIDTH, ICONWIDTH,
			BSPACE, cdrom_y);
	    XCopyArea(dpy, diskMap, grafMap, gc, 0, 0, ICONWIDTH, ICONWIDTH,
			disk_x, cdrom_y);
	    draw_forward = 1;
	    ratio_x = (installWidth - charWidth * 16) / 2;
	    ratio_y = cdrom_y + (ICONWIDTH + BSPACE) / 2;
	    ratio_y = (ratio_y - charHeight) / 2;
	    if (ratio_y < 0)
		ratio_y = 0;
	}
	XCopyArea(dpy, grafMap, grafWin, gc, 0, 0, installWidth, installHeight,
			0, 0);
	if (first_time)
	{
	    XtAddTimeOut(500, inc_install_bar, NULL);
	    first_time = 0;
	}
}


void
resize_install_frame()
{
	static  int	firstTime = 1;
	Dimension  hh, ww, w2;
	Position   posy;

	if (firstTime)
	{
	   XtSetArg(args[0], XtNwidth, &ww);
	   XtGetValues(scrolledWindow, args, 1);
	   w2 = ww;
	   XtGetValues(installGraf, args, 1);
	   if (ww > w2)
		w2 = ww;
	   XtGetValues(installFrame, args, 1);
	   if (ww > w2)
		w2 = ww;
	   XtGetValues(installShell, args, 1);
	   XtSetArg(args[0], XtNheight, &hh);
	   XtSetArg(args[1], XtNy, &posy);
	   XtGetValues(disWin, args, 2);
	   hh = hh + posy;
	   XtSetArg(args[0], XtNwidth, w2);
	   XtSetArg(args[1], XtNheight, hh);
	   XtSetValues(installShell, args, 2);
	   firstTime = 0;
	}
}


create_install_win()
{
	Window  win;
        int     x, y;

	sizeInstalled = 0;
	if (installShell == NULL)
	{
   	   XTranslateCoordinates(dpy, topShellId, RootWindow(dpy, 0),
                        0, 0, &x, &y, &win);
	   if (x > 10)
		x -= 10;
	   sprintf(location, "+%d+0", x);
	   n = 0;
	   XtSetArg (args[n], XtNtitle, "Installation Information"); n++;
     	   XtSetArg (args[n], XtNgeometry, location);  n++;
           installShell = XtCreatePopupShell("text", applicationShellWidgetClass,
				topShell,  args, n);
     	   n = 0;
     	   XtSetArg (args[n], XtNwidth, charWidth * 56);  n++;
     	   XtSetArg (args[n], XtNheight, charHeight * 10 + 80);  n++;
#ifdef OLIT
     	   installFrame = XtCreateManagedWidget("",
                        formWidgetClass, installShell, args, n);
#else
	   installFrame = (Widget)XmCreateForm(installShell, "", args, n);
     	   XtManageChild(installFrame);
#endif
	   create_install_text();
	   create_install_graf();
	   create_install_but();

	   XtAddEventHandler(installShell,StructureNotifyMask, False, resize_install_frame, (XtPointer)NULL);

	   XtRealizeWidget(installShell);
           XtPopup(installShell, XtGrabNone);
	}
}


create_install_graf()
{
	int  hh, ww;

	if (charHeight > ICONWIDTH / 2)
	     hh = charHeight;
	else
	     hh = ICONWIDTH / 2;
	hh = hh + BSPACE * 4 + ICONWIDTH / 2;
	ww = ICONWIDTH * 2 + charWidth * 20;
	installGraf = create_draw_window(installFrame, scrolledWindow, ww, hh, -1, -1, 1);
#ifdef MOTIF
        XtSetArg(args[0], XmNrightAttachment, XmATTACH_FORM);
#endif
	XtSetValues(installGraf, args, 1);
	XtAddCallback(installGraf, XtNexposeCallback, expose_graf_win,
                (XtPointer)0);
}


create_install_but()
{
	disWin = create_control_win(installFrame, installGraf, 0, 1);
#ifdef MOTIF
	n = 0;
        XtSetArg(args[n], XmNleftAttachment, XmATTACH_FORM);  n++;
        XtSetArg(args[n], XmNrightAttachment, XmATTACH_FORM);  n++;
	XtSetValues(disWin, args, n);
#endif
	disBut = create_button(disWin, "Dismiss", quit_proc, 0, 0);
}

void
install_exit()
{
	Dimension   width, height, bw, bh;
	Position    posx, posy;

	if (install_pid >= 0)
	{
	    install_pid = -1;
	    if (sizeInstalled >= totalSize)
	    {
/*
	       set_pix_info(&disk_info, smile_data, smile_num, smile_colors, smile_chs);
	       draw_pixmap(diskMap, disk_info, 0);
	       XCopyArea(dpy, diskMap, grafMap, gc, 0, 0, ICONWIDTH, ICONWIDTH,
			disk_x, cdrom_y);
*/
/**
        	XSetForeground (dpy, gc, winBg);
		XFillRectangle(dpy, grafMap, gc,  disk_x, cdrom_y, ICONWIDTH, ICONWIDTH);
	       XCopyArea(dpy, grafMap, grafWin, gc, 0, 0, installWidth,
			installHeight, 0, 0);
**/
	    }
	    draw_forward = 0;
	    XBell(dpy, 50);
	    XtAddTimeOut(500, inc_install_bar, NULL);
	    XtUnmapWidget(topShell);
	    n = 0;
            XtSetArg(args[n], XtNwidth, &width);  n++;
            XtSetArg(args[n], XtNheight, &height);  n++;
	    XtGetValues(installShell, args, n);
	    n = 0;
            XtSetArg(args[n], XtNy, &posy);  n++;
            XtSetArg(args[n], XtNheight, &bh);  n++;
	    XtGetValues(disWin, args, n);
	    bh = bh + posy;
	    if (bh > height)
	    {
            	XtSetArg(args[0], XtNwidth, width);
            	XtSetArg(args[1], XtNheight, bh);
	        XtSetValues(installShell, args, 2);
	    }
	    n = 0;
            XtSetArg(args[n], XtNy, &posy);  n++;
            XtSetArg(args[n], XtNwidth, &bw);  n++;
	    XtGetValues(disBut, args, n);
	    posx = (int)(width - bw) / 2;
	    if (posx < 0)
		posx = 0;
	    XtMoveWidget(disBut, posx, posy);
	    XtMapWidget(disBut);
	}
}
	

read_install_input()
{
	int	num, ival, size;
	char    *ptr;
	char    mess[256];

	if (grafWin == NULL)
		return;
	if ((num = read(pipe_1[0], tmpstr, 250)) > 1)
        {
	    tmpstr[num] = '\0';
	    ptr = tmpstr;
	    size = 0;
	    while (size < num)
	    {
	       if (*ptr != '$')
		    ptr++;
	       else
	       {
		    *ptr = '\0';
		    break;
	       }
	       size++;
	    }
	    if (size >= num)
		return;
	    sprintf(mess, "%s\n", tmpstr);
#ifdef OLIT
	    OlTextEditInsert(installText, mess, strlen(mess));
#else
	    text_pos = XmTextGetLastPosition(installText);
	    XmTextInsert(installText, text_pos, mess);
	    XmTextShowPosition(installText, text_pos);
#endif
            ival = sscanf( ptr+1, "%d", &size);
	    if (ival == 1 && size > 0)
	    {
		 sizeInstalled += size;
		 disp_install_ratio();
	    }
	}
	else
	{
   	    if (install_pid <= 0)
	    {
	        XtRemoveInput(install_input);
	        close(pipe_1[0]);
	    }
	}
}

/* output to  i_vnmr.3 are the following:
   acq_pid, main option, source_dir, dest_dir,  pipe, online_help link,
   vnmr link, machine(sos, sol, ibm, sgi), choice ...
*/

exec_install()
{
	char    *i_vnmr;
	char    *tdata;
	int     pid, num, items, k;
	VCHOICE *tchoice;
	Widget  txWidget;

	if (pipe(pipe_1) == -1)
        {
	     fprintf(stderr, "ins_sol: pipe failed\n");
	     return;
	}

	i_vnmr = (char *) malloc((int)strlen(prog_dir) + 12);
	sprintf(i_vnmr, "%si_vnmr.3", prog_dir);
	
	nargv[0] = (char *) malloc (20);
	if (delete_acq)
	   sprintf(nargv[0], "%d", acq_pid);
	else
	   sprintf(nargv[0], "%d", -1);
	nargv[1] = (char *) malloc ((int)strlen(cur_sys_node->opt_name) + 2);
	strcpy(nargv[1], cur_sys_node->opt_name);
	nargv[2] = (char *) malloc((int)strlen(prog_dir) + 2);
	strcpy(nargv[2], prog_dir);

	if (show_location)
	{
	    tdata = get_text_widget(dirWidget);
	    if (tdata == NULL || (int) strlen(tdata) <= 0)
	    {
	       popup_confirmer();
	       set_text_widget(wLabel, 1,"Don't know the destination directory.");
	       set_text_widget(wLabel2,1, " ");
	       adjust_confirm_window(0);
	       XtMapWidget(okBut);
	       XtUnmapWidget(yesBut);
	       XtUnmapWidget(noBut);
	       return;
	    }
	    nargv[3] = (char *) malloc((int)strlen(tdata) + 2);
	    strcpy(nargv[3], tdata);
	}
	else
	{
	    nargv[3] = (char *) malloc(6);
	    strcpy(nargv[3], "/vnmr");
	}
	nargv[4] = (char *) malloc(8);
	sprintf(nargv[4], "%d", pipe_1[1]);
	nargv[5] = (char *) malloc(6);
	if (online_link)
	   strcpy(nargv[5], "yes");
	else
	   strcpy(nargv[5], "no");
	nargv[6] = (char *) malloc(6);
	if (vnmr_link)
	   strcpy(nargv[6], "yes");
	else
	   strcpy(nargv[6], "no");

	nargv[7] = (char *) malloc(6);
	strcpy(nargv[7], machine);

	nargv[8] = (char *) malloc(6);

	num = 9;

	cal_selected_size();
	items = 0;
	tchoice = cur_sys_node->choices;
	while (tchoice != NULL)
	{
	     if ((tchoice->online_item && online_link) || tchoice->selected)
	     {
		nargv[num] = (char *) malloc((int)strlen(tchoice->info) + 2);
		strcpy(nargv[num], tchoice->info);
		num++;
		items++;
	     }
	     tchoice = tchoice->next;
	}
	sprintf(nargv[8], "%d", items);

	nargv[num] = (char *) malloc(6);
	k = num;
	num++;
	items = 0;
	if (cur_opt_node != NULL)
	{
	   get_password(cur_opt_node);
/**
	   nargv[num] = (char *) malloc ((int)strlen(cur_opt_node->opt_name) + 2);
	   strcpy(nargv[num], cur_opt_node->opt_name);
	   num++;
**/
	   tchoice = cur_opt_node->choices;
	   while (tchoice != NULL)
	   {
	     if (tchoice->selected)
	     {
		nargv[num] = (char *) malloc((int)strlen(tchoice->info) + 2);
		strcpy(nargv[num], tchoice->info);
		num++;
		tdata = tchoice->passwd;
		if (tdata == NULL || (int) strlen(tdata) <= 0)
		{
		   nargv[num] = (char *) malloc(4);
		   strcpy(nargv[num], "?");
		}
		else
		{
		   nargv[num] = (char *) malloc(strlen(tdata) + 2);
		   strcpy(nargv[num], tdata);
		}
		num++;
		items++;
	     }
	     tchoice = tchoice->next;
	   }
	}
	nargv[num] = (char *)NULL;
	sprintf(nargv[k], "%d", items);
	if (debug)
	{
	    for(k = 0; k < num; k++)
	      fprintf(stderr, " %d. -%s-\n", k, nargv[k]);
	}
	pid = fork();
        if (pid == -1)
        {
	     fprintf(stderr, "ins_sol: could not execute i_vnmr.3\n");
	     return;
        }
	if (!debug)
	{
	    freopen("/dev/null","r",stdin);
   	    freopen("/dev/null","a",stdout);
	    freopen("/dev/null","a",stderr);
	}

	if (pid == 0)
	{
	    for(n = 3; n < 30; n++)
	    {
		if (n != pipe_1[1])
		    close(n);
	    }
	    sprintf(tmpstr, "%si_vnmr.3 ", prog_dir);
	    for (n = 0; n < num; n++)
	    {
		strcat(tmpstr, " ");
	        strcat(tmpstr, nargv[n]);
	    }
	    if (debug)
		fprintf(stderr, " run %s\n", tmpstr);
	    system(tmpstr);
	    exit(0);

	}
	else
	{
	    struct sigaction         intserv;
	    sigset_t                 qmask;

	    install_pid = pid;
	    close(pipe_1[1]);
	    install_input = XtAddInput(pipe_1[0], XtInputReadMask,
                                 read_install_input, NULL);
	    sigemptyset( &qmask );
            sigaddset( &qmask, SIGCHLD );
            intserv.sa_handler = install_exit;
            intserv.sa_mask = qmask;
            intserv.sa_flags = 0;
            sigaction( SIGCHLD, &intserv, NULL );
	    if (show_location)
	    {
#ifdef OLIT
	       XtSetArg (args[0], XtNtextEditWidget, &txWidget);
	       XtGetValues(dirWidget, args, 1);
	       XtSetArg (args[0], XtNsensitive, FALSE);
	       XtSetValues(txWidget, args, 1);
#else
	       XtSetArg (args[0], XmNeditable, FALSE);
	       XtSetValues(dirWidget, args, 1);
#endif
	       XtSetArg (args[0], XtNsensitive, FALSE);
	       XtSetValues(vlink[0], args, 1);
	       XtSetValues(vlink[1], args, 1);
	    }
	    XtSetArg (args[0], XtNsensitive, FALSE);
	    if (olink[0])
	    {
	    	XtSetValues(olink[0], args, 1);
	    	XtSetValues(olink[1], args, 1);
	    }
	    if (kbut[0])
	    {
	    	XtSetValues(kbut[0], args, 1);
	    	XtSetValues(kbut[1], args, 1);
	    }
	}

}

confirm_proc(w, client_data, call_data)
  Widget       w;
  XtPointer    client_data;
  XtPointer    call_data;
{
	int	yes;

	yes = (int) client_data;
	XtUngrabPointer(confirmShell, CurrentTime);
	XtUngrabKeyboard(confirmShell, CurrentTime);
        XtPopdown(confirmShell);
	if (yes == 1)
	{
	     install_pid = -1;
	     kill(0, SIGKILL);
             XCloseDisplay(dpy);
             exit(0);
	}
}

adjust_confirm_window(show_no_button)
int	show_no_button;
{
	Dimension w, h, w2, w3;
	Position  posx;

	XtSetArg (args[0], XtNwidth, &w);
	XtSetArg (args[1], XtNheight, &h);
	XtGetValues(confirmShell, args, 2);
	if (messLen > messLen2)
	   w3 = messLen;
	else
	   w3 = messLen2;
	w3 += 24;
	if (show_no_button)
	{
	   XtSetArg (args[0], XtNwidth, &w2);
	   XtSetArg (args[1], XtNx, &posx);
	   XtGetValues(noBut, args, 2);
	   w2 = w2 + posx + charWidth * 3;
	   if (w2 > w3)
		w3 = w2;
	}
	XtSetArg (args[0], XtNwidth, w3);
#ifdef OLIT
	if (w > w3)
	{
	     XtSetArg (args[1], XtNheight, h);
	     XtSetValues(confirmShell, args, 2);
	}
	else
	{
	     XtSetValues(wLabel, args, 1);
	     XtSetValues(wLabel2, args, 1);
	}
#else
	XtSetArg (args[1], XtNheight, h);
	XtSetValues(confirmShell, args, 2);
#endif
}


popup_confirmer()
{
     Widget  control;
     Window  win;
     int     x, y;
     Dimension  h;
     Position   posy;

     if (confirmShell == NULL)
     {
   	XTranslateCoordinates(dpy, topShellId, RootWindow(dpy, 0),
                        0, 0, &x, &y, &win);
        n = 0;
        XtSetArg (args[n], XtNtitle, "Installation Warning");  n++;
	sprintf(location, "%dx%d+%d+%d", charWidth * 40, charHeight * 6,x+100, y+200);
     	XtSetArg (args[n], XtNgeometry, location);  n++;
        confirmShell = XtCreateWidget("",
                        transientShellWidgetClass, topShell, args, n);
	confirmFrame = create_control_win(confirmShell, NULL, 1, 0);

	wLabel = create_label_widget(confirmFrame, "Installation is not done yet,");
	wLabel2 = create_label_widget(confirmFrame, "do you still want to quit?");

	control = create_control_win(confirmFrame, NULL, 0, 0);
     	n =0;
#ifdef OLIT
     	XtSetArg(args[n], XtNhPad, charWidth * 3); n++;
     	XtSetArg(args[n], XtNhSpace, charWidth * 7); n++;
#else
     	XtSetArg(args[n], XmNmarginWidth, charWidth * 3); n++;
     	XtSetArg(args[n], XmNspacing, charWidth * 7); n++;
#endif
	XtSetValues(control, args, n);

     	n = 0;
	yesBut = create_button(control, "Yes", confirm_proc, 1, 1);
	okBut = create_button(control, "OK", confirm_proc, 2, 0);
	noBut = create_button(control, "No", confirm_proc, 0, 1);
	XtManageChild(confirmShell);
     	XtRealizeWidget(confirmShell);
#ifdef MOTIF
     	XtSetArg (args[0], XtNheight, &h);
     	XtSetArg (args[1], XtNy, &posy);
	XtGetValues(control, args, n);
	h = h + posy;
	XtSetArg (args[0], XtNheight, h);
	XtSetValues(confirmShell, args, 1);
#endif
     }
     XBell(dpy, 20);
     XtPopup(confirmShell, XtGrabNonexclusive);
}


void
close_help()
{
        XtPopdown(helpShell);
}


create_mark_map()
{
	int	x, y, x2, y2;
	int	w;
	unsigned char *map_bits;

	markMap0 =  XCreatePixmap (dpy, topShellId, markWidth,
                         markWidth, winDepth);
	markMap1 =  XCreatePixmap (dpy, topShellId, markWidth,
                         markWidth, winDepth);
	markMap2 =  XCreatePixmap (dpy, topShellId, markWidth,
                         markWidth, winDepth);
	markMap3 =  XCreatePixmap (dpy, topShellId, markWidth,
                         markWidth, winDepth);
	XSetForeground (dpy, gc, winBg);
	XFillRectangle (dpy, markMap0, gc, 0, 0, markWidth, markWidth);
	XFillRectangle (dpy, markMap1, gc, 0, 0, markWidth, markWidth);
	XSetForeground (dpy, gc, grayPix);
	XFillRectangle (dpy, markMap2, gc, 0, 0, markWidth, markWidth);
	XFillRectangle (dpy, markMap3, gc, 0, 0, markWidth, markWidth);
	XSetForeground (dpy, gc, lightPix);
	y = 1;
	x2 = markWidth - 2;
	y2 = markWidth - 1;
	w = markWidth - 1;
	XDrawLine (dpy, markMap0, gc, 0, y, x2, y);
	XDrawLine (dpy, markMap0, gc, 0, y, 0, y2);
	XDrawLine (dpy, markMap1, gc, 0, y, x2, y);
	XDrawLine (dpy, markMap1, gc, 0, y, 0, y2);
	XDrawLine (dpy, markMap2, gc, 0, y2, x2, y2);
	XDrawLine (dpy, markMap2, gc, x2, y, x2, y2);
	XDrawLine (dpy, markMap3, gc, 0, y2, x2, y2);
	XDrawLine (dpy, markMap3, gc, x2, y, x2, y2);
	XSetForeground (dpy, gc, darkPix);
	XDrawLine (dpy, markMap0, gc, 0, y2, x2, y2);
	XDrawLine (dpy, markMap0, gc, x2, y, x2, y2);
	XDrawLine (dpy, markMap1, gc, 0, y2, x2, y2);
	XDrawLine (dpy, markMap1, gc, x2, y, x2, y2);
	XDrawLine (dpy, markMap2, gc, 0, 0, x2, 0);
	XDrawLine (dpy, markMap2, gc, 0, 0, 0, y2);
	XDrawLine (dpy, markMap3, gc, 0, 0, x2, 0);
	XDrawLine (dpy, markMap3, gc, 0, 0, 0, y2);
	if (markWidth >= 15)
	{
	    map_bits = check15;
	    x = 0;
	    y = 2;
	    y2 = markWidth - 1;
	    x2 = markWidth;
	}
	else
	{
	    map_bits = check12;
	    x = 0;
	    y = 16 - markWidth;
	    y2 = markWidth - 1;
	    x2 = markWidth;
	}
	draw_mark(markMap1, map_bits, x, y, x2, y2);
	draw_mark(markMap3, map_bits, x, y, x2, y2);
}

draw_mark(xmap, icon_bits, x, y, w, h)
Pixmap  xmap;
unsigned char    *icon_bits;
int     x, y, w, h;
{
        int     y2, x2,  row, count, next_row;
        unsigned char  *data, bit;
	static  int   first_time = 1, pindex;

	if (!first_time)
	{
	   XDrawPoints(dpy, xmap, gc, check_pnts, pindex, CoordModeOrigin);
	   return;
	}
	XSetForeground (dpy, gc, textPix);
	pindex = 0;
	y2 = 0;
        for(row = 0; row < h; row++)
        {
            x2 = x;
            data = (unsigned char *)(icon_bits + y * 2);
            bit = 0x01;
	    next_row = 0;
            for(;;)
            {
                bit = 0x01;
                for (count = 0; count < 8; count++)
                {
                    if (*data & bit)
                    {
			check_pnts[pindex].x = x2;
			check_pnts[pindex].y = y2;
			pindex++;
                    }
                    bit = bit << 1;
                    x2++;
		    if (x2 >= w)
		    {
			next_row = 1;
			break;
		    }
                }
		if (next_row)
		    break;
		data++;
            }
	    y2++;
	    y++;
        }
	XDrawPoints(dpy, xmap, gc, check_pnts, pindex, CoordModeOrigin);
	first_time = 0;
}



set_password_option(node, from_expose)
VCHOICE  *node;
int	 from_expose;
{
	int	x, y;

	x = opt_node_start->max_len + info_x;
	if (node->selected)
	{
	    XSetForeground (dpy, gc, textPix);
	    y = rowHeight * (node->id +1) - ch_descent;
	    XDrawString(dpy, optId, gc, x, y, "Password:", 9);
	    if (!from_expose)
	    {
	       XtMapWidget(password[node->id]);
#ifdef OLIT
	       OlTextEditClearBuffer(password[node->id]);
	       if (node->passwd)
		  OlTextEditInsert(password[node->id], node->passwd, strlen(node->passwd));
	       OlCallAcceptFocus((Widget)password[node->id], CurrentTime);
#else
	       if (node->passwd)
	          XmTextSetString(password[node->id], node->passwd);
	       else
	          XmTextSetString(password[node->id], "");
	       XtSetKeyboardFocus(optWin2, password[node->id]);
#endif
	    }
            XSetForeground (dpy, gc, winFg);
	}
	else
	{
	    if (!from_expose)
	    {
	       XtUnmapWidget(password[node->id]);
	       y = rowHeight * node->id + 4;
	       XClearArea(dpy, optId, x, y, password_len, rowHeight, FALSE);
	    }
	}
}

create_password_widget()
{
	int	x, y, k, m;

	m = opt_node_start->max_count;
	password = (TextEditWidget *) malloc((int)sizeof(TextEditWidget) * m);
	x = opt_node_start->max_len + info_x + password_len;
#ifdef OLIT
	y = row_gap + 4;
#else
	if (row_gap > 4)
	    y = row_gap - 4;
	else
	    y = 0;
#endif
	for(k = 0; k < m; k++)
	{
	   password[k] = create_text_widget(optWin2, x, y, 1, PASSWD, 0);
	   XtAddCallback(password[k], XtNmodifyVerification, text_verify, 0);
	   y += rowHeight;
	}
}

get_password(opt)
VOPTION  *opt;
{
	int	len;
	char    *data, *data2;
	VCHOICE  *node;

	node = opt->choices;
	while (node != NULL)
	{
	    if (node->selected)
	    {
#ifdef OLIT
		OlTextEditCopyBuffer(password[node->id], &data);
#else
		data = (char *) XmTextGetString(password[node->id]);
#endif
		if (data != NULL)
		{
		    strcpy(tmpstr, data);
/*
		    XtFree(data);
*/
		    data = tmpstr;
		    while (*data == ' ')
			data++;
		    len = strlen(data);
		    data2 = data + len - 1;
		    while (len > 0)
		    {
		        if (*data2 == ' ')
			   *data2 = '\0';
			else
			   break;
			len--;
			data2--;
		    }
		    len = strlen(data);
		    if (len < 10)
			len = 10;
		    if (node->p_len <= len)
		    {
			if (node->passwd)
			    free(node->passwd);
			node->passwd = (char *) malloc(len + 2);
			node->p_len = len;
		    }
		    strcpy(node->passwd, data);
		}
	    }
	    node = node->next;
	}
}

clear_password(opt)
VOPTION  *opt;
{
	int	k;

	get_password(opt);
	for(k = 0; k < opt_node_start->max_count; k++)
	    XtUnmapWidget(password[k]);
}

#ifdef OLIT

create_icon_window()
{
        int       width, height;

	/*  total number of icon is options + logo */
	width = main_opt_num * (66 + ICONGAP) + ICONGAP;
	if (width < optWinWidth)
	    width = optWinWidth;
	height = 66 + VGAP * 2;

        n = 0;
	XtSetArg(args[n], XtNxAddWidth, TRUE); n++;
        XtSetArg(args[n], XtNyAddHeight, TRUE); n++;
        XtSetArg(args[n], XtNborderWidth, 0);  n++;
        XtSetArg (args[n], XtNwidth, width);  n++;
        XtSetArg (args[n], XtNheight, height);  n++;
        XtSetArg (args[n], XtNlayout, OL_MAXIMIZE );  n++;
        XtSetArg(args[n], XtNxResizable, TRUE);  n++;
	XtSetArg(args[n], XtNxAttachRight, TRUE); n++;
        mainWin = XtCreateManagedWidget("",
                        bulletinBoardWidgetClass, mainFrame, args, n);
}


create_sys_window(topWidget)
Widget  topWidget;
{
	int	height;
	Dimension  w, h;
	TextEditWidget  twidget;

	markWidth = ch_ascent;
	if (markWidth < 8)
	   markWidth = 8;
	mark_x = charWidth + 6;
	info_x = mark_x + markWidth + charWidth;
	height = (sys_node_start->max_count) * rowHeight + row_gap;
	sysWinWidth = sysWinWidth + info_x;
	sysWin = create_draw_window(mainFrame,topWidget,sysWinWidth,height,-1,-1,1);
/***
	n = 0;
	XtSetArg(args[n], XtNx, 0); n++;
	XtSetArg(args[n], XtNy, 0); n++;
	XtSetArg(args[n], XtNbottomMargin, 0); n++;
	XtSetArg(args[n], XtNtopMargin, 0); n++;
	XtSetArg(args[n], XtNmappedWhenManaged, FALSE); n++;
	XtSetArg(args[n], XtNlinesVisible, 1); n++;
	XtSetArg(args[n], XtNcharsVisible, 2); n++;
        XtSetArg(args[n], XtNborderWidth, 1);  n++;
	twidget = (TextEditWidget) XtCreateManagedWidget("",
                 	textEditWidgetClass, mainFrame, args, n);
	XtSetArg(args[0], XtNwidth, &w);
	XtSetArg(args[1], XtNheight, &h);
	XtGetValues(twidget, args, 2);
	rowHeight = (int)h + 3;
***/
}


create_option_window(topWidget)
Widget  topWidget;
{
	int		height, width;

	if (opt_node_start == NULL)
	{
	    optWin = NULL;
	    return;
	}
	height = opt_node_start->max_count * rowHeight + row_gap;
	width = optWinWidth + info_x;
	optWin = create_draw_window(mainFrame,topWidget,width,height,-1,-1,1);
	optWin2 = optWin;
	create_password_widget();
}


create_size_window(topWidget)
Widget  topWidget;
{
	int	height, width;

	height = rowHeight + row_gap;
	width = optWinWidth + info_x;
	sizeWin = create_draw_window(mainFrame,topWidget,width,height,-1,-1,1);
}


create_install_text()
{
        scrolledWindow = XtCreateManagedWidget("",
                        scrolledWindowWidgetClass, installFrame, NULL, 0);
	n = 0;
        XtSetArg (args[n], XtNxAddWidth, TRUE);  n++;
        XtSetArg (args[n], XtNyAddHeight, TRUE);  n++;
        XtSetArg (args[n], XtNxAttachRight, TRUE);  n++;
        XtSetArg (args[n], XtNxResizable, TRUE);  n++;
  	XtSetArg(args[n], XtNlinesVisible, 9); n++;
	XtSetArg(args[n], XtNcharsVisible, 55); n++;
	XtSetArg(args[n], XtNborderWidth, 1); n++;
	XtSetArg(args[n], XtNinsertTab, FALSE);   n++;
	XtSetArg(args[n], XtNblinkRate, 0);   n++;
	XtSetArg(args[n], XtNsensitive, TRUE);   n++;
   	installText = (TextEditWidget) XtCreateManagedWidget("",
                        textEditWidgetClass, scrolledWindow, args, n);
}


create_help_window()
{
     Widget  pwidget, scroll, twidget;

     if (helpShell == NULL)
     {
	sprintf(location, "+%d+%d", 300, 100);
        n = 0;
        XtSetArg (args[n], XtNtitle, "Installation Help");  n++;
	XtSetArg (args[n], XtNgeometry, location);  n++;
        helpShell = XtCreateApplicationShell("",
				 transientShellWidgetClass, args, n);
	pwidget = create_control_win(helpShell, NULL, 1, 0);

	sprintf(tmpstr, "%sreadme.txt", help_dir);
        n = 0;
	XtSetArg(args[n], XtNlinesVisible, 19); n++;
	XtSetArg(args[n], XtNcharsVisible, 60); n++;
	XtSetArg(args[n], XtNborderWidth, 1); n++;
	XtSetArg(args[n], XtNsensitive, FALSE);   n++;
	XtSetArg(args[n], XtNsourceType, OL_DISK_SOURCE);   n++;
	XtSetArg(args[n], XtNsource, tmpstr);   n++;
	scroll = XtCreateManagedWidget("",
                        scrolledWindowWidgetClass, pwidget, NULL, 0);
        XtCreateManagedWidget("",
                        textEditWidgetClass, scroll, args, n);
	twidget = create_control_win(pwidget, NULL, 0, 0);
	create_button(twidget, "Close", close_help, 0, 1);
     	XtRealizeWidget(helpShell);
    }
    if (helpShell != NULL)
        XtPopup(helpShell, XtGrabNone);
}

#else

  /*   Motif ....  */

create_icon_window()
{
        int       width, height;

	/*  total number of icon is options + logo */
	width = main_opt_num * (66 + ICONGAP) + ICONGAP;
	height = 66 + VGAP * 2;

        n = 0;
        XtSetArg (args[n], XtNwidth, width);  n++;
        XtSetArg (args[n], XtNheight, height);  n++;
        XtSetArg(args[n], XmNleftAttachment, XmATTACH_FORM);  n++;
        XtSetArg(args[n], XmNrightAttachment, XmATTACH_FORM);  n++;
        mainWin = XtCreateManagedWidget("",
                        xmBulletinBoardWidgetClass, mainFrame, args, n);
}


create_sys_window(topWidget)
Widget  topWidget;
{
	int	height;
	Dimension  w, h;
	Widget  twidget;

	markWidth = ch_ascent;
	if (markWidth < 8)
	   markWidth = 8;
	mark_x = charWidth + 6;
	info_x = mark_x + markWidth + charWidth;
	height = (sys_node_start->max_count) * rowHeight + row_gap;
	sysWinWidth = sysWinWidth + info_x;
	sysWin = create_draw_window(mainFrame,topWidget,sysWinWidth,height,-1,-1,1);
/***
	n = 0;
	XtSetArg(args[n], XmNx, 0); n++;
	XtSetArg(args[n], XmNy, 0); n++;
	XtSetArg(args[n], XmNmarginHeight, 1); n++;
	XtSetArg(args[n], XmNmappedWhenManaged, FALSE); n++;
        XtSetArg(args[n], XmNborderWidth, 1);  n++;
	twidget = (Widget) XmCreateText(mainFrame, "tt", args, n);
	XtManageChild(twidget);
	XtSetArg(args[0], XtNwidth, &w);
	XtSetArg(args[1], XtNheight, &h);
	XtGetValues(twidget, args, 2);
	rowHeight = (int)h + 4;
***/
}


create_option_window(topWidget)
Widget  topWidget;
{
	int		height, width;

	if (opt_node_start == NULL)
	{
	    optWin = NULL;
	    return;
	}
	height = opt_node_start->max_count * rowHeight + row_gap;
	width = optWinWidth + info_x;
	n = 0;
	if (topWidget)
        {
           XtSetArg(args[n], XmNtopAttachment, XmATTACH_WIDGET); n++;
           XtSetArg (args[n], XmNtopWidget, topWidget); n++;
        }
        XtSetArg(args[n], XmNleftAttachment, XmATTACH_FORM);  n++;
        XtSetArg(args[n], XmNrightAttachment, XmATTACH_FORM); n++;
        XtSetArg (args[n], XtNwidth, (Dimension)width);  n++;
        XtSetArg (args[n], XtNheight, (Dimension)height);  n++;
        XtSetArg (args[n], XmNmarginHeight, 0);  n++;
        XtSetArg (args[n], XmNmarginWidth, 0);  n++;
        optWin = XtCreateManagedWidget("",
                        xmBulletinBoardWidgetClass, mainFrame, args, n);
        n = 0;
        XtSetArg (args[n], XtNwidth, (Dimension) width); n++;
        XtSetArg (args[n], XtNheight, (Dimension)height);  n++;
        XtSetArg (args[n], XtNx, 0);  n++;
        XtSetArg (args[n], XtNy, 0);  n++;
        optWin2 = XtCreateManagedWidget("", xmDrawingAreaWidgetClass,
                         optWin, args, n);
	create_password_widget();
}


create_size_window(topWidget)
Widget  topWidget;
{
	int	height, width;

	height = rowHeight + row_gap;
	width = optWinWidth + info_x;
	sizeWin = create_draw_window(mainFrame,topWidget,width,height,-1,-1,1);
}


create_install_text()
{
	n = 0;
  	XtSetArg (args[n], XmNrows, 9); n++;
	XtSetArg (args[n], XmNcolumns, 55); n++;
        XtSetArg (args[n], XmNleftAttachment, XmATTACH_FORM);  n++;
        XtSetArg (args[n], XmNrightAttachment, XmATTACH_FORM);  n++;
        XtSetArg (args[n], XmNwordWrap, TRUE);  n++;
        XtSetArg (args[n], XmNresizeHeight, FALSE);  n++;
        XtSetArg (args[n], XmNeditable, FALSE);  n++;
        XtSetArg (args[n], XmNscrollVertical, TRUE);  n++;
	XtSetArg (args[n], XmNscrollHorizontal, False);  n++;
	XtSetArg (args[n], XmNeditMode, XmMULTI_LINE_EDIT); n++;
	XtSetArg (args[n], XmNcursorPositionVisible, FALSE); n++;

	installText = (Widget) XmCreateScrolledText (installFrame, "", args, n);
   	XtManageChild (installText);
	scrolledWindow = installText;
}


create_help_window()
{
     Widget  pwidget, scroll, twidget;
     FILE    *fd;
     struct  stat  f_stat;
     char    *buf;


     if (helpShell == NULL)
     {
        n = 0;
        XtSetArg (args[n], XtNtitle, "Installation Help");  n++;
	XtSetArg (args[n], XtNgeometry, location);  n++;
        helpShell = XtCreateApplicationShell("",
				 transientShellWidgetClass, args, n);
	pwidget = create_control_win(helpShell, NULL, 1, 0);
        n = 0;
  	XtSetArg (args[n], XmNrows, 19); n++;
	XtSetArg (args[n], XmNcolumns, 60); n++;
	XtSetArg (args[n], XmNborderWidth, 1); n++;
        XtSetArg (args[n], XmNeditable, FALSE);  n++;
	XtSetArg (args[n], XmNeditMode, XmMULTI_LINE_EDIT); n++;
	XtSetArg (args[n], XmNcursorPositionVisible, FALSE); n++;
	XtSetArg (args[n], XmNscrollHorizontal, False);  n++;
	scroll = (Widget) XmCreateScrolledText(pwidget, "", args, n);
   	XtManageChild (scroll);
	twidget = create_control_win(pwidget, NULL, 0, 0);
	create_button(twidget, "Close", close_help, 0, 1);
     	XtRealizeWidget(helpShell);
	sprintf(tmpstr, "%sreadme.txt", help_dir);
	sprintf(location, "+%d+%d", 300, 100);
	if (stat(tmpstr, &f_stat) == -1 || f_stat.st_size <= 0)
		return;
	if((fd = fopen(tmpstr, "r")) == NULL)
		return;

	if (!(buf = XtMalloc((unsigned)(f_stat.st_size + 1))))
		return;
	if (!fread(buf, sizeof(char), f_stat.st_size +1, fd))
	{
		fclose(fd);
		return;
	}
	buf[f_stat.st_size] = '\0';
	XmTextSetString(scroll, buf);
	fclose(fd);
	XtFree(buf);
    }
    if (helpShell != NULL)
        XtPopup(helpShell, XtGrabNone);
}

#endif

char
*remove_comment(data, flag)
char	*data;
int	*flag;
{
	while (*data != '\0')
	{
	    if (*data == '*')
	    {
		if (*(data+1) == '/')
		{
		     *flag = 0;
		     return((char *)(data+2));
		}
	     }
	     data++;
	}
	return((char *) NULL);
}

char
*get_str_arg(data)
char	*data;
{
	char	*rdata;
	static char	*source;

	rdata = NULL;
	if (data != NULL)
	    source = data;
	while (*source != '\0' && *source != '"')
	    source++;
	if (*source == '\0')
	    return(rdata);
	source++;
	rdata = source;
	while (*source != '\0' && *source != '"')
	    source++;
	if (*source == '"')
	{
	    *source = '\0';
	    source++;
	}
	return(rdata);
}


int
get_int_arg(data)
char   *data;
{
	int   val;

	while (*data == ' ' || *data == '\t' || *data == '=')
	    data++;
	val = atoi(data);
	return(val);
}

static char
*read_a_line(fd)
FILE    *fd;
{
        char    *data;
	char	sdata[256];

        while ((data = fgets(sdata, 256, fd)) != NULL)
        {
            while (*data != '\0')
	    {
                if (*data == '"')
		    return(data);
                data++;
	    }
        }
        return ((char *) NULL);
}



int
create_new_xpm_icon(fd, node, id, x, y)
FILE   *fd;
VOPTION   *node;
int    id, x, y;
{
	int     width, height;
        int     k, i, m, ver, stop;
        int     colors;
	char	**color_num;
	char	*color_chs;
	char	**color_data;
        char    *strs, *data, cname[32];

        strs = read_a_line(fd);
        if (strs == NULL)
             return(0);
	strs++;
        k = sscanf(strs, "%d%d%d%d", &width, &height, &colors, &ver);
        if (k < 4 || ver < 1 || ver > 3)
             return(0);
	if (width > 128 || height > 128)
             return(0);

	color_num = (char **) malloc(sizeof (char *) * colors);
	color_chs = (char *) malloc(colors + 2);
	strcpy(cname, "white");
        for (k = 0; k < colors; k++)
        {
              strs = read_a_line(fd);
              if (strs == NULL)
                   return(0);
              strs++;
	      color_chs[k] = *strs;
              strs++;
              stop = 0;
              while (1)
              {
                   switch (*strs) {
                    case  '\0':
                    case  '\n':
                                stop = 1;
                                break;
                    case  'c':
                                if ((*(strs-1) == ' ' || *(strs-1) == '\t')
                                 && (*(strs+1) == ' ' || *(strs+1) == '\t'))
                                {
                                    stop = 1;
                                    strs++;
                                    data = strs;
                                    while (*strs != '"' && *strs != '\0')
                                        strs++;
                                    *strs = '\0';
                                    if (sscanf(data, "%s", cname) != 1)
					strcpy(cname, "white");
                                }
                                break;
                   }
                   if (stop)
		   {
			if (color_chs[k] == ' ')
			    strcpy(cname, "white");
			color_num[k] = (char *) malloc(strlen(cname)+2);
			strcpy(color_num[k], cname);
                        break;
		   }
                   strs++;
              }
        }
	color_data = (char **) malloc(sizeof (char *) * ICONWIDTH);
        for (k = 0; k < ICONWIDTH; k++)
        {
	      stop = 0;
	      color_data[k] = (char *) malloc(ICONWIDTH + 2);
              strs = read_a_line(fd);
              if (strs == NULL)
	      {
		   strs = color_data[k];
		   for(m = 0; m < ICONWIDTH; m++)
		       *strs++ = ' ';
		   *strs = '\0';
		   continue;
	      }
              strs++;
	      data = color_data[k];
	      i = 0;
	      while (*strs != '\0')
              {
		   if (*strs == '"')
			break;
		   *data++ = *strs++;
		   i++;
              }
              while (i < ICONWIDTH)
	      {
		   *data++ = ' ';
		   i++;
	      }
	      *data = '\0';
        }
	create_graph_icon(color_data, id, colors, color_num,
				 color_chs, x, y, node);
	return(1);
}


create_text_icon(node, id, x, y)
VOPTION   *node;
int       id, x, y;
{
	char	**color_num;
	char	*color_chs;

	color_chs = (char *) malloc(4);
	strcpy(color_chs, "  ");
	color_num = (char **) malloc(sizeof (char *) * 2);
	color_num[0] = (char *) malloc(6);
	strcpy(color_num[0], "white");
	create_graph_icon((char **) NULL, id, 1, color_num,
				 color_chs, x, y, node);
}


read_xpm_data(node, id, x, y)
VOPTION   *node;
int	  id, x, y;
{
	FILE   *fd;
	char	dline[512];
	char	name[32];
	char	cname[32];
	char	*dptr;
	char	*vptr;
	char	**color_num;
	char	*color_chs;
	char	**color_data;
	int	width, height, colors;
	int	k, m, start;

	sprintf(tmpstr, "%sicon/%s.icon", prog_dir, node->base_name);
	
        if ((fd = fopen(tmpstr, "r")) == NULL)
	{
	    create_text_icon(node, id, x, y);
	    return;
	}
	start = 0;
	while ((dptr = fgets(dline, 512, fd )) != NULL)
        {
	     if (strstr(dline, "! XPM") != NULL)
             {
                    start = 1;
                    break;
             }
             else if (strstr(dline, "XPM") != NULL)
             {
                   if (!create_new_xpm_icon(fd, node, id, x, y))
			create_text_icon(node, id, x, y);
                   fclose(fd);
                   return;
             }

        }
        if (!start)
        {
            fclose(fd);
	    create_text_icon(node, id, x, y);
            return;
        }
	fgets(dline, 256, fd);
        sscanf(dline, "%d%d%d", &width, &height, &colors);
	color_num = (char **) malloc(sizeof (char *) * colors);
	color_chs = (char *) malloc(colors + 2);
	if (width > 128 || height > 128)
	{
	    create_text_icon(node, id, x, y);
	    fclose(fd);
	    return;
	}
	for (k = 0; k < colors; k++)
        {
	      if ((dptr = fgets(dline, 512, fd )) != NULL)
	      {
              	color_chs[k] = dline[0];
                sscanf(dptr+1, "%s%s", name, cname);
		if (dline[0] == ' ')
		    strcpy(cname, "white");
		color_num[k] = (char *) malloc(strlen(cname) + 2);
		strcpy(color_num[k], cname);
              }
	      else
	      {
		create_text_icon(node, id, x, y);
		fclose(fd);
		return;
	      }
        }
	color_data = (char **) malloc(sizeof (char *) * ICONWIDTH);
	for (k = 0; k < ICONWIDTH; k++)
        {
	      color_data[k] = (char *) malloc(ICONWIDTH + 2);
	      dptr = fgets(dline, 512, fd );
              if (dptr == NULL)
	      {
		dptr = color_data[k];
		for(m = 0; m < ICONWIDTH; m++)
		    *dptr++ = ' ';
		*dptr = '\0';
	      }
	      else
	      {
	      	vptr = color_data[k];
		m = 0;
                while (*dptr != '\0')
                {
		    *vptr++ = *dptr++;
		    m++;
		}
                while (m < ICONWIDTH)
		{
		    *vptr++ = ' ';
		    m++;
		}
              }
        }
        fclose(fd);
	create_graph_icon(color_data, id, colors, color_num,
				 color_chs, x, y, node);
}



