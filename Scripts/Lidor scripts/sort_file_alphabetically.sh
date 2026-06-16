#!/bin/bash

# --- Script Name: sort_file_alphabetically.sh ---
# Description: Sorts the lines of a text file alphabetically with options for standard out, new file, or in-place.

# Helper function to print usage
print_usage() {
    echo "Usage: $0 <input_file> [options]"
    echo "Options:"
    echo "  -i, --in-place          Sort the file in-place (overwrites the input file)."
    echo "  -o, --output <file>     Save the sorted content to a specified output file."
    echo "  -f, --ignore-case       Sort ignoring case (case-insensitive)."
    echo "  -h, --help              Display this help menu."
    echo ""
    echo "If run without output options, the script will prompt you interactively."
}

# Variable defaults
IN_PLACE=false
OUTPUT_FILE=""
IGNORE_CASE=false
INPUT_FILE=""

# Check if first arg is help
if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    print_usage
    exit 0
fi

# Parse arguments
# We expect the first argument to be the input file (if not starting with -)
if [[ -n "$1" && "$1" != -* ]]; then
    INPUT_FILE="$1"
    shift
fi

# Parse remaining options
while [[ "$#" -gt 0 ]]; do
    case "$1" in
        -i|--in-place)
            IN_PLACE=true
            shift
            ;;
        -o|--output)
            if [ -n "$2" ]; then
                OUTPUT_FILE="$2"
                shift 2
            else
                echo "Error: --output requires a file path argument." >&2
                exit 1
            fi
            ;;
        -f|--ignore-case)
            IGNORE_CASE=true
            shift
            ;;
        -h|--help)
            print_usage
            exit 0
            ;;
        *)
            # If input file wasn't set yet
            if [ -z "$INPUT_FILE" ]; then
                INPUT_FILE="$1"
            else
                echo "Error: Unknown argument '$1'." >&2
                print_usage
                exit 1
            fi
            shift
            ;;
    esac
done

# If input file was not specified, prompt for it
if [ -z "$INPUT_FILE" ]; then
    read -p "Enter the path of the file to sort: " INPUT_FILE
fi

# Validate input file exists
if [ ! -f "$INPUT_FILE" ]; then
    echo "Error: File '$INPUT_FILE' does not exist or is not a regular file." >&2
    exit 1
fi

# Validate input file is not empty
if [ ! -s "$INPUT_FILE" ]; then
    echo "Error: File '$INPUT_FILE' is empty." >&2
    exit 1
fi

# Build sort options
SORT_OPTS=""
if [ "$IGNORE_CASE" = true ]; then
    SORT_OPTS="-f"
fi

# Interactive mode selection if no output destination was specified
if [ "$IN_PLACE" = false ] && [ -z "$OUTPUT_FILE" ]; then
    echo "=========================================================="
    echo "File loaded: $INPUT_FILE"
    echo "Choose an output action for the sorted lines:"
    echo "  1) Print sorted lines to terminal (stdout)"
    echo "  2) Save to a new file"
    echo "  3) Overwrite the original file in-place"
    echo "=========================================================="
    read -p "Select choice (1-3): " CHOICE

    case "$CHOICE" in
        1)
            # Default behavior: stdout
            ;;
        2)
            read -p "Enter output file path: " OUTPUT_FILE
            if [ -z "$OUTPUT_FILE" ]; then
                echo "Error: Output file path cannot be empty." >&2
                exit 1
            fi
            ;;
        3)
            IN_PLACE=true
            ;;
        *)
            echo "Invalid choice. Defaulting to printing to terminal."
            ;;
    esac
fi

# Determine case-insensitivity sorting message
SORT_MODE_MSG="standard sorting"
if [ "$IGNORE_CASE" = true ]; then
    SORT_MODE_MSG="case-insensitive sorting"
fi

# Perform sorting
if [ "$IN_PLACE" = true ]; then
    # Overwrite in-place (safely via temp file)
    TEMP_FILE=$(mktemp)
    sort $SORT_OPTS "$INPUT_FILE" > "$TEMP_FILE"
    mv "$TEMP_FILE" "$INPUT_FILE"
    echo "Success: File '$INPUT_FILE' sorted in-place ($SORT_MODE_MSG)."
elif [ -n "$OUTPUT_FILE" ]; then
    # Save to a new file
    sort $SORT_OPTS "$INPUT_FILE" > "$OUTPUT_FILE"
    echo "Success: Sorted content ($SORT_MODE_MSG) saved to '$OUTPUT_FILE'."
else
    # Output to stdout
    echo "=========================================================="
    echo "                  SORTED CONTENT ($SORT_MODE_MSG)"
    echo "=========================================================="
    sort $SORT_OPTS "$INPUT_FILE"
    echo "=========================================================="
fi
