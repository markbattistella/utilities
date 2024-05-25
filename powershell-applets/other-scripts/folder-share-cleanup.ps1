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
$csvRows = Import-Csv -Delimiter "," -Header @("id", "name", "number") -Path $csvFile

# to see where we are at
$loopIndex = 0;

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
	$columnID = $csvRow.id
	$columnNameNumber = "{0} {1}"  -f $csvRow.name, $csvRow.number


	#
	# // MARK: begin main folder creation
	#

	# "SMITH 12345678" does NOT exist
	if( -not ( Test-Path "$columnNameNumber" ) ) {
		# create the "SMITH 12345678"
		New-Item "$columnNameNumber" -ItemType Directory
	}


	#
	# // MARK: begin ID folder moves
	#

	# if "98765" folder exists
	if( Test-Path "$columnID" ) {
		# move "98765" into "12345678, SMITH"
		Move-Item "$columnID" -Destination "$columnNameNumber"
	}

}

# if not in ISE
if( $Host.name -notmatch "ISE" ) {
    # stop the transcription
    Stop-Transcript
} else {

    # remind me to manually get console
    Write-Host( "No logging was saved - manually extract logs" )
}
