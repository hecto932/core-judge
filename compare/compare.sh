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
# 3 - Error

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
DIRECTORY_NAME="diff_"$FILE1NAME"_"$FILE2NAME.html

# 7.- EXIT_CODE
EXIT_CODE=3

################# FUNCTIONS #################
function rmAssets
{
	rm $DIRECTORY/bootstrap.min.css >/dev/null 2>/dev/null
	rm $DIRECTORY/styles.css >/dev/null 2>/dev/null
}

if [[ ! -f "$FILE1" || ! -f "$FILE2" ]]; then
	echo "$FILE1NAME or $FILE2NAME doesn't exist."
	EXIT_CODE=2
else

	# JUST COMPARE USING DIFF
	if [[ -z "$FLAG" ]]; then
		diff $FILE1 $FILE2 > /dev/null 2>&1
		EXIT_CODE=$?
	else
		rmAssets
		cp $SCRIPTPATH/bootstrap.min.css $DIRECTORY >/dev/null 2>/dev/null
		cp $SCRIPTPATH/styles.css $DIRECTORY >/dev/null 2>/dev/null
		python $SCRIPTPATH/diff2html.py $FILE1 $FILE2 > $DIRECTORY/$FILENAME 2>/dev/null
		diff $FILE1 $FILE2 > /dev/null 2>&1
		EXIT_CODE=$?
	fi
fi

echo $EXIT_CODE
exit $EXIT_CODE