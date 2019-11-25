Function Get-InstalledSoftware
{
  <#
      .SYNOPSIS
      "Get-InstalledSoftware" collects all the software listed in the Uninstall registry.

    .DESCRIPTION
    Add a more complete description of what the function does.

      .PARAMETER SortList
      Allows you to sort by Name, Installed Date or Version Number.  'InstallDate' or 'DisplayName' or 'DisplayVersion'

      .PARAMETER SoftwareName
      This wil provide the installed date, version, and name of the software in the "value".  You can use part of a name or two words, but they must be in quotes.  Mozil or "Mozilla Firefox"

    .PARAMETER File
    Future Use:  Will be used to send to a file instead of the screen. 

      .EXAMPLE
      Get-InstalledSoftware -SortList DisplayName

      InstallDate  DisplayVersion   DisplayName 
      -----------  --------------   -----------
      20150128     6.1.1600.0       Windows MultiPoint Server Log Collector 
      02/06/2007   3.1              Windows Driver Package - Silicon Labs Software (DSI_SiUSBXp_3_1) USB  (02/06/2007 3.1) 
      07/25/2013   10.30.0.288      Windows Driver Package - Lenovo (WUDFRd) LenovoVhid  (07/25/2013 10.30.0.288)


      .EXAMPLE
      Get-InstalledSoftware -SoftwareName 'Mozilla Firefox',Green,vlc 

      Installdate  DisplayVersion  DisplayName                     
      -----------  --------------  -----------                     
      69.0            Mozilla Firefox 69.0 (x64 en-US)
      20170112     1.2.9.112       Greenshot 1.2.9.112             
      2.1.5           VLC media player  

    .NOTES
    Place additional notes here.

    .LINK
    https://github.com/KnarrStudio/ITPS.OMCS.Tools


    .OUTPUTS
    To the screen until the File parameter is working

  #>




  [cmdletbinding(DefaultParameterSetName = 'SortList',SupportsPaging = $true)]
  Param(
    [Parameter(Mandatory=$false,HelpMessage = 'Get list of installed software by installed date (InstallDate) or alphabetically (DisplayName)',ParameterSetName = 'SortList')]
    [Parameter(ParameterSetName = 'SoftwareName')]
    [ValidateSet('InstallDate', 'DisplayName','DisplayVersion')] 
    $SortList,
    
    [Parameter(Mandatory = $true,HelpMessage = 'At least part of the software name to test', Position = 0,ParameterSetName = 'SoftwareName')]
    [String[]]$SoftwareName,
    [Parameter(Mandatory = $false,HelpMessage = 'list of installed software by installed date (InstallDate) or alphabetically (DisplayName)', Position = 1,ParameterSetName = 'SoftwareName')]
    [Parameter(ParameterSetName = 'SortList')]
    [Switch]$File
  )
  
  Begin { 
    $InstalledSoftware = (Get-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*)
  }
  
  Process {
    Try 
    {
      if($SoftwareName -eq $null) 
      {
        if($SortList -eq $null)
        {
          $SortList = 'DisplayName'
        }
        $InstalledSoftware |
        Sort-Object -Descending -Property $SortList |
        Select-Object -Property @{
          Name = 'Date Installed'
          Exp  = {
            $_.Installdate
          }
        }, @{
          Name = 'Version'
          Exp  = {
            $_.DisplayVersion
          }
        }, DisplayName #, UninstallString 
      }
      Else 
      {
        foreach($Item in $SoftwareName)
        {
          $InstalledSoftware |
          Where-Object -Property DisplayName -Match -Value $Item |
          Select-Object -Property @{
            Name = 'Version'
            Exp  = {
              $_.DisplayVersion
            }
          }, DisplayName
        }
      }
    }
    Catch 
    {
      # get error record
      [Management.Automation.ErrorRecord]$e = $_

      # retrieve information about runtime error
      $info = [PSCustomObject]@{
        Exception = $e.Exception.Message
        Reason    = $e.CategoryInfo.Reason
        Target    = $e.CategoryInfo.TargetName
        Script    = $e.InvocationInfo.ScriptName
        Line      = $e.InvocationInfo.ScriptLineNumber
        Column    = $e.InvocationInfo.OffsetInLine
      }
      
      # output information. Post-process collected info, and log info (optional)
      $info
    }
  }
  
  End{ }
}

#
# Get-InstalledSoftware -SortList InstallDate | select -First 10 #| Format-Table -AutoSize
# Get-InstalledSoftware -SoftwareName 'Mozilla Firefox',vlc, Acrobat
Get-InstalledSoftware
 
