@echo off

:: -------------------------------------

:: QuickVolume Version 1.0c

:: -------------------------------------

:: USAGE: Drag a video file onto this program and type a percentage to change the volume

:: -------------------------------------

:: Code

title QuickAudio

:: if the user didn't give a file, show an error
if [%1]==[] goto ERROR_file

:: get user selection for audio
echo Type a percentage of audio (10%%, 125%%, etc.), but leave out the %% sign (e.g. 125), then press enter.
set /p volume=

:: change the audio level
:: ffmpeg -input filename -codec:video copy -filter:audio "volume=volumelevel" outputname
ffmpeg -fflags +igndts -i "%~f1" -c:v copy -filter:a "volume=%volume%/100" "%~n1_qv%~x1"
exit

:ERROR_file
echo Error: Please drag a file onto this program to use it.
echo.
pause
exit
