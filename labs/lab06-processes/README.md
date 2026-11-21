# Lab 6 — Live processes and memory pressure

Pair: Baimagambet Alikhan + `<partner>` · Date: 21 November 2026 · Guests: Ubuntu `lab01-ubuntu` (kernel 7.0.0-43-generic, 2 CPU, RAM lowered 4 GB → 2 GB, no swap), Windows 10 32-bit `lab002-windows` (4 GB RAM)

## Part 1 — One process, three tools

**Process chosen:** `python -m http.server 8000` — Python's built-in web server, started on both guests (`python3` on Ubuntu, `python.exe` 3.14 32-bit on Windows).
**Why:** the recommended VBoxService is not running in our Ubuntu guest (Guest Additions there do not start), so we used the second option from the guide: the same small program on both sides. It is one process with one listening socket, so the numbers are easy to compare.

| | Task Manager | Process Explorer | htop / ps |
|---|---|---|---|
| PID | 5324 | 5324 | 2196 |
| Parent (name and PID) | — (not shown) | none shown — drawn at the left edge as a root (its parent `powershell.exe 5468` had already exited) | `bash` (1759) — `login → bash → bash linux-part.sh → python3` |
| "Memory" as shown by default | Memory (private working set): 8,184 K | Private Bytes: 9,116 K | RES: 22,528 K |
| Private memory | Commit size: 9,116 K | Private Bytes: 9,116 K | — (no column; `RssAnon` in /proc: 11,724 kB) |
| Working set / RES | Working set: 16,488 K | Working Set: 16,488 K | RES: 22,528 K (ps RSS: 22,528) |
| Virtual size | — (not shown) | not added (PowerShell `VirtualMemorySize64`: 60 MB) | VIRT: 35,404 K (ps VSZ: 35,404) |
| Handles / file descriptors | 96 | 96 | 4 FDs (`ls /proc/2196/fd \| wc -l`) |
| Threads | 1 | 1 | 1 (ps NLWP) |

Evidence: `evidence/task-manager.png`, `evidence/process-explorer.png`, `evidence/htop.png`, `evidence/part1-ps.txt`, `evidence/part1-windows.txt`.

### Where the tools disagree

