# @(#)splash.tcl 10.1 01/13/06 Copyright (c) 1991-2000 Varian Inc. All Rights Reserved
# 
# Copyright (c) 1991-2000 Varian Inc. All Rights Reserved. 
# This software contains proprietary and confidential
# information of Varian Inc. and its contributors.
# Use, disclosure and reproduction is prohibited without
# prior consent.
#
toplevel .splash
wm transient .splash .
wm colormapwindows . .splash
wm overrideredirect .splash 1
if {[info exists pInfo(rootGeom)] == 1} {
  set geom $pInfo(rootGeom)
} else {
  set geom 100x100
}
regexp {[^+]*(.*)} $geom match xy
wm geometry .splash $xy
canvas .splash.splCan -height 436 -width 436
set im1 [file join $hD bitmaps sc_splash.gif]
image create photo vinc -palette 256/256/256
vinc read $im1
.splash.splCan create image 0 0 -anchor nw -image vinc
set font "helvetica10"
set theTopText ""
set theTopFile [file join $hD bitmaps topsplash.txt]
if {[file exists $theTopFile] == 1} {
 set file [open $theTopFile r]
 set theTopText [read $file]
 close $file
}
set theLowText ""
set theLowFile [ file join $hD bitmaps lowsplash.txt]
if {[file exists $theLowFile] == 1} {
 set file [open $theLowFile r]
 set theLowText [read $file]
 close $file
}
.splash.splCan create text 222 4 \
 -anchor nw -font $font -width 215 -text $theTopText -tags top
.splash.splCan create text 222 382 \
 -anchor nw -font $font -width 200 -text $theLowText -tags low
pack .splash.splCan
raise .splash
update idletasks
after 2000 {destroy .splash}
