#!/usr/bin/env python

import sys

if len(sys.argv) > 1:
	name = sys.argv[1]
else:
	name = raw_input('Enter name: ')

if len(sys.argv) > 2:
	age = int(sys.argv[2])
else:
	age = int(raw_input("Enter age: "))

sayHello = "Hello " + name + ","

if age == 100:
	sayAge = "You are already 100 years old!"
elif age < 100:
	sayAge = "You will be 100 in " + str(100 - age) + " years!"
else:
	sayAge = "You turned 100 " + str(age - 100) + " years ago!"

print sayHello, sayAge