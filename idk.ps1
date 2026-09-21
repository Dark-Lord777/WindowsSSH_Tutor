# Menu Items
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
        Write-Host "$key.$($menu[$key].Name)"
    }
    Write-Host "------------------------"
    
    $choice = 0
    while ($choice -lt 1 -or$choice -gt $menu.Count) {$input = Read-Host "Enter option number"
        [int]::TryParse($input, [ref]$choice) | Out-Null
    }
    
    return $menu[$choice].Cmd
}

# 1. Get user choices for all 4 corners
$cmdTopLeft = Get-UserChoice "TOP-LEFT"

# Instant Kill check
if ($cmdTopLeft -eq "KILL") {
    Clear-Host
    Write-Host "Killing all Windows Terminal instances..." -ForegroundColor Red
    taskkill /F /IM WindowsTerminal.exe 2>$null
    Exit
}

$cmdTopRight = Get-UserChoice "TOP-RIGHT"
$cmdBotLeft  = Get-UserChoice "BOTTOM-LEFT"
$cmdBotRight = Get-UserChoice "BOTTOM-RIGHT"

# 2. Fix cava crash handling inline
if ($cmdTopLeft  -eq "cava") { $cmdTopLeft  = "cava; echo 'Cava crashed! Press Enter...'; read" }
if ($cmdTopRight -eq "cava") { $cmdTopRight = "cava; echo 'Cava crashed! Press Enter...'; read" }
if ($cmdBotLeft  -eq "cava") { $cmdBotLeft  = "cava; echo 'Cava crashed! Press Enter...'; read" }
if ($cmdBotRight -eq "cava") { $cmdBotRight = "cava; echo 'Cava crashed! Press Enter...'; read" }

# 3. Base execution command for MSYS2 UCRT64 environment
$envCmd = "C:\msys64\usr\bin\env.exe MSYSTEM=UCRT64 PATH=/ucrt64/bin:/usr/bin:`$PATH /usr/bin/bash.exe -lc"

Clear-Host
Write-Host "Deploying GPU-accelerated 2x2 grid in Fullscreen..." -ForegroundColor Green

# 4. Execute wt.exe in Fullscreen (-f) with exact split sequence
wt.exe -F `
  new-tab $envCmd "$cmdTopLeft" `; `
  split-pane -V $envCmd "$cmdTopRight" `; `
  move-focus left `; `
  split-pane -H $envCmd "$cmdBotLeft" `; `
  move-focus right `; `
  split-pane -H $cmdBotRight

