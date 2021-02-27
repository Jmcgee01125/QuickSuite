
:: -------------------------------------

QuickConv Version 1.4

:: -------------------------------------

QuickConv is a fast and easy way to convert files from a series of images (0001.png, 0002.png, etc) to an actual video file.

:: -------------------------------------

To use, leave QuickConv.bat and QuickConv_op.txt in the same folder as your images, then run QuickConv.bat.
	Make sure no other images follow the same naming structure or the program may behave unexpectedly.
	Missing QuickConv_op.txt allows setting defaults, but it is not required for the program to work.

Images must have a static filename length, so 1..100 is not allowed but 001..100 is.

To render only a portion of the video, remove the frames outside of the range. QuickConv.bat works fine if the first image is, for example, 0005.png.
	Note that you must still have a continuous range of frames. The program will stop once there is no next frame.

The input is formatted as <pre><frame number><end>.<extension>
	Spaces are allowed in pre and end.
The output will be saved as output.<type selection>

The usage itself should be self explanatory. Just run QuickConv.bat and confirm settings.

:: -------------------------------------

Make sure to change the settings in QuickConv_op.txt to your personal defaults.
	This can be overridden during runtime.

Current options are the following:
	fps=INTEGER - determines the frames per second of the output.
	num=INTEGER - the number of digits in the input images (for example, 0001.png is 4).
	pre=STRING  - words that appear before the filename, such as "hello" in hello0002.png.
	end=STRING  - words that appear after the filename, such as "world" in 0025world.png.

:: -------------------------------------

By opening QuickConv.bat, three variables become available:
	opsfile - string pointing to the settings file that will be used at runtime (default: QuickConv_op.txt).
	mbr - Maximum bitrate (only used by the webm and mp4 outputs) (default: 20M).
	filetype - Image source file type, note that only pngs have been tested (default: png).