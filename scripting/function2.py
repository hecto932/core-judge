#!/usr/bin/env python

import sys

def fac(n):
	if n > 1:
		return n * fac(n-1)
	else:
		return 1

num = int(raw_input("Enter a number: "))
print str(num) + "! =", fac(num)