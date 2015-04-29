#!/usr/bin/env python

import sys

name = sys.argv[1]
age = int(sys.argv[2])
diff = 100 - age

print "Hello", name + ', you will be 100 in', diff, 'years!'