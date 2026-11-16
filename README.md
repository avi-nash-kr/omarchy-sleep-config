# omarchy-sleep-config

Drop-in config for systemd sleep settings (suspend + suspend-then-hibernate).

## Settings

- `AllowSuspend=yes`
- `AllowHibernate=yes`
- `AllowSuspendThenHibernate=yes`
- `HibernateDelaySec=2h` (hibernate 2 hours after suspend when using suspend-then-hibernate)

## Install

```bash
./install.sh
```

Or manually:

```bash
sudo mkdir -p /etc/systemd/sleep.conf.d
sudo install -m 644 omarchy-sleep.conf /etc/systemd/sleep.conf.d/omarchy-sleep.conf
```

## Notes

- Takes effect for future sleep actions.
- `suspend-then-hibernate` requires a working hibernation setup (sufficient swap and resume configured). If hibernation is not set up, the system may remain suspended.
