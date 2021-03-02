# Update $InputFolder and $OutputFolder
$InputFolder = "F:\Videos";
$OutputFolder = "F:\Temp";
#Remove the following seconds from the start of the file.
$TrimStart = 10
#Remove the following seconds from the end of the file.
$TrimEnd = 0
#Output format extension
$OutputFormat = ".mp4"

###################################################################################################################
# Execution Code
###################################################################################################################

#Ensure the input directory exists. We can't actually do anything if it doesn't.
If(!(Test-Path $InputFolder)) {
	write-host "Failure: Source directory ($InputFolder) does not exist. Exiting" -foreground "red"
	Exit(1)
}
#Ensure the output directory exists. Create it and any subfolders if they don't.
If(!(Test-Path $OutputFolder)) {
	write-host "Creating output directory and subdirectories: $OutputFolder" -foreground "green"
	New-Item -ItemType Directory -Force -Path $OutputFolder
	If(!(Test-Path $OutputFolder)) {
		write-host "Failure: Unable to create output directory ($OutputFolder). Exiting" -foreground "red"
		Exit(1)
	}
	# Recreate directory structure from $InputFolder to $OutputFolder; /e (copy subfolders) /xf * (exclude all files)
	robocopy "$InputFolder" "$OutputFolder" /e /xf *;
	echo("Updated file will be moved to $OutputFolder")
}

# Find all the JPGs that correspond to videos you want to trim.
$ListsFiles = Get-ChildItem "$InputFolder" -recurse -Filter *.jpg;     

Foreach ($file in $ListsFiles){
	# Create full input path and filename for video file
	$FileName = $file.basename+$OutputFormat;
	$Inputpath = $file.fullname|split-path;
	$Inputfull = $Inputpath+"\"+$FileName;

	# $Testname is used for testing the script.  $OutputFull below would need to be modified from #FileName to #Testname if testing
	# $Testname = $file.basename+"_tst"+".mp4";
	
	# Create full output path and filename for video file
	$OutputPath = echo $file.fullname | split-path | ForEach-Object {$_ -Replace [Regex]::Escape("$InputFolder"), "$OutputFolder"}
	$OutputFull = $OutputPath+"\"+$FileName;

	# Get duration of the video (rounded)
	$input_dur = [math]::round((ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "$Inputfull"));

    $output_duration=$input_dur-$TrimStart-$TrimEnd;
	
    $ArgumentList = '-i "{0}" -v 0 -ss {1} -t {2} -vcodec copy -acodec copy "{3}"' -f $Inputfull, $TrimStart, $output_duration, $OutputFull;
    Write-Host "Start: " -NoNewline
	Write-Host (get-date).ToString('T')"  " -NoNewline
	Write-Host -ForegroundColor Green -Object $ArgumentList;   
    Start-Process -FilePath ffmpeg -ArgumentList $ArgumentList -Wait -NoNewWindow;
	Write-Host "Stop:  " -NoNewline
	(get-date).ToString('T')
}
