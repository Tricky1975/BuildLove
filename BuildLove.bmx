Rem
	Love Builder
	Properly sets up a Love project for all available platforms
	
	
	
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

Strict
Framework tricky_units.gini
'Import "/projects/blitzmax/jcr6+/units/dirry/dirry.bmx" 'Temp line
Import tricky_units.Dirry
Import tricky_units.ListDir
Import tricky_units.Listfile
Import tricky_units.advdatetime
Import tricky_units.prefixsuffix
Import tricky_units.CreateIndexFiles
Import tricky_units.ansistring
Import jcr6.zlibdriver
Import jcr6.realdir
Import jcr6.fileasjcr

Import "Love/incbin.bmx"

Include "inc/globals.bmx"
Include "inc/error.bmx"
Include "inc/yes.bmx"
Include "inc/defaultini.bmx"
Include "inc/lookdirs.bmx"
Include "inc/BuildProject.bmx"
Include "inc/zip.bmx"
Include "inc/release.bmx"
Include "inc/writelicenses.bmx"

MKL_Version "Love Builder - BuildLove.bmx","17.11.12"
MKL_Lic     "Love Builder - BuildLove.bmx","GNU General Public License 3"


AppTitle = "BuildLove v"+MKL_NewestVersion()+" - Make Love Not War!"
Print ANSI_Col("BuildLove v"+MKL_NewestVersion(),A_Yellow,A_Red)
Print ANSI_SCol("Coded by: Tricky",A_Yellow,A_Italic)
Print ANSI_SCol("(c) Jeroen Broks 2016",A_Yellow,A_Dark)

?debug
warn "Please note that this is the DEBUG build of the builder!!!"
?

If (Len AppArgs)<2
	Print MKL_GetAllversions()
	Print
	Print "Usage: BuildLove <Project>"
	End
EndIf
	
check FileType(ginifile),"Can't load: "+ginifile
LoadIni ginifile,gini	
	
ChangeDir LaunchDir
pinifile=AppArgs[1]
If Not ExtractExt(pinifile) pinifile:+".blp"
check FileType(pinifile)<>2,"I cannot use a directory as project file: "+pinifile
If Not FileType(pinifile)
	Print "I do not have a project named: "+pinifile
	If Not yes("Create it") End
	bt = WriteFile(pinifile)
	check bt<>Null,"Could not create: "+pinifile
	WriteLine bt, "[rem]~nEmpty project"
	CloseFile bt	
	Print "Project created~n"
EndIf

Print ANSI_SCol("Processing project: ",A_Cyan)+ANSI_SCol(pinifile,A_Magenta)
LoadIni pinifile,pini

DefaultIni
LookDirs
BuildProject
zip
releasegames
Print ANSI_SCol("Cleaning up my mess...",A_Cyan); If Not  DeleteDir(tempdir,1) warn "Tempdir ~q"+tempdir+"~q could not be removed.~n~t   This should not affect the built game, but only takes up diskspace and leads to a warning on the next build."
WriteLicenses
repeatwarnings
