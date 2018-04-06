<#
 .SYNOPSIS  
  Sets a VM Boot Delay
 
 .DESCRIPTION  
  Changes the boot delay for a VM, allowing access to boot menu options.
 
 .NOTES   
  Author: Richard Croft
  Twitter: @dickjacroft
  email: richard.j.a.croft@gmail.com
#>

function Set-VMBootDelay {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$True,
        ValueFromPipeline=$True,
        ValueFromPipelineByPropertyName=$True,
        HelpMessage='Name of the VM to Target')]
        [string[]]$Name,
        [Parameter(Mandatory=$True,
        ValueFromPipeline=$False,
            HelpMessage='Boot Delay from 0 to 1000ms')]
        [int64]$BootDelay
        )
    begin { 
        write-verbose "Changing bootime of $Name to $Delay miliseconds"
        } 
    
    process {
        $vm = Get-VM -Name $Name -ErrorAction Stop
        #Creates a new object for the VM with configurable Boot Options     
        $vmbo = New-Object VMware.Vim.VirtualMachineBootOptions
        #Creates the VM config spec object with the specified bootdelay parameter in the function
        $vmbo.BootDelay = $BootDelay
        $vmcs = New-Object VMware.Vim.VirtualMachineConfigSpec
        $vmcs.BootOptions = $vmbo
        #writes the changes to a VM
        $vm.ExtensionData.ReconfigVM($vmcs)
        }
     }


