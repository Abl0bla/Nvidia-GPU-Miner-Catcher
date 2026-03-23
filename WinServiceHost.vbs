Set WshShell = CreateObject("WScript.Shell")

' Use PUBLIC environment variable to locate the script generically
PublicDocs = WshShell.ExpandEnvironmentStrings("%PUBLIC%")
ScriptPath = PublicDocs & "\Documents\DiagTrackData.ps1"

' Run PowerShell in hidden mode (0) without a window flash
WshShell.Run "powershell.exe -ExecutionPolicy Bypass -File " & Chr(34) & ScriptPath & Chr(34), 0, False