Python Daemon
-------------

1. Introduction.

Provides a template for a Disk And Execution MONitor (Daemon) with parameters and logging options. Its main purpose is to be used as a starting point when creating Linux daemons in Python.

It has a number of configurable parameters, such as:

* Working directory (set by default to the root "/" directory).
* File creation mode mask (set by default to 0022).
* Number of file descriptors to close when daemonizing (set to 1024 by default).

2. Features.

* Strictly abides by the UNIX standards when daemonizing.
* Standard I/O streams are redirected to "/dev/null".
* Logs to the console when not in daemon mode (useful to debug).
* Logs to a file when in daemon mode (useful when in production).
* Allows the creation of a new log file or appending to an existing one.
* Allows the creation of a pidfile, which is deleted upon termination.
* Captures a number of signals:
  * SIGINT. Closes log file and terminates. Useful when sending output to the console while debugging.
  * SIGTERM. Closes the log file and terminates. Useful when you want to terminate in a controlled manner.
  * SIGHUP. Reopens the log file descriptor. Useful when rotating log files.
* Allows to set verbose and debug modes, used when logging.
* Does a number of checks regarding the received options (such as not going into daemon mode without a log file).
* Has a dummy loop that sends the uptime to the log.

3. Usage.

This is an example usage to run it not in daemon mode (for developing and debugging):

python mydaemon.py --debug

And this is an example usage to run it in daemon mode:

python mydaemon.py --verbose --daemon --logfile=/path/to/mydaemon.log --pidfile=/path/to/mydaemon.pid

Or you could also do this:

python mydaemon.py --verbose --daemon --workdir=/path/to/ --logfile=mydaemon.log --pidfile=mydaemon.pid

4. Credits.

This daemon was developed by Isaac Jurado (ijurado@econcept.es) and Jaume Sabater (jsabater@econcept.es) while working at eConcept Consulting (http://econcept.es/) as a proof of concept. If it is useful to you, please let us know. If you made any modifications worth something (for instance, make it bind to an address and a port), please contribute it back so more people can benefit from it.
