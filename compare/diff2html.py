#!/usr/bin/env python

# *****************************************
# * FILE: diff2html.py                    *
# * AUTOR: Hector Jose Flores Colmenarez  *
# * EMAIL: hecto932@gmail.com             *           
# *****************************************

import sys
import os
import string
import re
import time
import stat

if ( __name__ == "__main__" ) :
	# PROCESSES COMMAND-LINE OPTIONS
    cmd_line = string.join(sys.argv)
    print cmd_line
    argv = tuple(sys.argv)
    print argv
