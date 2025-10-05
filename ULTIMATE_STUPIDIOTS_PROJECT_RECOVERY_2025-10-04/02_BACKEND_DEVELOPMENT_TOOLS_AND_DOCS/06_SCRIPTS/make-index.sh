#!/usr/bin/env bash
set -euo pipefail

src="stupidiots_one_page_static_site_index.html"
dst="index.html"

if [[ ! -f "$src" ]]; then
  echo "Source file not found: $src" >&2
  exit 1
fi

cp -f "$src" "$dst"
echo "Wrote $dst from $src"

