
:: -------------------------------------

QuickCompress Version 1.10c

:: -------------------------------------

QuickCompress is a quick and easy way to compress videos either below a filesize threshold or at a specified bitrate.

:: -------------------------------------

To use, drag the video file onto QuickCompress.bat.
	If UseSmartBitrate is 1, then the program will start immediately with the specified settings. If there's a problem, the user will get prompts.
	If UseSmartBitrate is 0, then the program will prompt the user to confirm a static bitrate before continuing.

You may also drag multiple videos onto QuickCompress at a time, and each video will be encoded separately.

The output will be saved as <source file>_qc.<type selection>

If the output is larger than the target, the program will attempt to re-encode with a more restrictive target.
	It will iterate this process multiple times, up to the value of the MaxAttempts variable.
	Some videos may still fail, in this case the program will display an error.
		Changing MaxAttempts to allow more attempts may solve the issue.
		However, changing TargetOutputSizeKB is recommended if this happens.

:: -------------------------------------

By opening QuickCompress.bat, sixteen variables become available:
	UseSmartBitrate - Automatically determines the bitrate to obtain a given file size (default: 1).
	TargetOutputSizeKB - The initial encoding target in KB, usually the same as MaxOutputSizeKB (default: 8192).
	MaxOutputSizeKB - The maximum size, in KB, of the output file. 8192 KB = 8 MB, the Discord file limit (default: 8192). 
	MaxAttempts - Number of times the program will attempt more restrictive bitrates before displaying a failure to hit size target (default: 3).
	WarnForLowDetailThresholdMP4 - If the bitrate is below this number when using mp4, warn the user. Prevents terrible quality output (default: 1024).
	WarnForLowDetailThresholdWebm - Same as above, but for automatic bitrate of Webm (default: 256).
	UseMaxFPS - Enables using a maximum framerate, frames beyond this will be discarded (default: 1).
	MaxFPS - If UseMaxFPS is enabled, this is the maximum framerate. Lower framerates are kept as-is (default: 30).
	UseMaxResolution - Enables using a maximum resolution, videos of a higher res will be shrunk (default: 1).
	MaxResHeight - The maximum pixel height of the video, aspect ratio is always preserved (default: 1080).
	mbr - Maximum bitrate used when UseSmartBitrate is disabled (default: 2000).
	abr - Audio bitrate used, enter "src" to preserve the original audio bitrate (default: src).
	UseWebm - Uses webm/VP9 instead of mp4/x264 by default. Takes longer to encode, but has superior compression at low bitrates (default: 0).
	          Useful if you're commonly encoding long videos and trying to fit it into a small filesize without giant compression blocks.
	          Note that you can still use webm on the fly if the bitrate is below WarnForLowDetailThresholdMP4
	UseNVENC - Uses the nvenc encoder on the GPU instead of a CPU encoder. MUCH faster, but not available for all systems (default: 1).
	           QuickCompress runs a check when starting if UseNVENC=1, to prevent an abnormal crash.
	UseMB - Applies a frameblended motionblur effect to the final output (default: 0).
	        This feature is automatically disabled during runtime if UseMaxResolution is enabled, as they are incompatible.
	MBFrames - If using motionblur, specifies the number of frames to blend (default: 2).
