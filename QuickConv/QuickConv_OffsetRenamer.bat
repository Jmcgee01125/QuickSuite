@echo off

:: -------------------------------------

:: QuickConv_OffsetRenamer Version 1.0

:: -------------------------------------

:: USAGE: Place this file into the folder containing your frames, and enter the offset you wish to have. Then, run this program.
::        !! REMOVE ANY OTHER FRAMES FROM THE FOLDER. IF YOUR FIRST FRAME IS 0124, REMOVE FRAMES 0001-0123 MANUALLY.

:: -------------------------------------

:: Settings

:: First frame 
set in=420

:: Last frame
set out=1337

:: Number of newframe in the frame number, such as 4 for 0125.png
set num=4

:: File extension, such as png in 1254.png
set ext=png

:: Prefix before frame number, such as "hello" in hello7123.png
set pre=

:: Postfix after frame number, such as "world" in 0024world.png
set end=

:: -------------------------------------

:: Code

title QuickConv Offset Renamer

setlocal EnableDelayedExpansion

set /a num-=1
set newframe=1

for /l %%x in (0, 1, %num%) do (
	set /a newframe=!newframe! * 10
)

set /a realframe=newframe + in - 1

for /l %%y in (%in%, 1, %out%) do (
	set /a newframe+=1
	set /a realframe+=1
	echo %pre%!realframe:~1!%end%.%ext% %pre%!newframe:~1!%end%.%ext%
	ren %pre%!realframe:~1!%end%.%ext% %pre%!newframe:~1!%end%.%ext%
)