param(
  [string]$ProjectRoot = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
)

$ErrorActionPreference = 'Stop'

$cmakePath = Join-Path $ProjectRoot 'windows\CMakeLists.txt'
$resourcePath = Join-Path $ProjectRoot 'windows\runner\Runner.rc'
$iconSource = Join-Path $ProjectRoot 'assets\branding\homework.ico'
$iconTarget = Join-Path $ProjectRoot 'windows\runner\resources\app_icon.ico'
$generatedWidgetTest = Join-Path $ProjectRoot 'test\widget_test.dart'

foreach ($requiredPath in @($cmakePath, $resourcePath, $iconSource)) {
  if (-not (Test-Path $requiredPath)) {
    throw "Không tìm thấy tệp bắt buộc: $requiredPath"
  }
}

$cmake = Get-Content $cmakePath -Raw
$cmake = $cmake -replace 'set\(BINARY_NAME "homework"\)', 'set(BINARY_NAME "HomeWork")'
Set-Content -Path $cmakePath -Value $cmake -Encoding utf8

$resource = Get-Content $resourcePath -Raw
$resource = $resource -replace 'VALUE "CompanyName", ".*?" "\\0"', 'VALUE "CompanyName", "Base27-CVNSS" "\0"'
$resource = $resource -replace 'VALUE "FileDescription", ".*?" "\\0"', 'VALUE "FileDescription", "HomeWork Workspace" "\0"'
$resource = $resource -replace 'VALUE "InternalName", ".*?" "\\0"', 'VALUE "InternalName", "HomeWork" "\0"'
$resource = $resource -replace 'VALUE "OriginalFilename", ".*?" "\\0"', 'VALUE "OriginalFilename", "HomeWork.exe" "\0"'
$resource = $resource -replace 'VALUE "ProductName", ".*?" "\\0"', 'VALUE "ProductName", "HomeWork" "\0"'
Set-Content -Path $resourcePath -Value $resource -Encoding utf8

Copy-Item -Path $iconSource -Destination $iconTarget -Force

if (Test-Path $generatedWidgetTest) {
  $widgetTestContent = Get-Content $generatedWidgetTest -Raw
  if ($widgetTestContent -match 'const MyApp\(\)') {
    Remove-Item $generatedWidgetTest -Force
    Write-Host 'Đã loại bỏ widget_test.dart mẫu do Flutter tự sinh.'
  }
}

Write-Host 'Đã cấu hình tên, metadata và icon Windows cho HomeWork.'
