 <#
 .SYNOPSIS  
  Force package deployment
 
 .DESCRIPTION  
  Changes the boot delay for a VM, allowing access to boot menu options.
 
 .NOTES   
  Author: Richard Croft
  Twitter: @dickjacroft
 /#>


#DECLARE FUNCTIONS

<#
 .SYNOPSIS  
  Request Machine Policy
 
 .DESCRIPTION  
  Request and download machine policy from SCCM
 
 .EXAMPLE
 Run-RequestMachinePolicy -ComputerName SYDCOMP_001

 /#>
function Run-RequestMachinePolicy{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$True,
        ValueFromPipeline=$True,
        ValueFromPipelineByPropertyName=$True,
        HelpMessage='Name of the VM to Target')]
        [string[]]$ComputerName
        )
    process {
                try {
                    Invoke-CMClientNotification -DeviceName "$Computer" -ActionType ClientNotificationRequestMachinePolicyNow
                    }
            catch [System.Management.Automation.ItemNotFoundException]
                    {
                    write-host "ERROR: Exception: $computer could not be found"
                    } 
        }
    }

<#
 .SYNOPSIS  
  Run Application Deployment Evaluation
 
 .DESCRIPTION  
  Re-evaluate all of the global conditions and it also re-detects all applications deployed to the system as required.
 
 .EXAMPLE
 Run-RequestMachinePolicy -ComputerName SYDCOMP_001

 /#>
function Run-AppDeployment {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$True,
        ValueFromPipeline=$True,
        ValueFromPipelineByPropertyName=$True,
        HelpMessage='Name of the VM to Target')]
        [string[]]$ComputerName
        )
    process {
            try   {
                  Invoke-CMClientNotification -DeviceName "$ComputerName" -ActionType ClientNotificationAppDeplEvalNow
                  }
            catch [System.Management.Automation.ItemNotFoundException]
                  {
                  write-host "ERROR: Exception: $ComputerName could not be found"
                  } 
            }
    }        

#END FUNCTION DECLARATION

#Collection Name that machines will be added to.
$Collection = "APP VMware Horizon Agent Upgrade"
#Gets collectionID from Collection named above
$CollectionID = Get-CMCollection -Name $Collection | select -Property CollectionID | % {$_.CollectionID}

#Iterates through each computer name in the agentupgrade.txt file and adds it to the Collection
foreach ($computer in (get-content 'C:\Powershell Scripts\Data\agentupgrade.txt')) {
        try {
              Add-CMDeviceCollectionDirectMembershipRule -CollectionID $CollectionID `
		      -ResourceId $(Get-CMDevice -Name $Computer).ResourceID
              }
        catch {
              write-host "$computer is already in the collection $Collection"
              } 
        }

#For each machine in the agentupgrade.txt file run a Request Machine Policy
foreach ($computer in (get-content 'C:\Powershell Scripts\Data\agentupgrade.txt')) {Run-RequestMachinePolicy -ComputerName $computer}
        
start-sleep -Seconds 120

#For each machine in the agentupgrade.txt file run a Application Deployment Evaluation
foreach ($computer in (get-content 'C:\Powershell Scripts\Data\agentupgrade.txt')) {Run-AppDeployment -ComputerName $computer}
     

