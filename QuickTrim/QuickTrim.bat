@echo off

:: -------------------------------------

:: QuickTrim Version 1.2b

:: -------------------------------------

:: USAGE: Drag a video file onto this program, then enter the desired trim settings.

:: -------------------------------------

:: Settings

:: Advanced input for manually entering hh:mm:ss.ms arguments. Faster for technical users, but less streamlined. (Default: 0)
set UseManualInput=0

:: -------------------------------------

:: Code

title QuickTrim

:: if the user didn't give a file, show an error
if [%1]==[] goto ERROR_file

:: get the video duration in seconds
:: go go gadget copy paste - https://stackoverflow.com/questions/32344947/ffmpeg-batch-extracting-media-duration-and-writing-to-a-text-file
for /f "tokens=2 delims==" %%a in ('ffprobe "%~f1" -show_entries format^=duration -v quiet -of compact') do (
	set dur=%%a
)

:: do some operations to extract hours, minutes, etc. from the duration
:: also add a leading zero if necessary using some hacky bs
set /a h2=dur / 3600
if %h2% LEQ 9 set h2=0%h2%
set /a m2=dur / 60 - h2 * 60
if %m2% LEQ 9 set m2=0%m2%
set /a s2=dur %% 60
if %s2% LEQ 9 set s2=0%s2%
set ms2=%dur:~-6%

if "%UseManualInput%"=="1" goto MANUALINPUT

:EASYINPUT
:: initial variable setup
set h1=00
set m1=00
set s1=00
set ms1=00

echo Your video duration is %h2% hour(s), %m2% minute(s), %s2% second(s), and %ms2:~0,3% millisecond(s).
:: can't guarantee it's over an hour long, so meh
if %h2% GEQ 1 (
	echo Enter starting hour, or nothing to default to 0:
	set /p h1=
	echo Enter ending hour, or nothing to default to the end of the video:
	set /p h2=
)
if %h2%%m2% GEQ 1 (
	echo Enter starting minute, or nothing to default to 0:
	set /p m1=
	echo Enter ending minute, or nothing to default to the end of the video:
	set /p m2=
)
echo Enter starting second, or nothing to default to 0:
set /p s1=
echo Enter ending second, or nothing to default to the end of the video:
set /p s2=
echo Enter starting millisecond, or nothing to default to 0:
set /p ms1=
echo Enter ending millisecond, or nothing to default to the end of the video:
set /p ms2=
:: I have determined that it is your fault if you give invalid data, not because I'm lazy or anything. FFmpeg gives an error
set start=%h1%:%m1%:%s1%.%ms1%
set end=-to %h2%:%m2%:%s2%.%ms2%
goto TRIM

:MANUALINPUT
echo Program is running in advanced mode.
echo Please follow the format hh:mm:ss.ms (you may omit hh:, mm:, and/or .ms if applicable)
echo Your video duration is %h2%:%m2%:%s2%.%ms2%
echo Enter start time, or nothing for unchanged.
set start=0
set /p start=
echo Enter end time, or nothing for unchanged.
set /p end=
if "%end%" NEQ "" set end=-to %end%
goto TRIM

:TRIM
ffmpeg -ss %start% -i %1 %end% -c copy "%~n1_trim%~x1"
pause
exit

:ERROR_file
echo Error: Please drag a file onto this program to use it.
echo Opening the file to edit settings... (you can safely close this terminal).
start notepad.exe %0
echo.
pause
exit