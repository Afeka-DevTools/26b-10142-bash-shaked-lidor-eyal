#!/bin/bash

# =================================================================
# Script to count lines, words, and characters in each file of a directory
# =================================================================

# 1. Check if 'wc' utility is available (Requirement 2a)
if ! command -v wc &> /dev/null; then
    echo "Error: 'wc' utility is missing. Attempting to install coreutils..."
    sudo apt-get update && sudo apt-get install -y coreutils
    
    # Verify installation success
    if [ $? -ne 0 ]; then
        echo "Error: Failed to install coreutils. Please install 'wc' manually."
        exit 1
    fi
fi

# 2. Check if the directory parameter is provided
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <directory_path>"
    echo "Example: $0 ./dummy_project_files"
    exit 1
fi

TARGET_DIR="$1"

# 3. Check if the target directory exists
if [ ! -d "$TARGET_DIR" ]; then
    echo "Error: Directory '$TARGET_DIR' does not exist."
    exit 1
fi

echo "Analyzing files in directory: $TARGET_DIR"
echo "------------------------------------------------------------"
# Print a formatted table header
printf "%-25s %-10s %-10s %-10s\n" "File Name" "Lines" "Words" "Characters"
echo "------------------------------------------------------------"

# 4. Loop through all items in the directory
shopt -s nullglob
FOUND_FILES=0

for FILE_PATH in "$TARGET_DIR"/*; do
    # Process only regular files (skip directories, symlinks, etc.)
    if [ -f "$FILE_PATH" ]; then
        FILENAME=$(basename "$FILE_PATH")
        
        # Extract statistics using 'wc'
        # Using redirection (<) prevents wc from printing the filename in the raw output
        LINES=$(wc -l < "$FILE_PATH")
        WORDS=$(wc -w < "$FILE_PATH")
        CHARS=$(wc -m < "$FILE_PATH") # -m handles characters accurately
        
        # Print the formatted row
        printf "%-25s %-10s %-10s %-10s\n" "$FILENAME" "$LINES" "$WORDS" "$CHARS"
        ((FOUND_FILES++))
    fi
done

echo "------------------------------------------------------------"
if [ $FOUND_FILES -eq 0 ]; then
    echo "No regular files found inside '$TARGET_DIR'."
else
    echo "Analysis complete. Processed $FOUND_FILES file(s)."
fi
