#!/usr/bin/env python

import random

answer = random.randint(1,10)
num = 0

while num != answer:
	num = int(raw_input("What number am I thinking of?"))

	if num != answer:
		print "Wrong!"

print "Correct!"