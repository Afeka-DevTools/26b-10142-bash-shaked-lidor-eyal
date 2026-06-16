#!/bin/bash

# =================================================================
# Script to add a prefix to all .txt files in a specific directory
# =================================================================

# 1. Check if the required parameters are provided
# Expecting exactly 2 arguments: <directory_path> and <prefix>
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <directory_path> <prefix>"
    echo "Example: $0 ./my_folder backup_"
    exit 1
fi

TARGET_DIR="$1"
PREFIX="$2"

# 2. Check if the target directory exists
if [ ! -d "$TARGET_DIR" ]; then
    echo "Error: Directory '$TARGET_DIR' does not exist."
    exit 1
fi

# 3. Enable nullglob so the loop doesn't execute if no .txt files match
shopt -s nullglob
TXT_FILES=("$TARGET_DIR"/*.txt)

# Check if there are actually any .txt files to process
if [ ${#TXT_FILES[@]} -eq 0 ]; then
    echo "No .txt files found in directory '$TARGET_DIR'."
    exit 0
fi

echo "Adding prefix '$PREFIX' to all .txt files in '$TARGET_DIR'..."
echo "------------------------------------------------"

# 4. Loop through each discovered .txt file and rename it
COUNTER=0
for FILE_PATH in "${TXT_FILES[@]}"; do
    # Separate the directory path from the filename
    DIR=$(dirname "$FILE_PATH")
    FILENAME=$(basename "$FILE_PATH")
    
    # Construct the new filename and full path
    NEW_FILENAME="${PREFIX}${FILENAME}"
    NEW_FILE_PATH="${DIR}/${NEW_FILENAME}"
    
    # Rename the file using move (mv)
    mv "$FILE_PATH" "$NEW_FILE_PATH"
    
    echo "Renamed: $FILENAME -> $NEW_FILENAME"
    ((COUNTER++))
done

echo "------------------------------------------------"
echo "Success: Successfully renamed $COUNTER files."
