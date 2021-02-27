
:: -------------------------------------

QuickCompress Version 1.2b

:: -------------------------------------

QuickCompress is a quick and easy way to compress videos either below a filesize threshold or at a specified bitrate.

:: -------------------------------------

To use, drag the video file onto QuickCompress.bat.
	If UseSmartBitrate is 1, then the program will start immediately with the specified settings.
	If UseSmartBitrate is 0, then the program will prompt the user to confirm a static bitrate before continuing

The output will be saved as <source file>_qc.<type selection>

:: -------------------------------------

By opening QuickCompress.bat, six variables become available:
	UseSmartBitrate - Automatically determines the bitrate to obtain a given file size (default: 1).
	TargetOutputSizeKB - The size, in KB (not Kb), of the output file. 8000 = 8 MB, the Discord file limit (default: 8000).
	WarnForLowDetailThreshold - If the bitrate is below this number, warn before continuing. This is to prevent atrocious detail (default: 512).
		If you're running into issues with low detail, try setting UseWebm to 1.
	mbr - Maximum bitrate used when UseSmartBitrate is disabled (default: 2000).
	abr - Audio bitrate used, enter "src" to preserve the original audio bitrate (default: 196).
	UseWebm - Uses the webm/VP9 codec instead of mp4/x264. Takes longer to encode, but has superior compression at low bitrates (default: 0).
		Useful if you're encoding long videos and trying to fit it into a small filesize without giant compression blocks.