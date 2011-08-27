#!/bin/sh

export LC_ALL=C

function filter {
    echo "Looking for '$1' in '$LOG' ..."
    echo ""
    
    $CAT "$LOG" | $GREP -i "$1" | $GREP "^$STR"
}

CAT=`which cat`
GREP=`which grep`
LOG="/var/log/system.log"

# Set the date string to filter the logs for
if [ $# -eq 1 ];
then
	STR=$1
	echo "Looking for string '$STR'"
else
	#STR=`date +%b`
	#echo "Looking for month '$STR'"
	echo "Usage:   $0 <DAY>"
	echo "Example: $0 'Aug  9'"
	echo ""
	exit 1
fi

# Basic checks - if they fail, there's no sense continuing
if [ ! -e $CAT ];
then
    echo "ERROR: File '$CAT' does not exist/is not executable"
    exit 1
fi

if [ ! -e $GREP ];
then
    echo "ERROR: File '$GREP' does not exist/is not executable"
    exit 1
fi

if [ ! -r $LOG ];
then
    echo "ERROR: Logfile '$LOG' is not readable"
    exit 1
fi

#exit 0

echo "-------------------------------------------------------------------------"
echo "Booting"
echo "-------------------------------------------------------------------------"
filter "kernel.0."
echo ""

echo "-------------------------------------------------------------------------"
echo "Logoff (Login Window)"
echo "-------------------------------------------------------------------------"
filter "Login Window Application Started"
echo ""

echo "-------------------------------------------------------------------------"
echo "Going to Sleep"
echo "-------------------------------------------------------------------------"
filter "SleepWakeCallback WILL sleep"
echo ""

echo "-------------------------------------------------------------------------"
echo "Wake from Sleep"
echo "-------------------------------------------------------------------------"
filter "askForPasswordBuiltIn"
filter "Returned from Security Agent"
echo ""

echo "-------------------------------------------------------------------------"
echo "Shutdown"
echo "-------------------------------------------------------------------------"
filter "SHUTDOWN_TIME"
echo ""

exit 0