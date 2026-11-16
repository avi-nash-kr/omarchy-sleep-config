# omarchy-sleep-config

Idle and suspend settings for Omarchy (Hyprland):

- Screensaver after **5 minutes**
- Idle lock **disabled**
- Suspend after **15 minutes of inactivity**

## Install

```bash
git clone https://github.com/avi-nash-kr/omarchy-sleep-config.git
cd omarchy-sleep-config
./install.sh
```

`install.sh` will:

1. Install `hypridle` via pacman if it is missing.
2. Write `~/.config/hypr/hypridle.conf` with a 15-minute suspend listener.
3. Update `~/.config/omarchy/shell.json`:
   - `idle.screensaver = 300`
   - `idle.lock = 0` (disabled)
4. Enable and start `hypridle.service` for the current user.

## Omarchy shell idle settings

The resulting `idle` block in `~/.config/omarchy/shell.json` is:

```json
"idle": {
  "lock": 0,
  "screensaver": 300
}
```

Set a value to `0` to disable that action. Omarchy hot-reloads `shell.json`.

## Suspend

`~/.config/hypr/hypridle.conf`:

```ini
listener {
    timeout = 900
    on-timeout = systemctl suspend
}
```

Hypridle respects idle inhibitors, so video playback and similar activities
keep the system awake.

## Notes

- Omarchy still has `omarchy-sleep-lock.service` enabled by default, which locks
  the session right before a suspend. Disable it with
  `systemctl --user disable omarchy-sleep-lock.service` if you do not want a
  lock on resume.
- To undo the idle changes, restore the backup `shell.json.bak.<timestamp>` and
  remove `~/.config/hypr/hypridle.conf`.
