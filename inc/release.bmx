Rem
	Build Love
	Releaser
	
	
	
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
MKL_Version "Love Builder - release.bmx","17.11.12"
MKL_Lic     "Love Builder - release.bmx","GNU General Public License 3"


Function MacRelease(o$)
Rem
	Local mac:TJCRDir = JCR_Dir("incbin::Mac64.jcr")
	Local e:TJCREntry
	Local target$,infomac$,copyright$=""
	AddRaw mac,tempdir+"/zips/project.OSX.love","love.app/Contents/Resources/"+pini.c("Executable")+".love"
	WriteStdout "Building application: "+pini.c("Release."+platform)+"/"+o+"/"+pini.c("Executable")+".app  ... "
	?debug
	Print "Debug data below"
	?Not debug
	Local nument,cntent,prcent
	For e=EachIn MapValues(mac.entries) nument:+1 Next
	?
	For e=EachIn MapValues(mac.entries)
		target = pini.c("Release."+platform)+"/"+o+"/"+Replace(e.filename,"love.app/",pini.c("Executable")+".app/")
		?debug
		Print "= Writing: "+target
		?Not debug
		cntent:+1
		prcent = Int((Double(cntent)/Double(nument))*100)
		WriteStdout Right("   "+prcent,4)+"%"+Chr(8)+Chr(8)+Chr(8)+Chr(8)+Chr(8)
		?
		check CreateDir(ExtractDir(target),2),"Could not create: "+ExtractDir(target)
		If ExtractExt(target).tolower()="icns"
			If Not CopyFile(pini.c("MacIcon."+platform),target) warn "Could not copy "+pini.c("MacIcon."+platform)+" to "+target
		ElseIf e.filename.tolower()="love.app/contents/info.plist"
			copyright=""
			For Local yr$=EachIn pini.list("years")
				If copyright copyright:+", "
				copyright:+yr
			Next
			copyright:+"  "+pini.c("you")
			infomac = LoadString(JCR_B(mac,e.filename))
			infomac = Replace(infomac,"{title}",pini.c("Title"))
			infomac = Replace(infomac,"{build}",Right(Year(),2)+"."+Right("0"+Month(),2)+"."+Right("0"+Day(),2))
			infomac = Replace(infomac,"{copyright}",copyright)			
			SaveString infomac,target
		ElseIf e.filename.tolower()="love.app/contents/macos/love"
			If Not FileType(e.filename) JCR_Extract mac,e.filename,target,True
		Else
			JCR_Extract mac,e.filename,target,True
		EndIf			
	Next
	?Not debug
	Print "done   "
	?
