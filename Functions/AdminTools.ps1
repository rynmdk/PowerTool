#requires -Version 2.0
function Start-AdminTool
{

  [CmdletBinding()]
  

  param
  (
    [Parameter(Mandatory = $true,HelpMessage = 'Name of Tool from the AdminTool Splat')]
    [Object]$Tool
  )

  $AdminTool = @{
    Explorer       = 'explorer.exe', 'File Explorer launched'
    Service        = 'services.msc', 'Services.msc launched'
    Regedit        = 'regedit', 'Regedit launched'
    PowerShell     = 'powershell', 'PowerShell launched'
    CMD            = 'cmd', 'CMD launched'
    DeviceManager  = 'devmgmt', 'Device Manager launched'
    EventViewer    = 'eventvwr', 'Event Viewer launched'
    SystemSettings = 'sysdm.cpl', 'Advanced System Settings launched'
    RemotePing     = "ping.exe -ArgumentList '$hostname -n 300'", "Ping launched for $hostname"
  }


  Start-Process -FilePath $AdminTool.$Tool[0]
  Edit-PTlog -Write -logString $AdminTool.$Tool[1]
}



<#
    Broke while editing
    Will fix later

    function PT-RemoteExplorer 
    {
    Invoke-Item -Path \\$hostname\c$\
    ,('File Explorer launched for {0}' -f $hostname)
    PT-LineSpacer
    }
#>


<#
Save for later 


function PT-RemoteServices 
{
  & "$env:windir\system32\services.msc" /computer=$hostname
  Write-PTlog -logString "Services.msc launched for $hostname"
  PT-LineSpacer
}
#>

