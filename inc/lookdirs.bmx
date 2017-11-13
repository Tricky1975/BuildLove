Rem
	Love Builder
	dir scanner
	
	
	
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
Version: 17.11.12
End Rem
Function LookDirs()
	Local jd:TJCRDir
	Local d$
	pini.clist "IMPORT",True
	If pini.c("MULTIDIR").toUpper()<>"Y" 
		project = JCR_Dir(pini.c("Projectdir."+platform))
		For Local i$=EachIn pini.list("IMPORT")
			JCR_AddPatch project , JCR_Dir(Trim(i$))
		Next	
		Return
	EndIf	
	Print ANSI_SCol("Looking for dirs: ",A_Cyan)
	pini.clist "I_WANT_YOU",True
	pini.clist "I_DONT_WANT_YOU",True
	pini.clist "LICS"
	Local ly:TList = pini.list("I_WANT_YOU")
	Local ln:TList = pini.list("I_DONT_WANT_YOU")
	Local lic:TList = pini.list("LICS")
	Local DirList:TList = ListDirFull(pini.c("Projectdir."+platform))
	For d=EachIn pini.list("IMPORT")
		For Local d2$=EachIn ListDirFull(d) ListAddLast dirlist,d2 Next
	Next		
	For d$=EachIn dirlist
		If JCR_Type(d) '(pini.c("Projectdir."+platform))+"/"+d)
			If Not ( ListContains(ly,d) Or ListContains(ln,d) )
				If yes("Allow dir ~q"+d+"~q")
					ListAddLast ly,d
					SortList ly
				Else
					ListAddLast ln,d
					SortList ln
				EndIf
				SaveIni pinifile,pini
			EndIf	
			If ListContains(ly,d)
				Print ANSI_SCol("Will add: ",A_yellow,A_dark)+ANSI_SCol(D,A_magenta)
				Need pini,"Dir.Author."+d,"Author",d
				If Not pini.c("Dir.Lic."+d)
					Print ANSI_SCol("We got the next license codes: ",A_Yellow,A_Bright)
					For Local lc$=EachIn lic Print ANSI_SCol("* ",A_Blue,A_Blink)+ANSI_SCol(lc,A_magenta) Next
				EndIf
				need pini,"Dir.Lic."+d,"License Tag: ","UNKNOWN"
				If Not ListContains(lic,pini.c("Dir.Lic."+d)) 
					ListAddLast lic, pini.c("Dir.Lic."+d);
					SaveIni pinifile,pini
				EndIf
			need pini,"Lic."+pini.c("Dir.Lic."+d),"License Text: ","License text not properly set up. Sorry!"
			EndIf
		EndIf	
	Next	
	Print  ANSI_SCol("Adding directories to project",A_Cyan)
	For d$=EachIn ly
		Print ANSI_SCol("Adding: ",A_Cyan,A_Dark)+ANSI_SCol(d,A_Magenta)
		jd = JCR_Dir(d) 'pini.c("Projectdir."+platform)+"/"+d)
		For Local f$=EachIn MapKeys(jd.entries)
			If Prefixed(f,"JBL/") Or Prefixed(f,"JCR/") Or Prefixed(f,"LIBS/") Print "WARNING! "+f+" makes use of a reserved directory. This may lead To undesirable behavior!"
			authoraddfile pini.c("dir.author."+d),pini.c("dir.lic."+d),TJCREntry(MapValueForKey(jd.entries,f)).filename
			Next
		JCR_AddPatch(project,jd)
	Next		
End Function
