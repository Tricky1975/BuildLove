Rem
	Love builder
	error handler
	
	
	
	(c) Jeroen P. Broks, 2016, All rights reserved
	
		This program is free software: you can redistribute it and/or modify
		it under the terms of the GNU General Public License as published by
		the Free Software Foundation, either version 3 of the License, or
		(at your option) any later version.
		
		This program is distributed in the hope that it will be useful,
		but WITHOUT ANY WARRANTY; without even the implied warranty of
		MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
		GNU General Public License for more details.
		You should have received a copy of the GNU General Public License
		along with this program.  If not, see <http://www.gnu.org/licenses/>.
		
	Exceptions to the standard GNU license are available with Jeroen's written permission given prior 
	to the project the exceptions are needed for.
Version: 16.03.26
End Rem
Function ERROR(E$,internal=False)
Print "ERROR!"
Print  E
Print
If internal
	Print "This is an internal error!"
	Print  "Please discuss with the dev"
	Print
	EndIf
End
EndFunction

Function check(boole,Err$,Internal=False)
If boole Return
error err,internal
End Function

Function Warn(W$)
Print "WARNING!"
Print W
ListAddLast warninglist,W
End Function

Function repeatwarnings()
Print
Local c = CountList ( warninglist )
Select c
	Case 0	Return
	Case 1	Print "There was one warning"
	Default	Print "There were "+c+" warnings" 
	End Select
For Local w$=EachIn warninglist
	Print"~t- "+W
	Next
Print
End Function	


MKL_Version "Love Builder - error.bmx","16.03.26"
MKL_Lic     "Love Builder - error.bmx","GNU General Public License 3"
