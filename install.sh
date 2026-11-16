#!/usr/bin/env bash
set -euo pipefail

dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# 1. Hypridle (Arch/Omarchy)
if ! command -v hypridle >/dev/null 2>&1; then
  sudo pacman -S --needed --noconfirm hypridle
fi

# 2. Hypridle config: suspend after 15 minutes of inactivity
mkdir -p "$HOME/.config/hypr"
install -m 644 "$dir/hypridle.conf" "$HOME/.config/hypr/hypridle.conf"

# 3. Omarchy shell idle: screensaver at 5 minutes, idle lock disabled
shell_json="$HOME/.config/omarchy/shell.json"
mkdir -p "$(dirname "$shell_json")"
if [ ! -f "$shell_json" ]; then
  printf '{\n  "version": 1\n}\n' > "$shell_json"
fi
cp "$shell_json" "$shell_json.bak.$(date +%s)"
python3 - "$shell_json" <<'PY'
import json
import sys

path = sys.argv[1]
with open(path) as f:
    config = json.load(f)

config.setdefault("idle", {})
config["idle"]["screensaver"] = 300
config["idle"]["lock"] = 0

with open(path, "w") as f:
    json.dump(config, f, indent=2)
    f.write("\n")
PY

# 4. Start hypridle now and on every login
systemctl --user enable --now hypridle.service

echo "Done: screensaver 5 min, idle lock disabled, suspend after 15 min."
