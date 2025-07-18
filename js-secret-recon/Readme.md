# 🔍 JS Secret Recon

A Bash script to extract JavaScript files from live subdomains and scan them for secrets like API keys and tokens.

## ⚙️ Features

- Probes live subdomains with `httpx`
- Extracts JS links via `subjs`
- Scans for secrets using `SecretFinder`
- Saves results with subdomain context

## 📁 Output

- `live.txt` – Live subdomains  
- `jsfiles.txt` – JS file links  
- `findings.txt` – Secrets with matching subdomain

## 🛠️ Requirements

- httpx  
- subjs  
- python3 + SecretFinder

## 🚀 Usage

```bash
bash js-recon.sh
```

bash, bugbounty, recon, javascript, secrets, automation, httpx, subjs, secretfinder, vgod

