$gitExe = "$env:LOCALAPPDATA\Programs\MinGit\cmd\git.exe"
Remove-Item "tools\status.ps1" -Force -ErrorAction SilentlyContinue
& $gitExe add -A
& $gitExe commit --amend -m "Initial commit"
& $gitExe status
