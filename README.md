## core-judge

Core Judge is a set of modules open source to evaluate C, C++, Python and Java scripts. 

These scripts were design to any web interface. Python in Judge is not sandboxed yet. Just a low level of security is provided for python.

If you want to use Core Judge for python, USE IT AT YOUR OWN RISK or provide sandboxing yourself.

### Features

  * Support for `C`, `C++`, `Python2`, `Python3` and `Java`.
  * Shield in searching of malicious lines in the source code to evaluate.
  * Sandboxing to C/C++ use [EasySandbox](https://github.com/daveho/EasySandbox).
  * Sandboxing _(not yet for python)_
  * Output Comparison using `diff` and `diff2html` for checking output correctness.
  * Output Comparison in `HTML5` using `bootstrap 3`.
  * Simple answer!
  * ...

### Requirements

For running core judge, a Linux server with following requirements is needed:

  * Tools for compiling and running codes (`gcc`, `g++`, `javac`, `java`, `python2` and `python3` commands).

### Usage

```sh
./main.sh /FULL_PATH/PROBLEM FLAG MEMLIMIT TIMELIMIT SHIELD SANDBOX COMPARE DIFF2HTML JAVA_POLICY DISPLAY_JAVA_EXCEPTION_ON
```
Example: 
```sh
./main.sh /home/user/desktop/core-judge/tests/123-searching-quickly/Searching.cpp --cpp 5120 30 1 0 1 1 1 1 
```
* Flags: [ --c, --cpp, --py2, --py3, --java]
* MemoryLimit in kbs. 5120 kb (5MB).
* TimeLimit in seconds. 90 (1m:30s)
* Shield 0 - 1
* Sandbox 0 - 1
* Compare 0 - 1
* Diff2html 0 - 1
* Java policy 0 - 1
* Display java exception 0 - 1

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