' Disable computer auto sleep
' Code written by Mark Battistella
' Copyright (c) 2018
' Do not alter anything or else the world will break

set wsc = CreateObject("WScript.Shell")
wsc.Popup "This computer will no longer go to sleep :(", 3, "NoSleepMakesComputerGoSomethingSomething"
Do
	WScript.Sleep(5*60*1000)
	wsc.SendKeys("{SCROLLLOCK 2}")
Loop