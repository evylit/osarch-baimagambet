# Lab 3 — Teardown, and the same machine from the command line

**Pair:** [Surname1] / [Surname2]  
**Driver first half:** [Name]  
**Machine:** [Host OS and model], [Guest if used]  
**Date:** DD.MM.YYYY

## What I did

1. Looked up every component on its official manufacturer page.  
2. Wrote captions covering what the part is, what it connects to, and its limits.  
3. Compared the two motherboards (socket, chipset, memory type, supported CPUs).  
4. Built two fully compatible systems and justified every choice.  
5. Collected the same hardware facts from the command line on Windows and Linux (and macOS if available).

---

## 1. The ten parts

All information comes from the official manufacturer pages (links below). Shop pages were not used as the primary source.

### Processors

**AMD Ryzen 5 7600**  
![Ryzen 5 7600](evidence/photos/ryzen5-7600.png)  
Desktop CPU, Zen 4, 6 cores / 12 threads, 3.8–5.1 GHz, 65 W TDP, integrated Radeon Graphics.  
**Connects to:** Socket AM5.  
**Limits:** AM5 only, DDR5 only, official JEDEC speed DDR5-5200. Boxed version includes Wraith Stealth cooler.  
Manufacturer: https://www.amd.com/en/products/processors/desktops/ryzen/7000-series/amd-ryzen-5-7600.html

**Intel Core i5-13400**  
![Core i5-13400](evidence/photos/i5-13400.png)  
Desktop CPU, 13th Gen (Raptor Lake), 10 cores (6P+4E) / 16 threads, up to 4.6 GHz, 65 W base, Intel UHD Graphics 730.  
**Connects to:** Socket LGA1700.  
**Limits:** LGA1700 only. Supports both DDR4-3200 and DDR5-4800 (motherboard decides). Boxed version includes Laminar RM1 cooler.  
Manufacturer: https://ark.intel.com/content/www/us/en/ark/products/230495/intel-core-i513400-processor-20m-cache-up-to-4-60-ghz.html

### Motherboards

**ASUS PRIME B650M-A**  
![ASUS PRIME B650M-A](evidence/photos/asus-b650m-a.png)  
Micro-ATX, Socket AM5, AMD B650 chipset, 4 × DDR5 slots.  
**Connects to:** AM5 CPU, DDR5, M.2 NVMe, SATA, 24-pin ATX + 8-pin EPS.  
**Limits:** Ryzen 7000/8000/9000 only, DDR5 only, no onboard Wi-Fi.  
Manufacturer: https://www.asus.com/motherboards-components/motherboards/prime/prime-b650m-a/techspec/

**MSI PRO B760M-A WIFI DDR4**  
![MSI PRO B760M-A WIFI DDR4](evidence/photos/msi-b760m-a.png)  
Micro-ATX, Socket LGA1700, Intel B760 chipset, 4 × DDR4 slots, Wi-Fi 6E.  
**Connects to:** LGA1700 CPU, DDR4, M.2, SATA, 24-pin ATX + 8-pin EPS.  
**Limits:** Intel 12th/13th/14th Gen only, DDR4 only.  
Manufacturer: https://www.msi.com/Motherboard/PRO-B760M-A-WIFI-DDR4/Specification

### Memory

**Kingston FURY Beast DDR5-5600 16 GB**  
![Kingston FURY Beast](evidence/photos/kingston-ddr5.png)  
DDR5 UDIMM, 16 GB, 5600 MT/s, non-ECC.  
**Connects to:** One DDR5 DIMM slot.  
**Limits:** Physically fits only DDR5 boards. 5600 MT/s requires XMP/EXPO.  
Manufacturer: https://www.kingston.com/en/memory/search?partid=KF556C40BB-16

**Crucial 16 GB DDR4-3200**  
![Crucial DDR4](evidence/photos/crucial-ddr4.png)  
DDR4 UDIMM, 16 GB, 3200 MT/s, non-ECC.  
**Connects to:** One DDR4 DIMM slot.  
**Limits:** Physically incompatible with DDR5 slots (different key notch).  
Manufacturer: https://www.crucial.com/memory/ddr4/ct16g4dfra32a

### SSDs

**Samsung 990 PRO 1 TB**  
![Samsung 990 PRO](evidence/photos/samsung-990-pro.png)  
M.2 2280 NVMe SSD, PCIe 4.0 x4, up to ~7450 MB/s sequential read.  
**Connects to:** M.2 slot (no cables).  
**Limits:** Needs a PCIe 4.0 (or at least 3.0) M.2 slot.  
Manufacturer: https://semiconductor.samsung.com/consumer-storage/internal-ssd/990pro/

**Samsung 870 EVO 1 TB**  
![Samsung 870 EVO](evidence/photos/samsung-870-evo.png)  
2.5-inch SATA SSD, SATA 6 Gb/s, ~560 MB/s sequential read.  
**Connects to:** SATA data cable + SATA power cable.  
**Limits:** SATA interface caps speed at ~560 MB/s.  
Manufacturer: https://www.samsung.com/uk/memory-storage/sata-ssd/870-evo-1tb-sata-3-2-5-ssd-mz-77e1t0b-eu/

