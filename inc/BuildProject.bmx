Rem
	Love - Build project
	
	
	
	
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
Version: 17.08.23
End Rem
Function SetupDefs()
Local dubbelepunt,List$,dkey$,L:TList
Print "Checking Definitions"
pini.clist("Defs",1)
gini.clist("Defs",1)
WriteStdout "__~r"
For Local dl:TIni = EachIn [gini,pini]
	WriteStdout "#"
	For Local key$=EachIn dl.list("Defs")
		dubbelepunt = key.find(":")
		If dubbelepunt<0
			list = "ALL"
		Else
			list	= key[..dubbelepunt+0]
			dkey	= key[dubbelepunt+1..] 
		EndIf	
		dkey = Upper(dkey)
		Select list.toupper()
			Case "ALL"
				For l:TList=EachIn MapValues(defsmap)
					ListAddLast l,dkey
				Next
			Default
				l = defslist(list)
				check L<>Null,"Unknown definition list"
				ListAddLast l,dkey
		End Select						
	Next
Next
Print "  ... done"
End Function

Function mdt(d$)
check CreateDir(TempDir+"/"+d,True),"Could not create: "+d
End Function

Function MakeDirs()
	mdt "Assets"
	mdt "Script"
	For Local k$=EachIn wplatforms
		If Len(k)=3 And k<>"MAC" And out(k)
			If Upper(Trim(need(pini,"OUTOS."+k,"Shall I make a build for platform: "+k+">"+out(k).losn+" ? (Y/N) ","Y")))="Y"
				mdt "Script/"+k
				out(k).process=True
			ElseIf Not out(k)
				warn "Null found on out("+k+"). This is an internal bug!"	
			EndIf	
		EndIf	
	Next
	'SortList wplatforms
End Function

Function OutWrite(atxt$,force=False)
	Local outk:toutos
	Local txt$
	For Local platform$=EachIn wplatforms
		txt=atxt
		outk=out(platform)
		If Not(force Or outk.allow) txt = "-- deactivated by builder -- "+txt
		If outk.process WriteLine outk.bt,txt
	Next
EndFunction

