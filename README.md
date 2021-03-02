# PlayOnTrimmers

Windows Powershell scripts to generate thumbnails for your videos (GenThumbnails.ps1) and trim the beginning and/or end of your videos (TrimVideos.ps1). The two scripts work in conjunction with each other.  After modifying the env variables in each script:
  - Run GenThumbnail where it will extract the frame at 2 seconds into the video to create a JPG thumbnail for every MP4 video in the folder you identify in the script.
  - Manually, you review all the thumbnails and delete those that are not from a PlayOn recording (the thumbnail should have the PlayOn intro captured if its a PlayOn recording).
  - Run TrimVideo where it will find all the remaining thumbnails and trim the associated video per the values you put in the script.  
  - You review the output and move the new video to your main directory.

Notes:
  - My main video folder had videos from multiple sources, not just PlayOn, which is why I went with this approach. If all the recordings in the source folder are PlayOn recordings then the scripts will still work and you could skip the manual review of the thumbnails in between executing the two scripts.
  - The scripts will recurse through subdirectories.
  - It does not look for chapters marked as advertisements.
  - The modified files are intended to be stored in a different directory than the source folder as it uses the same filename.  TrimVideo has not been tested using the same source and destination folder.
  - Requires ffmpeg (and ffprobe) to be installed and its bin directory in your $path to run.
