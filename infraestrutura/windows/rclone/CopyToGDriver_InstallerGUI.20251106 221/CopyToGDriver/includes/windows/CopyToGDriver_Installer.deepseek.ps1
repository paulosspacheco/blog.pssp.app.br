# ===========================================================
# Projeto: CopyToGDriver
# Script: CopyToGDriver_Installer.ps1 (v2.2.2)
# Função: Instalador automatizado completo (Windows - Git Bash)
# ===========================================================
# ===========================================================
# CopyToGDriver Installer (Windows)
# ===========================================================

param(
    [string]$path,
    [string]$parameters = ""
)

# Initialize
Write-Host "CopyToGDriver Installer" -ForegroundColor Cyan
Write-Host "=======================" -ForegroundColor Cyan

$DefaultBase = "C:\scripts"
$UserProfile = [Environment]::GetFolderPath("UserProfile")
$ConfigDir = Join-Path $UserProfile ".copytogdriver"
$RecordFile = Join-Path $ConfigDir "install_record.json"
$LogFile = Join-Path $ConfigDir "install_log.txt"
$InstallPathFile = Join-Path $ConfigDir "install_path.txt"

# Create config directory
if (-not (Test-Path $ConfigDir)) {
    New-Item -ItemType Directory -Path $ConfigDir -Force | Out-Null
}

# Log function
function Write-Log {
    param([string]$Message)
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $line = "[$timestamp] $Message"
    Add-Content -Path $LogFile -Value $line
    Write-Host $line
}

Write-Log "Starting CopyToGDriver installation"

# Process parameters
$ScriptParams = @{}
if ($parameters) {
    Write-Log "Parameters: $parameters"
    $paramArray = $parameters -split '\s+'
    foreach ($param in $paramArray) {
        if ($param -match '^--([^=]+)=(.+)$') {
            $ScriptParams[$Matches[1]] = $Matches[2]
        } elseif ($param -match '^--(.+)$') {
            $ScriptParams[$Matches[1]] = $true
        }
    }
}

function Test-Parameter {
    param([string]$Name)
    return $ScriptParams.ContainsKey($Name) -and $ScriptParams[$Name] -eq $true
}

# Set target directory
if ($path) {
    $TargetDir = $path
    Write-Log "Custom path: $TargetDir"
} else {
    $TargetDir = Join-Path $DefaultBase "CopyToGDriver"
    Write-Log "Default path: $TargetDir"
}

# Create target directory
if (-not (Test-Path $TargetDir)) {
    New-Item -ItemType Directory -Path $TargetDir -Force | Out-Null
    Write-Log "Created directory: $TargetDir"
}

# Save installation path
Set-Content -Path $InstallPathFile -Value $TargetDir -Encoding UTF8
Write-Log "Installation path saved"

# Set environment variable
[Environment]::SetEnvironmentVariable("COPYTOGDRIVER_PATH", $TargetDir, "User")
Write-Log "Environment variable set"

# Download function
function Download-File {
    param([string]$url, [string]$dest, [string]$label)
    try {
        Write-Log "Downloading $label"
        Invoke-WebRequest -Uri $url -OutFile $dest -UseBasicParsing
        if (Test-Path $dest) {
            Write-Log "Download completed: $label"
            return $true
        }
        return $false
    } catch {
        Write-Log "Download failed: $label - $($_.Exception.Message)"
        return $false
    }
}

# Git Bash installation
function Install-GitBash {
    Write-Log "Installing Git Bash"
    $installer = Join-Path $env:TEMP "Git-Installer.exe"
    $url = "https://github.com/git-for-windows/git/releases/download/v2.42.0.windows.2/Git-2.42.0.2-64-bit.exe"

    if (Download-File $url $installer "Git Bash") {
        $process = Start-Process -FilePath $installer -ArgumentList @("/VERYSILENT", "/NORESTART", "/NOCANCEL") -Wait -PassThru
        Start-Sleep -Seconds 10
        if ($process.ExitCode -eq 0) {
            Write-Log "Git Bash installed successfully"
            Remove-Item $installer -Force -ErrorAction SilentlyContinue
            return $true
        }
    }
    Write-Log "Git Bash installation failed"
    return $false
}

# Check Git Bash
function Get-GitBashPath {
    $paths = @(
        "C:\Program Files\Git\bin\bash.exe",
        "C:\Program Files (x86)\Git\bin\bash.exe"
    )
    foreach ($p in $paths) {
        if (Test-Path $p) {
            return $p
        }
    }
    return $null
}

Write-Log "Checking Git Bash"
$gitbashPresent = $false
$gitBashPath = Get-GitBashPath
$gitbashInstalled = $false

if (Get-Command bash.exe -ErrorAction SilentlyContinue) {
    Write-Log "Git Bash found in PATH"
    $gitbashPresent = $true
} elseif ($gitBashPath) {
    Write-Log "Git Bash found at: $gitBashPath"
    $gitbashPresent = $true
} else {
    Write-Log "Git Bash not found"
    if (Test-Parameter "auto-install-gitbash") {
        Write-Log "Auto-installing Git Bash"
        $gitbashPresent = Install-GitBash
        $gitbashInstalled = $gitbashPresent
    } else {
        Write-Log "Please install Git Bash manually from: https://git-scm.com/download/win"
    }
}

