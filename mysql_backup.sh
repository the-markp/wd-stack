#!/bin/bash

# === CONFIGURATION ===
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
BACKUP_DIR="/home/user/backups"
CONTAINER_NAME="mysql_db"
MYSQL_USER="root"
MYSQL_PASSWORD="UserSecure123"
RETENTION_DAYS=7
RCLONE_REMOTE="gdrive"
RCLONE_DEST="MySQLBackups"
EMAIL="email@example.com"

# === CREATE BACKUP DIRECTORY ===
mkdir -p "$BACKUP_DIR"

# === RUN BACKUP ===
echo "Starting MySQL backup from container: $CONTAINER_NAME"
docker exec $CONTAINER_NAME   mysqldump -u $MYSQL_USER -p$MYSQL_PASSWORD --all-databases   > "$BACKUP_DIR/mysql_backup_$TIMESTAMP.sql"

# === COMPRESS BACKUP ===
gzip "$BACKUP_DIR/mysql_backup_$TIMESTAMP.sql"
BACKUP_FILE="$BACKUP_DIR/mysql_backup_$TIMESTAMP.sql.gz"
echo "Backup compressed: $(basename $BACKUP_FILE)"

# === UPLOAD TO GOOGLE DRIVE ===
#echo "Uploading backup to Google Drive..."
#rclone copy "$BACKUP_FILE" "$RCLONE_REMOTE:$RCLONE_DEST/"
#UPLOAD_STATUS=$?

# === ROTATE OLD BACKUPS ===
find "$BACKUP_DIR" -type f -name "*.sql.gz" -mtime +$RETENTION_DAYS -exec rm {} \;
echo "Old backups older than $RETENTION_DAYS days removed."

# === SEND EMAIL NOTIFICATION ===
#if [ $UPLOAD_STATUS -eq 0 ]; then
#  STATUS_MSG="Backup and upload completed successfully."
#else
#  STATUS_MSG="Backup completed, but upload to Google Drive failed."
#fi

echo -e "MySQL Backup Report

Backup File: $(basename $BACKUP_FILE)
Status: $STATUS_MSG
Timestamp: $TIMESTAMP" | mail -s "MySQL Backup Completed" $EMAIL

echo "Backup completed successfully at $TIMESTAMP"
