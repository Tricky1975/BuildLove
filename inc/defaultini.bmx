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
Need pini,"Executable","Executable",Replace(pini.c("Title")," ","_")
need pini,"Release."+platform,"Release directory","*REQUIRED*"
need pini,"You","And you are","Mr. Nobody"
EndFunction
