#!/bin/bash
# Records one tool in a real Ghostty window and writes a GIF. macOS only.
# Usage: rec.sh NAME COLS ROWS MAX_SECONDS CWD SCRIPT_JSON OUT_GIF
set -euo pipefail
name=$1 cols=$2 rows=$3 secs=$4 cwd=$5 script=$6 out=$7
here=$(cd "$(dirname "$0")" && pwd)
work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT

for tool in bounds park; do
  [ -x "$here/$tool" ] || swiftc -O "$here/$tool.swift" -o "$here/$tool"
done

marker="$work/done"
wrapper="$work/run.sh"
printf '#!/bin/bash\nexec /usr/bin/python3 %q %q %q %q\n' "$here/puppet.py" "$cwd" "$script" "$marker" > "$wrapper"
chmod +x "$wrapper"

open -na /Applications/Ghostty.app --args \
  --config-default-files=false --title="$name" \
  --window-width="$cols" --window-height="$rows" --font-size=15 \
  --background=0d1117 --foreground=d6dde6 --background-opacity=1 \
  --window-padding-x=18 --window-padding-y=14 --window-padding-balance=true \
  --cursor-style=bar --quit-after-last-window-closed=true --confirm-close-surface=false \
  --macos-titlebar-style=native --initial-window=true --window-save-state=never \
  --command="$wrapper"

rect=""
for _ in $(seq 1 50); do rect=$("$here/bounds" "$name" 2>/dev/null) && break; sleep 0.1; done
[ -n "$rect" ] || { echo "the Ghostty window did not open" >&2; exit 1; }

"$here/park"
now() { python3 -c 'import time; print(time.time())'; }
start=$(now)
screencapture -x -v -V "$secs" -R"$rect" "$work/take.mov" &
capture=$!
for _ in $(seq 1 $((secs * 10))); do [ -f "$marker" ] && break; sleep 0.1; done
skip=1.4
length=$(python3 -c "print(round($(now) - $start + 2.5 - $skip, 2))")
wait "$capture" || true
pkill -f -- "--title=$name " || true

ffmpeg -loglevel error -y -ss "$skip" -t "$length" -i "$work/take.mov" -vf \
  "fps=14,scale=1000:-1:flags=lanczos,split[a][b];[a]palettegen=stats_mode=diff[p];[b][p]paletteuse=dither=bayer:bayer_scale=4:diff_mode=rectangle" \
  "$out"
echo "$out"
