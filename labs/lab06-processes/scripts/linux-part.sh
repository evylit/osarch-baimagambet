#!/usr/bin/env bash
# Lab 6 — Ubuntu guest (lab01-ubuntu). Run as your normal user:   bash linux-part.sh
# Before running: VM powered off -> snapshot "before-lab6" taken (and RAM lowered to 2 GB).
# Results go to ~/lab06. At the end the folder is served on port 8080 so the host can download it.
set -u
OUT=~/lab06; mkdir -p "$OUT"; cd "$OUT"

echo "### Step 0: tools"
sudo apt update -qq && sudo apt install -y htop stress-ng python3

echo "### Part 1: pick the process (same program as on Windows)"
PID=$(pgrep -o VBoxService || true)
if [ -n "$PID" ]; then
  NAME=VBoxService
else
  echo "VBoxService is not running here -> using python3 -m http.server 8000 (use the same on Windows)"
  nohup python3 -m http.server 8000 >/dev/null 2>&1 &
  sleep 2
  PID=$(pgrep -of "http.server 8000")
  NAME="python3 -m http.server 8000"
fi
echo "$NAME" > process-name.txt

{
  echo "=== $(date) $NAME PID=$PID ==="
  ps -o pid,ppid,user,rss,vsz,nlwp,%cpu,%mem,cmd -p "$PID"
  PP=$(ps -o ppid= -p "$PID" | tr -d ' ')
  echo "Parent: $(ps -o pid=,comm= -p "$PP")"
  echo "Open FDs: $(sudo ls /proc/$PID/fd | wc -l)"
  sudo ls -l /proc/$PID/fd | head -20
  grep -E 'VmSize|VmRSS|RssAnon|RssFile|RssShmem|Threads' /proc/$PID/status
} | tee part1-ps.txt

echo
echo ">>> Open htop in another terminal:  htop  -> F3 type the name, F5 tree, F2 Columns add PPID."
echo ">>> Take a screenshot (PrtScr or Shift+PrtScr), save it as ~/lab06/htop.png"
echo ">>> Do the Windows part (Task Manager + Process Explorer) NOW too, so the numbers are from the same time."
read -rp "Press Enter when the htop screenshot is saved... "

echo "### Part 2: memory pressure"
{ free -h; echo; swapon --show; } | tee swap.txt
{ echo "=== BEFORE $(date) ==="; free -h; } > memory-pressure.txt
( while true; do echo "=== $(date +%T) ==="; free -h; sleep 3; done >> memory-pressure.txt ) &
REC=$!
vmstat -t 2 > vmstat.txt &
VM=$!

run() {  # $1 = percent, $2 = seconds
  echo "=== $(date +%T) START stress-ng --vm 2 --vm-bytes $1 --timeout $2 ===" | tee -a memory-pressure.txt stress-log.txt
  stress-ng --vm 2 --vm-bytes "$1" --timeout "$2" --metrics-brief 2>&1 | tee -a stress-log.txt
  echo "=== $(date +%T) END $1 ===" | tee -a memory-pressure.txt stress-log.txt
  sleep 10
}
echo ">>> While this runs: try typing / watch htop and note when it lags."
run 70% 60s
run 90% 60s
run 120% 90s
if ! journalctl -k --since "30 min ago" | grep -qi "out of memory"; then
  echo "No OOM yet -> 150%"
  run 150% 90s
fi

kill $REC $VM 2>/dev/null
{ echo "=== AFTER $(date) ==="; free -h; } >> memory-pressure.txt

journalctl -k --since "30 min ago" | grep -i -E -B3 -A8 "out of memory|oom-kill" > kernel-log-extract.txt
echo "### OOM lines:"
grep -i -E "out of memory|killed process" kernel-log-extract.txt || echo "(none — lower guest RAM to 2 GB and rerun)"

pkill -f "http.server 8000" 2>/dev/null
echo
echo "### Done. Files:"; ls -l "$OUT"
echo ">>> Serving ~/lab06 on port 8080 for the host. Tell Claude it's ready; press Ctrl+C after the download."
python3 -m http.server 8080
