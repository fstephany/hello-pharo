#!/bin/bash
# This script is inspired by st-exec.sh from http://stfx.eu/pharo-server/
# originally written by Sven Van Caekenberghe

function usage() {
    cat <<END
Usage: $0 <command> <image>
    manage a Smalltalk server
Naming
    script.pid  will be used to hold the process id
    image.image is the Smalltalk image that will be started
Commands:
    install  run the install script on the image.
    start    start the server in background
    stop     stop the server
    restart  restart the server
    run      run the server in foreground
    pid      print the process id
END
    exit 1
}

# Setup vars

script_home=$(dirname $0)
script_home=$(cd $script_home && pwd)

command=$2
image=$3

echo Working directory $script_home

# We need the two arguments.
if [ "$#" -ne 2 ]; then
    usage
fi

# Usage:

# app install
# -> Run the install.st script on the image then save and quit

# app start
# -> Run the start.st script on the image. Store the process PID

# app stop
# -> Check the PID stored when started and kill the process associated with it.

# app restart
# -> stop and start the app.
