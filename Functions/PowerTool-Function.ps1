#requires -Version 3.0


#Set-Location -Path $PSScriptRoot


. .\Functions\edit-ptlog.ps1 
. .\Functions\AdminTools.ps1 

# Main Functions
function Connect-PTworkstation 
{
  # Connect to remote workstation

  Edit-PTlog -Clear
  Set-PtRemoteTools -SetState Disable

  # Set hostname up as a global variable based on the hostname entry
  $global:hostname = $txbHostname.text

  if ($hostname -eq '') 
  {
    Edit-PTlog -Write -logString 'No Computer Name or IP Address entered'
  }
  else 
  {
    $TestConnection = Test-Connection -ComputerName $hostname -Count 1 -BufferSize 16 -ErrorAction SilentlyContinue
    
    if (!($TestConnection)) 
    {
      Edit-PTlog -Write -logString ('Unable to Connect to {0}' -f $hostname)
    }
    else 
    {
      try 
      {
        # Get target hostname
        $MachineName = Get-WmiObject -Class win32_computersystem -ComputerName $hostname
         
        # Compare entered hostname to target hostname to ensure no DNS issue
        if ((!($hostname -like '*.*')) -and ($MachineName.name -ne $hostname)) 
        {
          # Stop processing as DNS issue occured
          Edit-PTlog -Clear
          Set-PtRemoteTools -SetState Disable
          Edit-PTlog -Write -logString ('DNS issue encountered connecting to {0}' -f $hostname)
        }
        else 
        {
          Edit-PTlog -Clear
          Set-PtRemoteTools -SetState Enable
          Edit-PTlog -Write -logString ('Successfully connected to {0}' -f $hostname)
        }
      }
      catch 
      {
        Edit-PTlog -Clear
        Edit-PTlog -Write -logString ('Unable to connect to {0}' -f $hostname)
      }
    }
  }
}

function Clear-PTlog 
{
  # Clear PowerTool Log
  Edit-PTlog -Clear
}


function Copy-PTLogs 
{
  # Function to copy logs to clipboard
  # Copy-Clipboard required
  
  Edit-PTlog -Copy
  Edit-PTlog -Write -logString 'Log copied to clipboard'
}

function Write-PTlog 
{
  # Add log to PowerTool log screen
  Write-Error -Message 'This is still being used somewhere'
}

function PT-LineSpacer 
{
  # Add linespacer to logs - for formatting only
  # $txbLogging.Appendtext("{0}`r`n" -f $PtLine)
  Return
}

function Set-PtRemoteTools 
{
  [CmdletBinding()]
  param(
    [Parameter(Mandatory = $true, ValueFromPipeline = $true,
    ValueFromPipelineByPropertyName = $true)]
    [ValidateSet('Enable','Disable')]
    [string]$SetState
  )
  
  if($SetState -eq 'Enable')
  {
    $ToolState = $true
  }
  if($SetState -eq 'Disable')
  {
    $ToolState = $false
  }
    
  $computerInformationDropdown.Visible = $ToolState
  $fixesDropdown.Visible = $ToolState
  $appvDropdown.Visible = $ToolState
  $applicationsDropdown.Visible = $ToolState
  
  $tools_remote_Explorer.Enabled = $ToolState
  $tools_remote_Services.Enabled = $ToolState
  $tools_remote_Ping.Enabled = $ToolState
}


# Account Information

# Computer Information

# Scripts

# Applications

# App-V