# Init to Systemd

### References
- [The Story Behind ‘init’ and ‘systemd’: Why ‘init’ Needed to be Replaced with ‘systemd’ in Linux](http://www.tecmint.com/systemd-replaces-init-in-linux/)
- [第十七章、認識系統服務 (daemons)](http://linux.vbird.org/linux_basic/0560daemons.php)
- [19.1.3 第一支程式 systemd 及使用 default.target 進入開機程序分析](http://linux.vbird.org/linux_basic/0510osloader.php#startup_init)

### Init and its alternatives
The init is a daemon process which starts as soon as the computer starts and continue running till, it is shutdown. In-fact init is the first process that starts when a computer boots, making it the parent of all other running processes directly or indirectly and hence typically it is assigned “pid=1“. If somehow init daemon could not start, no process will be started and the system will reach a stage called “Kernel Panic“. init is most commonly referred to as System V init. System V is the first commercial UNIX Operating System designed and usages of init on most of the Linux Distribution of today is identical with System V OS with a few exception like Slackware using BSD-style and Gentoo using custom init.

- Upstart – A init replacement daemon implemented in Ubuntu GNU/Linux and designed to start process asynchronously.
- Epoch – A init replacement daemon built around simplicity and service management, designed to start process single-threaded.
- Mudar – A init replacement daemon written in Python, implemented on Pardus GNU/Linux and designed to start process asynchronously.
- systemd – A init replacement daemon designed to start process in parallel, implemented in a number of standard distribution – Fedora, OpenSuSE, Arch, RHEL, CentOS, etc.

### System V init intro

Daemon control scripts are located at `/etc/init.d/`. Controlling daemons using `/etc/init.d/daemon [start|stop|restart|status]`.

- stand alone daemon: resideds in memory directly.
- super daemon: manage other daemons. (ex: xinted, inetd)

7 [runlevels](https://en.wikipedia.org/wiki/Runlevel) for startup: 0, 1, 2, 3, 4, 5, 6. (1 => Single-user mode, 3 => Multi-user mode with networking, 5 => Same as runlevel 3 + display manager). Soft links from `/etc/init.d/daemon` to `/etc/rc.d/rc[0-6]/SXXdaemon`. (S => start, XX => order for startup. ex: S00 will be started before S10.)   

### systemd

#### Advantages against init
- Parallelly starting up indenpendent daemons.
- Daemon dependencies self-check.
- Classifying daemons by their feature.
- Grouping daemons into targets. (Analogous to runlevels)
- Compatiable with init scripts

#### Configurations
- `/usr/lib/systemd/system/`: The directory for control scripts. (Analogous to `/etc/init.d `)
- `/etc/systemd/system/` (Analogous to `/etc/rc.d/rcY.d/Sxx`)

#### System V runlevel to systemd target mapping

```bash
[root@study ~]# ll -d /usr/lib/systemd/system/runlevel*.target | cut -c 28-
May  4 17:52 /usr/lib/systemd/system/runlevel0.target -> poweroff.target
May  4 17:52 /usr/lib/systemd/system/runlevel1.target -> rescue.target
May  4 17:52 /usr/lib/systemd/system/runlevel2.target -> multi-user.target
May  4 17:52 /usr/lib/systemd/system/runlevel3.target -> multi-user.target
May  4 17:52 /usr/lib/systemd/system/runlevel4.target -> multi-user.target
May  4 17:52 /usr/lib/systemd/system/runlevel5.target -> graphical.target
May  4 17:52 /usr/lib/systemd/system/runlevel6.target -> reboot.target
```

| System V    |  systemd                              |  
|-------------|---------------------------------------|
| init 0      |  systemctl poweroff                   |
| init 1      |  systemctl rescue                     |
| init [234]  |  systemctl isolate multi-user.target  |
| init 5      |  systemctl isolate graphical.target   |
| init 6      |  systemctl reboot                     |

#### Recovering root password in rescue mode
[redhat tutorial](https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/7/html/System_Administrators_Guide/sec-Terminal_Menu_Editing_During_Boot.html#sec-Recovering_Root_Password)

Pressing `e` on the boot entry. Adding `systemd.unit=rescue.target` to kernel line.