### Power & Cooling

**Corsair RM750e 750 W**  
![Corsair RM750e](evidence/photos/corsair-rm750e.png)  
Fully modular ATX PSU, 750 W continuous, 80 PLUS Gold.  
**Connects to:** 24-pin motherboard, EPS 8-pin CPU, SATA/Molex drives, PCIe GPU.  
**Limits:** 750 W continuous output.  
Manufacturer: https://www.corsair.com/us/en/p/psu/cp-9020262-na/rme-series-rm750e-fully-modular-low-noise-atx-power-supply-cp-9020262-na

**AMD Wraith Stealth** (stock cooler for Ryzen 5 7600)  
Mounts on AM5 retention, connects to 4-pin CPU_FAN header. Rated for 65 W.

**Intel Laminar RM1** (stock cooler for i5-13400)  
Mounts on LGA1700 retention, connects to 4-pin CPU_FAN header.

---

## 2. Motherboard comparison

| Feature              | ASUS PRIME B650M-A          | MSI PRO B760M-A WIFI DDR4     |
|----------------------|-----------------------------|-------------------------------|
| Socket               | AM5                         | LGA1700                       |
| Chipset              | AMD B650                    | Intel B760                    |
| Memory type          | 4 × DDR5                    | 4 × DDR4                      |
| Supported CPUs       | Ryzen 7000 / 8000 / 9000    | Intel 12th / 13th / 14th Gen  |
| Accepts Ryzen 5 7600 | Yes                         | No                            |
| Accepts i5-13400     | No                          | Yes                           |
| Onboard Wi-Fi        | No                          | Yes (Wi-Fi 6E)                |

---

## 3. Two builds that work

### Build A — AMD platform

| Component                      | Why it belongs here |
|--------------------------------|---------------------|
| AMD Ryzen 5 7600               | Only CPU that fits the AM5 board. Integrated graphics → no discrete GPU needed. |
| ASUS PRIME B650M-A             | Only AM5 motherboard in the set. |
| Kingston FURY Beast DDR5 16 GB | AM5 is DDR5-only; this is the only DDR5 module. |
| Samsung 990 PRO 1 TB           | Uses the board’s M.2 PCIe 4.0 slot. |
| Corsair RM750e                 | Provides required 24-pin + EPS 8-pin with headroom. |
| Wraith Stealth                 | Stock cooler included with the CPU. |

**Still required:** micro-ATX case, second DDR5 stick (for dual-channel), monitor, keyboard, mouse, OS.

### Build B — Intel platform

| Component                      | Why it belongs here |
|--------------------------------|---------------------|
| Intel Core i5-13400            | Only CPU that fits the LGA1700 board. Integrated UHD 730. |
| MSI PRO B760M-A WIFI DDR4      | Only LGA1700 board. Has DDR4 slots and Wi-Fi. |
| Crucial DDR4-3200 16 GB        | Only DDR4 module; runs at the CPU’s rated speed. |
| Samsung 870 EVO 1 TB           | Uses the board’s SATA ports. |
| Laminar RM1                    | Stock cooler included with the CPU. |

**Still required:** power supply, micro-ATX case, SATA data cable, monitor, keyboard, mouse, OS.

---

## 4. The same facts from the command line

| Fact                | Windows (PowerShell)                                              | Linux                                      |
|---------------------|-------------------------------------------------------------------|--------------------------------------------|
| CPU model           | `Get-CimInstance Win32_Processor \| Select-Object Name`          | `lscpu` (Model name)                       |
| Cores / threads     | `Get-CimInstance Win32_Processor \| Select-Object NumberOfCores, NumberOfLogicalProcessors` | `lscpu` |
| Total memory        | `(Get-CimInstance Win32_ComputerSystem).TotalPhysicalMemory`     | `free -h`                                  |
| Memory modules      | `Get-CimInstance Win32_PhysicalMemory`                           | `dmidecode -t memory` or `free -h`         |
| Disk model & type   | `Get-PhysicalDisk`                                               | `lsblk -d -o NAME,MODEL,SIZE,ROTA,TRAN`    |
| Free space          | `Get-Volume`                                                     | `df -h`                                    |
| Firmware type       | `Get-CimInstance Win32_BIOS`                                     | presence of `/sys/firmware/efi`            |

Raw outputs are saved in:
- `evidence/windows-specs.txt`
- `evidence/linux-specs.txt`
- `evidence/macos-specs.txt` (if available)

---

## What did not work the first time

- [Write at least one real problem you encountered]  
  Example: A shop page incorrectly listed the Ryzen 5 7600 as AM4. The official AMD page clearly shows Socket AM5. Using the shop page would have produced an impossible build.

---

## Evidence

- [evidence/photos/](evidence/photos/) — screenshots from official manufacturer pages for every component  
- [evidence/windows-specs.txt](evidence/windows-specs.txt) — full PowerShell output  
- [evidence/linux-specs.txt](evidence/linux-specs.txt) — full command output from Linux  
- [evidence/macos-specs.txt](evidence/macos-specs.txt) — (if available)
