echo "go make some tea..." & ^
powershell.exe -Command "scoop update *"  & ^
sudo wsl.exe --shutdown  & ^
sudo wsl.exe --update & ^
pause
