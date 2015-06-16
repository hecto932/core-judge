#!/bin/bash

# ESTE SCRIPT FUNCIONA COMO UNA INTERFAZ
# PARA PODER EJECUTAR EL SHIELD

# FUNCIONAMIENTO
# ==============

# EL SHIELD DEBE DE EJECUTARSE DE LA SIGUIENTE MANERA:
# sh shield.sh --lenguaje archivo.ext

# --c to language C
# --c++ to C++ language
# --py to Python language
# --jc to Java language

if [ $# -lt 1 ]; then
	echo "Faltan Argumentos"
	exit 0
else 
	
	echo $EXT $FILE_NAME

	
	if [ $1 == '--C']
	EXT=$1
	FILE_NAME=$2

fi