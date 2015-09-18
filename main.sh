#!/bin/bash

# *****************************************
# * FILE: main.sh                         *
# * AUTOR: Hector Jose Flores Colmenarez  *
# * EMAIL: hecto932@gmail.com             *           
# *****************************************

# FUNCTIONALITY
# ==============
# main.sh MUST BE RUN THIS WAY:
# ./main.sh /FULLPATH/problema.ext --FLAG TIMELIMIT MEMORYLIMIT OUTPUT INPUT

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
SANDBOX="sandbox/sandbox.so"
# SANDBOXPATH
SANDBOXPATH="sandbox"

#EXEFILE
EXEFILE="1"

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

# 8.- FILENAME_OUTPUT
OUTPUT="output.out"

# 9.- OUT EXPECTED
OUT_EXPECTED=${5}

# 10.- INPUT
INPUT=${6}


if [[ ! -f $FULLPATH ]]; then
    echo "File not found!"
    exit 0
fi

if [[ $#==6 || $#==5 ]]; then
	#EJECUTANDO EL SHIELD

	RESULT=$($SCRIPTPATH/shield/shield.sh $FLAG $FULLPATH)
	echo "Running shield...$RESULT"
	if [[ $RESULT == 0 ]]; then

		ulimit -t $TIMELIMIT

		# LANGUAJE C/C++
		if [[ $FLAG=="--c" || $FLAG=="--cpp" ]]; then

			# IF DOES NOT EXPECT INPUT
			if [[ -z "$INPUT" ]]; then
				# echo "DOES NOT EXPECT INPUT"
				# echo "LD_PRELOAD=$PRELOAD_SANDBOX $DIRECTORY/1 > $DIRECTORY/$OUTPUT 2> /dev/null"
				# LD_PRELOAD=$PRELOAD_SANDBOX $DIRECTORY/1 > $DIRECTORY/$OUTPUT 2> /dev/null
				# echo "Salida del sandbox $?"
				# CMD="LD_PRELOAD=./sandbox/sandbox.so .$DIRECTORY/$EXEFILE"
				# timeout $((TIMELIMIT*2)) $CMD >$DIRECTORY/$OUTPUT
				# echo $?
				# remove <<entering SECCOMP mode>> from beginning of output:
				# tail -n +2 $DIRECTORY/$OUTPUT >thetemp && mv thetemp $DIRECTORY/$OUTPUT
				# LD_PRELOAD=/home/hector/Escritorio/core-judge/sandbox/sandbox.so /home/hector/Escritorio/1

				timeout -s9 $((TIMELIMIT*2)) .$SCRIPTPATH/sandbox/sandbox.sh /home/hector/Escritorio/1
			else
				# DOES EXPECT INPUT
				 echo "DOES EXPECT INPUT"
				# echo "LD_PRELOAD=$PRELOAD_SANDBOX $DIRECTORY/1 < $INPUT"
				timeout --signal=9 $TIMELIMIT LD_PRELOAD=sandbox/sandbox.so $DIRECTORY/1 < $INPUT > $DIRECTORY/$OUTPUT  2> /dev/null
				echo "Running shield...$?"
				echo $?
				# remove <<entering SECCOMP mode>> from beginning of output:
				tail -n +2 $DIRECTORY/$OUTPUT >thetemp && mv thetemp $DIRECTORY/$OUTPUT
			fi
		fi
	else
		echo "Compilation error."
		echo "Running sandbox...1"
	fi
fi

#./runcode.sh $EXT $MEMLIMIT $TIMELIMIT $TIMELIMITINT $PROBLEMPATH/in/input$i.txt "java -mx${MEMLIMIT}k $JAVA_POLICY $MAINFILENAME"
