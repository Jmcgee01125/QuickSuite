
:: -------------------------------------

QuickNote Version 1.1

:: -------------------------------------

QuickNote is an easy way to make a note-taking file in a specific directory without having to manage save-as.

:: -------------------------------------

To prepare, set the variables for location and template in QuickNote.bat
	The default %USERPROFILE% points to C:\Users\<this user>\
	Location specifies where the resulting file will be saved.
	Template specifies the default file. This is usually a blank Word document, but can be any type (.odf, .txt, etc).
	Spaces in filenames are allowed, there simply aren't any in the default settings.

The output will be saved as <timestamp>.<extension> in the location folder.

To use, run any copy of QuickNote.bat from anywhere on your system. The note will be created and automatically opened.