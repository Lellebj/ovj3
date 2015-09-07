: '@(#)readme.txt.sh 22.1 03/24/08 1991-1996 '
# 
#
# Copyright (C) 2015  Stanford University
# 
# You may distribute under the terms of either the GNU General Public
# License or the Apache License, as specified in the README file.
# 
# For more information, see the README file.
# 
#
	INSTRUCTIONS TO LOAD VNMR FROM CD-ROM

Note1: If you use the 'su' command to become root, 
       do not use 'su -'. You can only use the 'su'
       command if you logged in as vnmr1.
Note2: Below '#' represents the root-prompt. You do not
       type this prompt.

Become root on your system.  If windows is not running type

# PATH=/usr/sbin:/usr/bin:.
# export $PATH
# /usr/openwin/bin/openwin

and wait for the X Windows to come up. Meanwhile insert
the CD into the CD-ROM drive, use a caddy if needed.

Depending on how you CD-ROM is mounted
# cd /cdrom	OR	# cd /cdrom/cdrom0
# ./load.nmr

`load.nmr' will present you with several option:

`VNMR'		This loads the basic VNMR package. 
`Online_Manuals'This loads the online manual software.
		See also below.
`GLIDE'		This loads the optional Glide software (run
		point-and-click interactive experiments)
`PFG'		Loads seqlib, psglib parameters, etc files
	 	for PFG experiments
`Kermit'	Loads the Kermit (serial port)
		communication software. This is shareware.
		Needed for field mapping.
`GNU'		This loads the GNU "C" compiler. Needed
		for pulse sequence programming.
		This is shareware.
`uImaging'	Loads software for micro imaging
`Imaging_&_Triax'	Load software for imaging
`limNet'	Load the Limnet software. Needed for
		ethernet communication between SUN and
		VXR or Gemini systems that run PASCAL OS
`Userlib'	Loads Userlib.

Also available may be the passworded options

'Gradient_shim'	Software for shimming using the Gradient Amplifier
'LC-NMR'	Software for driving LC-NMR experiments
'Diffusion'	Software fro running Diffusion experiment
'STARS'		A software simulation package
When selected a password field will become visible. Enter your password
in the field (it is echoed).


Options can be added later through `load.nmr'.

1. Select the options you want to load. 
   If a password field appears, enter the password exactly
   as provided, it is case sensitive.
2. Enter the destination directory if it is not correct.
   If you want to keep the previous version, you may
   want to name the new version /export/home/vnmr.x.y,
   where x.y is the version of the VNMR, e.g 5.2
3. Answer the question whether to stop acquisition. If
   you do this, the program that connects VNMR with the
   nmr console is stopped (Either Acqproc or Expproc,
   depending on your system type). This must eventually
   be done, so you might as well do it now, unless the
   console is in use. If you don't do it now, then you
   must do it later by hand (see the Software
   Installation Manual).
4. Answer the question whether to establish the link
   to /vnmr. If you do this the previous version is 
   hidden. This must eventually be done, so you might
   as well do it now, unless the console is in use.
   If you don't do it now, then you must do it later
   by hand (see the Software Installation Manual).
5. Answer the question whether the online manuals should
   be accessed via a link. This leaves the manuals on the
   CD-ROM, and makes a link from the hard disk to the
   CD-ROM directory.  It saves 30-40 Mbytes on your hard
   disk, but the CD must be in the drive for access to
   the manuals.

Click install. You do not have to create the destination
directory. If it exist we use it, if it does not exist,
we create it. If you install VNMR we also create the
vnmr1 user (if needed).

The last message you should see is "Software
Load Complete". After that click on "Dismiss".

Finally  execute 'makeuser' and 'setacq'.

   # cd /vnmr/bin
   # ./makeuser
   # ./setacq

`'makeuser' create/updates user files such as .login,
global and clears user's psg-libraries and the user's
`seqlib'.
`setacq' will instruct you to reboot the console. 
Push the reset button on the acquisition CPU (on INOVA 
systems, this button is behind the left door, the left 
most card in the digital card cage). 
Answer the question `setacq' asks, then wait a moment.
When `setacq' is done it will tell you if you need to
reboot the SUN computer; if `setacq' doesn't tell you
to reboot the SUN, you are done.

