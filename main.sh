#!/bin/bash

# *****************************************
# * FILE: main.sh                         *
# * AUTOR: Hector Jose Flores Colmenarez  *
# * EMAIL: hecto932@gmail.com             *           
# *****************************************

# FUNCTIONALITY
# ==============
# main.sh MUST BE RUN THIS WAY:
# ./main.sh /FULLPATH/problema.ext --FLAG TIMELIMIT MEMORYLIMIT 

# FLAGS:
# =====
# --c to language C
# --cpp to C++ language
# --py2 to Python language
# --py3 to Python language
# --java to Java language

# TIMELIMIT (seconds)
# MEMORYLIMIT (kb)

# GLOBALS
# =======

# MISC
SCRIPT=$(readlink -f "$0")

# DIRECTORY PATH
SCRIPTPATH=$(dirname "$SCRIPT")

# TIMELIMIT (1m:30s = 90s)
DEFAULT_TIMELIMIT=90

# MEMORYLIMIT (5MB = 5120 Kb)
DEFAULT_MEMORYLIMIT=5120

# SANDBOX PRELOAD
PRELOAD_SANDBOX="sandbox/sandbox.so"
# SANDBOXPATH
SANDBOXPATH="sandbox"

# GETTINGS ARGUMENTS 
# ==================

# 1.- FULLPATH PROBLEM
FULLPATH=${1}

# 2.- FLAG
FLAG=${2}

# 3.- TIMELIMIT(Seconds)
TIMELIMIT=${3}

# 4.- MEMORY LIMIT(Kb)
MEMORYLIMIT=${4}

# 5.- FILE
FILE=${FULLPATH##*/}  

# 6.- EXTENSION
EXT="${FILE#*.}"

# 7.- PATH
DIRECTORY=$(dirname "$FULLPATH")

# 8.- INPUT
INPUT=${5}

# 9.- OUTPUT
OUTPUT="output.out"

if [[ ! -f $FULLPATH ]]; then
    echo "File not found!"
    echo "Exit..."
    exit 0
fi

if [[ $#==6 || $#==5 ]]; then
	#EJECUTANDO EL SHIELD

	RESULT=$($SCRIPTPATH/shield/shield.sh $FLAG $FULLPATH)
	echo "Running shield...$RESULT"
	if [[ $RESULT == 0 ]]; then

		# LANGUAJE C/C++
		if [[ $FLAG=="--c" || $FLAG=="--cpp" ]]; then
			if [[ $INPUT!="" ]]; then
				# DOES EXPECT INPUT
				# echo "DOES EXPECT INPUT"
				# echo "LD_PRELOAD=$PRELOAD_SANDBOX $DIRECTORY/1 < $INPUT"
				LD_PRELOAD=$PRELOAD_SANDBOX $DIRECTORY/1 < $INPUT > $DIRECTORY/$OUTPUT  2> /dev/null
				echo "Running shield...$?"
			else
				# DOESN'T EXPECT INPUT
				# echo "DOES NOT EXPECT INPUT"
				# echo "LD_PRELOAD=$PRELOAD_SANDBOX $DIRECTORY/1 > $DIRECTORY/$OUTPUT 2> /dev/null"
				LD_PRELOAD=$PRELOAD_SANDBOX $DIRECTORY/1 > $DIRECTORY/$OUTPUT 2> /dev/null
				echo "Running shield...$?"
			fi
		fi
	else
		echo "Running sandbox...1"
	fi
fi

#./runcode.sh $EXT $MEMLIMIT $TIMELIMIT $TIMELIMITINT $PROBLEMPATH/in/input$i.txt "java -mx${MEMLIMIT}k $JAVA_POLICY $MAINFILENAME"
