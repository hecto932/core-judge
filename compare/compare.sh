#!/bin/sh

if diff3 file1.txt file2.txt >/dev/null ; then
  	echo Same
else
  	echo Different
fi