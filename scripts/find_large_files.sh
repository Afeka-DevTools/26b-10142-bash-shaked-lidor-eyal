#!/bin/bash

# --- Script Name: find_large_files.sh ---
# Description: Searches for files in a directory larger than a specified size threshold.

# Helper function to print usage
print_usage() {
    echo "Usage: $0 [directory] [size_threshold]"
    echo "  directory:      The directory to search."
    echo "  size_threshold: The size limit (e.g., 10M, 500K, 2G, or bytes). Use K, M, G suffixes."
    echo "If arguments are omitted, the script will prompt you interactively."
}

# Check for help flags
if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    print_usage
    exit 0
fi

# Get directory path
if [ -n "$1" ]; then
    SEARCH_DIR="$1"
else
    read -p "Enter the directory to search: " SEARCH_DIR
fi

# Get size threshold
if [ -n "$2" ]; then
    THRESHOLD="$2"
else
    read -p "Enter the size threshold (e.g., 500K, 10M, 2G): " THRESHOLD
fi

# Validate directory
if [ ! -d "$SEARCH_DIR" ]; then
    echo "Error: Directory '$SEARCH_DIR' does not exist." >&2
    exit 1
fi

# Validate size threshold pattern
if [[ ! "$THRESHOLD" =~ ^[0-9]+[kKmMgGbBcC]?$ ]]; then
    echo "Error: Invalid size format. Use numbers optionally followed by K, M, or G (e.g., 10M, 500K, 2G)." >&2
    exit 1
fi

# Parse size threshold for the 'find' command
NUM=$(echo "$THRESHOLD" | grep -oE '^[0-9]+')
UNIT=$(echo "$THRESHOLD" | grep -oE '[a-zA-Z]$')

case "$UNIT" in
    [kK]) FIND_UNIT="k" ;;
    [mM]) FIND_UNIT="M" ;;
    [gG]) FIND_UNIT="G" ;;
    [cC]|"") FIND_UNIT="c" ;;
    *) FIND_UNIT="c" ;;
esac

FIND_SIZE="+${NUM}${FIND_UNIT}"

# Resolve absolute path for clarity
ABS_DIR=$(cd "$SEARCH_DIR" && pwd)

echo "=========================================================="
echo "Searching for files larger than $THRESHOLD in:"
echo "  $ABS_DIR"
echo "=========================================================="

# Find files and print them with human-readable size
# We use du -sh to display sizes cleanly.
# find's -size +X finds files STRICTLY LARGER than X.

# Collect matching files
FILES_FOUND=$(find "$ABS_DIR" -type f -size "$FIND_SIZE" -print0 2>/dev/null)

if [ -z "$FILES_FOUND" ]; then
    echo "No files larger than $THRESHOLD were found."
else
    echo -e "Size\t\tFile Path"
    echo -e "----\t\t---------"
    # We read the null-terminated paths outputted by find
    find "$ABS_DIR" -type f -size "$FIND_SIZE" -print0 2>/dev/null | while IFS= read -r -d '' file; do
        # Extract human readable size using du
        # fallback to ls -lh or stat if du fails
        HUMAN_SIZE=$(du -sh "$file" 2>/dev/null | cut -f1)
        if [ -z "$HUMAN_SIZE" ]; then
            HUMAN_SIZE="Unknown"
        fi
        printf "%-10s\t%s\n" "$HUMAN_SIZE" "$file"
    done
fi

echo "=========================================================="
