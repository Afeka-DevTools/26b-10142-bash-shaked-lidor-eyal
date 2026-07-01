#!/bin/bash

# --- Script Name: check_website_access.sh ---
# Description: Checks the accessibility of websites from a given list.

# Helper function to print usage
print_usage() {
    echo "Usage: $0 [file]"
    echo "  file: A text file containing one website address per line."
}

# Check for help flags
if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    print_usage
    exit 0
fi

# Get file path
if [ -n "$1" ]; then
    URL_FILE="$1"
else
    read -p "Enter the file containing the website addresses: " URL_FILE
fi

# Validate file
if [ ! -f "$URL_FILE" ]; then
    echo "Error: File '$URL_FILE' does not exist." >&2
    exit 1
fi

# Resolve absolute path
ABS_FILE=$(cd "$(dirname "$URL_FILE")" && pwd)/$(basename "$URL_FILE")

echo "=========================================================="
echo "Checking website accessibility from:"
echo "  $ABS_FILE"
echo "=========================================================="

# Read each website and check accessibility
while IFS= read -r url || [ -n "$url" ]; do

    # Skip empty lines
    [ -z "$url" ] && continue

    printf "%-40s" "$url"

    if curl -Is --connect-timeout 5 "$url" > /dev/null 2>&1; then
        echo "Accessible"
    else
        echo "Not Accessible"
    fi

done < "$ABS_FILE"

echo "=========================================================="