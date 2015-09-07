'
' @(#)runasscript.vbs 22.1 03/24/08 Copyright (c) 2003-2005 Agilent Technologies All Rights Reserved
' 
' Agilent Technologies All Rights Reserved.
' This software contains proprietary and confidential
' information of Agilent Technologies and its contributors.
' Use, disclosure and reproduction is prohibited without
' prior consent.
' 
' 

On Error Resume Next
dim WshShell,oArgs,FSO

set oArgs=wscript.Arguments

if InStr(oArgs(0),"?")<>0 then
wscript.echo VBCRLF & "? HELP ?" & VBCRLF
Usage
end if

if oArgs.Count <3 then
wscript.echo VBCRLF & "! Usage Error !" & VBCRLF
Usage
end if

sUser=oArgs(0)
sPass=oArgs(1)&VBCRLF
sCmd=oArgs(2)

set WshShell = CreateObject("WScript.Shell")
set WshEnv = WshShell.Environment("Process")
WinPath = WshEnv("SystemRoot")&"\System32\runas.exe"
set FSO = CreateObject("Scripting.FileSystemObject")

if FSO.FileExists(winpath) then
'wscript.echo winpath & " " & "verified"
else
wscript.echo "!! ERROR !!" & VBCRLF & "Can't find or verify " & winpath &"." & VBCRLF & "You must be running Windows 2000 for this script to work."
set WshShell=Nothing
set WshEnv=Nothing
set oArgs=Nothing
set FSO=Nothing
wscript.quit
end if

rc=WshShell.Run("runas /user:" & sUser & " " & CHR(34) & sCmd & CHR(34), 2, FALSE)
Wscript.Sleep 90 'need to give time for window to open.
WshShell.AppActivate(WinPath) 'make sure we grab the right window to send password to
WshShell.SendKeys sPass 'send the password to the waiting window.
WshShell.SendKeys "{ENTER}"
'WshShell.Sleep 20000

set WshShell=Nothing
set oArgs=Nothing
set WshEnv=Nothing
set FSO=Nothing

wscript.quit

'************************
'* Usage Subroutine *
'************************
Sub Usage()
On Error Resume Next
msg="Usage: cscript|wscript vbrunas.vbs Username Password Command" & VBCRLF & VBCRLF & "You should use the full path where necessary and put long file names or commands" & VBCRLF & "with parameters in quotes" & VBCRLF & VBCRLF &"For example:" & VBCRLF &" cscript vbrunas.vbs quilogy\jhicks luckydog e:\scripts\admin.vbs" & VBCRLF & VBCRLF &" cscript vbrunas.vbs quilogy\jhicks luckydog " & CHR(34) &"e:\program files\scripts\admin.vbs 1stParameter 2ndParameter" & CHR(34)& VBCRLF & VBCRLF & VBCLRF & "cscript vbrunas.vbs /?|-? will display this message."

wscript.echo msg

wscript.quit

end sub
'End of Script 
