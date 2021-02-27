@echo off

:: -------------------------------------

:: QuickCompress Version 1.2b

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

:: Default audio bitrate (in Kb), used with or without smart bitrate.
:: To use source rate, set as "src" (default: 196)
set abr=196

:: Use webm (vp9) instead of mp4 (x264) (default: 0)
:: Not recommended for quick compressions, but can achieve higher detail at lower bitrates (sub 500K).
set UseWebm=0

:: -------------------------------------

:: Code

title QuickCompress

:: if the user didn't give a file, show an error
if [%1]==[] goto ERROR_file

:: get the name of the file for the output to match
set name=%~n1%

:: if using same audio bitrate, detect it
if "%abr%"=="src" goto FINDSRCABR

:RETURNINTRO
if %UseSmartBitrate%==1 goto SMARTMBRCALC

:: not using smart bitrate, so confirm that the settings are to the user's liking
echo Using video bitrate %mbr%K
echo Using audio bitrate %abr%K
echo Would you like to use these settings? (Y/n):
set /p op=
if /I "%op%"=="n" goto CHANGESET

:COMPRESS
if %UseWebm%==1 goto :WEBMCOMPRESS
:: ffmpeg -input filename -bitrate:video mbr -bitrate:audio abr -codec:video x264 outputname
ffmpeg -i "%~f1" -b:v %mbr%K -b:a %abr%K -c:v libx264 "%name%_qc.mp4"
exit

:WEBMCOMPRESS
:: ffmpeg -input filename -bitrate:video mbr -bitrate:audio abr -codec:video vp9 outputname
ffmpeg -i "%~f1" -b:v %mbr%K -b:a %abr%K -c:v vp9 "%name%_qc.webm"
exit

:SMARTMBRCALC
:: get the video duration in seconds
:: go go gadget copy paste - https://stackoverflow.com/questions/32344947/ffmpeg-batch-extracting-media-duration-and-writing-to-a-text-file
for /f "tokens=2 delims==" %%a in ('ffprobe "%~f1" -show_entries format^=duration -v quiet -of compact') do (
	set dur=%%a
)
:: get the kilobit size from kilobytes size
set /a targetkbit=%TargetOutputSizeKB% * 8
:: kb/s formula to get average bitrate to use
set /a mbr=%targetkbit% / dur
:: reduce the size based on the codec overhead and audio bitrate allowance
if %UseWebm%==1 (
	set /a buffer=mbr / 3
) else (
	set /a buffer=mbr / 12
)
set /a mbr=mbr - abr - buffer

if %mbr% LEQ %WarnForLowDetailThreshold% goto CONFIRMLOWDETAIL
goto COMPRESS

:CONFIRMLOWDETAIL
echo Warning: Video bitrate is very low (^< %WarnForLowDetailThreshold% Kbps).
echo This will drastically affect the video quality.
echo Do you wish to continue? (Y/n):
set /p cont=
if /I "%cont%"=="n" exit
goto COMPRESS

:CHANGESET
echo Please type a video bitrate, in Kb (omit Kb):
set /p mbr=
echo Please type an audio bitrate, in Kb (omit Kb):
set /p abr=
goto COMPRESS

:FINDSRCABR
:: get source bitrate from the provided file by sending it to a temporary file. Thanks batch
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