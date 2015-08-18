/*
 *****************************************
 * FILE: sandbox.c                       *
 * AUTOR: Hector Jose Flores Colmenarez  *
 * EMAIL: hecto932@gmail.com             *           
 *****************************************
*/

// LINKS
// =====
// http://refspecs.linuxbase.org/LSB_3.1.1/LSB-Core-generic/LSB-Core-generic/baselib---libc-start-main-.html
// http://gribblelab.org/CBootcamp/7_Memory_Stack_vs_Heap.html
// http://stackoverflow.com/questions/7259830/why-and-when-to-use-static-structures-in-c-programming
// http://justanothergeek.chdir.org//2010/02/how-system-calls-work-on-recent-linux/ 
// http://www.tutorialspoint.com/c_standard_library/c_function_atexit.htm
// http://refspecs.linuxbase.org/LSB_2.1.0/LSB-generic/LSB-generic/baselib---cxa-atexit.html
// http://stackoverflow.com/questions/12851184/dlopen-failed-cannot-open-shared-object-file-no-such-file-or-directory

// LIBRARIES
// =========
#include <unistd.h>
#include <fcntl.h>
#include <dlfcn.h>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <errno.h>
#include <sys/prctl.h>
#include <sys/syscall.h>
#include <sys/mman.h>

// DEFAULT HEAP SIZE IS 8MB(Bytes)
#define DEFAULT_HEAP_SIZE 8388608

#define DLOPEN_FAILED 	120
#define SECCOMP_FAILED 	121
#define EXIT_FAILED 	122 // SHOULD NOT HAPPEN! 
#define MMAP_FAILED 	123

