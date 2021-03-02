$StartFolder = "F:\Temp"
$OutputFolder = "F:\Temp"

###################################################################################################################
# Execution Code
###################################################################################################################

$ListsFiles = Get-ChildItem "$StartFolder" -recurse -Filter *.mp4;    

Foreach ($file in $ListsFiles){
	$OutputFolder = $file.fullname | split-path
    $ArgumentList = '-i "{0}" -ss 2 -frames 1 -loglevel quiet "{2}\{1}.jpg"' -f $file.Fullname, $file.basename, $OutputFolder;
    Write-Host -ForegroundColor Green -Object $ArgumentList;   
    Start-Process -FilePath ffmpeg -ArgumentList $ArgumentList -Wait -NoNewWindow;    
}
