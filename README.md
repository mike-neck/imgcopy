imgcopy
===

A utility tools for copying data between image files and memory.

- `imgcopy`: Copies a specified image file to the clipboard.
- `imgfile`: Writes an image in the clipboard to a specified file.

System requirements
---

- macOS 14.2.1 or later
- Xcode 15.2 or later
- Swift 5.9.0 or later

Install
---

These tools are not distributed, so you need to build them and copy them into a directory on your PATH to use them.

Build
---

You can build them by running the following commands:

```shell
git clone https://github.com/mike-neck/imgcopy.git
cd imgcopy
make build
make pick
```

After running these commands, the following two binaries are created:

```text
build/bin/imgfile
build/bin/imgcopy
```

You can then copy these into a directory on your PATH to use them.

Usage
---

### `imgcopy`

This command copies an image file to the clipboard.

```shell
imgcopy /path/to/img.png
```

### `imgfile`

This command saves an image in the clipboard to a file.

```shell
imgfile /path/to/new-image.png
```

