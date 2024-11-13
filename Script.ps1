# PowerShell скрипт для сбора информации о системных компонентах и их драйверах

# Создаем объект для хранения информации
$systemInfo = @{}

# Получаем информацию о процессоре
$processor = Get-WmiObject -Class Win32_Processor
$systemInfo.Processor = @{
    Name = $processor.Name
    Manufacturer = $processor.Manufacturer
    Version = $processor.Version
    DriverVersion = $processor.DriverVersion
}

# Получаем информацию о видеокарте
$videoCard = Get-WmiObject -Class Win32_VideoController
$systemInfo.VideoCard = @{
    Name = $videoCard.Name
    Manufacturer = $videoCard.Manufacturer
    Version = $videoCard.Version
    DriverVersion = $videoCard.DriverVersion
}

# Получаем информацию о материнской плате
$motherboard = Get-WmiObject -Class Win32_BaseBoard
$systemInfo.Motherboard = @{
    Name = $motherboard.Product
    Manufacturer = $motherboard.Manufacturer
    Version = $motherboard.Version
    DriverVersion = $motherboard.DriverVersion
}

# Получаем информацию о драйверах
$drivers = Get-WmiObject -Class Win32_PnPSignedDriver
$systemInfo.Drivers = @()
foreach ($driver in $drivers) {
    $systemInfo.Drivers += @{
        Name = $driver.DeviceName
        Manufacturer = $driver.Manufacturer
        Version = $driver.DriverVersion
        Date = $driver.DriverDate
    }
}

# Сохраняем информацию в файл
$filePath = "C:\system_info.txt"
$systemInfo | ConvertTo-Json | Out-File -FilePath $filePath -Encoding utf8

Write-Host "Информация о системных компонентах и их драйверах сохранена в файл $filePath"
