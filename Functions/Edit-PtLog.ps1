#requires -Version 2.0

function Edit-PTlog
{
  [cmdletbinding(DefaultParameterSetName = 'Write')]
  Param(
    [Parameter(Mandatory = $true,
    ParameterSetName = 'Clear')]
    [Switch]$Clear,

    [Parameter(Mandatory = $true,
    ParameterSetName = 'Write')]
    [Switch]$Write,

    [Parameter(Mandatory = $true,
    ParameterSetName = 'Write')]
    [Object]$logString,
    
    [Parameter(Mandatory = $true,
    ParameterSetName = 'Copy')]
    [Switch]$Copy
  )

  $Script:PtLine = '-' * 109

  # Clear PowerTool Log
  if($Clear)
  {
    $txbLogging.clear()
  }

  if($Write) 
  {
    # Add log to PowerTool log screen

    $now = Get-Date -Format g
    $txbLogging.Appendtext("$now - $logString`r")
    $txbLogging.Appendtext("$PtLine`r`n")
  }

  #TODO: Use $PsBoundParameters rather than if 
  if($Copy)
  {
    function Copy-PTClipboard 
    {
      # Function to copy text to clipboard
      # Used with CopyLogs function - DO NOT DELETE

      param([Parameter(Mandatory = $true)][string]$text)
      Add-Type -AssemblyName System.Windows.Forms
      $TextBox = New-Object -TypeName System.Windows.Forms.TextBox
      $TextBox.Multiline = $true
      $TextBox.Text = $text
      $TextBox.SelectAll()
      $TextBox.Copy()
    }

    $text = $txbLogging.Text
    #$text = $txb_logs.Text
    Copy-PTClipboard -text $text
  }
  
  function PT-LineSpacer 
  {
    # Add linespacer to logs - for formatting only
    Return
  }
}
