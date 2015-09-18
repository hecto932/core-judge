#!/bin/bash

# *****************************************
# * FILE: main.sh                         *
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
OUTPUT="output.out"

# 4.- DIRNAME
DIRECTORY=$(dirname "$EXEFILE")

# 5.- RESULT_CODE
RESULT_CODE="2"


if [[ -z "$INPUT" ]]; then
	# echo "DOES NOT EXPECT INPUT"
	RESULT_CODE=$(LD_PRELOAD=$SCRIPTPATH/sandbox.so $EXEFILE > $DIRECTORY/$OUTPUT 2> /dev/null)
	echo $RESULT_CODE
	tail -n +2 $DIRECTORY/$OUTPUT >thetemp && mv thetemp $DIRECTORY/$OUTPUT
else
	# echo "DOES EXPECT INPUT"
	RESULT_CODE=$(LD_PRELOAD=$SCRIPTPATH/sandbox.so $EXEFILE < $INPUT > $DIRECTORY/$OUTPUT 2> /dev/null)
	echo $RESULT_CODE
	tail -n +2 $DIRECTORY/$OUTPUT >thetemp && mv thetemp $DIRECTORY/$OUTPUT
fi

