@(#)readme2.txt 22.1 03/24/08 Copyright (c) 1991-1994 Agilent Technologies All Rights Reserved
# 
# Agilent Technologies All Rights Reserved.
# This software contains proprietary and confidential
# information of Agilent Technologies and its contributors.
# Use, disclosure and reproduction is prohibited without
# prior consent.
#
	INSTRUCTIONS TO LOAD VNMR FROM CD-ROM

Note1: If you use the 'su' command to become root, 
       do not use 'su -'. You can only use the 'su'
       command if you logged in as vnmr1.
Note2: Below '#' represents the root-prompt. You do not
       type this prompt.

Become root on your system.  If OpenWindows or CDE is not running type:

# /usr/openwin/bin/openwin

and wait for the X Windows to come up. Meanwhile insert the CD into the CD-ROM drive, use a caddy if needed. Then type:

YOU MUST ALREADY HAVE LOADED THE FIRST CD BEFORE LOADING THIS ONE!

# cd /cdrom/cdrom0
# ./load.nmr

`load.nmr' will present you with several option:

`VNMR'		This loads the additional VNMR package. 
`Online_Manuals'This loads the online manual software.
		See also below.
`GLIDE'		This loads the optional Glide software (run
		point-and-click interactive experiments)
`PFG'		Loads seqlib, psglib parameters, etc files
	 	for PFG experiments
`Userlib'	Loads Userlib.

Options can be added later through `load.nmr'.

1. Select the options you want to load. 
   If a password field appears, enter the password exactly
   as provided, it is case sensitive.
2. Answer the question whether to stop acquisition. If
   you do this, the program that connects VNMR with the
   nmr console is stopped (Either Acqproc or Expproc,
   depending on your system type). This must eventually
   be done, so you might as well do it now, unless the
   console is in use. If you don't do it now, then you
   must do it later by hand (see the Software
   Installation Manual).
3. Answer the question whether the online manuals should
   be accessed via a link. This leaves the manuals on the
   CD-ROM, and makes a link from the hard disk to the
   CD-ROM directory.  It saves 50-80 Mbytes on your hard
   disk, but the CD must be in the drive for access to
   the manuals.

Click install. Software is added to the existing /vnmr directory.

The last message you should see is "Software Load Complete". After that click on "Dismiss".

Finally  execute 'makeuser' and 'setacq'.

   # cd /vnmr/bin
   # ./makeuser
   # ./setacq

`'makeuser' create/updates user files such as .login, global and clears user's psg-libraries and the user's `seqlib'.
`setacq' will instruct you to reboot the console. Push the reset button on the acquisition CPU (on INOVA systems, this button is behind the left door, the left most card in the digital card cage). Answer the question `setacq' asks, then wait a moment.
When `setacq' is done it will tell you if you need to reboot the SUN computer; if `setacq' doesn't tell you to reboot the SUN, you are done.

