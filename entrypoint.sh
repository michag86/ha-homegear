#!/usr/bin/env bash

_term() {
	echo "[INFO] Received termination signal"

	echo "[INFO] Running backup script..."

	/backup.sh

	echo "[INFO] Shutting down..."

	HOMEGEAR_PID=$(cat /var/run/homegear/homegear.pid)
	kill $(cat /var/run/homegear/homegear-management.pid)
	kill $(cat /var/run/homegear/homegear-webssh.pid)
	kill $(cat /var/run/homegear/homegear-influxdb.pid)
	kill $HOMEGEAR_PID
	wait "$HOMEGEAR_PID"
	/etc/homegear/homegear-stop.sh
	exit 0
}

trap _term SIGTERM

# Init backup cron job
CRON_JOB="*/15 * * * * root /backup.sh"

echo "[INFO] Checking if the we need to init backup cron job"
if ! grep -Fxq "$CRON_JOB" /etc/crontab; then
    echo "$CRON_JOB" >> /etc/crontab
    echo "[INFO] Cron job added to /etc/crontab"
else
    echo "[INFO] Cron job already exists in /etc/crontab"
fi

echo "[INFO] Running restore script..."
/restore.sh

# Optional: Logging
echo "[INFO] Starting Homegear..."

# Start Homegear in foreground
/start.sh &
pid=$!

wait "$pid"
