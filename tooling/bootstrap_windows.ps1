$ErrorActionPreference = 'Stop'
$projectRoot = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path

if (-not (Get-Command flutter -ErrorAction SilentlyContinue)) {
  throw 'Chưa tìm thấy Flutter trong PATH. Cài Flutter stable rồi chạy lại.'
}

Push-Location $projectRoot
try {
  flutter config --enable-windows-desktop
  flutter create --platforms=windows --org=vn.base27 --project-name=homework .
  & (Join-Path $PSScriptRoot 'configure_windows.ps1') -ProjectRoot $projectRoot
  flutter pub get
  Write-Host 'HomeWork đã sẵn sàng. Chạy: flutter run -d windows'
} finally {
  Pop-Location
}
