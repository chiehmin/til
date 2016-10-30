# Command tricks
## Read keyboard code
Using `cat` command to read keyboard key and print it!
```bash
$ cat
^[         # Esc
^[[1;2C    # shift + left
```

## $?, &&, ||, test, if
[vbird redirect commands](http://linux.vbird.org/linux_basic/0320bash.php#redirect_com)
- `cmd1 && cmd2`:
	1. 若 cmd1 執行完畢且正確執行($?=0)，則開始執行 cmd2。
	2. 若 cmd1 執行完畢且為錯誤 ($?≠0)，則 cmd2 不執行。
- `cmd1 || cmd2`:
	1. 若 cmd1 執行完畢且正確執行($?=0)，則 cmd2 不執行。
	2. 若 cmd1 執行完畢且為錯誤 ($?≠0)，則開始執行 cmd2。

- `test -e /home/fatminmin`:
	set $?=0 if /home/fatminmin exists. equals to `[ test -e /home/fatminmin ]`

```bash
cmd
if [ $? -eq 0 ]; then
	echo 'command success'
fi

# equals to
# cmd will set $?=0 if cmd success

if cmd; then
	echo 'command success'
fi
```
