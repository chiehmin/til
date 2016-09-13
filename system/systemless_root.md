# Systemless root

### References

- [What Is “Systemless Root” on Android, and Why Is It Better?](http://www.howtogeek.com/249162/what-is-systemless-root-on-android-and-why-is-it-better/)
- [Verified Boot](https://source.android.com/security/verifiedboot/)
- [dm-verity](https://source.android.com/security/verifiedboot/dm-verity.html)
- [Chainfire Releases Root For Android 6.0 Without Modifying /system](http://www.xda-developers.com/chainfire-releases-root-for-android-6-0-without-modifying-system/)


> i wrote that for simplicity, it's modifying only the system which is no longer an option.
dm-verity will only give you a warning if you modified /system, not stopping you to run it. the most important thing is a stricter selinux policy, which will make the su daemon fail to run.
to make it run, a modification to selinux policy is required. this is made by modifying boot image. disabling dm-verity here is just for convenience to not stare at warning page on every boot.
in the first stage of this experiment, those modifications were made. together with the old way of installing binaries to system.
then came the important question. why would we still use /system if we already modify boot? why disabling a security feature if we could move binaries to someplace else?
this news is the answer.

