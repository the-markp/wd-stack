#!/bin/bash

# Variables
VOLUME_NAME="mysql_data"
BACKUP_DIR="/home/foxriver/backups"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
BACKUP_FILE="${BACKUP_DIR}/${VOLUME_NAME}_backup_${TIMESTAMP}.tar.gz"
RETENTION_DAYS=1							# Check

# Create backup directory if it doesn't exist
mkdir -p "$BACKUP_DIR"

# Create a temporary container to access the volume
docker run --rm \
  -v ${VOLUME_NAME}:/volume \
  -v ${BACKUP_DIR}:/backup \
  alpine \
  sh -c "tar czf /backup/$(basename $BACKUP_FILE) -C /volume ."

echo "Backup of volume '${VOLUME_NAME}' saved to '${BACKUP_FILE}'"

# === Backup source code ===

zip -r "app_$TIMESTAMP.zip" ./app
mv "app_$TIMESTAMP.zip" "$BACKUP_DIR/"

# === ROTATE OLD BACKUPS ===
find "$BACKUP_DIR" -mindepth 1 -mmin +$RETENTION_DAYS -exec rm -rf {} +
echo "Old backups older than $RETENTION_DAYS days removed."
echo "Backup completed successfully at $TIMESTAMP"