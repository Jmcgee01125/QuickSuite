# QuickSuite

A collection of batch tools to do various menial tasks quickly.

:: ------------------------------------- :: 
CURRENT TOOLS 
:: ------------------------------------- ::

QuickConv: converts a series of images (0001.png, 0002.png, etc) into a video file, with support for audio and frameblend motionblur.

QuickCompress: automatically compresses a video below a certain size, which is useful for sending videos on size-restricted platforms like Discord.

QuickNote: allows creating a note-taking file in an arbitrary directory from anywhere on the computer without having to save-as.

:: ------------------------------------- :: 
FFMPEG NOTE 
:: ------------------------------------- ::

!! YOU MUST INSTALL FFMPEG TO USE QUICKCONV AND QUICKCOMPRESS

You can download FFmpeg from https://www.wikihow.com/Install-FFmpeg-on-Windows (directs to https://ffmpeg.org/download.html).

Make sure to add it to your system's PATH variable. The guide covers this as well, or you can go edit environment variables yourself.


I've also included ffmpeg.exe (Version 2021-2-20) in the repo. You can download that as well if you're not comfortable with editing PATH.

ffmpeg.exe will need to be in the SAME DIRECTORY as any batch file using it. Otherwise, it won't work.

:: ------------------------------------- :: 
LICENSING 
:: ------------------------------------- ::

I am releasing my files under the MIT License as described in the LICENSE.md file.

FFmpeg, however, is licensed under GNU LGPL 2.1, as I am not its original creator (unsurprisingly).
