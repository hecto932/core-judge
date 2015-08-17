#!/bin/bash

# *****************************************
# * FILE: main.sh                         *
# * AUTOR: Hector Jose Flores Colmenarez  *
# * EMAIL: hecto932@gmail.com             *           
# *****************************************

# FUNCTIONALITY
# ==============
# THE MAIN MUST BE RUN THIS WAY:
# main.sh /FULLPATH/problema.ext --FLAG TIMELIMIT MEMORYLIMIT 

# FLAGS:
# =====
# --c to language C
# --cpp to C++ language
# --py2 to Python language
# --py3 to Python language
# --java to Java language

# GLOBALS
# =======

# MISC
SCRIPT=$(readlink -f "$0")

# DIRECTORY PATH
SCRIPTPATH=$(dirname "$SCRIPT")

# TIMELIMIT
DEFAULT_TIMELIMIT=90

# MEMORYLIMIT (5MB = 5120 Kb)
DEFAULT_MEMORYLIMIT=5120


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

if [[ $# -lt 5 ]]; then
	#EJECUTANDO EL SHIELD

	RESULT=$($SCRIPTPATH/shield/shield.sh $FLAG $FULLPATH)
	echo "Running shield...$RESULT"
	if [[ $RESULT == 0 ]]; then
		echo "Running sandbox...0"
	else
		echo "Running sandbox...1"
	fi
fi
