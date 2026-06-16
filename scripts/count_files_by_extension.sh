#!/bin/bash

# --- Script Name: count_files_by_extension.sh ---
# Description: Recursively counts files by their extension in a given directory.

# Helper function to print usage
print_usage() {
    echo "Usage: $0 [directory]"
    echo "  directory: The directory path to scan. If omitted, the script prompts for it."
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
    read -p "Enter the directory to scan: " SEARCH_DIR
fi

# Validate directory
if [ ! -d "$SEARCH_DIR" ]; then
    echo "Error: Directory '$SEARCH_DIR' does not exist." >&2
    exit 1
fi

# Resolve absolute path for clarity
ABS_DIR=$(cd "$SEARCH_DIR" && pwd)

echo "=========================================================="
echo "Counting files by extension in: "
echo "  $ABS_DIR"
echo "=========================================================="

# Find files recursively and process their extensions
# Using find with -print0 to handle spaces and special characters in filenames safely.
# We extract the extension, convert it to lowercase for case-insensitive grouping,
# and count them using sort and uniq.

# We will store the counts in an associative array or use pipe-based sorting.
# Associative arrays require Bash 4+. Using pipe-based sorting is more compatible.
# Note: ${ext,,} is Bash 4+ syntax. For maximum compatibility we can also use 'tr'.
# Let's use tr to lowercase the extension.

RESULTS=$(find "$ABS_DIR" -type f -print0 2>/dev/null | while IFS= read -r -d '' file; do
    filename=$(basename "$file")
    if [[ "$filename" == *.* && "$filename" != .* ]]; then
        # Extract extension (text after the last dot)
        ext="${filename##*.}"
        # Convert to lowercase using tr for compatibility
        echo "$ext" | tr '[:upper:]' '[:lower:]'
    else
        echo "(no extension)"
    fi
done | sort | uniq -c | sort -rn)

if [ -z "$RESULTS" ]; then
    echo "No files found in the directory."
else
    echo -e " Count\tExtension"
    echo -e "------\t---------"
    # Print the results, aligning count and extension
    echo "$RESULTS" | while read -r count ext; do
        printf " %5d\t%s\n" "$count" "$ext"
    done
fi

echo "=========================================================="
