#!/bin/bash

# --- Script Name: display_env_vars.sh ---
# Description: Displays important environment variables with options to search or show all.

# Helper function to print usage
print_usage() {
    echo "Usage: $0 [option]"
    echo "Options:"
    echo "  -k, --key       Show only curated key environment variables (default)."
    echo "  -a, --all       Show all active environment variables."
    echo "  -s, --search    Search for a specific environment variable by name."
    echo "  -h, --help      Display this help menu."
}

# Function to display key environment variables with descriptions
show_key_vars() {
    echo "=========================================================="
    echo "         KEY ENVIRONMENT VARIABLES & DESCRIPTIONS"
    echo "=========================================================="
    printf "%-12s | %-22s | %s\n" "Variable" "Value" "Description"
    printf "%-12s-|-%-22s-|-%s\n" "------------" "----------------------" "------------------------"

    # Curated list of variables
    # We use a helper helper function to print each cleanly
    print_var_row() {
        local name="$1"
        local desc="$2"
        # Get variable value dynamically
        local val="${!name}"
        # Truncate value if it's too long (e.g., PATH)
        if [ ${#val} -gt 30 ]; then
            val="${val:0:27}..."
        fi
        if [ -z "$val" ]; then
            val="(not set)"
        fi
        printf "%-12s | %-22s | %s\n" "$name" "$val" "$desc"
    }

    # Handle USER vs USERNAME (Windows Git Bash uses USERNAME)
    local user_var="USER"
    if [ -z "$USER" ] && [ -n "$USERNAME" ]; then
        user_var="USERNAME"
    fi

    print_var_row "$user_var" "Current logged-in user name"
    print_var_row "HOME" "Home directory of the current user"
    print_var_row "PATH" "Directories searched for executables"
    print_var_row "SHELL" "Path to the active login shell"
    print_var_row "PWD" "Current working directory"
    print_var_row "LANG" "System locale / language setting"
    print_var_row "TERM" "Terminal emulator type"
    print_var_row "OSTYPE" "Operating system type identifier"
    print_var_row "HOSTNAME" "Network name of the system"
    
    echo "=========================================================="
    echo "Tip: Run '$0 -a' to see all variables, or '$0 -s' to search."
    echo "=========================================================="
}

# Function to show all variables
show_all_vars() {
    echo "=========================================================="
    echo "            ALL ENVIRONMENT VARIABLES"
    echo "=========================================================="
    env | sort
    echo "=========================================================="
}

# Function to search variables
search_vars() {
    local query=""
    if [ -n "$1" ]; then
        query="$1"
    else
        read -p "Enter search term (case-insensitive): " query
    fi

    if [ -z "$query" ]; then
        echo "Error: Search term cannot be empty." >&2
        exit 1
    fi

    echo "=========================================================="
    echo "Searching environment variables matching: '$query'"
    echo "=========================================================="
    
    # Search names and values
    local results=$(env | grep -i "$query" | sort)
    if [ -z "$results" ]; then
        echo "No matching environment variables found."
    else
        echo "$results"
    fi
    echo "=========================================================="
}

# Main routing logic
OPTION="$1"

case "$OPTION" in
    -k|--key|"")
        show_key_vars
        ;;
    -a|--all)
        show_all_vars
        ;;
    -s|--search)
        search_vars "$2"
        ;;
    -h|--help)
        print_usage
        ;;
    *)
        echo "Invalid option: $OPTION" >&2
        print_usage
        exit 1
        ;;
esac
