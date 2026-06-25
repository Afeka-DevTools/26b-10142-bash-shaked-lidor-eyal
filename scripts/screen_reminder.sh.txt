#!/bin/bash

# --- Script Name: screen_reminder.sh ---
# Description: Displays a reminder message on the screen after a specified time.

# Helper function to print usage
print_usage() {
    echo "Usage: $0 [minutes] [message]"
    echo "  minutes: Number of minutes to wait before displaying the reminder."
    echo "  message: Reminder message to display."
}

# Check for help flags
if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    print_usage
    exit 0
fi

# Get delay time
if [ -n "$1" ]; then
    MINUTES="$1"
else
    read -p "Enter the number of minutes to wait: " MINUTES
fi

# Validate delay time
if ! [[ "$MINUTES" =~ ^[0-9]+$ ]]; then
    echo "Error: Minutes must be a positive integer." >&2
    exit 1
fi

# Get reminder message
if [ -n "$2" ]; then
    MESSAGE="$2"
else
    read -p "Enter the reminder message: " MESSAGE
fi

echo "=========================================================="
echo "Reminder scheduled."
echo "Message:"
echo "  $MESSAGE"
echo "Will appear in $MINUTES minute(s)."
echo "=========================================================="

# Wait for the specified time
sleep "${MINUTES}m"

# Display reminder
echo
echo "=========================================================="
echo "******************* REMINDER ******************************"
echo "$MESSAGE"
echo "**********************************************************"
echo "=========================================================="