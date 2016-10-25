# MBR vs GPT

[What’s the Difference Between GPT and MBR When Partitioning a Drive?](http://www.howtogeek.com/193669/whats-the-difference-between-gpt-and-mbr-when-partitioning-a-drive/)

* MBR (Master Boot Record)
* GPT (GUID Partition Table): GPT is associated with [UEFI](./uefi_vs_bios.md).

Storing the partitioning information on a drive includes 
 - where partitions start and begin
 - which partition is bootable

### MBR limitations
* MBR works with disks up to 2 TB in size
* Allowing only 4 boot records. Using [extended boot record](https://en.wikipedia.org/wiki/Extended_boot_record) for more thant 4 partitions.

### GPT’s Advantages
* Every partition has a globally unique identifier(GUID). (a random string so long that every GPT partition on earth likely has its own unique identifier)
* Unlimited amount of partitions
* GPT stores multiple copies of partitioning and boot data across the disk. If the data is correupted. GPT also stores cyclic redundancy check (CRC) values to check that its data is intact.