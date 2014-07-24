#!/bin/bash

# This script is inspired by st-exec.sh from http://stfx.eu/pharo-server/
# originally written by Sven Van Caekenberghe

function usage() {
    cat <<END
Usage: $0 <command> <image>
    manage a Smalltalk server.
    You *must* provide install.st and start.st files right next to the image
    file.
Naming
    script.pid  will be used to hold the process id
    image.image is the Smalltalk image that will be started
Commands:
    install  run install.sh on the image and then quit.
    start    run the image with start.st in background
    stop     stop the server
    restart  restart the server
    pid      print the process id
END
    exit 1
}

# Setup vars

script_home=$(dirname $0)
script_home=$(cd $script_home && pwd)

command=$1
image=$2
pid_file="$script_home/pharo.pid"
vm=/Applications/Pharo.app/Contents/MacOS/Pharo

# echo Working directory $script_home

function install() {
    echo $vm $image install.st
    $vm $image $st_file
}

function start() {
    echo Starting $script in background
    if [ -e "$pid_file" ]; then
    rm -f $pid_file
    fi
    echo $pid_file
    echo $vm $image start.st
    $vm $image start.st 2>&1 >/dev/null &
    echo $! >$pid_file
}

function stop() {
    echo Stopping $script
    if [ -e "$pid_file" ]; then
        pid=`cat $pid_file`
        echo Killing $pid
    kill $pid
    rm -f $pid_file
    else
        echo Pid file not found: $pid_file
    echo Searching in process list for $script
    pids=`ps ax | grep $script | grep -v grep | grep -v $0 | awk '{print $1}'`
    if [ -z "$pids" ]; then
            echo No pids found!
    else
            for p in $pids; do
        if [ $p != "$pid" ]; then
                    echo Killing $p
                    kill $p
        fi
            done
    fi
    fi
}

function restart() {
    echo Restarting $script
    stop
    start
}

function printpid() {
    if [ -e $pid_file ]; then
    cat $pid_file
    else
        echo Pid file not found: $pid_file
    echo Searching in process list for $script
    pids=`ps ax | grep $script | grep -v grep | grep -v $0 | awk '{print $1}'`
    if [ -z "$pids" ]; then
            echo No pids found!
    else
        echo $pids
    fi
    fi
}

case $command in
    install)
        install
        ;;
    start)
        start
        ;;
    stop)
        stop
        ;;
    restart)
        restart
        ;;
    pid)
        printpid
        ;;
    *)
        usage
        ;;
esac