End Rem
	Local target$,infomac$,copyright$=""
	Local outapp$ = pini.c("Release."+platform)+"/"+o+"/"+pini.c("Executable")+".app"
	Select FileType(outapp)
		Case 1
			Print "ERROR: There is a FILE named `"+outapp+"` -- It blocks me from writing a mac app!"
			Return
		Case 2
			Print ANSI_SCol("Updating application: ",A_Cyan,A_Dark)+ANSI_SCol(outapp,A_magenta)
		Case 0
			Print ANSI_SCol("Creating application: ",A_Cyan,A_Dark)+ANSI_SCol(outapp,A_magenta)
			Local temp$=Dirry("$AppSupport$/BuildLove/MacTemp")
			If Not CreateDir(temp,1)
				Print "ERROR: No swap dir could be created"
				Return
			EndIf
			Print D("Extracting core data")
			CopyFile "incbin::Mac64.zip",temp+"/Mac64.zip"
			Local cd$=CurrentDir()
			ChangeDir temp
			Print D("Extracting app data")
			system_ "unzip Mac64 > UnpackResult.txt"
			Print D("Installing base app")
			ChangeDir cd
			?win32
			system_ "move '"+Replace(temp,"/","\")+"\love.app' '"+outapp+"'"
			?Not win32
			system_ "mv '"+temp+"/love.app' '"+outapp+"'"
			?
	End Select	
	Print D("Iconing application")
	Local tgt$[]=[outapp+"/Contents/Resources/OS X AppIcon.icns",outapp+"/Contents/Resources/GameIcon.icns"]
		For target = EachIn tgt
			If Not CopyFile(pini.c("MacIcon."+platform),target) warn "Could not copy "+pini.c("MacIcon."+platform)+" to "+target
		Next
	'Rem	
	
	Print D("Writing game's meta data")
			copyright=""
			For Local yr$=EachIn pini.list("years")
				If copyright copyright:+", "
				copyright:+yr
			Next
			copyright:+"  "+pini.c("you")
			infomac = LoadString("incbin::info.plist") 'JCR_B(mac,love.app/contents/info.plist))
			infomac = Replace(infomac,"{title}",pini.c("Title"))
			infomac = Replace(infomac,"{build}",Right(Year(),2)+"."+Right("0"+Month(),2)+"."+Right("0"+Day(),2))
			infomac = Replace(infomac,"{copyright}",copyright)			
			SaveString infomac,outapp+"/Contents/info.plist"
	'End Rem		
			
	Print D("Installing game's resources")
	check CopyFile(tempdir+"/zips/project.OSX.love",outapp+"/Contents/Resources/"+pini.c("Executable")+".love"),"Copying data failed!"
	Print D("Done","=",A_Green)						
	
End Function; out("OSX").releasegame = MacRelease


Function WinRelease(o$)
	Local win32:TJCRDir = JCR_Dir("incbin::Win32.jcr")
	Local win64:TJCRDir = JCR_Dir("incbin::Win64.jcr")
	Local exej:TJCRDir[] = [win32,win64]
	Local dir$ = pini.c("Release."+platform)+"/"+o+"/"
	Local exeb[] = [32,64]
	Local exed$[] = [dir+"/32bit",dir+"/64bit"]
	Local love:TJCRDir = Raw2JCR(tempdir+"/zips/project.WIN.love","Win.love")
	Local lovebank:TBank = JCR_B(love,"Win.Love")
	Local exebank:TBank
	Local i	
	Local bo:TStream
	Local e:TJCREntry
	Local lic$ = LoadString(JCR_B(win32,"license.txt"))
	For i=0 Until Len exeb
		check CreateDir(exed[i],1),"Cannot create: "+Exed[i]
		exebank = JCR_B(exej[i],"love.exe")
		WriteStdout D("Compiling: ")+ANSI_SCol(exed[i]+"/"+pini.c("Executable")+".exe",A_Magenta)+ANSI_SCol(" ... ",A_Cyan)+"step 1"
		bo = WriteStream(exed[i]+"/"+pini.c("Executable")+".exe")
		check bo<>Null,"Cannot write file!"
		WriteBank exebank,bo,0,BankSize(exebank)
		WriteStdout Chr(8)+Chr(8)+" 2 "
		WriteBank lovebank,bo,0,BankSize(lovebank)
		For Local j=1 To 7 WriteStdout Chr(8) Next
		Print ANSI_SCol(" done    ",A_Green)
		CloseStream bo
		For e=EachIn MapValues(exej[i].entries)
			If ExtractExt(e.filename).tolower()="dll" 
			   JCR_Extract exej[i],e.filename,exed[i] 
			   ?debug
			   Print D("Written: "+exed[i]+"/"+e.filename)
			   ?
			   EndIf
			Next
		bo = WriteStream(exed[i]+"/love.license.txt")
		WriteLine bo,"This file only explains the license about the underlying LOVE2D engine. It says nothing about the game itself!~n~n"	
		WriteString bo,lic
		CloseStream bo
	Next			
End Function; out("WIN").releasegame = winrelease


Function LinRelease(o$)
Local lout$ = pini.c("Release."+platform)+"/"+o+"/"+pini.c("Executable")+".linux.love"
check CopyFile(tempdir+"/zips/project.LIN.love",lout),"Copy love file failed"
'Print "WARNING! Linux batch files not yet present in builder. Planned for future versions!"
Print ANSI_SCol("Linux output file: ",A_Cyan)+ANSI_SCol(lout,A_Magenta)
End Function; out("LIN").releasegame = LinRelease

Function AndroidRelease(o$)
	Print ANSI_SCol("You do need git, and the Android SDK and NDK in order to get this done!",A_Yellow)
	Local cloneit = Not FileType(workdir+"/Android/Clone")
	Local clonedir$ = workdir+"Android/Clone/"
	check CreateDir(workdir+"Android/Clone",2),"Could not create clone dir for Android"
	'check CreateDir(workdir+"Android/Copy",2),"Could not create copy dir for Android"
	Local pdir$ = workdir+"Android/PRJ"
	' Clone the android data in case it doesn't exist
	If cloneit
		Repeat
			Print ANSI_SCol("Cloning love for Android repository",A_Cyan)
			system_ "git clone https://bitbucket.org/MartinFelis/love-android-sdl2 '"+clonedir+"'"
		Until Yes("Is everything cloned succesfully")
	EndIf
	' Copy the Android data
	If FileType(pdir) 
		If Yes("Old android shit is there. Maybe something went wrong last time. Remove it") 
			check DeleteDir(pdir,1),"Sorry, that didn't work"
		Else
			warn "Then I cannot make a new Android build"
			Return
		EndIf
	EndIf
	Print ANSI_SCol("Copying data into project",a_cyan)
	?win32
	pdir = Replace(pdir,"/","\")
	CreateDir pdir
	system_ "xcopy /e ~q"+clonedir+"~q ~q"+pdir+"~q"
	?Not win32
	system_ "cp -r ~q"+clonedir+"~q ~q"+pdir+"~q"
	?
	' Configure ndk and sdk dirs
	Print ANSI_SCol("Configuring snd/ndk directories",A_Cyan)
	need pini,"Android."+platform+".NDK","Android ndk dir",""
	need pini,"Android."+platform+".SDK","Android sdk dir",""
	SaveString "ndk.dir="+pini.c("Android."+platform+".NDK")+"~nsdk.dir="+pini.c("Android."+platform+".SDK"),pdir+"/local.properties"
	' Copy love file
	check CreateDir(pdir+"/app/src/main/assets",2),"lovedir could not be created"
	Print ANSI_SCol("Copying game into android install directory",A_Cyan)
	check CopyFile(tempdir+"/zips/project.AND.love",pdir+"/app/src/main/assets/"+pini.c("Executable")+".Android.Love"),"Copy love file failed"
	' FIRE!
	Local od$ = CurrentDir()
	ChangeDir pdir
	?Not win32
	system_ "chmod +x gradlew"
	?
	Print ANSI_SCol("Creating apk file",A_Cyan)
	system_ "./gradlew build"
	system_ "ls -Gla app/build/outputs/apk/" ' debug line must be on rem in final version
	
End Function
out("AND").releasegame=AndroidRelease

Function ReleaseGames()
	Local r(os$)
	For Local p$=EachIn(wplatforms)
		If out(p).process
			Print ANSI_SCol("Releasing for ",A_Cyan,A_Bright)+ANSI_SCol(out(p).losn,A_Magenta,A_Bright)
			r = out(p).releasegame
			If Not r
				warn "Code not found to release for: "+p
			Else	
				check CreateDir(pini.c("Release."+platform)+"/"+p,2),"Could not create: "+pini.c("Release."+platform)+"/"+p,2
				r(p)
			EndIf
		EndIf
	Next	
End Function
