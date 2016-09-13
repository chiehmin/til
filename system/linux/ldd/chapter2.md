# Chapter 2: Building and Running Modules

Hello world module.
```c
#include <linux/init.h>
#include <linux/module.h>
MODULE_LICENSE("Dual BSD/GPL");

static int hello_init(void)
{
  printk(KERN_ALERT "Hello, world\n");
  return 0;
}

static void hello_exit(void)
{
  printk(KERN_ALERT "Goodbye, cruel world\n");
}

module_init(hello_init);
module_exit(hello_exit);
```

Commands
`insmod`, `rmmod`, `lsmod`, `modprobe`
`lsmod` works by reading the `/proc/modules` virtual file. Currently loaded modules can also be found in the sysfs virtual filesystem under `/sys/module`

## Mechanism vs Policy
* Mechanism: what capabilities are to be provided (kernel driver)
* Policy: how those capabilities can be used (userspace program)

## Splitting the kernel
Process management
Memory management
Filesystems
Device control
Networking

## Building and Compiling
Makefile just need one line
```
obj-m := module.o
```
Then invoke the make command
```
$ make -C /path/to/kernel/source M=`module path` modules
```
-C dir, --directory=dir
Change to directory dir before reading the makefiles or doing anything else.

Wildcard makefile
```makefile
obj-m       += hello.o
KVERSION := $(shell uname -r)
all:
    $(MAKE) -C /lib/modules/$(KVERSION)/build M=$(PWD) modules

clean:
    $(MAKE) -C /lib/modules/$(KVERSION)/build M=$(PWD) clean
```

## Concurrency in Kernel
Linux kernel code, including driver code, must be reentrant: it must be capable of running in more than one context at the same time

## The Current Process
Kernel code can refer to the current process by accessing the global item `current`, defined in `<asm/current.h>`, which yields a pointer to `struct task_struct`, defined by `<linux/sched.h>`.
```c
printk(KERN_INFO "The process is \"%s\" (pid %i)\n", current->comm, current->pid);
```

## Module stacking
When a module is loaded, any symbol exported by the module becomes part of the kernel symbol table.
```
EXPORT_SYMBOL(name);
EXPORT_SYMBOL_GPL(name);
```

`msdos` module relies on fat module.
`modprobe` automatically loads all necessary modules

## Module parameters

```c
static char *whom = "world";
static int howmany = 1;
module_param(howmany, int, S_IRUGO);
module_param(whom, charp, S_IRUGO);
```
```shell
insmod hellop howmany=10 whom="Mom"
```
