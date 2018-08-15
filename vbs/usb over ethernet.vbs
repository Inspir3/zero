'-----------------------------------------------
' A partir d'un raspbian fraichement installé,
' Ce script active :
' - sshd
' - USB over ethernet (dwc2 & g_ether)
' La sdcard doit être sur le lecteur D:
'-----------------------------------------------

Const forReading=1
Const forWriting=2

Const sshFile="d:\ssh"
Const configFile="d:\config.txt"
Const cmdlineFile="d:\cmdline.txt"

set objFSO = CreateObject("Scripting.FileSystemObject")

'------------
' Active sshd
'------------
sub sshd()
	if not objFso.FileExists(sshFile) then
		set objFile = objFSO.CreateTextFile(sshFile)

		objFile.WriteLine
	set objFile = objFSO.OpenTextFile(configFile, ForReading)

		objFile.close
	end if
end sub

'------------------
' USB over ethernet
'------------------
sub usbOverEthernet()
	'--------------
	'config.txt
	'--------------
	set objFile = objFSO.OpenTextFile(configFile, ForReading)

	contenu = objFile.ReadAll

	objFile.close

	if right(contenu, 4) <> "dwc2" then
		contenu = contenu & vblf & vblf
		contenu = contenu & "# USB over ethernet" & vblf
		contenu = contenu & "dtoverlay=dwc2"

		set objFile = objFSO.OpenTextFile(configFile, ForWriting)

		objFile.Write contenu

		objFile.close
	end if

	'--------------
	'cmdline.txt
	'--------------
	set objFile = objFSO.OpenTextFile(cmdlineFile, ForReading)

	contenu = objFile.ReadAll

	objFile.close
	
	if mid(contenu, instr(contenu, "rootwait")+9, 3) <> "mod" then
		nouveauContenu = Replace(contenu, "rootwait", "rootwait modules-load=dwc2,g_ether")

		set objFile = objFSO.OpenTextFile(cmdlineFile, ForWriting)

		objFile.Write nouveauContenu

		objFile.close
	end if
end sub

sshd()
usbOverEthernet()

WScript.echo("OK")
