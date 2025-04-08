Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# === GLOBALS ===
$AppTitle = "Conzex Development Studio (CDS)"
$AppVersion = "1.5"
$HelpURL = "https://www.conzex.com"
$GitHubURL = "https://github.com/conzex/cds"
$Email = "info@conzex.com"
$LogoPath = "C:\Users\Administrator\Downloads\logo-icon.png"  # Replace if converting to EXE

# === FORM ===
$form = New-Object Windows.Forms.Form
$form.Text = "$AppTitle - Installer"
$form.Size = New-Object Drawing.Size(800, 600)
$form.StartPosition = "CenterScreen"
$form.BackColor = [Drawing.Color]::White

# === Help Menu ===
$menuStrip = New-Object Windows.Forms.MenuStrip

# Help Dropdown
$helpMenu = New-Object Windows.Forms.ToolStripMenuItem("Help")
$helpMenu.DropDownItems.Add("Website", $null, { Start-Process $HelpURL })
$helpMenu.DropDownItems.Add("GitHub", $null, { Start-Process $GitHubURL })
$helpMenu.DropDownItems.Add("Email Us", $null, { Start-Process "mailto:$Email" })
$menuStrip.Items.Add($helpMenu)

# Version label aligned to the right
$versionLabel = New-Object Windows.Forms.ToolStripLabel
$versionLabel.Text = "Version $AppVersion"
$versionLabel.Alignment = 'Right'
$menuStrip.Items.Add($versionLabel)

$form.MainMenuStrip = $menuStrip
$form.Controls.Add($menuStrip)

# === LOGO ===
if (Test-Path $LogoPath) {
    $logoBox = New-Object Windows.Forms.PictureBox
    $logoBox.Image = [System.Drawing.Image]::FromFile($LogoPath)
    $logoBox.SizeMode = 'Zoom'
    $logoBox.Size = New-Object Drawing.Size(40, 40)
    $logoBox.Location = New-Object Drawing.Point(20, 35)
    $form.Controls.Add($logoBox)
}

# === LABEL ===
$titleLabel = New-Object Windows.Forms.Label
$titleLabel.Text = "$AppTitle Installer"
$titleLabel.Font = New-Object Drawing.Font("Segoe UI", 18, [Drawing.FontStyle]::Bold)
$titleLabel.AutoSize = $true
$titleLabel.Location = New-Object Drawing.Point(70, 40)  # Adjusted to align with logo
$form.Controls.Add($titleLabel)

# === Console Box ===
$consoleBox = New-Object Windows.Forms.TextBox
$consoleBox.Multiline = $true
$consoleBox.ScrollBars = "Vertical"
$consoleBox.BackColor = "#f0f0f0"
$consoleBox.ReadOnly = $true
$consoleBox.Font = 'Consolas, 10pt'
$consoleBox.Size = New-Object Drawing.Size(740, 200)
$consoleBox.Location = New-Object Drawing.Point(20, 120)
$form.Controls.Add($consoleBox)

# === Progress Bar ===
$progressBar = New-Object Windows.Forms.ProgressBar
$progressBar.Style = 'Continuous'
$progressBar.Width = 740
$progressBar.Height = 20
$progressBar.Location = New-Object Drawing.Point(20, 340)
$form.Controls.Add($progressBar)

# === Install Button ===
$btnInstall = New-Object Windows.Forms.Button
$btnInstall.Text = "Install Environment"
$btnInstall.Font = "Segoe UI, 11pt"
$btnInstall.Size = New-Object Drawing.Size(200, 40)
$btnInstall.Location = New-Object Drawing.Point(20, 380)
$form.Controls.Add($btnInstall)

# === Function to Log to Console Box ===
function Write-Log($text) {
    $consoleBox.AppendText("[$(Get-Date -f 'HH:mm:ss')] $text`r`n")
}

# === Function to Show Completion Popup ===
function Show-SuccessPopup {
    [System.Windows.Forms.MessageBox]::Show("Development environment setup completed successfully!", "$AppTitle", 'OK', 'Information')
}

# === Installation Logic ===
$btnInstall.Add_Click({
    $btnInstall.Enabled = $false
    $progressBar.Value = 0
    $steps = 10
    $i = 0

    # Step 1: Check prerequisites
    Write-Log "Checking prerequisites..."
    $i++
    $progressValue = [math]::Min(($i * 100 / $steps), 100)
    $progressBar.Value = $progressValue

    # Step 2: Chocolatey check or install
    Write-Log "Checking/Installing Chocolatey..."
    if (!(Get-Command choco.exe -ErrorAction SilentlyContinue)) {
        Set-ExecutionPolicy Bypass -Scope Process -Force
        [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
        Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
        Write-Log "Chocolatey installed."
    } else {
        Write-Log "Chocolatey already installed."
    }
    $i++; $progressBar.Value = ($i * 100 / $steps)

    # Step 3+: Install packages
    $packages = @(
        "git", "python", "cmake", "wix", "filezilla", "filezilla.server",
        "xampp", "googlechrome", "nodejs-lts", "putty", "windows-sdk-10-version-2104-all", "winrar", "ps2exe"
    )

    foreach ($pkg in $packages) {
        Write-Log "Installing $pkg..."
        Start-Process -Wait powershell -ArgumentList "-Command choco install $pkg -y --ignore-checksums" -WindowStyle Hidden
        $i++
        $progressValue = [math]::Min([int](($i * 100) / $steps), 100)
        $progressBar.Value = $progressValue
    }

    # Final step
    Write-Log "Installation complete!"
    $progressBar.Value = 100
    Show-SuccessPopup
})

# === Run Form ===
$form.Topmost = $true
[void]$form.ShowDialog()
