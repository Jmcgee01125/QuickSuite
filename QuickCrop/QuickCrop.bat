@echo off

:: -------------------------------------

:: QuickCrop Version 1.0c

:: -------------------------------------

:: USAGE: Simply drag and drop the file you want to crop on top of this .bat

:: -------------------------------------

:: Settings

:: Should the cropped resolution be prompted before encoding begins? Change from 1 to disable. (default: 1)
set ConfirmResolution=1

:: -------------------------------------

:: Code

echo Detecting original resolution...

for /f "usebackq delims=" %%a in (`ffprobe -v error -select_streams v:0 -show_entries stream^=width -of default^=noprint_wrappers^=1:nokey^=1 "%~f1"`) do set srcwidth=%%a
for /f "usebackq delims=" %%a in (`ffprobe -v error -select_streams v:0 -show_entries stream^=height -of default^=noprint_wrappers^=1:nokey^=1 "%~f1"`) do set srcheight=%%a
echo Extracted source width (%srcwidth%) and height (%srcheight%)

echo Detecting target resolution...

:: converted from bash - https://gist.github.com/schocco/21981bc00c37c851e3ca
for /F "tokens=2 delims==" %%a in ('ffmpeg -hide_banner -i %1 -t 1 -vf cropdetect -f null null 2^>^&1') do (
	echo %%a | find ":" >nul
	if errorlevel 1 (echo.>nul) else (set croptarget=%%a)
)
echo Extracted crop information: %croptarget%

:: extract the width and height
for /f "tokens=1 delims=:" %%a in ("%croptarget%") do set width=%%a
for /f "tokens=2 delims=:" %%a in ("%croptarget%") do set height=%%a
echo Extracted width (%width%) and height (%height%)
if %width% LSS 0 set /a width=width*-1
if %height% LSS 0 set /a height=height*-1
echo Adjusted width (%width%) and height (%height%)

cls

echo Detected output resolution %width% by %height% (Source is %srcwidth% by %srcheight%)
if %ConfirmResolution%==1 (
	choice /c YCN /m "Continue? (Yes / Change / No (cancel))"
)
:: this goes outside of the if block for stupid reasons
if %errorlevel%==3 exit
if %errorlevel%==2 (
	echo Enter width:
	set /p width=
	echo Enter height:
	set /p height=
)

ffmpeg -y -i %1 -c:a copy -vf "crop=%width%:%height%" "%~n1_qcr%~x1"