1. **Parent process.** Task Manager does not show the parent at all. Process Explorer shows the parent as the line above, one level to the left — but our `python.exe` is drawn at the **left edge with no parent**, because the `powershell.exe` (5468) that started it had already exited. Windows does not re-parent orphans; it only remembers the parent PID (PowerShell's `Win32_Process.ParentProcessId` still says 5468). On Linux, `ps` shows a live parent `bash (1759)`; had that bash died, the kernel would have re-parented python3 to `systemd (1)`.
2. **"Memory" means different things.** Task Manager's default *Memory* column is the **private working set** (8,184 K: private pages in RAM). htop's **RES** (22,528 K) is the whole resident set, including shared, file-backed pages: `/proc/2196/status` splits it into `RssAnon 11,724 kB` + `RssFile 10,804 kB` (the python binary and shared libraries such as libc). So RES is almost 3× the Windows "Memory" figure for the same program — they measure different things.
3. **Same thing, different names.** Task Manager's **Commit size** and Process Explorer's **Private Bytes** are the same number (9,116 K) under two names. htop has no column for it; the closest Linux figure is `RssAnon`, and that counts only the part that is in RAM.
4. **VIRT is not memory in use.** htop VIRT is 35,404 K vs RES 22,528 K: VIRT is the whole mapped address space, including parts never touched.
5. **Handles vs. file descriptors: 96 vs 4.** Windows counts *handles* to every kind of kernel object — Process Explorer's lower pane lists directories, `\Device\ConDrv`, `\Device\Afd` (the socket), registry keys (`HKLM`, `HKCU`…), the window station, events… Linux counts only *file descriptors*: stdin/stdout/stderr (`/dev/null`) and one `socket:[17001]`.
6. **The numbers move.** Our PowerShell script read the same process 3 seconds after it started and got **Handles 100, Threads 2, Private 9,132 K**; minutes later both Windows tools showed **96, 1, 9,116 K**. Python's start-up thread had finished and released its handles. That is why all tools have to be read at the same moment.

## Part 2 — Memory pressure

Guest RAM: 2 GB set in VirtualBox (1.6 GiB visible to Linux; lowered from 4 GB: **yes**) · swap: **none** (`swapon --show` prints nothing, `free -h`: `Swap: 0B`)

Snapshot `before-lab6` taken (VM powered off) before lowering RAM and starting.

Steps (all run by `scripts/linux-part.sh`):
```bash
sudo apt install -y htop stress-ng
{ echo "=== BEFORE $(date) ==="; free -h; } > memory-pressure.txt
( while true; do echo "=== $(date +%T) ==="; free -h; sleep 3; done >> memory-pressure.txt ) &   # recording
vmstat -t 2 > vmstat.txt &
stress-ng --vm 2 --vm-bytes 70%  --timeout 60s
stress-ng --vm 2 --vm-bytes 90%  --timeout 60s
stress-ng --vm 2 --vm-bytes 120% --timeout 90s
stress-ng --vm 2 --vm-bytes 150% --timeout 90s     # because 120% gave no OOM line
{ echo "=== AFTER $(date) ==="; free -h; } >> memory-pressure.txt
journalctl -k --since "30 min ago" | grep -i -E -B3 -A8 "out of memory|oom-kill" > kernel-log-extract.txt
```

| | Before (16:11:15) | During (worst) | After (16:16:56) |
|---|---|---|---|
| Available | 1.2 Gi | **19 Mi** at 16:15:20 (used 1.6 Gi of 1.6 Gi) | 1.2 Gi |
| Swap used | 0 B (no swap) | 0 B (no swap) | 0 B |
| buff/cache | 785 Mi | 83 Mi at 16:15:20 | 117 Mi |

**What happened** (times UTC, from `memory-pressure.txt`, `stress-log.txt`, `vmstat.txt`):
- 16:11:15 — **70%** (2 × 209 MB): available dropped from 1.2 Gi to **738 Mi** (16:11:24) and came back between stress-ng's allocation cycles; no problems, run "passed".
- 16:12:25 — **90%** (2 × 299 MB): available down to **602 Mi** (16:12:30); still responsive.
- 16:13:35 — **120%** (2 × 421 MB, more than the 701 MB stress-ng saw as available): available **318 Mi** at 16:13:55. Then the recording loop, which writes every 3 s, **went silent for 26 s (16:14:01 → 16:14:27)** and again for 11 s (16:14:54 → 16:15:05). The kernel logged `clocksource: Long readout interval … 7028958121 ns` at 16:14:18: the guest stalled for ~7 s. No swap existed, so the kernel had to throw away page cache (buff/cache fell from 668 Mi to 396 Mi) and re-read program code from disk, so the machine stalled. No OOM yet: the kernel could still reclaim cache.
- 16:15:15 — **150%** (2 × 742 MB = 1.45 GB of 990 MB available): available fell to **19 Mi** within 5 s, buff/cache to 83 Mi, and the **OOM killer fired at 16:15:15**. vmstat shows `us ≈ 35 / sy ≈ 65` and `bi` up to **132,688** blocks/s: most CPU went to the kernel reclaiming memory and re-reading pages from disk. stress-ng's throughput fell from ~53,600 to **5,723 bogo ops/s** (10× slower). stress-ng kept restarting killed workers, so the kernel killed **172** `stress-ng-vm` processes before the run ended at 16:16:46.
- 16:16:56 — after the run: available back to **1.2 Gi** at once (killed workers' memory freed); buff/cache stayed low (117 Mi vs 785 Mi before) because the cache must be refilled from disk.

### What the kernel did

```
Nov 21 16:15:15 lab01-ubuntu kernel: stress-ng-vm invoked oom-killer: gfp_mask=0x140cca(GFP_HIGHUSER_MOVABLE|__GFP_COMP), order=0, oom_score_adj=1000
Nov 21 16:15:15 lab01-ubuntu kernel: [   2640]  1000  2640   204116   190521   190374      130        17  1613824        0          1000 stress-ng-vm
Nov 21 16:15:15 lab01-ubuntu kernel: [   2641]  1000  2641   204116   156654   156520      130         4  1343488        0          1000 stress-ng-vm
Nov 21 16:15:15 lab01-ubuntu kernel: oom-kill:constraint=CONSTRAINT_NONE,nodemask=(null),cpuset=/,mems_allowed=0,global_oom,task_memcg=/user.slice/user-1000.slice/session-1.scope,task=stress-ng-vm,pid=2640,uid=1000
Nov 21 16:15:15 lab01-ubuntu kernel: Out of memory: Killed process 2640 (stress-ng-vm) total-vm:816464kB, anon-rss:761496kB, file-rss:520kB, shmem-rss:68kB, UID:1000 pgtables:1576kB oom_score_adj:1000
...
Nov 21 16:16:45 lab01-ubuntu kernel: Out of memory: Killed process 2907 (stress-ng-vm) total-vm:816464kB, anon-rss:761496kB, file-rss:544kB, shmem-rss:88kB, UID:1000 pgtables:1580kB oom_score_adj:1000
```

At **16:15:15** the guest ran out of RAM and had no swap to fall back on (`global_oom`, `CONSTRAINT_NONE`: the whole machine was out of memory, not just one cgroup). A `stress-ng-vm` worker asked for another page (`invoked oom-killer`), the kernel could not find one, and the OOM killer chose a victim. It killed **`stress-ng-vm` PID 2640**: it used the most memory (`anon-rss: 761,496 kB`, ≈ 744 MB, almost half of the 1.6 GiB RAM; in the task list it had 190,521 resident pages vs 156,654 for its sibling 2641). Its `oom_score_adj` was **1000**, the highest possible: stress-ng marks its own workers as "kill me first", so the kernel picks them before any system process. The time matches `memory-pressure.txt`: 16:15:17 available 323 Mi and dropping, 16:15:20 **19 Mi**, 16:15:23 back to 544 Mi right after a kill freed ~744 MB. stress-ng respawned the worker each time, so the same thing happened 172 times until 16:16:45.

### Windows

```powershell
Get-WinEvent -FilterHashtable @{LogName='System'; ProviderName='Microsoft-Windows-Resource-Exhaustion-Detector'} -MaxEvents 5 |
    Format-List TimeCreated, Id, Message
```

Result: `No events were found that match the specified selection criteria.` (see `evidence/windows-events.txt`)

Explanation: Windows has no OOM killer. When the **commit charge** gets close to the **commit limit** (RAM + page file), the Resource-Exhaustion-Detector writes **event ID 2004** ("Windows successfully diagnosed a low virtual memory condition") and names the processes that use the most memory. Windows does not kill them: new allocations fail, and programs crash or show "out of memory" errors themselves. Our Windows guest never got close: Process Explorer's status bar showed **Commit Charge 27–28 %** during the lab. So the query correctly returned nothing. We would expect event 2004 if we ran Sysinternals `testlimit -d 512` until the page file was full.

## What did not work the first time

1. **The Windows process disappeared between screenshots.** The script started `python -m http.server` in its own minimized console window. While tidying the desktop we closed that window, and PID 2748 was gone before Process Explorer showed its handles. We restarted it (new PID **5324**) and re-took both Windows screenshots so that Task Manager and Process Explorer show the same PID.
2. **Our Windows helper script did not parse** in the guest's old Windows PowerShell: the file was UTF-8 without BOM and contained an em dash ("—"). PowerShell read it as ANSI, and one of the bytes turned into a typographic quote that ended a string early (`The string is missing the terminator`). Fix: ASCII-only script.
3. **Process Explorer showed "Access denied"** for some process paths because it was not started as administrator.
4. **120% was not enough for the OOM killer.** Even with RAM lowered to 2 GB and no swap, the kernel survived 120% by dropping page cache, with a ~26 s stall. Only at **150%** did it run out of memory and log `Out of memory: Killed process`.
5. **No clipboard into the guests** (Guest Additions not running), so commands could not be pasted. We downloaded the scripts from this repo with `wget` / `Invoke-WebRequest` and moved the Linux results to the host through a VirtualBox NAT port-forward (`python3 -m http.server 8080` in the guest).
