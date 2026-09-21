<!--www.flamingtext.com-->
<div align="center">
  <img
    width="80%"
    max-width="600px"
    style="max-width: 100%; height: auto;"
    alt="image"
    src="https://github.com/user-attachments/assets/958ab0a6-052f-491a-8d4b-413a0ce74b6f"
  />


</div>


Okey Let's go

Install this
(This utils can help you create a bridge beetween virtual space OpenSSH and UserSpace)
RUN STRICTLY ROOT(ADMIN POWERSHELL) 
```
Invoke-WebRequest -Uri "https://download.sysinternals.com/files/PSTools.zip" -OutFile "$env:TEMP\PSTools.zip"; Expand-Archive -Path "$env:TEMP\PSTools.zip" -DestinationPath "C:\Windows\System32" -Force; & psexec /accepteula
```

Okey Some commands

Launch Terminal

```
psexec -i -d C:\msys64\usr\bin\mintty.exe /usr/bin/bash -lc "cmatrix"
```
Maybe work 
```
# 1. Подгружаем библиотеку для работы с графическим интерфейсом винды
Add-Type -AssemblyName System.Windows.Forms

# 2. Берем ширину и высоту первичного (основного) монитора
$screenWidth = [System.Windows.Forms.Screen]::PrimaryScreen.Bounds.Width
$screenHeight = [System.Windows.Forms.Screen]::PrimaryScreen.Bounds.Height

# 3. Считаем размеры для одного квадранта (делим экран пополам)
# Вычитаем по 40-50 пикселей на высоту, чтобы окна не залезали под панель задач винды
$w = [int]($screenWidth / 2)
$h = [int](($screenHeight - 50) / 2)

# 4. Вычисляем координаты точек перегиба сетки
$rightX = $w
$bottomY = $h

# 5. Запускаем 4 окна Mintty по вычисленным пикселям
# Топ-Лево
psexec -i -d C:\msys64\usr\bin\mintty.exe -p 0,0 -s $w,$h /usr/bin/bash -lc "cmatrix"

# Топ-Право
psexec -i -d C:\msys64\usr\bin\mintty.exe -p $rightX,0 -s $w,$h /usr/bin/bash -lc "cmatrix"

# Боттом-Лево
psexec -i -d C:\msys64\usr\bin\mintty.exe -p 0,$bottomY -s $w,$h /usr/bin/bash -lc "cmatrix"

# Боттом-Право
psexec -i -d C:\msys64\usr\bin\mintty.exe -p $rightX,$bottomY -s $w,$h /usr/bin/bash -lc "cmatrix"

```
Stop Procces

```
Stop-Process -Name mintty -Force
```
```
git clone https://github.com/Dark-Lord777/FirstApp
cd FirstApp
make build && make run
```
```
# 1. Запрашиваем точное разрешение экрана у винды
Add-Type -AssemblyName System.Windows.Forms
$screenWidth = [System.Windows.Forms.Screen]::PrimaryScreen.Bounds.Width
$screenHeight = [System.Windows.Forms.Screen]::PrimaryScreen.Bounds.Height

# 2. Чистая адаптивная формула: делим экран строго пополам
$w = [int]($screenWidth / 2)
$h = [int]($screenHeight / 2)

# Функция запуска через правильный параметр --geometry
function Launch-Pixel-Matrix($X, $Y) {
    # Формируем строку геометрии в формате: {Ширина}x{Высота}+{X}+{Y}
    # Флаг -B void убирает рамки, чтобы окна слились в монолит
    psexec -i -d C:\msys64\usr\bin\mintty.exe -B void --geometry "${w}x${h}+${X}+${Y}" /usr/bin/bash -lc "cmatrix"
    Start-Sleep -Milliseconds 300 # Микропауза, чтобы менеджер окон Windows (DWM) не сходил с ума
}

# 3. Распределяем по 4 квадрантам без зазоров
Launch-Pixel-Matrix 0 0                 # Топ-Лево
Launch-Pixel-Matrix $w 0                 # Топ-Право
Launch-Pixel-Matrix 0 $h                 # Боттом-Лево
Launch-Pixel-Matrix $w $h                 # Боттом-Право

```
