$systemInfo = @{}

# Процессор
$processor = Get-WmiObject -Class Win32_Processor
$systemInfo.Processor = @{
    Name = $processor.Name
    Manufacturer = $processor.Manufacturer
}

# Видеокарта
$videoCard = Get-WmiObject -Class Win32_VideoController
$systemInfo.VideoCard = @{
    Name = $videoCard.Name
    Manufacturer = $videoCard.Manufacturer
    Version = $videoCard.Version
    DriverVersion = $videoCard.DriverVersion
}

#  Материнская плата
$motherboard = Get-WmiObject -Class Win32_BaseBoard
$systemInfo.Motherboard = @{
    Name = $motherboard.Product
    Manufacturer = $motherboard.Manufacturer
    Version = $motherboard.Version
    DriverVersion = $motherboard.DriverVersion
}


$filePath = "C:\Users\Nicks\system_info.txt"
$systemInfo | ConvertTo-Json | Out-File -FilePath $filePath -Encoding default

Write-Host "Информация о системных компонентах и их драйверах сохранена в файл $filePath"
