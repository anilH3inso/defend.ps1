# This is window Powershell script called defend.ps1
# madeby Anil Budthapa.

# Function to install gpg4win using Chocolatey
Function InstallGPG {
    Write-Output "Installing gpg4win using Chocolatey..."
    choco install gpg4win -y
}

# Function to set up GPG key
Function SetupGPG {
    Write-Output "Setting up GPG key..."
    & 'C:\Program Files (x86)\GnuPG\bin\gpg.exe' --generate-key
    # Additional prompts may be required to input details like name and email
}

# Function to backup files
function Backup {
    # Prompt user to enter source folder path
    $sourceFile = Read-Host "Enter the path to the source file"
    # Prompt user to enter backup folder path
    $backupFile = ".\Backup"
    # Path to the gpg executable
    $gpgPath = "C:\Program Files (x86)\GnuPG\bin\gpg.exe"
    Write-Output "Backing up files..."

    # Prompt user for recipient email
    $recipientEmail = Read-Host "Enter the recipient's email for encryption"

    # Iterate through files in source folder
    Get-ChildItem $sourceFile | ForEach-Object {
        $outputFile = "$backupFile\$($_.Name).gpg"
        # Encrypt each file using GPG and store in the backup folder
        & $gpgPath --output $outputFile --encrypt --recipient $recipientEmail $_.FullName
    }
    Write-Output "Backup completed."
}

# Function to restore files
function Restore {
    # Prompt user to enter backup folder path
    $backupFile = ".\Backup"
    # Prompt user to enter restore folder path
    $restoredFile = ".\Restore"
    # Path to the gpg executable
    $gpgPath = "C:\Program Files (x86)\GnuPG\bin\gpg.exe"
    Write-Output "Restoring files..."
    # Iterate through files in backup folder
    Get-ChildItem $backupFile | ForEach-Object {
        $outputFile = "$restoredFile\$($_.BaseName)"
        # Decrypt each file using GPG and save in the restored folder
        & $gpgPath --output $outputFile --decrypt $_.FullName
    }
    Write-Output "Restoration completed."
}

# Capture command line arguments
$data = $args

# Switch statement to execute appropriate function based on command line argument
Switch ($data[0]) {
    "installGPG" { InstallGPG }
    "setupGPG" { SetupGPG }
    "backup" { Backup }
    "restore" { Restore }
    Default { Write-Output "Invalid action specified." }
}

# Call PSScriptAnalyzer to clean up code
Invoke-ScriptAnalyzer defend.ps1
