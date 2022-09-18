@echo off

:: -------------------------------------

:: QuickCrop Version 1.0

:: -------------------------------------

:: USAGE: Simply drag and drop the file you want to crop on top of this .bat

:: -------------------------------------

:: Settings

:: Should the cropped resolution be prompted before encoding begins? Change from 1 to disable. (default: 1)
set ConfirmResolution=1

:: -------------------------------------

:: Code

echo Detecting target resolution...

:: converted from bash - https://gist.github.com/schocco/21981bc00c37c851e3ca
for /F "tokens=2 delims==" %%A in ('ffmpeg -hide_banner -i %1 -t 1 -vf cropdetect -f null null 2^>^&1') do (
	echo %%A | find ":" >nul
	if errorlevel 1 (echo.>nul) else (set croptarget=%%A)
)
echo Extracted crop information: %croptarget%

:: extract the width and height
for /f "tokens=1 delims=:" %%A in ("%croptarget%") do set width=%%A
for /f "tokens=2 delims=:" %%A in ("%croptarget%") do set height=%%A
echo Extracted width (%width%) and height (%height%)

cls

echo Detected output resolution %width% by %height%
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

ffmpeg -y -i %1 -vf "crop=%width%:%height%" %~f1_qcr%~x1
