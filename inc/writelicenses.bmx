Rem
	Lovebuilder
	License outputter
	
	
	
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
Version: 16.04.04
End Rem
Global Lics:TList = New TList

Type TLicWrite
	Method tag$() Abstract
	Method name$() Abstract
	Method MakeItHappen(bt:TStream) Abstract
	Method New() Final ListAddLast Lics,Self End Method
End Type

Type licHtml Extends TLicWrite
	Method tag$() Return "HTML" EndMethod
	Method name$() Return  "Hypertext Markup language" EndMethod
	
	Method MakeItHappen(bt:TStream)
		Local author$,lic$,file$,outstr$,firstlic,firstfile
		Local tfiles,lfiles
		WriteLine bt,"~n~n~n<table class=lictab><caption>Project Contributors</caption>"
		For author=EachIn MapKeys(AuthorMapVar)
			tfiles = 0
			lfiles = 0
			outstr = "<tr class=liccel valign=top><td rowspan='*totalfiles*'>"+author+"</td>";
			firstlic=True
			firstfile=True
			For lic = EachIn MapKeys(authorlics(author))
				lfiles = CountList(authorlist(author,lic))
				tfiles:+lfiles
				If firstlic firstlic=False Else outstr:+"<tr class=liccel valign=top>"
				outstr :+ "<td rowspan="+lfiles+">"+pini.c("Lic."+lic)+"</td>"
				firstfile=True
				For file = EachIn authorlist(author,lic)
					If firstfile firstfile=False Else outstr:+"<tr class=liccel valign=top>"
					outstr :+ "<td><tt>"+file+"</tt></td></tr>"
				Next
			Next

			outstr = Replace(outstr,"*totalfiles*",tfiles)
			WriteLine bt,outstr
		Next						
		WriteLine bt,"</table>"
	End Method
End Type

New lichtml


Type licmd Extends TLicWrite
	Method tag$() Return "md" EndMethod
	Method name$() Return  "MarkDown" EndMethod
	
	Method MakeItHappen(bt:TStream)
	WriteLine bt,"~n~n## Contributors:~n~n"
		Local author$,lic$,file$,outstr$,firstlic,firstfile
		For author=EachIn MapKeys(AuthorMapVar)
			WriteLine bt,"- "+author
			For lic = EachIn MapKeys(authorlics(author))
				WriteLine bt,"  - "+pini.c("Lic."+lic)
				For file = EachIn authorlist(author,lic)
					WriteLine bt,"    - "+file
				Next
			Next
		Next
		WriteLine bt,"~n~n"	
	End Method
End Type	

New licmd



Function WriteLicenses()
	Local coutf$
	Local Bt:TStream
	For Local lic:tlicwrite = EachIn Lics
		coutf = pini.c("CREDITOUT."+lic.tag()+"."+platform)
		DebugLog "License output for: "+lic.tag()+"? ("+lic.name()+") >>> "+coutf+" <<< "+"CREDITOUT."+lic.tag()+"."+platform
		If coutf
			Print "Writing credits into "+lic.name()+" >> "+coutf
			CreateDir ExtractDir(coutf),1
			bt = WriteFile(coutf)
			pini.clist("PreLic."+lic.tag(),1)
			For Local l$=EachIn pini.list("PreLic."+lic.tag()) 
				l = Replace(l,"--update.time--",PNow())
				If l="--white--" WriteLine bt,"" Else WriteLine bt,l 
			Next
			lic.makeithappen bt
			pini.clist("PstLic."+lic.tag(),1)
			For Local l2$=EachIn pini.list("PstLic."+lic.tag())
				l2 = Replace(l2,"--update.time--",PNow())
				If l2="--white--" WriteLine bt,"" Else WriteLine bt,l2 
			Next
			CloseFile bt
		EndIf
	Next
End Function
