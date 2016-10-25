# Systemless root

### References

- [What Is “Systemless Root” on Android, and Why Is It Better?](http://www.howtogeek.com/249162/what-is-systemless-root-on-android-and-why-is-it-better/)
- [Verified Boot](https://source.android.com/security/verifiedboot/)
- [dm-verity](https://source.android.com/security/verifiedboot/dm-verity.html)
- [SafetyNet Explained: Why Android Pay and Other Apps Don’t Work on Rooted Devices](http://www.howtogeek.com/241012/safetynet-explained-why-android-pay-and-other-apps-dont-work-on-rooted-devices/)
- [Chainfire Releases Root For Android 6.0 Without Modifying /system](http://www.xda-developers.com/chainfire-releases-root-for-android-6-0-without-modifying-system/)
- [EXPERIMENT: Root without modifying /system](http://forum.xda-developers.com/showpost.php?p=63197935&postcount=2)

```text
Ramdisk modifications
- include (post above this one)
- init.rc (devs: please open file for reference)
--- on init
------ mkdir /su ...
--- on post-fs-data
------ copy image from cache to data (for rooting without access to /data in custom recovery)
------ mount image to /su
--- service daemonsu
- init.environ.rc
--- export PATH, prepended with /su/bin
- file_contexts
--- /su(/.*)? ubject_r:system_file:s0
```

- [Magisk - The Universal Systemless Interface](http://forum.xda-developers.com/android/software/mod-magisk-v1-universal-systemless-t3432382)

