#!/usr/bin/env bash
set -euo pipefail

# Normalize to 1080p/30, 5s each (tweak -t for per-clip timing)
for n in {1..7}; do
  src=$(printf "clips/clip%02d.mp4" "$n")
  out=$(printf "work/norm_clip%02d.mp4" "$n")
  mkdir -p work
  if [ ! -f "$src" ]; then echo "Missing $src" >&2; exit 1; fi
  ffmpeg -y -i "$src" -t 5 -vf "scale=1920:-2,fps=30" -c:v libx264 -preset veryfast -crf 20 -c:a aac -shortest "$out"
done

# Add captions
FONT="/Library/Fonts/Arial.ttf"
[ -f "$FONT" ] || FONT="/System/Library/Fonts/Supplemental/Arial.ttf"
[ -f "$FONT" ] || FONT="/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf"

while IFS='|' read -r idx text; do
  idx=$(echo "$idx" | xargs)
  text=$(echo "$text" | sed "s/'/\\'/g")
  in=$(printf "work/norm_clip%02d.mp4" "$idx")
  out=$(printf "work/cap_clip%02d.mp4" "$idx")
  ffmpeg -y -i "$in" -vf "drawtext=fontfile='${FONT}':text=${text}:x=(w-text_w)/2:y=h-160:fontsize=48:fontcolor=white:box=1:boxcolor=0x000000AA" -c:a copy "$out"
done < captions.txt

# Concat
rm -f list.txt
for n in {1..7}; do printf "file 'work/cap_clip%02d.mp4'\n" "$n"; done > list.txt
ffmpeg -y -f concat -safe 0 -i list.txt -c copy tmp_concat.mp4

# Optional music
if [ -f "bgm.mp3" ]; then
  ffmpeg -y -i tmp_concat.mp4 -stream_loop -1 -i bgm.mp3 -shortest     -filter_complex "acompressor=threshold=-16dB:ratio=3:attack=10:release=100,dynaudnorm"     -c:v copy -c:a aac -b:a 192k stupid-supercut-1080p.mp4
else
  mv tmp_concat.mp4 stupid-supercut-1080p.mp4
fi

echo "DONE -> stupid-supercut-1080p.mp4"
