# Ticket 2 — Four builds

All prices: shop.kz (Белый Ветер / White Wind, delivers across Kazakhstan), taken **2026-11-22**.
Line-by-line prices are in [budget.csv](budget.csv). Compatibility and power were checked
with PCPartPicker ([evidence/pcpartpicker-links.md](evidence/pcpartpicker-links.md)) and against the
vendor's spec pages (case limits, cooler height, GPU length).

## The fact that shaped all four builds: memory prices

On 2026-11-22 memory was the most expensive part of almost every build:

| Memory kit (shop.kz, 2026-11-22) | Price, KZT |
|---|---|
| DDR4-3200 16 GB (2×8) | 66,990 |
| DDR4-3200 32 GB (2×16) | 152,990 |
| DDR5-5200 16 GB (2×8) | 159,990 |
| DDR5-5600 32 GB (2×16) | 282,990 |

A 32 GB DDR5 kit costs about three Ryzen 7 CPUs. So the budget decision was mainly
**which machines need DDR5 (and the AM5 upgrade path)** and **which machines can stay on DDR4 (AM4)**.

- Accountant and sales manager → **AM4 + DDR4**. Their workload will not grow much in 4–5 years, and DDR4 costs about half as much.
- Web developer and designer → **AM5 + DDR5**. Their workload will grow, and AM5 gives a CPU and memory upgrade path.

Parts shared by all four (so one spare PSU or cooler fits any machine):
DeepCool Matrexx 30 mATX case, MSI MAG A650BN 650 W PSU, DeepCool AG200 cooler, Logitech MK120.
Fit check against the case spec: the case takes coolers up to **151 mm** tall (AG200 is 133 mm; I first picked a
152 mm cooler and swapped it), GPUs up to **250 mm** long (the RTX 5060 Windforce is 199 mm), and PSUs up to 170 mm.

---

### Build 1 — Accountant

**Load:** 1C:Accounting all day (Windows-only), Excel with wide sheets, a browser with the tax and
e-invoice portals (cabinet.salyk.kz, esf.gov.kz) plus NCALayer for the digital signature. 8 hours a day,
3–4 programs open at once. Light on CPU, roughly 6–8 GB of RAM in use.

**Bottleneck:** not the CPU. The limits are **screen area** (a 1C report beside an Excel sheet) and
**data safety**: a power cut while 1C is posting documents can corrupt the file database, and that costs
more than the whole PC. 16 GB of RAM leaves a 2× margin over the working set, so the system will not swap (Lab 6).

**Trade-off:** chose an end-of-life platform (AM4, DDR4) instead of AM5. An AM5 equivalent (Ryzen 5 8500G +
B650M-P + 16 GB DDR5 = 285,970 KZT) costs 82,490 KZT more than this one (203,480 KZT) and buys an upgrade path the
accountant will not use. Part of that money went to a **UPS** (36,990) and a **27" 2560×1440 monitor** instead of a
24" 1080p one. The alternative I did not take was a cheaper 24" monitor and no UPS.
Windows 11 **Pro**, because BitLocker protects the financial data and Remote Desktop lets support log in.

**Total:** 561,210 KZT (budget.csv, rows 2–13)

---

### Build 2 — Sales manager

**Load:** CRM in the browser (e.g. Bitrix24), 30–40 tabs, WhatsApp Web, Excel, and 3–4 hours of
video calls a day, often with all of it open at once.

**Bottleneck:** **memory**. Chrome with ~40 tabs uses about 8–10 GB, and a video call adds 1.5–2 GB. On 16 GB,
with Windows itself on top, the machine is at the edge and starts paging during a call (the Lab 6 swapping
picture). Second bottleneck: a desktop has **no camera or microphone**, and the request forgot that.

**Trade-off:** 32 GB on **DDR4** instead of DDR5. The kit is 152,990 KZT instead of 282,990 KZT, and the whole
AM4 platform saves 119,490 KZT compared with the AM5 equivalent. The CPU is a 6-core Ryzen 5 5500GT, which barely works
in this role. The board has 4 DIMM slots, so 64 GB later costs one more DDR4 kit. Added a Logitech Brio 100
webcam and H390 USB headset (37,580 together). The alternative not taken: AM5 + 16 GB DDR5 for the
same money, which is newer but swaps on every call.

