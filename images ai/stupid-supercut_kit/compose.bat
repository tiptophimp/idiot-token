
@echo off
setlocal enabledelayedexpansion
mkdir work 2>nul

rem Normalize to 1080p/30, 5s each
for /l %%n in (1,1,7) do (
  set SRC=clips\clip0%%n.mp4
  set OUT=work\norm_clip0%%n.mp4
  if not exist !SRC! (
    echo Missing !SRC!
    exit /b 1
  )
  ffmpeg -y -i "!SRC!" -t 5 -vf "scale=1920:-2,fps=30" -c:v libx264 -preset veryfast -crf 20 -c:a aac -shortest "!OUT!"
)

rem Add captions
set FONT=C:\Windows\Fonts\arial.ttf
for /f "tokens=1,* delims=|" %%A in (captions.txt) do (
  set IDX=%%A
  set TXT=%%B
  set IN=work\norm_clip0!IDX!.mp4
  set OUT=work\cap_clip0!IDX!.mp4
  ffmpeg -y -i "!IN!" -vf "drawtext=fontfile='%FONT%':text=!TXT!:x=(w-text_w)/2:y=h-160:fontsize=48:fontcolor=white:box=1:boxcolor=0x000000AA" -c:a copy "!OUT!"
)

rem Concat
>list.txt (
  echo file 'work/cap_clip01.mp4'
  echo file 'work/cap_clip02.mp4'
  echo file 'work/cap_clip03.mp4'
  echo file 'work/cap_clip04.mp4'
  echo file 'work/cap_clip05.mp4'
  echo file 'work/cap_clip06.mp4'
  echo file 'work/cap_clip07.mp4'
)
ffmpeg -y -f concat -safe 0 -i list.txt -c copy tmp_concat.mp4

if exist bgm.mp3 (
  ffmpeg -y -i tmp_concat.mp4 -stream_loop -1 -i bgm.mp3 -shortest ^
    -filter_complex "acompressor=threshold=-16dB:ratio=3:attack=10:release=100, dynaudnorm" ^
    -c:v copy -c:a aac -b:a 192k stupid-supercut-1080p.mp4
) else (
  move /y tmp_concat.mp4 stupid-supercut-1080p.mp4 >nul
)

echo DONE ^> stupid-supercut-1080p.mp4
