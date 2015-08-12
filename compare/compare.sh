#!/bin/bash

# *****************************************
# * FILE:  compare.sh                     *
# * AUTOR: Hector Jose Flores Colmenarez  *
# * EMAIL: hecto932@gmail.com             *           
# *****************************************

FILE1=${1}

FILE2=${2}

diff $FILE1 $FILE2 > /dev/null 2>&1

DIFF_RESULT=$?

if [[ $DIFF_RESULT == 0 ]]; then
	echo "The files are the same."
fi

if [[ $DIFF_RESULT == 1 ]]; then
	echo "The files are diferents."
fi

if [[ $DIFF_RESULT == 2 ]]; then
	echo "There was something wrong with the diff comand."
fi

echo "Result: $DIFF_RESULT"

exit 0