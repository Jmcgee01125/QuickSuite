@echo off

:: -------------------------------------

:: QuickExtract Version 1.0b

:: -------------------------------------

:: USAGE: Drag a video file onto this program to extract audio.

:: -------------------------------------

:: Settings

:: Output file type to be used. (Default: mp3)
set Filetype=mp3

:: -------------------------------------

:: Code

title QuickExtract

:: if the user didn't give a file, show an error
if [%1]==[] goto ERROR_file

:: get the name of the file for the output to match
set name=%~n1%

ffmpeg -i %1 -map 0:a "%name%_qe.%Filetype%"
exit

:ERROR_file
echo Error: Please drag a file onto this program to use it.
echo.
echo Opening the file to edit settings... (you can safely close this terminal).
start notepad.exe %0
pause
exit