# Variable scope

[What's the scope of a Python variable declared in an if statement?](http://stackoverflow.com/questions/2829528/whats-the-scope-of-a-python-variable-declared-in-an-if-statement)

Python variables are scoped to the innermost function or module; control blocks like if and while blocks don't count. (IIUC, this is also how JavaScript and Ruby var-declared variables work.)