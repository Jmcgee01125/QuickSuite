@echo off

:: -------------------------------------

:: QuickCompress Version 1.2d

:: -------------------------------------

:: USAGE: Simply drag and drop the file you want to convert on top of this .bat

:: -------------------------------------

:: Settings

:: Automatically determines maximum bitrate based on the target output size in KB (defaults: 1, 8000, 512, 256)
:: Note that there are some scenarios where the file still exceeds the target. In this case, try reducing target output size.
:: To disable, set UseSmartBitrate to 0
set UseSmartBitrate=1
set TargetOutputSizeKB=8000
set WarnForLowDetailThresholdMP4=512
set WarnForLowDetailThresholdWebm=256

:: Default maximum bitrate (in Kb), if not using smart bitrate (default: 2000)
set mbr=2000

:: Default audio bitrate (in Kb), used with or without smart bitrate. Recommended no more than 196 for most uses.
:: To use source rate, set as "src" (default: src)
set abr=src

:: Use webm (vp9) instead of mp4 (x264) (default: 0)
:: Not recommended for quick compressions, but can achieve higher detail at lower bitrates.
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
if %UseWebm%==1 goto WEBMCOMPRESS
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

if %mbr% LEQ 0 goto ERROR_bitratetoolow

if %mbr% LEQ %WarnForLowDetailThresholdMP4% if %UseWebm%==0 goto CONFIRMLOWDETAIL
if %mbr% LEQ %WarnForLowDetailThresholdWebm% if %UseWebm%==1 goto CONFIRMLOWDETAILWEBM
goto COMPRESS

:CONFIRMLOWDETAIL
echo Warning: MP4 video bitrate is very low (%mbr% ^< %WarnForLowDetailThresholdMP4% Kbps).
echo This will drastically affect the video quality.
echo Do you wish to continue with mp4 (m), switch to webm (w), or cancel (c)? (m/W/c):
set /p cont=
if /I "%cont%"=="m" goto COMPRESS
if /I "%cont%"=="c" exit
set UseWebm=1
goto SMARTMBRCALC

:CONFIRMLOWDETAILWEBM
echo Warning: Webm video bitrate is very low (%mbr% ^< %WarnForLowDetailThresholdWebm% Kbps).
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

:: if the bitrate is below zero then ffmpeg crashes, so it should be handled
:ERROR_bitratetoolow
echo The calculated bitrate necessary to get the video under the target size is less than 0 (%mbr%).
echo It is impossible to compress at this bitrate (because there would be no video, of course).
echo You can remedy this by reducing the length of your file or taking one of the actions below:
if %UseWebm%==0 goto ERR_btlmp4
if %UseWebm%==1 goto ERR_btlwebm
:ERR_btlwebm
echo a - Set a custom audio bitrate (currently %abr%)
echo v - Use static video bitrate (may exceed target size)
echo m - Switch to mp4
echo c - Cancel
echo (a/v/M/c):
set /p sel=
if /I "%sel%"=="a" goto ERR_btlcustomaudio
if /I "%sel%"=="v" goto ERR_btlcustomvideo
if /I "%sel%"=="c" exit
set UseWebm=0
GOTO SMARTMBRCALC
:: currently assumes that mp4 is always smaller than webm. This is generally true, but in some circumstances it isn't
:ERR_btlmp4
echo a - Set a custom audio bitrate (currently %abr%)
echo v - Use static video bitrate (may exceed target size)
echo c - Cancel
echo (a/v/C):
set /p sel=
if /I "%sel%"=="a" goto ERR_btlcustomaudio
if /I "%sel%"=="v" goto ERR_btlcustomvideo
exit
:ERR_btlcustomaudio
echo Please enter custom audio bitrate (in Kbps):
set /p abr=
goto SMARTMBRCALC
:ERR_btlcustomvideo
echo Please enter a static video bitrate (in Kbps):
set /p mbr=
goto COMPRESS

:ERROR_file
echo Error: please drag a file onto this program to use it.
pause
exit