# Breakpoint and Watchpoint

## Hardware breakpoint vs Software breakpoint
[Debugger flow control: Hardware breakpoints vs software breakpoints](http://www.nynaeve.net/?p=80)
Software breakpoints may only be targetted at code; there is no support for setting a “memory breakpoint” via a software breakpoint. Unlike software breakpoints, you may use hardware breakpoints to set “memory breakpoints”, or a breakpoint that is fired when any instruction attempts to read, write, or execute (depending on how you configure the breakpoint) a specific address.

Hardware breakpoints have some limitations, however; the main limit being that the number of hardware breakpoints that you may have active is extremely limited (on x86, you may only have four hardware breakpoints active at the same time).

The way software breakpoints work is fairly simple. Speaking about x86 specifically, to set a software breakpoint, the debugger simply writes an int 3 instruction (opcode 0xCC) over the first byte of the target instruction. This causes an interrupt 3 to be fired whenever execution is transferred to the address you set a breakpoint on. When this happens, the debugger “breaks in” and swaps the 0xCC opcode byte with the original first byte of the instruction when you set the breakpoint, so that you can continue execution without hitting the same breakpoint immediately.

Hardware breakpoints are, as you might imagine given the name, set with special hardware support. In particular, for x86, this involves a special set of perhaps little-known registers know as the “Dr” registers (for debug register). These registers allow you to set up to four (for x86, this is highly platform specific) addresses that, when either read, read/written, or executed, will cause the processor to throw a special exception that causes execution to stop and control to be transferred to the debugger.

(Hadware breakpoints can act as watchpoint)
Well, the main strength of hardware breakpoints is that you can use them to halt on non-execution accesses to memory locations. This is actually an extremely useful capability; for example, if you were debugging a memory corruption problem where an initial instance of corruption eventually causes a crash, your initial reaction would probably be something on the lines of “gee, if I know who caused the corruption in the first place, this would be much, much easier to debug” – and this is exactly what hardware breakpoints let you do. In essence, you can use a hardware breakpoint to tell the processor to stop when a specific variable (address) is read or read/written to. You can also use hardware breakpoints to break in on code execution as well, although in the typical case, it is more common to use software breakpoints for that purpose due to the relaxed restrictions on how many breakpoints you may have active at once.

[GDB docs](http://ftp.gnu.org/old-gnu/Manuals/gdb/html_node/gdb_29.html)
Depending on your system, watchpoints may be implemented in software or hardware. GDB does software watchpointing by single-stepping your program and testing the variable's value each time, which is hundreds of times slower than normal execution. (But this may still be worth it, to catch errors where you have no clue what part of your program is the culprit.)

GDB sets a hardware watchpoint if possible. Hardware watchpoints execute very quickly, and the debugger reports a change in value at the exact instruction where the change occurs. If GDB cannot set a hardware watchpoint, it sets a software watchpoint, which executes more slowly and reports the change in value at the next statement, not the instruction, after the change occurs.

## How does watchpoint work?
The following stackoverflow answer is not correct but that could be a valid implementation.

[so discussion](http://stackoverflow.com/questions/7805782/hardware-watch-points)
I believe gdb uses the MMU so that the memory pages containing watched address ranges are marked as protected - then when an exception occurs for a write to a protected pages gdb handles the exception, checks to see whether the address of the write corresponds to a particular watchpoint, and then either resumes or drops to the gdb command prompt accordingly.

You can implement something similar for your own debugging code or test harness using mprotect, although you'll need to implement an exception handler if you want to do anything more sophisticated than just fail on a bad write.

The MMU (Memory Management Unit) is hardware - by marking a page as protected you can get an exception on a write to that page - this is how hardware-assisted watchpoints work. Without the MMU you'd have to pause after every instruction and examine all watchpoint address ranges - this is how software watchpoints typically work on systems without MMUs (e.g. small embedded systems) and it's very slow.
