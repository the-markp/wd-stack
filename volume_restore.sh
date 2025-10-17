#!/bin/bash

# Variables
VOLUME_NAME="mysql_data"
BACKUP_FILE="./docker_volume_backups/your_volume_name_backup_YYYYMMDD_HHMMSS.tar.gz"

# Check if backup file exists
if [ ! -f "$BACKUP_FILE" ]; then
  echo "Backup file '$BACKUP_FILE' not found!"
  exit 1
fi

# Restore the volume using a temporary container
docker run --rm \
  -v ${VOLUME_NAME}:/volume \
  -v $(dirname "$BACKUP_FILE"):/backup \
  alpine \
  sh -c "rm -rf /volume/* && tar xzf /backup/$(basename "$BACKUP_FILE") -C /volume"

echo "Volume '${VOLUME_NAME}' restored from '${BACKUP_FILE}'"