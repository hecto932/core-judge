#!/bin/bash

# *****************************************
# * FILE: shield_c.c                      *
# * AUTOR: Hector Jose Flores Colmenarez  *
# * EMAIL: hecto932@gmail.com             *           
# *****************************************

# ESTE SCRIPT FUNCIONA COMO UNA INTERFAZ
# PARA PODER EJECUTAR EL SHIELD

# FUNCTIONALITY
# ==============

# THE SHIELD MUST BE RUN THIS WAY:
# ./shield.sh --c example.c
# ./shield.sh --cpp example.cpp
# ./shield.sh --py2 example.py
# ./shield.sh --py3 example.py
# ./shield.sh --java example.java

# FLAGS:
# =====
# --c to language C
# --cpp to C++ language
# --py2 to Python language
# --py3 to Python language
# --java to Java language

# COMPILER OPTIONS FOR C/C++
# ==========================
C_COMPILER="gcc"
C_OPTIONS="-fno-asm -Dasm=error -lm -O2"
C_WARNING_OPTION="-w"
C_EXEFILE="1"
C_SHIELD="shield_c.c"
C_FLAG="--c"
C_EXT="c"

CPP_COMPILER="g++"
CPP_EXEFILE="1"
CPP_SHIELD="shield_cpp.cpp"
CPP_FLAG="--cpp"
CPP_EXT="cpp"
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

if [ $# -gt 1 ]; then

	FLAG=$1
	FILE=$2
	EXT="${FILE##*.}"

	# C
	if [ "$FLAG" == "$C_FLAG" ]; then
		if [ "$EXT" == "$C_EXT" ]; then
			echo "Running shield code in c..."
			#echo "Cambiando de nombre..."
			mv $FILE code.c
			#echo "Refactorizando codigo..."
			echo '#define main themainmainfunction' | cat - code.c > thetemp && mv thetemp code.c
			#echo "Compilando..."
			$C_COMPILER $C_SHIELD $C_OPTIONS $C_WARNING_OPTION -o $C_EXEFILE >/dev/null 2>cerr
			EXITCODE=$?
			if [ $EXITCODE=0 ]; then
				#echo "Compilacion exitosa..."
				#echo "Estatus de compilacion: $EXITCODE"
				echo $EXITCODE
				#./$C_EXEFILE > out_$FILE.txt
			else
				echo "Error de compilación..."
				echo "Estatus de compilacion: $EXITCODE"
			fi
			#echo "Colocando todo en su lugar..."
			mv code.c $FILE
		else
			echo "Incorrect --FLAG or extension..."
		fi	
	fi

	# C++
	if [ "$FLAG" == "$CPP_FLAG" ]; then
		if [ "$EXT" == "$CPP_EXT" ]; then
			echo "Running shield code in c++..."
			#echo "Cambiando de nombre..."
			mv $FILE code.c
			#echo "Refactorizando codigo..."
			echo '#define main themainmainfunction' | cat - code.c > thetemp && mv thetemp code.c
			#echo "Compilando..."
			$CPP_COMPILER $CPP_SHIELD $C_OPTIONS $C_WARNING_OPTION -o $CPP_EXEFILE >/dev/null 2>cerr
			EXITCODE=$?
			if [ $EXITCODE=0 ]; then
				echo "Compilacion exitosa..."
				echo "Estatus de compilacion: $EXITCODE"
				./$CPP_EXEFILE > out_$FILE.txt
			else
				echo "Error de compilación..."
				echo "Estatus de compilacion: $EXITCODE"
			fi
			#echo "Colocando todo en su lugar..."
			mv code.c $FILE
		else
			echo "C++ shield error: Incorrect --FLAG or extension..."
		fi	
	fi
	
	# PYTHON
	if [[ $FLAG == $PY2_FLAG || $FLAG == $PY3_FLAG ]]; then
		if [[ $FLAG == $PY2_FLAG && $PY_EXT == $EXT ]] ; then
			echo "Running shield for python..."
			cat $PY2_SHIELD | cat - $FILE > thetemp && mv thetemp $FILE
			$PY2_COMPILER $PY_OPTIONS $FILE >/dev/null 2>cerr
			echo $?
		fi
		if [[ $FLAG == $PY3_FLAG && $PY_EXT == $EXT ]]; then
			echo "Running shield for python3..."
			cat $PY3_SHIELD | cat - $FILE > thetemp && mv thetemp $FILE
			$PY3_COMPILER $PY_OPTIONS $FILE >/dev/null 2>cerr
			echo $?
		fi
	fi

	# JAVA
	if [[ $FLAG == $JAVA_FLAG ]]; then
		echo "Running shield for Java..."
		if [[ $EXT == $JAVA_EXT ]]; then
			$JAVA_COMPILER $FILE >/dev/null 2>cerr
			echo $?
			#$JAVA_RUNNER $JAVA_POLICY "${FILE%.*}" >/dev/null 2>cerr
			#echo $?
		else
			echo "Java shield error: Incorrect --FLAG or extension..."
		fi
	fi
	
else
	echo "Usage: ./shield.sh --FLAG --PATHFILE"
  	echo "\tFLAGS"
  	echo "\t====="
  	echo "\tUse: --c for C"
  	echo "\tUse: --cpp for C++"
  	echo "\tUse: --py2 for Python2"
  	echo "\tUse: --py3 for Python3"
  	echo "\tUse: --java for Java"
fi
