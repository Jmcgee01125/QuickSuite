@echo off

:: -------------------------------------

:: QuickCompress Version 1.2

:: -------------------------------------

:: USAGE: Simply drag and drop the file you want to convert on top of this .bat

:: -------------------------------------

:: Settings

:: Automatically determines maximum bitrate based on the target output size in KB (defaults: 1, 8000, 512)
:: Note that there are some scenarios where the file still exceeds the target. In this case, try reducing target output size.
:: To disable, set UseSmartBitrate to 0
set UseSmartBitrate=1
set TargetOutputSizeKB=8000
set WarnForLowDetailThreshold=512

:: Default maximum bitrate (in Kb), if not using smart bitrate (default: 2000)
set mbr=2000

:: Audio bitrate (in Kb), used with or without smart bitrate.
:: To use source rate, set as "src" (default: 196)
set abr=196

:: Use webm (vp9) instead of mp4 (x264) (default: 0)
:: Not recommended for quick compressions, but can achieve higher detail at lower bitrates (sub 500K).
set UseWebm=0

:: -------------------------------------

if [%1]==[] goto ERROR_file

set name=%~n1%
set ext=%~x1%

if "%abr%"=="src" goto FINDSRCABR

:RETURNINTRO
if %UseSmartBitrate%==1 goto SMARTMBRCALC

echo Using bitrate %mbr%K, change? (Y or N (default))
set /p op=
if /I "%op%"=="y" goto CHANGEMBR

:COMPRESS
if %UseWebm%==1 goto :WEBMCOMPRESS
ffmpeg -i "%~f1" -b:v %mbr%K -b:a %abr%K -c:v libx264 "%name%_qc.mp4"
exit

:WEBMCOMPRESS
ffmpeg -i "%~f1" -b:v %mbr%K -b:a %abr%K -c:v vp9 "%name%_qc.webm"
exit

:SMARTMBRCALC
:: go go gadget copy paste - https://stackoverflow.com/questions/32344947/ffmpeg-batch-extracting-media-duration-and-writing-to-a-text-file
for /f "tokens=2 delims==" %%a in ('ffprobe "%~f1" -show_entries format^=duration -v quiet -of compact') do (
	set dur=%%a
)
set /a targetkbit=%TargetOutputSizeKB% * 8
set /a mbr=%targetkbit% / dur
if %UseWebm%==1 (
	set /a buffer=mbr / 3
) else (
	set /a buffer=mbr / 8
)
set /a mbr=mbr - abr - buffer

if %mbr% LEQ %WarnForLowDetailThreshold% goto CONFIRMLOWDETAIL
goto COMPRESS

:CONFIRMLOWDETAIL
echo Warning: Video bitrate is very low (^< %WarnForLowDetailThreshold% Kbps).
echo This will drastically affect the video quality.
echo Do you wish to continue? (Y (default) or N):
set /p cont=
if /I "%cont%"=="n" exit
goto COMPRESS

:CHANGEMBR
echo Please type a bitrate, in Kb (omit Kb):
set /p mbr=
goto COMPRESS

:FINDSRCABR
:: go go gadget copy paste again - https://superuser.com/questions/1541235/how-can-i-get-the-audio-bitrate-from-a-video-file-using-ffprobe
ffprobe -v 0 -select_streams a:0 -show_entries stream=bit_rate -of compact=p=0:nk=1 "%~f1" > quickcomptemporaryfileforyoinkingtheoriginalaudiobitrate.txt
set /p abr=<quickcomptemporaryfileforyoinkingtheoriginalaudiobitrate.txt
del quickcomptemporaryfileforyoinkingtheoriginalaudiobitrate.txt
set /a abr=abr / 1000
goto RETURNINTRO

:ERROR_file
echo Error: please drag a file onto this program to use it.
pause
exit