#!/bin/bash

# *****************************************
# * FILE: shield.sh                       *
# * AUTOR: Hector Jose Flores Colmenarez  *
# * EMAIL: hecto932@gmail.com             *           
# *****************************************

# FUNCTIONALITY
# ==============

# THE SHIELD MUST BE RUN THIS WAY:
# ./shield.sh --c /absolutepath/example.c
# ./shield.sh --cpp /absolutepath/example.cpp
# ./shield.sh --py2 /absolutepath/example.py
# ./shield.sh --py3 /absolutepath/example.py
# ./shield.sh --java /absolutepath/example.java

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
SHIELD_PATH=$SCRIPTPATH

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

# COMPILER OPTIONS FOR PYTHON2 && PYTHON3
# =======================================
PY2_COMPILER="python"
PY3_COMPILER="python3"
PY2_FLAG="--py2"
PY3_FLAG="--py3"
PY_EXT="py"
PY2_SHIELD="shield_python2.py"
PY3_SHIELD="shield_python3.py"
PY_OPTIONS="-O -m py_compile"

# COMPILER OPTIONS FOR JAVA
# =========================
JAVA_FLAG="--java"
JAVA_COMPILER="javac"
JAVA_RUNNER="java"
JAVA_EXT="java"
JAVA_POLICY="-Djava.security.manager -Djava.security.policy=java.policy"
JAVA_FILEPOLICY="java.policy"

# GETTINGS ARGUMENTS 
# ==================

# 1.- FLAG
FLAG=${1}

# 2.- PROBLEM DIRECTORY(FULL PATH)
PROBLEMPATH=${2}

