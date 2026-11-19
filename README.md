# omarchy-sleep-config

Power and idle settings for Omarchy (Hyprland):

- Screensaver after **5 minutes**
- Idle lock **disabled**
- Suspend after **15 minutes of inactivity**
- Hibernate when on battery at or below **65%**

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
5. Install `/usr/local/bin/battery-hibernate-check` and the
   `battery-hibernate.service` / `battery-hibernate.timer` units.
6. Enable and start `battery-hibernate.timer`.

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

## Hibernate on battery

`battery-hibernate.timer` runs `battery-hibernate-check` once a minute.
It hibernates when:

- external power is **not** connected, and
- battery capacity is **≤ 65%**.

It re-arms when external power is connected or the charge rises above 65%.
State lives in `/run/battery-hibernate`, so resuming from hibernation at ≤65%
does not immediately hibernate again, while a cold boot on battery at ≤65%
will.

This is level-triggered, not idle-based: it will hibernate even while the
laptop is in active use.

### Requirements

Hibernation must work on the machine already:

```bash
busctl call org.freedesktop.login1 /org/freedesktop/login1 \
  org.freedesktop.login1.Manager CanHibernate
cat /sys/power/state                      # must include "disk"
swapon --show                             # swap must be large enough
```

### Changing the threshold

```bash
sudo systemctl edit battery-hibernate.service
```

Add:

```ini
[Service]
Environment=BATTERY_HIBERNATE_THRESHOLD=50
```

Then:

```bash
sudo systemctl daemon-reload
```

### Logs

```bash
journalctl -t battery-hibernate
```

## Notes

- Omarchy still has `omarchy-sleep-lock.service` enabled by default, which locks
  the session right before a suspend or hibernate. Disable it with
  `systemctl --user disable omarchy-sleep-lock.service` if you do not want a
  lock on resume.
- To undo the idle changes, restore the backup `shell.json.bak.<timestamp>` and
  remove `~/.config/hypr/hypridle.conf`.
- To undo the battery hibernate setup:

  ```bash
  sudo systemctl disable --now battery-hibernate.timer
  sudo rm /etc/systemd/system/battery-hibernate.{service,timer} \
          /usr/local/bin/battery-hibernate-check
  sudo systemctl daemon-reload
  ```
