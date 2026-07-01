#!/bin/bash

# --- Script Name: current_user_info.sh ---
# Description: Displays information about the currently logged-in user,
# including username, home directory, groups, and configured shell.

# Helper function to print usage
print_usage() {
    echo "Usage: $0"
    echo "  Displays information about the current user."
}

# Check for help flags
if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    print_usage
    exit 0
fi

echo "=========================================================="
echo "Current User Information"
echo "=========================================================="

# Get current username
CURRENT_USER=$(whoami)

# Get user's home directory
HOME_DIR=$(eval echo "~$CURRENT_USER")

# Get user's groups
USER_GROUPS=$(groups "$CURRENT_USER")

# Get user's configured shell
USER_SHELL=$(getent passwd "$CURRENT_USER" | cut -d: -f7)

echo "Username:"
echo "  $CURRENT_USER"
echo

echo "Home Directory:"
echo "  $HOME_DIR"
echo

echo "Groups:"
echo "  $USER_GROUPS"
echo

echo "Configured Shell:"
echo "  $USER_SHELL"

echo "=========================================================="