# 1. Получаем разрешение экрана Windows
Add-Type -AssemblyName System.Windows.Forms
$screenWidth = [System.Windows.Forms.Screen]::PrimaryScreen.Bounds.Width
$screenHeight = [System.Windows.Forms.Screen]::PrimaryScreen.Bounds.Height

# Адаптивная формула деления экрана пиксель-в-пиксель
$w = [int]($screenWidth / 2)
$h = [int]($screenHeight / 2)

# Список доступных программ
$menu = @{
    1 = @{ Name = "CMatrix (Матрица)";   Cmd = "cmatrix" }
    2 = @{ Name = "Fastfetch (Инфо)";    Cmd = "fastfetch; echo 'Нажми Enter для выхода...'; read" }
    3 = @{ Name = "Btop (Диспетчер)";    Cmd = "btop" }
    4 = @{ Name = "Cava (Музыка)";       Cmd = "cava" }
    5 = @{ Name = "Своя программа";      Cmd = "echo 'In Future...'; read" }
    6 = @{ Name = "[KILL] Закрыть все окна Mintty"; Cmd = "KILL" }
}

# Функция для отображения меню и выбора программы
function Get-UserChoice($PositionName) {
    Clear-Host
    Write-Host "=== Настройка экрана ===" -ForegroundColor Cyan
    Write-Host "Что запустить в угол: [$PositionName]?" -ForegroundColor Yellow
    Write-Host "------------------------"
    
    # Выводим варианты ответов
    foreach ($key in ($menu.Keys | Sort-Object)) {
        Write-Host "$key. $($menu[$key].Name)"
    }
    Write-Host "------------------------"
    
    $choice = 0
    while ($choice -lt 1 -or $choice -gt $menu.Count) {
        $input = Read-Host "Введи номер варианта"
        [int]::TryParse($input, [ref]$choice) | Out-Null
    }
    
    return $menu[$choice].Cmd
}

# Функция жесткого пиксельного запуска окна
function Launch-Window($X, $Y, $LinuxCmd) {
    psexec -i -d C:\msys64\usr\bin\mintty.exe -B void --geometry "${w}x${h}+${X}+${Y}" /usr/bin/bash -lc "$LinuxCmd"
    Start-Sleep -Milliseconds 300
}

# 2. Опрашиваем пользователя для первого угла
$cmdTopLeft = Get-UserChoice "Топ-Лево (Верхний Левый)"

# Если пользователь СРАЗУ выбрал пункт 6 (Убить всё), гасим окна и выходим
if ($cmdTopLeft -eq "KILL") {
    Clear-Host
    Write-Host "Уничтожаю все окна Mintty..." -ForegroundColor Red
    taskkill /F /IM mintty.exe 2>$null
    Exit
}

# Если нет, опрашиваем остальные 3 угла
$cmdTopRight = Get-UserChoice "Топ-Право (Верхний Правый)"
$cmdBotLeft  = Get-UserChoice "Боттом-Лево (Нижний Левый)"
$cmdBotRight = Get-UserChoice "Боттом-Право (Нижний Правый)"

# 3. Финальный запуск всей сетки
Clear-Host
Write-Host "Запуск хакерской панели..." -ForegroundColor Green

Launch-Window 0 0 $cmdTopLeft
Launch-Window $w 0 $cmdTopRight
Launch-Window 0 $h $cmdBotLeft
Launch-Window $w $h $cmdBotRight

