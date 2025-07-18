# 🔍 JS Secret Recon

A powerful Bash script to automate JavaScript file discovery and secret detection during bug bounty reconnaissance.

## 🚀 Features

- Probes live subdomains using `httpx`
- Extracts JS file URLs using `subjs`
- Scans JS files for secrets like API keys, tokens, and credentials using `SecretFinder`
- Saves results with subdomain context

## 🛠 Tools Used

- `httpx` – Fast & flexible HTTP probing
- `subjs` – Extracts JavaScript URLs from webpages
- `SecretFinder` – Detects sensitive data in JS files

## 📁 Output Structure

- `live.txt` – Live subdomains
- `js_links.txt` – JavaScript file URLs
- `secrets/` – SecretFinder scan results per subdomain

## 📌 Use Cases

- Bug bounty reconnaissance
- JS endpoint discovery
- API key and secret hunting

## 🔗 Author

👤 GitHub: [vgod-sec](https://github.com/vgod-sec)  
💼 LinkedIn: [shivamsinghvgod](https://linkedin.com/in/shivam-thakur1)

⭐ Star this repo if it helps your recon workflow!
