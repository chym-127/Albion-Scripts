# Set-Location -Path $args[0]

$filePath = [String]::Format("{0}main.exe", $args[0])

if (Test-Path $filePath) {
    Remove-Item $filePath
}

$str = [String]::Format("/in {0}main.ahk /out {0}main.exe", $args[0])

Start-Process Ahk2Exe.exe $str -NoNewWindow -Wait 
if (Test-Path $filePath) {
    Start-Process $filePath -NoNewWindow -Wait 
}