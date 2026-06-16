#!/bin/bash

# =================================================================
# Script to backup a directory into a compressed archive (tar.gz)
# =================================================================

# 1. Check if 'tar' is installed (Requirement 2a)
if ! command -v tar &> /dev/null; then
    echo "Error: 'tar' is not installed. Attempting to install..."
    
    # Attempt installation (Targeted for Debian/Ubuntu environments like vLab)
    sudo apt-get update && sudo apt-get install -y tar
    
    # Verify if installation succeeded
    if [ $? -ne 0 ]; then
        echo "Error: Installation of tar failed. Please install it manually."
        exit 1
    fi
fi

# 2. Check if the required parameters are provided
if [ "$#" -lt 1 ]; then
    echo "Usage: $0 <source_directory> [destination_directory]"
    echo "Example: $0 /home/user/documents /home/user/backups"
    exit 1
fi

SRC_DIR="$1"
# Default to current directory if destination is not provided
DEST_DIR="${2:-.}"

# 3. Check if the source directory exists
if [ ! -d "$SRC_DIR" ]; then
    echo "Error: Source directory '$SRC_DIR' does not exist."
    exit 1
fi

# 4. Check if the destination directory exists (create if not)
if [ ! -d "$DEST_DIR" ]; then
    echo "Destination directory does not exist. Creating: $DEST_DIR"
    mkdir -p "$DEST_DIR"
fi

# 5. Define backup filename with a unique timestamp
DIR_NAME=$(basename "$SRC_DIR")
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_FILE="${DEST_DIR}/${DIR_NAME}_backup_${TIMESTAMP}.tar.gz"

echo "Starting backup of directory '$SRC_DIR'..."

# 6. Execute the backup
# -C changes the directory temporarily to avoid saving absolute paths inside the archive
tar -czf "$BACKUP_FILE" -C "$(dirname "$SRC_DIR")" "$(basename "$SRC_DIR")"

# 7. Check exit status
if [ $? -eq 0 ]; then
    echo "------------------------------------------------"
    echo "Backup completed successfully!"
    echo "Archive created at: $BACKUP_FILE"
    echo "------------------------------------------------"
else
    echo "Error: Backup creation failed."
    exit 1
fi
