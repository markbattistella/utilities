# Code written by Mark Battistella
# Copyright (c) 2020
# Do not alter anything or else the world will break

# fix the powershell scripts policy
# Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope LocalMachine


# create an array of computers
$computerIPs = @(
    "192.168.0.1"
);

# create a list of user accounts
$userList = @(
	"username"
);

# create a list of user accounts
$shortcutList = @(
	"myShortcut"
);

# create a list of user accounts
$pathwayList = @(
    "\\NAS\shareName"
);


# create the loop
forEach( $computer in $computerIPs ) {

    # loop through users
    forEach( $user in $userList ) {

        # make the UNC string
        $uncString = ( "\\" + $computer + "\C$\Users\" + $user + "\AppData\Roaming\Microsoft\Windows" );

        # test the path
        if( Test-Path "$uncString" ) {

            # get children items
            $childShortcuts = Get-ChildItem ( "B:\Network Shortcuts\" )

            # path exists
            Write-Output( "-------------------------" )
            Write-Output( "Working on: " + $uncString )
            Write-Output( "-------------------------" )

            # check if the destination exists
            if( Test-Path ("$uncString" + "\Network Shortcuts") ) {

                # delete the existing folder
                Remove-Item -Path ($uncString + "\Network Shortcuts") -Confirm:$false
            }

            # make a blank folder
            New-Item -ItemType directory -Path ("$uncString" + "\Network Shortcuts")

            # create the loop
            $i = 0;

            # create symbolic links
            forEach( $shortcut in $shortcutList ) {

                # generate the junctions
                New-Item -ItemType Junction -Path "$uncString\Network Shortcuts\$shortcut" -Target $pathwayList[$i]

                # increment
                $i++
            }

        } else {

            # no location
            # Write-Output( "Not found: " + $uncString )
        }
    }
}
