#!/bin/sh
# Script to combine config files based on the specified roles and start supervisor
# Usage: /etc/supervisor/start.sh [/etc/supervisor/supervisor.conf]

# The base configuration file to use
CONFIG_FILE=${1:-/etc/supervisor/supervisor.conf}

# Function to add a process and common options to the config file
add_config() {
    cat $1 >> $CONFIG_FILE
    if [ -f /etc/supervisor/common.conf ]; then
        cat /etc/supervisor/common.conf >> $CONFIG_FILE
    fi
}

# Iterate over the comma seperated list of roles, and add config as appropriate
for ROLE in $(echo "$ROLES" | tr "," "\n"); do
    if [ -d /etc/supervisor/roles/$ROLE ]; then
        for ROLE_PROCESS in $(ls /etc/supervisor/roles/$ROLE/*.conf); do
            add_config $ROLE_PROCESS
        done
    elif [ -f /etc/supervisor/roles/$ROLE.conf ]; then
        add_config /etc/supervisor/roles/$ROLE.conf
    fi
done

# Start supervisor
supervisord -c $CONFIG_FILE
