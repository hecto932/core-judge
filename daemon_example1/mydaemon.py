#!/usr/bin/python

"""
Provides a template for a Disk And Execution MONitor (Daemon) with parameters and logging options.
Configurable parameters:
    * Working directory set to the "/" directory.
    * File creation mode mask set to 0022.
    * First 1024 open file descriptors are closed.
    * Standard I/O streams are redirected to "/dev/null".
"""

import os
import sys
import resource
import signal, atexit
import ctypes
import logging
from optparse import OptionParser

__author__ = "Isaac Jurado and Jaume Sabater"
__copyright__ = "Copyright 2011, eConcept Consulting"
__credits__ = ["Isaac Jurado", "Jaume Sabater"]
__license__ = "Affero General Public License"
__version__ = "1.0.3"
__maintainer__ = "Jaume Sabater"
__email__ = "jsabater@econcept.es"
__status__ = "Production"

# Default values of certain variables, in case the values are not passed by parameter
# or they cannot be obtained from the system.
MAXFD = 1024

# Process name (max. 16 bytes).
PROCNAME = 'mydaemon'

def daemonize(workdir=None, umask=None):
    # Fork a child process so the parent can exit.  On some obscure and outdated
    # SunOS versions, a double fork was required due to terminal ownership
    # issues.  Nowadays, a single fork is enough.
    #
    # The parent process immediatly exits without invoking any atexit handlers
    # so that the init process becomes the child's new parent.
    # Any OSException related to the fork() syscall is propagated to the caller.
    if os.fork() > 0:
        os._exit(0)

    # Dettach from terminal, become session and group process leader
    os.setsid()

    # Change the working directory (defaults to / ) to prevent the process from
    # blocking the umount command.
    if workdir:
        os.chdir(workdir)

    # Set umask to prevent the process from using a potentially too powerful mask
    # inherited from its parent.
    if umask:
        os.umask(umask)

    # Close all open file descriptors, ignoring errors.
    maxfd = resource.getrlimit(resource.RLIMIT_NOFILE)[1]
    if maxfd == resource.RLIM_INFINITY:
        maxfd = MAXFD
    for fd in xrange(maxfd):
        try:
            os.close(fd)
        except OSError: # The descriptor was more probably already closed
            pass

    # Redirect stdin, stdout and stderr to /dev/null
    # Since all file descriptors all closed at this moment, os.open() will
    # return id 0, which is sys.stdin
    os.open(os.devnull, os.O_RDWR)
    os.dup2(0, 1)
    os.dup2(0, 2)

def create_pidfile(filename):
    # Create pidfile, register function that will delete it upon termination
    pidfile = open(filename, 'w')
    pidfile.write("%d\n" % os.getpid())
    pidfile.close()
    atexit.register(lambda: os.unlink(filename))

def set_procname(name):
    # This is strictly Linux specific, as the prctl(2) system call is only
    # present in Linux kernels. Note that PR_SET_NAME = 15
    lc = ctypes.cdll.LoadLibrary("libc.so.6")
    lc.prctl(15, name[:15])


if __name__ == "__main__":

    # Define program options here.
    # At least the default value of the port variable should be changed.
    def _parse_options(parser):
        parser.formatter.max_help_position = 78
        parser.add_option("-d", "--daemon", dest="daemon", action='store_true', help="become a daemon process", default=False)
        parser.add_option("-v", "--verbose", dest="verbose", action='store_true', help="be verbose when logging", default=False)
        parser.add_option("-A", "--logappend", dest="logappend", action='store_true', help="append output to logfile", default=False)
        parser.add_option("-D", "--debug", dest="debug", action='store_true', help="add debug information when logging", default=False)
        parser.add_option("-a", "--address", dest="address", type='string', help="listen at specified address", metavar="ADDR", default='127.0.0.1')
        parser.add_option("-l", "--logfile", dest="logfile", type='string', help="log output to this file", metavar="FILE")
        parser.add_option("-p", "--port", dest="port", type='int', help="listen at specified port", metavar="PORT", default=10000)
        parser.add_option("-u", "--umask", dest="umask", type='string', help="use this umask", metavar="UMSK", default=0022)
        parser.add_option("-w", "--workdir", dest="workdir", type='string', help="use this working directory", metavar="PATH", default='/')
        parser.add_option("-P", "--pidfile", dest="pidfile", type='string', help="save process id inside the this file", metavar="FILE")
        return parser.parse_args()

    def _create_logger(options):
        """ Handle creation of the logger """
        level = logging.INFO if options.verbose else logging.WARNING
        if options.debug: level = logging.DEBUG
        fmt = "%(asctime)s - %(levelname)s - %(message)s"
        if options.logfile is not None:
            filename = options.logfile
            filemode = 'a' if options.logappend else 'w'
            logging.basicConfig(filename=options.logfile, filemode=filemode, level=level, format=fmt)
        else:
            logging.basicConfig(level=level, format=fmt)

    # Parse options and make sure we have everything we need
    parser = OptionParser()
    (options, args) = _parse_options(parser)
    parser.destroy()

    if options.logappend and not options.logfile:
        print "Error: --logappend requires --logfile"
        sys.exit(1)

    if options.pidfile and not options.daemon:
        print "Error: --pidfile requires --daemon"
        sys.exit(1)

    if options.daemon and not options.logfile:
        print "Error: --daemon requires --logfile"
        sys.exit(1)

    # Daemonize if requested to do so
    if options.daemon:
        daemonize(options.workdir, int(options.umask))

    # Handle pidfile and logger
    if options.pidfile is not None:
        create_pidfile(options.pidfile)

    # Create the logger
    _create_logger(options)

    # Set process name
    set_procname(PROCNAME)

    # Handle signals
    def handle_sigterm(signum, frame):
        logging.warn('TERM signal received. Exitting.')
        logging.shutdown()
        sys.exit(0) # Calls functions registered with atexit, in LIFO order
    signal.signal(signal.SIGTERM, handle_sigterm)

    def handle_sigint(signum, frame):
        logging.warn('INT signal received. Exitting.')
        logging.shutdown()
        sys.exit(0)
    signal.signal(signal.SIGINT, handle_sigint)

    def handle_sighup(signum, frame):
        logging.warn('HUP signal received. Closing and reopening the log file descriptor.')
        logging.shutdown()
        _create_logger(options)
    signal.signal(signal.SIGHUP, handle_sighup)


    # Start the main program
    logging.warning("Starting process with id %d. Log level is %s." % (os.getpid(), logging.getLevelName(logging.getLogger().getEffectiveLevel())))
    logging.warning("Process name is '%s'." % PROCNAME)
    logging.debug("Process id: %s, parent process id: %s, process group id: %s, session id: %s, user id: %s, effective user id: %s, real group id: %s, effective group id: %s" % (os.getpid(), os.getppid(), os.getpgrp(), os.getsid(0), os.getuid(), os.geteuid(), os.getgid(), os.getegid()))

    # Set initial timers
    import time
    start_time = time.time()
    previous_time = start_time
    abs_starttime = start_time
    sleeptime = 2.0
    while 1:
        time_now = time.time()
        if (time_now - previous_time) > sleeptime:
            previous_time = time_now
            running_time = time_now - abs_starttime
            logging.warn("Uptime: %s seconds" % str(running_time))
            time.sleep(1)