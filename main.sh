#!/bin/bash

# *****************************************
# * FILE: main.sh                         *
# * AUTOR: Hector Jose Flores Colmenarez  *
# * EMAIL: hecto932@gmail.com             *           
# *****************************************

# USAGE : ./main.sh /FULLPATH/PROBLEM --FLAG MEMORYLIMIT TIMELIMIT ON_SHIELD ON_SANDBOX ON_COMPARE ON_DIFF2HMTL JAVA_POLICY DISPLAY_JAVA_EXCEPTION_ON
# =======

# FLAGS:
# =====
# --c to language C
# --cpp to C++ language
# --py2 to Python language
# --py3 to Python language
# --java to Java language

# MEMORYLIMIT (kb)
# TIMELIMIT (seconds)
# ON_SHIELD (0 or 1)
# ON_SANDBOX (0 or 1)
# ON_COMPARE (0 or 1)
# JAVA_POLICY (0 or 1)
# DISPLAY_JAVA_EXPTION_ON (0 or 1)

# STATUS CODES
# ============
# 0 - OK
# 1 - Error
# 2 - File not found.
# 3 - Missing Arguments
# 4 - Compare is disabled.

# GET CURRENT TIME (IN MILLISECONDS)
START=$(($(date +%s%N)/1000000));

# GLOBALS
# =======

# MISC
SCRIPT=$(readlink -f "$0")

# DIRECTORY PATH
SCRIPTPATH=$(dirname "$SCRIPT")

# TIMELIMIT (1m:30s = 90s)
# DEFAULT_TIMELIMIT=90

# MEMORYLIMIT (5MB = 5120 Kb)
# DEFAULT_MEMORYLIMIT=5120

# GETTINGS ARGUMENTS 
# ==================

# 1.- FULLPATH PROBLEM
PROBLEMPATH=${1}

# 2.- FLAG
FLAG=${2}

# 3.- MEMORYLIMIT(Kb)
MEMORYLIMIT=${3}

# 4.- TIMELIMIT(Seconds)
TIMELIMIT=${4}

# 5.- ENABLE/DISABLE SHIELD
ON_SHIELD=${5}

# 6.- ENABLE/DISABLE SANDBOX
ON_SANDBOX=${6}

# 7.- ENABLE/DISABLE DIFF
ON_COMPARE=${7}

# 8.- ENABLE/DISABLE DIFF2HTML
ON_DIFF2HMTL=${8}

# 9.- JAVA_POLICY ENABLE/DISABLE JAVA SECURITY MANAGER
JAVA_POLICY=${9}
if [[ $JAVA_POLICY == "1" ]]; then
	JAVA_POLICY="-Djava.security.manager -Djava.security.policy=java.policy"
else
	JAVA_POLICY=""
fi

# 10.- DISPLAY_JAVA_EXCEPTION_ON
DISPLAY_JAVA_EXCEPTION_ON=${10}

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

# MISC
# ====

