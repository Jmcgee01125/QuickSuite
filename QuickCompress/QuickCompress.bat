@echo off

:: -------------------------------------

:: QuickCompress Version 1.10b

:: -------------------------------------

:: USAGE: Simply drag and drop the file you want to compress on top of this .bat

:: -------------------------------------

:: Settings

:: Automatically determines maximum bitrate based on the target output size in KB. (defaults: 1, 8192, 8192, 3, 1024, 256)
:: MaxOutputSizeKB is the maximum allowed size of the output.
:: MaxOutputSizeKB should ALWAYS be greater than or equal to TargetOutputSizeKB.
:: TargetOutputSizeKB is the initial encoding target, usually the same as MaxOutputSizeKB.
::     If the encoded video is over MaxOutputSizeKB, then TargetOutputSize is decreased and encoding is reattempted.
:: MaxAttempts is the number of times to attempt recompressing if the file exceeds the target size.
:: To disable, set UseSmartBitrate to 0
set UseSmartBitrate=1
set MaxOutputSizeKB=8192
set TargetOutputSizeKB=8192
set MaxAttempts=3
set WarnForLowDetailThresholdMP4=1024
set WarnForLowDetailThresholdWebm=256

:: Have a maximum framerate on the output.
:: Videos with a framerate lower than this value will use their original FPS. (defaults: 1, 30)
set UseMaxFPS=1
set MaxFPS=30

:: Enable changing the resolution to whatever value is set if the source is higher.
:: Useful for when you're commonly encoding 4k videos and want it to be smaller.
:: Very low resolutions may cause certain videos to fail. Treat this as a maximum, not a compression technique.
:: Note that this is the video pixel HEIGHT (the 1080 in 1920x1080), the aspect ratio is always preserved. (defaults: 1, 1080)
set UseMaxResolution=1
set MaxResHeight=1080

:: Default maximum bitrate (in Kb), if not using smart bitrate. (default: 2000)
set mbr=2000

:: Default audio bitrate (in Kb), used with or without smart bitrate. Recommended no more than 196 for most uses.
:: Original audio is preserved for mp4, but webm will automatically remux. It will sound effectively identical.
:: To use source rate, set as "src" (default: src)
set abr=src

:: Use webm (vp9) instead of mp4 (x264). (default: 0)
:: Not recommended for quick compressions, but can achieve higher detail at lower bitrates.
:: Has a higher priority than NVENC, if both are enabled.
set UseWebm=0

:: Use nvenc (GPU mp4/h264) instead of CPU. (default: 1)
:: Can be faster than a CPU encode, but might not be supported on all systems.
:: Can still be enabled if not present, will simply turn itself back off after a check. Best to leave this on unless the check causes issues.
set UseNVENC=1

:: Enables a motion blur effect created by blending frames around the current frame.
:: THIS IS NOT COMPATIBLE WITH UseMaxResolution! Enabling both will disable motion blur. (defaults: 0, 2)
set UseMB=0
set MBFrames=2

:: -------------------------------------

:: Code

title QuickCompress

:: if the user didn't give a file, show an error
if [%1]==[] goto ERROR_file

:: if there are multiple files, call quickcompress copies to compress those in parallel, then kill this one
if [%2] NEQ [] goto BECOMEMASTER

:: get the name of the file for the output to match
set name=%~n1

:: if the original file size is below the target, why encode?
if %UseSmartBitrate%==1 goto CONFIRMORIGINALSIZE
:RETURNINTRO_COS

:: set up encoding failure variable
set failcount=0

:: if using same audio bitrate, detect it
set srcaud=0
if "%abr%"=="src" goto FINDSRCABR
:RETURNINTRO_ABR

if %UseNVENC%==1 goto CHECKNVENC
:RETURNINTRO_NVENC

:: get the source FPS
:: go go gadget copy paste https://stackoverflow.com/questions/27792934/get-video-fps-using-ffprobe
:: ffmpeg returns a precise fraction (like 30000/1001), so we do some math
for /f "usebackq delims=" %%a in (`ffprobe -v error -select_streams v -of default^=noprint_wrappers^=1:nokey^=1 -show_entries stream^=avg_frame_rate "%~f1"`) do set /a fps=%%a
:: if the source FPS is higher than the maximum allowed FPS, reduce it
if %UseMaxFPS%==1 (if %fps% GTR %MaxFPS% set fps=%MaxFPS%)

