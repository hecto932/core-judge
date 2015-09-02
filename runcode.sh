#!/bin/bash

# *****************************************
# * FILE: runcode.sh                      *
# * AUTOR: Hector Jose Flores Colmenarez  *
# * EMAIL: hecto932@gmail.com             *           
# *****************************************

# FUNCTIONALITY
# ==============
# runcode.sh MUST BE RUN THIS WAY:
# ./runcode.sh extension memorylimit timelimit timelimit_int input_file command

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
RUN_PATH=$SCRIPTPATH

# GETTINGS ARGUMENTS 
# ==================

# 1.- 
FLAG=${1}

if [[ $FLAG=="--c" || $FLAG=="--cpp" ]]; then
	LD_PRELOAD=./SCRIPTPATH/EasySandbox.so ./
fi