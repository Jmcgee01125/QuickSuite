@echo off

:: -------------------------------------

:: QuickVolume Version 1.0d

:: -------------------------------------

:: USAGE: Drag a video file onto this program and type a percentage to change the volume

:: -------------------------------------

:: Settings

:: If set (not blank), use this as the audio bitrate in Kbps. (Default: )
set abr=

:: -------------------------------------

:: Code

title QuickAudio

:: if the user didn't give a file, show an error
if [%1]==[] goto ERROR_file

:: get user selection for audio
echo Type a percentage of audio (10%%, 125%%, etc.), but leave out the %% sign (e.g. 125), then press enter.
set /p volume=

:: get the source audio bitrate
if [%abr%] NEQ [] set abr=-b:a %abr%K

:: change the audio level
ffmpeg -i "%~f1" -c:v copy -filter:a "volume=%volume%/100" %abr% "%~n1_qv%~x1"
exit

:ERROR_file
echo Error: Please drag a file onto this program to use it.
echo Opening the file to edit settings... (you can safely close this terminal).
start notepad.exe %0
echo.
pause
exit