**Total:** 628,800 KZT (budget.csv, rows 14–26)

---

### Build 3 — Web developer

**Load:** VS Code, Docker with 4–6 containers (app, PostgreSQL, Redis, a reverse proxy), `npm`/`vite`
builds, two or three browsers for testing, sometimes a VM. Running together, this adds up to roughly 20–26 GB of RAM,
and many small files are read and written (node_modules, image layers).

**Bottleneck:** **memory first**, then CPU threads during builds, then storage latency on many small files.
If memory runs out, containers get OOM-killed (the Lab 6 OOM-killer evidence).

**Trade-off:** 32 GB instead of 64 GB. A second DDR5 kit would add 282,990 KZT and break the budget.
The MSI PRO B650M-P has **4 DDR5 slots**, so two are free for a later 2×16 GB kit. The money went to an
8-core Ryzen 7 7700 (builds scale with cores) and a PCIe 4.0 SSD. The OS is **Ubuntu 26.04 LTS**: it is
licensed (GPL, Canonical allows commercial use at no cost), Docker runs natively without the WSL2 VM
using several GB of RAM, and it saves 102,990 KZT compared with Windows Pro. Not taken: Windows 11 Pro + WSL2.

**Total:** 683,720 KZT (budget.csv, rows 27–37)

---

### Build 4 — Designer

**Load:** Photoshop with 2–4 GB layered files, Illustrator, Figma in the browser, and some short
video for social media (Premiere / DaVinci Resolve). Colour has to look the same on the screen as in the client's
browser.

**Bottleneck:** **memory** (Photoshop keeps history states and layers in RAM, and at 16 GB it uses its
scratch disk), then **GPU** (Photoshop filters, video timeline and NVENC export), then the **monitor's colour gamut**.
The CPU matters least of the four.

**Trade-off:** took the Ryzen 5 7500F (no integrated graphics, which a discrete GPU makes unnecessary) instead of a
Ryzen 7 7700 to save 31,000 KZT. Took an RTX 5060 8 GB instead of an RTX 5060 Ti 16 GB (460,990, +131,000 KZT),
so 8 GB of VRAM limits heavy 4K video. The monitor covers 100% sRGB / 95% DCI-P3 but has no hardware
calibration. A calibrated ProArt/BenQ costs 2–3× more. If the designer starts doing print work, buy a colorimeter.
Power: 65 W CPU + ~145 W GPU + ~50 W for the rest ≈ 260 W, well inside 650 W (the card asks for ≥ 450 W).

**Total:** 1,085,700 KZT (budget.csv, rows 38–49)

---

## Budget summary

| Role | Platform | Total, KZT |
|---|---|---|
| Accountant | AM4 / DDR4 16 GB | 561,210 |
| Sales manager | AM4 / DDR4 32 GB | 628,800 |
| Web developer | AM5 / DDR5 32 GB | 683,720 |
| Designer | AM5 / DDR5 32 GB + RTX 5060 | 1,085,700 |
| **Grand total** | | **2,959,430** |
| Reserve (budget − total) | | 40,570 |

## Compatibility checks

| Check | Accountant / Sales | Web developer / Designer |
|---|---|---|
| CPU socket ↔ board | AM4 ↔ AM4 (B550 supports Zen 3; flash the latest BIOS for the 5500GT) | AM5 ↔ AM5 |
| Memory type ↔ board | DDR4 ↔ 4× DDR4 | DDR5 ↔ 4× DDR5 |
| NVMe ↔ M.2 | PCIe 3.0 SSD in M.2 (APU runs M.2 at 3.0) | PCIe 4.0 SSD in M.2 PCIe 4.0 ×4 |
| Video output | iGPU → board HDMI | 7700: board HDMI/DP; 7500F has no iGPU → RTX 5060 DP/HDMI |
| Power | ~120 W on 650 W | ~260 W on 650 W |
| Case | mATX board, 133 mm cooler (≤151) | + 199 mm GPU (≤250) |
