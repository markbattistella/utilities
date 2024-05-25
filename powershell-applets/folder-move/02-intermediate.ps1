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
ForEach( $csvRow in $csvRows ) {

	# create the variables
	$columnID = $csvRow.ID
	$columnNameNumber = "{0} {1}"  -f $csvRow.name, $csvRow.number
	$columnNumberName = "{1}, {0}" -f $csvRow.name, $csvRow.number


	#
	# // MARK: begin main folder creation
	#

	# "SMITH 12345678" and "13246578, SMITH" do NOT exist
	if( (-not ( Test-Path "$columnNameNumber" )) -and (-not ( Test-Path "$columnNumberName" )) ) {
		# create the "12345678, SMITH"
		New-Item "$columnNumberName" -ItemType Directory
	}

	# "SMITH 12345678" EXISTS but "13246578, SMITH" does NOT exist
	if( ( Test-Path "$columnNameNumber" ) -and (-not ( Test-Path "$columnNumberName" )) ) {
		# rename "SMITH 12345678" -> "12345678, SMITH"
		Rename-Item "$columnNameNumber" -NewName $columnNumberName -Force
	}

	# "SMITH 12345678" does NOT exist but "13246578, SMITH" EXISTS
	if( (-not ( Test-Path "$columnNameNumber" )) -and ( Test-Path "$columnNumberName" ) ) {
		# do nothing
	}

	# "SMITH 12345678" and "13246578, SMITH" both EXIST
	if( ( Test-Path "$columnNameNumber" ) -and ( Test-Path "$columnNumberName" ) ) {
		# find all the items in $columnNameNumber
		$subDirectory = Get-ChildItem $columnNameNumber -Name

		# loop through and move to $columnNameNumberNew
		ForEach( $childItem in $subDirectory ) {
			Move-Item "$columnNameNumber\$childItem" -Destination "$columnNumberName"
		}

		# rename to know its done
		if( ( Test-Path .\destination ) ) {
			Move-Item "$columnNameNumber" -Destination .\destination
		}
	}


	#
	# // MARK: begin ID folder moves
	#

	# if "98765" folder exists
	if( Test-Path "$columnID" ) {
		# move "98765" into "12345678, SMITH"
		Move-Item "$columnID" -Destination "$columnNumberName"
	}
}
