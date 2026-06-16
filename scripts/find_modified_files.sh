#!/bin/bash

# --- Script Name: find_modified_files.sh ---
# Description: Finds all files in a specified directory modified in the last N days.

# Helper function to print usage
print_usage() {
    echo "Usage: $0 [directory] [days]"
    echo "  directory: The path to search for modified files."
    echo "  days:      The number of days (positive integer) to look back."
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

# Get number of days
if [ -n "$2" ]; then
    DAYS="$2"
else
    read -p "Enter the number of days (N): " DAYS
fi

# Validate directory
if [ ! -d "$SEARCH_DIR" ]; then
    echo "Error: Directory '$SEARCH_DIR' does not exist." >&2
    exit 1
fi

# Validate days (must be a positive integer)
if [[ ! "$DAYS" =~ ^[0-9]+$ ]] || [ "$DAYS" -le 0 ]; then
    echo "Error: Days must be a positive integer." >&2
    exit 1
fi

# Resolve absolute path for clarity
ABS_DIR=$(cd "$SEARCH_DIR" && pwd)

echo "=========================================================="
echo "Searching for files modified in the last $DAYS day(s) in:"
echo "  $ABS_DIR"
echo "=========================================================="

# Find modified files
# -type f: find files only
# -mtime -$DAYS: modified less than DAYS days ago (i.e. within the last N days)
# Using find and displaying path and modification time/date
# We use printf to format the output with file path and modification time
# Note: macOS find might behave slightly differently than GNU find, so we write a portable find command
# and fallback to simple list if formatting flags aren't fully supported, or just print paths.
# Let's print paths and their last modified date in a cross-platform friendly way.

# Temporary array/list of files
FILES_FOUND=$(find "$ABS_DIR" -type f -mtime -"$DAYS" 2>/dev/null)

if [ -z "$FILES_FOUND" ]; then
    echo "No files modified in the last $DAYS day(s) were found."
else
    echo -e "Last Modified Date\t\tFile Path"
    echo -e "----------------------------------------------------------"
    while IFS= read -r file; do
        if [[ -n "$file" ]]; then
            # Get modification time in a portable way if possible
            if date -r "$file" >/dev/null 2>&1; then
                # macOS / BSD date
                MOD_DATE=$(date -r "$file" "+%Y-%m-%d %H:%M:%S")
            elif stat --format="%y" "$file" >/dev/null 2>&1; then
                # GNU stat
                MOD_DATE=$(stat --format="%y" "$file" | cut -d'.' -f1)
            else
                # Fallback if stat/date methods aren't compatible
                MOD_DATE="Unknown Date"
            fi
            echo -e "${MOD_DATE}\t${file}"
        fi
    done <<< "$FILES_FOUND"
fi

echo "=========================================================="
