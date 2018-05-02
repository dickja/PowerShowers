<#
.Synopsis
   Upgrade hardware Version
.DESCRIPTION
   Function to upgrade the hardware version on next reboot for a vSphere VM to the hardware version specified in the cmdlet.
.EXAMPLE
   upgrade-VMhardware -vm EG-W10-PC01 -version 13
.INPUTS
   Inputs to this cmdlet (if any)
.FUNCTIONALITY
   The functionality that best describes this cmdlet
.AUTHOR
   Richard Croft
   e:richard.j.a.croft@gmail.com
#>
function Upgrade-VMHardware
{
    Param
    (
        # Name of virtual machine to upgrade
        [Parameter(Mandatory=$true, 
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true, 
                   ValueFromRemainingArguments=$false, 
                   Position=0,
                   HelpMessage='Name of the VM to Upgrade')]
        [ValidateNotNull()]
        [string[]]$vm,

        # Harware version number to upgrade to
        [Parameter(Mandatory=$True,
        ValueFromPipeline=$True,
        ValueFromPipelineByPropertyName=$True,
        HelpMessage='Name of the VM to Target')]
        [int]$ver

       )

    Begin
    {
    try {$vmo = Get-VM -Name $vm -ErrorAction Stop}
    catch {"VM $vm cannot be found"}
    }
    Process
    {
    #create relevant object, set it to upgrade VMversion on guest OS reboot.
    $spec = New-Object -TypeName VMware.Vim.VirtualMachineConfigSpec
        $spec.ScheduledHardwareUpgradeInfo = New-Object -TypeName VMware.Vim.ScheduledHardwareUpgradeInfo
        $spec.ScheduledHardwareUpgradeInfo.UpgradePolicy = "onSoftPowerOff"
        $spec.ScheduledHardwareUpgradeInfo.VersionKey = "vmx-$ver"
        $vmo.ExtensionData.ReconfigVM_Task($spec)
    }
    End
    {
    }
}
