# NFS

Linux kernel now has NFS support.

## Installation

Ubuntu
```shell
$ sudo apt-get install nfs-kernel-server
```

Enable and start the service
```
$ sudo systemctl enable nfs-kernel-server && sudo systemctl start nfs-kernel-server
```

## Settings

edit `/etc/exports`
```shell
/home       192.168.1.0/24(rw,sync,no_root_squash,no_subtree_check)
```

Adopt Settings
```shell
$ sudo exportfs -a
```

## Mount in clients

```
$ sudo mount 1.2.3.4:/home /mnt/nfs/home
```

Mount in Android using busybox
```
$ busybox mount -t nfs 1.2.3.4:/var/nfs /sdcard/nfs
```
