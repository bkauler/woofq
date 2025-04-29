/*
This is a simple program to truncate a file. It can also increase a file.
Usage: # truncate size-in-bytes filename
Returns 0 if success.
This program is used by the PETget package manager in Puppy Linux.

The code is below. Rename this file to truncate.c and compile like this:
# gcc -o truncate truncate.c
*/

/*written by Barry K 2006 for Puppy Linux*/
#define _FILE_OFFSET_BITS 64
#include <unistd.h>
#include <sys/types.h>
#include <errno.h>
#include <stdlib.h>

main(int argc,char* argv[]) {
  off_t mynewsize;
  
  mynewsize=atol(argv[1]);
  
  /* 1st param is size, 2nd is filename...*/
  truncate(argv[2],mynewsize);
  
  return errno;
  
}
