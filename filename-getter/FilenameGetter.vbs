' Help tool to extract file names from directory
' Code written by Mark Battistella & Sharni White
' Copyright (c) 2017
' Do not alter anything or else the world will break


Do While X = 0
	str01 = InputBox( "Enter the location of the files", "File location" )
	If str01 = "" Then
		Wscript.Echo "1"
	Else
		str01 = str01
	Exit Do
End If
Loop


str02 = InputBox( "Enter the location of the place to save the file", "Save location" )

If str02 = "" Then
	str02 = str01 & "\output.txt"
Else
	str02 = str02 & "\output.txt"
End If




str03 = InputBox( "Enter 1 (for all files and folders) or 2 (for only files)", "Save location" )

If str03 = "" Then
	str03 = ""
End If

If str03 = "1" Then
	str03 = ""
End If

If str03 = "2" Then
	str03 = "-d"
End If



' Create some string variables
str04 = "CD /d " & chr(34) & str01 & chr(34) & "&"
str05 = "cmd.exe /C " & str04 & " dir /B /A" & str03 & " > " & chr(34) & str02 & chr(34)



' Run the file name getter
Set oShell = WScript.CreateObject("WScript.shell")
oShell.run str05

' Wscript.Echo str05
