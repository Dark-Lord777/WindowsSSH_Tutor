# 1. Get Screen Resolution
Add-Type -AssemblyName System.Windows.Forms
$screenWidth = [System.Windows.Forms.Screen]::PrimaryScreen.Bounds.Width
$screenHeight = [System.Windows.Forms.Screen]::PrimaryScreen.Bounds.Height

# Adaptive Grid Formula
$w = [int]($screenWidth / 2)
$h = [int]($screenHeight / 2)

# Menu Items (HTOP instead of BTOP + KILL Option)
$menu = @{
    1 = @{ Name = "CMatrix (Matrix Code)";  Cmd = "cmatrix" }
    2 = @{ Name = "Fastfetch (Sys Info)";   Cmd = "fastfetch; echo 'Press Enter to exit...'; read" }
    3 = @{ Name = "Htop (Task Manager)";    Cmd = "htop" }
    4 = @{ Name = "Cava (Music Visualizer)";Cmd = "cava" }
    5 = @{ Name = "My Custom App";          Cmd = "echo 'In Future...'; read" }
    6 = @{ Name = "[KILL] Close All Windows";Cmd = "KILL" }
}

# Menu Function
function Get-UserChoice($PositionName) {
    Clear-Host
    Write-Host "=== SCREEN GRID CONFIG ===" -ForegroundColor Cyan
    Write-Host "Select app for corner: [$PositionName]" -ForegroundColor Yellow
    Write-Host "------------------------"
    
    foreach ($key in ($menu.Keys | Sort-Object)) {
        Write-Host "$key. $($menu[$key].Name)"
    }
    Write-Host "------------------------"
    
    $choice = 0
    while ($choice -lt 1 -or $choice -gt $menu.Count) {
        $input = Read-Host "Enter option number"
        [int]::TryParse($input, [ref]$choice) | Out-Null
    }
    
    return $menu[$choice].Cmd
}


function Launch-Window($X, $Y, $LinuxCmd) {
    if ($LinuxCmd -eq "cava") {
        $LinuxCmd = "cava; echo 'Cava crashed! Press Enter to close...'; read"
    }


    psexec -i -d C:\msys64\usr\bin\mintty.exe -o MSYSTEM=UCRT64 -B void --geometry "${w}x${h}+${X}+${Y}" /usr/bin/bash -lc "$LinuxCmd"
    Start-Sleep -Milliseconds 300
}


# 2. Get choice for the first corner
$cmdTopLeft = Get-UserChoice "TOP-LEFT"

# Instant Kill check: if user selects 6, close everything and exit immediately
if ($cmdTopLeft -eq "KILL") {
    Clear-Host
    Write-Host "Killing all Mintty windows..." -ForegroundColor Red
    taskkill /F /IM mintty.exe 2>$null
    Exit
}

# If not KILL, ask for the remaining 3 corners
$cmdTopRight = Get-UserChoice "TOP-RIGHT"
$cmdBotLeft  = Get-UserChoice "BOTTOM-LEFT"
$cmdBotRight = Get-UserChoice "BOTTOM-RIGHT"

# 3. Final Grid Deployment
Clear-Host
Write-Host "Deploying hacker grid..." -ForegroundColor Green

Launch-Window 0 0 $cmdTopLeft
Launch-Window $w 0 $cmdTopRight
Launch-Window 0 $h $cmdBotLeft
Launch-Window $w $h $cmdBotRight

