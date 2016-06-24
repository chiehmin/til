# `cin.tie()` and `cout.tie()`

[Significance of ios_base::sync_with_stdio(false); cin.tie(NULL);](http://stackoverflow.com/questions/31162367/significance-of-ios-basesync-with-stdiofalse-cin-tienull)
[so discussion](http://stackoverflow.com/questions/14052627/why-do-we-need-to-tie-cin-and-cout)
[cin.tie与sync_with_stdio加速输入输出](http://www.hankcs.com/program/cpp/cin-tie-with-sync_with_stdio-acceleration-input-and-output.html)

```cpp
ios_base::sync_with_stdio(false);
```

This disables the synchronization between the C and C++ standard streams. By default all standard streams are synchronized, which in practice allows you to mix C and C++ style I/O and get sensible and expected results. If you disable the synchronization then C++ streams are allowed to have their own independent buffers, which makes mixing C and C++ style I/O an adventure.

```cpp
cin.tie(NULL);
```
This unties cin from cout. Tied streams ensure that one stream is flushed automatically before each I/O operation on the other stream.

