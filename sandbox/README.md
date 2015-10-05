## Sandbox

Core-jude can execute code in several languages, such as C, C ++, Python and Java, foreach one it uses a different technique.It should run codes in a restricted environment.

You can improve security by enabling alongside Sandbox.

### C/C++ Sandboxing

Core-judge use [EasySandbox](https://github.com/daveho/EasySandbox) for sandboxing C/C++ codes. EasySandbox limits the running code using **[seccomp](http://lwn.net/Articles/332974/)**, a sandboxing mechanism in Linux kernel.

### Python Sandboxing

Don't have a solution yet.

### Java Sandboxing

Java sandbox is enabled by default using Java Security Manager.

### Usage
Run the `make` command to build the sandbox shared library.

```sh
$ ./sandbox.sh /full_path/exefile /full_path/input.txt(Optional)
```
#### Status Codes
* 0 - Sandboxing Success.
* 1 - Sandboxing Failed.
* 2 - File not found.


