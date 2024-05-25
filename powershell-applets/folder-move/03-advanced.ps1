# Code written by Mark Battistella
# Copyright (c) 2020
# Do not alter anything or else the world will break

# fix the powershell scripts policy
# Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope LocalMachine

# the CSV location
$csvFile = ".\file.csv"

# import the CSV file for folder creation
# create the headers for the file since CSVs dont have them
$csvRows = Import-Csv -Delimiter "," -Header @("original","destination", "shortcut") -Path $csvFile

# to see where we are at
$loopIndex = 0;

# begin the loop
ForEach( $csvRow in $csvRows ) {

	# create the variables
    $original    = $csvRow.original    # column number 1
    $destination = $csvRow.destination # column number 2
    $shortcut    = $csvRow.shortcut    # column number 3

    # start a new shell object
    $WScriptShell = New-Object -ComObject WScript.Shell

    # increase the index number
    $loopIndex++;

    #
    # // MARK: break up the entries
    #
    Write-Host( "---" )
    Write-Host( "$loopIndex" + " / " + $csvRows.Count )
    Write-Host( $original )
    Write-Host( "---" )

    #
    # // MARK: get the sub items
    #
    if( Test-Path "$original" ) {
        $originalChildItems = Get-ChildItem "$original"
    }

    #
    # // MARK: move sub items from original location to destination
    #
    if( Test-Path "$original" ) {

        # loop the sub items
        ForEach( $originalChildItem in $originalChildItems ) {

           # check if child exists in destination
           if( Test-Path( "$destination" + "\" + "$originalChildItem" ) ) {

                # // DEBUG: already in desitnation
                Write-Host( "Already exists: " + "$destination" + "\" + "$originalChildItem" )

           } else {

                # if the file is a shortcut
                $fileExtension = [IO.Path]::GetExtension($originalChildItem)

                if( $fileExtension -eq ".lnk" ) {

                    # // DEBUG: don't move shortcuts
                    Write-Host( "Not moving shortcuts:" + "$destination" + "\" + $originalChildItem )

                } else {

                    # move them to the destination
                    Move-Item -Path ("$original" + "\" + "$originalChildItem") -Destination "$destination"

                    # // DEBUG: log move
                    Write-Host( "Moved to: " + "$destination" + "\" + $originalChildItem )

                }
           }
        }
    }


    #
    # // MARK: create shortcuts back to the original location
    #
    if( Test-Path "$destination" ) {

        # get all the items in the Scality directory
        $destinationChildItems = Get-ChildItem -Path "$destination"

        # loop through each item
        ForEach( $destinationChildItem in $destinationChildItems ) {

            # create the shortcut paths
            $shortcutOriginalLocation    = ( $shortcut    + "\" + $destinationChildItem + ".lnk" )
            $shortcutDestinationLocation = ( $destination + "\" + $destinationChildItem )

            if( Test-Path $shortcutOriginalLocation) {

                # shortcut already exists
                Write-Host( "Shortcut already exists: " + $shortcutOriginalLocation )


            } else {
                # generate the shortcut
                $buildShortcut            = $WScriptShell.CreateShortcut( "$shortcutOriginalLocation" )
                $buildShortcut.TargetPath = "$shortcutDestinationLocation"

                # save the shortcut
                $buildShortcut.Save()

                # // DEBUG: log shortcut
                Write-Host( "Shortcut created: " + "$shortcutOriginalLocation" )
            }
        }
    }
}
