#!/bin/bash

# *****************************************
# * FILE: compare.sh                      *
# * AUTOR: Hector Jose Flores Colmenarez  *
# * EMAIL: hecto932@gmail.com             *           
# *****************************************

# FUNCTIONALITY
# ==============

# THE SHIELD MUST BE RUN THIS WAY:
# ./compare.sh -flgs file1 file2


# FLAGS:
# =====



# GLOBALS
# =======
GLOBAL_ARGUMENTS="-ubB"


# OPTIONS
# ==========================



# GETTINGS ARGUMENTS 
# ==================

# 1.- ARGUMENTS
ARGUMENTS=${1}

# 2.- FILENAME1
FILENAME1=${2}

#3.- FILENAME2
FILENAME2=${3}

echo "$GLOBAL_ARGUMENTS $FILENAME1 $FILENAME2"

diff $GLOBAL_ARGUMENTS $FILENAME1 $FILENAME2