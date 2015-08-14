#!/bin/bash

# *****************************************
# * FILE:  compare.sh                     *
# * AUTOR: Hector Jose Flores Colmenarez  *
# * EMAIL: hecto932@gmail.com             *           
# *****************************************

# FUNCTIONALITY
# ==============

# THE COMPARE MUST BE RUN THIS WAY:
# ./compare.sh --diff2html file1 file2
# ./compare.sh file1 file2

# FLAGS:
# =====
# --diff2html WITH THIS FLAG WILL HAVE HTML OUTPUT

# GLOBALS
# =======
DIFF_RESULT="-1"
SCRIPT=$(readlink -f "$0")
SCRIPTPATH=$(dirname "$SCRIPT")

# GETTINGS ARGUMENTS 
# ==================

# 1.- FILENAME FILE1
FILE1=${1}
FILE1NAME="${FILE1%.*}"

# 2.- FILENAME FILE2
FILE2=${2}
FILE2NAME="${FILE2%.*}"

# 3.- FLAG
FLAG=${3}

# 4.- FILENAME DIFF2HTML
FILENAME="diffrestult.html"

# 5.- DIRECTORY OF FILE 1
DIRECTORY=$(dirname "$FILE1")

# 6.- DIRECTORY NAME
DIRECTORY_NAME="diff_$FILE1NAME_$FILE2NAME" 

# IF YOU WANT TO COMPARE WITH HTML OUTPUT
if [[ $FLAG == "--diff2html" ]]; then

	# CREATING FOLDERS AND FILE
	mkdir $DIRECTORY/$DIRECTORY_NAME
fi

exit 0

# IF YOU JUST WANT TO COMPARE
if [[ $FLAG == "" ]]; then
	diff $FILE1 $FILE2 > /dev/null 2>&1
	DIFF_RESULT=$?
	echo $DIFF_RESULT
fi

# if [[ $DIFF_RESULT == 0 ]]; then
# 	echo "The files are the same."
# fi

# if [[ $DIFF_RESULT == 1 ]]; then
# 	echo "The files are diferents."
# fi

# if [[ $DIFF_RESULT == 2 ]]; then
# 	echo "There was something wrong with the diff comand."
# fi

exit 0