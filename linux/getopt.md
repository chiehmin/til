# The GNU C Library: Getopt

* [The GNU C Library](https://www.gnu.org/software/libc/manual/html_node/Getopt.html)
* [getopt manpage](http://man7.org/linux/man-pages/man3/getopt.3.html)
* [C語言 getopt用法](http://carl830.pixnet.net/blog/post/50806433-c%E8%AA%9E%E8%A8%80-getopt%E7%94%A8%E6%B3%95-)

```c
#include <unistd.h>

int getopt(int argc, char * const argv[], const char *optstring);
/*
argc: argc from main
argv: argv from main
optstring: available options 
  ex1: optstring = "abf". -a, -b, -f and -abf are acceptable.
  ex2: optstring = "f:". ":" indicates there will be optarg after -f (-f filename)
*/
extern char *optarg;
extern int optind, opterr, optopt;
/*
result will be put into optarg.
 ex: ./a.out -f test.txt. => optarg = "test.txt"
*/
```

```c
while((c=getopt(argc, argv, "abf:")) != -1)
{
    switch(c)
    {
        case 'a':
        break;
        case 'b':
        break;
        case 'f':
        puts(optarg);
        break;
        case ':':
        puts("oops");
        break;
        case '?'
        puts("wrong command");
        break;
    }
}
```