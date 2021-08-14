
:: -------------------------------------

QuickCombine Version 1.0

:: -------------------------------------

QuickCombine allows easily appending videos to each other, forming one continuous clip.

:: -------------------------------------

To use, select all of the videos you want to combine and drag them onto QuickCombine.bat
	You will then be able to select which video comes in which order.
	Enter the number (such as "2") of the video in the list given, then press enter.
	Do not enter a blank, even if the argument order is the intended order, numbers must be entered.

You are responsible for making sure that all selected items are videos.

The output will be saved as QuickCombine_output.<type selection>

:: -------------------------------------

By opening QuickCombine.bat, two variables become available:
	UseNVENC - Uses the nvenc encoder on the GPU instead of a CPU encoder. MUCH faster, but not available for all systems (default: 1).
		   QuickCompress runs a check when starting if UseNVENC=1, to prevent an abnormal crash.
	ext - Output file type (default: mp4).
