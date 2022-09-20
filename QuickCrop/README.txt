
:: -------------------------------------

QuickCrop Version 1.2

:: -------------------------------------

QuickCrop is a simple method of removing letter/pillarboxing from a video file.

:: -------------------------------------

To use, drag the video file onto QuickCrop.bat.
	If ConfirmResolution is 1, then it will ask if the detected crop resolution is correct and offer to change it.

The output will be saved as <source file>_qcr.<source filetype>

:: -------------------------------------

By opening QuickCrop.bat, three variables becomes available:
	ConfirmResolution - Asks to confirm that the detected crop resolution is correct, or to change it (default: 1).
	MaxScanTime - The maximum number of seconds to scan the video to determine crop resolution (default: 10).
		Higher values improve accuracy, but take longer to run.
	SeekTime - The number of seconds to seek before determining crop resolution (default: 30).
		If the video duration is less than SeekTime, 0 is used for SeekTime.
		Useful for content like movies which fade in from black and could confuse the detection.