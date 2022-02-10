
:: -------------------------------------

QuickConv Version 1.6b

:: -------------------------------------

QuickConv is a fast and easy way to convert files from a series of images (0001.png, 0002.png, etc) to an actual video file.

:: -------------------------------------

To use, leave QuickConv.bat and QuickConv_op.txt in the same folder as your images, then run QuickConv.bat.
	Make sure no other images follow the same naming structure or the program may behave unexpectedly.
	QuickConv_op.txt is responsible for setting user defaults, but it is not required for the program to work.

Images must have a static filename length, so 1..100 is not allowed but 001..100 is.

To render only a portion of the video, remove the frames outside of the range. QuickConv.bat works fine if the first image is, for example, 0005.png.
	Note that you must still have a continuous range of frames. The program will stop once there is no next frame.
	There seems to be some limit to how far in you can start, but I can't narrow it down. I was unable to render beginning at frame 112 in one circumstance.
		As a remedy, run QuickConv_OffsetRenamer.bat to shift all frames down to start at frame 1. 

The input is formatted as <pre><frame number><end>.<extension>
	Spaces are allowed in pre and end.

The output will be saved as output.<type selection>

The usage itself should be self explanatory. Just run QuickConv.bat and confirm settings.

:: -------------------------------------

Make sure to change the settings in QuickConv_op.txt to your personal defaults.
	This can be overridden during runtime.

Current options are the following:
	fps=INTEGER - Determines the frames per second of the output. Refers to source fps if motion blur is enabled.
	num=INTEGER - The number of digits in the input images (For example, 0001.png is 4).
	pre=STRING  - Words that appear before the filename, such as "hello" in hello0002.png.
	end=STRING  - Words that appear after the filename, such as "world" in 0025world.png.
	mob=y/n     - Yes or no to use motion blur, will ignore motion blur variables if n.
	aud=STRING  - Path to the audio file to use with the video (Will end the video if either the video or audio track ends).
	mbf=INTEGER - Final fps if using motion blur (For frameblending from high fps). Will trim down to this framerate from the source fps.
	mfp=INTEGER - Number of frames before a new blended frame will be considered.
	              for example, an mfp of 10 and framerate of 60 will cause 6 frames to blend into each output frame.

:: -------------------------------------

By opening QuickConv.bat, four variables become available:
	opsfile - String pointing to the settings file that will be used at runtime (default: QuickConv_op.txt).
	mbr - Maximum bitrate (only used by the webm and mp4 outputs) (default: 20M).
	abr - Audio bitrate (default: 196K).
	filetype - Image source file type (default: png).

:: -------------------------------------

Some quick tips for motion blur:
	1) Try to start with a higher source FPS (like, hundreds of FPS). Since this blurring technique is simply layering frames, having more source frames boosts quality.
	2) For the most correct results, set the mbf and mfp values equal to each other. This will mean that the unused in-between frames are blended, not "real" frames.
	3) If you're getting too much blur or the end result looks choppy, decrease mfp. Less frames will be blended, giving a sharper image.
