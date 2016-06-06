# Installing Oracle Java in Fedora

Downloading and installing oracle java from oracle website

```shell
# usage: alternatives --install <link> <name> <path> <priority>
$ sudo alternatives --install /usr/bin/java java /usr/java/jdk1.6.0_45/bin/java 2
$ sudo alternatives --install /usr/bin/javac javac /usr/java/jdk1.6.0_45/bin/javac 2
$ sudo alternatives --config java
$ sudo alternatives --config javac
```
