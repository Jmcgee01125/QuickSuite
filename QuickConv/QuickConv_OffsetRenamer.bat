@echo off

:: -------------------------------------

:: QuickConv_OffsetRenamer Version 1.0

:: -------------------------------------

:: USAGE: Place this file into the folder containing your frames, and enter the offset you wish to have. Then, run this program.
::        !! REMOVE ANY OTHER FRAMES FROM THE FOLDER. IF YOUR FIRST FRAME IS 0124, REMOVE FRAMES 0001-0123 MANUALLY.

:: -------------------------------------

:: Settings

:: First frame 
set in=10

:: Last frame
set out=14

:: Number of digits in the frame number, such as 4 for 0125.png
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
set suffering=1

for /l %%x in (0, 1, %num%) do (
	set /a suffering=!suffering! * 10
)

set /a pain=suffering + in - 1

for /l %%y in (%in%, 1, %out%) do (
	set /a suffering+=1
	set /a pain+=1
	echo %pre%!pain:~1!%end%.%ext% %pre%!suffering:~1!%end%.%ext%
	ren %pre%!pain:~1!%end%.%ext% %pre%!suffering:~1!%end%.%ext%
)