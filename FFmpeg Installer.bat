@echo off
title FFmpeg Installer

set ESC=

if "%PATH%" NEQ "%PATH:FFmpeg=%" (
	echo You already appear to have FFmpeg installed and on PATH.
	echo This installer will now exit.
	echo.
	pause
	exit
)

set SevenZipDir=C:\Program Files\7-Zip
echo %ESC%[48;5;214m%ESC%[38;5;0m===============================================
echo WARNING: This installer requires 7-Zip to work.
echo ===============================================%ESC%[00m
echo If you do not have 7-Zip, please CANCEL AND INSTALL THAT FIRST.
echo (Advanced Users: 7-Zip must be present under %SevenZipDir% - not just 7z.exe on PATH)
echo.
set InstallDir=%localappdata%\FFmpeg
echo Installing in %InstallDir%
choice /c YN /n /m "Continue with install? ([Y]es/[N]o): "
if %errorlevel%==2 exit
echo.

set DownloadLink=https://www.gyan.dev/ffmpeg/builds/ffmpeg-release-full.7z
set DownloadedFile=%userprofile%\Downloads\ffmpeg-full-download-temp.7z

echo Downloading FFmpeg from %DownloadLink%
powershell -Command "(New-Object Net.WebClient).DownloadFile('%DownloadLink%', '%DownloadedFile%')"

echo Unzipping into %InstallDir%
"%SevenZipDir%\7z.exe" x %DownloadedFile% -o%DownloadedFile%-unpacked
rmdir "%InstallDir%" /s /q
move "%DownloadedFile%-unpacked\ffmpeg*build" "%InstallDir%"

echo Cleaning up temporary files
del %DownloadedFile%
rmdir %DownloadedFile%-unpacked

echo Adding FFmpeg to PATH
reg add "HKEY_CURRENT_USER\Environment" /v "Path" /t REG_SZ /d "%PATH%;%InstallDir%\bin;" /f

echo.
echo.
echo ===== Finished =====
echo.
echo.
echo %ESC%[48;5;227m%ESC%[38;5;0mYou must restart your computer to finish applying changes.%ESC%[00m
echo.
echo.
pause
exit
