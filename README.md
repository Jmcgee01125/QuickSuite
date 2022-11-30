# QuickSuite

A collection of batch tools to do various tasks quickly, with a special focus on video operations.  

---

## CURRENT TOOLS 

* **QuickCombine:** concatenates videos using a user-defined order.  
* **QuickCompress:** automatically compresses videos below a certain size, which is useful for sending videos on size-restricted platforms like Discord.  
* **QuickConv:** converts a series of images (0001.png, 0002.png, etc) into a video file, with support for audio and frameblend motionblur.  
* **QuickCrop:** automatically detects and crops letter/pillarboxing from a video.
* **QuickExtract:** extracts audio from a video file.  
* **QuickNote:** creates a note-taking file in an arbitrary directory from anywhere on the computer without having to save-as.  
* **QuickTrim:** trims a video based on user-selected timestamps without needing to re-encode.  
* **QuickVolume:** changes the volume of a video's audio without needing to re-encode the video.

---

## FFMPEG NOTE 

**!! YOU MUST INSTALL FFMPEG TO USE MOST OF THESE PROGRAMS**  

You can find instructions to download FFmpeg [here](https://docs.google.com/document/d/1Oex7va4IURjw17OT2MK3FHZgC6iVoInT6ZVuctyZ-uI/).  
Or download it yourself from https://ffmpeg.org/download.html.  

Make sure to add it to your system's path variable. The guide covers this as well, or you can go edit environment variables yourself if familiar.  

Alternatively, you can instead run these batch files in the FFmpeg/bin folder (where ffmpeg.exe and ffprobe.exe are). You'll still have to download FFmpeg from the website.  

---

## VARIABLE USAGE NOTE 

All of these programs contain variables inside the batch files themselves. You may need to change these for the program to work how you want it to.  

To edit those variables, right click the program in your file browser and select "edit" from the menu.  
Variables to change are at the top of the file (under the "Settings" section), and have a short description of their use.  

If a file is not working correctly for you (fails to do its job or crashes instantly), this is the most likely cause of issues.  