# 3.- FILE  
FILE=${PROBLEMPATH##*/}  

# 4.- EXTENSION FILE
EXT="${FILE#*.}"

# 5.- CLASS NAME(ONLY FOR JAVA)
CLASSNAME="${FILE%.*}"

# 6.- DIRECTORY OF PROBLEM
DIRECTORY=$(dirname "$PROBLEMPATH")

# 7.- FILENAME(WITHOUT EXTENSION)
FILENAME="${FILE%.*}"

# 8.- ROUTE OF THE SOLUTION
ROUTEOFSOLUTION="$DIRECTORY/shield_$FILENAME$(date +"%d%m%Y%H%M%S")"

# 9.- LOG FILE
LOG="$ROUTEOFSOLUTION/shield_log"

################# FUNCTIONS #################
function write_log
{
	echo -e "$@" >> $LOG 
}

################# C #################

if [[ $FLAG == $C_FLAG ]]; then
	if [[ $EXT == $C_EXT ]]; then
		mkdir $ROUTEOFSOLUTION
		write_log "Running shield code in c..."
		write_log "Copying original problem..."
		cp $PROBLEMPATH $ROUTEOFSOLUTION/code.c
		write_log "Copying shield files 1/2"
		cp $SHIELD_PATH/$C_SHIELD $ROUTEOFSOLUTION/$C_SHIELD
		write_log "Copying shield files 2/2"
		cp $SHIELD_PATH/$C_BLACKLIST $ROUTEOFSOLUTION/$C_BLACKLIST
		write_log "Working..."
		echo '#define main themainmainfunction' | cat - $ROUTEOFSOLUTION/code.c > thetemp && mv thetemp $ROUTEOFSOLUTION/code.c
		write_log "Compiling..."
		$C_COMPILER $ROUTEOFSOLUTION/$C_SHIELD $C_OPTIONS $C_WARNING_OPTION -o $ROUTEOFSOLUTION/../$C_EXEFILE >/dev/null 2>$ROUTEOFSOLUTION/cerr
		echo $?
		write_log "Done."
	else
		write_log "Incorrect extension."
	fi
fi

################# C++ #################

if [[ $FLAG == $CPP_FLAG ]]; then
	if [[ $EXT == $CPP_EXT ]]; then
		mkdir $ROUTEOFSOLUTION
		write_log "Running shield code in C++..."
		write_log "Copping original problem..."
		cp $PROBLEMPATH $ROUTEOFSOLUTION/code.c
		write_log "Copping shield files 1/2"
		cp $SHIELD_PATH/$CPP_SHIELD $ROUTEOFSOLUTION/$CPP_SHIELD
		write_log "Copping shield files 2/2"
		cp $SHIELD_PATH/$CPP_BLACKLIST $ROUTEOFSOLUTION/$CPP_BLACKLIST
		write_log "Working..."
		echo '#define main themainmainfunction' | cat - $ROUTEOFSOLUTION/code.c > thetemp && mv thetemp $ROUTEOFSOLUTION/code.c
		write_log "Compiling..."
		$CPP_COMPILER $ROUTEOFSOLUTION/$CPP_SHIELD $C_OPTIONS $C_WARNING_OPTION -o $ROUTEOFSOLUTION/../$CPP_EXEFILE >/dev/null 2>$ROUTEOFSOLUTION/cerr
		echo $?
		write_log "Done."
	else
		write_log "Incorrect extension."
	fi
fi

################# PYTHON #################

if [[ $FLAG == $PY2_FLAG || $FLAG == $PY3_FLAG ]]; then
	if [[ $FLAG == $PY2_FLAG && $PY_EXT == $EXT ]] ; then
		mkdir $ROUTEOFSOLUTION
		write_log "Running shield for python..."
		write_log "Copping original problem..."
		cp $PROBLEMPATH $ROUTEOFSOLUTION/$FILE
		write_log "Copping shield file..."
		cp $SHIELD_PATH/$PY2_SHIELD $ROUTEOFSOLUTION/$PY2_SHIELD
		write_log "Working..."
		cat $PY2_SHIELD | cat - $ROUTEOFSOLUTION/$FILE > thetemp && mv thetemp $ROUTEOFSOLUTION/$FILE
		write_log "Compiling..."
		$PY2_COMPILER $ROUTEOFSOLUTION/$FILE >/dev/null 2>$ROUTEOFSOLUTION/cerr
		echo $?
		write_log "Done."
	fi
	if [[ $FLAG == $PY3_FLAG && $PY_EXT == $EXT ]]; then
		mkdir $ROUTEOFSOLUTION
		echo "Running shield for python3..."
		write_log "Copping original problem..."
		cp $PROBLEMPATH $ROUTEOFSOLUTION/$FILE
		write_log "Copping shield file..."
		cp $SHIELD_PATH/$PY3_SHIELD $ROUTEOFSOLUTION/$PY3_SHIELD
		write_log "Working..."
		cat $PY3_SHIELD | cat - $ROUTEOFSOLUTION/$FILE > thetemp && mv thetemp $ROUTEOFSOLUTION/$FILE
		write_log "Compiling..."
		$PY3_COMPILER $PY_OPTIONS $ROUTEOFSOLUTION/$FILE >/dev/null 2>$ROUTEOFSOLUTION/cerr
		echo $?
		write_log "Done."
	fi
fi

################# JAVA #################

if [[ $FLAG == $JAVA_FLAG ]]; then
	if [[ $EXT == $JAVA_EXT ]]; then
		mkdir $ROUTEOFSOLUTION
		echo "Running shield for Java..."
		write_log "Copping original problem..."
		cp $PROBLEMPATH $ROUTEOFSOLUTION/$FILE
		write_log "Copping shield file..."
		cp $SHIELD_PATH/java.policy $ROUTEOFSOLUTION/java.policy
		write_log "Compiling..."
		$JAVA_COMPILER $ROUTEOFSOLUTION/$FILE >/dev/null 2>$ROUTEOFSOLUTION/cerr
		echo $?
		write_log "Done."
	else
		write_log "Java shield error: Incorrect --FLAG or extension..."
	fi
fi

#INCLUIR

# 1.- ID DEL SUBMIT
# 2.- CARPETA COMPETENCIA