@echo off

:: -------------------------------------

:: QuickConv Version 1.5

:: -------------------------------------

:: USAGE: Place this file into the folder that contains the images you wish to convert. Then, run this file.

:: -------------------------------------

:: Settings

:: Options file to be used (default: QuickConv_op.txt)
:: That file is formatted as two lines with fps=XX and num=XX
set opsfile=QuickConv_op.txt

:: Maximum bitrate for webm and mp4 (default: 20M)
:: Formatted as "20M" or "100K"
set mbr=20M

:: Audio bitrate (default: 196K)
set abr=196K

:: Source image file type (default: png)
set filetype=png

:: -------------------------------------

:: Code

title QuickConv

if exist "%opsfile%" (
	GOTO GETVARSFROMFILE
) else (
	GOTO GETVARSFROMINPUT
)

:CONVERSION
echo.
echo Please choose an output file format:
echo 1 - avi  (raw)
echo 2 - avi  (huffyuv)
echo 3 - webm (vp9)
echo 4 - mp4  (x264)
echo 5 - CANCEL OPERATION
echo Selection (default 4): 
set /p sel=

if "%sel%"=="1" (
	set bitrate=
	set codec=rawvideo
	set outtype=avi
) else if "%sel%"=="2" (
	set bitrate=
	set codec=huffyuv
	set outtype=avi
) else if "%sel%"=="3" (
	set bitrate=-b:v %mbr%
	set codec=vp9
	set outtype=webm
) else if "%sel%"=="5" (
	exit
) else (
	set bitrate=-b:v %mbr%
	set codec=libx264
	set outtype=mp4
)
:: ffmpeg -framerate fps -logsize -input filenamerangefromhell -input audiofile -videofilters format=colorspace motionblur=settings -r newfps -videobitrate -videocodec outputfile
ffmpeg -framerate %fps% -thread_queue_size 128K -i "%pre%%%0%num%d%end%.%filetype%" %aud% -filter:v "format=yuv420p%mbops%" %mbf% %bitrate% -c:v %codec% -b:a %abr% -shortest output.%outtype%
exit

:GETVARSFROMFILE
:: set the variables equal to the lines from the options file
(
	set /p fps=
	set /p num=
	set /p pre=
	set /p end=
	set /p aud=
	set /p mob=
	set /p mbf=
	set /p mfp=
) < %opsfile%
:: remove the beginning identifier from the setting
set fps=%fps:~4%
set num=%num:~4%
set pre=%pre:~4%
set end=%end:~4%
set aud=%aud:~4%
set mob=%mob:~4%
set mbf=%mbf:~4%
set mfp=%mfp:~4%
echo Found options file %opsfile%
echo Framerate: %fps%
echo File nums: %num%
echo Prefix:    %pre%
echo Postfix:   %end%
echo Audio src: %aud%
echo Do MoBlur: %mob%
echo MB_OutFPS: %mbf%
echo MB_FPBlur: %mfp%
:: audio input formatting conversion
if NOT [%aud%]==[] (
	set aud=-i %aud%
)
echo Would you like to use these settings? (Y/n):
set /p op=
if /I "%op%"=="n" (
	echo.
	GOTO GETVARSFROMINPUT
)
if /I "%mob%" NEQ "y" (
	set mbf=
	set mfp=
	GOTO CONVERSION
)
:: else not general, and yes it's directly below
GOTO CALCULATEMOTIONBLUR

:CALCULATEMOTIONBLUR
set /a tmixfps=fps / mfp
set mbops=, tmix=frames=%tmixfps%:weights=^'1^'
set mbf=-r %mbf%
GOTO CONVERSION

:GETVARSFROMINPUT
echo Enter source framerate:
set /p fps=
echo Enter digits in filename: 
set /p num=
echo Enter file prefix (if none, press enter):
set /p pre=
echo Enter file postfix (if none, press enter):
set /p end=
echo Enter audio file (if none, press enter):
set /p aud=
if NOT [%aud%]==[] (
	set aud=-i %aud%
)
echo Enable motion blur (y/N):
set /p mob=
if /I "%mob%"=="y" (
	echo Enter output framerate (can be equal to source framerate):
	set /p mbf=
	echo Enter frames per motion blur frame:
	set /p mfp=
	GOTO CALCULATEMOTIONBLUR
)
:: else not general
set mbf=
set mfp=
GOTO CONVERSION