# FILE
FILE=${PROBLEMPATH##*/}  

# EXTENSION
EXT="${FILE#*.}"

# PATH
DIRECTORY=$(dirname "$PROBLEMPATH")

# FILENAME_OUTPUT
OUTPUT="output.txt"

# CLASS NAME(ONLY FOR JAVA)
CLASSNAME="${FILE%.*}"

# INPUTNAME 
INPUTNAME="input.txt"

########### - FUNCTIONS - ###########

LOG="$DIRECTORY/log"; echo "" >>$LOG

function judge_log
{
	if $LOG_ON; then
		echo "$@" >>$LOG 
	fi
}
########### - /FUNCTIONS - ###########

judge_log  "$(date)"
judge_log  "Language: $EXT"
judge_log  "Time Limit: $TIMELIMIT s"
judge_log  "Memory Limit: $MEMORYLIMIT kB"

if [[ ! -f $PROBLEMPATH ]]; then
    judge_log "File not found!"
    exit 2
else
	if [[ $# == 10 ]]; then

		

		#################### C ####################
		if [[ $FLAG == $C_FLAG ]]; then
			# IF SHIELD IS ENABLE
			if [[ $ON_SHIELD == "1" ]]; then
				SHIELD_CODE=$($SCRIPTPATH/shield/shield.sh $FLAG $PROBLEMPATH) >/dev/null 2>$DIRECTORY/cerr
			else
				$C_COMPILER $FULLPATH $C_OPTIONS $C_WARNING_OPTION -o $DIRECTORY/$CLASSNAME >/dev/null 2>$DIRECTORY/cerr 
				SHIELD_CODE=$?
			fi

			judge_log "SHIELD = $SHIELD_CODE"

			if [[ $SHIELD_CODE == "0" ]]; then

				# IF SANDBOX IS ENABLE
				if [[ $ON_SANDBOX == "1" ]]; then

					# IF THE PROBLEM HAS INPUT
					if [[ -f $DIRECTORY/input.txt ]]; then
						$SCRIPTPATH/runcode.sh $FLAG $DIRECTORY $MEMORYLIMIT $TIMELIMIT "LD_PRELOAD=$SCRIPTPATH/sandbox/sandbox.so $DIRECTORY/$CLASSNAME" $DIRECTORY/input.txt
					else
						$SCRIPTPATH/runcode.sh $FLAG $DIRECTORY $MEMORYLIMIT $TIMELIMIT "LD_PRELOAD=$SCRIPTPATH/sandbox/sandbox.so $DIRECTORY/$CLASSNAME"
					fi
					SANDBOX_CODE=$?
					judge_log "SANDBOX = $SANDBOX_CODE"
					EXIT_CODE=$SANDBOX_CODE
				else # IF SANDBOX IS DISABLE
					
					# IF THE PROBLEM HAS INPUT
					if [[ -f $DIRECTORY/input.txt ]]; then
						$SCRIPTPATH/runcode.sh $FLAG $DIRECTORY $MEMORYLIMIT $TIMELIMIT "$DIRECTORY/$CLASSNAME" $DIRECTORY/input.txt >/dev/null 2>$DIRECTORY/cerr
					else
						$SCRIPTPATH/runcode.sh $FLAG $DIRECTORY $MEMORYLIMIT $TIMELIMIT "$DIRECTORY/$CLASSNAME" >/dev/null 2>$DIRECTORY/cerr
					fi
					RUN_CODE=$?
					judge_log "RUN = $RUN_CODE"
					EXIT_CODE=$RUN_CODE
				fi
				
				if [[ $EXIT_CODE == "0" ]]; then
					if [[ $ON_COMPARE == "1" ]]; then
						if [[ $ON_DIFF2HMTL == "1" ]]; then
							$SCRIPTPATH/compare/compare.sh $DIRECTORY/output.txt $DIRECTORY/expected.txt --diff2html >/dev/null 2>$DIRECTORY/cerr
						else
							$SCRIPTPATH/compare/compare.sh $DIRECTORY/output.txt $DIRECTORY/expected.txt >/dev/null 2>$DIRECTORY/cerr
						fi
						COMPARE_CODE=$?
						judge_log "COMPARE = $COMPARE_CODE"
					else
						COMPARE_CODE=4
						judge_log "COMPARE = Disable."
					fi
				fi
			fi
		fi

		################### C++ ###################
		if [[ $FLAG == $CPP_FLAG ]]; then
			# IF SHIELD IS ENABLE
			if [[ $ON_SHIELD == "1" ]]; then
				SHIELD_CODE=$($SCRIPTPATH/shield/shield.sh $FLAG $PROBLEMPATH) >/dev/null 2>$DIRECTORY/cerr
			else
				$CPP_COMPILER $FULLPATH $CPP_OPTIONS $CPP_WARNING_OPTION -o $DIRECTORY/$CLASSNAME >/dev/null 2>$DIRECTORY/cerr
				SHIELD_CODE=$?
			fi

			judge_log "SHIELD = $SHIELD_CODE"
			
			if [[ $SHIELD_CODE == "0" ]]; then

				# IF SANDBOX IS ENABLE
				if [[ $ON_SANDBOX == "1" ]]; then

					# IF THE PROBLEM HAS INPUT
					if [[ -f $DIRECTORY/input.txt ]]; then
						cp $SCRIPTPATH/sandbox/sandbox.so $DIRECTORY/Sandbox.so
						$SCRIPTPATH/runcode.sh $FLAG $DIRECTORY $MEMORYLIMIT $TIMELIMIT "LD_PRELOAD=./Sandbox.so $DIRECTORY/$CLASSNAME" $DIRECTORY/input.txt >/dev/null 2>$DIRECTORY/cerr
					else
						cp $SCRIPTPATH/sandbox/sandbox.so $DIRECTORY/Sandbox.so
						$SCRIPTPATH/runcode.sh $FLAG $DIRECTORY $MEMORYLIMIT $TIMELIMIT "LD_PRELOAD=./Sandbox.so $DIRECTORY/$CLASSNAME" >/dev/null 2>$DIRECTORY/cerr
					fi
					SANDBOX_CODE=$?
					judge_log "SANDBOX = $SANDBOX_CODE"
					EXIT_CODE=$SANDBOX_CODE
				else # IF SANDBOX IS DISABLE
					
					# IF THE PROBLEM HAS INPUT
					if [[ -f $DIRECTORY/input.txt ]]; then
						$SCRIPTPATH/runcode.sh $FLAG $DIRECTORY $MEMORYLIMIT $TIMELIMIT "$DIRECTORY/$CLASSNAME" $DIRECTORY/input.txt >/dev/null 2>$DIRECTORY/cerr
					else
						$SCRIPTPATH/runcode.sh $FLAG $DIRECTORY $MEMORYLIMIT $TIMELIMIT "$DIRECTORY/$CLASSNAME" >/dev/null 2>$DIRECTORY/cerr
					fi
					RUN_CODE=$?
					judge_log "RUN = $RUN_CODE"
					EXIT_CODE=$RUN_CODE
				fi

				if [[ $EXIT_CODE == "0" ]]; then
					if [[ $ON_COMPARE == "1" ]]; then
						if [[ $ON_DIFF2HMTL == "1" ]]; then
							$SCRIPTPATH/compare/compare.sh $DIRECTORY/output.txt $DIRECTORY/expected.txt --diff2html >/dev/null 2>$DIRECTORY/cerr
						else
							$SCRIPTPATH/compare/compare.sh $DIRECTORY/output.txt $DIRECTORY/expected.txt >/dev/null 2>$DIRECTORY/cerr
						fi
						COMPARE_CODE=$?
						judge_log "COMPARE = $COMPARE_CODE"
					else
						COMPARE_CODE=4
						judge_log "COMPARE = Disable."
					fi
				fi
			fi
		fi

		################### PYTHON2 ###################
		if [[ $FLAG == $PY2_FLAG ]]; then
			# IF SHIELD IS ENABLE
			if [[ $ON_SHIELD == "1" ]]; then
				SHIELD_CODE=$($SCRIPTPATH/shield/shield.sh $FLAG $PROBLEMPATH) >/dev/null 2>$DIRECTORY/cerr
			else
				$PY2_COMPILER $PY_OPTIONS $DIRECTORY/$FILE >/dev/null 2>$DIRECTORY/cerr
				SHIELD_CODE=$?
			fi

			judge_log "SHIELD = $SHIELD_CODE"
			
			if [[ $SHIELD_CODE == "0" ]]; then

				# IF THE PROBLEM HAS INPUT
				if [[ -f $DIRECTORY/input.txt ]]; then
					$SCRIPTPATH/runcode.sh $FLAG $DIRECTORY $MEMORYLIMIT $TIMELIMIT "python2 -O $PROBLEMPATH" $DIRECTORY/input.txt >/dev/null 2>$DIRECTORY/cerr
				else
					$SCRIPTPATH/runcode.sh $FLAG $DIRECTORY $MEMORYLIMIT $TIMELIMIT "python2 -O $PROBLEMPATH" >/dev/null 2>$DIRECTORY/cerr
				fi

				RUN_CODE=$?

				judge_log "RUN = $RUN_CODE" 

				if [[ $RUN_CODE == "0" ]]; then
					if [[ $ON_COMPARE == "1" ]]; then
						if [[ $ON_DIFF2HMTL == "1" ]]; then
							$SCRIPTPATH/compare/compare.sh $DIRECTORY/output.txt $DIRECTORY/expected.txt --diff2html >/dev/null 2>$DIRECTORY/cerr
						else
							$SCRIPTPATH/compare/compare.sh $DIRECTORY/output.txt $DIRECTORY/expected.txt >/dev/null 2>$DIRECTORY/cerr
						fi
						COMPARE_CODE=$?
						judge_log "COMPARE = $COMPARE_CODE"
					else
						COMPARE_CODE=4
						judge_log "COMPARE = Disable."
					fi
				fi
			fi
		fi

		################### PYTHON3 ###################
		if [[ $FLAG == $PY3_FLAG ]]; then

			# IF SHIELD IS ENABLE
			if [[ $ON_SHIELD == "1" ]]; then
				SHIELD_CODE=$($SCRIPTPATH/shield/shield.sh $FLAG $PROBLEMPATH) >/dev/null 2>$DIRECTORY/cerr
			else
				$PY3_COMPILER $PY_OPTIONS $DIRECTORY/$FILE >/dev/null 2>$DIRECTORY/cerr
				SHIELD_CODE=$?
			fi

			judge_log "SHIELD = $SHIELD_CODE"
			
			if [[ $SHIELD_CODE == "0" ]]; then

				# IF THE PROBLEM HAS INPUT
				if [[ -f $DIRECTORY/input.txt ]]; then
					$SCRIPTPATH/runcode.sh $FLAG $DIRECTORY $MEMORYLIMIT $TIMELIMIT "python3 -O $PROBLEMPATH" $DIRECTORY/input.txt >/dev/null 2>$DIRECTORY/cerr
				else
					$SCRIPTPATH/runcode.sh $FLAG $DIRECTORY $MEMORYLIMIT $TIMELIMIT "python3 -O $PROBLEMPATH" >/dev/null 2>$DIRECTORY/cerr
				fi
				
				RUN_CODE=$?
				judge_log "RUN = $RUN_CODE"
				if [[ $RUN_CODE == "0" ]]; then
					if [[ $ON_COMPARE == "1" ]]; then
						if [[ $ON_DIFF2HMTL == "1" ]]; then
							$SCRIPTPATH/compare/compare.sh $DIRECTORY/output.txt $DIRECTORY/expected.txt --diff2html >/dev/null 2>$DIRECTORY/cerr
						else
							$SCRIPTPATH/compare/compare.sh $DIRECTORY/output.txt $DIRECTORY/expected.txt >/dev/null 2>$DIRECTORY/cerr
						fi
						COMPARE_CODE=$?
						judge_log "COMPARE = $COMPARE_CODE"
					else
						COMPARE_CODE=4
						judge_log "COMPARE = Disable."
					fi
				fi
			fi
		fi
		################### JAVA ###################
		if [[ $FLAG == $JAVA_FLAG ]]; then
			judge_log "JAVA_POLICY: \"$JAVA_POLICY\""
			judge_log "DISPLAY_JAVA_EXCEPTION_ON: $DISPLAY_JAVA_EXCEPTION_ON"
			# IF SHIELD IS ENABLE
			if [[ $ON_SHIELD == "1" ]]; then
				SHIELD_CODE=$($SCRIPTPATH/shield/shield.sh $FLAG $PROBLEMPATH) >/dev/null 2>$DIRECTORY/cerr
			else
				$JAVA_COMPILER $PROBLEMPATH >/dev/null 2>$DIRECTORY/cerr
				SHIELD_CODE=$?
			fi

			judge_log "SHIELD = $SHIELD_CODE"
			
			if [[ $SHIELD_CODE == "0" ]]; then

				# IF THE PROBLEM HAS INPUT
				cd $DIRECTORY
				if [[ -f $DIRECTORY/input.txt ]]; then
					$SCRIPTPATH/runcode.sh $FLAG $DIRECTORY $MEMORYLIMIT $TIMELIMIT "java -mx${MEMORYLIMIT}k $JAVA_POLICY $CLASSNAME" $DIRECTORY/input.txt 
				else
					$SCRIPTPATH/runcode.sh $FLAG $DIRECTORY $MEMORYLIMIT $TIMELIMIT "java -mx${MEMORYLIMIT}k $JAVA_POLICY $CLASSNAME" 
				fi
				
				RUN_CODE=$?
				judge_log "RUN = $RUN_CODE"
				if [[ $RUN_CODE == "0" ]]; then
					if [[ $ON_COMPARE == 1 ]]; then
						if [[ $ON_DIFF2HMTL == 1 ]]; then
							$SCRIPTPATH/compare/compare.sh $DIRECTORY/output.txt $DIRECTORY/expected.txt --diff2html >/dev/null 2>$DIRECTORY/cerr
						else
							$SCRIPTPATH/compare/compare.sh $DIRECTORY/output.txt $DIRECTORY/expected.txt >/dev/null 2>$DIRECTORY/cerr
						fi
						COMPARE_CODE=$?
						judge_log "COMPARE = $COMPARE_CODE"
					else
						COMPARE_CODE=4
						judge_log "COMPARE = Disable."
					fi
				fi
				
				if grep -iq -m 1 "Too small initial heap" output.txt || grep -q -m 1 "java.lang.OutOfMemoryError" err; then
					judge_log "Memory Limit Exceeded"
					continue
				fi
				
				# SHOW EXCEPTION
				if grep -q -m 1 "Exception in" err; then 				
					javaexceptionname=`grep -m 1 "Exception in" err | grep -m 1 -oE 'java\.[a-zA-Z\.]*' | head -1 | head -c 80`
					javaexceptionplace=`grep -m 1 "$MAINFILENAME.java" err | head -1 | head -c 80`
					judge_log "Exception: $javaexceptionname\nMaybe at:$javaexceptionplace"

					if $DISPLAY_JAVA_EXCEPTION_ON && grep -q -m 1 "^$javaexceptionname\$" ../java_exceptions_list; then
						judge_log "Runtime Error $(javaexceptionname)"
					else
						judge_log "Runtime Error"
					fi
					continue
				fi
			fi
		fi


		##################### - RESULTS - #####################
		if [[ $RUN_CODE == "137" ]]; then
			judge_log "Killed."
		fi

		if [[ $RUN_CODE != "0" ]]; then
			judge_log "Runtime error."
		fi

	else
		judge_log "Missing arguments."
		exit 3
	fi
fi

END=$(($(date +%s%N)/1000000));
judge_log "Total Execution Time: $((END-START)) ms"

exit $EXIT_CODE