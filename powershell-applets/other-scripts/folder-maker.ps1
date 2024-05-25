# Code written by Mark Battistella
# Copyright (c) 2020
# Do not alter anything or else the world will break


# fix the powershell scripts policy
# Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope LocalMachine

# base path
$basePath = "B:\"

# the CSV location
$csvFile = $basePath + "file.csv"

# import the CSV file for folder creation
# create the headers for the file since CSVs dont have them
$csvRows = Import-Csv -Delimiter "," -Header @("newDirectory") -Path $csvFile

# to see where we are at
$loopIndex = 1;

# if not in ISE
if( $Host.name -notmatch "ISE" ) {

    # stop any other transcripts
    $ErrorActionPreference = "SilentlyContinue"
    Stop-Transcript | Out-Null

    # set the transcript preference
    $ErrorActionPreference = "Continue"
    Start-Transcript -Path ($basePath + "file.log") -Append
} else {

    # clear the console
    clear
}

# begin the loop
ForEach( $csvRow in $csvRows ) {

	# create the variables
    $newDirectory    = $csvRow.newDirectory    # column number 1

	# create the folders
	# if path has non-existing parent folder, they will be made too
    New-Item -ItemType Directory -Force -Path $newDirectory

}

# if not in ISE
if( $Host.name -notmatch "ISE" ) {
    # stop the transcription
    Stop-Transcript
} else {

    # remind me to manually get console
    Write-Host( "No logging was saved - manually extract logs" )
}
