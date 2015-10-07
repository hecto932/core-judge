#!/bin/bash

# *****************************************
# * FILE: runcode.sh                      *
# * AUTOR: Hector Jose Flores Colmenarez  *
# * EMAIL: hecto932@gmail.com             *           
# *****************************************

# USAGE: ./runcode.sh --FLAG DIRECTORY MEMORYLIMIT TIMELIMIT COMMAND INPUT(OPTIONAL)

# STATUS CODES
# ============
# timeout exit codes http://www.gnu.org/software/coreutils/manual/html_node/timeout-invocation.html#timeout-invocation

# GETTINGS ARGUMENTS 
# ==================

# 1.- FLAGS
FLAG=${1}

# 2.- PROBLEM DIRECTORY
DIRECTORY=${2}

# 2.- MEMORYLIMIT
MEMORYLIMIT=${3}

# 3.- TIMELIMITINT
TIMELIMIT=${4}

# 4.- COMMAND
CMD=${5}

# 5.- INPUT
INPUT=${6}

# 6.- EXIT_CODE
EXIT_CODE=0

# echo $FLAG
# echo $DIRECTORY
# echo $MEMORYLIMIT
# echo $TIMELIMIT
# echo $CMD
# echo $INPUT

# DETECTING EXISTENCE OF TIMEOUT
TIMEOUT_EXISTS=true
hash timeout 2>/dev/null || TIMEOUT_EXISTS=false

if [ $FLAG == "--py2" ]; then
        mem=$(pid=$(python2 >/dev/null 2>/dev/null & echo $!) && ps -p $pid -o vsz=; kill $pid >/dev/null 2>/dev/null;)
        MEMORYLIMIT=$((MEMORYLIMIT+mem+5000))
elif [ $FLAG == "--py3" ]; then
        mem=$(pid=$(python3 >/dev/null 2>/dev/null & echo $!) && ps -p $pid -o vsz=; kill $pid >/dev/null 2>/dev/null;)
        MEMORYLIMIT=$((MEMORYLIMIT+mem+5000))
fi

# IMPOSING MEMORY LIMIT WITH ulimit
if [ "$FLAG" != "--java" ]; then
	ulimit -v $((MEMORYLIMIT+10000))
	ulimit -m $((MEMORYLIMIT+10000))
	ulimit -s $((MEMORYLIMIT+10000))
fi

# IMPOSING TIME LIMIT WITH ULIMIT
ulimit -t $TIMELIMIT

if $TIMEOUT_EXISTS; then
	# RUN THE COMMAND WITH REAL TIME LIMIT OF TIMELIMIT*2
	if [[ -z "$INPUT" ]]; then
		timeout -s9 $((TIMELIMIT*2)) $CMD > $DIRECTORY/output.txt 2>$DIRECTORY/err
	else
		timeout -s9 $((TIMELIMIT*2)) $CMD <$INPUT > $DIRECTORY/output.txt 2>$DIRECTORY/err
	fi
	EXIT_CODE=$?
else
	# RUN THE COMMAND
	if [[ -z "$INPUT" ]]; then
		$CMD >$DIRECTORY/output.txt 2>$DIRECTORY/err
	else
		$CMD <$INPUT > $DIRECTORY/output.txt 2>$DIRECTORY/err
	fi
	EXIT_CODE=$? 
fi

echo $EXIT_CODE
exit $EXIT_CODE
