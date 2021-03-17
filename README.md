# QuickSuite

A collection of batch tools to do various menial tasks quickly.

:: ------------------------------------- :: 
CURRENT TOOLS 
:: ------------------------------------- ::

QuickConv: converts a series of images (0001.png, 0002.png, etc) into a video file, with support for audio and frameblend motionblur.

QuickCompress: automatically compresses a video below a certain size, which is useful for sending videos on size-restricted platforms like Discord.

QuickNote: allows creating a note-taking file in an arbitrary directory from anywhere on the computer without having to save-as.

QuickTrim: trims a video based on user-selected timestamps.

:: ------------------------------------- :: 
FFMPEG NOTE 
:: ------------------------------------- ::

!! YOU MUST INSTALL FFMPEG TO USE QUICKCONV AND QUICKCOMPRESS

You can download FFmpeg from https://www.wikihow.com/Install-FFmpeg-on-Windows (directs to https://ffmpeg.org/download.html).

Make sure to add it to your system's PATH variable. The guide covers this as well, or you can go edit environment variables yourself.


I've also included ffmpeg.exe (Version 2021-2-20) in the repo. You can download that as well if you're not comfortable with editing PATH.

If using this ffmpeg.exe, it will need to be in the SAME DIRECTORY as any batch file using it. This does not apply for the full installation.

:: ------------------------------------- :: 
VARIABLE USAGE NOTE 
:: ------------------------------------- ::

All of these programs contain variables inside the batch files themselves. You may need to change these for the program to work properly.

To edit those variables, right click the program in your file browser and select "edit" from the menu.

Variables to change are at the top of the file (under the "Settings" section), and have a short description of their use.

If a file is not working correctly for you (fails to do its job or crashes instantly), this is the most likely cause of issues.

:: ------------------------------------- :: 
LICENSING 
:: ------------------------------------- ::

I am releasing my files under the MIT License as described in the LICENSE.md file.

FFmpeg, however, is licensed under GNU LGPL 2.1, as I am not its original creator (unsurprisingly).
