#!/bin/bash

# =================================================================
# Script to delete files older than X days from a specific directory
# =================================================================

# 1. Check if 'find' utility is available (Requirement 2a)
if ! command -v find &> /dev/null; then
    echo "Error: 'find' utility is missing. Attempting to install findutils..."
    sudo apt-get update && sudo apt-get install -y findutils
    
    # Verify installation success
    if [ $? -ne 0 ]; then
        echo "Error: Failed to install findutils. Please install 'find' manually."
        exit 1
    fi
fi

# 2. Check if the required parameters are provided
# Expecting exactly 2 arguments: <directory_path> and <number_of_days>
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <directory_path> <number_of_days>"
    echo "Example: $0 ./dummy_project_files 7"
    exit 1
fi

TARGET_DIR="$1"
DAYS="$2"

# 3. Check if the target directory exists
if [ ! -d "$TARGET_DIR" ]; then
    echo "Error: Directory '$TARGET_DIR' does not exist."
    exit 1
fi

# 4. Validate that DAYS is a positive integer
if ! [[ "$DAYS" =~ ^[0-9]+$ ]]; then
    echo "Error: Number of days must be a valid positive integer."
    exit 1
fi

echo "Searching for files in '$TARGET_DIR' older than $DAYS days..."
echo "------------------------------------------------------------"

# 5. Count how many files match the criteria before deleting
# -mtime +X matches files modified more than X days ago
FILE_COUNT=$(find "$TARGET_DIR" -type f -mtime +"$DAYS" | wc -l)

if [ "$FILE_COUNT" -eq 0 ]; then
    echo "No files found older than $DAYS days in '$TARGET_DIR'."
    exit 0
fi

echo "Found $FILE_COUNT file(s) to delete:"
# List the files that will be deleted for log transparency
find "$TARGET_DIR" -type f -mtime +"$DAYS" -print
echo "------------------------------------------------------------"

# 6. Perform the deletion safely
find "$TARGET_DIR" -type f -mtime +"$DAYS" -delete

# 7. Verify exit status
if [ $? -eq 0 ]; then
    echo "Success: Successfully deleted $FILE_COUNT file(s)."
else
    echo "Error: Something went wrong during the deletion process."
    exit 1
fi
