@echo off

:: Options file to be used
:: That file is formatted as two lines with fps=XX and num=XX
set opsfile=quickconv_op.txt

:: Maximum bitrate for webm and mp4
:: Formatted as "20M" or "100K"
set mbr=20M

:: Source image file type
:: Use at your own "risk" as only pngs were tested, but this option is available
set filetype=png

:: -------------------------------------------

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

if "%sel%"=="1" (
ffmpeg -framerate %fps% -i %%0%num%d.%filetype% -vf format=yuv420p -c:v rawvideo output.avi
) else if "%sel%"=="2" (
ffmpeg -framerate %fps% -i %%0%num%d.%filetype% -vf format=yuv420p -c:v huffyuv output.avi
) else if "%sel%"=="4" (
ffmpeg -framerate %fps% -i %%0%num%d.%filetype% -vf format=yuv420p -b:v %mbr% -c:v libx264 output.mp4
) else if "%sel%"=="5" (
exit
) else (
ffmpeg -framerate %fps% -i %%0%num%d.%filetype% -vf format=yuv420p -b:v %mbr% -c:v vp9 output.webm
)

GOTO END

:GETVARSFROMFILE
(
set /p fps=
set /p num=
) < %opsfile%
set fps=%fps:~4%
set num=%num:~4%
echo Found options file %opsfile%
echo Framerate: %fps%
echo File nums: %num%

echo Would you like to use these settings? (Y (default) or N):
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
GOTO CONVERSION

:END