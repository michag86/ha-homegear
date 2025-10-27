# Homegear Home Assistant Add-on

This repository packages the [Homegear](https://homegear.eu/index.php/Main_Page) smart home daemon as a Home Assistant add-on. The container keeps configuration persistent by backing up Homegear data to `/data` and restoring it on startup, making it suitable for long running Home Assistant deployments.

[![Open your Home Assistant instance and add this repository.](https://my.home-assistant.io/badges/supervisor_add_repository.svg)](https://my.home-assistant.io/redirect/supervisor_add_repository/?repository_url=https%3A%2F%2Fgithub.com%2Fdeg0nz%2Fha-homegear)

## Features

- Installs the official `homegear/homegear` container image
- Automatically restores previous configuration from `/data` when the add-on starts
- Periodically backs up Homegear state to `/data` for persistence across upgrades or rebuilds
- Exposes Homegear management ports `2001`–`2003` and optional HTTP(S) interface

## Installation

1. In Home Assistant, navigate to **Settings → Add-ons → Add-on Store**.
2. Open the menu (three dots) in the top-right corner and choose **Repositories**.
3. Add this repository URL: `https://github.com/deg0nz/ha-homegear`.
4. Locate **Homegear** in the add-on list, click it, and select **Install**.

## Configuration

The add-on ships with sane defaults and requires no additional configuration to start. Ports are mapped to match the default Homegear setup:

| Port | Description             |
| ---- | ----------------------- |
| 5000 | Homegear HTTP interface |
| 5443 | Homegear HTTPS interface|
| 2001 | HomeMatic BidCoS        |
| 2002 | HomeMatic IP            |
| 2003 | HomeMatic Wired         |

Backups are written to `/data/homegear-backup`. You can adjust or expand the backup logic in `backup.sh` and `restore.sh` if you need to persist additional paths.

## Maintenance

- To trigger a manual backup, execute `/backup.sh` inside the container.
- Review the scripts `backup.sh`, `restore.sh`, and `entrypoint.sh` to customize behaviour such as cron scheduling or backup destinations.
- Standard updates are handled by Home Assistant. Rebuilds restore the latest backup on startup.
- Homegear's SQLite backend may delay flushing writes to disk. After applying changes inside Homegear, keep the add-on running for a little while before restarting so that the next scheduled backup contains the updated database. Avoid taking immediate snapshots right after edits, or you risk capturing an outdated state.

## Contributing

Issues and pull requests are welcome. If you encounter problems, please include add-on logs and describe your environment so we can reproduce the issue quickly.
