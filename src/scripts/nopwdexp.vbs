'
' @(#)nopwdexp.vbs 22.1 03/24/08 Copyright (c) 2003-2005 Agilent Technologies All Rights Reserved
' 
' Agilent Technologies All Rights Reserved.
' This software contains proprietary and confidential
' information of Agilent Technologies and its contributors.
' Use, disclosure and reproduction is prohibited without
' prior consent.
' 
' 

'=============================================================================
'
' Usage: cscript //nologo nopwdexp.vbs /domain:domainname /user:username
' ==============================================================================

Option Explicit

On Error Resume Next

' Set constants
Const ufDONT_EXPIRE_PASSWD = &H10000

' Set variables
Dim colNamedArguments
Dim strDomain, strUser

' Read command line named arguments
Set colNamedArguments = WScript.Arguments.Named

' Report missing domain argument
If colNamedArguments.Exists("domain") Then
	strDomain=colNamedArguments.Item("domain")
Else
	WScript.Echo "Missing argument: /domain:domainname"
	Usage
End If

' Report missing user argument
If colNamedArguments.Exists("user") Then
	strUser=colNamedArguments.Item("user")
Else
	WScript.Echo "Missing argument: /user:username"
	Usage
End If

PasswordNeverExpires strDomain, strUser

' ******************************************************************************

Sub PasswordNeverExpires(domainname, username)
' Sets the do not expire password flag if not already set

Dim objUser, objUserFlags

' Read user properties
Set objUser = GetObject("WinNT://" & domainname & "/" & username & ",user")

' Examine flags set against account
objUserFlags = objUser.Get("UserFlags")

' If password expiry is allowed, then set password never to expire.
If (objUserFlags And ufDONT_EXPIRE_PASSWD) = 0 Then
	' Password does expire
	' WScript.Echo objUserFlags
	objUserFlags = objUserFlags Or ufDONT_EXPIRE_PASSWD
	' WScript.Echo objUserFlags
	objUser.Put "UserFlags", objUserFlags
	objUser.SetInfo 
	WScript.Echo domainname & "\" & username & " password has been set never to expire."
'Else
	' Password does not expire
	' WScript.Echo objUserFlags
        ' WScript.Echo domainname & "\" & username & " password was already set never to expire."
End If

End Sub

' ******************************************************************************

Sub Usage()
' Reports the correct command line syntax

Wscript.Echo VbCr
WScript.Echo "nopwdexp.vbs"
Wscript.Echo VbCr
WScript.Echo "Usage: cscript //nologo nopwdexp.vbs /domain:domainname /user:username"
Wscript.Quit

End Sub

' ******************************************************************************