Function ConvertLua(prj:TJCRDir,file$)
	WriteStdout "= Adepting: "+file+" "
	Local platform$
	Local outk:toutos
	Local lines,line$,trline$,spline$[]
	Local warnings:TList =New TList
	Local defs:TList = New TList,D$,c
	Local imp_file$,imp_var$ ',imp_jcr:TJCRDir
	Local libdir$,libfound$
	Local external_requests_done
	'Local lini:TIni = New Tlini; lini.clist("Defs")		
	' Prepare
	For platform=EachIn wplatforms
		outk=out(platform)
		defs = New TList
		MapInsert defsmap,"LOCAL_"+Platform,defs
		For d$=EachIn defslist(platform) ListAddLast defs,d Next; SortList defs
		If Not outk error "Null-platform on: "+platform,True
		outk.process = pini.c("OUTOS."+platform).toupper()="Y"
		If outk.process
			WriteStdout Chr(platform[0])
			outk.allow=True
			outk.dir=Tempdir+"/Script/"+platform+"/"+ExtractDir(file)
			check CreateDir(outk.dir,1) , outk.dir+" could not be created"
			outk.file = outk.dir+"/"+StripDir(file)
			outk.bt = WriteFile(outk.file); 'DebugLog "Creating: "+outk.file
			If Not outk.bt 
				outk.process = False
				ListAddLast warnings, outk.file+" could not be created. This will very likely deem errors in the "+outk.losn+" version"
			EndIf
		EndIf
	Next
	WriteStdout " "
	' Action
	Local lcl$
	For line = EachIn Listfile(JCR_B(prj,file))
		If (Not lines) Or Right(lines,2)="00" WriteStdout "."
		lines:+1
		line = Replace(line,"$$mydir$$",ExtractDir(file))
		trline = Trim(line)
		If Prefixed(trline,"-- *")
			spline = trline.split(" ")
			Select spline[1].tolower()
				Case "*import","*require","*localimport"
					If spline[1].tolower()="*localimport" lcl="local " Else lcl=""
					check Len(spline)=3,"Incorrect number of parameters in line #"+lines
					check ExtractExt(spline[2].tolower())<>"lua","Don't use the .lua extention in import requests! Line #"+lines
					check ExtractExt(spline[2].tolower())<>"lll","Don't use the .lll extention in import requests! Line #"+lines
					imp_var$ = StripAll(spline[2])
					check Not Prefixed(Upper(spline[2]),"LIBS/"),"Invalid import request in line #"+lines					
					If JCR_Exists(prj,ExtractDir(file)+"/"+spline[2]+".lua") 
						imp_file=ExtractDir(file)+"/"+spline[2]+".lua" 
					ElseIf  (ExtractDir(spline[2]) And JCR_Exists(prj,spline[2]+".lua"))
						imp_file=ExtractDir(file)+"/"+spline[2]+".lua"
					ElseIf JCR_Exists(prj,ExtractDir(file)+"/"+spline[2]+".lll/"+spline[2]+".lua") 
						imp_file=ExtractDir(file)+"/"+spline[2]+".lll/"+spline[2]+".lua"
					ElseIf  (ExtractDir(spline[2]) And JCR_Exists(prj,spline[2]+".lll/"+spline[2]+".lua"))
						imp_file=ExtractDir(file)+"/"+spline[2]+".lll/"+spline[2]+".lua" 
					Else
						For libdir = EachIn gini.list("LIBRARIES")
							'Print "Check: "+Libdir+"  f: "+libdir+"/"+spline[2]+".lll/"+spline[2]+".lua"
							If Not (ExtractDir(spline[2]))
								If FileType(libdir+"/"+spline[2]+".lua")
									imp_file = "Libs/"+spline[2]+".lua"
									If Not ListContains(imports,spline[2]) AddRaw importjcr,libdir+"/"+spline[2]+".lua",imp_file external_requests_done=True								
								ElseIf FileType(libdir+"/"+spline[2]+".lll/"+spline[2]+".lua")
									imp_file = "Libs/"+spline[2]+".lll/"+spline[2]+".lua"
									check importjcr<>Null,"ImportJCR resource is null",1
									If Not ListContains(imports,spline[2]) JCR_AddPatch importjcr,JCR_Dir(libdir+"/"+spline[2]+".lll","Libs/"+spline[2]+".lll/") external_requests_done=True
								Else
									error "No way to import: "+spline[2]
								EndIf
							EndIf
						Next								
					EndIf	
					outwrite lcl+imp_var+" = "+imp_var+" or j_love_import(~q"+imp_file+"~q)~t"+line
				Case "*define"
					For platform=EachIn wplatforms
						outk=out(platform)
						check Len(spline)>2,"Invalid define in line #"+lines
						defs = defslist("LOCAL_"+Platform)
						If outk.allow 
							For c=2 Until (Len spline)
								If Chr(spline[c][0])="$" Or Chr(spline[c][0])="!"
									ListAddLast warnings,Chr(spline[c][0])+" is a reserved char! Definition requestion ignored! In line #"+lines
								Else
									If Not ListContains(defs,Upper(spline[c])) ListAddLast defs,Upper(spline[c])
								EndIf
							Next
						EndIf	
					Next	
					outwrite line
				Case "*undefine","*undef"
					For platform=EachIn wplatforms
						outk=out(platform)
						check Len(spline)>2,"Invalid undefine in line #"+lines
						defs = defslist("LOCAL_"+Platform)
						If outk.allow 
							For c=2 Until (Len spline)
								If Chr(spline[c][0])="$" Or Chr(spline[c][0])="!"
									ListAddLast warnings,Chr(spline[c][0])+" is a reserved char! Undefinition requestion ignored! In line #"+lines
								Else
									If ListContains(defs,Upper(spline[c])) ListRemove defs,Upper(spline[c])
								EndIf	
							Next
						EndIf	
					Next	
					outwrite line
				Case "*if"
					For platform=EachIn wplatforms
						outk=out(platform)
						outk.allow=True
						If outk.process
							If Not outk.bt ListAddLast warnings,"Could not write to file! Why?" Else WriteLine outk.bt,line
							EndIf
						c=0
						For Local d$=EachIn spline
							If c>1 
								If Chr(d[0])="!"
									outk.allow = outk.allow And ListContains(defslist("LOCAL_"+platform),Upper(Right(d,Len(d)-1)))=0
								Else
									outk.allow = outk.allow And ListContains(defslist("LOCAL_"+platform),Upper(d))
								EndIf
							EndIf		
							c:+1
						Next								
					Next
				Case "*fi"
					For platform=EachIn wplatforms
						out(platform).allow=True
					Next
					outwrite "-- *fi"
				Default
					ListAddLast warnings, "Unknown compiler directive! ("+spline[1]+") in line #"+lines+". If it was not a compiler directive please remove the *, as that marks such directives and who knows what will happen in future versions"			
					outwrite line
			End Select			
		Else	
			outwrite line	
		EndIf
	Next
	' Closure
	For platform=EachIn wplatforms
		If out(platform).process CloseFile out(platform).bt
	Next	
	If line=1 Print " done (1 line)" Else Print " done ("+lines+" lines)"
	For Local W$=EachIn warnings warn(W) Next
	Return external_requests_done
