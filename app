#!/bin/bash

# This script is inspired by st-exec.sh from http://stfx.eu/pharo-server/
# originally written by Sven Van Caekenberghe

function usage() {
    cat <<END
Usage: $0 <command>
    manage a Smalltalk server.
    You *must* provide install.st and start.st files right next to the image
    file.
    start and stop command takes an optional pid file. By the default, the
    pid file will be '${script_home}/pharo.pid'.

Commands:
    install  run install.sh on the image and then quit.
    start    run the image with start.st in background
    stop     stop the server.
    restart  restart the server
    pid      print the process id
END
    exit 1
}

# Setup vars

script_home=$(dirname $0)
script_home=$(cd $script_home && pwd)

command=$1
image="$script_home/pharo.image"

echo $pid_file

# MacOS X
# vm=/Applications/Pharo.app/Contents/MacOS/Pharo

# Ubuntu
vm=pharo-vm-nox

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
    echo Stopping $pid_file
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