# Install Rclone
$rcloneInstalled = $false
if (-not (Get-Command rclone.exe -ErrorAction SilentlyContinue)) {
    if (Test-Parameter "auto-install-rclone") {
        Write-Log "Installing Rclone"
        $tempZip = Join-Path $env:TEMP "rclone.zip"
        $url = "https://downloads.rclone.org/rclone-current-windows-amd64.zip"

        if (Download-File $url $tempZip "Rclone") {
            Expand-Archive -Path $tempZip -DestinationPath $env:TEMP -Force
            $exe = Get-ChildItem -Path $env:TEMP -Filter "rclone.exe" -Recurse | Select-Object -First 1
            if ($exe) {
                Copy-Item $exe.FullName "C:\Windows\System32\" -Force
                Write-Log "Rclone installed to System32"
                $rcloneInstalled = $true
            }
            Remove-Item $tempZip -Force -ErrorAction SilentlyContinue
        }
    } else {
        Write-Log "Rclone not found. Install from: https://rclone.org/downloads/"
    }
} else {
    Write-Log "Rclone already installed"
}

# Configure Rclone remote
if (Test-Parameter "auto-config-remote") {
    Write-Log "Configuring Rclone remote"
    try {
        $existing = rclone listremotes 2>$null
        if ($existing -notmatch "^gdriver:") {
            rclone config create gdriver drive | Out-Null
            Write-Log "Rclone remote 'gdriver' created"
        } else {
            Write-Log "Rclone remote 'gdriver' already exists"
        }
    } catch {
        Write-Log "Failed to configure Rclone remote"
    }
} else {
    Write-Log "Rclone remote configuration skipped"
}

# Copy project files
Write-Log "Copying project files"
try {
    $scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
    $projectRoot = Join-Path $scriptDir ".."
    $resolvedRoot = Resolve-Path $projectRoot

    Get-ChildItem -Path $resolvedRoot -Include "*.sh", "*.ps1", "*.bat", "*.md", "*.txt" -Recurse | ForEach-Object {
        $relativePath = $_.FullName.Substring($resolvedRoot.Path.Length + 1)
        $destPath = Join-Path $TargetDir $relativePath
        $destDir = Split-Path $destPath -Parent

        if (-not (Test-Path $destDir)) {
            New-Item -ItemType Directory -Path $destDir -Force | Out-Null
        }

        Copy-Item $_.FullName $destPath -Force
    }
    Write-Log "Files copied successfully"
} catch {
    Write-Log "Failed to copy files: $($_.Exception.Message)"
}

# Configure bash aliases
if ($gitbashPresent) {
    Write-Log "Configuring bash aliases"
    $bashrc = Join-Path $UserProfile ".bashrc"
    $bashPath = $TargetDir -replace "\\", "/" -replace "C:", "/c"

    $content = @()
    if (Test-Path $bashrc) {
        $content = Get-Content $bashrc
    }

    # Remove old aliases
    $newContent = $content | Where-Object {
        $_ -notmatch "CopyToGDriver" -and
        $_ -notmatch "copydrive" -and
        $_ -notmatch "copycheck" -and
        $_ -notmatch "copyrestore"
    }

    # Add new aliases
    $newContent += ""
    $newContent += "# CopyToGDriver Aliases"
    $newContent += "alias copydrive='$bashPath/CopyToGDriver_CopyCurrent.sh'"
    $newContent += "alias copycheck='$bashPath/CopyToGDriver.sh --check-only'"
    $newContent += "alias copyrestore='$bashPath/CopyToGDriver_Restore.sh'"
    $newContent += "export COPYTOGDRIVER_PATH='$bashPath'"

    $newContent | Out-File $bashrc -Encoding utf8
    Write-Log "Bash aliases configured"
}

# Windows context menu
Write-Log "Adding to Windows context menu"
try {
    $menuKey = "HKCU:\Software\Classes\*\shell\CopyToGDriver"
    $commandKey = "$menuKey\command"

    if (-not (Test-Path $menuKey)) {
        New-Item -Path $menuKey -Force | Out-Null
    }
    if (-not (Test-Path $commandKey)) {
        New-Item -Path $commandKey -Force | Out-Null
    }

    Set-ItemProperty -Path $menuKey -Name "(Default)" -Value "Send to Google Drive" -Force
    Set-ItemProperty -Path $commandKey -Name "(Default)" -Value "`"$TargetDir\CopyToGDriver.sh`" `"%1`"" -Force
    Write-Log "Context menu entry added"
} catch {
    Write-Log "Failed to add context menu entry"
}

# Save installation record
$installInfo = @{
    installed_on = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    path = $TargetDir
    user = $env:USERNAME
    rclone_installed = (Get-Command rclone.exe -ErrorAction SilentlyContinue) -ne $null
    gitbash_installed = $gitbashPresent
    rclone_auto_installed = $rcloneInstalled
    gitbash_auto_installed = $gitbashInstalled
}

$installInfo | ConvertTo-Json | Out-File $RecordFile -Encoding UTF8
Write-Log "Installation record saved"

# Completion
Write-Host ""
Write-Host "Installation completed!" -ForegroundColor Green
Write-Host "Location: $TargetDir" -ForegroundColor White
Write-Host "Git Bash: $(if ($gitbashPresent) {'Ready'} else {'Not found'})" -ForegroundColor White
Write-Host "Rclone: $(if (Get-Command rclone.exe -ErrorAction SilentlyContinue) {'Ready'} else {'Not found'})" -ForegroundColor White
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Cyan
Write-Host "1. Open Git Bash" -ForegroundColor White
Write-Host "2. Run: copydrive --help" -ForegroundColor White
Write-Host "=======================" -ForegroundColor Cyan

exit 0
