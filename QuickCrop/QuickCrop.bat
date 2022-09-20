@echo off

:: -------------------------------------

:: QuickCrop Version 1.2

:: -------------------------------------

:: USAGE: Simply drag and drop the file you want to crop on top of this .bat

:: -------------------------------------

:: Settings

:: Should the cropped resolution be prompted before encoding begins? Change from 1 to disable. (default: 1)
set ConfirmResolution=1

:: Amount of time in seconds to scan for the crop resolution. (default: 10)
set MaxScanTime=10

:: Seconds to seek forward before beginning to scan, 0 if this is longer than the video duration. (default: 30)
set SeekTime=30

:: -------------------------------------

:: Code

title QuickCrop

:: if the user didn't give a file, show an error
if [%1]==[] goto ERROR_file

echo Detecting original resolution...

for /f "usebackq delims=" %%a in (`ffprobe -v error -select_streams v:0 -show_entries stream^=width -of default^=noprint_wrappers^=1:nokey^=1 "%~f1"`) do set srcwidth=%%a
for /f "usebackq delims=" %%a in (`ffprobe -v error -select_streams v:0 -show_entries stream^=height -of default^=noprint_wrappers^=1:nokey^=1 "%~f1"`) do set srcheight=%%a
echo Extracted source width (%srcwidth%) and height (%srcheight%)

echo Detecting target resolution...

:: scan for some time, in case it starts with a black screen
for /f "tokens=2 delims==" %%a in ('ffprobe "%~f1" -show_entries format^=duration -v quiet -of compact') do (
	set dur=%%a
)
if %dur% GTR %MaxScanTime% (
	set scanlength=%MaxScanTime%
) else ( set scanlength=%dur% )
if %SeekTime% GTR %dur% set SeekTime=0

:: converted from bash - https://gist.github.com/schocco/21981bc00c37c851e3ca
for /F "tokens=2 delims==" %%a in ('ffmpeg -hide_banner -ss %SeekTime% -i %1 -t %scanlength% -vf cropdetect -f null null 2^>^&1') do (
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
exit

:ERROR_file
echo Error: Please drag a file onto this program to use it.
echo.
echo Opening the file to edit settings... (you can safely close this terminal).
start notepad.exe %0
pause
exit
