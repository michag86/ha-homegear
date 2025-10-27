#!/usr/bin/env bash
set -euo pipefail

log() {
    echo "[$(date --iso-8601=seconds)] $*"
}

log "=== Starting Homegear Backup ==="

MOUNTED_ETC="/etc/homegear"
MOUNTED_LIB="/var/lib/homegear"
MOUNTED_LOG="/var/log/homegear"

DATA_ETC="/data/etc"
DATA_LIB="/data/lib"
DATA_LOG="/data/log"

log "Ensuring destination folders exist..."
mkdir -p "$DATA_ETC" "$DATA_LIB" "$DATA_LOG"

# 1) /etc/homegear (full backup)
log "Backing up config: $MOUNTED_ETC → $DATA_ETC"
rsync -av --delete "$MOUNTED_ETC/" "$DATA_ETC/" | tee /tmp/rsync_etc.log
log "Config backup complete, files copied:"
grep -E '^[^/]|\w' /tmp/rsync_etc.log || log "No changes."

# 2) /var/lib/homegear (filtered backup)
log "Backing up data: $MOUNTED_LIB → $DATA_LIB"
rsync -av --delete \
    --include="db.sql" \
    --include="devices/***" \
    --include="scripts/***" \
    --include="flows/***" \
    --include="flows-nodes/***" \
    --include="www/***" \
    --exclude="*" \
    "$MOUNTED_LIB/" "$DATA_LIB/" | tee /tmp/rsync_lib.log
log "Data backup complete, files copied:"
grep -E '^[^/]|\w' /tmp/rsync_lib.log || log "No changes."

# 3) Logs (optional full backup)
log "Backing up logs: $MOUNTED_LOG → $DATA_LOG"
rsync -av --delete "$MOUNTED_LOG/" "$DATA_LOG/" | tee /tmp/rsync_log.log
log "Log backup complete, files copied:"
grep -E '^[^/]|\w' /tmp/rsync_log.log || log "No changes."

# Mark backup timestamp
echo "$(date --iso-8601=seconds)" > /data/last_backup_run
log "Backup completed successfully."
