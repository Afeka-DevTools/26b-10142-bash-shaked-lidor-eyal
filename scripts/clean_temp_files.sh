#!/bin/bash

# --- Script Name: clean_temp_files.sh ---
# Description: Removes common temporary files and directories from a project.

# Helper function to print usage
print_usage() {
    echo "Usage: $0 [project_directory]"
    echo "  project_directory: The project directory to clean."
}

# Check for help flags
if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    print_usage
    exit 0
fi

# Get project directory
if [ -n "$1" ]; then
    PROJECT_DIR="$1"
else
    read -p "Enter the project directory: " PROJECT_DIR
fi

# Validate directory
if [ ! -d "$PROJECT_DIR" ]; then
    echo "Error: Directory '$PROJECT_DIR' does not exist." >&2
    exit 1
fi

# Resolve absolute path
ABS_DIR=$(cd "$PROJECT_DIR" && pwd)

echo "=========================================================="
echo "Cleaning temporary files from:"
echo "  $ABS_DIR"
echo "=========================================================="

# Counter
COUNT=0

# Remove common temporary files
find "$ABS_DIR" -type f \( \
    -name "*.class" -o \
    -name "*.pyc" -o \
    -name "*.tmp" -o \
    -name "*.log" \
\) -print0 | while IFS= read -r -d '' file; do
    rm -f "$file"
    echo "Deleted file:"
    echo "  $file"
done

# Remove common temporary directories
find "$ABS_DIR" -type d \( \
    -name "node_modules" -o \
    -name "__pycache__" \
\) -print0 | while IFS= read -r -d '' dir; do
    rm -rf "$dir"
    echo "Deleted directory:"
    echo "  $dir"
done

echo "=========================================================="
echo "Cleanup completed."
echo "=========================================================="