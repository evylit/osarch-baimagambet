# Ticket 2 — Kitting out the new office

## 1. What was asked

> From: Daniyar K. (Director)
> Subject: computers for the new office
>
> We are opening the second office and need four computers — accountant, sales, web developer,
> designer. Budget 3,000,000 tenge for everything. Everyone says we should just buy the same four
> machines, is that right? Make sure they last a few years. Monitors included.

## 2. What was actually needed

**Four identical machines is the wrong answer.** The four people put four different loads on a computer,
so each machine runs out of a different resource first:

- **Accountant:** screen area and data safety (1C database + power cuts). Needs Windows for 1C.
- **Sales manager:** memory (40 browser tabs + video calls), plus a camera and microphone.
- **Web developer:** memory and CPU threads (Docker, builds), plus fast storage.
- **Designer:** memory, GPU and a wide-gamut monitor.

One "average" machine either overpays for the accountant (a GPU and 32 GB the accountant never uses) or underpowers the designer
and developer. With DDR5 at 282,990 KZT per 32 GB (2026-11-22), four identical machines good enough for the
designer would cost about 4 × 1,085,700 = 4.3 M KZT, which is over budget. Four identical ones that fit the budget
(≈ 740,000 each) would swap on the designer's and developer's work. Different machines give each person
what their load needs.

**What the request left out:**
- Operating-system licences (≈ 103,000 KZT per Windows Pro machine)
- Keyboards and mice
- **Webcam and headset** for the sales manager (desktops have neither)
- A **UPS** for the accountant
- Application licences: 1C, Microsoft Office / 365, Adobe Creative Cloud
- Network equipment, a printer, delivery/assembly
- Backups
- A reserve, because memory and SSD prices move within a month

**What I would ask Daniyar, and what I assumed instead:**

| Question for Daniyar | My assumption |
|---|---|
| Does the 3 M include software licences (1C, Office, Adobe)? | No. Only hardware, monitors and the OS. The company already has 1C/Office/Adobe subscriptions. |
| "A few years" — how many? | 4–5 years. So AM5 for the two growing roles; AM4 is fine for the two stable roles. |
| What does the designer actually do: print, web, video? | Mostly web/social graphics plus short video, so sRGB/DCI-P3 matters more than hardware calibration. |
| What stack does the developer use? Do they need Windows? | Web stack in Docker, so Linux (Ubuntu) is fine. |
| Does the office have network, a printer, power protection? | Network and printer exist. Power is unreliable enough to protect the accounting machine. |
| Who assembles? | Our own IT (me), so no assembly fee. |

## 3. What I did

1. For each role I wrote **load → bottleneck → trade-off** before choosing parts (see [builds.md](builds.md)).
2. Took prices from one Kazakhstan vendor, shop.kz (White Wind), on **2026-11-22**, using the current price shown on
   the product page.
3. Found that memory is the most expensive part right now, so I split the office into two platforms:
   AM4/DDR4 for the accountant and sales manager, AM5/DDR5 for the developer and designer.
4. Checked compatibility (socket, memory type, M.2, power, cooler height, GPU length) against the vendor's spec
   pages and PCPartPicker. This found one problem: the first cooler (152 mm) did not fit the case (151 mm max),
   so I replaced it.
5. Put every part in [budget.csv](budget.csv). **Grand total 2,959,430 KZT**, reserve 40,570 KZT.

| Role | Total, KZT |
|---|---|
| Accountant | 561,210 |
| Sales manager | 628,800 |
| Web developer | 683,720 |
| Designer | 1,085,700 |
| **Grand total** | **2,959,430** |

### Which machine will be upgraded first, 18 months from now?

The **web developer's memory**: 32 GB → 64 GB, by adding a second 2×16 GB DDR5 kit to the two free slots on
the B650M-P. Docker images, a database and a VM only grow, and the developer is already at ~20–26 GB out of 32.
I did not buy 64 GB now only because DDR5 costs 282,990 KZT per 32 GB today. Waiting 18 months is a bet that the price
comes down, and the AM5 board makes it a 10-minute job instead of a new PC.

### Pre-built vs built

Comparable pre-built system units from the same vendor, same date ([prebuilt.csv](prebuilt.csv)):

| Role | Pre-built (shop.kz WW-KZ, 2026-11-22) | Price | My tower* |
|---|---|---|---|
| Accountant | i3-12100 / 16 GB DDR4 / 512 GB SATA | 271,290 | 327,250 |
| Sales | Ryzen 5 5600GT / **8 GB** / 512 GB SATA / A520 | 254,790 | 413,250 |
| Web developer | i5-14400 / 16 GB DDR5 / 512 GB / H610, **2 slots** | 374,490 | 589,740 |
| Designer | 7500F / RTX 5060 / **16 GB (1×16)** / 1 TB / B650 | 707,790 | 888,730 |
| **Total** | | **1,608,360** | **2,218,970** |

\*Tower = CPU, board, memory, SSD, GPU, case, PSU, cooler. No OS, monitor or peripherals, the same as the pre-builts.

**Gained with pre-built:** one invoice and one warranty from the vendor for the whole unit, assembly and testing done,
delivered in a day, and about 610,000 KZT less up front.
**Lost:** the price is lower mainly because they ship **less memory and smaller, slower SSDs**: 8–16 GB instead of
16–32 GB, and 512 GB SATA where the brief requires 1 TB. None of the three office models meets the 1 TB rule
without an upgrade. The developer unit has an H610 board with only 2 DIMM slots, so it cannot be upgraded later.
I also do not choose the PSU or board brand. Bringing them up to spec means buying memory and SSDs at the same high
prices anyway.
**Verdict:** a pre-built makes sense for the accountant if Daniyar values the warranty. For the other three, the
pre-built saves money by cutting the bottleneck part.

### Who will complain within a month?

The **web developer**, about the **machine freezing or containers being killed while running the full stack plus a
VM or an Android emulator**. 32 GB covers Docker + DB + IDE + browsers (~20–26 GB), but the first time they start a VM
on top of that, memory runs out and the OOM killer stops a container (exactly what I saw in Lab 6). That is the
trade-off I chose (32 instead of 64 GB), and it is the same part I plan to upgrade first.

## 4. Evidence

- [budget.csv](budget.csv) — every part, price in KZT, vendor link and date (UTF-8). Proves the total is ≤ 3,000,000.
- [prebuilt.csv](prebuilt.csv) — dated pre-built prices for the pre-built vs built question.
- [builds.md](builds.md) — load, bottleneck, trade-off and total per machine, plus the compatibility table.
- [evidence/pcpartpicker-links.md](evidence/pcpartpicker-links.md) — one PCPartPicker list per build. Proves socket,
  memory and power compatibility (PCPartPicker does not price in tenge; it was used only for compatibility and
  wattage).
- [evidence/vendor-quotes/](evidence/vendor-quotes/) — a screenshot of each price, with the shop.kz address and the
  date visible. Proves the prices existed on 2026-11-22.

## 5. What I would do differently

I took every price from **one vendor** (shop.kz). It was fast and consistent, but with memory this expensive I
should have checked the three memory kits and the RTX 5060 at a second vendor (Kaspi.kz, DNS, Alser). A 10–15%
difference on the DDR5 kits alone is 60–80,000 KZT, which is more than my whole reserve. I would also put a written
quote from the vendor in the evidence, because a screenshot does not hold the price on the day of purchase.
