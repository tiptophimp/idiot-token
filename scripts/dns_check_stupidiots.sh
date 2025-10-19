#!/usr/bin/env bash
set -euo pipefail

DOMAIN="stupidiots.com"
EXPECTED_IP=""

while getopts ":d:e:" opt; do
  case $opt in
    d) DOMAIN="$OPTARG" ;;
    e) EXPECTED_IP="$OPTARG" ;;
    *) ;;
  esac
done

echo "=== DNS Diagnostics for $DOMAIN ==="

check_nslookup() {
  local resolver="$1"
  echo "-- nslookup @$resolver A $DOMAIN"
  nslookup "$DOMAIN" "$resolver" || true
  echo "-- nslookup @$resolver AAAA $DOMAIN"
  nslookup -type=AAAA "$DOMAIN" "$resolver" || true
  echo "-- nslookup @$resolver CNAME www.$DOMAIN"
  nslookup -type=CNAME "www.$DOMAIN" "$resolver" || true
}

echo "Resolvers: default, 1.1.1.1, 8.8.8.8"
check_nslookup ""
check_nslookup 1.1.1.1
check_nslookup 8.8.8.8

if [[ -n "$EXPECTED_IP" ]]; then
  echo "-- Comparing A record to expected IP: $EXPECTED_IP"
  A_RECORDS=$(nslookup "$DOMAIN" 1.1.1.1 | awk '/Address: /{print $2}' | tail -n +2 || true)
  echo "A records (Cloudflare): $A_RECORDS"
  if echo "$A_RECORDS" | grep -q "$EXPECTED_IP"; then
    echo "OK: DNS A includes expected IP"
  else
    echo "WARN: Expected IP not found in A records"
  fi
fi

echo "=== HTTP checks ==="
echo "-- curl -I http://$DOMAIN"
curl -sI "http://$DOMAIN" || true
echo "-- curl -I https://$DOMAIN"
curl -sI "https://$DOMAIN" || true

echo "=== Origin check via IP (requires server configured) ==="
if [[ -n "$EXPECTED_IP" ]]; then
  echo "-- curl -I http://$EXPECTED_IP (Host: $DOMAIN)"
  curl -sI -H "Host: $DOMAIN" "http://$EXPECTED_IP" || true
fi

echo "Done."

