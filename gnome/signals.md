## Signals

[docs](https://developer.gnome.org/gobject/stable/signal.html)

## GClosure

[docs](https://developer.gnome.org/gobject/stable/gobject-Closures.html)

A GClosure represents a callback supplied by the programmer. It will generally comprise a function of some kind and a marshaller used to call it. It is the responsibility of the marshaller to convert the arguments for the invocation from GValues into a suitable form, perform the callback on the converted arguments, and transform the return value back into a GValue.

In the case of C programs, a closure usually just holds a pointer to a function and maybe a data argument, and the marshaller converts between GValue and native C types. 