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
$csvRows = Import-Csv -Delimiter "," -Header @("ID") -Path $csvFile

# to see where we are at
$loopIndex = 1;

# search area
# `*\*\*` == number of levels to search
$searchShare = "C:\"

# if not in ISE
if( $Host.name -notmatch "ISE" ) {

    #clear console
    clear

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
    $id    = $csvRow.id    # column number 1

    # search the directory
    $idPathway = Get-ChildItem $searchShare -Directory -Recurse -ErrorAction SilentlyContinue |

        # find the matching ID
        Where-Object -Property Name -eq $id |

        # stop at first match
        Select-Object -First 1 |

        # return the pathway
        Select-Object -ExpandProperty FullName

    # get the sum of all the child items from the match
    $idSize = (Get-ChildItem $idPathway -Recurse -ErrorAction SilentlyContinue |
				Measure-Object -Property Length -Sum -ErrorAction Stop).Sum

	// return size in GB
    $idSizeInGB = [math]::Round( $idSize / 1GB, 2 )

	// print it out
	Write-Host(
        "$loopIndex/" + $csvRows.Count + ",`"" + $idPathway + "`"," + $idSizeInGB
    );

    # increase the index number
    $loopIndex++;
}

# if not in ISE
if( $Host.name -notmatch "ISE" ) {
    # stop the transcription
    Stop-Transcript
} else {

    # remind me to manually get console
    Write-Host( "No logging was saved - manually extract logs" )
}
