#!/bin/bash

MEGA_FOLDER_PATH="/path/to/MEGA/backup/folder"
LOCAL_BACKUP_DIR="/path/to/local/backup/folder"
DATE=$(date +"%Y-%m-%d_%H-%M-%S")

DB_NAMES=("db1" "db2" "db3" "db4" "db5")

# Function
backup_database() {
        local DB_NAME=$1
        local BACKUP_FILENAME="${DB_NAME}_${DATE}.sql"

        mysqldump --defaults-file=${SCRIPT_DIR}.my.cnf ${DB_NAME} > ${LOCAL_BACKUP_DIR}/${BACKUP_FILENAME}

        if [ $? -eq 0 ]; then
                echo "Database backup successful: ${BACKUP_FILENAME}"
        else
                echo "Error: Database backup failed for ${DB_NAME}"
                return 1
        fi

        mega-put ${LOCAL_BACKUP_DIR}/${BACKUP_FILENAME} ${MEGA_FOLDER_PATH}

        if [ $? -eq 0 ]; then
                echo "Backup for ${DB_NAME} uploaded to MEGA successfully"
        else
                echo "Error: Backup upload to MEGA failed for ${DB_NAME}"
                return 1
        fi
        return 0
}

for DB_NAME in "${DB_NAMES[@]}"
do
        echo "Backing up database: ${DB_NAME}"
        backup_database ${DB_NAME}
done