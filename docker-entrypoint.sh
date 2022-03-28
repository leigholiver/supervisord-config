#!/bin/sh

# Make sure that a role is configured
if [ -z "$ROLES" ]; then
    echo "No role configured!"
    exit 1

    # We could also set a default role here...
    # ROLES=web
fi

# Set up the supervisor and start it...
/etc/supervisor/start.sh
