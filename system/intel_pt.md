# Intel Processor Trace

* [Simple Processor Trace Announced For Broadwell & Skylake CPUs](http://www.phoronix.com/scan.php?page=news_item&px=linux-simple-pt)
Modern Intel Core CPUs (5th and 6th generation) have a Intel Processor Trace (PT) feature to trace branch execution with low overhead.

* [Processor Tracing](https://blogs.intel.com/blog/processor-tracing/)
Debuggers can use it to reconstruct the code flow that led to the current location.  Whether this is a crash site, a breakpoint, a watchpoint, or simply the instruction following a function call we just stepped over.  They may even allow navigating in the recorded execution history via reverse stepping commands.

>FatMinMin Note: normal frame unwinding usually fails or may not produce reliable results because old ebp may be corrupted

Another important use case is debugging stack corruptions.  When the call stack has been corrupted, normal frame unwinding usually fails or may not produce reliable results.  Intel PT can be used to reconstruct the stack back trace based on actual CALL and RET instructions.

Intel PT can also help to narrow down data races in multi-threaded operating system and user program code. It can log the execution of all threads with a rough time indication.  While it is not precise enough to detect data races automatically, it can give enough information to aid in the analysis.
