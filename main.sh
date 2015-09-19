#!/bin/bash

# *****************************************
# * FILE: main.sh                         *
# * AUTOR: Hector Jose Flores Colmenarez  *
# * EMAIL: hecto932@gmail.com             *           
# *****************************************

# USAGE : ./main.sh /FULLPATH/PROBLEM --FLAG MEMORYLIMIT TIMELIMIT ON_SHIELD ON_SANDBOX ON_COMPARE ON_DIFF2HMTL JAVA_POLICY DISPLAY_JAVA_EXCEPTION_ON
# =======

# FLAGS:
# =====
# --c to language C
# --cpp to C++ language
# --py2 to Python language
# --py3 to Python language
# --java to Java language

# MEMORYLIMIT (kb)
# TIMELIMIT (seconds)
# ON_SHIELD (0 or 1)
# ON_SANDBOX (0 or 1)
# ON_COMPARE (0 or 1)
# JAVA_POLICY (0 or 1)
# DISPLAY_JAVA_EXPTION_ON (0 or 1)

# STATUS CODES
# ============
# 0 - OK
# 1 - Error
# 2 - File not found.
# 3 - Missing Arguments

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

# GETTINGS ARGUMENTS 
# ==================

# 1.- FULLPATH PROBLEM
PROBLEMPATH=${1}

# 2.- FLAG
FLAG=${2}

# 3.- MEMORYLIMIT(Kb)
MEMORYLIMIT=${3}

# 4.- TIMELIMIT(Seconds)
TIMELIMIT=${4}

# 5.- ENABLE/DISABLE SHIELD
ON_SHIELD=${5}

# 6.- ENABLE/DISABLE SANDBOX
ON_SANDBOX=${6}

# 7.- ENABLE/DISABLE DIFF
ON_COMPARE=${7}

# 8.- ENABLE/DISABLE DIFF2HTML
ON_DIFF2HMTL=${8}

# 9.- JAVA_POLICY
JAVA_POLICY=${9}

# 10.- DISPLAY_JAVA_EXCEPTION_ON
DISPLAY_JAVA_EXCEPTION_ON=${10}

# COMPILER OPTIONS FOR C/C++
# ==========================
C_COMPILER="gcc"
C_OPTIONS="-fno-asm -Dasm=error -lm -O2"
C_WARNING_OPTION="-w"
C_EXEFILE="1"
C_SHIELD="shield_c.c"
C_FLAG="--c"
C_EXT="c"
C_BLACKLIST="blacklist_c.h"

CPP_COMPILER="g++"
CPP_EXEFILE="1"
CPP_SHIELD="shield_cpp.cpp"
CPP_FLAG="--cpp"
CPP_EXT="cpp"
CPP_BLACKLIST="blacklist_cpp.h"
# -w: Inhibit all warning messages
# -Werror: Make all warnings into errors
# -Wall ...
# Read more: http://gcc.gnu.org/onlinedocs/gcc/Warning-Options.html
# Read more: http://www.eis.uva.es/~fergay/III/enlaces/gcc.html

# MISC
# ====

# FILE
FILE=${PROBLEMPATH##*/}  

# EXTENSION
EXT="${FILE#*.}"

# PATH
DIRECTORY=$(dirname "$PROBLEMPATH")

# FILENAME_OUTPUT
OUTPUT="output.txt"

# CLASS NAME(ONLY FOR JAVA)
CLASSNAME="${FILE%.*}"

# EXIT_CODE



if [[ ! -f $PROBLEMPATH ]]; then
    echo "File not found!"
    exit 2
else
	if [[ $# -eq 10 ]]; then

		# C
		if [[ $FLAG=="--c" ]]; then

			# VERIFY SHIELD
			if [[ $ON_SHIELD=="1" ]]; then
				EXIT_CODE=$($SCRIPTPATH/shield/shield.sh $FLAG $PROBLEMPATH)
			else
				$C_COMPILER $FULLPATH $C_OPTIONS $C_WARNING_OPTION -o $DIRECTORY/$CLASSNAME >/dev/null 2>$DIRECTORY/cerr
				EXIT_CODE=$?
			fi

			echo "Shield -> $EXIT_CODE"
			
			if [[ $EXIT_CODE=="0" ]]; then
				#VERIFY SANDBOX
				echo "ON_SANDBOX = $ON_SANDBOX"
				if [[ $ON_SANDBOX==1 ]]; then
					echo "Aqui1"
					if [[ -z "$INPUT" ]]; then
						echo "Aqui2"
						$SCRIPTPATH/runcode.sh $FLAG $DIRECTORY $MEMORYLIMIT $TIMELIMIT "LD_PRELOAD=$SCRIPTPATH/sandbox/sandbox.so $DIRECTORY/$CLASSNAME"
					else
						echo "Aqui3"
						$SCRIPTPATH/runcode.sh $FLAG $DIRECTORY $MEMORYLIMIT $TIMELIMIT "LD_PRELOAD=$SCRIPTPATH/sandbox/sandbox.so $DIRECTORY/$CLASSNAME" $DIRECTORY/input.txt
					fi
				else
					if [[ -z "$INPUT" ]]; then
						$SCRIPTPATH/runcode.sh $FLAG $DIRECTORY $MEMORYLIMIT $TIMELIMIT "$DIRECTORY/$CLASSNAME"
					else
						$SCRIPTPATH/runcode.sh $FLAG $DIRECTORY $MEMORYLIMIT $TIMELIMIT "$DIRECTORY/$CLASSNAME" $DIRECTORY/input.txt
					fi
				fi
			else
				EXIT_CODE=1
			fi
			echo "Sandbox -> $EXIT_CODE"

			if [[ $ON_COMPARE=="1" ]]; then
				if [[ $ON_DIFF2HMTL=="1" ]]; then
					$SCRIPTPATH/compare/compare.sh $DIRECTORY/output.txt $DIRECTORY/expected.txt --diff2html
				else
					$SCRIPTPATH/compare/compare.sh $DIRECTORY/output.txt $DIRECTORY/expected.txt
				fi
				EXIT_CODE=$?
			else
				echo "Compare -> disable."
				echo $EXIT_CODE
			fi
		fi


	else
		echo "Missing arguments."
		exit 3
	fi
fi

echo $EXIT_CODE
exit $EXIT_CODE