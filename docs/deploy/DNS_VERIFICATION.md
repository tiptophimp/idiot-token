### DNS Verification Steps (stupidiots.com)

1) Set records at your DNS provider
- A: `stupidiots.com` → `<DROPLET_IP>`
- CNAME: `www` → `stupidiots.com`

2) Validate propagation
```bash
bash scripts/dns_check_stupidiots.sh -d stupidiots.com -e <DROPLET_IP>
```

3) Test origin directly via IP with Host header
```bash
curl -sI http://<DROPLET_IP> -H "Host: stupidiots.com"
```

4) Issue TLS (after A record resolves)
```bash
sudo certbot --nginx -d stupidiots.com -d www.stupidiots.com --redirect -n -m admin@stupidiots.com --agree-tos
```

5) Final checks
```bash
curl -sI https://stupidiots.com/
curl -sI https://stupidiots.com/assets/img/logo.png
curl -sI https://stupidiots.com/airdrop/idiocracy-1.json
```


