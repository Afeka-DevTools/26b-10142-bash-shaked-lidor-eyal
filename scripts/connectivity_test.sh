#!/bin/bash

# =================================================================
# Script to check internet connectivity and print a status log
# =================================================================

# 1. Check if 'ping' command is available (Requirement 2a)
if ! command -v ping &> /dev/null; then
    echo "Ping utility is not installed. Attempting to install..."
    
    # Attempt installation for Debian/Ubuntu environments (vLab)
    sudo apt-get update && sudo apt-get install -y iputils-ping
    
    # Verify installation success
    if [ $? -ne 0 ]; then
        echo "Error: Installation of iputils-ping failed. Please install it manually."
        exit 1
    fi
fi

# 2. Set the target host for the connectivity test (Google Public DNS)
TARGET_HOST="8.8.8.8"
TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")

echo "[$TIMESTAMP] Initializing network connectivity check..."

# 3. Execute ping command
# Sends 3 packets (-c 3) and waits up to 2 seconds for a response (-W 2)
PING_OUTPUT=$(ping -c 3 -W 2 $TARGET_HOST 2>&1)
PING_STATUS=$?

# 4. Analyze results and print log output to the screen
echo "===================================================="
echo "                  CONNECTION LOG                    "
echo "===================================================="
echo "Timestamp: $TIMESTAMP"
echo "Target IP: $TARGET_HOST"

if [ $PING_STATUS -eq 0 ]; then
    # Extract average round-trip time (RTT) from the ping output
    AVG_LATENCY=$(echo "$PING_OUTPUT" | tail -1 | awk -F '/' '{print $5}')
    
    echo "Status:    ONLINE"
    echo "Details:   Internet access is available."
    echo "Latency:   Avg RTT = ${AVG_LATENCY} ms"
else
    echo "Status:    OFFLINE"
    echo "Details:   Failed to reach the internet. Host is unreachable."
fi
echo "===================================================="
