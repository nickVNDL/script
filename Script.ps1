# PowerShell скрипт для сбора информации о системных компонентах и их драйверах, включая видеокарту

# Создаем объект для хранения информации
$systemInfo = @{}

# Получаем информацию о видеокарте
$videoCard = Get-WmiObject -Class Win32_VideoController
$systemInfo.VideoCard = @{
    Name = $videoCard.Name
    Manufacturer = $videoCard.Manufacturer
    Version = $videoCard.Version
    CurrentDriverVersion = $videoCard.DriverVersion
}

# Получаем актуальную версию драйвера видеокарты
$manufacturer = $videoCard.Manufacturer
if ($manufacturer -eq "NVIDIA") {
    $url = "https://www.nvidia.com/Download/index.aspx?lang=en-us"
    $response = Invoke-WebRequest -Uri $url
    $html = $response.Content
    $driverVersion = ($html | Select-String -Pattern "Version: (\d+\.\d+\.\d+)").Matches[0].Groups[1].Value
    $systemInfo.VideoCard.NewDriverVersion = $driverVersion
}
elseif ($manufacturer -eq "Intel") {
    $url = "https://downloadcenter.intel.com/product/$($videoCard.Name)"
    $response = Invoke-WebRequest -Uri $url
    $html = $response.Content
    $driverVersion = ($html | Select-String -Pattern "Version: (\d+\.\d+\.\d+)").Matches[0].Groups[1].Value
    $systemInfo.VideoCard.NewDriverVersion = $driverVersion
}
elseif ($manufacturer -eq "AMD") {
    $url = "https://www.amd.com/en/support/kb/release-notes/rn-amdgpu-win-$($videoCard.Name)"
    $response = Invoke-WebRequest -Uri $url
    $html = $response.Content
    $driverVersion = ($html | Select-String -Pattern "Version: (\d+\.\d+\.\d+)").Matches[0].Groups[1].Value
    $systemInfo.VideoCard.NewDriverVersion = $driverVersion
}

# Сохраняем информацию в файл
$filePath = "C:\Users\Nicks\system_info.txt"
$systemInfo | ConvertTo-Json | Out-File -FilePath $filePath -Encoding Default

Write-Host "Информация о системных компонентах и их драйверах сохранена в файл $filePath"
