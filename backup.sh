#!/bin/bash
# Before use make sure to check rsync options line 21
# Usage: backup.sh <source_directory> <destination_directory>
# Checking if exactly two arguments are entered.
if [ $# -ne 2 ]; then 
    echo "Usage: backup.sh <source_directory> <destination_directory>"
    echo "Please try again"
    exit 1
fi

# Checking if rsync is installed
if ! command -v rsync > /dev/null 2>&1; then
    echo "This script requires rsync to be installed"
    echo "Please install rsync and try again"
    exit 2
fi

# Capture the current date and store it in the YYYY-MM-DD format
current_date=$(date +%Y-%m-%d)

# Setting rsync command to execute. Add or delete "--dry-run" in the end to test script
rsync_options="-avb --backup-dir=\"$2/$current_date\" --delete --dry-run"

# Execute rsync command
rsync $rsync_options "$1" "$2/current" >>backup_"$current_date".log
