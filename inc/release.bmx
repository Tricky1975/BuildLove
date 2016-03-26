MKL_Version "",""
MKL_Lic     "",""


Function MacRelease(o$)
	Local mac:TJCRDir = JCR_Dir("incbin::Mac64.jcr")
	Local e:TJCREntry
	Local target$
	AddRaw mac,tempdir+"/zips/project.OSX.love","love.app/Contents/Resources/"+pini.c("Executable")+".love"
	For e=EachIn MapValues(mac.entries)
		target = pini.c("Release."+platform)+"/"+o+"/"+Replace(e.filename,"love.app/",pini.c("Executable")+".app/")
		Print "= Writing: "+target
		check CreateDir(ExtractDir(target),2),"Could not create: "+ExtractDir(target)
		If ExtractExt(target).tolower()="icns"
			If Not CopyFile(pini.c("MacIcon."+platform),target) warn "Could not copy "+pini.c("MacIcon."+platform)+" to "+target
		Else
			JCR_Extract mac,e.filename,target,True
		EndIf			
	Next
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
		WriteStdout "= Compiling: "+exed[i]+"/"+pini.c("Executable")+".exe ... step 1 "
		bo = WriteStream(exed[i]+"/"+pini.c("Executable")+".exe")
		check bo<>Null,"Cannot write file!"
		WriteBank exebank,bo,0,BankSize(exebank)
		WriteStdout Chr(8)+Chr(8)+"2 "
		WriteBank lovebank,bo,0,BankSize(lovebank)
		For Local j=1 To 7 WriteStdout Chr(8) Next
		Print "done    "
		CloseStream bo
		For e=EachIn MapValues(exej[i].entries)
			If ExtractExt(e.filename).tolower()="dll" JCR_Extract exej[i],e.filename,exed[i] Print "= Written: "+exed[i]+"/"+e.filename
			Next
		bo = WriteStream(exed[i]+"/love.license.txt")
		WriteLine bo,"This file only explains the license about the underlying LOVE2D engine. It says nothing about the game itself!~n~n"	
		WriteString bo,lic
		CloseStream bo
	Next			
End Function; out("WIN").releasegame = winrelease

Function ReleaseGames()
	Local r(os$)
	For Local p$=EachIn(wplatforms)
		If out(p).process
			Print "Releasing for "+out(p).losn
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
