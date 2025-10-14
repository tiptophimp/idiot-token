#!/usr/bin/env bash
set -euo pipefail

usage() {
  echo "Usage: $0 -h <host> [-u user] [-k key] [-s source_dir] [-r remote_dir]"
  echo "Defaults: user=deploy, source_dir=./public_html, remote_dir=/var/www/stupidiots.com/public_html"
}

HOST=""
USER="deploy"
KEY=""
SRC_DIR="./public_html"
REMOTE_DIR="/var/www/stupidiots.com/public_html"

while getopts ":h:u:k:s:r:" opt; do
  case $opt in
    h) HOST="$OPTARG" ;;
    u) USER="$OPTARG" ;;
    k) KEY="$OPTARG" ;;
    s) SRC_DIR="$OPTARG" ;;
    r) REMOTE_DIR="$OPTARG" ;;
    *) usage; exit 1 ;;
  esac
done

if [[ -z "$HOST" ]]; then
  usage; exit 1
fi

if [[ ! -d "$SRC_DIR" ]]; then
  echo "Source dir not found: $SRC_DIR" >&2
  exit 1
fi

TIMESTAMP=$(date +%Y%m%d_%H%M%S)
ARCHIVE="site_upload_${TIMESTAMP}.tar.gz"

echo "Packing $SRC_DIR into $ARCHIVE ..."
tar -czf "$ARCHIVE" -C "$SRC_DIR" .

SCP_OPTS=()
SSH_OPTS=()
if [[ -n "$KEY" ]]; then
  SCP_OPTS+=( -i "$KEY" )
  SSH_OPTS+=( -i "$KEY" )
fi

echo "Uploading archive to $USER@$HOST:/tmp/$ARCHIVE ..."
scp "${SCP_OPTS[@]}" "$ARCHIVE" "$USER@$HOST:/tmp/$ARCHIVE"

echo "Deploying on remote host ..."
ssh "${SSH_OPTS[@]}" "$USER@$HOST" bash -s <<EOF
set -euo pipefail
sudo mkdir -p "$REMOTE_DIR"
sudo rm -rf "${REMOTE_DIR:?}/"*
sudo tar -xzf "/tmp/$ARCHIVE" -C "$REMOTE_DIR"
sudo chown -R www-data:www-data "$REMOTE_DIR"
sudo chmod -R 755 "$REMOTE_DIR"
sudo rm -f "/tmp/$ARCHIVE"
sudo nginx -t && sudo systemctl reload nginx || true
EOF

echo "Deployment complete: https://stupidiots.com/"
rm -f "$ARCHIVE"

