Rem
	Love - Routines to easily set up data and default data
	
	
	
	
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
Version: 17.08.16
End Rem
Function Need$(ini:TIni,Tag$,Question$,DefaultValue$,isfile=False)
If ini.c(tag) Return Print(Question+": "+ini.c(tag))
Repeat
	ini.d tag,Input(Question+": ")
	If defaultvalue<>"*REQUIRED*" Or ini.c(tag) Exit
	Print "I require an answer on this one! Sorry!"
Forever	
If Not ini.c(tag) ini.d tag,defaultvalue
If isfile ini.d tag,Replace(ini.c(tag),"\","/")
SaveIni pinifile,pini
Return ini.c(tag)
EndFunction



Function DefaultIni()
pini.clist("years",1)
If Not ListContains(pini.list("years"),Year()+"") pini.add "years",Year()+""; SaveIni pinifile,pini
Need pini,"Title","Project title",StripAll(pinifile)
'Need pini,"PrefProj","Prefix with projectdir ? (Y/N) ","Y"	
need pini,"Projectdir."+platform,"Project dir",ExtractDir(pinifile)+"/project"
Need pini,"MultiDir","Multi-dir project ? (Y/N) ","Y"
Need pini,"MacIcon."+platform,"Mac Icon",ExtractDir(pinifile)+"/project/"+StripAll(pinifile)+".icns"
Need pini,"Executable","Executable (without pathname)",Replace(pini.c("Title")," ","_")
need pini,"Release."+platform,"Release directory","*REQUIRED*"
need pini,"You","And you are","Mr. Nobody"
EndFunction
