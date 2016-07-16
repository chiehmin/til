# Variable scope

[What's the scope of a Python variable declared in an if statement?](http://stackoverflow.com/questions/2829528/whats-the-scope-of-a-python-variable-declared-in-an-if-statement)

Python variables are scoped to the innermost function or module; control blocks like if and while blocks don't count. (IIUC, this is also how JavaScript and Ruby var-declared variables work.)

[Python variable scope in if-statements](http://stackoverflow.com/questions/7382638/python-variable-scope-in-if-statements)

`if` statements don't define a scope in Python. Neither do loops, `with` statements, `try` / `except`, etc. Only modules, functions and classes define scopes. See Python Scopes and Namespaces in the Python Tutorial.