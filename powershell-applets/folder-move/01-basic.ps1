# Code written by Mark Battistella
# Copyright (c) 2020
# Do not alter anything or else the world will break

# fix the powershell scripts policy
# Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope LocalMachine

# set the working directory
Set-Location "C:\" # <-- set your directory

# the CSV location
$csvFile = ".\file.csv"

# import the CSV file for folder creation
$folders = Import-Csv -Delimiter "," -Header @("ID","caseName","caseNumber") -Path $csvFile

# begin the loop
ForEach( $folder in $folders ) {

	# create the variables
	$columnID = $folder.ID
	$columnCase = "{0} {1}" -f $folder.caseName, $folder.caseNumber # returns: "Column2 Column3"

	# if case name and number folder does NOT exist
	if( -not ( Test-Path "$columnCase" ) ) {
		New-Item "$columnCase" -ItemType Directory
	}

	# if case name and number folder does exist
	if( Test-Path "$columnID" ) {

		# ID folder exists - move it
		Move-Item "$columnID" -Destination "$columnCase" -Force

	} elseif (Test-Path "$columnCase\$columnID" ) {

		# ID folder DOES exist inside of the subdirectory
		# do nothing now

	} else {

		# ID doesn't exist - create it in the right spot
		New-Item "$columnCase\$columnID" -ItemType Directory

   }
}
