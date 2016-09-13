# Chapter 3: Char Drivers

## Scull driver
scull (Simple Character Utility for Loading Localities). scull is a char driver that acts on a memory area as though it were a device.

##### scull0 to scull3
Four devices, each consisting of a memory area that is both global and persistent.
* Global: if the device is opened multiple times, the data contained within the device is shared by all the file descriptors that opened it.
* Persistent: if the device is closed and reopened, data isn't lost.

##### scullpipe0 to scullpipe3
Four FIFO devices, which act like pipes. One process reads what another process writes.

## Major and Minor Numbers

Char devices are accessed through names in the filesystem. Special files for char drivers are identified by a "c" in the first column of the output of `ls -l`. Block devices are identified by a "b".

In `ls -l` output, you'll see two numbers in the device file entries before the date of the last modification. These numbers are the major and minor device number for the device.

```
brw-rw----.  1 root      disk    253,   0 Apr  7 13:35 dm-0
crw-rw----.  1 root      video    29,   0 Apr  7 13:35 fb0
crw-rw----.  1 root      lp        6,   3 Apr  7 13:34 lp3
crw--w----.  1 root      tty       4,   7 Apr  7 13:35 tty7
crw--w----.  1 root      tty       4,   8 Apr  7 13:35 tty8
crw--w----.  1 root      tty       4,   9 Apr  7 13:35 tty9
```

Traditionally, the major number identifies the driver associated with the device. The minor number is used by the kernel to determined exactly which device is being referred to.

## Allocating and Freeing Device Numbers
Header file: `<linux/fs.h>`

```
int register_chrdev_region(dev_t first, unsigned int count, char *name);
```

`first` is the beginning device number of the range you would like to allocate. minor number portion `first` is often 0. `count` is the total number of contiguous device numbers you are requesting. If `count` is large, the range could spill over to the next major number. `name` is the name of the device that should be associated with this number range; it will appear in /proc/devices and sysfs.

#### Dynamic allocation for major number
```
int alloc_chrdev_region(dev_t *dev, unsigned int firstminor, unsigned count, char *name);
```

`dev` is an output-only parameter.

#### Freeing device numbers
```
void unregister_chrdev_region(dev_t first, unsigned int count);
```

#### Creating /dev special files (mknod)

[skull_load](https://github.com/martinezjavier/ldd3/blob/master/scull/scull_load)

## File Operation(`struct file_operations`)
Defined in `<linux/fs.h>`

```c
struct file_operations scull_fops = {
	.owner =    THIS_MODULE,
	.llseek =   scull_llseek,
	.read =     scull_read,
	.write =    scull_write,
	.unlocked_ioctl = scull_ioctl,
	.open =     scull_open,
	.release =  scull_release,
};
```

## The file Structure(`struct file`)
The `file` structure represents an open file(represents an open file descriptor). Defined in `<linux/fs.h>`.

* `mode_t f_mode`
* `loff_t f_pos`
* `unsigned int f_flags`
* `struct file_operations *f_op`: The operations associated with the file. code for `open` associated with major number 1 ()/dev/null, /dev/zero, and so on) substitutes the operations in `filp->f_op` depending on the minor number being opened. This allows the implementation of several behaviors under the same major number.
* `void *private_data`
* `struct dentry *f_dentry`

## The inode Structure(`struct inode`)
Used to represent files. There can be numerous `file` structures representing multiple open descriptors on a single file, but they all point to a single `inode` structure.

## Char Device Registration

```c
struct cdev *my_cdev = cdev_alloc();
my_cdev->ops = &my_fops;
```
or
```c
void cdev_init(struct cdev *cdev, struct file_operations *fops);
```

Add to kernel

```c
int cdev_add(struct cdev *dev, dev_t num, unsigned int count);
```
```c
struct scull_dev {
	struct scull_qset *data;  /* Pointer to first quantum set */
	int quantum;              /* the current quantum size */
	int qset;                 /* the current array size */
	unsigned long size;       /* amount of data stored here */
	unsigned int access_key;  /* used by sculluid and scullpriv */
	struct semaphore sem;     /* mutual exclusion semaphore     */
	struct cdev cdev;	  /* Char device structure		*/
};
static void scull_setup_cdev(struct scull_dev *dev, int index)
{
	int err, devno = MKDEV(scull_major, scull_minor + index);

	cdev_init(&dev->cdev, &scull_fops);
	dev->cdev.owner = THIS_MODULE;
	dev->cdev.ops = &scull_fops;
	err = cdev_add (&dev->cdev, devno, 1);
	/* Fail gracefully if need be */
	if (err)
		printk(KERN_NOTICE "Error %d adding scull%d", err, index);
}
```

## fops
### Open
```c
#include <linux/kernel.h>
container_of(pointer, container_type, container_field);
```
`container_of` takes a `pointer` to a field named container_field, within a structure of type container_type, and returns a pointer to the containing structure.

```c
struct scull_dev *dev;
dev = container_of(inode->i_cdev, struct scull_dev, cdev);
filp->private_date = dev;
```
