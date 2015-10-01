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

# STATUS CODES
# ============
# 0 - SHIELD SUCCESS
# 1 - SHIELD FAILED
# 2 - FILE NOT FOUND
# 3 - INCORRECT FLAG

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

# 10.- EXIT_CODE
EXIT_CODE=3

################# FUNCTIONS #################
function write_log
{
	echo -e "$@" >> $LOG 
}

function rmShieldFilesC
{
	rm $DIRECTORY/$CLASSNAME >/dev/null 2>/dev/null
	rm $DIRECTORY/output.out >/dev/null 2>/dev/null
	rm $DIRECTORY/*.h >/dev/null 2>/dev/null
	rm $DIRECTORY/code.c >/dev/null 2>/dev/null && rm $DIRECTORY/shield_c.c >/dev/null 2>/dev/null
	rm $DIRECTORY/cerr >/dev/null 2>/dev/null
	rm $DIRECTORY/shield_log >/dev/null 2>/dev/null
	rm $DIRECTORY/*.css >/dev/null 2>/dev/null
	rm $DIRECTORY/*.html >/dev/null 2>/dev/null
}

function rmShieldFilesCPP
{
	rm $DIRECTORY/$CLASSNAME >/dev/null 2>/dev/null
	rm $DIRECTORY/output.out >/dev/null 2>/dev/null
	rm $DIRECTORY/*.h >/dev/null 2>/dev/null
	rm $DIRECTORY/code.c >/dev/null 2>/dev/null && rm $DIRECTORY/shield_cpp.cpp >/dev/null 2>/dev/null
	rm $DIRECTORY/cerr >/dev/null 2>/dev/null
	rm $DIRECTORY/shield_log >/dev/null 2>/dev/null
	rm $DIRECTORY/*.css >/dev/null 2>/dev/null
	rm $DIRECTORY/*.html >/dev/null 2>/dev/null
}

function rmShieldFilesPython2
{
	rm $DIRECTORY/*.pyo 2>/dev/null
	rm $DIRECTORY/shield_log 2>/dev/null
	rm $DIRECTORY/cerr 2>/dev/null
	rm $DIRECTORY/shield_python2.py 2>/dev/null
	rm $DIRECTORY/*.css >/dev/null 2>/dev/null
	rm $DIRECTORY/*.html >/dev/null 2>/dev/null
}

function rmShieldFilesPython3
{
	rm $DIRECTORY/*.pyo 2>/dev/null
	rm $DIRECTORY/shield_log 2>/dev/null
	rm $DIRECTORY/cerr 2>/dev/null
	rm $DIRECTORY/shield_python3.py 2>/dev/null
	rm $DIRECTORY/*.css >/dev/null 2>/dev/null
	rm $DIRECTORY/*.html >/dev/null 2>/dev/null
}

function rmShieldFilesJava
{
	rm $DIRECTORY/cerr 2>/dev/null
	rm $DIRECTORY/err 2>/dev/null
	rm $DIRECTORY/java.policy 2>/dev/null
	rm $DIRECTORY/*.class 2>/dev/null
	rm $DIRECTORY/*.css 2>/dev/null
	rm $DIRECTORY/*.html 2>/dev/null
}

# IF EXIST FILE PROBLEM
if [[ ! -f "$PROBLEMPATH" ]]; then
	echo "$FILE doesn't exist."
	EXIT_CODE=2
	echo
fi

############################ C ############################

if [[ $FLAG == $C_FLAG && $EXT == $C_EXT ]]; then
	rmShieldFilesC
	cp $PROBLEMPATH $DIRECTORY/code.c
	# if code contains any 'undef', raise compile error:
	if tr -d ' \t\n\r\f' < $DIRECTORY/code.c | grep -q '#undef'; then
		echo 'code.c:#undef is not allowed' >cerr
		EXIT_CODE=1
	else
		cp $SHIELD_PATH/$C_SHIELD $DIRECTORY/$C_SHIELD
		cp $SHIELD_PATH/$C_BLACKLIST $DIRECTORY/$C_BLACKLIST
		echo '#define main thenewmainfunction' | cat - $DIRECTORY/code.c > thetemp && mv thetemp $DIRECTORY/code.c
		$C_COMPILER $DIRECTORY/$C_SHIELD $C_OPTIONS $C_WARNING_OPTION -o $DIRECTORY/$CLASSNAME >/dev/null 2>$DIRECTORY/cerr
		EXIT_CODE=$?

	fi
fi

############################ C++ ###########################

if [[ $EXT == $CPP_EXT && $FLAG == $CPP_FLAG ]]; then
	rmShieldFilesCPP
	cp $PROBLEMPATH $DIRECTORY/code.c
	# if code contains any 'undef', raise compile error:
	if tr -d ' \t\n\r\f' < $DIRECTORY/code.c | grep -q '#undef'; then
		echo 'code.c:#undef is not allowed' >cerr
		EXIT_CODE=1
	else
		cp $SHIELD_PATH/$CPP_SHIELD $DIRECTORY/$CPP_SHIELD
		cp $SHIELD_PATH/$CPP_BLACKLIST $DIRECTORY/$CPP_BLACKLIST
		echo '#define main thenewmainfunction' | cat - $DIRECTORY/code.c > thetemp && mv thetemp $DIRECTORY/code.c
		$CPP_COMPILER $DIRECTORY/$CPP_SHIELD $C_OPTIONS $C_WARNING_OPTION -o $DIRECTORY/$CLASSNAME >/dev/null 2>$DIRECTORY/cerr
		EXIT_CODE=$?
	fi
fi

########################## PYTHON2 ##########################

if [[ $FLAG == $PY2_FLAG && $PY_EXT == $EXT ]]; then
	rmShieldFilesPython2
	cp $SHIELD_PATH/$PY2_SHIELD $DIRECTORY/$PY2_SHIELD
	cat $SCRIPTPATH/$PY2_SHIELD | cat - $DIRECTORY/$FILE > thetemp && mv thetemp $DIRECTORY/$FILE
	$PY2_COMPILER $PY_OPTIONS $DIRECTORY/$FILE >/dev/null 2>$DIRECTORY/cerr
	EXIT_CODE=$?
fi

########################## PYTHON3 ##########################

if [[ $FLAG == $PY3_FLAG && $PY_EXT == $EXT ]]; then
	rmShieldFilesPython3
	cp $SHIELD_PATH/$PY3_SHIELD $DIRECTORY/$PY3_SHIELD
	cat $SCRIPTPATH/$PY3_SHIELD | cat - $DIRECTORY/$FILE > thetemp && mv thetemp $DIRECTORY/$FILE
	$PY3_COMPILER $PY_OPTIONS $DIRECTORY/$FILE >/dev/null 2>$DIRECTORY/cerr
	EXIT_CODE=$?
fi

########################## JAVA ##########################

if [[ $FLAG == $JAVA_FLAG && $EXT == $JAVA_EXT ]]; then
	rmShieldFilesJava
	cp $SHIELD_PATH/java.policy $DIRECTORY/java.policy
	$JAVA_COMPILER $DIRECTORY/$FILE >/dev/null 2>$DIRECTORY/cerr
	EXIT_CODE=$?
fi

echo $EXIT_CODE
exit $EXIT_CODE