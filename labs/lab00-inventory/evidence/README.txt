# Lab 00 — System Inventory

## Summary table

| What                        | Value                                              | Where I got it |
|-----------------------------|----------------------------------------------------|----------------|
| CPU                         | Intel(R) Core(TM) 5 210H                           | `Get-CimInstance Win32_Processor` → evidence/cpu.txt |
| Cores / Threads             | 8 cores / 12 logical processors                    | `Get-CimInstance Win32_Processor` → evidence/cpu.txt |
| RAM                         | 16 GB (2 × 8 GB) @ 5600 MHz (configured 5200 MHz)  | `Get-CimInstance Win32_PhysicalMemory` → evidence/memory.txt |
| RAM Manufacturer            | Micron Technology                                  | `Get-CimInstance Win32_PhysicalMemory` → evidence/memory.txt |
| Storage                     | 477 GB NVMe SSD (BIWIN CE980Q41R00-512)            | `Get-PhysicalDisk` → evidence/disk.txt |
| Disk bus                    | NVMe                                               | `Get-PhysicalDisk` → evidence/disk.txt |
| BIOS Manufacturer           | American Megatrends International, LLC.            | `Get-CimInstance Win32_BIOS` → evidence/bios.txt |
| BIOS Version                | S3607VA.306                                        | `Get-CimInstance Win32_BIOS` → evidence/bios.txt |
| BIOS Release Date           | 2025-08-22                                         | `Get-CimInstance Win32_BIOS` → evidence/bios.txt |
| Firmware type               | UEFI                                               | `$env:firmware_type` and `Get-ComputerInfo` → evidence/firmware-virtualization.txt |
| Virtualization              | Enabled in firmware (True). SLAT & VM Monitor Mode Extensions: True. Hyper-V requirements satisfied. | `Get-CimInstance Win32_Processor` + `systeminfo` → evidence/firmware-virtualization.txt |

## Evidence

All raw PowerShell outputs are stored in the `evidence/` folder:

- `cpu.txt`
- `memory.txt`
- `disk.txt`
- `bios.txt`
- `firmware-virtualization.txt`

## Commands used

```powershell
# CPU
Get-CimInstance Win32_Processor | Select-Object Name, NumberOfCores, NumberOfLogicalProcessors | Format-List

# Memory
Get-CimInstance Win32_PhysicalMemory | Select-Object BankLabel, @{n='GB';e={$_.Capacity/1GB}}, Speed, ConfiguredClockSpeed, Manufacturer | Format-Table

# Disk
Get-PhysicalDisk | Select-Object FriendlyName, MediaType, BusType, @{n='SizeGB';e={[math]::Round($_.Size/1GB)}} | Format-Table

# BIOS
Get-CimInstance Win32_BIOS | Select-Object Manufacturer, SMBIOSBIOSVersion, ReleaseDate | Format-List

# Firmware + Virtualization
$env:firmware_type
(Get-ComputerInfo -Property BiosFirmwareType).BiosFirmwareType
Get-CimInstance Win32_Processor | Select-Object Name, VirtualizationFirmwareEnabled, SecondLevelAddressTranslationExtensions, VMMonitorModeExtensions | Format-List
systeminfo | Select-String -Pattern "Hyper-V|Virtualization"
