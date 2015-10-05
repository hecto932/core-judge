## Shield

Shield is an extremely simple mechanism to forbid running of potentially harmful codes.

Shield is not a sandboxing solution. Shield provides only a partial protection against trivial attacks. 

### Shield for C/C++

By enabling Shield for C/C++, just adds some `#define`s at the beginning of submitted C/C++ code before running.

For example we can forbid using `goto` by adding this line at the beginning of submitted code:

```c
#define goto YouCannotUseGoto
```

With this line at the beginning of files, all submitted codes which use `goto` will get a compilation error.

If you enable Shield, any code that contains `#undef` will get a compilation error.

#### Adding Rules for C/C++

List of `#define` rules is located in files `core-judge/shield/blacklist_c.h` (for C) and `core-judge/shield/blacklist_cpp.h` (for C++). You can add new `#define` rules in these files. 

The syntax used in these files is like this:

```c

#define system errorNo1      //"system" is not allowed
#define freopen errorNo2     //File operation is not allowed
#define fopen errorNo3       //File operation is not allowed
#define fprintf errorNo4     //File operation is not allowed
#define fscanf errorNo5      //File operation is not allowed
#define feof errorNo6        //File operation is not allowed
#define fclose errorNo7      //File operation is not allowed
#define ifstream errorNo8    //File operation is not allowed
#define ofstream errorNo9    //File operation is not allowed
#define fork errorNo10       //Fork is not allowed
#define clone errorNo11      //Clone is not allowed
#define sleep errorNo12      //Sleep is not allowed
```

There should be a newline at the end of files `blacklist_c.h` and `blacklist_cpp.h`.

Note that lots of these rules are not usable in g++. For example we cannot use `#define fopen errorNo3` for C++. Because it results in compile error.

### Shield for Python

By enabling Shield for Python, just adds some code at the beginning of submitted Python code before running to prevent using dangerous functions.

There are ways to escape from Shield in python and use blacklisted functions!

```python
# @file shield_python3.py

import sys
sys.modules['os']=None

BLACKLIST = [
  #'__import__', # deny importing modules
  'eval', # eval is evil
  'open',
  'file',
  'exec',
  'execfile',
  'compile',
  'reload',
  #'input'
  ]
for module in BLACKLIST:
  if module in __builtins__.__dict__:
    del __builtins__.__dict__[module]
```


### Java List Exceptions

By enabling Shield for Java, there a file with all exceptions.

```Java

java.lang.ArithmeticException
java.lang.ArrayIndexOutOfBoundsException
java.lang.ArrayStoreException
java.lang.ClassCastException
java.lang.ClassNotFoundException
java.lang.CloneNotSupportedException
java.lang.EnumConstantNotPresentException
java.lang.Exception
java.lang.IllegalAccessException
java.lang.IllegalArgumentException
java.lang.IllegalMonitorStateException
java.lang.IllegalStateException
java.lang.IllegalThreadStateException
java.lang.IndexOutOfBoundsException
java.lang.InstantiationException
java.lang.InterruptedException
java.lang.NegativeArraySizeException
java.lang.NoSuchFieldException
java.lang.NoSuchMethodException
java.lang.NullPointerException
java.lang.NumberFormatException
java.lang.ReflectiveOperationException
java.lang.RuntimeException
java.lang.SecurityException
java.lang.StringIndexOutOfBoundsException
java.lang.TypeNotPresentException
java.lang.UnsupportedOperationException

java.lang.AbstractMethodError
java.lang.AssertionError
java.lang.BootstrapMethodError
java.lang.ClassCircularityError
java.lang.ClassFormatError
java.lang.Error
java.lang.ExceptionInInitializerError
java.lang.IllegalAccessError
java.lang.IncompatibleClassChangeError
java.lang.InstantiationError
java.lang.InternalError
java.lang.LinkageError
java.lang.NoClassDefFoundError
java.lang.NoSuchFieldError
java.lang.NoSuchMethodError
java.lang.OutOfMemoryError
java.lang.StackOverflowError
java.lang.ThreadDeath
java.lang.UnknownError
java.lang.UnsatisfiedLinkError
java.lang.UnsupportedClassVersionError
java.lang.VerifyError
java.lang.VirtualMachineError

java.util.ConcurrentModificationException
java.util.EmptyStackException
java.util.MissingResourceException
java.util.NoSuchElementException
java.util.TooManyListenersException

java.io.IOError
java.io.EOFException
java.io.FileNotFoundException
java.io.InterruptedIOException
java.io.InvalidClassException
java.io.InvalidObjectException
java.io.IOException
java.io.NotActiveException
java.io.NotSerializableException
java.io.OptionalDataException
java.io.StreamCorruptedException
java.io.SyncFailedException
java.io.UnsupportedEncodingException
java.io.UTFDataFormatException
java.io.WriteAbortedException

java.security.AccessControlException

```