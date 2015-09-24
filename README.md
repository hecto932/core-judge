# Core Judge

Core Judge is a set of modules open source to evaluate C, C++, Java and Python Scripts. 

These scripts were design to any web interface. Python in Judge is not sandboxed yet. Just a low level of security is provided for python.

If you want to use Core Judge for python, USE IT AT YOUR OWN RISK or provide sandboxing yourself.


## Features

  * Support for `C`, `C++`, `Python2`, `Python3` and `Java`.
  * Pre-evaluation in searching of malicious lines in the source code to evaluate.
  * Sandboxing _(not yet for python)_
  * Output Comparison using `DIFF` and `DIFF2HTML` for checking output correctness.
  * Output Comparison in `HTML5` using `bootstrap 3`.
  * Simple answer!
  * ...

## Requirements

For running Core judge, a Linux server with following requirements is needed:

  * Tools for compiling and running codes (`gcc`, `g++`, `javac`, `java`, `python2` and `python3` commands).

## Installation

  1. Verify that you have all tools described previously.
  2. Clone this repository, or also, you can download this repository.
  3. cd sandbox
  4. make 
  3. Enjoy.

## Quick use

```sh
$ ./main.sh /FULLPATH/PROBLEM --FLAG MEMORYLIMIT TIMELIMIT ON_SHIELD ON_SANDBOX ON_COMPARE ON_DIFF2HMTL JAVA_POLICY DISPLAY_JAVA_EXCEPTION_ON
```

* FLAGS:
* =====
* --c to language C
* --cpp to C++ language
* --py2 to Python language
* --py3 to Python language
* --java to Java language

* MEMORYLIMIT (kb)
* TIMELIMIT (seconds)
* ON_SHIELD (0 or 1)
* ON_SANDBOX (0 or 1)
* ON_COMPARE (0 or 1)
* JAVA_POLICY (0 or 1)
* DISPLAY_JAVA_EXPTION_ON (0 or 1)

* FULLPATH/problem.ext `/home/user/Desktop/example.c`.
* --FLAG this flag only have four values `--c`, `--cpp`, `--py2`, `--py3` and `--java`.
* TIMELIMIT expressed in seconds. `1m:30s = 90`.
* MEMORYLIMIT - Example (5MB = 5120 Kb) `5120`.

## License

The MIT License (MIT)

Copyright (c) 2015 Hector Jose Flores Colmenarez

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.