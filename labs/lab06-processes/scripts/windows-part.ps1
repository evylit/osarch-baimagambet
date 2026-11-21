# Lab 6 - Windows guest (lab002-windows, 32-bit). In an ADMIN PowerShell:
#   powershell -ExecutionPolicy Bypass -File windows-part.ps1
# Results go to Desktop\lab06.
$out = "$env:USERPROFILE\Desktop\lab06"; New-Item -ItemType Directory -Force $out | Out-Null

# Part 1: the same program as on Ubuntu - VBoxService if it runs, else python -m http.server 8000
$p = Get-Process VBoxService -ErrorAction SilentlyContinue
if (-not $p) {
  Write-Host "VBoxService not running -> starting python -m http.server 8000 (needs Python installed)"
  Start-Process python -ArgumentList '-m','http.server','8000' -WindowStyle Minimized
  Start-Sleep 3
  $p = Get-CimInstance Win32_Process -Filter "Name like 'python%'" |
       Where-Object CommandLine -like '*http.server 8000*' | Select-Object -First 1 |
       ForEach-Object { Get-Process -Id $_.ProcessId }
}
$c = Get-CimInstance Win32_Process -Filter "ProcessId=$($p.Id)"
$parent = Get-CimInstance Win32_Process -Filter "ProcessId=$($c.ParentProcessId)"
[pscustomobject]@{
  Time            = Get-Date
  Name            = $p.ProcessName
  PID             = $p.Id
  Parent          = "$($parent.Name) ($($c.ParentProcessId))"
  CommandLine     = $c.CommandLine
  WorkingSetKB    = [int]($p.WorkingSet64/1KB)
  PrivateBytesKB  = [int]($p.PrivateMemorySize64/1KB)   # = Commit size (TM) = Private Bytes (ProcExp)
  VirtualSizeMB   = [int]($p.VirtualMemorySize64/1MB)
  Handles         = $p.HandleCount
  Threads         = $p.Threads.Count
} | Format-List | Tee-Object "$out\part1-windows.txt"

# Step 10: resource-exhaustion events
"Command: Get-WinEvent -FilterHashtable @{LogName='System'; ProviderName='Microsoft-Windows-Resource-Exhaustion-Detector'} -MaxEvents 5" | Out-File "$out\windows-events.txt"
try {
  Get-WinEvent -FilterHashtable @{LogName='System'; ProviderName='Microsoft-Windows-Resource-Exhaustion-Detector'} -MaxEvents 5 -ErrorAction Stop |
    Format-List TimeCreated, Id, Message | Out-String | Tee-Object -Append "$out\windows-events.txt"
} catch { "Result: $($_.Exception.Message)" | Tee-Object -Append "$out\windows-events.txt" }

Write-Host "`nNow, with $($p.ProcessName) PID $($p.Id):"
Write-Host " 1) Task Manager -> Details, columns PID, Memory (private working set), Working set, Commit size, Handles, Threads -> screenshot task-manager.png"
Write-Host " 2) Process Explorer (procexp.exe - this guest is 32-bit) as admin, columns Private Bytes, Working Set, WS Private, Handles, Threads,"
Write-Host "    View -> Lower Pane View -> Handles -> screenshot process-explorer.png"
Write-Host "Save both PNGs into $out"
