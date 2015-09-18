#!/bin/bash

# This file runs a command with given limits
# usage: ./runcode.sh extension memorylimit timelimit timelimit_int input_file command

# usage: ./runcode.sh --FLAG /FULLPATH/EXEFILE MEMLIMIT TIMELIMIT TIMELIMITINT IN 

# PARAMS
# ======

# 1.- FLAGS
FLAG=$1
shift

# 2.- FILE EXE
EXT=$1
shift

# 3.- MEMORYLIMIT
MEMLIMIT=$1
shift

# 4.- TIMELIMIT
TIMELIMIT=$1
shift

# 5.- TIMELIMITINT
TIMELIMITINT=$1
shift

# 6.- INPUT FILE
IN=$1
shift

# 7.- COMMAND
CMD=$@

# DETECTING EXISTENCE OF TIMEOUT
TIMEOUT_EXISTS=true
hash timeout 2>/dev/null || TIMEOUT_EXISTS=false

if [ $EXT == "--py2" ]; then
        mem=$(pid=$(python2 >/dev/null 2>/dev/null & echo $!) && ps -p $pid -o vsz=; kill $pid >/dev/null 2>/dev/null;)
        MEMLIMIT=$((MEMLIMIT+mem+5000))
elif [ $EXT == "--py3" ]; then
        mem=$(pid=$(python3 >/dev/null 2>/dev/null & echo $!) && ps -p $pid -o vsz=; kill $pid >/dev/null 2>/dev/null;)
        MEMLIMIT=$((MEMLIMIT+mem+5000))
fi

# IMPOSING MEMORY LIMIT WITH ulimit
if [ "$EXT" != "--java" ]; then
	ulimit -v $((MEMLIMIT+10000))
	ulimit -m $((MEMLIMIT+10000))
	ulimit -s $((MEMLIMIT+10000))
fi

# IMPOSING TIME LIMIT WITH ULIMIT
ulimit -t $TIMELIMITINT

if $TIMEOUT_EXISTS; then
	# RUN THE COMMAND WITH REAL TIME LIMIT OF TIMELIMITINT*2
	timeout -s9 $((TIMELIMITINT*2)) $CMD <$IN >out
else
	# RUN THE COMMAND
	$CMD <$IN >out 2>err
fi

EXIT_CODE=$?

echo $EXIT_CODE

exit $EXIT_CODE
