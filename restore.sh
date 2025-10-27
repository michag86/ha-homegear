#!/usr/bin/env bash

# Directories
MOUNTED_ETC="/etc/homegear"
MOUNTED_LIB="/var/lib/homegear"
MOUNTED_LOG="/var/log/homegear"

DATA_ETC="/data/etc"
DATA_LIB="/data/lib"
DATA_LOG="/data/log"

set -e

echo "Starting Homegear Restore..."

# Function to check if a directory exists and is not empty
restore_if_exists() {
  SRC="$1"
  DEST="$2"
  if [ -d "$SRC" ] && [ "$(ls -A "$SRC")" ]; then
    echo "Restoring $SRC to $DEST"
    rsync -av "$SRC/" "$DEST/"
  else
    echo "Skipping $SRC: Directory does not exist or is empty."
  fi
}

restore_if_exists "$DATA_ETC" "$MOUNTED_ETC"
restore_if_exists "$DATA_LIB" "$MOUNTED_LIB"
#restore_if_exists "$DATA_LOG" "$MOUNTED_LOG"

echo "Restore completed successfully."
