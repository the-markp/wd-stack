#!/bin/bash

# === CONFIGURATION ===
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")		# Check
BACKUP_DIR="/home/foxriver/backups"			# Check
CONTAINER_NAME="mysql_db"					# Check
MYSQL_USER="root"							# Check
MYSQL_PASSWORD="rootpassword"				# Check
RETENTION_DAYS=1							# Check

# === CREATE BACKUP DIRECTORY ===
mkdir -p "$BACKUP_DIR"

# === RUN BACKUP ===
echo "Starting MySQL backup from container: $CONTAINER_NAME"
docker exec $CONTAINER_NAME mysqldump -u $MYSQL_USER -p$MYSQL_PASSWORD mydb > "$BACKUP_DIR/mysql_backup_$TIMESTAMP.sql"

# === Backup site assets ===

#cp -r ./app/public "$BACKUP_DIR/app_public_$TIMESTAMP"
#cp -r ./app/uploads "$BACKUP_DIR/app_uploads_$TIMESTAMP"
#cp -r ./app/storage "$BACKUP_DIR/app_storage_$TIMESTAMP"
zip -r "site_assets_$TIMESTAMP.zip" ./app/public ./app/uploads ./app/storage
mv "site_assets_$TIMESTAMP.zip" "$BACKUP_DIR/"

# === COMPRESS BACKUP ===
#zip -r "$BACKUP_DIR/site_assets_$TIMESTAMP" "$BACKUP_DIR/app_public_$TIMESTAMP" "$BACKUP_DIR/app_uploads_$TIMESTAMP" "$BACKUP_DIR/app_storage_$TIMESTAMP"
gzip "$BACKUP_DIR/mysql_backup_$TIMESTAMP.sql"
BACKUP_FILE="$BACKUP_DIR/mysql_backup_$TIMESTAMP.sql.gz"
echo "Backup compressed: $(basename $BACKUP_FILE)"

# === ROTATE OLD BACKUPS ===
#find "$BACKUP_DIR" -type f -name "*.sql.gz" -mtime +$RETENTION_DAYS -exec rm {} \;
#find "$BACKUP_DIR" -type f -mmin +5 -exec rm -f {} \; 
#find "$BACKUP_DIR" -type d -mmin +5 -exec rmdir {} \;
find "$BACKUP_DIR" -mindepth 1 -mmin +$RETENTION_DAYS -exec rm -rf {} +
echo "Old backups older than $RETENTION_DAYS days removed."
echo "Backup completed successfully at $TIMESTAMP"
