#!/bin/bash

# *****************************************
# * FILE: compare.sh                      *
# * AUTOR: Hector Jose Flores Colmenarez  *
# * EMAIL: hecto932@gmail.com             *           
# *****************************************

# FUNCTIONALITY
# ==============

# THE SHIELD MUST BE RUN THIS WAY:
# ./compare.sh -flags file1 file2


# FLAGS:
# =====


# GLOBALS
# =======
GLOBAL_ARGUMENTS1="-bB"


# OPTIONS
# ==========================



# GETTINGS ARGUMENTS 
# ==================

# 1.- FILENAME1
FILENAME1=${1}

# 2.- FILENAME2
FILENAME2=${2}

RESULTADO=$(diff -u $FILENAME1 $FILENAME2)

echo $RESULTADO
