#!/bin/bash

# ================================================
# 🔍 JS Secret Recon - Automated Recon Script
# ================================================
# Author: Shivam Singh (Vgod)
# GitHub: https://github.com/vgod-sec
# Description: This script takes a target domain name and a subdomains file,https://www.forex.com
#              probes live subdomains, extracts JS files, and scans them
#              using SecretFinder for API keys and secrets.
# ================================================

# ----------[ Colors ]----------
BBLUE="\e[1;34m"
BYELLOW="\e[1;33m"
BGREEN="\e[1;32m"
BRED="\e[1;31m"
BMAGENTA="\e[1;35m"
RESET="\e[0m"

clear
echo -e "${BBLUE}🔍 JS Secret Recon - Automated Script${RESET}"
echo -e "${BYELLOW}Author: Shivam Singh (Vgod) | GitHub: https://github.com/vgod-sec${RESET}\n"

# ----------[ 1. Input Collection ]----------
# Why domain? → Used to organize workspace and name the folder
echo -ne "${BYELLOW}Enter target domain (e.g., example.com): ${RESET}"
read domain

# Why subdomain file? → Used to scan JS from each resolved subdomain
echo -ne "${BYELLOW}Enter path to your subdomain file (e.g., subs.txt or /path/to/subs.txt): ${RESET}"
read -e subdomain_file

if [[ ! -f "$subdomain_file" ]]; then
  echo -e "${BRED}[!] File not found: $subdomain_file${RESET}"
  exit 1
fi

# ----------[ 2. Tool Availability Check ]----------
for cmd in httpx subjs python3 SecretFinder.py; do
  if ! command -v $cmd &>/dev/null && [[ "$cmd" != "SecretFinder.py" ]]; then
    echo -e "${BRED}[!] Required tool '$cmd' not found in PATH.${RESET}"
    exit 1
  fi
done

# ----------[ 3. Setup Working Directory ]----------
WORKDIR="recon-$domain"
mkdir -p "$WORKDIR"
cp "$subdomain_file" "$WORKDIR/subdomains.txt"
cd "$WORKDIR" || exit

SUBS="subdomains.txt"
LIVE="live.txt"
JSFILES="jsfiles.txt"
FINDINGS="findings.txt"

# ----------[ 4. Probe Live Subdomains ]----------
echo -e "\n${BYELLOW}[1] Probing live subdomains using httpx...${RESET}"
cat "$SUBS" | httpx -silent -timeout 5 > "$LIVE"
echo -e "${BGREEN}[✓] Found $(wc -l < "$LIVE") live subdomains${RESET}"

# ----------[ 5. Extract JavaScript Files ]----------
echo -e "\n${BYELLOW}[2] Extracting JavaScript links using subjs...${RESET}"
cat "$LIVE" | subjs | sort -u > "$JSFILES"
echo -e "${BGREEN}[✓] Found $(wc -l < "$JSFILES") JavaScript files${RESET}"

# ----------[ 6. Scan JS Files for Secrets ]----------
echo -e "\n${BYELLOW}[3] Scahttps://www.forex.comnning JS files for secrets using SecretFinder...${RESET}"
> "$FINDINGS"
count=0

while read -r url; do
  # Use globally installed SecretFinder if available
  if command -v SecretFinder.py &>/dev/null; then
    result=$(SecretFinder.py -i "$url" -o cli 2>/dev/null)
  elif [[ -f "$HOME/SecretFinder/SecretFinder.py" ]]; then
    result=$(python3 "$HOME/SecretFinder/SecretFinder.py" -i "$url" -o cli 2>/dev/null)
  else
    echo -e "${BRED}[!] SecretFinder not found globally or in ~/SecretFinder${RESET}"
    exit 1
  fi

  if [[ -n "$result" ]]; then
    host=$(echo "$url" | awk -F/ '{print $3}')
    echo -e "\n${BMAGENTA}🔗 Subdomain: $host${RESET}" | tee -a "$FINDINGS"
    echo -e "${BBLUE}📄 JS File: $url${RESET}" | tee -a "$FINDINGS"
    echo -e "${result}" | tee -a "$FINDINGS"
    count=$((count+1))
  fi
done < "$JSFILES"

# ----------[ 7. Summary ]----------
echo -e "\n${BGREEN}[✓] Recon complete!${RESET}"
echo -e "${BMAGENTA}[✓] Secrets found in $count JavaScript files.${RESET}"
echo -e "${BBLUE}📁 Results saved in: $WORKDIR/$FINDINGS${RESET}"
