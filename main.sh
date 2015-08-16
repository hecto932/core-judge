#!/bin/bash

# *****************************************
# * FILE: main.sh                         *
# * AUTOR: Hector Jose Flores Colmenarez  *
# * EMAIL: hecto932@gmail.com             *           
# *****************************************

# FUNCTIONALITY
# ==============
# THE MAIN MUST BE RUN THIS WAY:
# main.sh /home/username/directories/problema.ext --FLAG TIMELIMIT MEMORYLIMIT

# FLAGS:
# =====
# --c to language C
# --cpp to C++ language
# --py2 to Python language
# --py3 to Python language
# --java to Java language

# GLOBALS
# =======

SCRIPT=$(readlink -f "$0")
SCRIPTPATH=$(dirname "$SCRIPT")

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

if [[ $# -lt 5 ]]; then
	#EJECUTANDO EL SHIELD
	RESULT=$($SCRIPTPATH/shield/shield.sh $FLAG $FULLPATH)
	echo "Shield: $RESULT"
	if [[ $RESULT == 0 ]]; then
		echo "Running sandboxing..."
	else
		echo "Sandbox: 1"
	fi
fi
