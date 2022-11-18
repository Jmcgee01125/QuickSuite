 @echo off

:: -------------------------------------

:: QuickCombine Version 1.4

:: -------------------------------------

:: USAGE: Select all the files you want to combine, and drag them on top of this file.
::        You are responsible for making sure that all items are videos and have the same file extension.

:: -------------------------------------

:: Settings

:: The video extension to use (default: mp4)
:: This should match the extension of the files that you are combining.
set ext=mp4

:: -------------------------------------

:: Code

title QuickCombine

:: if the user didn't give a file, show an error
if [%1]==[] goto ERROR_file

:GETARGS
:: go go gadget what https://superuser.com/questions/901932/how-do-i-detect-the-number-of-parameters-to-a-batch-file-and-loop-through-them
setlocal enabledelayedexpansion
set argnum=0
set streamslabel=
for %%X in (%*) do (
	set streamslabel=!streamslabel![!argnum!:v][!argnum!:a]
	set /a argnum+=1
)

if !argnum! GTR 9 goto ERROR_toomanyarguments

:: print videos and their indexes for the user
:: could be combined with the above but separated for "readability"
for /l %%N in (1,1,%argnum%) do (
	call echo %%N - %%^~n%%N%%^~x%%N
)

:: get the user video order
set tempfilename=quickcombinetempfile_youmaydeletemewhenfinished.txt
if exist %tempfilename% del %tempfilename%
echo Please enter the number of which video should come first (then second, third, and so on).
echo Press enter after each number.
for /l %%N in (1,1,%argnum%) do (
	set /p cur=
	call echo file '%%^~n!cur!%%^~x!cur!'>> %tempfilename%
)

:COMBINE
ffmpeg -y -f concat -i %tempfilename% -c copy QuickCombine_output.%ext%
del %tempfilename%
pause
exit

:ERROR_file
echo Error: Please drag a file onto this program to use it.
echo Opening the file to edit settings... (you can safely close this terminal).
start notepad.exe %0
echo.
pause
exit

:ERROR_toomanyarguments
echo Error: Maximum number of files that can be concatenated is 9 (blame Microsoft's poor Batch arguments implementation).
echo.
pause
exit
