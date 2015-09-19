#!/bin/bash

# *****************************************
# * FILE: sandbox.sh                         *
# * AUTOR: Hector Jose Flores Colmenarez  *
# * EMAIL: hecto932@gmail.com             *           
# *****************************************

# FUNCTIONALITY
# ==============
# ./sandbox.sh /home/user/Desktop/exefile /home/user/Desktop/input.ext(Optional)

# STATUS CODES
# ============
# 0 - SANDBOX SUCCESS
# 1 - SANDBOX FAILED
# 2 - FILE NOT FOUND

# GLOBALS
# =======

# MISC
SCRIPT=$(readlink -f "$0")

# DIRECTORY PATH
SCRIPTPATH=$(dirname "$SCRIPT")

# GETTINGS ARGUMENTS 
# ==================

# 1.- EXE FILE
EXEFILE=${1}

# 2.- INPUT
INPUT=${2}

# 3.- FILENAME_OUTPUT
OUTPUT="output.txt"

# 4.- DIRNAME
DIRECTORY=$(dirname "$EXEFILE")

# 5.- RESULT_CODE
EXIT_CODE="2"

# IF EXIST FILE PROBLEM
if [[ ! -f "$EXEFILE" ]]; then
	echo "$EXEFILE doesn't exist."
	EXIT_CODE=2
else
	if [[ -z "$INPUT" ]]; then
		# echo "DOES NOT EXPECT INPUT"
		EXIT_CODE=$(LD_PRELOAD=$SCRIPTPATH/sandbox.so $EXEFILE > $DIRECTORY/$OUTPUT 2> /dev/null)
		tail -n +2 $DIRECTORY/$OUTPUT >thetemp && mv thetemp $DIRECTORY/$OUTPUT
	else
		# echo "DOES EXPECT INPUT"
		EXIT_CODE=$(LD_PRELOAD=$SCRIPTPATH/sandbox.so $EXEFILE < $INPUT > $DIRECTORY/$OUTPUT 2> /dev/null)
		tail -n +2 $DIRECTORY/$OUTPUT >thetemp && mv thetemp $DIRECTORY/$OUTPUT
	fi
fi

echo $EXIT_CODE
exit $EXIT_CODE