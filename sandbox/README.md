# Sandbox

Core judge runs lots of codes. It should run codes in a restricted environment. So we need tools to sandbox submitted codes in Sharif Judge.

You can improve security by enabling alongside Sandbox.

## C/C++ Sandboxing

For C and C++ codes core-judge using a variant implement of easySandbox[EasySandbox](https://github.com/daveho/EasySandbox) for sandboxing C/C++ codes. EasySandbox limits the running code using **[seccomp](http://lwn.net/Articles/332974/)**, a sandboxing mechanism in Linux kernel.

## Python2 and Python3

We don't have a solution yet.

## Java Sandboxing

Java sandbox is enabled by default using Java Security Manager.

## Usage

```sh
$ make 
$ ./sandbox.sh /full_path/exefile /full_path/input.txt(Optional)
```

 STATUS CODES
 ============
* 0 - SANDBOX SUCCESS
* 1 - SANDBOX FAILED
* 2 - FILE NOT FOUND