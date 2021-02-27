@echo off

:: -------------------------------------

:: QuickNote Version 1.1

:: -------------------------------------

:: USAGE: Set the location and template variables below.
::        To create a note, run QuickNote.bat from anywhere on the machine.

:: -------------------------------------

:: Settings

:: Location that the new documents will be created
set location=%USERPROFILE%\Downloads\QuickNotes

:: Template document that will be copied from, should be AT LEAST a blank document, but may contain text
set template=%USERPROFILE%\Downloads\QuickNotes\00_TEMPLATE.docx

:: -------------------------------------

:: Code

title QuickNote

:: create timestamp in the form MM-DD-YYYY_HHhMMmSSs
if "%time:~0,1%"==" " (set timestamp=%date:~-10,2%"-"%date:~-7,2%"-"%date:~-4,4%"_0"%time:~1,1%"h"%time:~3,2%"m"%time:~6,2%"s") else (set timestamp=%date:~-10,2%"-"%date:~-7,2%"-"%date:~-4,4%"_"%time:~0,2%"h"%time:~3,2%"m"%time:~6,2%"s")

:: create the new file, preserving the extension
for %%i in (%template%) do set extension="%%~xi"
set newfile=%location%\%timestamp%%extension%

:: copy the template as the new filename
xcopy "%template%" "%newfile%*" /q

:: open the default editor for this file type
:: you cannot specify a custom editor because batch is weird
start " " "%newfile%"