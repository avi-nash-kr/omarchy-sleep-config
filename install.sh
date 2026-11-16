#!/usr/bin/env bash
set -euo pipefail
dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
sudo mkdir -p /etc/systemd/sleep.conf.d
sudo install -m 644 "$dir/omarchy-sleep.conf" /etc/systemd/sleep.conf.d/omarchy-sleep.conf
echo "Installed /etc/systemd/sleep.conf.d/omarchy-sleep.conf"
echo "Note: suspend-then-hibernate requires working hibernation (swap + resume)."