:: get the source resolution
for /f "usebackq delims=" %%a in (`ffprobe -v error -select_streams v:0 -show_entries stream^=height -of default^=noprint_wrappers^=1:nokey^=1 "%~f1"`) do set height=%%a
:: if the source FPS is higher than the maximum allowed FPS, reduce it
if %UseMaxResolution%==1 ( if %height% GTR %MaxResHeight% set height=%MaxResHeight% )

if %UseSmartBitrate%==1 goto SMARTMBRCALC
:: not using smart bitrate, so confirm that the settings are to the user's liking
echo Using video bitrate %mbr%K
echo Using audio bitrate %abr%K
choice /c YN /m "Would you like to use these settings"
if %errorlevel%==2 goto CHANGESET

:COMPRESS
:: the following two options are mutually exclusive, and max res will overwrite motion blur settings
:: video filter "pixel format, frame mix=count=frame weighting"
if %UseMB%==1 ( set filterops=-filter_complex ^"format=yuv420p, tmix=frames=%MBFrames%:weights=^'1^'^" )
:: video filter "resolution = keep aspect ratio : pixel height"
if %UseMaxResolution%==1 ( set filterops=-filter_complex ^"scale=-1:%height%^" )
set codec=libx264
set extension=mp4
set audcom=-b:a %abr%K
if %srcaud%==1 ( set audcom=-c:a copy )
if %UseWebm%==1 (
	set codec=vp9
	set extension=webm
	:: webm has an issue with certain audio codecs, best to just remux
	set audcom=-b:a %abr%K
) else ( if %UseNVENC%==1 set codec=h264_nvenc )
:: ffmpeg -overwrite -input filename -bitrate:video mbr (-bitrate:audio abr or -codec:audio copy) (filterops) -codec:video codec -framerate fps outputname
ffmpeg -y -i "%~f1" -b:v %mbr%K %audcom% %filterops% -c:v %codec% -r %fps% "%name%_qc.%extension%"
if %UseSmartBitrate%==1 goto CHECKOUTPUTSIZE
pause
exit

:CHECKOUTPUTSIZE
:: go go gadget copy paste - https://stackoverflow.com/questions/1199645/how-can-i-check-the-size-of-a-file-in-a-windows-batch-script
for /f "tokens=*" %%A in ("%name%_qc.%extension%") do set bsize=%%~zA
set /a kbsize=bsize / 1024
if %kbsize% GTR %MaxOutputSizeKB% goto ERR_largeoutput
exit

:CONFIRMORIGINALSIZE
:: if the filesize is already below the max, don't encode
set bsize=%~z1
set /a kbsize=bsize / 1024
if %kbsize% GTR %MaxOutputSizeKB% goto RETURNINTRO_COS
echo Original file is already below the maximum output size of %MaxOutputSizeKB% KB
echo If you meant to re-encode this video, right click QuickCompress, select edit, and turn off UseSmartBitrate.
echo.
pause
exit

:SMARTMBRCALC
:: get the video duration in seconds
:: go go gadget copy paste - https://stackoverflow.com/questions/32344947/ffmpeg-batch-extracting-media-duration-and-writing-to-a-text-file
for /f "tokens=2 delims==" %%a in ('ffprobe "%~f1" -show_entries format^=duration -v quiet -of compact') do set dur=%%a
:: get the kilobit size from kilobytes size
set /a targetkbit=%TargetOutputSizeKB% * 8
:: kb/s formula to get average bitrate to use
set /a mbr=%targetkbit% / dur
:: reduce the size based on the codec overhead and audio bitrate allowance
if %UseWebm%==1 (
	set /a buffer=mbr / 3
) else (
	if %UseNVENC%==1 (
		set /a buffer=mbr / 8
	) else ( set /a buffer=mbr / 12 )
)
set /a mbr=mbr - abr - buffer

if %mbr% LEQ 0 goto ERROR_bitratetoolow

if %mbr% LEQ %WarnForLowDetailThresholdMP4% if %UseWebm%==0 goto CONFIRMLOWDETAIL
if %mbr% LEQ %WarnForLowDetailThresholdWebm% if %UseWebm%==1 goto CONFIRMLOWDETAILWEBM
goto COMPRESS

