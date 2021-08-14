@echo off

:: -------------------------------------

:: QuickCombine Version 1.0

:: -------------------------------------

:: USAGE: Select all the files you want to combine, and drag them on top of this .bat
::		  You are responsible for making sure that all items are videos.

:: -------------------------------------

:: Settings

:: Use nvenc (GPU mp4/h264) instead of CPU (default: 1)
:: Can be faster than a CPU encode, but might not be supported on all systems.
:: Can still be enabled if not present, will simply turn itself back off after a check. Best to leave this on unless the check causes issues.
set UseNVENC=1

:: The video extension to use (default: mp4)
:: If you set this to anything else, you MUST disable UseNVENC.
set ext=mp4

:: -------------------------------------

:: Code

title QuickCombine

:: if the user didn't give a file, show an error
if [%1]==[] goto ERROR_file


if %UseNVENC%==1 goto CHECKNVENC
:RETURNINTRO_NVENC

:GETARGS
:: go go gadget what https://superuser.com/questions/901932/how-do-i-detect-the-number-of-parameters-to-a-batch-file-and-loop-through-them
setlocal enabledelayedexpansion
set argnum=0
set streamslabel=
for %%X in (%*) do (
	set streamslabel=!streamslabel![!argnum!:v][!argnum!:a]
	set /a argnum+=1
)

:: print videos and their indexes for the user
:: could be combined with the above but separated for readability
for /l %%N in (1,1,%argnum%) do (
	call echo %%N - %%^~n%%N%%^~x%%N
)

:: get the user video order
set vidargs=
echo Please enter the number of which video should come first (then second, third, and so on).
echo Press enter after each number.
for /l %%N in (1,1,%argnum%) do (
	set /p cur=
	call set vidargs=!vidargs! -i %%!cur!
)

:COMBINE
:: If using NVENC, specify it. Otherwise, will let ffmpeg decide
if %UseNVENC%==1 set codec=-c:v h264_nvenc
:: go go gadget how does ffmpeg work https://blog.feurious.com/concatenate-videos-together-using-ffmpeg
:: ffmpeg -i file1 -i file2 <continues per file> -filter_complex "[0:v][0:a][1:v][1:a]<continues per file> concat=n=<filecount>:v=1:a=1 [outv] [outa]" -map "[outv]" -map "[outa]" -c:v <encoding codec> <filename>.<extension>
ffmpeg -y %vidargs% -filter_complex "%streamslabel% concat=n=%argnum%:v=1:a=1 [outv] [outa]" -map "[outv]" -map "[outa]" %codec% QuickCombine_output.%ext%
exit

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
cls
goto RETURNINTRO_NVENC

:ERROR_file
echo Error: please drag a file onto this program to use it.
pause
exit