End Function

Function Build(aprj:TJCRDir)
	Local prj:TJCRDir=aprj
	Print "~n~nBuilding project"
	Local wantimports,uitslag
	Repeat
		importjcr:TJCRDir = New TJCRDir
		wantimports = False
		For Local f$=EachIn MapKeys(prj.entries)
			If ExtractExt(f)="LUA" 
				uitslag = ConvertLua ( prj,f ) 
				wantimports = wantimports Or uitslag
				'Print "Wantimports: "+wantimports+" uitslag: "+uitslag
			Else
				Print "= Copying: "+f
				check CreateDir(tempdir+"/Assets/"+ExtractDir(f),1),"Could not create target asset it"
				check SaveBank(JCR_B(prj,f),Tempdir+"/Assets/"+f),"Copy failed!"
				If JCR_Type(Tempdir+"/Assets/"+f)
					need pini,"jcr6unpack["+f+"]","The file "+f+" has been recognized as "+JCR_Type(Tempdir+"/Assets/"+f)+"~nDo you want to merge its content in the project ? (Y/N) ","Y"
					If Left(pini.C("jcr6unpack["+f+"]"),1).toupper()="Y" 
						CopyFile Tempdir+"/Assets/"+f,Tempdir+"/JCR_TEMP.JCR"
						DeleteFile Tempdir+"/Assets/"+f
						Local TJ:TJCRDir = JCR_Dir(Tempdir+"/JCR_TEMP.JCR")
						CreateDir tempdir+"/Assets/"+f
						For Local tf$=EachIn MapKeys(tj.entries)
							Print "= Extracting "+tf+" from "+f
							JCR_Extract tj,tf,tempdir+"/Assets/"+f
						Next
					EndIf
				EndIf	
			EndIf
		Next	
		prj = importjcr
		importjcr:TJCRDir = New TJCRDir
	Until Not wantimports	
EndFunction

Function I_love_you(file$)
Local script$=LoadString("incbin::LoveMain.lua")
script = Replace(script,"-- builddate --",PNow())
script = Replace(script,"-- version --",Right(Year(),2)+"."+Right("0"+Month(),2)+"."+Right("0"+Day(),2))
script = Replace(script,"-- title --",pini.c("Title"))
script = Replace(script,"-- import iloveyou --","j_love_import(~q"+file+"~q)")
For Local platform$=EachIn wplatforms
	If out(platform).process SaveString script,tempdir+"/script/"+platform+"/main.lua"
	Next
End Function

Function BuildProject()
	Print
	If FileType(tempdir)
		Print "The temp dir still exists! Probably due to a failed session!"
		If Not yes("Do you want to delete it") End
		check DeleteDir(tempdir,1),"Could not delete: "+Tempdir
	EndIf
	Local iloveyou,iloveyoufile$
	For Local f$=EachIn MapKeys(project.entries)
		If StripDir(f)="ILOVEYOU.LUA" iloveyou:+1; iloveyoufile=f
		check StripDir(f)<>"MAIN.LUA","MAIN.LUA is a reserved filename!"
		Next
	check iloveyou    ,"There is no ILOVEYOU.LUA file anywhere in this project!"
	check iloveyou=1,"I found "+iloveyou+" ILOVEYOU.LUA files. There may only be 1"
	SetUpDefs
MakeDirs	
Build project
I_love_you iloveyoufile
End Function