:CONFIRMLOWDETAIL
:: also used for nvenc
echo Warning: MP4 video bitrate is very low (%mbr% ^<= %WarnForLowDetailThresholdMP4% Kbps).
echo This will drastically affect the video quality.
choice /c WMC /m "Do you wish to switch to webm (w), continue with mp4 (m), or cancel (c)"
if %errorlevel%==3 exit
if %errorlevel%==2 goto COMPRESS
set UseWebm=1
goto SMARTMBRCALC

:CONFIRMLOWDETAILWEBM
echo Warning: Webm video bitrate is very low (%mbr% ^<= %WarnForLowDetailThresholdWebm% Kbps).
echo This will drastically affect the video quality.
choice /c YN /m "Do you wish to continue"
if %errorlevel%==2 exit
goto COMPRESS

:CHANGESET
echo Please type a video bitrate, in Kb (omit Kb):
set /p mbr=
echo Please type an audio bitrate, in Kb (omit Kb):
set /p abr=
goto COMPRESS

:FINDSRCABR
set srcaud=1
:: get source bitrate from the provided file by sending it to a temporary file. Thanks batch
:: go go gadget copy paste again - https://superuser.com/questions/1541235/how-can-i-get-the-audio-bitrate-from-a-video-file-using-ffprobe
for /f "usebackq delims=" %%a in (`ffprobe -v 0 -select_streams a:0 -show_entries stream^=bit_rate -of compact^=p^=0:nk^=1 "%~f1"`) do set abr=%%a
set /a abr=abr / 1000
goto RETURNINTRO_ABR

:CHECKNVENC
:: print status message due to potential lag if it's a really slow cpu
echo Checking for nvenc support...
:: loop over the ffmpeg build config and check for an occurrance of nvenc support
set found=0
for /f "delims=" %%a in ('ffmpeg -buildconf') do (
	if "%%a"=="    --enable-nvenc" (set found=1)
)
:: no you can't have nvenc you have baby gpu
if %found%==0 set UseNVENC=0
goto RETURNINTRO_NVENC

:: if multiple arguments were passed, make quickcompress threads for them
:: note that these threads MUST be closed with exit to kill their console, do not just let the batch file end
:BECOMEMASTER
echo Multiple arguments detected!
echo Creating a separate job for each video...
setlocal enabledelayedexpansion
for %%a in (%*) do (
	:: wait a bit between each due to an out of memory crash (even if enough memory is available -_-)
	timeout /t 2 /nobreak >NUL
	start QuickCompress.bat %%a
	
)
:: kill this thread since we just made a new one to run on %1
exit

:: if the bitrate is below zero then ffmpeg crashes (very surprising!), so it should be handled
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
choice /c AVMC /m "Make a selection"
if %errorlevel%==4 exit
if %errorlevel%==3 (
	set UseWebm=0
	GOTO SMARTMBRCALC
)
if %errorlevel%==2 goto ERR_btlcustomvideo
goto ERR_btlcustomaudio

:: currently assumes that mp4 is always smaller than webm. This is generally true, but in some circumstances it isn't
:: nvenc is disabled at this stage due to buffer sizing
:ERR_btlmp4
set UseNVENC=0
echo a - Set a custom audio bitrate (currently %abr%)
echo v - Use static video bitrate (may exceed target size)
echo c - Cancel
choice /c AVC /m "Make a selection"
if %errorlevel%==3 exit
if %errorlevel%==2 goto ERR_btlcustomvideo
goto ERR_btlcustomaudio

:: output size exceeded, so retry encoding until we hit max failures
:ERR_largeoutput
set /a MaxAttempts=MaxAttempts - 1
if %MaxAttempts% EQU 0 goto ERR_largeoutcancel
cls
echo Failed to encode: target output size exceeded.
echo Attempting to encode at a lower threshold...
:: reduce the target size by half the amount we were over the threshold, plus a bit more
set /a TargetOutputSizeKB=(TargetOutputSizeKB - kbsize - 50) / 2 + TargetOutputSizeKB
echo New target: %TargetOutputSizeKB%
goto :SMARTMBRCALC

:ERR_largeoutcancel
cls
echo Could not encode to target size within allotted attempts. Job cancelled.
echo Increasing the MaxAttempts or lowering the TargetOutputSizeKB variables could allow this job to succeed.
echo Final pass was %kbsize% KB with a maximum of %MaxOutputSizeKB% KB (last encoding target: %TargetOutputSizeKB% KB)
echo.
pause
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
echo If you meant to edit this file to change settings, right click it then select edit.
echo.
pause
exit