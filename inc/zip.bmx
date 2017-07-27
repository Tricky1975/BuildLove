Rem
	LoveBuilder
	zip
	
	
	
	(c) Jeroen P. Broks, 2016, 2017, All rights reserved
	
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
Version: 17.07.27
End Rem

MKL_Version "Love Builder - zip.bmx","17.07.27"
MKL_Lic     "Love Builder - zip.bmx","GNU General Public License 3"

Function zip()
	Local pwd$ = CurrentDir()
	ChangeDir Tempdir
	CreateDir "Zips"
	ChangeDir "Assets"
	Print "Zipping assets"
	' This file contains some info, and it prevents bugs too.
	Local BT:TStream = WriteFile("lovebuilder.info.txt")
	WriteLine bt,"== Created with Love Builder =="
	WriteLine bt,"Project:         "+pini.C("Title")
	WriteLine bt,"Author:          "+pini.C("Author")
	WriteLine bt,"Project file:    "+pinifile
	WriteLine bt,"Built:           "+CurrentDate()+" "+CurrentTime()
	WriteLine bt,"Builder version: "+MKL_NewestVersion()
	?MacOS
	WriteLine bt,"Builder OS:      Apple MacOS/MacOS X/OS X/Darwin"
	?Linus
	WriteLine bt,"Builder OS:      Linux"
	?Win32
	WriteLine bt,"Builder OS:      Microsoft Windows"
	?
	CloseFile bt
	?win32
	system_ AppDir+"\zip ..\Zips\Assets -9 -r *"
	?Not win32
	system_ "zip ../Zips/Assets -9 -r *"
	?
	ChangeDir "../Script"
	For Local p$=EachIn wplatforms
		If out(p).process
			Print "Creating love file for "+out(p).losn
			check CopyFile("../zips/assets.zip","../zips/project."+p+".love"),"Could not copy assets into full project file"
			ChangeDir p
			?win32
			system_ AppDir+"\zip ../../zips/project."+p+".love -9 -r *"
			?Not win32
			system_ "zip ../../zips/project."+p+".love -9 -r *"
			?
			ChangeDir ".."
		EndIf
	Next
	ChangeDir pwd			
End Function
