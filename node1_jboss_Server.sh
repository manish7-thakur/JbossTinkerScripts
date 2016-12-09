#!/bin/sh

# description: Script to Monitor, Start or Stop JBoss server instance

# =============================================================================
# JBoss Server UNIX Startup Script
#
# This file is used to execute the JBoss Server instance on a UNIX platform.
# Run this script without any command line options for the syntax help.
#
# This script is customizable by setting the following environment variables:
#
#    _SERVER_INST - Define the server instance to run
#                       
#    JBOSS_SERVER_HOME - Defines where the server's home install directory is.                 
#
#
#
# This script calls run.sh when starting the underlying JBossAS server.
# =============================================================================

echo "-------------------------------------------------------------" >> startstoplog.log
# =============================================================================
echo "Starting $1 script on $HOSTNAME at $(date +"%x %r %Z")"
echo "Starting $1 script on $HOSTNAME at $(date +"%x %r %Z")" >> startstoplog.log
echo "-------------------------------------------------------------"

# ----------------------------------------------------------------------
# Environment variables you can set to customize the launch of the JBoss Server.
# ----------------------------------------------------------------------

_SERVER_INST="airportui_node1"
JBOSS_SERVER_HOME="/apps/jboss/jboss-eap-6.4.0/jboss-eap-6.4"
export JBOSS_BASE_DIR="$JBOSS_SERVER_HOME/$_SERVER_INST"
export RUN_CONF="$JBOSS_BASE_DIR/standalone.conf"

check_status ()
{
	_SERVER_PID=`ps -ef | grep $_SERVER_INST | grep org.jboss.as | awk '{print $2}'`
}

check_status

_JBOSS_RUN_SCRIPT="${JBOSS_SERVER_HOME}/bin/standalone.sh"

if [ ! -f "$_JBOSS_RUN_SCRIPT" ]; then
   echo "ERROR! Cannot find the JBossAS run script"
   echo "Not found: $_JBOSS_RUN_SCRIPT"
   exit 1
fi

case "$1" in
'start')
       if [ -n "$_SERVER_PID" ]; then
          echo "JBOSS Server instance for - $_SERVER_INST - (pid $_SERVER_PID) is already running"
          echo "JBOSS Server instance for - $_SERVER_INST - (pid $_SERVER_PID) is already running" >> startstoplog.log
          exit 0
       fi

	rm $JBOSS_BASE_DIR/deployments/*.undeployed
	rm $JBOSS_BASE_DIR/deployments/*.failed

	echo "Going to start JBOSS Server for $_SERVER_INST..."
	echo "Going to start JBOSS Server for $_SERVER_INST..." >> startstoplog.log

	"$_JBOSS_RUN_SCRIPT" > /dev/null 2>&1 &
	 
	sleep 15
       
       check_status

       if [ -n "$_SERVER_PID" ]; then
	    echo "JBOSS Server instance for - $_SERVER_INST - (pid $_SERVER_PID) starting"	
	    echo "JBOSS Server instance for - $_SERVER_INST - (pid $_SERVER_PID) starting" >> startstoplog.log	
           exit 0
       else
          echo "Failed to start - make sure - $_SERVER_INST - JBoss server is fully configured properly"
          echo "Failed to start - make sure - $_SERVER_INST - JBoss server is fully configured properly" >> startstoplog.log
          exit 1
       fi
       ;;
'stop')
       if [ -z "$_SERVER_PID" ]; then
          echo "JBOSS Server instance for - $_SERVER_INST - is not running"
          echo "JBOSS Server instance for - $_SERVER_INST - is not running" >> startstoplog.log
          exit 0
       fi
	
       echo "Trying to stop JBOSS Server for $_SERVER_INST..."
	echo "$_SERVER_INST - JBOSS Server process (pid=${_SERVER_PID}) is being killed..."
	echo "$_SERVER_INST - JBOSS Server process (pid=${_SERVER_PID}) is being killed..." >> startstoplog.log
	
	kill -9 $_SERVER_PID

	sleep 5
       
       check_status

       if [ -z "$_SERVER_PID" ]; then
	    echo "JBOSS Server instance for - $_SERVER_INST - killed"	
	    echo "JBOSS Server instance for - $_SERVER_INST - killed" >> startstoplog.log	
           exit 0
       else
          echo "Unable to kill JBOSS Server instance for - $_SERVER_INST"
          echo "Unable to kill JBOSS Server instance for - $_SERVER_INST" >> startstoplog.log
          exit 1
       fi
       ;;

'status')
        if [ -n "$_SERVER_PID" ]; then
	    echo "JBOSS Server instance for - $_SERVER_INST - (pid $_SERVER_PID) is running"	
	    echo "JBOSS Server instance for - $_SERVER_INST - (pid $_SERVER_PID) is running" >> startstoplog.log	
           exit 0
       else
          echo "JBOSS Server instance for - $_SERVER_INST - is not running"
          echo "JBOSS Server instance for - $_SERVER_INST - is not running" >> startstoplog.log
          exit 1
       fi
       ;;

'restart')

	./"$(basename "$0")" stop
	./"$(basename "$0")" status
	./"$(basename "$0")" start
	echo "-------------------------------------------------------------" >> startstoplog.log
       ;;

'clear')

	./"$(basename "$0")" stop
	./"$(basename "$0")" status
	rm -r $JBOSS_BASE_DIR/tmp/
	rm -r $JBOSS_BASE_DIR/data/
	rm -r $JBOSS_BASE_DIR/work/
	rm -r $JBOSS_BASE_DIR/log/
	./"$(basename "$0")" start
	echo "-------------------------------------------------------------" >> startstoplog.log
       ;;

'clearlogs')

	./"$(basename "$0")" stop
	./"$(basename "$0")" status
	rm -r $JBOSS_BASE_DIR/log/
	./"$(basename "$0")" start
	echo "-------------------------------------------------------------" >> startstoplog.log
       ;;

'deploy')

	./"$(basename "$0")" stop
	./"$(basename "$0")" status
	rm -r $JBOSS_BASE_DIR/tmp/
	rm -r $JBOSS_BASE_DIR/work/
	./"$(basename "$0")" start
	echo "-------------------------------------------------------------" >> startstoplog.log
       ;;


*)
        echo "Usage: $0 { start | stop | status | restart | clear | clearlogs | deploy }"
        exit 1
        ;;
esac