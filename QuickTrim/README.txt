
:: -------------------------------------

QuickTrim Version 1.1

:: -------------------------------------

QuickTrim allows easily cutting off the beginning or end of a video without recompressing it.

:: -------------------------------------

To use, drag the video file onto QuickTrim.bat.

You may notice that your videos have a short bit of freezing at the beginning. This is caused by removing a video keyframe at the beginning of the trim.
	To "fix," open the file and set the Reencode variable to 1. The trim will take a lot longer, but will no longer freeze.
	Unfortunately this cannot be fixed without reencoding the video. You could also try finding a point just before the keyframe to reduce the impact.

The output will be saved as <source file>_qt.<source extension>

:: -------------------------------------

By opening QuickTrim.bat, three variables become available:
	UseManualInput - A more advanced version of the input that allows manually entering hh:mm:ss.ms arguments (default: 0).
	Reencode - Fixes the video freezing issue by rencoding the video, generating new keyframes (default: 0).
	ReencodeCodec - The codec to use when reencoding. Make sure this codec is compatible with your source file type (default: libx264).