$filePath = "./main.exe"
if (Test-Path $filePath) {
    Remove-Item $filePath
}
Start-Process Ahk2Exe.exe '/in .\main.ahk /out .\main.exe' -NoNewWindow -Wait 
if (Test-Path $filePath) {
    Start-Process .\main.exe -NoNewWindow -Wait 
}