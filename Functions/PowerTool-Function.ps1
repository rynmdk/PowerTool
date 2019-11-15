<#

    .NAME
        PowerTool-Functions

    .VERSION
        0.1

    .DESCRIPTION
        Functions required for ..\PowerTool.ps1

    .LICENSE
        MIT License

#>

Set-Location $PSScriptRoot

# Main Functions
function PT-Connect {

    # Connect to remote workstation

    PT-ClearLog
    PT-DisableRemoteTools

    if (!($txbHostname.text -eq "") ) {

        if (!($txbIPAddress.Text -eq "") ) {

            # Warning as both IP and hostname have been entered
            PT-LogWrite "Please enter ONLY a Hostname or IP Address and try again."
            return 

        } else {

            # Set hostname up as a global variable based on the hostname entry and set its text to uppercase
            $global:hostname = $txbHostname.text.toupper()
        }

    } else {

        # Set hostname up as a global variable based on the IP Address entry and set its text to uppercase
        $global:hostname = $txbIPAddress.text.toupper()
    }

    if ($hostname -eq "") {
    
        PT-LogWrite "No Computer Name entered. Please enter a valid Computer Name / IP Address"

    } else {
    
        $TestConnection = Test-Connection -ComputerName $hostname -Count 1 -BufferSize 16 -ErrorAction SilentlyContinue
    
        if (!($TestConnection)) {

            PT-LogWrite "Unable to Connect to $hostname"

        } else {

            try {
    
                # Get target hostname
                $MachineName = Get-WmiObject -Class win32_computersystem -ComputerName $hostname
         
                # Compare entered hostname to target hostname to ensure no DNS issue
                if ((!($hostname -like "*.*")) -and ($MachineName.name -ne $hostname)) {

                    # Stop processing as DNS issue occured
                    PT-ClearLog
                    PT-DisableRemoteTools
                    PT-LogWrite "DNS issue encountered connecting to $hostname"    
                                   
                } else {
     
                    PT-ClearLog
                    PT-EnableRemoteTools
                    PT-LogWrite "Successfully connected to $hostname"
                
                }

            } catch {

                PT-ClearLog
                PT-LogWrite "Unable to connect to $hostname"

            }

        }

    }

}

function PT-ClearLog {

    # Clear PowerTool Log

    $txbLogging.clear()

}

function PT-CopyClipboard {
    
    # Function to copy text to clipboard
    # Used with CopyLogs function - DO NOT DELETE

    param([string]$text)
	Add-Type -AssemblyName System.Windows.Forms
	$tb = New-Object System.Windows.Forms.TextBox
	$tb.Multiline = $true
	$tb.Text = $text
	$tb.SelectAll()
	$tb.Copy()	

}

function PT-CopyLogs {
    
    # Function to copy logs to clipboard
    # Copy-Clipboard required

    $Text = $txb_logs.Text
    PT-CopyClipboard -text $Text
    PT-LogWrite "Log copied to clipboard"

}

function PT-LogWrite {

    # Add log to PowerTool log screen

    Param ([string]$logString)
    $now = Get-Date -Format g
    $txbLogging.Appendtext("$now - $logString `r`n")


    # Create external logs
    New-Item -Path ..\ -Name "Logs" -ItemType Directory -ErrorAction Ignore
    $date = (Get-Date).ToString("dd-MM-yyyy")
    $now = '{0:HH:mm:ss}' -f (get-date)
    $Log = "..\Logs\"+$env:USERNAME+"-"+$date+"-"+$hostname+".log"
    Add-Content $log -Value "$now - $logstring" -Force

}

function PT-LineSpacer {

    # Add linespacer to logs - for formatting only

    $txbLogging.Appendtext("-------------------------------------------------------------------------------------------------------------`r`n")

}

function PT-EnableRemoteTools {

    # Enable Remote Tools & Dropdowns

    $computerInformationDropdown.Visible = $True
    $fixesDropdown.Visible = $True
    $appvDropdown.Visible = $True
    $applicationsDropdown.Visible = $True

    $tools_remote_Explorer.Enabled = $True
    $tools_remote_Services.Enabled = $True
    $tools_remote_Ping.Enabled = $True

}

function PT-DisableRemoteTools {

    # Disable Remote Tools & Dropdowns

    $computerInformationDropdown.Visible = $False
    $fixesDropdown.Visible = $False
    $appvDropdown.Visible = $False
    $applicationsDropdown.Visible = $False

    $tools_remote_Explorer.Enabled = $False
    $tools_remote_Services.Enabled = $False
    $tools_remote_Ping.Enabled = $False

}

# Admin Tools
function PT-FileExplorer {

    Start-Process explorer.exe
    PT-LogWrite "File Explorer launched"
    PT-LineSpacer

}

function PT-Services {

    Start-Process services.msc
    PT-LogWrite "Services.msc launched"
    PT-LineSpacer

}

function PT-Regedit {

    Start-Process regedit
    PT-LogWrite "Regedit launched"
    PT-LineSpacer

}

function PT-PowerShell {

    Start-Process powershell
    PT-LogWrite "PowerShell launched"
    PT-LineSpacer

}

function PT-CMD {

    Start-Process cmd
    PT-LogWrite "CMD launched"
    PT-LineSpacer

}

function PT-DeviceManager {

    Start-Process devmgmt
    PT-LogWrite "Device Manager launched"
    PT-LineSpacer

}

function PT-EventViewer {

    Start-Process eventvwr
    PT-LogWrite "Event Viewer launched"
    PT-LineSpacer

}

function PT-SystemSettings {

    Start-Process sysdm.cpl
    PT-LogWrite "Advanced System Settings launched"
    PT-LineSpacer

}

function PT-RemoteExplorer {

    ii \\$hostname\c$\
    PT-LogWrite "File Explorer launched for $hostname"
    PT-LineSpacer

}

function PT-RemoteServices {

    services.msc /computer=$hostname
    PT-LogWrite "Services.msc launched for $hostname"
    PT-LineSpacer

}

function PT-RemotePing {

    Start-Process ping.exe -ArgumentList "$hostname -n 300"
    PT-LogWrite "Ping launched for $hostname"
    PT-LineSpacer

}

# Account Information

# Computer Information

# Scripts

# Applications

# App-V