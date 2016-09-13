# xargs

[Linux 系統 xargs 指令範例與教學](https://blog.gtwang.org/linux/xargs-command-examples-in-linux-unix/)

Parse from stdin and pass it as arguments of command.

```bash
$ echo a b c d e f | xargs cat
# equals to 
$ cat a b c d e f

# -n [max-args]: Use at most max-args arguments per command line.
$ echo a b c d e f | xargs -n 3 cat
# equals to 
$ cat a b c
$ cat d e f

# -t, --verbose: Print the command line on the standard error output before executing it.

# Useful examples
# delete all .c files under current directory and sub-directories
$ find . -name "*.c" | xargs rm -f

# search which .c file include stdlib.h
$ find . -name '*.c' | xargs grep 'stdlib.h'
```