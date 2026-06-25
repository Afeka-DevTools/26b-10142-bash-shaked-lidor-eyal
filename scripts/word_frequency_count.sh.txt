#!/bin/bash

# --- Script Name: word_frequency_count.sh ---
# Description: Counts the frequency of words in a given text file.

# Helper function to print usage
print_usage() {
    echo "Usage: $0 [file]"
    echo "  file: The text file to analyze. If omitted, the script prompts for it."
}

# Check for help flags
if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    print_usage
    exit 0
fi

# Get file path
if [ -n "$1" ]; then
    INPUT_FILE="$1"
else
    read -p "Enter the file to analyze: " INPUT_FILE
fi

# Validate file
if [ ! -f "$INPUT_FILE" ]; then
    echo "Error: File '$INPUT_FILE' does not exist." >&2
    exit 1
fi

# Resolve absolute path for clarity
ABS_FILE=$(cd "$(dirname "$INPUT_FILE")" && pwd)/$(basename "$INPUT_FILE")

echo "=========================================================="
echo "Counting word frequency in:"
echo "  $ABS_FILE"
echo "=========================================================="

# Convert text to lowercase, split words into separate lines,
# remove empty lines, sort them, and count occurrences.
RESULTS=$(tr '[:upper:]' '[:lower:]' < "$ABS_FILE" \
    | tr -cs '[:alnum:]' '\n' \
    | grep -v '^$' \
    | sort \
    | uniq -c \
    | sort -rn)

if [ -z "$RESULTS" ]; then
    echo "No words found in the file."
else
    echo -e " Count\tWord"
    echo -e "------\t----"
    echo "$RESULTS" | while read -r count word; do
        printf " %5d\t%s\n" "$count" "$word"
    done
fi

echo "=========================================================="