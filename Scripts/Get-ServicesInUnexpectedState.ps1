<#
    .SYNOPSIS
    get-ServicesInUnexpectedState.ps1 finds services in a state that is not expected.

    .DESCRIPTION
    Add a more complete description of what the function does.

    .PARAMETER InputObject
    Describe parameter -InputObject.

    .EXAMPLE
    get-ServicesInUnexpectedState.ps1

    .NOTES
    Place additional notes here.

    .INPUTS
    List of input types that are accepted by this function.

    .OUTPUTS
    List of output types produced by this function.
#>


function Get-MyColHealthNotOk
{
  param
  (
    [Parameter(Mandatory, ValueFromPipeline, HelpMessage='Data to filter')]
    $InputObject
  )
  process
  {
    if ($InputObject.Name -ne $null -and $InputObject.Health -ne 'OK')
    {
      $InputObject
    }
  }
}


# Find services in unexpected state

$Services = get-wmiobject -Class win32_service -ErrorAction SilentlyContinue #| Where-Object {$_.DisplayName -like "Win*" }

$myCol = @()
Foreach ($service in $Services){
  $MyDetails = '' | select-Object -Property Name, State, StartMode, Health
  If ($service.StartMode -eq 'Auto') #TODO: All chained ifs should be converted to a switch statement for perofmrance and to tidy up code
  {
    if ($service.State -eq 'Stopped')
    {
      $MyDetails.Name = $service.Displayname
      $MyDetails.State = $service.State
      $MyDetails.StartMode = $service.StartMode
      $MyDetails.Health = 'Unexpected State'
    }
  }
  If ($service.StartMode -eq 'Auto')
  {
    if ($service.State -eq 'Running')
    {
      $MyDetails.Name = $service.Displayname
      $MyDetails.State = $service.State
      $MyDetails.StartMode = $service.StartMode
      $MyDetails.Health = 'OK'
    }
  }
  If ($service.StartMode -eq 'Disabled')
  {
    If ($service.State -eq 'Running')
    {
      $MyDetails.Name = $service.Displayname
      $MyDetails.State = $service.State
      $MyDetails.StartMode = $service.StartMode
      $MyDetails.Health = 'Unexpected State'
    }
  }
  If ($service.StartMode -eq 'Disabled')
  {
    if ($service.State -eq 'Stopped')
    {
      $MyDetails.Name = $service.Displayname
      $MyDetails.State = $service.State
      $MyDetails.StartMode = $service.StartMode
      $MyDetails.Health = 'OK'
    }
  }
  $myCol += $MyDetails
}

$Results = $MyCol | Get-MyColHealthNotOk
$Results
