# Lab 5 — Encoding forensics

**Name:** Alikhan Baimagambet  
**Date:** 15.11.2026  
**Tools:** Git Bash / PowerShell + Ubuntu guest

## What I received

- **Excel:** names shown as mojibake (strange characters)
- **LibreOffice:** import dialog appeared, default character set produced incorrect names
- **Terminal (`cat`):** Cyrillic and Kazakh letters displayed incorrectly

## Diagnosis (made before the fix)

- `file` said: (see `evidence/file-before.txt`)
- First bytes: `49 44 3B D4 EC E5 EB FF 3B ...` (see `evidence/hexdump-before.txt`)

**Encoding:** RK1048 (KZ-1048)  
— because Cyrillic letters take 1 byte (range `C0`–`FF`), and Kazakh letters (Ә, Қ, etc.) are present as single bytes. Windows-1251 does not contain these Kazakh characters.

**Line ending:** CRLF  
— because lines end with `0D 0A`

**BOM:** no  
— file starts with `49 44 3B` (`ID;`), not `EF BB BF` or `FF FE`

**Separator:** `;`

## Fix

Used the following script (`scripts/fix.sh`):

```sh
#!/bin/sh
# Lab 5: convert staff-broken.csv from RK1048 to UTF-8
in=evidence/staff-broken.csv
out=evidence/staff-fixed.csv

iconv -f RK1048 -t UTF-8 "$in" > "$out"

# Convert CRLF → LF (optional, depending on preference)
sed -i 's/\r$//' "$out"


