# Git format-patch

[docs](https://git-scm.com/docs/git-format-patch)

### Generating patches
```shell
$ git format-patch -<num>
# num: the latest [num] commits you want to generate

$ git format-patch -1 <commit>
# format only <commit> itself
```

### Applying format-patch
```shell
$ git am [patch_name]
```