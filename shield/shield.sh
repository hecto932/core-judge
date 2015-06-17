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

# THE SHIELD MUST BE EXECUTE THIS WAY:
# sh shield.sh --flag archivo.ext

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

if [ $#=2 ]; then

	FLAG=$1
	FILE=$2
	EXT="${FILE##*.}"

	if [ $FLAG=$C_FLAG ]; then
		if [ $EXT=$C_EXT ]; then
			echo "Execute shield code in c..."
			echo "Cambiando de nombre..."
			mv $FILE code.c
			echo "Refactorizando codigo..."
			echo '#define main themainmainfunction' | cat - code.c > thetemp && mv thetemp code.c
			echo "Compilando..."
			$C_COMPILER $C_SHIELD $C_OPTIONS $C_WARNING_OPTION -o $C_EXEFILE >/dev/null 2>cerr
			EXITCODE=$?
			if [ $EXITCODE=0 ]; then
				echo "Compilacion exitosa..."
				echo "Estatus de compilacion: $EXITCODE"
				./$C_EXEFILE > out_$FILE.txt
			else
				echo "Error de compilación..."
				echo "Estatus de compilacion: $EXITCODE"
			fi
			echo "Colocando todo en su lugar..."
			mv code.c $FILE
			exit
		else
			echo "Incorrect --FLAG or extension"
		fi	
	fi
	echo $FLAG $CPP_FLAG
	if [ $FLAG=$CPP_FLAG ]; then
		if [ $EXT=$CPP_EXT ]; then
			echo "Execute shield code in c++..."
			echo "Cambiando de nombre..."
			mv $FILE code.c
			echo "Refactorizando codigo..."
			echo '#define main themainmainfunction' | cat - code.c > thetemp && mv thetemp code.c
			echo "Compilando..."
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
			echo "Colocando todo en su lugar..."
			mv code.c $FILE
			exit
		else
			echo "Incorrect --FLAG or extension"
		fi	
	fi

	
else
	echo "Usage: sh shield.sh --FLAG --PATHFILE"
  	echo "FLAGS"
  	echo "====="
  	echo "Use: --c for C"
  	echo "Use: --cpp for C++"
  	echo "Use: --py for Python"
  	echo "Use: --java for Java"
fi
