<#
 .SYNOPSIS  
 Force SCCM Deployment for Application
 
 .DESCRIPTION  
 Adds a client to a Collection with a Direct rule then requests a client Machine Policy and App Deployment
 
 .NOTES   
 Author: Richard Croft
#>

#Source of machine names to action
$Source = get-content "<SOURCE_LOCATION>"
$Collection = "<COLLECTION_NAME>"
#Gets collectionID from Collection named above
$CollectionID = Get-CMCollection -Name $Collection | select -Property CollectionID | % {$_.CollectionID}

#Iterates through each machine in the source array and adds it to the collection, catch if the machine is already in the collection and notify.
foreach ($computer in $Source) {
        try {
              Add-CMDeviceCollectionDirectMembershipRule -CollectionID $CollectionID `
		      -ResourceId $(Get-CMDevice -Name $Computer).ResourceID
              }
        catch {
              write-host "$computer is already in the collection $Collection"
              } 
        }

#Iterates through each machine in the source array and asks it to request its machine policy, catch if there is an issue finding the machine
foreach ($computer in ) {
        try {
            Invoke-CMClientNotification -DeviceName $Computer -ActionType ClientNotificationRequestMachinePolicyNow
            }
        catch [System.Management.Automation.ItemNotFoundException]
              {
              write-host "ERROR: Exception: $computer could not be found"
              } 
        }

start-sleep -Seconds 120

#Iterates through each machine in the source array and asks it to run an Application Deployment Cycle, catch if there is an issue finding the machine
foreach ($computer in $Source) {
        try {
             Invoke-CMClientNotification -DeviceName $Computer -ActionType ClientNotificationAppDeplEvalNow
             }
        catch [System.Management.Automation.ItemNotFoundException]
              {
              write-host "ERROR: Exception: $computer could not be found"
              } 
        }
