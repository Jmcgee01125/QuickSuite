@echo off

:: -------------------------------------

:: QuickConv Version 1.4

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

:: Source image file type (default: png)
:: Use at your own "risk" as only pngs were tested, but this option is available
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
echo Selection (default 3): 
set /p sel=

:: ffmpeg -framerate fps -input filenamerangefromhell -videoformat format=colorspace -codec:video <codec> outputfile
if "%sel%"=="1" (
ffmpeg -framerate %fps% -i "%pre%%%0%num%d%end%.%filetype%" -vf format=yuv420p -c:v rawvideo output.avi
) else if "%sel%"=="2" (
ffmpeg -framerate %fps% -i "%pre%%%0%num%d%end%.%filetype%" -vf format=yuv420p -c:v huffyuv output.avi
) else if "%sel%"=="4" (
ffmpeg -framerate %fps% -i "%pre%%%0%num%d%end%.%filetype%" -vf format=yuv420p -b:v %mbr% -c:v libx264 output.mp4
) else if "%sel%"=="5" (
exit
) else (
ffmpeg -framerate %fps% -i "%pre%%%0%num%d%end%.%filetype%" -vf format=yuv420p -b:v %mbr% -c:v vp9 output.webm
)
exit

:GETVARSFROMFILE
:: set the variables equal to the lines from the options file
(
set /p fps=
set /p num=
set /p pre=
set /p end=
) < %opsfile%
:: remove the beginning identifier from the setting
set fps=%fps:~4%
set num=%num:~4%
set pre=%pre:~4%
set end=%end:~4%
echo Found options file %opsfile%
echo Framerate: %fps%
echo File nums: %num%
echo Prefix:    %pre%
echo Postfix:   %end%

echo Would you like to use these settings? (Y/n):
set /p op=
if /I "%op%"=="n" (
echo.
GOTO GETVARSFROMINPUT
)
GOTO CONVERSION

:GETVARSFROMINPUT
echo Enter framerate:
set /p fps=
echo Enter digits in filename: 
set /p num=
echo Enter file prefix (if none, press enter):
set /p pre=
echo Enter file postfix (if none, press enter):
set /p end=
GOTO CONVERSION