#!/bin/bash

# *****************************************
# * FILE:  compare.sh                     *
# * AUTOR: Hector Jose Flores Colmenarez  *
# * EMAIL: hecto932@gmail.com             *           
# *****************************************

# FUNCTIONALITY
# ==============

# THE COMPARE MUST BE RUN THIS WAY:
# ./compare.sh file1 file2 diff2html
# ./compare.sh file1 file2

# FLAGS:
# =====
# --diff2html WITH THIS FLAG WILL HAVE HTML OUTPUT

# STATUS CODE
# ===========
# 0 - Files =
# 1 - Files !=
# 2 - Some File doesn't exist

# GLOBALS
# =======
DIFF_RESULT="-1"
SCRIPT=$(readlink -f "$0")
SCRIPTPATH=$(dirname "$SCRIPT")

# GETTINGS ARGUMENTS 
# ==================

# 1.- FILENAME FILE1
FILE1=${1}
FILE1NAME=${FILE1##*/}
FILE1NAME="${FILE1NAME%.*}"

# 2.- FILENAME FILE2
FILE2=${2}
FILE2NAME=${FILE2##*/}
FILE2NAME="${FILE2NAME%.*}"

# 3.- FLAG
FLAG=${3}

# 4.- FILENAME DIFF2HTML
FILENAME="diffrestult.html"

# 5.- DIRECTORY OF FILE 1
DIRECTORY=$(dirname "$FILE1")

# 6.- DIRECTORY NAME
DIRECTORY_NAME="diff_"$FILE1NAME"_"$FILE2NAME 

if [[ ! -f "$FILE1" || ! -f "$FILE2" ]]; then
	# echo "Some file doesn't exist."
	exit 2
fi

# IF YOU WANT TO COMPARE WITH HTML OUTPUT
if [[ $FLAG == "--diff2html" ]]; then
	# CREATING FOLDERS AND FILE
	if [[ -d "$DIRECTORY" ]]; then
		rm -rf $DIRECTORY/$DIRECTORY_NAME
	fi
	
	mkdir $DIRECTORY/$DIRECTORY_NAME
	cp $SCRIPTPATH/bootstrap.min.css $DIRECTORY/$DIRECTORY_NAME
	cp $SCRIPTPATH/styles.css $DIRECTORY/$DIRECTORY_NAME
	python $SCRIPTPATH/diff2html.py $FILE1 $FILE2 > $DIRECTORY/$DIRECTORY_NAME/$FILENAME
	diff $FILE1 $FILE2 > /dev/null 2>&1
	DIFF_RESULT=$?
	echo $DIFF_RESULT
fi

# IF YOU JUST WANT TO COMPARE
if [[ $FLAG == "" ]]; then
	diff $FILE1 $FILE2 > /dev/null 2>&1
	DIFF_RESULT=$?
	echo $DIFF_RESULT
fi

exit 0