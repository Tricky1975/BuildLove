Rem
	Love Builder
	global declarations
	
	
	
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
MKL_Version "Love Builder - globals.bmx","16.04.04"
MKL_Lic     "Love Builder - globals.bmx","GNU General Public License 3"

?Win32
Const platform$ = "windows"
?MacOS
Const platform$ = "mac"
?linux
Const platform$ = "linux"
?
Const ginifile$ = "BuildLove."+platform+".ini"
Global pinifile$

Global file$
Global gini:TIni = New TIni '  Global ini
Global pini:TIni = New TIni ' Project ini

Global Project:TJCRDir = New TJCRDir

Global JWIN32:TJCRDir = JCR_Dir("incbin::Win32.jcr")
Global JWIN64:TJCRDir = JCR_Dir("incbin::Win32.jcr")
Global JMac64:TJCRDir = JCR_Dir("incbin::Win32.jcr")

Global WorkDir$ = Dirry("$AppSupport$/$LinuxDot$BuildLove/")
Global TempDir$ = Workdir + "TempProject"

Global BT:TStream

Global MacDefs:TList = New TList; ListAddLast MacDefs,"$MAC" ListAddLast MacDefs,"$OSX"
Global WinDefs:TList = New TList; ListAddLast WinDefs,"$WINDOWS" ListAddLast winDefs,"$WIN"
Global LinDefs:TList = New TList; ListAddLast LinDefs,"$LINUX" ListAddLast LinDefs,"$LIN"
Global AndDefs:TList = New TList; ListAddLast LinDefs,"$ANDROID"
Global iOSDefs:TList = New TList; ListAddLast iOSDefs,"$IOS"


Global DefsMap:TMap = New TMap

'- "OS X", "Windows", "Linux", "Android" Or "iOS".
Type toutos
	Field BT:TStream
	Field defs:TList = New TList
	Field LOSN$
	Field allow:Byte = True
	Field process:Byte
	Field dir$,file$
	Field ReleaseGame(os$)
	EndType
	
	
Global MacOut:toutos = New toutos
Global WinOut:Toutos = New toutos
Global LinOut:Toutos = New toutos
Global AndOut:Toutos = New toutos
Global IOSOut:Toutos = New toutos

macout.defs = macdefs
macout.losn = "OS X"
winout.defs = windefs
winout.losn = "Windows"
linout.defs = lindefs
linout.losn = "Linux"
andout.defs = anddefs
andout.losn = "Android" 
iosout.defs = iosdefs
iosout.losn = "iOS"

Global wplatforms$[] = ["OSX","WIN","LIN","AND","IOS"]

MapInsert DefsMap,"MAC",Macout
MapInsert DefsMap,"WIN",Winout
MapInsert DefsMap,"LIN",Linout
MapInsert DefsMap,"AND",Andout
MapInsert DefsMap,"MACOS",Macout
MapInsert DefsMap,"WINOWS",Winout
MapInsert DefsMap,"LINUX",Linout
MapInsert DefsMap,"ANDROID",Andout
MapInsert DefsMap,"MACOSX",Macout
MapInsert DefsMap,"OSX",Macout
MapInsert DefsMap,"IOS",iosout
Function DefsList:TList(Tag$)
	Local e:Object = MapValueForKey(defsmap,Upper(tag))
	If TList(e) Return TList(e)
	check toutos(e)<>Null,"I don't have a deflist called: "+tag
	Return Toutos(e).defs
End Function
Function out:toutos(tag$)
	Return Toutos(MapValueForKey(defsmap,Upper(tag)))
End Function
	
Type TImport
	Field file$
	Field variable$
	End Type

	
Global imports:TList = New TList
'Global impdetect:TList[] = [New TList,New TList]
Global importjcr:TJCRDir

Global WarningList:TList = New TList

Global AuthorMapVar:TMap = New TMap
Function AuthorLics:TMap(Author$)
If Not MapContains(AuthorMapVar,Author) MapInsert AuthormapVar,author,New TMap
Local LicMap:TMap = TMap(MapValueForKey(authormapvar,author))
Return licmap
End function
Function AuthorList:TList(Author$,License$)
If Not MapContains(AuthorMapVar,Author) MapInsert AuthormapVar,author,New TMap
Local LicMap:TMap = TMap(MapValueForKey(authormapvar,author))
If Not MapContains(licmap,license) MapInsert licmap,license, New TList
Return TList(MapValueForKey(licmap,license))
End Function
Function AuthorAddFile(Author$,license$,file$)
Local L:TList = authorlist(author,license)
ListAddLast L,file
SortList L
EndFunction
