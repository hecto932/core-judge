#!/usr/bin/env python

import sys

validPassword = '20162504'

inputPassword = raw_input('Please enter password: ')

if inputPassword == validPassword:
	print "You have access!"
else:
	print "Access denied!"
	sys.exit(0)

print "Welcome!"