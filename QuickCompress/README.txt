
:: -------------------------------------

QuickCompress Version 1.2c

:: -------------------------------------

QuickCompress is a quick and easy way to compress videos either below a filesize threshold or at a specified bitrate.

:: -------------------------------------

To use, drag the video file onto QuickCompress.bat.
	If UseSmartBitrate is 1, then the program will start immediately with the specified settings. If there's a problem, the user will get prompts.
		Once ffmpeg starts encoding, don't worry. As far as I know, no errors can occur at this point barring a crash. It will finish on its own.
	If UseSmartBitrate is 0, then the program will prompt the user to confirm a static bitrate before continuing

The output will be saved as <source file>_qc.<type selection>

:: -------------------------------------

By opening QuickCompress.bat, seven variables become available:
	UseSmartBitrate - Automatically determines the bitrate to obtain a given file size (default: 1).
	TargetOutputSizeKB - The size, in KB (not Kb), of the output file. 8000 = 8 MB, the Discord file limit (default: 8000).
	WarnForLowDetailThresholdMP4 - If the bitrate is below this number when using mp4, warn the user. Prevents terrible quality output (default: 512).
	WarnForLowDetailThresholdWebm - Same as above, but for automatic bitrate of Webm (default: 256).
	mbr - Maximum bitrate used when UseSmartBitrate is disabled (default: 2000).
	abr - Audio bitrate used, enter "src" to preserve the original audio bitrate (default: 196).
	UseWebm - Uses webm/VP9 instead of mp4/x264 by default. Takes longer to encode, but has superior compression at low bitrates (default: 0).
		Useful if you're commonly encoding long videos and trying to fit it into a small filesize without giant compression blocks.
		Note that you can still use webm on the fly if the bitrate is below WarnForLowDetailThresholdMP4