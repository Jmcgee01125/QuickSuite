
---------------------

QuickConv version 1.3

---------------------

QuickConv is a fast and easy way to convert files from a series of images (0001.png, 0002.png, etc) to an actual video file.

---------------------

To use, leave QuickConv.bat and QuickConv_op.txt in the same folder as your images.
The output will be saved as output.<type selection>

The usage itself should be self explanatory. Just run QuickConv.bat

---------------------

Make sure to change the settings in quickconv_op.txt to your personal defaults.
	This can be overridden during runtime.

Current options are the following:
	fps=INTEGER - determines the frames per second of the output.
	num=INTEGER - the number of digits in the input images (for example, 0001.png is 4).

---------------------

By opening QuickConv.bat, three variables become available:
	opsfile - string pointing to the settings file that will be used at runtime (default: quickconv_op.txt).
	mbr - Maximum bitrate (only used by the webm and mp4 outputs) (default: 20M).
	filetype - Image source file type, note that only pngs have been tested (default: png).