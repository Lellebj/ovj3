; '@(#)acquire.scr.sh 22.1 03/24/08 1991-1996 '
; 
; . 
; This software contains proprietary and confidential 
; information of Agilent Technologies and its contributors. 
; Use, disclosure and reproduction is prohibited without 
; prior consent. 
;
; This is a KERMIT script.
;
pause 1
echo start new experiment
cd \fmu
set baud 9600
pause 1
send start
pause 10
 
