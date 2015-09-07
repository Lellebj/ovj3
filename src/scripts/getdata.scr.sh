; '@(#)getdata.scr.sh 22.1 03/24/08 1991-1996 '
;
; . 
; This software contains proprietary and confidential 
; information of Agilent Technologies and its contributors. 
; Use, disclosure and reproduction is prohibited without 
; prior consent. 
;
; This is a KERMIT script.
;
echo look for file mapdata.done\13\10
set count 100
:again
pause 15
get mapdata.done
if success goto sun
echo still looking for mapdata.done\13\10
output \13
if count goto again
get mapdata.done
if success goto sun
echo file access timed out\13
pause 10
quit
:sun
set count 5
:sunchk
pause 1
get mapdata.sun
if success goto map
if count goto again
echo file getdata.sun not found\13
pause 10
quit
:map
echo mapdata.sun file transfer successful\13\10
pause 1
copy mapdata.sun mapdata.chk
pause 1
del mapdata.don
pause 5

