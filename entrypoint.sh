#!/bin/bash

# Start virtual X server in the background
# - DISPLAY default is :99, set in dockerfile
# - Users can override with `-e DISPLAY=` in `docker run` command to avoid
#   running Xvfb and attach their screen
if [[ -x "$(command -v Xvfb)" && "$DISPLAY" == ":99" ]]; then
        echo "Starting Xvfb"
        Xvfb :99 -screen 0 1600x1200x24+32 &
fi

# Starting PX4 SITL
# /bin/sh -c cd /opt/px4/firmware/build/px4_sitl_default/tmp && /opt/px4/firmware/Tools/sitl_run.sh /opt/px4/firmware/build/px4_sitl_default/bin/px4 none none iris /opt/px4/firmware /opt/px4/

# Use the LOCAL_USER_ID if passed in at runtime
if [ -n "${LOCAL_USER_ID}" ]; then
        echo "Starting with UID : $LOCAL_USER_ID"
        # modify existing user's id
        usermod -u $LOCAL_USER_ID user
        # run as user
        exec gosu user "$@"
else
        exec "$@"
fi

